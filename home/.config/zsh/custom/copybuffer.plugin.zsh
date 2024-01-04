#!/usr/bin/env zsh
# custom clipboard keybindings for better integration with system clipboard.
# also when no region is active copies the current buffer (or previous buffer if current buffer is empty)
# inspired by ohmyzsh copybuffer plugin. the difference is that it also copies the last command on empty buffer
# relies on p10k_custom.plugin.zsh to get the last buffer and show copy notification at right
# most of the code is taken from https://gist.github.com/jclosure/9ce8213d055741596d8a42360bd5596f

cutbuffer () {
    emulate -L zsh
    # if the region is not active copy the current or previous command based
    if [[ "$REGION_ACTIVE" == 0 ]]; then
	if [[ -n "$BUFFER" ]]; then
	    printf "%s" "$BUFFER" | clipcopy
	else
	    printf "%s" "$LAST_BUFFER" | clipcopy
        fi
	if command -v p10k &>/dev/null; then
	    p10k display '1/right/my_copybuffer'=show
        fi
	return
    fi
  zle kill-region
  zle set-mark-command -n -1
  killring=("$CUTBUFFER" "${(@)killring[1,-2]}")
  if which clipcopy &>/dev/null; then
    printf "%s" "$CUTBUFFER" | clipcopy
  else
    echo "clipcopy function not found. Please make sure you have Oh My Zsh installed correctly."
  fi
}

copybuffer () {
  emulate -L zsh
  zle copy-region-as-kill
  zle set-mark-command -n -1
  killring=("$CUTBUFFER" "${(@)killring[1,-2]}")
  if which clipcopy &>/dev/null; then
    printf "%s" "$CUTBUFFER" | clipcopy
  else
    echo "clipcopy function not found. Please make sure you have Oh My Zsh installed correctly."
  fi
}

pastebuffer () {
  if which clippaste &>/dev/null; then
    local pasted=$(clippaste)
    if [[ $pasted != $CUTBUFFER ]]; then
      CUTBUFFER=${pasted}
      killring=("$CUTBUFFER" "${(@)killring[1,-2]}")
    fi
  else
    echo "clippaste function not found. Please make sure you have Oh My Zsh installed correctly."
  fi
  zle yank
}

zle -N copybuffer
zle -N pastebuffer
zle -N cutbuffer

bindkey '\ew'  copybuffer
bindkey '\eW'  copybuffer
bindkey '^Y'   pastebuffer
bindkey '^w'  cutbuffer

