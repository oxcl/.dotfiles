#!/usr/bin/env bash

bg_hard() {
  export MY_THEME_BG_DIM="#070808"
  export MY_THEME_BG0="#131414"
  export MY_THEME_BG="#202020"
  export MY_THEME_BG1="#2a2827"
  export MY_THEME_BG2="#2e2c2b"
  export MY_THEME_BG3="#32302f"
  export MY_THEME_BG4="#3d3835"
  export MY_THEME_BG5="#46403d"
  export MY_THEME_BG6="#514945"
  export MY_THEME_BG7="#5a524c"
  export MY_THEME_BG8="#665c54"
  
  export MY_THEME_BG_GREEN="#32361a"
  export MY_THEME_BG_GREEN_SUBTLE="#333e34"
  export MY_THEME_BG_RED="#3c1f1e"
  export MY_THEME_BG_RED_SUBTLE="#442e2d"
  export MY_THEME_BG_BLUE="#0d3138"
  export MY_THEME_BG_BLUE_SUBTLE="#2e3b3b"
  export MY_THEME_BG_YELLOW="#473c29"
}

bg_medium() {
  export MY_THEME_BG_DIM="#101010"
  export MY_THEME_BG0="#1c1c1c"
  export MY_THEME_BG="#292828"
  export MY_THEME_BG1="#32302f"
  export MY_THEME_BG2="#383432"
  export MY_THEME_BG3="#3c3836"
  export MY_THEME_BG4="#45403d"
  export MY_THEME_BG5="#504945"
  export MY_THEME_BG6="#5a524c"
  export MY_THEME_BG7="#665c54"
  export MY_THEME_BG8="#7c6f64"

  export MY_THEME_BG_GREEN="#34381b"
  export MY_THEME_BG_GREEN_SUBTLE="#3b4439"
  export MY_THEME_BG_RED="#402120"
  export MY_THEME_BG_RED_SUBTLE="#4c3432"
  export MY_THEME_BG_BLUE="#0e363e"
  export MY_THEME_BG_BLUE_SUBTLE="#374141"
  export MY_THEME_BG_YELLOW="#4f422e"
}
bg_soft(){
  export MY_THEME_BG_DIM="#181919"
  export MY_THEME_BG0="#242424"
  export MY_THEME_BG="#32302f"
  export MY_THEME_BG1="#3c3836"
  export MY_THEME_BG2="#403c3a"
  export MY_THEME_BG3="#45403d"
  export MY_THEME_BG4="#504945"
  export MY_THEME_BG5="#5a524c"
  export MY_THEME_BG6="#665c54"
  export MY_THEME_BG7="#7c6f64"
  export MY_THEME_BG8="#928374"

  export MY_THEME_BG_GREEN="#3d4220"
  export MY_THEME_BG_GREEN_SUBTLE="#424a3e"
  export MY_THEME_BG_RED="#472322"
  export MY_THEME_BG_RED_SUBTLE="#543937"
  export MY_THEME_BG_BLUE="#0f3a42"
  export MY_THEME_BG_BLUE_SUBTLE="#404946"
  export MY_THEME_BG_YELLOW="#574833"
}
fg_original() {
  export MY_THEME_FG_DIM="#c9b99a"
  export MY_THEME_FG="#ebdbb2"
  export MY_THEME_RED="#fb4934"
  export MY_THEME_ORANGE="#fe8019"
  export MY_THEME_YELLOW="#fabd2f"
  export MY_THEME_GREEN="#b8bb26"
  export MY_THEME_AQUA="#8ec07c"
  export MY_THEME_BLUE="#83a598"
  export MY_THEME_PURPLE="#d3869b"
  
  export MY_THEME_RED_SUBTLE="#b85651"
  export MY_THEME_ORANGE_SUBTLE="#bd6f3e"
  export MY_THEME_YELLOW_SUBTLE="#c18f41"
  export MY_THEME_GREEN_SUBTLE="#8f9a52"
  export MY_THEME_AQUA_SUBTLE="#72966c"
  export MY_THEME_BLUE_SUBTLE="#68948a"
  export MY_THEME_PURPLE_SUBTLE="#ab6c7d"
}
fg_mix(){
  export MY_THEME_FG_DIM="#c5b18d"
  export MY_THEME_FG="#E2cca9"
  export MY_THEME_RED="#f2594b"
  export MY_THEME_ORANGE="#f28534"
  export MY_THEME_YELLOW="#e9b143"
  export MY_THEME_GREEN="#b0b846"
  export MY_THEME_AQUA="#8bba7f"
  export MY_THEME_BLUE="#80aa9e"
  export MY_THEME_PURPLE="#d3869b"
  
  export MY_THEME_RED_SUBTLE="#b85651"
  export MY_THEME_ORANGE_SUBTLE="#bd6f3e"
  export MY_THEME_YELLOW_SUBTLE="#c18f41"
  export MY_THEME_GREEN_SUBTLE="#8f9a52"
  export MY_THEME_AQUA_SUBTLE="#72966c"
  export MY_THEME_BLUE_SUBTLE="#68948a"
  export MY_THEME_PURPLE_SUBTLE="#ab6c7d"
}
fg_material(){
  export MY_THEME_FG_DIM="#c5b18d"
  export MY_THEME_FG="#D4be98"
  export MY_THEME_RED="#ea6962"
  export MY_THEME_ORANGE="#e78a4e"
  export MY_THEME_YELLOW="#d8a657"
  export MY_THEME_GREEN="#a9b665"
  export MY_THEME_AQUA="#89b482"
  export MY_THEME_BLUE="#7daea3"
  export MY_THEME_PURPLE="#d3869b"
  
  export MY_THEME_RED_SUBTLE="#b85651"
  export MY_THEME_ORANGE_SUBTLE="#bd6f3e"
  export MY_THEME_YELLOW_SUBTLE="#c18f41"
  export MY_THEME_GREEN_SUBTLE="#8f9a52"
  export MY_THEME_AQUA_SUBTLE="#72966c"
  export MY_THEME_BLUE_SUBTLE="#68948a"
  export MY_THEME_PURPLE_SUBTLE="#ab6c7d"
}

export MY_THEME_DARK_GREY="#7c6f64"
export MY_THEME_GREY="#928374"
export MY_THEME_LIGHT_GREY="#a89984"


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
