local wezterm = require("wezterm")

config = wezterm.config_builder()

config = {
    disable_default_key_bindings = true,
    disable_default_mouse_bindings = true,
    keys = {
            -- Copy selection to clipboard
            { key = "C", mods = "CTRL|SHIFT", action = wezterm.action.CopyTo "Clipboard" },
            -- Paste from clipboard
            { key = "V", mods = "CTRL|SHIFT", action = wezterm.action.PasteFrom "Clipboard" },
      },
    mouse_bindings = {
        -- Left drag = select, auto-copy on release
        { event = { Down = { streak = 1, button = "Left" } },
          mods = "NONE",
          action = wezterm.action.SelectTextAtMouseCursor "Cell" },

        { event = { Drag = { streak = 1, button = "Left" } },
          mods = "NONE",
          action = wezterm.action.ExtendSelectionToMouseCursor "Cell" },

        { event = { Up = { streak = 1, button = "Left" } },
          mods = "NONE",
          action = wezterm.action.CompleteSelection "Clipboard" },

        -- Right click = paste
        { event = { Down = { streak = 1, button = "Right" } },
          mods = "NONE",
          action = wezterm.action.PasteFrom "Clipboard" },

          -- Scroll up/down by line
          {
            event = { Down = { streak = 1, button = { WheelUp = 1 } } },
            mods = "NONE",
            action = wezterm.action.ScrollByLine(-6),
          },
          {
            event = { Down = { streak = 1, button = { WheelDown = 1 } } },
            mods = "NONE",
            action = wezterm.action.ScrollByLine(6),
          },

          -- Faster scroll (PageUp/PageDown style)
          {
            event = { Down = { streak = 3, button = { WheelUp = 1 } } },
            mods = "NONE",
            action = wezterm.action.ScrollByPage(-1),
          },
          {
            event = { Down = { streak = 3, button = { WheelDown = 1 } } },
            mods = "NONE",
            action = wezterm.action.ScrollByPage(1),
          },
    },
	automatically_reload_config = true,
	enable_tab_bar = false,
	window_close_confirmation = "NeverPrompt",
	window_decorations = "RESIZE", -- disable the title bar but enable the resizbale border
	default_cursor_style = "BlinkingBar",
	tab_bar_at_bottom = true,
	use_fancy_tab_bar = false,
	font = wezterm.font("FiraCode Nerd Font Mono", {weight="Regular", stretch="Normal", style="Normal"}), -- (AKA: Iosevka NFM, Iosevka NFM Medium Obl) /Users/jayrgarg/Library/Fonts/IosevkaNerdFontMono-MediumOblique.ttf, CoreText --wezterm.font("JetBrains Mono", { weight = "Bold" }),
	font_size = 12.5,
	color_scheme = 'Red Sands (Gogh)',-- 'Dracula (Official)',--'Lunaria Light (Gogh)',--"Nord (Gogh)",
 	background = {
        {
			source = {
				--File = "/Users/jayrgarg/Pictures/backgrounds/future-city.png",
				File = "/home/jgarg/Pictures/backgrounds/background.jpg",
			},
			width = "100%",
			height = "100%",
		},
        {
            source = {
                --Color = "black",--"#282c35",
                --Color = "#2e3440",--"#282c35",
                Color = "#002b36",--"#282c35",
            },
            width = "100%",
            height = "100%",
            opacity = 0.80,
        },
    },
	window_padding = {
		left = 5,
		right = 5,
--		top = 0,
--		bottom = 0,
	},
}

return config
