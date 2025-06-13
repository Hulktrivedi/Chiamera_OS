#!/bin/bash

MOUNT_POINT="$1"

if [[ -z "$MOUNT_POINT" || ! -d "$MOUNT_POINT" ]]; then
    echo "[!] Invalid or missing mount point."
    exit 1
fi

UX_STYLE_FILE="/tmp/ux_style.conf"

# Default to US style unless overridden
UX_STYLE="us-style"
if [[ -f ./configs/user_selected_ux.txt ]]; then
    UX_STYLE=$(cat ./configs/user_selected_ux.txt)
fi

case "$UX_STYLE" in
    us-style)
        cp ./configs/us-style.conf "$UX_STYLE_FILE"
        ;;
    mac-style)
        cp ./configs/mac-style.conf "$UX_STYLE_FILE"
        ;;
    linux-style)
        cp ./configs/linux-style.conf "$UX_STYLE_FILE"
        ;;
    *)
        echo "[!] Unknown UX style: $UX_STYLE"
        exit 1
        ;;
esac

# Apply the config inside the chroot
echo "[+] Applying $UX_STYLE settings inside chroot..."
cp "$UX_STYLE_FILE" "$MOUNT_POINT/etc/chimera_ux.conf"
