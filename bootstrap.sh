#!/usr/bin/env bash
set -euo pipefail

BOOTSTRAP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── Colors ────────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info()    { echo -e "${BLUE}==>${NC} $*"; }
success() { echo -e "${GREEN}  ✓${NC} $*"; }
warn()    { echo -e "${YELLOW}  !${NC} $*"; }
error()   { echo -e "${RED}  ✗${NC} $*" >&2; }

# ── Xcode Command Line Tools ──────────────────────────────────────────────────
install_xcode_tools() {
  info "Checking Xcode Command Line Tools..."
  if xcode-select -p &>/dev/null; then
    success "Xcode CLT already installed"
    return
  fi
  info "Installing Xcode Command Line Tools..."
  xcode-select --install
  # Wait for installation to complete
  until xcode-select -p &>/dev/null; do sleep 5; done
  success "Xcode CLT installed"
}

# ── Homebrew ──────────────────────────────────────────────────────────────────
install_homebrew() {
  info "Checking Homebrew..."
  if command -v brew &>/dev/null; then
    success "Homebrew already installed"
  else
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add brew to PATH for Apple Silicon
    if [[ -f /opt/homebrew/bin/brew ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    success "Homebrew installed"
  fi

  info "Updating Homebrew..."
  brew update --quiet
  success "Homebrew up to date"
}

install_brewfile() {
  local brewfile="$BOOTSTRAP_DIR/Brewfile"
  if [[ ! -f "$brewfile" ]]; then
    warn "No Brewfile found, skipping"
    return
  fi
  info "Installing packages from Brewfile..."
  brew bundle --file="$brewfile" --no-lock
  success "Brewfile packages installed"
}

# ── Dotfiles ──────────────────────────────────────────────────────────────────
install_dotfiles() {
  local dotfiles_dir="$BOOTSTRAP_DIR/dotfiles"
  if [[ ! -d "$dotfiles_dir" ]]; then
    warn "No dotfiles/ directory found, skipping"
    return
  fi

  info "Symlinking dotfiles..."
  # Walk all files recursively; create dirs, symlink files
  find "$dotfiles_dir" -mindepth 1 | while read -r file; do
    local rel="${file#$dotfiles_dir/}"
    local target="$HOME/$rel"

    if [[ -d "$file" ]]; then
      mkdir -p "$target"
      continue
    fi

    if [[ -e "$target" && ! -L "$target" ]]; then
      warn "$rel already exists and is not a symlink — backing up to ${rel}.bak"
      mv "$target" "${target}.bak"
    fi

    ln -sf "$file" "$target"
    success "Linked ~/$rel"
  done
}

# ── macOS Defaults ────────────────────────────────────────────────────────────
apply_macos_defaults() {
  local script="$BOOTSTRAP_DIR/macos/defaults.sh"
  if [[ ! -f "$script" ]]; then
    warn "No macos/defaults.sh found, skipping"
    return
  fi
  info "Applying macOS defaults..."
  bash "$script"
  success "macOS defaults applied"
}

# ── Extra Scripts ─────────────────────────────────────────────────────────────
run_scripts() {
  local scripts_dir="$BOOTSTRAP_DIR/scripts"
  if [[ ! -d "$scripts_dir" ]]; then
    warn "No scripts/ directory found, skipping"
    return
  fi

  info "Running setup scripts..."
  for script in "$scripts_dir"/*.sh; do
    [[ -f "$script" ]] || continue
    info "  Running $(basename "$script")..."
    bash "$script"
    success "  $(basename "$script") complete"
  done
}

# ── Main ──────────────────────────────────────────────────────────────────────
main() {
  echo ""
  echo "  Mac Bootstrap"
  echo "  ─────────────"
  echo ""

  install_xcode_tools
  install_homebrew
  install_brewfile
  install_dotfiles
  apply_macos_defaults
  run_scripts

  echo ""
  success "Bootstrap complete!"
  warn "See MANUAL.md for any remaining steps that require manual setup."
  echo ""
}

main "$@"
