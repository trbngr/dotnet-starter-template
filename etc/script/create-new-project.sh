#!/bin/bash

# #############################################################################
# Assemble Variables
# #############################################################################
if [[ -z "$PROJECT_NAMESPACE" ]]; then
    echo "Error: PROJECT_NAMESPACE is not set."
    exit 1
fi

project_dir=""
api_solution_file=""
api_project_file=""
name=""
name_snake=""
project_type=""

while [[ $# -gt 0 ]]; do
    case "$1" in
    --project-type)
        case "$2" in
        module) project_dir="$DEVENV_ROOT/backend/modules" ;;
        library) project_dir="$DEVENV_ROOT/backend/libraries" ;;
        *)
            echo "Error: --project-type must be either 'module' or 'library'."
            exit 1
            ;;
        esac
        project_type="$2"

        api_solution_file="$DEVENV_ROOT/backend/api/api.slnx"
        api_project_file="$DEVENV_ROOT/backend/api/src/api.csproj"
        shift 2
        ;;
    --name)
        name=$(to-pascal-case $2)
        name_snake=$(to-snake-case $2)
        shift 2
        ;;
    *)
        echo "Unknown argument: $1"
        exit 1
        ;;
    esac
done

if [[ -z "$name" || -z "$project_type" ]]; then
    echo "Usage: create-new-project --name NAME --project-type [module|library]"
    exit 1
fi

read -p "Enter any nuget packages to install (space-separated): " -a packages

# #############################################################################
# Functions to aid in readability
# #############################################################################
create_core_project() {
    mkdir -p "${project_dir}"
    cd "${project_dir}"

    # solution file - slnx
    dotnet new sln --name "$name_snake" >/dev/null 2>&1
    dotnet sln migrate
    rm "${name_snake}.sln"

    # project

    template=$([[ "$project_type" == "module" ]] && echo "web" || echo "classlib")
    dotnet new $template --name "${name_snake}" --output "src" --no-restore

    # add any packages requested
    for pkg in "${packages[@]}"; do
        echo "adding nuget package: $pkg"
        dotnet add "${project_file}" package "$pkg" >/dev/null 2>&1
    done

    # add to solution
    dotnet sln "${name_snake}.slnx" add "${project_file}"
}

add_root_namespace_to_project() {
    awk '/<PropertyGroup>/ && !x {print; print "    <RootNamespace>'"${PROJECT_NAMESPACE}.${name}"'</RootNamespace>"; x=1; next} 1' "$project_file" >"${project_file}.tmp" && mv "${project_file}.tmp" "$project_file"
}

nest_appsettings_files() {
    awk '
        BEGIN { inserted=0 }
        /<\/Project>/ && !inserted {
            print "  <ItemGroup>\n    <Content Update=\"appsettings.Development.json\">\n      <DependentUpon>appsettings.json</DependentUpon>\n    </Content>\n  </ItemGroup>";
            inserted=1
        }
        { print }
    ' "$project_file" >"${project_file}.tmp" && mv "${project_file}.tmp" "$project_file"
}

create_test_project() {
    "${SCRIPT_ROOT}/create-test-project.sh" \
        --project-dir "${project_dir}/${name_snake}" \
        --project-name "${name}" \
        --solution-file "${name_snake}.slnx"
}

expose_module_to_api() {
    "${SCRIPT_ROOT}/expose-module-to-api.sh" \
        --api-project-dir "$(dirname $api_project_file)" \
        --project-name "${name}" \
        --project-dir "${project_dir}"
}

add_module_references() {
    # Reference the common lib
    dotnet add "${project_file}" reference "$DEVENV_ROOT/backend/libraries/common/src/common.csproj"

    # add module to API solution
    dotnet sln "${api_solution_file}" \
        add "${project_file}" "${test_project_file}" \
        --solution-folder "modules/${name_snake}"

    # Reference the module in the API project
    dotnet add "${api_project_file}" reference "${project_file}"
}

add_library_to_api() {
    # add library to API solution
    dotnet sln "${api_solution_file}" \
        add "${project_file}" "${test_project_file}" \
        --solution-folder "libraries/${name_snake}"
}

create_frontend_lib_for_module() {
    cd "${DEVENV_ROOT}/frontend"
    echo "creating react library for module"
    nx g @nx/react:library --directory="libraries/${name_snake}" --bundler=vite --name="${name_snake}" --unitTestRunner=vitest >/dev/null 2>&1
    nx g @nx/react:storybook-configuration --project="${name_snake}" --configureStaticServe=true --generateStories=true --interactionTests=true >/dev/null 2>&1
    cd -
}

# #############################################################################
# Orchestrate the new project
# #############################################################################
SCRIPT_ROOT="${DEVENV_ROOT}/etc/script/create-new-project"

project_dir="${project_dir}/${name_snake}"
project_file="src/${name_snake}.csproj"
test_project_file="test/${name_snake}.test.csproj"

create_core_project
add_root_namespace_to_project
nest_appsettings_files
create_test_project

if [[ "$project_type" == "module" ]]; then
    expose_module_to_api
    add_module_references
    create_frontend_lib_for_module
fi

if [[ "$project_type" == "library" ]]; then
    add_library_to_api
fi
