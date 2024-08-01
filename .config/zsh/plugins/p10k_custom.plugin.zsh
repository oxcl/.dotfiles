#!/usr/bin/env zsh
# i add custom function and variables for powerlevel10k prompt here for easier access

function prompt-full-redraw() {
  local f
  for f in chpwd "${chpwd_functions[@]}" precmd "${precmd_functions[@]}"; do
    [[ "${+functions[$f]}" == 0 ]] || "$f" &>/dev/null || true
  done
  p10k display -r
}

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
function prompt_my_per_directory_history(){
    [[ $_per_directory_history_is_global == false ]] && p10k segment -r -i HISTORY_ICON -t local -f yellow -s LOCAL
}

# custom copybuffer segment which displays a text or icon to notify the user that the buffer was copied
_COPYBUFFER_SEGMENT= # empty the variable when the shell starts
function prompt_my_copybuffer(){
    [[ -z "$_COPYBUFFER_SEGMENT" ]] && export _COPYBUFFER_SEGMENT=1 || p10k segment -r -i OK_ICON -t copied -f magenta -s LOCAL
}

# custom asciinema segment which displays a red circle when inside an asciinema recording
function prompt_my_asciinema(){
    [[ -n "$_ASCIINEMA_SEGMENT" ]] && p10k segment +r -i '◉' -f red -s RECORDING
}
