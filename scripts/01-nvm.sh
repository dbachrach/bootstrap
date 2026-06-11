#!/usr/bin/env bash
# Install nvm if not already present
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/lib/helpers.sh"

NVM_DIR="$HOME/.nvm"

if [[ -d "$NVM_DIR" ]]; then
  success "nvm already installed, skipping"
  exit 0
fi

info "Installing nvm..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/HEAD/install.sh | bash

# Load nvm for the rest of this script (nvm.sh references unset variables,
# so relax `set -u` while it's in play)
export NVM_DIR="$HOME/.nvm"
set +u
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

info "Installing latest LTS Node..."
nvm install --lts
nvm use --lts
nvm alias default 'lts/*'
set -u

success "nvm + Node LTS installed"
