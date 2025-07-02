#!/bin/bash

echo "Current namespace: $PROJECT_NAMESPACE"
read -p "Enter new namespace: " REQUESTED_NAMESPACE

if [[ "$PROJECT_NAMESPACE" == "$REQUESTED_NAMESPACE" ]]; then
    echo "The namespaces are the same. Nothing to do."
    exit 0
fi

if [[ -n $(git status --porcelain) ]]; then

    echo "Aborting due to uncommitted changes"
    exit 1
fi

replace_in_file() {
    local file="$1"
    local current_value="$2"
    local new_value="$3"

    awk -v old="$current_value" -v new="$new_value" '{gsub(old, new); print}' "$file" >"$file.tmp"
    mv "$file.tmp" "$file"
}

update_backend_namespaces() {
    local files

    files=$(rg --files-with-matches --glob '!obj/**' --glob '!bin/**' --glob '!node_modules/**' "$PROJECT_NAMESPACE" backend)

    if [[ -n "$files" ]]; then
        while IFS= read -r file; do
            replace_in_file "$file" "$PROJECT_NAMESPACE" "$REQUESTED_NAMESPACE"
        done <<<"$files"
    fi
}

update_backend_namespaces

files_to_update_with_kebab_case=(
    "frontend/apps/frontend/src/auth-config.tsx"
    "etc/keycloak/realm.json"
    "devenv.nix"
    "services/caddy.nix"
)

for file in "${files_to_update_with_snake_case[@]}"; do
    replace_in_file "$file" "$(to-kebab-case $PROJECT_NAMESPACE)" "$(to-kebab-case $REQUESTED_NAMESPACE)"
done

replace_in_file "devenv.nix" "$PROJECT_NAMESPACE" "$REQUESTED_NAMESPACE"

echo ""
echo "
# #############################################################################
    Namespace changed from $PROJECT_NAMESPACE to $REQUESTED_NAMESPACE.

    Please ensure to update any other configurations or files that may reference the old namespace.

    I use dnsmasq to resolve local.*.com to localhost. So you may need to update your dnsmasq configuration.
# #############################################################################
"
