_cached_eval starship starship init zsh --print-full-init
_cached_eval zoxide zoxide init zsh
_cached_eval fzf fzf --zsh

# nvm is lazy-loaded: .zprofile puts the default node on PATH, and the real
# nvm.sh (~1s) is sourced the first time `nvm` is run or tab-completed.
if [[ -s $NVM_DIR/nvm.sh ]]; then
  if (( ! $+functions[nvm_ls] )); then
    _nvm_load() { unfunction nvm _nvm_load; source $NVM_DIR/nvm.sh; }
    nvm() { _nvm_load; nvm "$@"; }
  fi
  # Must come after compinit (else it runs its own) and after `nvm` exists
  # (else it bails out). Its helpers call nvm internals, so load nvm first.
  if [[ -s $NVM_DIR/bash_completion ]]; then
    source $NVM_DIR/bash_completion
    functions[__nvm]="(( \$+functions[_nvm_load] )) && _nvm_load; ${functions[__nvm]}"
  fi
fi
