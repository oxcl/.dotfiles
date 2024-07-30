#!/usr/bin/env sh
if [ -n "$WAYLAND_DISPLAY" ]; then
  echo "ran fine" > $HOME/test
  source "${XDG_CONFIG_HOME:-$HOME/.config}/wayland/profile"
fi
