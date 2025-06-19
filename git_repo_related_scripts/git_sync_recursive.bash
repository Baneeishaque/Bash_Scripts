#!/bin/bash

# Get the directory of the current script
DIR="$(dirname "$0")"

# Source the pull script (which sources the base script)
source "$DIR/git_pull_recursive.bash"

# Override post_git_operation to implement push
function post_git_operation {
  local repo_path="$1"
  # Only push if user has push permission
  if git ls-remote --exit-code origin HEAD &>/dev/null; then
    git push
  fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    run_updater_entrypoint "$@"
fi
