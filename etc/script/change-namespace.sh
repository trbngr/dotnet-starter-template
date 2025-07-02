#!/bin/bash

source "$DEVENV_ROOT/etc/state"

echo "Current namespace: $PROJECT_NAMESPACE"
read -p "Enter new namespace: " REQUESTED_NAMESPACE

if [[ "$PROJECT_NAMESPACE" == "$REQUESTED_NAMESPACE" ]]; then
    echo "The namespaces are the same. Nothing to do."
    exit 0
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

replace_in_file "frontend/apps/frontend/src/auth-config.tsx" "$(to-snake-case $PROJECT_NAMESPACE)" "$(to-snake-case $REQUESTED_NAMESPACE)"
replace_in_file "etc/keycloak/realm.json" "$(to-snake-case $PROJECT_NAMESPACE)" "$(to-snake-case $REQUESTED_NAMESPACE)"

update_state_file "PROJECT_NAMESPACE" "$REQUESTED_NAMESPACE"

echo "Namespace changed from $PROJECT_NAMESPACE to $REQUESTED_NAMESPACE."
