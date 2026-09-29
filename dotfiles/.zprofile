# Static equivalent of `eval "$(brew shellenv)"`, which forks brew (~30ms).
export HOMEBREW_PREFIX="/opt/homebrew"
export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
export HOMEBREW_REPOSITORY="/opt/homebrew"
fpath[1,0]="/opt/homebrew/share/zsh/site-functions"
export FPATH
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}"
[ -z "${MANPATH-}" ] || { export MANPATH="${MANPATH%"${MANPATH##*[!:]}"}"; export MANPATH=":${MANPATH#"${MANPATH%%[!:]*}"}"; };
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"

# Sourcing nvm.sh costs ~1s, so only put the default node on PATH here.
# The `nvm` command itself is lazy-loaded in ~/.config/zsh/tools.zsh.
export NVM_DIR="$HOME/.nvm"
() {
  local d
  [[ -r $NVM_DIR/alias/default ]] || return
  d=$(<$NVM_DIR/alias/default)
  # Exact version (v24.14.0), else newest match for a partial one (24, v24.1).
  local -a bins=($NVM_DIR/versions/node/{$d,v${d#v}}/bin(N/))
  (( $#bins )) || bins=($NVM_DIR/versions/node/v${d#v}.*/bin(Nn/))
  if (( $#bins )); then
    export NVM_BIN=${bins[-1]} PATH="${bins[-1]}:$PATH"
  else
    # Alias nvm must resolve itself (lts/*, node): pay for the full load.
    source $NVM_DIR/nvm.sh
  fi
}

# OrbStack
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

export PATH="$PATH:$HOME/.local/bin"
