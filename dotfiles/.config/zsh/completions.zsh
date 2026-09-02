# Make fpath identical in login and non-login shells, and dedupe it.
# `brew shellenv` exports FPATH, so nested shells inherit the parent's fpath
# and would otherwise get zsh-completions prepended a second time — which
# changes the file count compinit checks and forces a dump rebuild on every
# shell start.
typeset -gU fpath
_brew=${HOMEBREW_PREFIX:-/opt/homebrew}
[[ -d $_brew/share/zsh/site-functions ]] && fpath=($_brew/share/zsh/site-functions $fpath)
[[ -d $_brew/share/zsh-completions ]]    && fpath=($_brew/share/zsh-completions $fpath)
unset _brew

# Keep the dump (and compdump's .$HOST.$$ temp files) out of $HOME.
# Full security check + rebuild at most once a day; otherwise -C just loads it.
# To force a rebuild after installing new completions: rm ~/.cache/zsh/zcompdump-*
autoload -Uz compinit
() {
  # (#q...) glob qualifiers need extended_glob; keep that scoped to this block.
  setopt localoptions extendedglob
  local zcd=${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-$ZSH_VERSION
  mkdir -p ${zcd:h}
  if [[ -n $zcd(#qN.mh+24) ]]; then
    compinit -d $zcd
  else
    compinit -C -d $zcd
  fi
}

(( $+commands[workmux] )) && eval "$(workmux completions zsh)"

# nvm's completion script runs its own full compinit (writing ~/.zcompdump)
# unless compinit is already defined, so it must load after compinit above,
# not from .zprofile.
[[ -s ${NVM_DIR:-$HOME/.nvm}/bash_completion ]] && source ${NVM_DIR:-$HOME/.nvm}/bash_completion
