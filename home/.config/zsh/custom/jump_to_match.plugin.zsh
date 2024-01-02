# this function checks if the block cursor is on a parenthesis character and if it is. it jumps to the other pair of it
# but if it's not it will instead search for the next occurrence of the word that is under or before the cursor
function jump_to_match(){
    local char=${RBUFFER:0:1}
    if [[\
      "$char" == "("  || "$char" == ")" || \
      "$char" == "[" || "$char" == "]" ||\
      "$char" == "{" || "$char" == "}"
    ]]; then
      # jump back and forth between parenthesis pairs
        zle vi-match-bracket
    else
        jump_to_next_occurrence
    fi
}

# jump to the next occurrence of the word that is under/before the cursor.
# wraps around the beginning if reaches the end of the buffer
function jump_to_next_occurrence() {
    local cursor_pos="$CURSOR"
    zle backward-word
    local first_of_word="$CURSOR"
    zle forward-word
    zle backward-char
    local last_of_word="$CURSOR"
    CURSOR="$cursor_pos"
    local word_length=$((last_of_word - first_of_word ))
    local query_word="${BUFFER:$first_of_word:$word_length}"
    CURSOR="$cursor_pos"
    #    local occurrence_pos="${RBUFFER[(i)[$word]]}"
    echo $RBUFFER - $query_word - ${RBUFFER%%$query_word*}
#    if [[ -n "$occurrence_pos" ]]; then
#	CURSOR=$(( $CURSOR - $#LBUFFER - $#occurrence_pos + $#word ))
#    fi
}

zle -N jump_to_match
bindkey -e '^D' jump_to_match 
