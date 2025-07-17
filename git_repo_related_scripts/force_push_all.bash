#!/bin/bash

DRY_RUN=false
REMOTE_NAME="origin"

# Check for dry-run flag
if [ "$1" == "--dry-run" ]; then
  DRY_RUN=true
  echo "🧪 Dry run enabled: No branches will be pushed."
fi

echo "📋 Analyzing local branches..."
branches=$(git branch | sed 's/\*//g' | sed 's/ //g')

for branch in $branches; do
  echo -e "\n🔍 Inspecting branch: $branch"
  LOCAL_HASH=$(git rev-parse $branch)
  REMOTE_HASH=$(git rev-parse $REMOTE_NAME/$branch 2>/dev/null)

  if [ -z "$REMOTE_HASH" ]; then
    echo "📂 Remote branch $REMOTE_NAME/$branch not found. Skipping diff."
    continue
  fi

  BASE=$(git merge-base $branch $REMOTE_NAME/$branch)

  echo "🧠 Common ancestor (merge-base): $BASE"
  echo "📝 Local commits since common ancestor:"
  git log --oneline $BASE..$LOCAL_HASH

  echo "🌐 Remote commits since common ancestor:"
  git log --oneline $BASE..$REMOTE_HASH

  if $DRY_RUN; then
    echo "🛑 Dry run: Would prompt to force push branch '$branch'"
    continue
  fi

  read -p "❓ Do you want to force push '$branch'? (y/n): " confirm
  if [[ "$confirm" =~ ^[Yy]$ ]]; then
    echo "🚀 Force pushing $branch to $REMOTE_NAME..."
    git push $REMOTE_NAME $branch --force
    if [ $? -eq 0 ]; then
      echo "✅ Successfully pushed $branch"
    else
      echo "⚠️ Failed to push $branch"
    fi
  else
    echo "⏭️ Skipping push for $branch"
  fi
done

echo "✅ Script execution completed."
