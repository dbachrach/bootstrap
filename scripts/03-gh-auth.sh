#!/usr/bin/env bash
# Authenticate GitHub CLI — this also handles SSH key generation and upload

if gh auth status &>/dev/null; then
  echo "GitHub CLI already authenticated, skipping"
  exit 0
fi

echo "Authenticating GitHub CLI..."
echo "This will open a browser to complete authentication."
echo "When prompted, choose SSH and let gh generate and upload your key."
echo ""
gh auth login --git-protocol ssh
