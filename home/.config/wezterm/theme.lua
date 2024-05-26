local colors = {
  foreground = "#d4be98",
  background = "#202020",

  cursor_bg = '#c5b18d',
  cursor_fg = '#202020',

  -- Specifies the border color of the cursor when the cursor style is set to Block,
  -- or the color of the vertical or horizontal bar when the cursor style is set to
  -- Bar or Underline.
  cursor_border = '#c5b18d',

  selection_fg = 'none',
  selection_bg = '#2e2c2b',

  scrollbar_thumb = '#5a524c',

  -- The color of the split lines between panes
  split = '#131414',

  ansi = {
    '#181919',
    '#ea6962',
    '#a9b665',
    '#d8a657',
    '#7daea3',
    '#d3869b',
    '#89b482',
    '#ddc7a1',
  },
  brights = {
    '#181919',
    '#ea6962',
    '#a9b665',
    '#d8a657',
    '#7daea3',
    '#d3869b',
    '#89b482',
    '#ddc7a1'
  },

  -- Arbitrary colors of the palette in the range from 16 to 255
  -- indexed = { [136] = '#af8700' },

  -- Since: 20220319-142410-0fcdea07
  -- When the IME, a dead key or a leader key are being processed and are effectively
  -- holding input pending the result of input composition, change the cursor
  -- to this color to give a visual cue about the compose state.
  compose_cursor = '#e78a4e',

  -- Colors for copy_mode and quick_select
  -- available since: 20220807-113146-c2fee766
  -- In copy_mode, the color of the active text is:
  -- 1. copy_mode_active_highlight_* if additional text was selected using the mouse
  -- 2. selection_* otherwise
  -- copy_mode_active_highlight_bg = { Color = '#000000' },
  -- use `AnsiColor` to specify one of the ansi color palette values
  -- (index 0-15) using one of the names "Black", "Maroon", "Green",
  --  "Olive", "Navy", "Purple", "Teal", "Silver", "Grey", "Red", "Lime",
  -- "Yellow", "Blue", "Fuchsia", "Aqua" or "White".
  -- copy_mode_active_highlight_fg = { AnsiColor = 'Black' },
  -- copy_mode_inactive_highlight_bg = { Color = '#52ad70' },
  -- copy_mode_inactive_highlight_fg = { AnsiColor = 'White' },

  -- quick_select_label_bg = { Color = 'peru' },
  -- quick_select_label_fg = { Color = '#ffffff' },
  -- quick_select_match_bg = { AnsiColor = 'Navy' },
  -- quick_select_match_fg = { Color = '#ffffff' },
}

return colors
