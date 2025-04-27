#!/bin/bash

CONFIG_PATH="$HOME/Lab_Data/configurations-private/rclone.conf"

echo "Fetching free space for all remotes (this may take some time)..."
echo "--------------------------------------------------------------"
echo "REMOTE | FREE SPACE"
echo "--------------------------------------------------------------"

# Get list of remotes
remotes=$(rclone listremotes --config "$CONFIG_PATH")

for remote in $remotes; do
  # Remove trailing colon from remote name
  remote_name=${remote%:}
  
  # Try to get about info with timeout to prevent hanging
  about_info=$(timeout 10s rclone about "${remote}" --json --config "$CONFIG_PATH" 2>/dev/null)
  
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
      echo "$remote_name | $free_human"
    else
      echo "$remote_name | Free space not reported"
    fi
  else
    echo "$remote_name | Not supported or timed out"
  fi
done

echo "--------------------------------------------------------------"
echo "Note: Some remotes may not support the 'about' command or timed out."
