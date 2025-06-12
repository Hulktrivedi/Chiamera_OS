#!/bin/bash

# Load active profile
ACTIVE_PROFILE_PATH="configs/dpp-profiles/$(cat /etc/chimaera/active_profile).yml"

# Extract sandbox_profile using yq (YAML processor)
SANDBOX_PROFILE=$(yq e '.sandbox_profile' "$ACTIVE_PROFILE_PATH")

echo "[INFO] Launching app '$1' with sandbox profile: $SANDBOX_PROFILE"

# Check if firejail profile exists
FIREJAIL_PROFILE_PATH="configs/firejail/$SANDBOX_PROFILE.profile"

if [[ -f "$FIREJAIL_PROFILE_PATH" ]]; then
    firejail --profile="$FIREJAIL_PROFILE_PATH" "$1"
else
    echo "[WARN] Profile not found. Launching without sandbox."
    "$1"
fi
