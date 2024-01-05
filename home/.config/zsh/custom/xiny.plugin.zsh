#!/usr/bin/env zsh
# command line interface for xinyminutes.com tutorials with syntax highlighting using bat and guesslang
# the code is inspired by https://github.com/YesSeri/xny-cli

function xiny(){
    if [[ -z "$1" ]]; then
	echo "Please run this script with any programming language as parameter, like so:\n xiny python" >&2
    fi
    local XINY_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/xiny"
    [[ ! -d "$XINY_DIR" ]] && mkdir "$XINY_DIR" -p
    local LANGUAGE="$(echo "$1" | tr '[:upper:]' '[:lower:]')"
    local URL="https://learnxinyminutes.com/docs/"
    local FULL_URL="$URL$LANGUAGE/"
    local FILE_URL=$(curl $FULL_URL | grep -Po '(?<=href="/docs/)[^"]*')
    local FILE_PATH="$XINY_DIR/$(basename "$FILE_URL")"
    if [[ -f "$FILE_PATH" ]]; then
	bat "$FILE_PATH"
    elif [[ $FILE_URL ]]; then
	curl $URL$FILE_URL > "$FILE_PATH"
	[[ "$?" != 0 ]] && rm "$FILE_PATH"
	bat "$FILE_PATH"
    else
	echo "No data found for $LANGUAGE" >&2
	echo -e "Please run this script with any programming language as a parameter, like so:\n xiny python" >&2
    fi
}
