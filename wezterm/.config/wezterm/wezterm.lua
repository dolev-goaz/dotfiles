-- Remember to set $WEZTERM_CONFIG_FILE before launching wezterm(from desktop/terminal)
local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- source: https://wezterm.org/config/lua/wezterm/target_triple.html
local macos_targets = { "x86_64-apple-darwin", "aarch64-apple-darwin" }
local linux_targets = { "x86_64-unknown-linux-gnu" }
local windows_targets = { "x86_64-pc-windows-msvc" }
local function in_array(array, value)
	for _, v in ipairs(array) do
		if v == value then
			return true
		end
	end
	return false
end
local get_os_target = function()
	local target = wezterm.target_triple
	if in_array(macos_targets, target) then
		return "macos"
	elseif in_array(linux_targets, target) then
		return "linux"
	elseif in_array(windows_targets, target) then
		return "windows"
	else
		return "unknown"
	end
end

local os = get_os_target()

-- https://github.com/wez/wezterm/issues/3299#issuecomment-2145712082
if os == "macos" then
	wezterm.on("gui-startup", function(cmd)
		local active = wezterm.gui.screens().active
		local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
		window:gui_window():set_position(active.x, active.y)
		window:gui_window():set_inner_size(active.width, active.height)
	end)
elseif os == "linux" then
	config.enable_wayland = false
end

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
config.warn_about_missing_glyphs = false
wezterm.on("format-tab-title", tabs.format_tab_title)

-- keys
local keys = require("keys")
config.keys = keys

-- window settings
config.window_close_confirmation = "NeverPrompt"

-- config.window_background_image = wezterm.config_dir .. "/background-tinted.jpg"
-- config.window_background_image_hsb = {
-- 	brightness = 0.2,
-- }
-- config.window_background_image = wezterm.config_dir .. "/background.jpg"
-- config.window_background_image_hsb = {
-- 	brightness = 0.02,
-- }

-- config.window_background_opacity = 1
-- NOTE: only works on nightly build
-- config.kde_window_background_blur = true
return config
