using System.Diagnostics;
using Microsoft.CodeAnalysis;
using Starter.Template.SourceGenerators.ConfigKey;

namespace Starter.Template.SourceGenerators;

[Generator]
public class ConfigKeyGenerator : IIncrementalGenerator
{
    public void Initialize(IncrementalGeneratorInitializationContext context)
    {
#if DEBUG
        if (!Debugger.IsAttached) Debugger.Launch();
#endif
        context.RegisterPostInitializationOutput(ctx => ctx.GenerateConfigKey());
    }
}