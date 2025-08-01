#!/opt/homebrew/bin/bash

# Remote type preference order
preferred_types=(drive onedrive yandex mailru pcloud mega)

# Always source get_remote_free_space.bash
script_dir="$(dirname "$0")"
# shellcheck source=/dev/null
source "$script_dir/get_remote_free_space.bash"

# Get all remotes and their free space into an array using the function
mapfile -t remote_lines < <(get_remote_free_space 1)

# Parse remotes into associative arrays
declare -A remote_type_map
declare -A remote_free_map
remote_list=()
for line in "${remote_lines[@]}"; do
    rname=$(echo "$line" | cut -d'|' -f1)
    rtype=$(echo "$line" | cut -d'|' -f2)
    rfree=$(echo "$line" | cut -d'|' -f3)
    remote_type_map["$rname"]="$rtype"
    remote_free_map["$rname"]="$rfree"
    remote_list+=("$rname")
done

# Path to your Downloads directory
downloads_dir="$HOME/Downloads"

# Find all Stranger Things episodes in Downloads, sorted
episodes=("$downloads_dir"/Stranger.Things.S04E*.mkv)

# Check if any episodes were found
if [ ! -e "${episodes[0]}" ]; then
    echo "No Stranger Things episodes found in $downloads_dir."
    exit 1
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

# Helper: get type preference index
get_type_index() {
    local type="$1"
    for i in "${!preferred_types[@]}"; do
        if [[ "${preferred_types[$i]}" == "$type" ]]; then
            echo $i
            return
        fi
    done
    echo 99
}

# For each episode, pick the best remote, upload, then update free space
for episode in "${episodes[@]}"; do
    best_remote=""
    best_type_index=99
    best_free=-1
    # Find best remote by type preference and free space
    for rname in "${remote_list[@]}"; do
        rtype="${remote_type_map[$rname]}"
        rfree="${remote_free_map[$rname]}"
        type_index=$(get_type_index "$rtype")
        if [ "$type_index" -lt 99 ] && [ "$rfree" -ge 0 ]; then
            if [ "$best_remote" = "" ] || [ "$type_index" -lt "$best_type_index" ] || { [ "$type_index" -eq "$best_type_index" ] && [ "$rfree" -gt "$best_free" ]; }; then
                best_remote="$rname"
                best_type_index="$type_index"
                best_free="$rfree"
            fi
        fi
    done
    if [ -z "$best_remote" ]; then
        echo "No suitable remote found for $episode"
        break
    fi
    echo "Uploading '$episode' to '$best_remote:/' (type: ${remote_type_map[$best_remote]}, free: ${remote_free_map[$best_remote]} bytes) ..."
    rclone copy "$episode" "$best_remote:/" --progress --stats-one-line $dry_run_flag
    # Update in-memory free space for the chosen remote
    if [ -f "$episode" ]; then
        fsize=$(stat -f%z "$episode")
        remote_free_map["$best_remote"]=$(( ${remote_free_map[$best_remote]} - fsize ))
    fi
done

echo "Done."
