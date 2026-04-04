# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

A Mac bootstrap repo — scripts and dotfiles to provision a fresh macOS machine. There is no build system, test suite, or package manager. All files are shell scripts, config files, or dotfiles.

## Running the Bootstrap

```sh
./bootstrap.sh
```

This runs in order: Xcode CLT → Homebrew + Brewfile → dotfiles symlinking → macOS defaults → `scripts/*.sh` (numerically ordered).

## Architecture

**`bootstrap.sh`** — main entry point, orchestrates everything. Each phase is a bash function; idempotent by design (re-running is safe).

**`dotfiles/`** — mirrors `$HOME`. Bootstrap uses `stow` to symlink this directory into `$HOME`. For example, `dotfiles/.config/ghostty/config` → `~/.config/ghostty/config`. Adding a new dotfile means dropping it in the matching path under `dotfiles/`.

**`scripts/`** — numbered shell scripts (`01-nvm.sh`, `02-viteplus.sh`, `03-ssh.sh`) run in glob order. Each script is idempotent — it checks whether the tool is already installed and exits early if so. New setup steps go here as a new numbered script.

**`macos/defaults.sh`** — `defaults write` commands for system preferences. Ends with `killall Finder && killall Dock` to apply changes.

**`Brewfile`** — Homebrew formulae and casks. Add new packages here; `brew bundle` installs them.

**`MANUAL.md`** — steps that can't be automated (1Password sign-in, adding SSH key to GitHub).

## When to Re-run Bootstrap

`bootstrap.sh` is idempotent, so re-running it is always safe. You only need to re-run it (or a subset) in these cases:

- **New dotfile added** — `git pull` won't create the symlink for a file that didn't exist before; re-run bootstrap (or just `stow dotfiles` from the repo root) to add it.
- **New Brewfile entry** — run `brew bundle` to install new packages.
- **New `scripts/` entry** — run bootstrap to execute the new numbered script.
- **Updating dotfile content** — no action needed; symlinks already point into the repo, so `git pull` updates them automatically.

## Conventions

- Scripts use `set -euo pipefail` and the color helpers (`info`, `success`, `warn`, `error`) defined in `bootstrap.sh`.
- `scripts/03-ssh.sh` is interactive — it prompts for an email address. All other scripts are non-interactive.
- The `scripts/` naming convention uses zero-padded two-digit prefixes to control execution order.
