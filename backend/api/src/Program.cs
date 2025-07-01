using JasperFx;
using Starter.Template;
using Wolverine;
using Wolverine.EntityFrameworkCore;
using Wolverine.Postgresql;

var builder = WebApplication.CreateBuilder(args);

builder.Host.UseWolverine(opts =>
{
    var pg = builder.Configuration.Postgres();
    opts.PersistMessagesWithPostgresql(pg);
    opts.UseEntityFrameworkCoreTransactions();
    opts.Policies.AutoApplyTransactions();
	opts.AddUsersModule();
});

builder.Services.AddGraphQLServer()
	.AddUsersModule()
    .AddApiTypes();

var app = builder.Build();

app.MapGraphQL();

app.MapGet("/", () => Results.Redirect("/graphql"));

// Opt into using JasperFx for command line parsing
// to unlock built in diagnostics and utility tools within
// your Wolverine application
return await app.RunJasperFxCommands(args);
