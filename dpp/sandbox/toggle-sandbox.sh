#!/bin/bash

CONFIG="$HOME/.chimera/sandbox-enabled.conf"
APP="$1"

if [[ "$1" == "enable" && "$2" ]]; then
    echo "$2" >> "$CONFIG"
    echo "[✔] Sandbox enabled for $2"
elif [[ "$1" == "disable" && "$2" ]]; then
    sed -i "/^$2$/d" "$CONFIG"
    echo "[✘] Sandbox disabled for $2"
elif [[ "$1" == "status" ]]; then
    echo "=== Sandbox Enabled For ==="
    cat "$CONFIG"
else
    echo "Usage:"
    echo "  $0 enable <app>"
    echo "  $0 disable <app>"
    echo "  $0 status"
fi
