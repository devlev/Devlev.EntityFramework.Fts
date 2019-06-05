using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Data.Entity;
using System.Data.Entity.Infrastructure.Interception;
using System.Text.RegularExpressions;

namespace Devlev.EntityFramework.Fts
{
	public class FtsExtension : IDbCommandInterceptor
	{

        private Regex _regexReplace = new Regex(@"%\(-FTSFULLTEXTTABLE-(CONTAINS|FREETEXT)-\;(.+?)\;(.+?)\;(.+?)\;(.+?)\)%");

		private static string GetTableNameForRegex(string value)
		{
			return value.Replace("[", "\\[").Replace("]", "\\]").Replace(".", "\\.");
		}

		public void NonQueryExecuted(DbCommand command, DbCommandInterceptionContext<int> interceptionContext)
		{

		}

		public void NonQueryExecuting(DbCommand command, DbCommandInterceptionContext<int> interceptionContext)
		{

		}

		public void ReaderExecuted(DbCommand command, DbCommandInterceptionContext<DbDataReader> interceptionContext)
		{

		}

		public void ReaderExecuting(DbCommand command, DbCommandInterceptionContext<DbDataReader> interceptionContext)
		{
			RewriteFullTextQuery(command, interceptionContext.DbContexts);
		}

		public void ScalarExecuted(DbCommand command, DbCommandInterceptionContext<object> interceptionContext)
		{

		}

		public void ScalarExecuting(DbCommand command, DbCommandInterceptionContext<object> interceptionContext)
		{
			RewriteFullTextQuery(command, interceptionContext.DbContexts);
		}

		private void RewriteFullTextQuery(DbCommand command, IEnumerable<DbContext> dbContexts)
		{
			string CommandText = command.CommandText;

			foreach (DbParameter param in command.Parameters)
			{
				if (param.DbType != System.Data.DbType.String)
					continue;

				string value = param.Value.ToString().Replace("~_", "_").Replace("~[", "[");

				// Example: "%(-FTSFULLTEXTTABLE-FREETEXT-,[dbo].[TC_Comment],[dbo].[TC_FTS_Int],123123)%"
				Match matchReplace = _regexReplace.Match(value);
				if (!matchReplace.Success)
					continue;

				string searchType = matchReplace.Groups[1].Value;
				string tableQueryName = matchReplace.Groups[2].Value;
				string fieldNames = matchReplace.Groups[3].Value;
				string tableFtsName = matchReplace.Groups[4].Value;
				string searchText = matchReplace.Groups[5].Value;

				if (!(!string.IsNullOrEmpty(tableQueryName) && !string.IsNullOrEmpty(tableFtsName)))
					continue;

				string commandTextBifore = CommandText;

				string pattern = string.Format(@"{0} AS (\[[a-z][a-z0-9_]+\])", GetTableNameForRegex(tableFtsName));
				Match match = Regex.Match(commandTextBifore, pattern, RegexOptions.IgnoreCase);
				if (!match.Success)
					continue;

				string containstable = string.Format("{0}TABLE({1},({2}),'{3}')", searchType, tableQueryName, fieldNames, searchText);
				if (!commandTextBifore.Contains(tableFtsName))
					continue;

				string replace = commandTextBifore.Replace(tableFtsName, containstable);
				string extend = match.Groups[1].Value;
				string where = string.Format(@"(\[[a-z][a-z0-9_]+\])\.(\[[a-z][a-z0-9_]+\]) LIKE \@{0} ESCAPE N\'\~\'", param.ParameterName);

				Match matchLike = Regex.Match(replace, where, RegexOptions.IgnoreCase | RegexOptions.Multiline);
				if (!matchLike.Success)
					continue;

				string replaceWhere = Regex.Replace(replace, where, "1=1", RegexOptions.IgnoreCase | RegexOptions.Multiline);
				string replaceQuery = string.Format("{0}.{1}", extend, matchLike.Groups[2].Value);
				replaceWhere = replaceWhere.Replace(replaceQuery, "''");
				CommandText = replaceWhere;
			}

            if (CommandText != command.CommandText)
            {
                FtsSearch.Log?.Invoke(CommandText);

                command.CommandText = CommandText;
            }
		}
	}
}
