# Jetson AGX Xavier Flashing Scripts

This repository contains a set of bash scripts to automate the process of downloading, extracting, and flashing the Jetson AGX Xavier development kit with the latest Jetpack release from NVIDIA.

## Prerequisites

- Ubuntu Linux host system
- Internet connection
- Jetson AGX Xavier development kit

## Scripts

### 1. `download_jetpack.sh`

This script downloads the Jetson Driver Package and the Sample Root File System from the NVIDIA website. It uses `wget` to download the files.

### 2. `extract_jetpack.sh`

This script extracts the contents of the downloaded Driver Package and Root File System archives. It checks if the main `Linux_for_Tegra` directory exists, and if not, it creates it and extracts the contents of the Driver Package. It then extracts the Root File System into the `rootfs` subdirectory within `Linux_for_Tegra`.

Usage: `./extract_jetpack.sh <driver_file.tbz2> <rootfs_file.tbz2>`

### 3. `flash_jetson_nvme.sh`

This is the main script that handles the entire flashing process. It provides several options:

- `--download_jetpack=true/false`: Download the Jetpack files (default: `false`)
- `--extract_jetpack=true/false`: Extract the downloaded Jetpack files (default: `false`)
- `--driver_file=<file>`: Specify the Driver Package file (default: `jetpack_driver.tbz2`)
- `--rootfs_file=<file>`: Specify the Root File System file (default: `jetpack_rootfs.tbz2`)
- `--new_user_name=<name>`: Set the username for the new user (default: `agx`)
- `--new_password=<password>`: Set the password for the new user (default: `mrobotics`)

The script performs the following steps:

1. Handles the provided arguments and sets the corresponding variables.
2. If `--download_jetpack=true`, it runs the `download_jetpack.sh` script to download the Jetpack files.
3. If `--extract_jetpack=true`, it runs the `extract_jetpack.sh` script to extract the downloaded files.
4. Navigate to the `Linux_for_Tegra` directory.
5. Installs the prerequisites for using the L4T flash tools.
6. Sets the user ID and password (optional).
7. Runs the `apply_binaries.sh` script to apply the binary files.
8. Generates the necessary images for flashing the internal and external devices.
9. Flashes the generated images to the Jetson AGX Xavier development kit.

## Usage

1. Clone this repository to your Ubuntu host system.
2. Connect the Jetson AGX Xavier development kit to your host system. (Make sure that Jetson device is in recovery mode)
3. Make the scripts executable
   ```bash
   sudo chmod +x download_jetpack.sh extract_jetpack.sh flash_jetson_nvme.sh
   ```
4. Run the `flash_jetson_nvme.sh` script with the desired options:

   ```bash
   sudo ./flash_jetson_nvme.sh [--download_jetpack=true/false] [--extract_jetpack=true/false] [--driver_file=<file>] [--rootfs_file=<file>] [--new_user_name=<name>] [--new_password=<password>]
   ```

   Example-1: The below example will download , extract and flash the Jetson device 
   ```bash
   sudo ./flash_jetson_nvme.sh --download_jetpack=true --extract_jetpack=true
   ```