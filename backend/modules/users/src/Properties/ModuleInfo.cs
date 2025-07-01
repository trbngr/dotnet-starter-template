// ReSharper disable CheckNamespace
[assembly: HotChocolate.Module("UsersModule")]
namespace Starter.Template;
public static class UsersModule
{
    public static void AddUsersModule(this Wolverine.WolverineOptions options) =>
        options.Discovery.IncludeAssembly(typeof(UsersModule).Assembly);
}
