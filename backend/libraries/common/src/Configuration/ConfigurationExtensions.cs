namespace Starter.Template.Common.Configuration;

public static class ConfigurationExtensions
{
    public static RabbitMqConfiguration RabbitMq(this IConfiguration config) => new(config);
    public static PostgresConfiguration Postgres(this IConfiguration config) => new(config);
}
