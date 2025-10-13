#!/bin/bash
# Assign arguments
source_dir="output"
dest_dir=".."

# Check if source directory exists
if [ ! -d "$source_dir" ]; then
    echo "Error: Source directory '$source_dir' does not exist."
    exit 1
fi

# Create destination directory if it doesn't exist
mkdir -p "$dest_dir"

# If no subdirectory arguments are provided, copy all subdirectories
if [ "$#" -eq 0 ]; then
    echo "No substrings specified. Copying all subdirectories from '$source_dir' to '$dest_dir'..."
    for subdir in "$source_dir"/*/ ; do
        if [ -d "$subdir" ]; then
            subdir_name=$(basename "$subdir")
            echo "Copying '$subdir_name' to '$dest_dir'..."
            cp -r "$subdir" "$dest_dir/"
        fi
    done
else
    # Copy subdirectories whose names contain any of the provided substrings
    copied=0
    for subdir in "$source_dir"/*/ ; do
        if [ -d "$subdir" ]; then
            subdir_name=$(basename "$subdir")
            for substring in "$@"; do
                if [[ "$subdir_name" == *"$substring"* ]]; then
                    echo "Copying '$subdir_name' to '$dest_dir'..."
                    cp -r "$subdir" "$dest_dir/"
                    copied=$((copied + 1))
                    break
                fi
            done
        fi
    done
    if [ "$copied" -eq 0 ]; then
        echo "Warning: No subdirectories found in '$source_dir' matching any provided substrings."
    fi
fi

echo "Copy operation completed."
