#!/bin/bash

# Usage: ./cherry_pick_commits.sh <source_repo> <source_branch> <target_repo> <target_branch> <start_commit>

# Validate the number of arguments
if [ "$#" -ne 5 ]; then
    echo "Usage: $0 <source_repo> <source_branch> <target_repo> <target_branch> <start_commit>"
    exit 1
fi

SOURCE_REPO="$1"
SOURCE_BRANCH="$2"
TARGET_REPO="$3"
TARGET_BRANCH="$4"
START_COMMIT="$5"

# Print input values for debugging and user convenience
echo "Input values:"
echo "Source repo: $SOURCE_REPO"
echo "Source branch: $SOURCE_BRANCH"
echo "Target repo: $TARGET_REPO"
echo "Target branch: $TARGET_BRANCH"
echo "Start commit: $START_COMMIT"

# Check if the source repository is already added as a remote in the target repository
if git -C "$TARGET_REPO" remote | grep -q "source_repo"; then
    EXISTING_SOURCE_REPO=$(git -C "$TARGET_REPO" remote get-url source_repo)
    if [ "$EXISTING_SOURCE_REPO" != "$SOURCE_REPO" ]; then
        echo "Error: The existing source repository URL does not match the input value."
        exit 1
    fi
    echo "The source repository is the same as previously added. Continuing without adding the remote."
else
    # Add the source repository as a remote in the target repository
    if ! git -C "$TARGET_REPO" remote add source_repo "$SOURCE_REPO"; then
        echo "Error adding the source repository as a remote."
        exit 1
    fi
fi

# Fetch the latest changes from the source branch
if ! git -C "$TARGET_REPO" fetch source_repo "$SOURCE_BRANCH"; then
    echo "Error fetching changes from the source repository."
    exit 1
fi

# Get the list of commits after the specified commit in the source repository
COMMIT_HASHES=($(git -C "$TARGET_REPO" log --pretty=format:"%H" "$SOURCE_BRANCH"..source_repo/"$SOURCE_BRANCH" --not "$START_COMMIT"))

# Reverse the order of COMMIT_HASHES using a loop (create a new array)
REVERSED_COMMIT_HASHES=()
for ((i=${#COMMIT_HASHES[@]}-1; i>=0; i--)); do
    REVERSED_COMMIT_HASHES+=("${COMMIT_HASHES[i]}")
done

# Confirm the commit hashes and cherry-pick in the correct order
echo "Commits to cherry-pick:"
for commit_hash in "${REVERSED_COMMIT_HASHES[@]}"; do
    read -p "Cherry-pick commit $commit_hash ('$(git -C "$TARGET_REPO" log -1 --pretty=format:"%s" "$commit_hash")')? (yes/no): " choice
    if [[ "$choice" == "yes" ]]; then
        if ! git -C "$TARGET_REPO" cherry-pick "$commit_hash"; then
            echo "Cherry-pick failed for commit $commit_hash."
            exit 1
        fi
    fi
done

echo "Cherry-picking completed!"
