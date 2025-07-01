namespace Starter.Template.Common.Configuration;

public static class AuthConfiguration
{
    public static WebApplicationBuilder ConfigureAuth(this WebApplicationBuilder builder)
    {
        builder.Services
            .AddAuthentication("token");
        
        return builder;
    }
}
