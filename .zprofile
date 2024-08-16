#!/usr/bin/env zsh
# this file will be loaded when system is started. it is used to set environment variables and start a wayland compositor
# basically this file is replacing .xprofile for wayland
source ${XDG_CONFIG_HOME:-$HOME/.config}/wayland/profile

if [[ "$(tty)" == "/dev/tty1" ]] && [[ -z "$_WAYLAND_LOADED" ]]; then
  export _WAYLAND_LOADED=1
  exec hyprland
fi
