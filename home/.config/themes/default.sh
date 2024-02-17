#!/usr/bin/env sh
# theme color environment variables

export MY_THEME_NAME="gruvbox-material"
export MY_THEME_MODE=dark # dark | light
export MY_THEME_STYLE=material # material | mix | original
export MY_THEME_BG=hard # hard | medium | soft

source "${XDG_CONFIG_HOME}/themes/${MY_THEME_NAME}-${MY_THEME_MODE}.sh"

export MY_THEME_LOADED=1
