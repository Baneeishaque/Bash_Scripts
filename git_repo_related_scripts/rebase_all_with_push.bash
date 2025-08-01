#!/bin/bash
source "$(dirname "$0")/git_common.bash"

BASE_BRANCH=$1
DRY_RUN=$([[ "$2" == "--dry-run" ]] && echo true || echo false)

[ -z "$BASE_BRANCH" ] && echo "Usage: ./rebase_all_with_push.bash <base-branch> [--dry-run]" && exit 1

fetch_all
verify_branch_exists "$BASE_BRANCH" || { echo "❌ Base branch '$BASE_BRANCH' not found."; exit 1; }

branches=$(list_local_branches | grep -v "$BASE_BRANCH")

for branch in $branches; do
  echo -e "\n🔍 Evaluating branch: $branch"
  show_branch_diff "$branch" "$BASE_BRANCH"

  if $DRY_RUN; then
    dry_run_notice "git rebase $BASE_BRANCH onto $branch + force push"
    continue
  fi

  git checkout $branch && git rebase $BASE_BRANCH || { echo "⚠️ Rebase failed on $branch"; exit 1; }

  ask_confirmation "❓ Force push rebased branch '$branch'?" && \
    git push $REMOTE_NAME $branch --force && \
    echo "✅ Pushed $branch"
done

echo "🚀 Rebase + push workflow finished."
