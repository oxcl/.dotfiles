#!/usr/bin/env bash

bg_hard(){
  export MY_THEME_BG_DIM="#f2e5bc"
  export MY_THEME_BG0="#f3eac7"
  export MY_THEME_BG="#f9f5d7"
  export MY_THEME_BG1="#fbf1c7"
  export MY_THEME_BG2="#f2e5bc"
  export MY_THEME_BG3="#f2e5bc"
  export MY_THEME_BG4="#ebdbb2"
  export MY_THEME_BG5="#e0cfa9"
  export MY_THEME_BG6="#d5c4a1"
  export MY_THEME_BG7="#c9b99a"
  export MY_THEME_BG8="#bdae93"
}

bg_medium(){
  export MY_THEME_BG_DIM="#f2e5bc"
  export MY_THEME_BG0="#f6ebc1"
  export MY_THEME_BG="#fbf1c7"
  export MY_THEME_BG1="#f2e5bc"
  export MY_THEME_BG2="#eee0b7"
  export MY_THEME_BG3="#ebdbb2"
  export MY_THEME_BG4="#e0cfa9"
  export MY_THEME_BG5="#d5c4a1"
  export MY_THEME_BG6="#c9b99a"
  export MY_THEME_BG7="#bdae93"
  export MY_THEME_BG8="#a89984"
}

bg_soft(){
  export MY_THEME_BG_DIM="#ebdbb2"
  export MY_THEME_BG0="#efe0b7"
  export MY_THEME_BG="#f2e5bc"
  export MY_THEME_BG1="#ebdbb2"
  export MY_THEME_BG2="#e6d5ae"
  export MY_THEME_BG3="#e0cfa9"
  export MY_THEME_BG4="#d5c4a1"
  export MY_THEME_BG5="#c9b99a"
  export MY_THEME_BG6="#bdae93"
  export MY_THEME_BG7="#a89984"
  export MY_THEME_BG8="#928374"
}

fg_hard(){
  export MY_THEME_FG0="#3c3836"
  export MY_THEME_FG="#3c3836"
  export MY_THEME_FG1="#504945"
  export MY_THEME_RED="#9d0006"
  export MY_THEME_ORANGE="#af3a03"
  export MY_THEME_YELLOW="#b57614"
  export MY_THEME_GREEN="#79740e"
  export MY_THEME_AQUA="#427b58"
  export MY_THEME_BLUE="#076678"
  export MY_THEME_PURPLE"#8f3f71"
  
  export MY_THEME_RED_SUBTLE="#ea6962"
  export MY_THEME_ORANGE_SUBTLE="#e78a4e"
  export MY_THEME_YELLOW_SUBTLE="#d8a657"
  export MY_THEME_GREEN_SUBTLE="#a9b665"
  export MY_THEME_AQUA_SUBTLE="#89b482"
  export MY_THEME_BLUE_SUBTLE="#7daea3"
  export MY_THEME_PURPLE_SUBTLE="#d3869b"
}
fg_mix(){
  export MY_THEME_FG0="#514036"
  export MY_THEME_FG="#514036"
  export MY_THEME_FG1="#6f4f3c"
  export MY_THEME_RED="#af2528"
  export MY_THEME_ORANGE="#b94c07"
  export MY_THEME_YELLOW="#b4730e"
  export MY_THEME_GREEN="#72761e"
  export MY_THEME_AQUA="#477a5b"
  export MY_THEME_BLUE="#266b79"
  export MY_THEME_PURPLE="#924f79"
  
  export MY_THEME_RED_SUBTLE="#ea6962"
  export MY_THEME_ORANGE_SUBTLE="#e78a4e"
  export MY_THEME_YELLOW_SUBTLE="#d8a657"
  export MY_THEME_GREEN_SUBTLE="#a9b665"
  export MY_THEME_AQUA_SUBTLE="#89b482"
  export MY_THEME_BLUE_SUBTLE="#7daea3"
  export MY_THEME_PURPLE_SUBTLE="#d3869b"
}

fg_material(){
  export MY_THEME_FG0="#4f3829"
  export MY_THEME_FG="#654735"
  export MY_THEME_FG1="#6f4f3c"
  export MY_THEME_RED="#c14a4a"
  export MY_THEME_ORANGE="#c35e0a"
  export MY_THEME_YELLOW="#b47109"
  export MY_THEME_GREEN="#6c782e"
  export MY_THEME_AQUA="#4c7a5d"
  export MY_THEME_BLUE="#45707a"
  export MY_THEME_PURPLE="#945e80"
  
  export MY_THEME_RED_SUBTLE="#ea6962"
  export MY_THEME_ORANGE_SUBTLE="#e78a4e"
  export MY_THEME_YELLOW_SUBTLE="#d8a657"
  export MY_THEME_GREEN_SUBTLE="#a9b665"
  export MY_THEME_AQUA_SUBTLE="#89b482"
  export MY_THEME_BLUE_SUBTLE="#7daea3"
  export MY_THEME_PURPLE_SUBTLE="#d3869b"
}


export MY_THEME_LIGHT_GREY="#a89984"
export MY_THEME_GREY="#928374"
export MY_THEME_DARK_GREY="#7c6f64"

if [[ "$MY_THEME_STYLE" == "original" ]]; then
  fg_original
elif [[ "$MY_THEME_STYLE" == "mix" ]]; then
  fg_mix
elif [[ "$MY_THEME_STYLE" == "material" ]]; then
  fg_material
else
  echo "MY_THEME_STYLE of '$MY_THEME_STYLE' is not valid for gruvbox-material" >&2
fi
if [[ "$MY_THEME_BG" == "hard" ]]; then
  bg_hard
elif [[ "$MY_THEME_BG" == "medium" ]]; then
  bg_medium
elif [[ "$MY_THEME_BG" == "soft" ]]; then
  bg_soft
else
  echo "MY_THEME_BG of '$MY_THEME_BG' is not valid for gruvbox-material" >&2
fi
