using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data.Common;
using System.Data.Entity;
using System.Data.Entity.Core.Mapping;
using System.Data.Entity.Core.Metadata.Edm;
using System.Data.Entity.Infrastructure;
using System.Data.Entity.Infrastructure.Interception;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using DatabaseFTS;
using Devlev.EntityFramework.Fts;

namespace ExampleFTS
{
    class Program
    {
        public const string FullTextContainsTable = "-FTSFULLTEXTTABLE-";

        public static string Tests = @"
SELECT
    [Extent1].[Id] AS [Id],
    [Extent2].[Key] AS [Key],
    [Extent2].[Rank] AS [Rank]
    FROM  [dbo].[TC_Comment] AS [Extent1]
    INNER JOIN [dbo].[TC_FTS_Int] AS [Extent2] ON [Extent1].[Id] = [Extent2].[Key]
    WHERE [Extent2].[Query] LIKE @p__linq__0 ESCAPE N'~'
";

        static void Main(string[] args)
        {
            using (BlogEntities db = new BlogEntities())
            {
                FtsSearch.Log = value => Console.WriteLine(value);

                {
                    string queryText = FtsSearch.Query(
                        dbContext: db,
                        ftsEnum: FtsEnum.CONTAINS,
                        tableQuery: typeof(Article),
                        tableFts: typeof(FTS_Int),
                        search: "text");

                    var queryFts = db.FTS_Int.Where(n => n.Query.Contains(queryText));

                    var query = db.Article
                        .Where(n => n.Active)
                        .Join(queryFts, article => article.Id, fts => fts.Key, (article, fts) => new
                        {
                            article,
                            fts.Rank,
                        })
                        .OrderByDescending(n => n.Rank)
                        .Take(10)
                        .Select(n => n.article);

                    Console.WriteLine(query.ToString());

                    var result = FtsSearch.Execute(() => query.ToList());
                }

                {
                    string queryNewsText = FtsSearch.Query(
                        dbContext: db,
                        ftsEnum: FtsEnum.CONTAINS,
                        tableQuery: typeof(News),
                        tableFts: typeof(FTS_Int),
                        search: "Новое AND исследование");

                    var queryNewsSearch = db.FTS_Int.Where(n => n.Query.Contains(queryNewsText));
                    var query = db.News
                        .Join(queryNewsSearch, news => news.Id, fts => fts.Key, (news, fts) => new
                        {
                            news.Id,
                            news.Text,
                            RubricId = news.Rubric.Id,
                            fts.Key,
                            fts.Rank,
                        })
                        .OrderByDescending(n => n.Rank)
                        .Take(5);

                    Console.WriteLine(query.ToString());

                    var result = FtsSearch.Execute(() => query.ToList());

                    //var result = await FtsSearch.ExecuteAsync(async () => await query.ToListAsync());

                    foreach (var item in result)
                    {
                        var elem = item;
                        Console.WriteLine(elem.Id + " " + (elem.Text.Length > 20 ? elem.Text.Substring(0, 20) : elem.Text).Replace('\r', ' ').Replace('\n', ' '));
                    }

                    Console.ReadKey();
                }
            }
        }
    }
}

