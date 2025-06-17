local wezterm = require("wezterm")
local M = {}

local custom_scheme = wezterm.color.get_builtin_schemes()["Catppuccin Mocha"]

---- tabbar
local tabbar_bg = "#121212"
local tab_fg = "#1C1B19"
custom_scheme.tab_bar.background = tabbar_bg
custom_scheme.tab_bar.new_tab = { bg_color = tabbar_bg, fg_color = "#FCE8C3", intensity = "Bold" }
custom_scheme.tab_bar.new_tab_hover = { bg_color = tabbar_bg, fg_color = "#FBB829", intensity = "Bold" }
custom_scheme.tab_bar.inactive_tab_hover = {
	bg_color = "#FF8700",
	fg_color = tab_fg,
}
custom_scheme.tab_bar.active_tab = {
	bg_color = "#FBB829",
	fg_color = tab_fg,
}
custom_scheme.tab_bar.inactive_tab = {
	bg_color = "#4E4E4E",
	fg_color = tab_fg,
}
M.default_scheme = "Custompuccin Mocha"
M.color_schemes = {
	[M.default_scheme] = custom_scheme,
}

return M
