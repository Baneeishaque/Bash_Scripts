#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils.bash"

CONFIG_PATH="$HOME/Lab_Data/configurations-private/rclone.conf"

echo "Fetching free space for all remotes (this may take some time)..."
echo "--------------------------------------------------------------"
echo "REMOTE | TYPE | FREE SPACE"
echo "--------------------------------------------------------------"

# Get list of remotes
remotes=$(rclone listremotes --config "$CONFIG_PATH")
# echo $remotes
# press_enter_to_continue

# Collect output lines with free space for sorting
output_lines=()

for remote in $remotes; do
    # Remove trailing colon from remote name
    remote_name=${remote%:}
    # echo $remote_name
    # press_enter_to_continue
    
    # Get remote type
    remote_info=$(rclone config show "$remote_name" --config "$CONFIG_PATH")
    # echo $remote_info
    # press_enter_to_continue
    remote_type=$(echo "$remote_info" | grep "type =" | head -n1 | cut -d '=' -f 2 | tr -d ' ')
    # echo $remote_type
    # press_enter_to_continue
    
    # Skip types that do not support 'about' or are not needed
    case "$remote_type" in
        googlephotos|box|s3|ftp|http|alias|hasher)
            echo "$remote_name | $remote_type | 'about' not supported or not needed"
            continue
            ;;
        union)
            echo "$remote_name | $remote_type | Skipped (union of upstreams already checked)"
            continue
            ;;
    esac
    
    # For SFTP remotes, try to get disk space using SSH
    if [ "$remote_type" = "sftp" ]; then
        # Extract host and user from config
        host=$(echo "$remote_info" | grep "host =" | cut -d '=' -f 2 | tr -d ' ' | tr -d '*')
        user=$(echo "$remote_info" | grep "user =" | cut -d '=' -f 2 | tr -d ' ')
        key_file=$(echo "$remote_info" | grep "key_file =" | cut -d '=' -f 2 | tr -d ' ')
        
        # If we have host, user and key_file information, try SSH
        if [ -n "$host" ] && [ -n "$user" ] && [ -n "$key_file" ] && [ -f "$key_file" ]; then
            # Try to SSH and get disk space
            ssh_output=$(run_with_timeout 10s ssh -i "$key_file" -o StrictHostKeyChecking=no -o BatchMode=yes "$user@$host" "df -h / | tail -1 | awk '{print \$4}'" 2>/dev/null)
            
            if [ $? -eq 0 ] && [ -n "$ssh_output" ]; then
                echo "$remote_name | $remote_type | $ssh_output"
                # For successful free space retrieval:
                if [ -n "$ssh_output" ]; then
                    output_lines+=("$ssh_output|$remote_name | $remote_type | $ssh_output")
                else
                    # For lines where free space is not available, use 0 as the sort key
                    output_lines+=("0|$remote_name | $remote_type | $ssh_output")
                fi
            else
                echo "$remote_name | $remote_type | SSH connection failed"
            fi
        else
            echo "$remote_name | $remote_type | Missing SSH connection details"
        fi
    else
        # For non-SFTP remotes, try rclone about
        about_info=$(run_with_timeout 10s rclone about "${remote}" --json --config "$CONFIG_PATH" 2>/dev/null)
        # echo $about_info
        # press_enter_to_continue
        
        # Check if command succeeded
        if [ $? -eq 0 ] && [ -n "$about_info" ]; then
            # Try to extract free space from JSON
            free_space=$(echo "$about_info" | grep -o '"free":[^,}]*' | cut -d':' -f2)
            
            # If free space was found
            if [ -n "$free_space" ]; then
                # Convert bytes to human-readable format
                if [ "$free_space" -ge 1073741824 ]; then
                    free_human=$(echo "scale=2; $free_space/1073741824" | bc)" GB"
                    elif [ "$free_space" -ge 1048576 ]; then
                    free_human=$(echo "scale=2; $free_space/1048576" | bc)" MB"
                    elif [ "$free_space" -ge 1024 ]; then
                    free_human=$(echo "scale=2; $free_space/1024" | bc)" KB"
                else
                    free_human="$free_space B"
                fi
                echo "$remote_name | $remote_type | $free_human"
                # For successful free space retrieval:
                output_lines+=("$free_space|$remote_name | $remote_type | $free_human")
            else
                echo "$remote_name | $remote_type | Free space not reported"
            fi
        else
            echo "$remote_name | $remote_type | Not supported or timed out"
        fi
    fi
done

# Sort and print: most free space first
printf "%s\n" "${output_lines[@]}" | sort -t'|' -k1,1nr | cut -d'|' -f2-
