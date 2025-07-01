using HotChocolate.Types;

namespace Starter.Template.Api;

[QueryType]
public partial class Query
{
    public string Hello() => "Hello";
}
