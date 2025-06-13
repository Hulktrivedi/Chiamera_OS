#!/bin/bash

APP=$1
APP_NAME=$(basename "$APP")

if [[ -z "$APP" ]]; then
    echo "Usage: sandbox-launcher <app>"
    exit 1
fi

PROFILE_PATH="/etc/chimera/sandbox-profiles/${APP_NAME}.profile"
GENERIC_PROFILE="/etc/chimera/sandbox-profiles/read-only.profile"

if [[ -f "$PROFILE_PATH" ]]; then
    echo "[+] Using profile for $APP_NAME"
    exec firejail --profile="$PROFILE_PATH" "$APP"
else
    echo "[!] No app-specific profile found. Using generic sandbox."
    exec firejail --profile="$GENERIC_PROFILE" "$APP"
fi
