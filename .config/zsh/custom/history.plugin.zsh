#!/usr/bin/env bash
# this plugin wraps the builtin history command to pipe the history into fzf if installed
# and if the output is not piped to another command. the item that is selected in fzf gets
# executed. the kebinding C-h is also set for this command
function history(){
    if command -v fzf &> /dev/null && [ -t 1 ]; then
	echo
	builtin history "$@" | fzf --tac | awk '{print $1=""}1' | awk '{$1==$1}1' | zsh
	zle reset-prompt
    else
	builtin history "$@"
    fi
}
zle -N history history
bindkey '^R' history
