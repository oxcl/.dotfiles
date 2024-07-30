# this function checks if the  cursor is on a parenthesis character and if it is. it jumps to the other pair of it
# but if it's not it will instead search for the next occurrence of the word that is under or before the cursor
function jump_to_match(){
    local char=${RBUFFER:0:1}
    if [[ "$CURSOR" == "$_LAST_OCCURRENCE_JUMP_POS" ]]; then
	# check if the jump is a part of a series of occurrence jumps or not.
	# this check is done because when jumping to next occurrence, the cursor in placed at the end of the word.
	# and if the character after the search is a parenthesis pair then the next invokation of jump_to_match will
	# jump to the the other parenthesis pair which is not desirable.
	jump_to_next_occurrence
    elif [[\
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

# finds the word under the cursor and searches for the next occurrence of it in the buffer
# if no match is found the search is wrapped around the beginning of the buffer
function jump_to_next_occurrence(){
    if [[ -n "$1" ]]; then
	local word="$1"
    else
        # grab the word under the cursor
        local left_of_word="$(echo $LBUFFER | grep -oE '\b(\w|-|_)*$')"
        local right_of_word="$(echo $RBUFFER | grep -oE '^(\w|-|_)*\b')"
        local word="$left_of_word$right_of_word"
    fi
    # search for occurrences of the word 
    if [[ -n "$word" ]]; then
	local next_occurrence_index="$(echo $RBUFFER | grep -obE '\b'$word'\b' | head -n1 |cut -d':' -f1)"
	if [[ -n "$next_occurrence_index" ]]; then
            # if an occurrence was found at the right of the buffer jump to it
	    CURSOR=$(( CURSOR + next_occurrence_index + $#word ))
	    _LAST_OCCURRENCE_JUMP_POS=$CURSOR
	else
	    # wrap around the beginning of the buffer and search for occurrences. if there
	    # is only one occurrence of a word in the buffer the cursor will stay at the end of that word
	    CURSOR=0
	    jump_to_next_occurrence "$word"
        fi
    fi
}

zle -N jump_to_match
bindkey -e '^D' jump_to_match 
