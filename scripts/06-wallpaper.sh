#!/usr/bin/env bash
# Set the desktop wallpaper to the image stored in the repo.
# First run may prompt to allow Terminal to control System Events
# (Automation permission).
set -euo pipefail
repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$repo_root/lib/helpers.sh"

dest="$repo_root/macos/wallpaper/redbull.jpg"

current="$(osascript -e 'tell application "System Events" to get picture of first desktop' 2>/dev/null || true)"
if [[ "$current" == "$dest" ]]; then
  success "Wallpaper already set, skipping"
  exit 0
fi

info "Setting wallpaper..."
osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$dest\""
success "Wallpaper set"
