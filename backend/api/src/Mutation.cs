using HotChocolate.Types;

namespace Starter.Template.Api;

[MutationType]
public partial class Mutation
{
    public string Hello() => "Hello";
}
