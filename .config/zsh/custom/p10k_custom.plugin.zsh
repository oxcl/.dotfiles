#!/usr/bin/env zsh
# i add custom function and variables for powerlevel10k prompt here for easier access

# my own implementation of transient_prompt. after running each command the prompt will change
# to become the mini version of the prompt
# for this to work you have to disable p10k transient_prompt
function p10k-on-post-prompt() { # this function runs after pressing enter
    # keep last executed command
    export LAST_BUFFER="$BUFFER" # used in other places
   
    # hide everything
    p10k display '1/*/*'=hide
    # print left mini prompt
    p10k display "1/left/(dir|prompt_char)"=show
}
function p10k-on-pre-prompt()  { # this function runs before new prompt gets printed
    #print full left prompt
    p10k display "1/left/(${POWERLEVEL9K_LEFT_PROMPT_ELEMENTS// /|})"=show
}

# my custom segment for direnv
# it shows a red icon if a .env or .envrc is found but it is blocked and not in the
# whitelist yet it shows a green icon if a .env file is available and is currently loaded
function prompt_my_direnv(){
    [ -n "$DIRENV_LOADED" ] && p10k segment -r -i DIRENV_ICON -f green -s ACTIVE && return
    [ -n "$DIRENV_DIR" ] && p10k segment -r -i DIRENV_ICON -f red -s BLOCKED && return
}
