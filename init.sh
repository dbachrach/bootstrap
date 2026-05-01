#!/usr/bin/env bash
# Run this on a fresh Mac to clone the repo and kick off bootstrap:
#   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/dbachrach/bootstrap/main/init.sh)"
set -euo pipefail

REPO_URL="https://github.com/dbachrach/bootstrap.git"
DEST="$HOME/code/bootstrap"

# ── Colors ────────────────────────────────────────────────────────────────────
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m'

info()    { echo -e "${BLUE}==>${NC} $*"; }
success() { echo -e "${GREEN}  ✓${NC} $*"; }

# ── Xcode Command Line Tools ──────────────────────────────────────────────────
info "Checking Xcode Command Line Tools..."
if ! xcode-select -p &>/dev/null; then
  info "Installing Xcode Command Line Tools..."
  xcode-select --install
  until xcode-select -p &>/dev/null; do sleep 5; done
fi
success "Xcode CLT ready"

# ── Clone ─────────────────────────────────────────────────────────────────────
if [[ -d "$DEST" ]]; then
  info "Repo already exists at $DEST, pulling latest..."
  git -C "$DEST" pull --ff-only
else
  info "Cloning bootstrap repo..."
  mkdir -p "$HOME/code"
  git clone "$REPO_URL" "$DEST"
fi
success "Repo ready at $DEST"

# ── Run bootstrap ─────────────────────────────────────────────────────────────
exec "$DEST/bootstrap.sh"
