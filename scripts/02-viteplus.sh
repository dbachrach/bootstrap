#!/usr/bin/env bash
# Install Vite+

if [[ -d "$HOME/.vite-plus" ]]; then
  echo "Vite+ already installed, skipping"
  exit 0
fi

echo "Installing Vite+..."
curl -fsSL https://vite.plus | bash
echo "Vite+ installed"
