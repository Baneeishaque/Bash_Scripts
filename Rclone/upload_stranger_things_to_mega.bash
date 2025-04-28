#!/bin/bash

# List of Mega remotes
mega_remotes=(
    "Mega-Banee-Proton"
    "Mega-Banee4-Gmail"
    "Mega-Banee5-Gmail"
    "Mega-Banee6-Gmail"
    "Mega-Banee7-Gmail"
    "Mega-Banee-Hotmail"
)

# Path to your Downloads directory
downloads_dir="$HOME/Downloads"

# Find all Stranger Things episodes in Downloads, sorted
episodes=("$downloads_dir"/Stranger.Things.S04E*.mkv)

# Check if the number of episodes matches the number of remotes
if [ ${#episodes[@]} -gt ${#mega_remotes[@]} ]; then
    echo "Warning: More episodes than Mega remotes. Some episodes will not be uploaded."
    elif [ ${#episodes[@]} -lt ${#mega_remotes[@]} ]; then
    echo "Warning: More Mega remotes than episodes. Some remotes will not be used."
fi

# Check if we should actually run or just dry run
if [[ "$1" == "run" ]]; then
    dry_run_flag=""
    echo "Running actual upload..."
else
    dry_run_flag="--dry-run"
    echo "Dry run mode (no files will be uploaded)."
    echo "Pass 'run' as an argument to actually upload."
fi

# Upload each episode to the corresponding Mega remote
for i in "${!episodes[@]}"; do
    episode="${episodes[$i]}"
    remote="${mega_remotes[$i]}"
    if [ -z "$remote" ]; then
        echo "No more Mega remotes available for $episode"
        break
    fi
    echo "Uploading '$episode' to '$remote:/' ..."
    rclone copy "$episode" "$remote:/" --progress --stats-one-line $dry_run_flag
done

echo "Done."