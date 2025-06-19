#!/bin/bash

# Get the directory of the current script
DIR="$(dirname "$0")"

# Source the base script
source "$DIR/git_base_recursive.bash"

# Override git_operation to implement pull
function git_operation {
    printf "%b\n" "${HIGHLIGHT}Pulling changes in $(pwd)${NORMAL}"
    local repo_path="$1"
    git pull
}

# Dummy function for post-pull operations (can be overridden by sync)
function post_git_operation {
    local repo_path="$1"
    # Override this in sync script to add push
    return 0
}
