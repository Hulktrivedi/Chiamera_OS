#!/bin/bash

set -e

UX_CONFIG="$1"

if [ -z "$UX_CONFIG" ] || [ ! -f "$UX_CONFIG" ]; then
  echo "[!] UX configuration file is missing or invalid: $UX_CONFIG"
  exit 1
fi

echo "[*] Applying soft partitioning based on UX style..."

# Source the UX configuration
source "$UX_CONFIG"

USER_HOME="/home/$USER"
SOFT_PARTITION_ROOT="${USER_HOME}/virtual_partitions"

# Cleanup existing soft partitions if any
if [ -d "$SOFT_PARTITION_ROOT" ]; then
  echo "[*] Cleaning up old virtual partitions..."
  rm -rf "$SOFT_PARTITION_ROOT"
fi

mkdir -p "$SOFT_PARTITION_ROOT"

for partition in "${!VIRTUAL_PARTITIONS[@]}"; do
  folder_name="${VIRTUAL_PARTITIONS[$partition]}"
  full_path="${SOFT_PARTITION_ROOT}/${folder_name}"
  mkdir -p "$full_path"
  echo "[+] Created soft partition: $full_path"
done

echo "[✓] Soft partitioning completed successfully using $UX_CONFIG."
