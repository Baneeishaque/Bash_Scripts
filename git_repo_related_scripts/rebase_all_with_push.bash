#!/bin/bash

BASE_BRANCH=$1
DRY_RUN=false

if [ "$2" == "--dry-run" ]; then
  DRY_RUN=true
  echo "🧪 Dry run enabled: no branches will be changed."
fi

if [ -z "$BASE_BRANCH" ]; then
  echo "❌ Error: No base branch specified."
  echo "Usage: ./rebase_all.bash <base-branch> [--dry-run]"
  exit 1
fi

echo "🔍 Fetching all branches..."
git fetch --all

echo "📂 Checking base branch: $BASE_BRANCH"
git rev-parse --verify $BASE_BRANCH > /dev/null || { echo "Base branch '$BASE_BRANCH' not found."; exit 1; }

echo "📋 Listing local branches..."
branches=$(git branch | sed 's/\*//g' | sed 's/ //g' | grep -v "$BASE_BRANCH")

for branch in $branches; do
  echo -e "\n🔍 Evaluating branch: $branch"

  BASE=$(git merge-base $branch $BASE_BRANCH)

  echo "🧠 Common ancestor (merge-base): $BASE"
  echo "📝 Commits in $branch not in $BASE_BRANCH:"
  git log --oneline $BASE..$branch

  echo "🌿 Commits in $BASE_BRANCH not in $branch:"
  git log --oneline $BASE..$BASE_BRANCH

  if $DRY_RUN; then
    echo "🛑 Dry run: Would rebase $branch onto $BASE_BRANCH"
    continue
  fi

  echo "🔄 Rebasing $branch onto $BASE_BRANCH..."
  git checkout $branch
  git rebase $BASE_BRANCH
  if [ $? -ne 0 ]; then
    echo "⚠️ Rebase failed on branch $branch. Resolve conflicts manually."
    exit 1
  fi
  echo "✅ Successfully rebased $branch"
done

if $DRY_RUN; then
  echo "🧪 Dry run completed. No changes were made."
else
  echo "🏁 All branches rebased onto $BASE_BRANCH!"
fi
