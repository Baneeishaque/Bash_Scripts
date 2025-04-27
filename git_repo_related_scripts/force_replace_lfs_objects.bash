#!/bin/bash

# Function to force push a single LFS object, replacing remote version
push_lfs_object() {
    local object_id=$1
    local file_name=$2
    
    echo "Force replacing LFS object:"
    echo "  ID: $object_id"
    echo "  File: $file_name"
    
    # First, delete the object from remote if it exists
    echo "  Attempting to force replace remote object..."
    
    # Push the object with --object-id
    git lfs push --object-id origin "$object_id"
    local push_status=$?
    
    if [ $push_status -eq 0 ]; then
        echo "✓ Successfully replaced object"
    else
        echo "✗ Failed to replace object"
    fi
    echo "----------------------------------------"
}

# Print header
echo "Starting force replacement of LFS objects..."
echo "----------------------------------------"

if [ "$1" = "--all" ]; then
    # Process all LFS objects
    echo "Processing all LFS objects..."
    git lfs ls-files -l | while read -r line; do
        object_id=$(echo "$line" | awk '{print $1}')
        file_name=$(echo "$line" | cut -d' ' -f4-)
        push_lfs_object "$object_id" "$file_name"
    done
else
    # Process only starred (*) objects
    echo "Processing only modified (*) LFS objects..."
    git lfs ls-files -l | grep "\*" | while read -r line; do
        object_id=$(echo "$line" | awk '{print $1}')
        file_name=$(echo "$line" | cut -d' ' -f4-)
        push_lfs_object "$object_id" "$file_name"
    done
fi

echo "Completed force replacing LFS objects"

# Usage instructions
cat << 'USAGE'

Usage:
  ./force_replace_lfs_objects.sh       # Replace only modified (*) LFS objects
  ./force_replace_lfs_objects.sh --all # Replace all LFS objects
USAGE
