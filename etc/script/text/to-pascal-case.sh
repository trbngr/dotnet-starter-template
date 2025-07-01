to_pascal_case() {
    local input="$1"
    local output=""
    IFS='-_ ' read -ra parts <<<"$input"
    for part in "${parts[@]}"; do
        output+="${part^}"
    done
    echo "$output"
}

to_pascal_case $1
