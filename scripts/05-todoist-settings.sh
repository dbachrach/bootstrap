#!/usr/bin/env bash
# Hide the Todoist menu bar item (Settings → Advanced → Show Todoist in menu bar).
# Todoist is Electron — settings live in a JSON file, not defaults. Merge the one
# key with jq so user-specific settings (shortcuts, startup) are preserved.
# Note: Todoist rewrites this file on quit, so skip if the app is running.
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/lib/helpers.sh"

settings="$HOME/Library/Application Support/Todoist/settings.json"

if [[ -f "$settings" ]] && [[ "$(jq -r '.show_in_menu_bar' "$settings")" == "false" ]]; then
  success "Todoist menu bar item already hidden, skipping"
  exit 0
fi

if pgrep -xq Todoist; then
  warn "Todoist is running — quit it and re-run, or it will overwrite this setting"
  exit 0
fi

info "Hiding Todoist menu bar item..."
mkdir -p "$(dirname "$settings")"
if [[ -f "$settings" ]]; then
  tmp="$(mktemp)"
  jq '.show_in_menu_bar = false' "$settings" > "$tmp"
  mv "$tmp" "$settings"
else
  printf '{\n\t"show_in_menu_bar": false\n}\n' > "$settings"
fi
success "Todoist menu bar item hidden"
