#!/bin/bash

set -eo pipefail

# Check if both arguments are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <driver_file.tbz2> <rootfs_file.tbz2>"
    exit 1
fi

# Function to check if a directory exists
check_directory() {
    if [ -d "$1" ]; then
        echo 1
    else
        echo 0
    fi
}

# Extract the main driver file
driver_file="$1"
main_folder="Linux_for_Tegra"

# Check if the main folder already exists
if [ "$(check_directory "$main_folder")" -eq 1 ]; then
    echo "$main_folder already exists. Over-writing it may cause data loss."
else
    # Extract the contents
    echo "Extracting $driver_file ..."
    sudo tar -xvjf "$driver_file"

    # Check if extraction was successful
    if [ "$(check_directory "$main_folder")" -eq 0 ]; then
        echo "Error: $main_folder not found after extraction."
        exit 1
    else
        echo "Extraction complete: $driver_file."

        # Extract the rootfs file
        rootfs_file="$2"
        rootfs_folder="$main_folder/rootfs"

        # Check if the rootfs folder already exists
        if [ "$(check_directory "$rootfs_folder")" -eq 1 ]; then
            # Extract the rootfs file
            echo "Extracting $rootfs_file to $rootfs_folder ..."
            sudo tar -xvjf "$rootfs_file" -C "$rootfs_folder"
            echo "Extraction complete"

        else
            echo "rootfs folder already exists in $main_folder. Skipping rootfs extraction."
        fi
    fi
fi
