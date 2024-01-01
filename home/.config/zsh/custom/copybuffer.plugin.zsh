# copy the active line from the command line buffer 
# onto the system clipboard
# inspired by ohmyzsh copybuffer plugin. the difference is it copies the last command
# into clipboard if the current buffer is empty
# relies on p10k_custom.plugin.zsh to get the last buffer
copybuffer () {
    if which clipcopy &>/dev/null; then
	if [ ! -z "$BUFFER" ] ; then
	    printf "%s" "$BUFFER" | clipcopy
	else
	    printf "%s" "$LAST_BUFFER" | clipcopy
	fi
  else
    zle -M "clipcopy not found. Please make sure you have Oh My Zsh installed correctly."
  fi
}

zle -N copybuffer

bindkey -M emacs "^O" copybuffer
bindkey -M viins "^O" copybuffer
bindkey -M vicmd "^O" copybuffer
