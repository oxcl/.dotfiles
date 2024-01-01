#!/usr/bin/env zsh
# in this file necessary variables are set and zert functions are lazy loaded

# locate where zert is installed. change ZERT_CONFIG_HOME variable to override the default
if [[ ! -n "$ZERT_CONFIG_HOME" ]]; then
    export ZERT_CONFIG_HOME="${ZDOTDIR:-${XDG_CONFIG_HOME:-$HOME/.config/zsh}/zsh}/zert"
    mkdir -p "$ZERT_CONFIG_HOME"
fi

# locate where plugin files should be stored. change ZERT_DATA_HOME to override the default
if [[ ! -n "$ZERT_DATA_HOME" ]]; then
   export ZERT_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/zert"
   mkdir -p "$ZERT_DATA_HOME" "$ZERT_DATA_HOME/plugins"
fi


# add zert directories to fpath so it's functions and plugins are recognized by zsh
fpath+=("$ZERT_CONFIG_HOME")
fpath+=("$ZERT_DATA_HOME/plugins")
for PLUGIN_DIRECTORY in $(ls $ZERT_DATA_HOME/plugins ); do fpath+=("$PLUGIN_DIRECTORY"); done
unset PLUGIN_DIRECTORY
if [[ -f "$ZERT_DATA_HOME/omz_plugins" ]]; then
    # add omz plugins that were loaded on the last zsh startup to fpath
    # this is done so that the completion for those plugins are loaded and captured
    # for zcompdump file.
    while read plugin; do
	fpath+=("$plugin")
    done < "$ZERT_DATA_HOME/omz_plugins"
    unset plugin
    rm "$ZERT_DATA_HOME/omz_plugins"
fi

# locate where zert.lock file. this pins plugins into a specific version to improve reproducibility
# change ZERT_LOCK_FILE to override the default path
if [[ ! -n "$ZERT_LOCK_FILE" ]]; then
    export ZERT_LOCK_FILE="${ZDOTDIR:-$HOME}/zert.lock"
fi
[[ ! -f "$ZERT_LOCK_FILE" ]] && touch "$ZERT_LOCK_FILE"


# lazy load zert functions in zsh
autoload -Uz zert-load-url
autoload -Uz zert-load-git
autoload -Uz zert-load-github
autoload -Uz zert-parse-args
autoload -Uz zert-utilize
autoload -Uz zert-update

# run the completion system
autoload -Uz compinit && compinit -i -d "${ZSH_COMPDUMP:-$ZERT_DATA_HOME/compdump}"
