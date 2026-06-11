#!/usr/bin/env bash
# Authenticate GitHub CLI — this also handles SSH key generation and upload
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/lib/helpers.sh"

if gh auth status &>/dev/null; then
  success "GitHub CLI already authenticated, skipping"
  exit 0
fi

info "Authenticating GitHub CLI..."
echo "This will open a browser to complete authentication."
echo "When prompted, choose SSH and let gh generate and upload your key."
echo ""
gh auth login --git-protocol ssh
