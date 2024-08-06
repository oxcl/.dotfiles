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

####################
# PLUGINS
####################
# simple function to load zsh plugins and scripts
# i use git submodules and this function as my zsh plugin manager
function load(){
  local PLUGIN="$1"

  # add plugin directory to fpath for completions
  if [[ -d "$HERE/plugins/$PLUGIN" ]]; then
    fpath+=("$HERE/plugins/$PLUGIN")
  fi

  function try(){
    if [[ -f "$1" ]]; then source "$1"; else return 1; fi
  }

  try "$HERE/plugins/$PLUGIN.zsh" || \
  try "$HERE/plugins/$PLUGIN.plugin.zsh" || \
  try "$HERE/plugins/$PLUGIN/$PLUGIN.zsh-theme" || \
  try "$HERE/plugins/$PLUGIN/$PLUGIN.plugin.zsh" || \
  try "$HERE/plugins/$PLUGIN/$PLUGIN.zsh" || \
  try "$HERE/plugins/$PLUGIN/$(basename $PLUGIN).plugin.zsh" || \
  [[ -f "$HERE/plugins/$PLUGIN/_$(basename $PLUGIN)" ]] || \
  echo "failed to load plugin $PLUGIN: don't know which file to source" >&2
}

load fast-syntax-highlighting # syntax highlighting for commands

# autoload compinit && compinit -d "${ZSH_COMPDUMP}"

load powerlevel10k # zsh prompt
load p10k_custom # my additional customizations and widgets for powerlevel10k prompt

# clipcopy - Copy data to clipboard
#   Usage:
#     <command> | clipcopy     - copies stdin to clipboard
#     clipcopy <file>          - copies a file's contents to clipboard
# clippaste - writes clipboard's contents to stdout
#   Usage:
#     clippaste | <command>   - paste contents and pipes it to another process
#     clippaste > <file>      - paste contents to a file
load ohmyzsh/lib/clipboard

# automatically send system notifications for commands that take a long time
load ohmyzsh/plugins/bgnotify
export bgnotify_treshold=60

# colorize man pages with less as pager
autoload -Uz colors && colors # required
load ohmyzsh/plugins/colored-man-pages

# archive and compress files and directories with different formats
# usage: archive <format> [files]
# example: archive zip file1 file2 directory/ *.txt
load ohmyzsh/plugins/universalarchive
alias archive="ua"

# extract compressed files with different formats
# usage: extract <file> OR unarchive <file>
load ohmyzsh/plugins/extract
alias unarchive="extract"

# direnv integration with a wrapper for _direnv_hook to make direnv work without nagging
# about .env files not being trusted. i do this because i have customized powerlevel10k
# to add information in prompt about the status of direnv so i don't need explicit error
# messages
load ohmyzsh/plugins/direnv
function _direnv_hook(){
  trap -- '' SIGINT
  eval "$(direnv export zsh 2> >(grep -v 'is blocked' >&2) )"
  trap - SIGINT;
}

# show command autosuggestion (after the cursor in gray color) based on history, zsh completions, etc..
load zsh-autosuggestions
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=200
export ZSH_AUTOSUGGEST_COMPLETION_IGNORE="npm *"
export ZSH_AUTOSUGGEST_STRATEGY=(history)

# enable thefuck in the shell if installed
command -v thefuck &> /dev/null && eval "$(thefuck --alias)"
load thefuck

# search in the history for previous commands that share the same prefix as the one typed in the prompt
# (similar to fish shell)
load zsh-history-substring-search
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND=
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND=
HISTORY_SUBSTRING_SEARCH_PREFIXED=1
bindkey -M emacs '^[OA' history-substring-search-up
bindkey -M emacs '^[OB' history-substring-search-down

#load simple ohmyzsh plugins that are either only for completion or don't need configuration
function load_plugins(){
  alias() { :; }
  while [ -n "$1" ]; do
    load ohmyzsh/plugins/$1
    shift
  done
  unfunction alias
  unset plugin
}
# plugins that sould be loaded before compinit
load_plugins docker-compose fancy-ctrl-z gitfast git-extras flutter golang gh pylint redis-cli

# start the completion system
autoload -Uz compinit && compinit -i -d $ZSH_COMPDUMP

# plugins that sould be loaded after compinit
load_plugins dotnet lxd

unfunction load_plugins

####################
# OPTIONS
####################
# don't use any global rc files
setopt no_global_rcs

# enable bash-like extended globing
setopt ksh_glob

# ignore contigous duplicate commands in history
setopt hist_ignore_all_dups

# don't add commands that start with a space to history
setopt hist_ignore_space

# don't store the "history" command itself to history
setopt hist_no_store

# add entered commands to history immediatly not after the shell is closed
setopt inc_append_history

# run background jobs at a lower priority
setopt bg_nice

# ctrl-d will not exit the shell
setopt ignore_eof

# no beeping
setopt no_beep

####################
# KEYBINDINGS
####################
# use emacs keybindings
bindkey -e
WORDCHARS=
bindkey "^H" backward-kill-word # Ctrl+Backspace
bindkey "^Oc" forward-word # Ctrl+<Right>
bindkey "^Od" backward-word # Ctrl+<Left>

####################
# ALIASES
####################
source "$HERE/alias.zsh"


####################
# COMPLETIONS
####################
fpath+=("$HERE/completions")

[[ -f "$HERE/p10k.zsh" ]] && source "$HERE/p10k.zsh"
unfunction load
