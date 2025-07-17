#!/bin/bash

BASE_BRANCH=$1

if [ -z "$BASE_BRANCH" ]; then
  echo "❌ Error: No base branch specified."
  echo "Usage: ./rebase_all.sh <base-branch>"
  exit 1
fi

echo "🔍 Fetching all branches..."
git fetch --all

echo "📂 Checking out base branch: $BASE_BRANCH"
git checkout $BASE_BRANCH || { echo "Base branch '$BASE_BRANCH' not found."; exit 1; }

echo "📋 Listing local branches..."
branches=$(git branch | sed 's/\*//g' | sed 's/ //g' | grep -v "$BASE_BRANCH")

for branch in $branches; do
  echo "🔄 Rebasing branch: $branch onto $BASE_BRANCH"
  git checkout $branch
  git rebase $BASE_BRANCH
  if [ $? -ne 0 ]; then
    echo "⚠️ Rebase failed on branch $branch. Resolve conflicts manually."
    exit 1
  fi
  echo "✅ Successfully rebased $branch"
done

echo "🏁 All branches rebased onto $BASE_BRANCH!"
