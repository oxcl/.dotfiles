#!/usr/bin/env zsh

# this is a simple zsh-autosuggest strategy which calls thefuck command when a command exits with a non zero exit code
# assuming there is a mistake in the command the suggested fix by thefuck will be added as one of zsh-autosuggest
# items
function ensure(){
  while [ -n "$1" ]; do
    if ! command -v "$1" &>/dev/null; then
      return 1
    fi
    shift;
  done
  return 0
}

_ZSH_THEFUCK_HERE="${0:A:h}"
# checks if the executed command exitted with a non-zero exit code and if it did, tries to get a fix from thefuck
function _thefuck_hook(){
  local exit_code=$?
  if [ $exit_code -eq 0 ] || [ $exit_code -eq 130 ]; then
    _ZSH_THEFUCK_SUGGEST=
    return;
  fi
  local command="${history[@][1]}"
  if [[ "$command" == $_ZSH_THEFUCK_LAST_COMMAND ]]; then
    # don't thefuck a command twice
    return
  fi
  _ZSH_THEFUCK_LAST_COMMAND=$command
  local result=$(COMMAND=$command expect -f $_ZSH_THEFUCK_HERE/expect.exp)
  _ZSH_THEFUCK_SUGGEST=$(echo $result | tail -n1 | rev | cut -d'[' -f2- | rev | tr -cd '[:print:]' | sed 's/\[1K//' | xargs)
}

# custom strategy for zsh-autosuggest plugin to suggest the fix provided by thefuck
function _zsh_autosuggest_strategy_thefuck(){
  typeset -g suggestion
  suggestion=( $_ZSH_THEFUCK_SUGGEST )
}


if ensure thefuck expect; then
  precmd_functions+=(_thefuck_hook)
  ZSH_AUTOSUGGEST_STRATEGY=(thefuck $ZSH_AUTOSUGGEST_STRATEGY)
fi
