to_kebab_case() {
    local input="$(to-snake-case "$1")"
    input="${input,,}"
    # Replace underscores and spaces with hyphens
    input="${input//[_ ]/-}"
    # Remove multiple consecutive hyphens
    input="${input//--/-}"
    # Remove leading and trailing hyphens
    input="${input#-}"
    input="${input%-}"
    echo "$input"
}

to_kebab_case "$1"
