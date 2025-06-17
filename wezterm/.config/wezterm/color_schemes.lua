local wezterm = require("wezterm")
local M = {}

local custom_scheme = wezterm.color.get_builtin_schemes()["Catppuccin Mocha"]

---- tabbar
local tabbar_bg = "#121212"
local tab_fg = "#1C1B19"
local accent_primary = "#89b4fa"
custom_scheme.tab_bar.background = tabbar_bg
custom_scheme.tab_bar.new_tab = { bg_color = tabbar_bg, fg_color = "#b4befe", intensity = "Bold" }
custom_scheme.tab_bar.new_tab_hover = { bg_color = tabbar_bg, fg_color = accent_primary, intensity = "Bold" }
custom_scheme.tab_bar.inactive_tab_hover = {
	bg_color = "#585b70",
	fg_color = tab_fg,
}
custom_scheme.tab_bar.active_tab = {
	bg_color = accent_primary,
	fg_color = tab_fg,
}
custom_scheme.tab_bar.inactive_tab = {
	bg_color = "#45475a",
	fg_color = tab_fg,
}
M.default_scheme = "Custompuccin Mocha"
M.color_schemes = {
	[M.default_scheme] = custom_scheme,
}

return M
