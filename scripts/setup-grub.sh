#!/bin/bash
# Setup GRUB bootloader for Chimera Linux ISO

set -e

ISO_ROOT="$1"
BOOT_DIR="$ISO_ROOT/boot"

echo "[*] Creating necessary directories..."
mkdir -p "$BOOT_DIR/grub"

echo "[*] Copying grub.cfg..."
cp ../../grub.cfg "$BOOT_DIR/grub/grub.cfg"

echo "[*] Copying kernel and initrd images..."
cp ../../iso/base/boot/vmlinuz-6.2.0-chimera "$BOOT_DIR/"
cp ../../iso/base/boot/initrd.img-6.2.0-chimera "$BOOT_DIR/"

# Placeholder for DPP kernel and initrd, if available
if [ -f "../../dpp/vmlinuz-dpp" ]; then
    cp ../../dpp/vmlinuz-dpp "$BOOT_DIR/"
fi
if [ -f "../../dpp/initrd-dpp.img" ]; then
    cp ../../dpp/initrd-dpp.img "$BOOT_DIR/"
fi

# Copy memtest if available
if [ -f "../../tools/memtest86+.bin" ]; then
    cp ../../tools/memtest86+.bin "$BOOT_DIR/"
fi

echo "[*] GRUB setup completed."
