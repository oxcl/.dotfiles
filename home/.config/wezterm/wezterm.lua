local wezterm = require("wezterm")
local colors = require("theme")
local config = wezterm.config_builder()

config.enable_tab_bar = false

config.colors = colors
--config.font = wezterm.font_with_fallback {
--  {family = "ioZevka Mono", stretch = "Expanded", weight = "Bold" },
--  {family = "Vazir Code", scale = 1.1 }
--}

config.font_size = 10.5

config.cell_width = 1.1

config.harfbuzz_features = { 'calt', 'clig', 'liga' }

return config
