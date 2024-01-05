#!/usr/bin/env zsh
# theme color declarations
# these values are used  x11 xrdb in my current setup
# currently i use: gruvbox-material
export MY_THEME_MODE=dark # dark | light
export MY_THEME_VARIANT=material # material | mix | original
export MY_THEME_BG=soft # hard | medium | soft

# Function to set background colors. these colors are affected by MY_THEME_BG variable
set_bg_colors() {
  export COLOR_BG_DIM="$1"
  export COLOR_BG_0="$2"
  export COLOR_BG_1="$3"
  export COLOR_BG_2="$4"
  export COLOR_BG_3="$5"
  export COLOR_BG_4="$6"
  export COLOR_BG_5="$7"
  export COLOR_BG_STATUSLINE_1="$8"
  export COLOR_BG_STATUSLINE_2="$9"
  export COLOR_BG_STATUSLINE_3="${10}"
  export COLOR_BG_DIFF_GREEN="${11}"
  export COLOR_BG_VISUAL_GREEN="${12}"
  export COLOR_BG_DIFF_RED="${13}"
  export COLOR_BG_VISUAL_RED="${14}"
  export COLOR_BG_DIFF_BLUE="${15}"
  export COLOR_BG_VISUAL_BLUE="${16}"
  export COLOR_BG_VISUAL_YELLOW="${17}"
  export COLOR_BG_CURRENT_WORD="${18}"
}

# Function to set foreground color variables. these colors are affected by MY_THEME_VARIANT variable
set_fg_colors() {
  export COLOR_FG_0="$1"
  export COLOR_FG_1="$2"
  export COLOR_RED="$3"
  export COLOR_ORANGE="$4"
  export COLOR_YELLOW="$5"
  export COLOR_GREEN="$6"
  export COLOR_AQUA="$7"
  export COLOR_BLUE="$8"
  export COLOR_PURPLE="$9"
  # these are background colors but since they are affected by MY_THEME_VARIANT, they are placed here
  export COLOR_RED_BG="${10}"
  export COLOR_GREEN_BG="${11}"
  export COLOR_YELLOW_BG="${12}"
  
  export COLOR_GREY_0="${13}"
  export COLOR_GREY_1="${14}"
  export COLOR_GREY_2="${15}"

}

# Set Background Colors
if [[ "$MY_THEME_MODE" == "dark" ]]; then
    if [[ "$MY_THEME_BG" == "hard" ]]; then
      set_bg_colors '#141617' '#1d2021' '#282828' '#282828' '#3c3836' '#3c3836' '#504945' '#282828' '#32302f' '#504945' '#32361a' '#333e34' '#3c1f1e' '#442e2d' '#0d3138' '#2e3b3b' '#473c29' '#32302f'
    elif [[ "$MY_THEME_BG" == "medium" ]]; then
      set_bg_colors '#1b1b1b' '#282828' '#32302f' '#32302f' '#45403d' '#45403d' '#5a524c' '#32302f' '#3a3735' '#504945' '#34381b' '#3b4439' '#402120' '#4c3432' '#0e363e' '#374141' '#41422e' '#3c3836'
    elif [[ "$MY_THEME_BG" == "soft" ]]; then
      set_bg_colors '#252423' '#32302f' '#3c3836' '#3c3836' '#504945' '#504945' '#665c54' '#3c3836' '#46413e' '#5b534d' '#3d4220' '#424a3e' '#472322' '#543937' '#0f3a42' '#404946' '#574833' '#45403d'
    else
	echo "Invalid background option for MY_THEME_BG '$MY_THEME_BG'" >&2
    fi
