// ReSharper disable CheckNamespace
[assembly: HotChocolate.Module("UsersModule")]
namespace StarterTemplate;
public static class UsersModule
{
    public static void AddUsersModule(this Wolverine.WolverineOptions options) =>
        options.Discovery.IncludeAssembly(typeof(UsersModule).Assembly);
}
