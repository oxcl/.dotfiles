#!/usr/bin/env bash
# this plugin wraps the builtin history command to pipe the history into fzf if installed
# and if the output is not piped to another command. the item that is selected in fzf gets
# executed. the kebinding C-h is also set for this command
function history(){
    if command -v fzf &> /dev/null && [ -t 1 ]; then
	local command="$(builtin history 1 "$@" | fzf --tac | awk '{print $1=""}1' | awk '{$1==$1}1')"
	BUFFER="$(echo $command | xargs)" # trim white space
	if ! zle accept-line &>/dev/null; then
	    (echo $command | exec zsh )
        fi
    else
	builtin history "$@"
    fi
}
zle -N history history
bindkey '^R' history
