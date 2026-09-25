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

  -- Forward CMD chords to Herdr as kitty-protocol CSI-u sequences.
  -- WezTerm does not report the super/CMD bit to the running app on macOS
  -- (wezterm#4589), so Herdr never sees the "cmd+..." bindings in its
  -- config.toml [keys] table. Encode the sequences by hand instead.
  -- Modifier field is 1 + bitmask, where shift=1, alt=2, ctrl=4, super=8.
  -- Letters: CSI <codepoint> ; <mods> u   Arrows: CSI 1 ; <mods> <A|B|C|D>
  { key = "d", mods = "CMD", action = act.SendString("\x1b[100;9u") },
  { key = "d", mods = "CMD|SHIFT", action = act.SendString("\x1b[100;10u") },
  { key = "r", mods = "CMD|SHIFT", action = act.SendString("\x1b[114;10u") },
  { key = "UpArrow", mods = "CMD|OPT", action = act.SendString("\x1b[1;11A") },
  { key = "DownArrow", mods = "CMD|OPT", action = act.SendString("\x1b[1;11B") },
  { key = "RightArrow", mods = "CMD|OPT", action = act.SendString("\x1b[1;11C") },
  { key = "LeftArrow", mods = "CMD|OPT", action = act.SendString("\x1b[1;11D") },
}

return config
