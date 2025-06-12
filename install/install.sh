#!/bin/bash

set -e

# Constants
MOUNT_POINT="/mnt/chimera_root"
RECOMMENDED_TOOLS_URL="https://raw.githubusercontent.com/Hulktrivedi/Chiamera_OS/main/tools/recommended_tools.txt"

echo "[*] Starting Chimaera OS Installer..."

# Create mount point if it doesn't exist
mkdir -p "$MOUNT_POINT"

# STEP 1: Run partitioning scripts
echo "[+] Partitioning the disk..."
./scripts/hard_partitioning.sh

# STEP 2: Mount partitions
echo "[+] Mounting root partition..."
mount /dev/sdX1 "$MOUNT_POINT"  # Replace with actual detection logic or variables

# STEP 3: Install base system (Debian-based for example)
echo "[+] Installing base system..."
debootstrap stable "$MOUNT_POINT" http://deb.debian.org/debian

# STEP 4: Apply UX-specific config
echo "[+] Applying user style configuration..."
./scripts/ux-config-parser.sh "$MOUNT_POINT"

# STEP 5: Install essential tools in chroot
echo "[+] Installing base tools in chroot..."
chroot "$MOUNT_POINT" /bin/bash <<EOF
apt update
apt install -y firejail btrfs-progs rsync sudo curl
EOF

# STEP 6: Optional community-recommended tools
echo ""
read -p "Would you like to install community-recommended tools? (y/n): " USER_CHOICE

if [[ "$USER_CHOICE" =~ ^[Yy]$ ]]; then
    echo "[+] Checking internet connectivity..."
    if ping -c 1 google.com &>/dev/null; then
        echo "[+] Internet is available. Fetching recommended tools list..."
        curl -s "$RECOMMENDED_TOOLS_URL" -o /tmp/tools.txt

        if [[ -s /tmp/tools.txt ]]; then
            echo "Here are some tools you can install:"
            cat /tmp/tools.txt | nl
            echo "Enter tool numbers separated by space (e.g., 1 4 5), or leave blank to skip:"
            read -a selections

            for index in "${selections[@]}"; do
                TOOL=$(sed "${index}q;d" /tmp/tools.txt)
                echo "[+] Installing $TOOL..."
                chroot "$MOUNT_POINT" apt install -y "$TOOL"
            done
        else
            echo "[!] Could not fetch the tool list. Skipping..."
        fi
    else
        echo "[!] No internet connection. Skipping optional tools installation."
    fi
fi

# STEP 7: Configure sandbox launcher
echo "[+] Setting up sandbox launcher..."
cp scripts/sandbox-launcher.sh "$MOUNT_POINT/usr/local/bin/sandbox-launcher"
chmod +x "$MOUNT_POINT/usr/local/bin/sandbox-launcher"

# STEP 8: Finish installation
echo "[✓] Installation complete! You may now reboot."
