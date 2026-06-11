#!/usr/bin/env bash
# Install Vite+
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/lib/helpers.sh"

if [[ -d "$HOME/.vite-plus" ]]; then
  success "Vite+ already installed, skipping"
  exit 0
fi

info "Installing Vite+..."
curl -fsSL https://vite.plus | bash
success "Vite+ installed"
