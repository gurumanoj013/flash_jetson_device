#!/bin/bash

set -eo pipefail

# Default values
download_jetpack="false"
extract_jetpack="false"
new_user_name="agx"
new_password="mrobotics"
driver_file="jetpack_driver.tbz2"
rootfs_file="jetpack_rootfs.tbz2"
# driver_file="jetson_linux_r35.4.1_aarch64.tbz2"
# rootfs_file="tegra_linux_sample-root-filesystem_r35.4.1_aarch64.tbz2"

# Function to handle arguments
handle_arguments() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --extract_jetpack=true)
                extract_jetpack="true"
                shift
                ;;
            --extract_jetpack=false)
                extract_jetpack="false"
                shift
                ;;
            --driver_file=*)
                driver_file="${1#*=}"
                shift
                ;;
            --rootfs_file=*)
                rootfs_file="${1#*=}"
                shift
                ;;
            --download_jetpack=true)
                download_jetpack="true"
                shift
                ;;
            --download_jetpack=false)
                download_jetpack="false"
                shift
                ;;
             --new_user_name=*)
                new_user_name="${1#*=}"
                shift
                ;;
            --new_password=*)
                new_password="${1#*=}"
                shift
                ;;
            *)
                echo "Invalid argument: $1"
                exit 1
                ;;
        esac
    done
}

# Handle arguments if provided
if [[ $# -gt 0 ]]; then
    handle_arguments "$@"
fi

# If download_jetpack is true, run download_jetpack.sh
if [[ "$download_jetpack" == "true" ]]; then
    ./download_jetpack.sh
fi

# Check if extract_jetpack is true and run extractor.sh
if [[ "$extract_jetpack" == "true" ]]; then
    ./extract_jetpack.sh "$driver_file" "$rootfs_file"
else
    echo "using existing Jetson files."
fi

# Navigate to the Linux_for_Tegra directory
cd Linux_for_Tegra

# Install the prerequisites for using L4T flash tools
sudo ./tools/l4t_flash_prerequisites.sh

# Setting User ID & Password
# sudo ./tools/l4t_create_default_user.sh -u "$new_user_name" -p "$new_password"

# Run the apply_binaries.sh script
sudo ./apply_binaries.sh

# Put the device into recovery mode, then generate qspi only images for the internal device
sudo ./tools/kernel_flash/l4t_initrd_flash.sh --no-flash jetson-agx-xavier-devkit internal

# Put the device into recovery mode, then generate a normal filesystem for the external device
sudo ./tools/kernel_flash/l4t_initrd_flash.sh --no-flash \
    --external-device nvme0n1p1 \
    -c ./tools/kernel_flash/flash_l4t_external.xml \
    --external-only --append jetson-agx-xavier-devkit external

# Flash the both images to Jetson
sudo ./tools/kernel_flash/l4t_initrd_flash.sh --flash-only
