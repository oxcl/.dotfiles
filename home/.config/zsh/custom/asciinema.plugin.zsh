#!/usr/bin/env zsh
# introduces two functions rec and play which make using asciinema easier
# it stores asciinema recordings in $HOME/asciinema and automatically converts them to GIF
# recordings are saved at $HOME/asciinema and a .cast extension is added to them automatically

# creates a new asciinema recording in $HOME/asciinema based on the provided name or an automatically generated one
function rec() {
    [[ ! -d "$HOME/asciinema" ]] && mkdir -p "$HOME/asciinema"
    [ -n "$1" ] && local filename="$HOME/asciinema/$1.cast" || local filename="$HOME/asciinema/$(date +'%Y-%m-%d-%H-%M-%S').cast"
    asciinema rec "$filename"
    [[ "$?" != 0 ]] && return
    # convert to gif
    if command -v agg &>/dev/null; then
	agg $filename "${filename%.cast}.gif" \
	    --theme $(echo "$MY_THEME_BG,$MY_THEME_FG,$MY_THEME_BG0,$MY_THEME_RED,$MY_THEME_GREEN,$MY_THEME_YELLOW,$MY_THEME_BLUE,$MY_THEME_PURPLE,$MY_THEME_AQUA,$MY_THEME_FG,$MY_THEME_DARK_GREY,$MY_THEME_RED_SUBTLE,$MY_THEME_GREEN_SUBTLE,$MY_THEME_YELLOW_SUBTLE,$MY_THEME_BLUE_SUBTLE,$MY_THEME_PURPLE_SUBTLE,$MY_THEME_AQUA_SUBTLE,$MY_THEME_LIGHT_GREY" | tr -d '#')
	[[ "$?" != 0 ]] || ! command -v gifsicle && return
	# make an optimized version of the gif 
	gifsicle --lossy=80 -k 64 -O2 -Okeep-empty "${filename%.cast}.gif" -o "${filename%.cast}.opt.gif"
    fi
    export LAST_RECORDED_ASCIINEMA="$filename"
}

# plays a recorded asciinema cast
# if no argument is passed to this function it tries to guess the last recorded cast and play it
function play(){
    if [ -n "$1" ]; then
	local filename="$HOME/asciinema/$1.cast"
    elif [ -n "$LAST_RECORDED_ASCIINEMA" ]; then
	local filename="$LAST_RECORDED_ASCIINEMA"
    else
	echo "Specify Recording File Name!" >&2
	return 1
    fi
    asciinema play "$filename"
}

# upload the specified asciinema recording to the asciinema server and copy its link into clipboard
# if no name is provided it tries to guess the last recorded cast and upload that
function asciiupload(){
    if [ -n "$1" ]; then
	local filename="$HOME/asciinema/$1.cast"
    elif [ -n "$LAST_RECORDED_ASCIINEMA" ]; then
	local filename="$LAST_RECORDED_ASCIINEMA"
    else
	echo "Specify Recording File Name!" >&2
	return 1
    fi
    asciinema upload "$filename" |& tee /tmp/asciinema
    cat /tmp/asciinema | grep -m 1 "https://" | xargs | clipcopy
    echo "the URL is Copied to your clipboard!"
}
