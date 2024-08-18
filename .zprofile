#!/usr/bin/env zsh
# this file will be loaded in wsl, ssh, tty logins and maybe other places.
# do not try to start a wayland compositor here!

source "${XDG_CONFIG_HOME:-$HOME/.config}/profile"
