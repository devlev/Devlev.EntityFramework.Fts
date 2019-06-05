# Devlev.EntityFramework.Fts
Full-Text Search in ADO.NET Entity Framework 6 with support LINQ.

## How to use it?
1. Download this source and build all project
2. Add DLL Devlev.EntityFramework.Fts.dll to your project
3. Create utility table FTS_Int
```csharp
public partial class FTS_Int
{
    public int Key { get; set; }
    public int Rank { get; set; }
    public string Query { get; set; }
}
```
4. Add table FTS_Int to your .edmx file;
5. Add using Devlev.EntityFramework.Fts;
6. See examples!

## Examples
```csharp
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

var result = FtsSearch.Execute(() => query.ToList());
```
### Code Samples Async
```csharp
// ...
var result = await FtsSearch.ExecuteAsync(async () => await query.ToListAsync());
```
### Log
```csharp
FtsSearch.Log = value => Console.WriteLine(value);
```
### License
MIT licensed
