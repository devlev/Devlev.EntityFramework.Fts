using System;
using System.Collections;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Entity.Core.Mapping;
using System.Data.Entity.Core.Metadata.Edm;
using System.Data.Entity.Infrastructure;
using System.Data.Entity.Infrastructure.Interception;
using System.Linq;
using System.Threading.Tasks;

namespace Devlev.EntityFramework.Fts
{
	public class FtsSearch
	{
        public static Action<string> Log { get; set; }

        private static FtsExtension ftsExtension = new FtsExtension();
		private static int _CountDbInterception = 0;
		private static string GetTableName(Type type, DbContext context)
		{
			MetadataWorkspace metadata = ((IObjectContextAdapter)context).ObjectContext.MetadataWorkspace;

			// Get the part of the model that contains info about the actual CLR types
			ObjectItemCollection objectItemCollection = (ObjectItemCollection)metadata.GetItemCollection(DataSpace.OSpace);

			// Get the entity type from the model that maps to the CLR type
			EntityType entityType = metadata
				.GetItems<EntityType>(DataSpace.OSpace)
				.FirstOrDefault(e => objectItemCollection.GetClrType(e) == type);

			if (entityType == null)
			{
				return null;
			}

			// Get the entity set that uses this entity type
			EntitySet entitySet = metadata
				.GetItems<EntityContainer>(DataSpace.CSpace)
				.Single()
				.EntitySets
				.FirstOrDefault(s => s.ElementType.Name == entityType.Name);

			if (entitySet == null)
			{
				return null;
			}

			// Find the mapping between conceptual and storage model for this entity set
			EntitySetMapping mapping = metadata.GetItems<EntityContainerMapping>(DataSpace.CSSpace)
				.Single()
				.EntitySetMappings
				.Single(s => s.EntitySet == entitySet);

			if (mapping == null)
			{
				return null;
			}

			// Find the storage entity set (table) that the entity is mapped
			EntitySet table = mapping
				.EntityTypeMappings.Single()
				.Fragments.Single()
				.StoreEntitySet;

			// Return the table name from the storage entity set
			return string.Format("[{0}].[{1}]", table.Schema, (string)table.MetadataProperties["Table"].Value ?? table.Name);
		}
		private static string GetFieldsName(IEnumerable<string> fields)
		{
			if (fields == null || fields.Count() == 0)
				return "*";

			return string.Join(",", fields);
		}

		private static void AttacheInterception()
		{
			if (_CountDbInterception == 0)
			{
				DbInterception.Add(ftsExtension);
			}
			_CountDbInterception++;
		}
		private static void DeAttacheInterception()
		{
			_CountDbInterception--;
			if (_CountDbInterception == 0)
			{
				DbInterception.Remove(ftsExtension);
			}
		}

		public static string Query(DbContext dbContext, FtsEnum ftsEnum, Type tableQuery, Type tableFts, string search, IEnumerable<string> fields = null)
		{
			return string.Format(
				"(-{0}-{1}-;{2};{3};{4};{5})",
				FtsReplace.FullTextSearch,
				ftsEnum.ToString(),
				GetTableName(tableQuery, dbContext),
				GetFieldsName(fields),
				GetTableName(tableFts, dbContext),
				search
			);
		}

		public static async Task<T> ExecuteAsync<T>(Func<Task<T>> func)
		{
			Exception eresult = null;
			T result = default(T);
			try
			{
				AttacheInterception();
				result = await func.Invoke();
			}
			catch (Exception e)
			{
				eresult = e;
			}
			finally
			{
				DeAttacheInterception();
				if (eresult != null)
				{
					throw new Exception("fts error", eresult);
				}
			}

			return result;
		}
		public static T Execute<T>(Func<T> action)
		{
			Exception eresult = null;
			T result = default(T);
			try
			{
				AttacheInterception();
				result = action.Invoke();
			}
			catch (Exception e)
			{
				eresult = e;
			}
			finally
			{
				DeAttacheInterception();
			}
			return result;
		}
	}
}
