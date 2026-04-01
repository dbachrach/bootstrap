#!/usr/bin/env bash
# Install nvm if not already present

NVM_DIR="$HOME/.nvm"

if [[ -d "$NVM_DIR" ]]; then
  echo "nvm already installed, skipping"
  exit 0
fi

echo "Installing nvm..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/HEAD/install.sh | bash

# Load nvm for the rest of this script
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

echo "Installing latest LTS Node..."
nvm install --lts
nvm use --lts
nvm alias default 'lts/*'

echo "nvm + Node LTS installed"
