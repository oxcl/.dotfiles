#!/usr/bin/env zsh

# these envrinment variables should be set here because when they are set in ~/.config/env (like other environment variables)
# they get overwritten by zsh at launch
export HISTFILE="${XDG_CACHE_HOME}/zsh_history"
export ZSH_COMPDUMP="${XDG_CACHE_HOME}/zcompdump"
export SAVEHIST=4000
export HERE="${ZDOTDIR:-$(dirname $0)}"

# enable powerlevel10k instant propmt. should stay at the top of the rc file
# allow new shells to have zero delay displaying the prompt.
if [[ -r "${XDG_CACHE_HOME}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME}/p10k-instant-prompt-${(%):-%n}.zsh"
fi



function load(){
  local PLUGIN="$1"
  if [[ ! -d "$HERE/plugins/$PLUGIN" ]]; then
    echo "failed to load plugin $PLUGIN: directory $HERE/plugins/$PLUGIN does not exist" >&2
    return -1
  fi

  function try(){
    if [[ -f "$1" ]]; then source "$1"; else return 1; fi
  }
  try "$HERE/plugins/$PLUGIN/$PLUGIN.zsh-theme" || \
  try "$HERE/plugins/$PLUGIN/$PLUGIN.plugin.zsh" || \
  echo "failed to load plugin $PLUGIN: don't know which file to source" >&2
}

load powerlevel10k


[[ -f "$HERE/p10k.zsh" ]] && source "$HERE/p10k.zsh"
