using HotChocolate.Types;

namespace StarterTemplate.Api;

[MutationType]
public partial class Mutation
{
    public string Hello() => "Hello";
}
