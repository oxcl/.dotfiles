#!/usr/bin/env bash
# this script is supposed to setup the dotfiles on a new system. run it with "bash bootstrap.sh" and everything should be setted up for you
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
git submodule update --init --recursive
source $SCRIPT_DIR/.local/bin/stowhome
