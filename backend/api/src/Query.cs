using HotChocolate.Types;

namespace StarterTemplate.Api;

[QueryType]
public partial class Query
{
    public string Hello() => "Hello";
}
