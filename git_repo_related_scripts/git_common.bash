#!/bin/bash

REMOTE_NAME="origin"

function list_local_branches() {
  git branch | sed 's/\*//g' | sed 's/ //g'
}

function verify_branch_exists() {
  git rev-parse --verify "$1" > /dev/null
}

function fetch_all() {
  echo "🔍 Fetching all branches..."
  git fetch --all
}

function show_branch_diff() {
  local branch=$1
  local target=$2
  local base=$(git merge-base $branch $target)

  echo "🧠 Common ancestor (merge-base): $base"
  echo "📝 Commits in $branch not in $target:"
  git log --oneline $base..$branch

  echo "🌿 Commits in $target not in $branch:"
  git log --oneline $base..$target
}

function ask_confirmation() {
  local prompt="$1"
  read -p "$prompt (y/n): " confirm
  [[ "$confirm" =~ ^[Yy]$ ]]
}

function dry_run_notice() {
  echo "🛑 Dry run: Would execute: $1"
}
