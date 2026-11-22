#!/bin/bash

compare_service_states() {
    local OLD_FILE_PATHNAME="$1"
    local NEW_FILE_PATHNAME="$2"

    local -A array_old=()
    local -A array_new=()
    local -a old_keys=()
    local -a new_keys=()
    local -a changes=()
    local key value result

    if [[ ! -r "$OLD_FILE_PATHNAME" || ! -r "$NEW_FILE_PATHNAME" ]]; then
        echo "ERROR: Cannot read service state files" >&2
        return 1
    fi

    # Read old states
    while read -r key value || [[ -n "$key" ]]; do
        [[ -z "$key" ]] && continue
        array_old["$key"]="$value"
        old_keys+=("$key")
    done < "$OLD_FILE_PATHNAME"

    # Read new states
    while read -r key value || [[ -n "$key" ]]; do
        [[ -z "$key" ]] && continue
        array_new["$key"]="$value"
        new_keys+=("$key")
    done < "$NEW_FILE_PATHNAME"

    # Find changed and removed services
    for key in "${old_keys[@]}"; do
        if [[ ! -v array_new[$key] ]]; then
            changes+=("$key=removed")
        elif [[ "${array_old[$key]}" != "${array_new[$key]}" ]]; then
            changes+=("$key=${array_old[$key]}->${array_new[$key]}")
        fi
    done

    # Find newly added services
    for key in "${new_keys[@]}"; do
        if [[ ! -v array_old[$key] ]]; then
            changes+=("$key=new")
        fi
    done

    # Print all changes in one line
    if (( ${#changes[@]} > 0 )); then
        printf -v result '%s, ' "${changes[@]}"
        echo "${result%, }"
    fi
}
