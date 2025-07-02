using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.Text;

namespace Starter.Template.SourceGenerators.ConfigKey;

public static class Code
{
    public static IncrementalGeneratorPostInitializationContext GenerateConfigKey(
        this IncrementalGeneratorPostInitializationContext context)
    {
        var file = @"ConfigKey/Templates/ConfigKey.scriban_cs";
        var content = EmbeddedResource.GetContent(file);
        context.AddSource("ConfigKey.g.cs", SourceText.From(content));
        return context;
    }
}