-- Remember to set $WEZTERM_CONFIG_FILE before launching wezterm(from desktop/terminal)
local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.font = wezterm.font_with_fallback({
	"FiraCode Nerd Font",
	"Noto Sans Hebrew",
})
config.font_size = 13
config.bidi_enabled = true -- https://github.com/wezterm/wezterm/commit/98f35bbf24619e7f2a930ba5e525fcd7704640a9
-- config.bidi_direction = "AutoLeftToRight"

-- color schemes
local color_schemes = require("color_schemes")
config.color_schemes = color_schemes.color_schemes
config.color_scheme = color_schemes.default_scheme

-- tab bar
local tabs = require("tabs")
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.show_tab_index_in_tab_bar = false
config.use_fancy_tab_bar = false
wezterm.on("format-tab-title", tabs.format_tab_title)

-- window settings
config.window_close_confirmation = "NeverPrompt"

-- config.window_background_image = wezterm.config_dir .. "/background-tinted.jpg"
-- config.window_background_image_hsb = {
-- 	brightness = 0.2,
-- }
config.window_background_image = wezterm.config_dir .. "/background.jpg"
config.window_background_image_hsb = {
	brightness = 0.02,
}

-- config.window_background_opacity = 1
-- NOTE: only works on nightly build
-- config.kde_window_background_blur = true
return config
