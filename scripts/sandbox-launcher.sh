#!/bin/bash
# File: scripts/sandbox-launcher.sh

CONFIG="$HOME/.chimera/sandbox-enabled.conf"
APP="$1"
ARGS="${@:2}"

if grep -Fxq "$APP" "$CONFIG"; then
    echo "[⚠] Launching $APP in sandbox..."
    firejail --profile=/etc/firejail/chimera-default.profile "$APP" $ARGS
else
    echo "[ℹ] Launching $APP without sandbox..."
    "$APP" $ARGS
fi
