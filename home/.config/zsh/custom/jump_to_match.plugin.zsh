# this function checks if the  cursor is on a parenthesis character and if it is. it jumps to the other pair of it
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

zle -N jump_to_match
bindkey -e '^D' jump_to_match 
