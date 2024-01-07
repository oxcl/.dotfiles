#!/usr/bin/env zsh
# simple and quick command to serve the current directory over local Network with python SimpleHTTPServer module + displaying devices private ip address
function serve(){
    # print all the ip addresses on this machine
    echo "IPs: \033[0;33m$(ifconfig | grep inet | awk '{print $2}' | grep -v '::' | tr '\n' '\t')\033[0;m"
    python -m http.server "$@"
}
