#!/usr/bin/env zsh

# replace a command with another if possible
function replace(){
  local command=$1
  shift;
  command -v "$1" &> /dev/null && alias $command="$@"
}

unalias run-help # because run-help=man is a dumb default alias!

# aliases for ohmyzsh clipboard library
alias copy=clipcopy
alias paste=clippaste

# use lsd instead of ls if possible
replace ls lsd -v

# commonly used aliases for ls
alias la="ls -lAhv" # list everything except . & .. with human readable sizes
alias ll="ls -lhv" # list with human readable sizes
alias l="la"
alias l.="ls -ldv .*" # only list dotfiles
alias lt="ls -lth" # sort by time (most recent)
alias lS="ls -lSh" # sort by size (largest first)

# use bat instead of cat if possible
replace cat bat
# use bat to show pretified --help output for every command
command -v bat &> /dev/null && alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'
