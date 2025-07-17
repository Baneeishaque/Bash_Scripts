#!/bin/bash
source "$(dirname "$0")/git_common.sh"

DRY_RUN=$([[ "$1" == "--dry-run" ]] && echo true || echo false)

branches=$(list_local_branches)

for branch in $branches; do
  echo -e "\n🔍 Evaluating branch: $branch"
  verify_branch_exists "$REMOTE_NAME/$branch" || { echo "📂 Remote $branch not found."; continue; }

  show_branch_diff "$branch" "$REMOTE_NAME/$branch"

  if $DRY_RUN; then
    dry_run_notice "git push $REMOTE_NAME $branch --force"
    continue
  fi

  ask_confirmation "❓ Force push '$branch'?" && \
    git push $REMOTE_NAME $branch --force && \
    echo "✅ Pushed $branch"
done

echo "🏁 Force-push script finished."
