source ~/.config/zsh/options.zsh
source ~/.config/zsh/aliases.zsh
source ~/.config/zsh/completions.zsh
source ~/.config/zsh/tools.zsh
source ~/.config/zsh/plugins.zsh

# Superset CLI
export PATH="/Users/dustin/superset/bin:$PATH"

# custom
alias agents='$(pnpm root -w)/.bin/tsx $(pnpm root -w)/../apps/agents-cli/src/cli.ts --envPath $(pnpm root -w)/../packages/agents-framework/.env -p'
