#!/usr/bin/env bash
set -euo pipefail

BOOTSTRAP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── Colors ────────────────────────────────────────────────────────────────────
source "$BOOTSTRAP_DIR/lib/helpers.sh"

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

# ── Git Submodules ────────────────────────────────────────────────────────────
init_submodules() {
  info "Checking git submodules..."
  git -C "$BOOTSTRAP_DIR" submodule update --init --recursive
  success "Submodules ready"
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
  brew bundle --file="$brewfile"
  success "Brewfile packages installed"
}

# ── Dotfiles ──────────────────────────────────────────────────────────────────
install_dotfiles() {
  if [[ ! -d "$BOOTSTRAP_DIR/dotfiles" ]]; then
    warn "No dotfiles/ directory found, skipping"
    return
  fi

  info "Symlinking dotfiles with stow..."
  # --no-folding: symlink individual files, not whole directories. A folded
  # directory (e.g. ~/.config → repo) makes apps write live state — including
  # credentials — into the repo working tree.
  stow --no-folding --dir="$BOOTSTRAP_DIR" --target="$HOME" --restow dotfiles
  success "Dotfiles linked"
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

# ── Switch remote to SSH ──────────────────────────────────────────────────────
switch_remote_to_ssh() {
  local current
  current=$(git -C "$BOOTSTRAP_DIR" remote get-url origin 2>/dev/null || true)

  if [[ "$current" == git@* ]]; then
    success "Remote already using SSH"
    return
  fi

  # Convert https://github.com/user/repo.git → git@github.com:user/repo.git
  local ssh_url
  ssh_url=$(echo "$current" | sed 's|https://github.com/|git@github.com:|')

  info "Switching remote origin to SSH..."
  git -C "$BOOTSTRAP_DIR" remote set-url origin "$ssh_url"
  success "Remote switched to $ssh_url"
}

# ── Main ──────────────────────────────────────────────────────────────────────
main() {
  echo ""
  echo "  Mac Bootstrap"
  echo "  ─────────────"
  echo ""

  install_xcode_tools
  init_submodules
  install_homebrew
  install_brewfile
  install_dotfiles
  apply_macos_defaults
  run_scripts
  switch_remote_to_ssh

  echo ""
  success "Bootstrap complete!"
  warn "See MANUAL.md for any remaining steps that require manual setup."
  echo ""
}

main "$@"
