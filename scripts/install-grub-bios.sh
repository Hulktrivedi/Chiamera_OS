#!/bin/bash
# install-grub-bios.sh - Installs BIOS GRUB bootloader into ISO root and loop device

set -e

if [ $# -ne 2 ]; then
  echo "Usage: $0 <iso_root_path> <loop_device>"
  exit 1
fi

ISO_ROOT="$1"
LOOPDEV="$2"

echo "[*] Installing BIOS GRUB bootloader into ISO root: $ISO_ROOT"

# Create necessary directories
mkdir -p "$ISO_ROOT/boot/grub/i386-pc"

# Install GRUB core image and modules for BIOS boot into the ISO root
grub-install \
  --target=i386-pc \
  --boot-directory="$ISO_ROOT/boot" \
  --modules="normal part_msdos ext2 multiboot biosdisk" \
  --force \
  --no-floppy \
  --recheck \
  --root-directory="$ISO_ROOT" \
  "$LOOPDEV"

echo "[*] BIOS GRUB installed on loop device $LOOPDEV successfully."
