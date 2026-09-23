local wezterm = require("wezterm")

local config = wezterm.config_builder()
local act = wezterm.action

config.color_scheme = "rose-pine-moon"
config.font_size = 15.0
config.window_background_opacity = 0.8
config.macos_window_background_blur = 50
config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "RESIZE"
config.native_macos_fullscreen_mode = true

config.keys = {
  -- Rebind OPT-Left, OPT-Right as ALT-b, ALT-f respectively to match
  -- Terminal.app behavior
  {
    key = "LeftArrow",
    mods = "OPT",
    action = act.SendKey({ key = "b", mods = "ALT" }),
  },
  {
    key = "RightArrow",
    mods = "OPT",
    action = act.SendKey({ key = "f", mods = "ALT" }),
  },
  -- Toggle fullscreen with CMD-CTRL-f, matching macOS convention
  {
    key = "f",
    mods = "CMD|CTRL",
    action = act.ToggleFullScreen,
  },
}

return config
