#/usr/bin/env zsh
# helper functions to make working with nix/nixos easier

# recursive symlink lookup for binaries inside $PATH since most binaries in nix/nixos are symlinks
function whichnix(){ readlink -f "$(command which $1)"; }
function wherenix(){ readlink -f "$(command where $1)"; }
alias which=whichnix
