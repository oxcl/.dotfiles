#!/usr/bin/env zsh
# if the previous command failed with a non zero exit code, recommend the correct version using thefuck and zsh-autosuggestion
# for this to work you should add it to the beginning of $ZSH_AUTOSUGGEST_STRATEGY
# right now this script relies on $LAST_BUFFER variable to be present which is defined in p10k.custom.zsh
function _zsh_autosuggest_strategy_thefuck(){
        typeset -g suggestion
	suggestion="X$LAST_BUFFER"
}
