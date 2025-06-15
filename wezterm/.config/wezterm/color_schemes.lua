local wezterm = require("wezterm")
local M = {}

local custom_scheme = wezterm.color.get_builtin_schemes()["Catppuccin Mocha"]
custom_scheme.tab_bar.background = "#121212"
custom_scheme.tab_bar.new_tab = { bg_color = "#121212", fg_color = "#FCE8C3", intensity = "Bold" }
custom_scheme.tab_bar.new_tab_hover = { bg_color = "#121212", fg_color = "#FBB829", intensity = "Bold" }
M.default_scheme = "Custompuccin Mocha"
M.color_schemes = {
	[M.default_scheme] = custom_scheme,
}

return M
