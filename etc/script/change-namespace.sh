#!/bin/bash

source "$DEVENV_ROOT/etc/state"

echo "Current namespace: $CURRENT_NAMESPACE"
read -p "Enter new namespace: " REQUESTED_NAMESPACE

if [[ "$CURRENT_NAMESPACE" == "$REQUESTED_NAMESPACE" ]]; then
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

    files=$(rg --files-with-matches --glob '!obj/**' --glob '!bin/**' --glob '!node_modules/**' "$CURRENT_NAMESPACE" backend)

    if [[ -n "$files" ]]; then
        while IFS= read -r file; do
            replace_in_file "$file" "$CURRENT_NAMESPACE" "$REQUESTED_NAMESPACE"
        done <<<"$files"
    fi
}

update_backend_namespaces

replace_in_file "frontend/apps/frontend/src/auth-config.tsx" "$(to-snake-case $CURRENT_NAMESPACE)" "$(to-snake-case $REQUESTED_NAMESPACE)"
replace_in_file "etc/keycloak/realm.json" "$(to-snake-case $CURRENT_NAMESPACE)" "$(to-snake-case $REQUESTED_NAMESPACE)"

update_state_file "CURRENT_NAMESPACE" "$REQUESTED_NAMESPACE"

echo "Namespace changed from $CURRENT_NAMESPACE to $REQUESTED_NAMESPACE."
