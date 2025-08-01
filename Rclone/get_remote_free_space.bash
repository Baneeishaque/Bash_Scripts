#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils.bash"

CONFIG_PATH="$HOME/Lab_Data/configurations-private/rclone.conf"

get_remote_free_space() {
    local quiet=1
    if [[ "$1" == "0" ]]; then
        quiet=0
        echo "Fetching free space for all remotes (this may take some time)..."
        echo "--------------------------------------------------------------"
        echo "REMOTE | TYPE | FREE SPACE"
        echo "--------------------------------------------------------------"
    fi
    remotes=$(rclone listremotes --config "$CONFIG_PATH")
    output_lines=()
    for remote in $remotes; do
        remote_name=${remote%:}
        remote_info=$(rclone config show "$remote_name" --config "$CONFIG_PATH")
        remote_type=$(echo "$remote_info" | grep "type =" | head -n1 | cut -d '=' -f 2 | tr -d ' ')
        case "$remote_type" in
            googlephotos|box|s3|ftp|http|alias|hasher)
                if [[ $quiet -eq 0 ]]; then
                    echo "$remote_name | $remote_type | 'about' not supported or not needed"
                fi
                continue
                ;;
            union)
                if [[ $quiet -eq 0 ]]; then
                    echo "$remote_name | $remote_type | Skipped (union of upstreams already checked)"
                fi
                continue
                ;;
        esac
        if [ "$remote_type" = "sftp" ]; then
            host=$(echo "$remote_info" | grep "host =" | cut -d '=' -f 2 | tr -d ' ' | tr -d '*')
            user=$(echo "$remote_info" | grep "user =" | cut -d '=' -f 2 | tr -d ' ')
            key_file=$(echo "$remote_info" | grep "key_file =" | cut -d '=' -f 2 | tr -d ' ')
            if [ -n "$host" ] && [ -n "$user" ] && [ -n "$key_file" ] && [ -f "$key_file" ]; then
                ssh_output=$(run_with_timeout 10s ssh -i "$key_file" -o StrictHostKeyChecking=no -o BatchMode=yes "$user@$host" "df -h / | tail -1 | awk '{print \\$4}'" 2>/dev/null)
                if [ $? -eq 0 ] && [ -n "$ssh_output" ]; then
                    if [[ $quiet -eq 0 ]]; then
                        echo "$remote_name | $remote_type | $ssh_output"
                    fi
                    if [ -n "$ssh_output" ]; then
                        output_lines+=("$ssh_output|$remote_name | $remote_type | $ssh_output")
                    else
                        output_lines+=("0|$remote_name | $remote_type | $ssh_output")
                    fi
                else
                    if [[ $quiet -eq 0 ]]; then
                        echo "$remote_name | $remote_type | SSH connection failed"
                    fi
                fi
            else
                if [[ $quiet -eq 0 ]]; then
                    echo "$remote_name | $remote_type | Missing SSH connection details"
                fi
            fi
        else
            about_info=$(run_with_timeout 10s rclone about "${remote}" --json --config "$CONFIG_PATH" 2>/dev/null)
            if [ $? -eq 0 ] && [ -n "$about_info" ]; then
                free_space=$(echo "$about_info" | grep -o '"free":[^,}]*' | cut -d':' -f2)
                if [ -n "$free_space" ]; then
                    if [ "$free_space" -ge 1073741824 ]; then
                        free_human=$(echo "scale=2; $free_space/1073741824" | bc)" GB"
                    elif [ "$free_space" -ge 1048576 ]; then
                        free_human=$(echo "scale=2; $free_space/1048576" | bc)" MB"
                    elif [ "$free_space" -ge 1024 ]; then
                        free_human=$(echo "scale=2; $free_space/1024" | bc)" KB"
                    else
                        free_human="$free_space B"
                    fi
                    if [[ $quiet -eq 0 ]]; then
                        echo "$remote_name | $remote_type | $free_human"
                    fi
                    output_lines+=("$free_space|$remote_name | $remote_type | $free_human")
                else
                    if [[ $quiet -eq 0 ]]; then
                        echo "$remote_name | $remote_type | Free space not reported"
                    fi
                fi
            else
                if [[ $quiet -eq 0 ]]; then
                    echo "$remote_name | $remote_type | Not supported or timed out"
                fi
            fi
        fi
    done
    printf "%s\n" "${output_lines[@]}" | sort -t'|' -k1,1nr | cut -d'|' -f2-
}

# If not sourced, run the function and print output
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    get_remote_free_space 0
fi
