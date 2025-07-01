#!/bin/bash
to_snake_case() {
    local input="$1"
    local cleaned=""
    local char prev=""

    input="${input//[-_]/ }"
    input="${input//[^a-zA-Z0-9 ]/}"

    for word in $input; do
        local snake=""
        prev=""
        for ((i = 0; i < ${#word}; i++)); do
            char="${word:$i:1}"
            if [[ "$char" =~ [A-Z] ]]; then
                if [[ "$prev" =~ [a-z0-9] && -n "$prev" ]]; then
                    snake+="_"
                fi
                snake+="$(tr 'A-Z' 'a-z' <<<"$char")"
            elif [[ "$char" =~ [0-9] ]]; then
                if [[ "$prev" =~ [a-zA-Z] && -n "$prev" ]]; then
                    snake+="_"
                fi
                snake+="$char"
            else
                snake+="$char"
            fi
            prev="$char"
        done
        cleaned+="${cleaned:+_}$snake"
    done

    echo "$cleaned"
}

to_snake_case $1
