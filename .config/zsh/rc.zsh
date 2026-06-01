#!/usr/bin/env zsh

# these envrinment variables should be set here because when they are set in ~/.config/env (like other environment variables)
# they get overwritten by zsh at launch
export HISTFILE="${XDG_CACHE_HOME}/zsh_history"
export ZSH_COMPDUMP="${XDG_CACHE_HOME}/zcompdump"
export SAVEHIST=20000


# enable powerlevel10k instant prompt. should stay at the top of the rc file
# allow new shells to have zero delay displaying the prompt
[[ -r "${XDG_CACHE_HOME}/p10k-instant-prompt-${(%):-%n}.zsh" ]] && source "${XDG_CACHE_HOME}/p10k-instant-prompt-${(%):-%n}.zsh"


source "$HOME/Projects/zert/zert.zsh"

zert romkatv/powerlevel10k # the best zsh prompt
[ -f "$ZDOTDIR/p10k_custom.zsh" ] && source "$ZDOTDIR/p10k_custom.zsh"


#zert zdharma-continuum/fast-syntax-highlighting

# show command autosuggestion (after the cursor in gray color) based on history, zsh completions, etc..
zert https://github.com/zsh-users/zsh-autosuggestions
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=200
export ZSH_AUTOSUGGEST_COMPLETION_IGNORE="npm *"
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)


# zert "git@github.com:zsh-users/zsh-history-substring-search"
# HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND=
# HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND=
# HISTORY_SUBSTRING_SEARCH_PREFIXED=1

zert "$ZDOTDIR/my_plugins/asciinema.plugin.zsh"


zert use ohmyzsh

# direnv integration with a wrapper for _direnv_hook to make direnv work without nagging
# about .env files not being trusted. i do this because i have customized powerlevel10k
# to add information in prompt about the status of direnv so i don't need explicit error
# messages
if (( ${+commands[direnv]} )); then
    zert ohmyzsh plugins/direnv
    function _direnv_hook(){
      trap -- '' SIGINT
      eval "$(direnv export zsh 2> >(grep -v 'is blocked' >&2) )"
      trap - SIGINT;
    }
fi

# word navigation with Ctrl+Arrow
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# delete word with Ctrl+Backspace
bindkey "^H" backward-kill-word

# MUST be sourced last — powerlevel10k captures the state of the shell at source time,
# so anything added after this line won't be reflected in the prompt
[ -f "$ZDOTDIR/p10k.zsh" ] && source "$ZDOTDIR/p10k.zsh"
