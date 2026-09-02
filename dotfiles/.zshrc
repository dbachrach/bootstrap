source ~/.config/zsh/options.zsh
source ~/.config/zsh/aliases.zsh
source ~/.config/zsh/completions.zsh
source ~/.config/zsh/tools.zsh
source ~/.config/zsh/plugins.zsh

# Superset CLI
export PATH="/Users/dustin/superset/bin:$PATH"

# custom
alias agents='$(pnpm root -w)/.bin/tsx $(pnpm root -w)/../apps/agents-cli/src/cli.ts --envPath $(pnpm root -w)/../packages/agents-framework/.env -p'

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/dustin/.lmstudio/bin"
# End of LM Studio CLI section

# Machine-local secrets/overrides (not tracked). See MANUAL.md.
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
