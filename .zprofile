#!/usr/bin/env zsh
# this file will be loaded when system is started. it is used to set environment variables and start a wayland compositor
# basically this file is replacing .xprofile for wayland
source ${XDG_CONFIG_HOME:-$HOME/.config}/wayland/profile

exec sway
