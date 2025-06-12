#!/usr/bin/env python3

import os
import yaml
import sys
import time

# === Config Paths ===
PROFILE_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), "../configs/dpp-profiles"))
PREFERENCE_FILE = os.path.expanduser("~/.chimera_selected_ux")

# === Utilities ===
def clear_screen():
    os.system('cls' if os.name == 'nt' else 'clear')

def slowprint(text, delay=0.02):
    for c in text:
        print(c, end='', flush=True)
        time.sleep(delay)
    print()

def list_profiles():
    return [f for f in os.listdir(PROFILE_DIR) if f.endswith(".yml")]

def load_profile(profile_name):
    file_path = os.path.join(PROFILE_DIR, profile_name)
    with open(file_path, 'r') as f:
        return yaml.safe_load(f)

def save_user_choice(profile_name):
    with open(PREFERENCE_FILE, 'w') as f:
        f.write(profile_name)

def read_saved_choice():
    if os.path.exists(PREFERENCE_FILE):
        with open(PREFERENCE_FILE, 'r') as f:
            return f.read().strip()
    return None

def apply_profile(profile):
    slowprint(f"\n🔧 Applying profile: {profile['profile_name'].capitalize()}...")
    print(f"→ Description: {profile.get('description', 'No description')}")
    print(f"→ Default DE: {profile.get('default_de')}")
    print(f"→ Theme: {profile.get('ux_theme')}")
    print(f"→ Filesystem Emulation: {profile.get('filesystem_emulation')}")
    print(f"→ Sandbox Profile: {profile.get('sandbox_profile')}")
    print(f"→ Firewall Mode: {profile.get('firewall_mode')}")
    print("✅ Profile loaded successfully.\n")
    # Simulate integration flags (to be extended with real actions)
    with open("/tmp/chimera_profile_flags", "w") as f:
        f.write(f"UX={profile['profile_name']}\n")
        f.write(f"DE={profile['default_de']}\n")
        f.write(f"THEME={profile['ux_theme']}\n")
    return True

def prompt_user_choice():
    slowprint("👋 Welcome to Chimera OS Dynamic Profile Setup\n")
    profiles = list_profiles()
    if not profiles:
        print("❌ No profiles found in config directory.")
        sys.exit(1)

    print("Please choose your preferred UX environment:")
    for idx, prof in enumerate(profiles):
        profile_data = load_profile(prof)
        print(f"  [{idx + 1}] {profile_data['profile_name'].capitalize()} - {profile_data.get('description', 'No details')}")

    while True:
        choice = input("Enter the number of your choice [1-{}]: ".format(len(profiles)))
        if choice.isdigit() and 1 <= int(choice) <= len(profiles):
            return profiles[int(choice) - 1]
        else:
            print("⚠️ Invalid input. Try again.")

# === Main Execution ===
def main():
    clear_screen()

    saved = read_saved_choice()
    if saved:
        profile_path = os.path.join(PROFILE_DIR, saved)
        if os.path.exists(profile_path):
            print(f"📌 Using previously saved UX profile: {saved}")
            profile = load_profile(saved)
            apply_profile(profile)
            return
        else:
            print("⚠️ Saved profile not found. Re-selecting...")

    # Prompt user
    selected = prompt_user_choice()
    save_user_choice(selected)
    profile = load_profile(selected)
    apply_profile(profile)

if __name__ == "__main__":
    main()
