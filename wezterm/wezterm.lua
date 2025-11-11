local wezterm = require("wezterm")

local config = wezterm.config_builder()

-- ======== GLOBAL DEFAULTS ========
config.disable_default_key_bindings = true
config.disable_default_mouse_bindings = true
config.automatically_reload_config = true
config.enable_tab_bar = false
config.window_close_confirmation = "NeverPrompt"
config.window_decorations = "RESIZE"
config.default_cursor_style = "BlinkingBar"
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.font = wezterm.font("Iosevka Term Nerd Font Mono", {weight="Regular"})
config.font_size = 12.0
config.line_height = 1.05
config.color_scheme = "Tokyo Night Storm"--"Scarlet Protocol"  -- default fallback
-- config.colors = {
--     background = "#1a1c22",
--     foreground = "#e4e6eb"
-- }
-- config.window_background_opacity = 0.97
config.window_padding = { left = 5, right = 5 }

config.keys = {
  { key = "C", mods = "CTRL|SHIFT", action = wezterm.action.CopyTo "Clipboard" },
  { key = "V", mods = "CTRL|SHIFT", action = wezterm.action.PasteFrom "Clipboard" },
}

config.mouse_bindings = {
  { event = { Down = { streak = 1, button = "Left" } }, mods = "NONE",
    action = wezterm.action.SelectTextAtMouseCursor "Cell" },
  { event = { Drag = { streak = 1, button = "Left" } }, mods = "NONE",
    action = wezterm.action.ExtendSelectionToMouseCursor "Cell" },
  { event = { Up = { streak = 1, button = "Left" } }, mods = "NONE",
    action = wezterm.action.CompleteSelection "Clipboard" },
  { event = { Down = { streak = 1, button = "Right" } }, mods = "NONE",
    action = wezterm.action.PasteFrom "Clipboard" },
  { event = { Down = { streak = 1, button = { WheelUp = 1 } } }, mods = "NONE",
    action = wezterm.action.ScrollByLine(-6) },
  { event = { Down = { streak = 1, button = { WheelDown = 1 } } }, mods = "NONE",
    action = wezterm.action.ScrollByLine(6) },
  { event = { Down = { streak = 3, button = { WheelUp = 1 } } }, mods = "NONE",
    action = wezterm.action.ScrollByPage(-1) },
  { event = { Down = { streak = 3, button = { WheelDown = 1 } } }, mods = "NONE",
    action = wezterm.action.ScrollByPage(1) },
}

-- ======== PER-PROFILE OVERRIDES ========
local profiles = {}

-- 🔴 Scarlet Protocol (WS1 / “work” terminal)
profiles.run = function(c)
  c.color_scheme = "Scarlet Protocol"
  c.window_background_opacity = 0.93
end

-- 💚 Cyberdyne (WS2 / “edit” terminal)
profiles.edit = function(c)
  c.color_scheme = "Cyberdyne"
  c.window_background_opacity = 0.95
end

-- Apply profile based on env var
local PROFILE = os.getenv("WEZTERM_PROFILE")
if PROFILE and profiles[PROFILE] then
  profiles[PROFILE](config)
end

return config
