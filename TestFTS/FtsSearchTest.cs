using System;
using DatabaseFTS;
using Devlev.EntityFramework.Fts;
using Xunit;

namespace TestFTS
{
    public class FtsSearchTest
    {
        [Fact]
        public void Query()
        {
            using (BlogEntities db = new BlogEntities())
            {
                string res = FtsSearch.Query(
                        dbContext: db,
                        ftsEnum: FtsEnum.CONTAINS,
                        tableQuery: typeof(Article),
                        tableFts: typeof(FTS_Int),
                        search: "text");

                Assert.Equal("(-FTSFULLTEXTTABLE-CONTAINS-;[dbo].[Article];*;[dbo].[FTS_Int];text)", res);
            }
        }

        [Fact]
        public void Query_Fields()
        {
            using (BlogEntities db = new BlogEntities())
            {
                string res = FtsSearch.Query(
                        dbContext: db,
                        ftsEnum: FtsEnum.CONTAINS,
                        tableQuery: typeof(News),
                        tableFts: typeof(FTS_Int),
                        search: "text",
                        fields: new string[] { nameof(News.Text),nameof(News.Tegs) });

                Assert.Equal("(-FTSFULLTEXTTABLE-CONTAINS-;[dbo].[News];Text,Tegs;[dbo].[FTS_Int];text)", res);
            }
        }

        [Fact]
        public void Query_FREETEXT()
        {
            using (BlogEntities db = new BlogEntities())
            {
                string res = FtsSearch.Query(
                        dbContext: db,
                        ftsEnum: FtsEnum.FREETEXT,
                        tableQuery: typeof(News),
                        tableFts: typeof(FTS_Int),
                        search: "test or text");

                Assert.Equal("(-FTSFULLTEXTTABLE-FREETEXT-;[dbo].[News];*;[dbo].[FTS_Int];test or text)", res);
            }
        }
    }
}
