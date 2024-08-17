local wezterm = require('wezterm')
local config = wezterm.config_builder()

config.font = wezterm.font('BerkeleyMonoVariable Nerd Font Mono')
config.font_size = 22

config.freetype_load_target = 'Light'

config.color_scheme = 'Catppuccin Mocha'

config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true
-- Only allow resizing, no title bar
-- config.window_decorations = 'INTEGRATED_BUTTONS|RESIZE'
config.window_decorations = 'RESIZE'

config.window_background_opacity = 0.8
config.macos_window_background_blur = 30

-- Use full space to allow better interop with yabai
config.native_macos_fullscreen_mode = true

config.keys = {
  {
    key = 'Enter',
    mods = 'SUPER',
    action = wezterm.action.ToggleFullScreen,
  },
  {
    key = 'p',
    mods = 'SUPER',
    action = wezterm.action.ActivateCommandPalette,
  },
}

config.window_padding = {
  top = 5,
  bottom = 5,
  left = 10,
  right = 5,
}

-- then finally apply the plugin
-- these are currently the defaults:
wezterm.plugin.require('https://github.com/nekowinston/wezterm-bar').apply_to_config(config, {
  position = 'bottom',
  max_width = 32,
  dividers = 'slant_right', -- or "slant_left", "arrows", "rounded", false
  indicator = {
    leader = {
      enabled = true,
      off = ' ',
      on = ' ',
    },
    mode = {
      enabled = true,
      names = {
        resize_mode = 'RESIZE',
        copy_mode = 'VISUAL',
        search_mode = 'SEARCH',
      },
    },
  },
  tabs = {
    numerals = 'arabic',        -- or "roman"
    pane_count = 'superscript', -- or "subscript", false
    brackets = {
      active = { '', ':' },
      inactive = { '', ':' },
    },
  },
  clock = {           -- note that this overrides the whole set_right_status
    enabled = true,
    format = '%H:%M', -- use https://wezfurlong.org/wezterm/config/lua/wezterm.time/Time/format.html
  },
})

return config