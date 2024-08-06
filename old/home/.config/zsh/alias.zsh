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
