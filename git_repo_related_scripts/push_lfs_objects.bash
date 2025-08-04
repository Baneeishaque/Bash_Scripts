#!/bin/bash

# Function to push a single LFS object
push_lfs_object() {
    local object_id=$1
    local file_name=$2
    local status=$3
    
    echo "Pushing LFS object:"
    echo "  ID: $object_id"
    echo "  File: $file_name"
    echo "  Status: $status"
    
    git lfs push --object-id origin "$object_id"
    local push_status=$?
    
    if [ $push_status -eq 0 ]; then
        echo "✓ Successfully pushed"
    else
        echo "✗ Failed to push"
    fi
    echo "----------------------------------------"
}

# Print header
echo "Starting LFS object push process..."
echo "----------------------------------------"

# Get all object IDs marked with asterisk
echo "Finding LFS objects marked with '*'..."
git lfs ls-files -l | grep "\*" | while read -r line; do
    # Extract object ID (first column)
    object_id=$(echo "$line" | awk '{print $1}')
    # Extract status (second column)
    status=$(echo "$line" | awk '{print $2}')
    # Extract filename (remaining columns after the second column)
    file_name=$(echo "$line" | cut -d' ' -f4-)
    
    push_lfs_object "$object_id" "$file_name" "$status"
done

echo "Completed pushing all marked LFS objects"