elif [[ "$MY_THEME_MODE" == "light" ]]; then
    if [[ "$MY_THEME_BG" == "hard" ]]; then
	set_bg_colors ‘#f3eac7’ ‘#f9f5d7’ ‘#f5edca’ ‘#f3eac7’ ‘#f2e5bc’ ‘#eee0b7’ ‘#ebdbb2’ ‘#f5edca’ ‘#f3eac7’ ‘#eee0b7’ ‘#e4edc8’ ‘#dde5c2’ ‘#f8e4c9’ ‘#f0ddc3’ ‘#e0e9d3’ ‘#d9e1cc’ ‘#f9eabf’ '#f3eac7'
    elif [[ "$MY_THEME_BG" == "medium" ]]; then
	set_bg_colors ‘#f2e5bc’ ‘#fbf1c7’ ‘#f4e8be’ ‘#f2e5bc’ ‘#eee0b7’ '#e5d5ad' ‘#ddccab’ ‘#f2e5bc’ ‘#f2e5bc’ ‘#e5d5ad’ ‘#e6eabc’ ‘#dee2b6’ ‘#f9e0bb’ ‘#f1d9b5’ ‘#e2e6c7’ ‘#dadec0’ ‘#fae7b3’ ‘#f2e5bc’
    elif [[ "$MY_THEME_BG" == "soft" ]]; then
	set_bg_colors '#ebdbb2' '#f2e5bc' '#eddeb5' '#ebdbb2' '#e6d5ae' '#dac9a5' '#d5c4a1' '#ebdbb2' '#ebdbb2' '#dac9a5' '#dfe1b4' '#d7d9ae' '#f7d9b9' '#efd2b3' '#dbddbf' '#d3d5b8' '#f3deaa' '#ebdbb2'
    else
      echo "Invalid background option for MY_THEME_BG '$MY_THEME_BG'" >&2
    fi    
else
  echo "Invalid mode option"
fi
unset set_bg_colors

# Set Foreground Colors
if [[ "$MY_THEME_MODE" == "dark" ]]; then
    if [[ "$MY_THEME_VARIANT" == "material" ]]; then
      set_fg_colors '#d4be98' '#ddc7a1' '#ea6962' '#e78a4e' '#d8a657' '#a9b665' '#98b482' '#7daea3' '#d3869b' '#ea6962' '#a9b665' '#d8a657' '#7c6f64' '#928374' '#a89984'

    elif [[ "$MY_THEME_VARIANT" == "mix" ]]; then
      set_fg_colors '#e2cca9' '#e2cca9' '#f2594b' '#f28534' '#e9b143' '#b0b846' '#8bba7f' '#80aa9e' '#d3869b' '#db4740' '#b0b846' '#e9b143' '#7c6f64' '#928374' '#a89984'
    elif [[ "$MY_THEME_VARIANT" == "original" ]]; then
      set_fg_colors '#ebdbb2' '#ebdbb2' '#fb4934' '#fe8019' '#fabd2f' '#b8bb26' '#8ec07c' '#83a598' '#d3869b' '#cc241d' '#b8bb26' '#fabd2f' '#7c6f64' '#928374' '#a89984'
    else
      echo "Invalid background option for MY_THEME_VARIANT '$MY_THEME_VARIANT'" >&2
    fi
elif [[ "$MY_THEME_MODE" == "light" ]]; then
    if [[ "$MY_THEME_VARIANT" == "material" ]]; then
      set_fg_colors '#654735' '#4f3829' '#c14a4a' '#c35e0a' '#b47109' '#6c782e' '#4c7a5d' '#45707a' '#945e80' '#ae5858' '#6f8352' '#a96b2c' '#a89984' '#928374' '#7c6f64'
    elif [[ "$MY_THEME_VARIANT" == "mix" ]]; then
      set_fg_colors '#514036' '#514036' '#af2528' '#b94c07' '#b4730e' '#72761e' '#477a5b' '#266b79' '#924f79' '#ae5858' '#6f8352' '#a96b2c' '#a89984' '#928374' '#7c6f64'
    elif [[ "$MY_THEME_VARIANT" == "original" ]]; then
      set_fg_colors '#3c3836' '#3c3836' '#9d0006' '#af3a03' '#b57614' '#79740e' '#427b85' '#076678' '#8f3f71' '#ae5858' '#6f8352' '#a96b2c' '#a89984' '#928374' '#7c6f64'
    else
      echo "Invalid background option for MY_THEME_VARIANT '$MY_THEME_VARIANT'" >&2
    fi    
else
  echo "Invalid mode option"
fi
unset set_fg_colors

