# Bootstrap

Scripts and configuration to set up a new Mac from scratch — Homebrew packages, apps, dotfiles, and system preferences.

## What's Included

- **Homebrew** — formulae and casks via `Brewfile`
- **Dotfiles** — shell config, editor settings, and other personal configs
- **macOS defaults** — sensible system preference overrides
- **App setup** — post-install configuration for common tools

## Usage

```sh
# Clone the repo
mkdir -p ~/code
git clone https://github.com/dbachrach/bootstrap.git ~/code/bootstrap
cd ~/code/bootstrap

# Run the bootstrap script
./bootstrap.sh
```

## Structure

```
bootstrap/
├── Brewfile          # Homebrew packages and casks
├── bootstrap.sh      # Main entry point
├── dotfiles/         # Symlinked to $HOME
├── macos/            # macOS system defaults
└── scripts/          # Individual setup scripts
```

## Manual Steps

Some things can't be automated. After running the script, check `MANUAL.md` for any steps that require human interaction (app store installs, license keys, etc).
