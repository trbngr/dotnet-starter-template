// ReSharper disable MemberCanBePrivate.Global
namespace Starter.Template.Common.Configuration;

public record RabbitMqConfiguration(IConfiguration Configuration)
{
    public string ConnectionString => Configuration["RabbitMq:ConnectionString"] ?? "amqp://localhost:5672";
    public static implicit operator string(RabbitMqConfiguration cfg) => cfg.ConnectionString;
}
