#!/bin/bash
if [[ -z "$PROJECT_NAMESPACE" ]]; then
    echo "Error: PROJECT_NAMESPACE is not set."
    exit 1
fi

# Default values
project_dir=""
project_name=""
project_name_snake=""
solution_file=""

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
    --solution-file)
        solution_file="$2"
        shift 2
        ;;
    *)
        echo "Unknown argument: $1"
        exit 1
        ;;
    esac
done

# Check required arguments
if [[ -z "$project_dir" || -z "$project_name" ]]; then
    echo "Usage: create-test-project --project-dir DIR --project-name NAME"
    exit 1
fi

test_project_name="${project_name_snake}.test"
test_project_file="test/${project_name_snake}.test.csproj"

dotnet new xunit --name "${test_project_name}" --output "test" --no-restore
dotnet add "${test_project_file}" reference "src/${project_name_snake}.csproj"
dotnet sln "${solution_file}" add "$test_project_file"

packages=(
    coverlet.collector
    Microsoft.NET.Test.Sdk
    xunit
    xunit.runner.visualstudio
)

for pkg in "${packages[@]}"; do
    dotnet remove "$test_project_file" package "$pkg" >/dev/null 2>&1
done

for pkg in "${packages[@]}"; do
    echo "adding nuget package: '$pkg' to test project"
    dotnet add "$test_project_file" package "$pkg" >/dev/null 2>&1
done

echo "adding nuget package: 'Moq' to test project"
dotnet add "$test_project_file" package Moq >/dev/null 2>&1

echo "adding nuget package: 'JetBrains.Annotations' to test project"
dotnet add "$test_project_file" package JetBrains.Annotations --prerelease >/dev/null 2>&1

SCRIPT_ROOT="${DEVENV_ROOT}/etc/script/create-new-project"

awk '/<PropertyGroup>/ && !x {print; print "    <RootNamespace>'"${PROJECT_NAMESPACE}.${name}.Test"'</RootNamespace>"; x=1; next} 1' "$test_project_file" >"${test_project_file}.tmp" && mv "${test_project_file}.tmp" "$test_project_file"

rm "./test/UnitTest1.cs"
