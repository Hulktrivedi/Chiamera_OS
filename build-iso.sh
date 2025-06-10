#!/bin/bash
# build-iso.sh - Build Chimera OS ISO with BIOS and UEFI boot support, including DPP integration placeholder

set -e
set -o pipefail

# Configurable paths (adjust as needed)
ISO_ROOT="iso/base"
ISO_OUTPUT="chimeraos.iso"
KERNEL_IMAGE="vmlinuz"           # should exist in $ISO_ROOT/boot/
INITRD_IMAGE="initrd.img"        # should exist in $ISO_ROOT/boot/
GRUB_CFG="$ISO_ROOT/boot/grub/grub.cfg"
DPP_PLACEHOLDER="$ISO_ROOT/dpp"  # DPP directory inside ISO root

# Check dependencies
command -v grub-install >/dev/null 2>&1 || { echo "grub-install required but not found."; exit 1; }
command -v grub-mkimage >/dev/null 2>&1 || { echo "grub-mkimage required but not found."; exit 1; }
command -v xorriso >/dev/null 2>&1 || { echo "xorriso required but not found."; exit 1; }

echo "[*] Cleaning previous ISO root contents..."
rm -rf "$ISO_ROOT"/*
mkdir -p "$ISO_ROOT/boot/grub"
mkdir -p "$ISO_ROOT/EFI/BOOT"

echo "[*] Copying kernel and initrd images..."
# Here you should place your actual compiled kernel and initrd
# For demo, assuming files already exist in 'kernel/' directory
cp kernel/vmlinuz "$ISO_ROOT/boot/vmlinuz"
cp kernel/initrd.img "$ISO_ROOT/boot/initrd.img"

echo "[*] Adding DPP placeholder directory..."
mkdir -p "$DPP_PLACEHOLDER"
# Add recovery and decryptor tools here as needed, or keep empty for now

echo "[*] Creating GRUB configuration..."
cat > "$GRUB_CFG" <<'EOF'
set timeout=5
set default=0

menuentry "ChimeraOS - Normal Boot" {
    linux /boot/vmlinuz quiet splash
    initrd /boot/initrd.img
}

menuentry "ChimeraOS - Boot into Doomsday Protocol (DPP)" {
    linux /boot/vmlinuz quiet splash dpp-mode=1
    initrd /boot/initrd.img
}

menuentry "Memory Test (memtest86+)" {
    linux16 /boot/memtest86+.bin
}
EOF

echo "[*] Setting up UEFI GRUB bootloader..."
./scripts/install-grub-uefi.sh "$ISO_ROOT"

echo "[*] Creating ISO image with xorriso..."
xorriso -as mkisofs \
  -iso-level 3 \
  -full-iso9660-filenames \
  -volid "CHIMERA_OS" \
  -output "$ISO_OUTPUT" \
  -eltorito-boot boot/grub/i386-pc/eltorito.img \
  -eltorito-catalog boot/grub/boot.cat \
  -no-emul-boot \
  -boot-load-size 4 \
  -boot-info-table \
  -eltorito-alt-boot \
  -e EFI/BOOT/BOOTx64.EFI \
  -no-emul-boot \
  "$ISO_ROOT"

echo "[*] ISO image created: $ISO_OUTPUT"

echo "[*] Attaching ISO to loop device for BIOS GRUB installation..."
LOOPDEV=$(losetup --find --show "$ISO_OUTPUT")
echo "[*] Loop device: $LOOPDEV"

echo "[*] Installing BIOS GRUB bootloader on loop device..."
./scripts/install-grub-bios.sh "$ISO_ROOT" "$LOOPDEV"

echo "[*] Detaching loop device..."
losetup -d "$LOOPDEV"

echo "[*] Build process completed successfully!"
