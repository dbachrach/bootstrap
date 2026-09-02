eval "$(/opt/homebrew/bin/brew shellenv)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# OrbStack
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

export PATH="$PATH:$HOME/.local/bin"
