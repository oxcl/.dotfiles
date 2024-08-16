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

# make grep use colors and ignore some special folders by default
GREP_OPTIONS="--color=auto --exclude-dir={.git,CVS,.hg,.bzr,.svn,.idea,.tox}"
alias grep="grep $GREP_OPTIONS"
alias egrep="egrep $GREP_OPTIONS"
alias fgrep="fgrep $FREP_OPTIONS"
unset GREP_OPTIONS

# aliases for find
alias findf="find . -type f -name" # search through files
alias findd="find . -type d -name" # search through directories


# don't add unnecessary commands to history. for this to work HIST_NO_SPACE
# must be set.
alias exit=" exit"

# human readable file sizes
alias df="df -h"
alias du="du -h"


# pretty print json from stdin
alias json="jq . --color-output"

# python aliases
command -v python3 &>/dev/null && alias python="python3"
command -v pip3 &>/dev/null && alias pip="pip3"

if command -v python3 &>/dev/null; then
  alias venv="python3 -m venv"
elif command -v python &>/dev/null; then
  alias venv="python -m venv"
fi

# breaking the habbit of using clear instead of Ctrl-l
alias clear=" echo 'use Ctrl-l'"

# use bat instead of cat if possible
replace cat bat
# use bat to show pretified --help output for every command
command -v bat &> /dev/null && alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'

# base64
alias encode64="base64"
alias decode64="base64 -d"

# nixos aliases
alias hms="home-manager switch --flake ~/.nixconf"
alias nrs="sudo nixos-rebuild switch --flake ~/.nixconf"
