#!/bin/bash

ISO_NAME="ChimaeraOS"
ISO_BASE="iso/base"
ISO_OUTPUT="output"
ISO_LABEL="CHIMAERA_OS"

# Step 1: Prepare base ISO root
echo "[+] Cleaning previous builds..."
rm -rf "$ISO_OUTPUT"
mkdir -p "$ISO_OUTPUT"

# Step 2: Copy required base system files (assumes already setup)
echo "[+] Copying base filesystem..."
cp -a "$ISO_BASE" "$ISO_OUTPUT/"

# Step 3: Inject essential packages
echo "[+] Injecting required tools (Firejail, DPP)..."
mount --bind /dev "$ISO_BASE/dev"
chroot "$ISO_BASE" /bin/bash <<EOF
apt update
apt install -y firejail btrfs-progs rsync nano curl sudo
# Optional: install custom DPP tools from local .deb or binaries
# dpkg -i /opt/tools/dpp-recovery.deb
EOF
umount "$ISO_BASE/dev"

# Step 4: Setup bootloader, kernel, initrd
echo "[+] Setting up GRUB and kernel..."
grub-mkrescue -o "$ISO_NAME.iso" "$ISO_OUTPUT" --compress=xz

# Step 5: Move ISO to output directory
mv "$ISO_NAME.iso" "$ISO_OUTPUT/"
echo "[✓] ISO successfully built at $ISO_OUTPUT/$ISO_NAME.iso"
