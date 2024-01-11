#!/usr/bin/env zsh
# enable Powerlevel10k instant prompt. should stay at the top of the rc file
# allows new shells to have zero delay displaying the prompt.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#
# these environment variables should be set here because when they are set in env.zsh
# they might get overriden by zsh itself at launch
export HISTFILE="${XDG_CACHE_HOME}/zsh_history"
export ZSH_COMPDUMP="${XDG_CACHE_HOME}/zcompdump"
export SAVEHIST=4000 # maximum size for $HISTFILE
local HERE="${ZDOTDIR:-$(dirname $0)}"

# my own custom zsh completions mainly for scripts i wrote myself
fpath+=("$ZDOTDIR/completions")

#####################
# PLUGINS
#####################
# initialize zert plugin manager
source "$HERE/zert/init.zsh"
zert-load-github "romkatv/powerlevel10k" # prompt theme
zert-load-github "zdharma-continuum/fast-syntax-highlighting" # syntax highlighting for commands

# OH MY ZSH
##############
zert-utilize ohmyzsh # initialize ohmyzsh with zert

# cross-platform clipboard integration (clipcopy and clippaste commands)
# clipcopy <file> # copies file content to clipboard
# <command> | clipcopy # copies stdout to clipboard
# clippaste > <file> # paste clipboard to file
# clippaste | <command> # paste clipboard to stdin
zert-load-omz lib clipboard

# automatically send system notifications for commands that take a long time
zert-load-omz plugin bgnotify
bgnofity_threshold=60 # more than 60 seconds

# direnv integration with a wrapper for _direnv_hook to make direnv work without nagging
# about .env files not being trusted. i do this because i have customized powerlevel10k
# to add information in prompt about the status of direnv so i don't need explicit error
# messages
zert-load-omz plugin direnv
function _direnv_hook(){
    trap -- '' SIGINT;
    eval "$(direnv export zsh 2>/tmp/direnv_nag)";
    printf "\e[31m"
    cat /tmp/direnv_nag | grep -v "is blocked" # make direnv stfu about untrusted .env files
    printf "\e[0m"
    trap - SIGINT;
}

# colorize man pages with less as pages
autoload -Uz colors && colors # required
zert-load-omz plugin colored-man-pages

# archive files and folders with different formats
# usage: archive <format> [files]
# example: archive zip file1 file2 *.txt
zert-load-omz plugin universalarchive
alias archive="ua"

# extract compressed files with different formats
# usage: extract <file> or unarchive <file>
zert-load-omz plugin extract
alias unarchive="extract"

# smarter cd with frecency search
zert-load-omz plugin zoxide


# fish-like history search with up and down arrow keys.
# should be loaded after syntax highlighting
zert-load-omz plugin history-substring-search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
# don't change prompt syntax highlighting
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND=""
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND=""


# add directory-local history so that every directory keeps a local history in addition to the global history
# local/global history can be toggled on and off with Ctrl-N
HISTORY_BASE="${XDG_CACHE_HOME}/.directory_history"
PER_DIRECTORY_HISTORY_PRINT_MODE_CHANGE=false # reduce printing message when toggling
PER_DIRECTORY_HISTORY_TOGGLE='^N'
HISTORY_START_WITH_GLOBAL=true
zert-load-omz plugin per-directory-history
# integration with p10k. i wrote a custom prompt segment for this in custom/p10k_custom.plugin.zsh
function history-toggle(){
    per-directory-history-toggle-history
    command -v p10k &>/dev/null && {
	if [[ $_per_directory_history_is_global == true ]]; then
	    p10k display '1/(left)/(my_per_directory_history)'=hide
	else
	    p10k display '1/(left)/(my_per_directory_history)'=show
	    prompt-full-redraw
	fi
    }
}
zle -N history-toggle history-toggle
bindkey '^N' history-toggle


# autosuggestion in gray color after the cursor based on history and zsh completinos
zert-load-github zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=200
ZSH_AUTOSUGGEST_MANUAL_REBIND=true # boosts performance but makes the plugin more unstable
ZSH_AUTOSUGGEST_COMPLETION_IGNORE="npm *"

# prepped sudo to current or previous command by pressing  <esc> twice
zert-load-omz plugin sudo

# load simple plugins that are either only for completion or aliases and don't need configuration
local simple_plugins=(docker-compose dotnet fancy-ctrl-z gitfast git-extras flutter golang gh lxd pylint redis-cli)
for plugin in $simple_plugins; do zert-load-omz plugin $plugin --ignore-alias; done
unset simple_plugins plugin
rm $XDG_CACHE_DIR/zcompdump -f

####################
# OPTIONS
####################
# don't use any default rc files
setopt no_global_rcs

# use bash-like extended globbing
setopt ksh_glob

# ignore contigous duplicate commands in history
setopt hist_ignore_all_dups

# don't add commands that start with a space to history
setopt hist_ignore_space

# don't store the "history" command itself to history
setopt hist_no_store

# add entered commands to history immediatly not after the shell is exitted
setopt inc_append_history

# run background jobs at a lower priority
setopt bg_nice

# Ctrl-D will not exit the shell
setopt ignore_eof

# stop beeping
setopt no_beep


####################
# CUSTOMIZATIONS
####################

# set the definition of a word for navigation and editing commands
WORDCHARS=""

# use ls colors for zsh file completion aswell
zstyle ":completion:*" menu select
zstyle ":completion:*" list-colors "${(s.:.)LS_COLORS}"

# emulate emacs keybindings
bindkey -e
bindkey "^H" backward-kill-word # Ctrl+Backspace
bindkey "^[Oc" forward-word # Ctrl+<Right>
bindkey "^[Od" backward-word # Ctrl+<Left>


# load fzf completions
command -v fzf-share &> /dev/null && source "$(fzf-share)/completion.zsh"

command -v fuck &> /dev/null && eval "$(thefuck --alias)"

# my own aliases
source "$HERE/alias.zsh"

# my own custom plugins
for custom in $HERE/custom/*.plugin.zsh; do source $custom; done
unset custom

# load p10k customizations if available should be at the end of the rc file
[[ -f "$HERE/p10k.zsh" ]] && source "$HERE/p10k.zsh"
