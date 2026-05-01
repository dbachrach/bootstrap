# Bootstrap

Scripts and configuration to set up a new Mac from scratch — Homebrew packages, apps, dotfiles, and system preferences.

## What's Included

- **Homebrew** — formulae and casks via `Brewfile`
- **Dotfiles** — shell config, editor settings, and other personal configs
- **macOS defaults** — sensible system preference overrides
- **App setup** — post-install configuration for common tools

## Usage

On a fresh Mac, open Terminal and run:

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/dbachrach/bootstrap/main/init.sh)"
```

This installs Xcode CLT, clones the repo to `~/code/bootstrap`, and runs `bootstrap.sh` — no git or SSH key needed upfront.

To re-run on an existing machine:

```sh
~/code/bootstrap/bootstrap.sh
```

## Structure

```
bootstrap/
├── init.sh           # Fresh-machine entry point (curl | bash this)
├── bootstrap.sh      # Main orchestrator
├── Brewfile          # Homebrew packages and casks
├── dotfiles/         # Mirrors $HOME — symlinked recursively (e.g. dotfiles/.config/starship.toml → ~/.config/starship.toml)
├── macos/            # macOS system defaults
└── scripts/          # Individual setup scripts
```

## Manual Steps

Some things can't be automated. After running the script, check `MANUAL.md` for any steps that require human interaction (app store installs, license keys, etc).
