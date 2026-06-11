#!/usr/bin/env bash
# Install Claude Code CLI
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/lib/helpers.sh"

if command -v claude &>/dev/null; then
  success "Claude Code already installed, skipping"
  exit 0
fi

info "Installing Claude Code..."
curl -fsSL https://claude.ai/install.sh | bash
success "Claude Code installed"
