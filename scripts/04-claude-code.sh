#!/usr/bin/env bash
# Install Claude Code CLI

if command -v claude &>/dev/null; then
  echo "Claude Code already installed, skipping"
  exit 0
fi

echo "Installing Claude Code..."
curl -fsSL https://claude.ai/install.sh | bash
echo "Claude Code installed"
