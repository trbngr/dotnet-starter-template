using System.Diagnostics;
using Microsoft.CodeAnalysis;
using StarterTemplate.SourceGenerators.ConfigKey;

namespace StarterTemplate.SourceGenerators;

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
