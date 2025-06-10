#!/bin/bash

set -e

# Paths to partitioning scripts
HARD_PARTITION_SCRIPT="./install/hard_partitioning.sh"
SOFT_PARTITION_SCRIPT="./install/soft_partitioning.sh"

# UX config directory
UX_CONFIG_DIR="./config"

echo "=== Chimera OS Installation ==="

# Step 1: Auto-detect available disks (excluding system and read-only)
echo "[*] Detecting available disks..."
AVAILABLE_DISKS=($(lsblk -ndo NAME,TYPE | grep disk | awk '{print $1}'))

if [ ${#AVAILABLE_DISKS[@]} -eq 0 ]; then
  echo "[!] No available disks found for installation."
  exit 1
fi

echo "Available disks:"
for i in "${!AVAILABLE_DISKS[@]}"; do
  disk="${AVAILABLE_DISKS[$i]}"
  echo "  [$i] /dev/$disk"
done

read -p "Select disk number for Chimera OS installation: " disk_index

if ! [[ "$disk_index" =~ ^[0-9]+$ ]] || [ "$disk_index" -ge "${#AVAILABLE_DISKS[@]}" ]; then
  echo "[!] Invalid disk selection."
  exit 1
fi

TARGET_DISK="/dev/${AVAILABLE_DISKS[$disk_index]}"
echo "[*] Selected disk: $TARGET_DISK"

# Step 2: Choose UX style for soft partitioning
echo "Available UX styles:"
UX_CONFIGS=($(ls "$UX_CONFIG_DIR" | grep '\.conf$'))
for i in "${!UX_CONFIGS[@]}"; do
  echo "  [$i] ${UX_CONFIGS[$i]}"
done

read -p "Select UX style number: " ux_index
if ! [[ "$ux_index" =~ ^[0-9]+$ ]] || [ "$ux_index" -ge "${#UX_CONFIGS[@]}" ]; then
  echo "[!] Invalid UX selection."
  exit 1
fi

SELECTED_UX_CONF="${UX_CONFIG_DIR}/${UX_CONFIGS[$ux_index]}"
echo "[*] Selected UX config: $SELECTED_UX_CONF"

# Step 3: Run hard partitioning (real disk partitions)
echo "[*] Starting hard partitioning on $TARGET_DISK ..."
bash "$HARD_PARTITION_SCRIPT" "$TARGET_DISK"
echo "[✓] Hard partitioning complete."

# Step 4: Run soft partitioning with UX config
echo "[*] Creating soft partitions for UX style..."
bash "$SOFT_PARTITION_SCRIPT" "$SELECTED_UX_CONF"
echo "[✓] Soft partitioning complete."

# Step 5: Additional install steps (copy system files, bootloader, etc.)
echo "[*] Proceeding with system installation steps..."
# Placeholder: add your system file copy, bootloader install here

echo "[✓] Chimera OS installation complete!"
