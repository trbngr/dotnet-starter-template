#!/bin/bash
if [[ -z "$PROJECT_NAMESPACE" ]]; then
    echo "Error: PROJECT_NAMESPACE is not set."
    exit 1
fi

# Default values
project_dir=""
project_name=""
project_name_snake=""
api_project_dir=""

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
    --project-dir)
        project_dir="$2"
        shift 2
        ;;
    --project-name)
        project_name=$(to-pascal-case $2)
        project_name_snake=$(to-snake-case $2)
        shift 2
        ;;
    --api-project-dir)
        api_project_dir="$2"
        shift 2
        ;;
    *)
        echo "Unknown argument: $1"
        exit 1
        ;;
    esac
done

# Check required arguments
if [[ -z "$project_dir" || -z "$api_project_dir" || -z "$project_name" ]]; then
    echo "Usage: expose-module-to-api --project-dir DIR --project-name NAME --api-project-dir DIR"
    exit 1
fi

# echo "PROJECT_NAMESPACE: $PROJECT_NAMESPACE"
# echo "project_dir: $project_dir"
# echo "project_name: $project_name"
# echo "project_name_snake: $project_name_snake"
# echo "api_project_dir: $api_project_dir"

# exit 0

set_hotchocolate_module_name() {
    cat >"$project_dir/src/Properties/ModuleInfo.cs" <<EOF
// ReSharper disable CheckNamespace
[assembly: HotChocolate.Module("${project_name}Module")]
namespace ${PROJECT_NAMESPACE};
public static class ${project_name}Module
{
    public static void Add${project_name}Module(this Wolverine.WolverineOptions options) =>
        options.Discovery.IncludeAssembly(typeof(${project_name}Module).Assembly);
}
EOF
}

create_hotchocolate_queries() {
    cat >"$project_dir/src/Types/${project_name}Queries.cs" <<EOF
using HotChocolate.Language;
using HotChocolate.Types;

namespace ${PROJECT_NAMESPACE}.${project_name}.Types;

[ExtendObjectType(OperationType.Query)]
public class ${project_name}Queries
{
}
EOF
}

create_hotchocolate_mutations() {
    cat >"$project_dir/src/Types/${project_name}Mutations.cs" <<EOF
using HotChocolate.Language;
using HotChocolate.Types;

namespace ${PROJECT_NAMESPACE}.${project_name}.Types;

[ExtendObjectType(OperationType.Mutation)]
public class ${project_name}Mutations
{
}
EOF
}

add_hotchocolate_module() {
    local api_program_file="${api_project_dir}/Program.cs"
    local tmp_file=$(mktemp)

    awk -v mod="\t.Add${project_name}Module()" '
        /\.AddApiTypes\(\)/ {
            print mod
        }
        { print }
    ' "$api_program_file" >"$tmp_file" && mv "$tmp_file" "$api_program_file"
}

add_wolverine_module() {
    local api_program_file="${api_project_dir}/Program.cs"
    local tmp_file=$(mktemp)

    # Avoid duplicate insertion
    if grep -q "opts.Add${project_name}Module();" "$api_program_file"; then
        return
    fi

    awk -v mod="\topts.Add${project_name}Module();" '
        /opts\.Policies\.AutoApplyTransactions\(\);/ {
            print
            print mod
            next
        }
        { print }
    ' "$api_program_file" >"$tmp_file" && mv "$tmp_file" "$api_program_file"
}

mkdir -p "$project_dir/src/Types"

set_hotchocolate_module_name
create_hotchocolate_mutations
create_hotchocolate_queries
add_hotchocolate_module
add_wolverine_module
