#!/usr/bin/env zsh
# Extended asciinema helper with error handling and smarter GIF optimization

function ensure(){
  while [ -n "$1" ]; do
    if ! command -v $1 &>/dev/null; then
      echo "❌ ERROR: '$1' is required for asciinema plugin to work" >&2
      return 1
    fi
    shift
  done
  return 0
}

_ZSH_ASCIINEMA_DEPS=(asciinema gifsicle agg jq)

function convert_cast(){
  if ! ensure $_ZSH_ASCIINEMA_DEPS; then return 1; fi
  local filename="$1"
  local workfile="$filename"

  # detect asciinema format version
  local version=$(jq -r '.version // empty' "$filename" 2>/dev/null)
  if [[ "$version" == "3" ]]; then
    echo "🔄 Converting $filename from Cast v3 → v2..."
    workfile="${filename%.cast}.v2.cast"
    if ! asciinema convert -f asciicast-v2 "$filename" "$workfile"; then
      echo "❌ ERROR: Failed to convert cast v3 → v2." >&2
      return 1
    fi
  fi

  # now feed to agg
  if ! agg "$workfile" "${filename%.cast}.gif"; then
    echo "❌ ERROR: Failed to convert $workfile to GIF." >&2
    return 1
  fi

  return 0
}

function rec() {
  if ! ensure $_ZSH_ASCIINEMA_DEPS; then return 1; fi
  [[ ! -d "$HOME/asciinema" ]] && mkdir -p "$HOME/asciinema"

  (( $# )) && local filename="$HOME/asciinema/$@.cast" \
              || local filename="$HOME/asciinema/$(date +'%Y-%m-%d-%H-%M-%S').cast"

  asciinema rec "$filename" -c "_NO_HISTORY=1 _ASCIINEMA_SEGMENT=1 /usr/bin/env zsh" -i 2
  if [[ "$?" != 0 ]]; then
    echo "❌ ERROR: asciinema recording failed." >&2
    return 1
  fi

  # convert to gif
  if ! convert_cast "$filename"; then return 1; fi

  # check size and optimize only if needed
  local giffile="${filename%.cast}.gif"
  if [[ -f "$giffile" ]]; then
    local filesize=$(stat -c%s "$giffile" 2>/dev/null || stat -f%z "$giffile")
    if (( filesize > 2000000 )); then
      if command -v gifsicle &>/dev/null; then
        echo "⚡ Optimizing GIF (size > 2MB: $((filesize/1024)) KB)..."
        if ! gifsicle --lossy=80 -k 64 -O2 -Okeep-empty "$giffile" -o "${filename%.cast}.opt.gif"; then
          echo "❌ ERROR: GIF optimization failed." >&2
        fi
      else
        echo "ℹ️ Note: 'gifsicle' not found, skipping optimization." >&2
      fi
    else
      echo "✅ GIF is already small enough ($(($filesize/1024)) KB), skipping optimization."
    fi
  else
    echo "❌ ERROR: Expected GIF file not found: $giffile" >&2
    return 1
  fi
}

# plays a recorded asciinema cast
# if no argument is passed to this function it tries to guess the last recorded cast and play it
function play(){
  if ! ensure $_ZSH_ASCIINEMA_DEPS; then return; fi
  if [ -n "$@" ]; then
    local filename="$HOME/asciinema/$@.cast"
  else
    local filename=$(find "$HOME/asciinema" -type f -name '*.cast' -printf '%T@ %p\n' | sort -n | tail -1 | cut -d' ' -f2-)
  fi
  asciinema play "$filename"
}

# upload the specified asciinema recording to the asciinema server and copy its link into clipboard
# if no name is provided it tries to guess the last recorded cast and upload that
function asciiupload(){
  if ! ensure $_ZSH_ASCIINEMA_DEPS; then return; fi
  if [ -n "$@" ]; then
    local filename="$HOME/asciinema/$@.cast"
  else
    local filename=$(find /path/to/dir -type f -printf '%T@ %p\n' | sort -n | tail -1 | cut -d' ' -f2-)
  fi
  asciinema upload "$filename" |& tee /tmp/asciinema
  cat /tmp/asciinema | grep -m 1 "https://" | xargs | clipcopy
  echo "the URL is Copied to your clipboard!"
}
alias ascii-upload="asciiupload"

# disable command history for the current shell if it's an asciinema session
if (( $_ASCIINEMA_SEGMENT )); then
  # unsetopt HISTFILE
  export HISTSIZE=0
  export SAVEHIST=0
fi
