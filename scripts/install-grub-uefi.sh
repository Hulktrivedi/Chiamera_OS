#!/bin/bash
# install-grub-uefi.sh - Prepares GRUB EFI files for UEFI boot in ISO root

set -e

if [ $# -ne 1 ]; then
  echo "Usage: $0 <iso_root_path>"
  exit 1
fi

ISO_ROOT="$1"

echo "[*] Installing UEFI GRUB bootloader into ISO root: $ISO_ROOT"

EFI_BOOT_DIR="$ISO_ROOT/EFI/BOOT"
mkdir -p "$EFI_BOOT_DIR"

# Generate grubx64.efi for UEFI boot
grub-mkimage -o "$EFI_BOOT_DIR/BOOTx64.EFI" \
  -O x86_64-efi \
  -p "/boot/grub" \
  normal linux ext2 part_gpt part_msdos fat iso9660 configfile search echo

echo "[*] UEFI GRUB bootloader created at $EFI_BOOT_DIR/BOOTx64.EFI"
