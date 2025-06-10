#!/bin/bash
set -euo pipefail

echo "==== CHIMAERE OS: HARD DISK PARTITIONING ===="

# Auto-detect available disks (excluding loop and CD-ROM)
echo "[INFO] Scanning available disks..."
AVAILABLE_DISKS=($(lsblk -dpno NAME,TYPE | grep "disk" | awk '{print $1}'))

if [ ${#AVAILABLE_DISKS[@]} -eq 0 ]; then
    echo "[ERROR] No disks found! Aborting."
    exit 1
fi

echo "[INFO] Found the following disks:"
for i in "${!AVAILABLE_DISKS[@]}"; do
    echo "  [$i] - ${AVAILABLE_DISKS[$i]}"
done

# Ask user to choose a disk
read -rp "Enter the number corresponding to the disk you want to partition (WARNING: All data will be lost): " SELECTED_INDEX
TARGET_DISK="${AVAILABLE_DISKS[$SELECTED_INDEX]}"

read -rp "Are you sure you want to format $TARGET_DISK? This will DELETE ALL DATA. (yes/[no]): " CONFIRM
if [[ "$CONFIRM" != "yes" ]]; then
    echo "Aborting by user request."
    exit 0
fi

# Wipe and create partitions
echo "[INFO] Wiping $TARGET_DISK..."
sgdisk --zap-all "$TARGET_DISK"

echo "[INFO] Creating partitions..."
# Partition layout:
# 1: DPP      - 1GB
# 2: SYSTEM   - 20GB
# 3: HOME     - user defined
# 4: DOWNLOAD - user defined

read -rp "Enter size for HOME partition (e.g. 30G): " HOME_SIZE
read -rp "Enter size for DOWNLOAD partition (e.g. 50G): " DOWNLOAD_SIZE

sgdisk -n1:0:+1G                 -t1:8300 -c1:"CH-DPP"      "$TARGET_DISK"
sgdisk -n2:0:+20G                -t2:8300 -c2:"CH-SYSTEM"   "$TARGET_DISK"
sgdisk -n3:0:+"$HOME_SIZE"       -t3:8300 -c3:"CH-HOME"     "$TARGET_DISK"
sgdisk -n4:0:+"$DOWNLOAD_SIZE"   -t4:8300 -c4:"CH-DOWNLOAD" "$TARGET_DISK"
partprobe "$TARGET_DISK"
sleep 2

echo "[INFO] Formatting partitions..."
mkfs.ext4 "${TARGET_DISK}1" -L CH_DPP
mkfs.ext4 "${TARGET_DISK}2" -L CH_SYSTEM
mkfs.ext4 "${TARGET_DISK}3" -L CH_HOME
mkfs.ext4 "${TARGET_DISK}4" -L CH_DOWNLOAD

# Export partition paths for install.sh to use
echo "CH_DPP=${TARGET_DISK}1" > /tmp/ch_partitions.conf
echo "CH_SYSTEM=${TARGET_DISK}2" >> /tmp/ch_partitions.conf
echo "CH_HOME=${TARGET_DISK}3" >> /tmp/ch_partitions.conf
echo "CH_DOWNLOAD=${TARGET_DISK}4" >> /tmp/ch_partitions.conf

echo "[SUCCESS] Partitions created and formatted. Continue using install.sh."
