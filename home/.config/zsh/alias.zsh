#!/usr/bin/env zsh

unalias run-help # because run-help=man is a dumb default alias

command -v lsd &> /dev/null && alias ls="lsd -v" # use lsd instead of ls if installed

# commonly used aliases for ls
alias la="ls -lAhv" # list everything except . & .. with human readable sizes
alias ll="ls -lhv" # list with human readable sizes
alias l="la"
alias l.="ls -ldv .*" # list dot files"
alias lt="ls -lth" # sort by time
alias lS="ls -lSh" # sort by file size
alias diff='diff --color' # colorized diffs

# make grep use colors and ignore some special folders by default
GREP_OPTIONS="--color=auto --exclude-dir={.git,CVS,.hg,.bzr,.svn,.idea,.tox}"
alias grep="grep $GREP_OPTIONS"
alias egrep="egrep $GREP_OPTIONS"
alias fgrep="fgrep $FREP_OPTIONS"
unset GREP_OPTIONS

# aliases for find
alias findf="find . -type f -name" # search through files
alias findd="find . -type d -name" # search through directories

# make file navigation easier when trying to reach parent directories
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

# don't add unnecessary commands to history. for this to work HIST_NO_SPACE
# must be set.
alias exit=" exit"

# human readable file sizes
alias df="df -h"
alias du="du -h"

alias copy="clipcopy"
alias paste="clippaste"

# pretty print json from stdin
alias json="jq . --color-output"

# python3 as python
command -v python3 &>/dev/null && alias python="python3"
command -v pip3 &>/dev/null && alias pip="pip3"

# quickly edit zsh config and automatically reload zsh
if [[ "$EDITOR" == *"vim" ]]; then
    alias zshrc="$EDITOR $ZDOTDIR/rc.zsh -c\
                 'belowright split $ZDOTDIR/env.zsh |\
                  vsplit $ZDOTDIR/alias.zsh |\
                  wincmd k' && exec zsh"
elif [[ "$EDITOR" == "emacs"* ]]; then
    # TODO: better vterm integration
    alias zshrc="$EDITOR -f zshrc && exec zsh"
else
    alias zshrc="${EDITOR:-nano} $ZDOTDIR/rc.zsh $ZDOTDIR/env.zsh $ZDOTDIR/alias.zsh && exec zsh"
fi

# replace cat for bat if installed
command -v bat &>/dev/null && alias cat="bat"
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain' # use bat for --help in every command


# fzf
alias fzfp="fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}'"

# breaking the habbit of using clear instead of Ctrl-l
alias clear=" echo 'use Ctrl-l'"

# nix/nixos aliases
alias nrs="sudo echo && sudo nixos-rebuild switch --flake $HOME/.dotfiles#$MY_NIX_HOST --log-format internal-json |& nom --json"

# json viewer
if command -v fx &>/dev/null; then
    alias json="fx"
elif command -v jless &> /dev/null; then
    alias json="jless"
else
    alias json="echo 'install fx or jless' >&2"
fi

# systemd
alias sc="systemctl"
alias scu="systemctl --user"

# disable hyperlink server since urxvt and vterm don't support it anyway
alias poke="poke --no-hserver"

# python
if command -v python3 &>/dev/null; then
    alias venv="python3 -m venv"
else
    alias venv="python -m venv"
fi
