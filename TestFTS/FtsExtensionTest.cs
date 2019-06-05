using DatabaseFTS;
using Devlev.EntityFramework.Fts;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xunit;

namespace TestFTS
{
    public class FtsExtensionTest
    {
        private IQueryable<Article> _GetQuery(BlogEntities db)
        {
            string queryText = FtsSearch.Query(
                dbContext: db,
                ftsEnum: FtsEnum.CONTAINS,
                tableQuery: typeof(Article),
                tableFts: typeof(FTS_Int),
                search: "text");

            var queryFts = db.FTS_Int.Where(n => n.Query.Contains(queryText));

            return db.Article
                .Where(n => n.Active)
                .Join(queryFts, article => article.Id, fts => fts.Key, (article, fts) => new
                {
                    article,
                    fts.Rank,
                })
                .OrderByDescending(n => n.Rank)
                .Take(10)
                .Select(n => n.article);
        }

        [Fact]
        public void Query_Default()
        {
            using (BlogEntities db = new BlogEntities())
            {
                string queryResult = _GetQuery(db).ToString();

                Assert.Equal(@"SELECT TOP (10) 
    [Project1].[Id] AS [Id], 
    [Project1].[Date] AS [Date], 
    [Project1].[Text] AS [Text], 
    [Project1].[Active] AS [Active]
    FROM ( SELECT 
        [Extent1].[Id] AS [Id], 
        [Extent1].[Date] AS [Date], 
        [Extent1].[Text] AS [Text], 
        [Extent1].[Active] AS [Active], 
        [Extent2].[Rank] AS [Rank]
        FROM  [dbo].[Article] AS [Extent1]
        INNER JOIN [dbo].[FTS_Int] AS [Extent2] ON [Extent1].[Id] = [Extent2].[Key]
        WHERE ([Extent1].[Active] = 1) AND ([Extent2].[Query] LIKE @p__linq__0 ESCAPE N'~')
    )  AS [Project1]
    ORDER BY [Project1].[Rank] DESC", queryResult);
            }
        }

        [Fact]
        public void Query_Replace()
        {
            using (BlogEntities db = new BlogEntities())
            {
                string queryResult = "";

                FtsSearch.Log = value => queryResult = value;

                List<Article> result = FtsSearch.Execute(() => _GetQuery(db).ToList());

                Assert.Equal(@"SELECT TOP (10) 
    [Project1].[Id] AS [Id], 
    [Project1].[Date] AS [Date], 
    [Project1].[Text] AS [Text], 
    [Project1].[Active] AS [Active]
    FROM ( SELECT 
        [Extent1].[Id] AS [Id], 
        [Extent1].[Date] AS [Date], 
        [Extent1].[Text] AS [Text], 
        [Extent1].[Active] AS [Active], 
        [Extent2].[Rank] AS [Rank]
        FROM  [dbo].[Article] AS [Extent1]
        INNER JOIN CONTAINSTABLE([dbo].[Article],(*),'text') AS [Extent2] ON [Extent1].[Id] = [Extent2].[Key]
        WHERE ([Extent1].[Active] = 1) AND (1=1)
    )  AS [Project1]
    ORDER BY [Project1].[Rank] DESC", queryResult);
            }
        }

        [Fact]
        public void Query_Execute()
        {
            using (BlogEntities db = new BlogEntities())
            {
                List<Article> result = FtsSearch.Execute(() => _GetQuery(db).ToList());

                Assert.Single(result);
            }
        }

        [Fact]
        public void Query_ExecuteAsync()
        {
            using (BlogEntities db = new BlogEntities())
            {
                Task.Run(async () =>
                {
                    List<Article> result = await FtsSearch.ExecuteAsync(async () => await _GetQuery(db).ToListAsync());

                    Assert.Single(result);
                }).Wait();
            }
        }
    }
}
