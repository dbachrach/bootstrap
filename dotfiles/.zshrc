alias ll="ls -alh"
alias o="open ."
alias g="git"
alias gst="git status"
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Brew
if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

    autoload -Uz compinit
    compinit
fi

# Autosuggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Syntax highlighting (MUST be last)
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

setopt auto_cd

export PATH="$PATH:$HOME/.local/bin"

# Vite+ bin (https://viteplus.dev)
. "$HOME/.vite-plus/env"

# Workmux
alias wm='workmux'
eval "$(workmux completions zsh)"

# Starship
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
source <(fzf --zsh)
