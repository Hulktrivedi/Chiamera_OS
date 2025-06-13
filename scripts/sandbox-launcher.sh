#!/bin/bash

APP=$1

if [[ -z "$APP" ]]; then
    echo "Usage: sandbox-launcher <app>"
    exit 1
fi

echo "[+] Launching $APP in sandbox..."
exec firejail --noprofile --net=none "$APP"
