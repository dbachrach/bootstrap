# Source the output of an init/completion generator from a cache instead of
# forking it on every shell start. The cache is keyed on the binary's resolved
# path, so it regenerates when the tool is upgraded (brew relinks to a new
# Cellar path). Usage: _cached_eval <name> [env VAR=val...] <cmd> [args...]
_cached_eval() {
  local name=$1 cache=${XDG_CACHE_HOME:-$HOME/.cache}/zsh/eval-$1.zsh bin arg line
  shift
  for arg; do [[ $arg == env || $arg == *=* ]] || { bin=${commands[$arg]:A}; break; }; done
  [[ -n $bin ]] || return 0
  [[ -r $cache ]] && read -r line < $cache
  if [[ $line != "# $bin" ]]; then
    mkdir -p ${cache:h}
    { print -r -- "# $bin"; "$@" } >| $cache.$$ && mv -f $cache.$$ $cache || rm -f $cache.$$
  fi
  [[ -r $cache ]] && source $cache
}

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

# ~/.local/bin (cua-driver, claude, ...) is appended in .zprofile. Don't let
# installers prepend it: it holds Hermes's node/npm/npx, which shadow nvm's.
