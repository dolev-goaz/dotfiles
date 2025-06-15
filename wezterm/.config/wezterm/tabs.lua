-- Source
-- https://github.com/wezterm/wezterm/discussions/628#discussioncomment-1874614

local wezterm = require("wezterm")
local M = {}
-- Equivalent to POSIX basename(3)
-- Given "/foo/bar" returns "bar"
-- Given "c:\\foo\\bar" returns "bar"
local function basename(s)
	return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

local SOLID_LEFT_ARROW = "" -- U+E0BA
local SOLID_LEFT_MOST = "█" -- U+2588
local SOLID_RIGHT_ARROW = "" -- U+E0BC

local ADMIN_ICON = "" -- U+F49C

local CMD_ICON = "" -- U+E62A
local NU_ICON = "" -- U+E7A8
local PS_ICON = "" -- U+E70F
local ELV_ICON = "ﱯ" -- U+FC6F
local YORI_ICON = "" -- U+F1D4

local VIM_ICON = "" -- U+E62B
local FUZZY_ICON = "" -- U+F0B0
local HOURGLASS_ICON = "" -- U+F252

local NODE_ICON = "" -- U+E74E
local DENO_ICON = "" -- U+E628
local LAMBDA_ICON = "ﬦ" -- U+FB26

function M.format_tab_title(tab, tabs, panes, config, hover, max_width)
	local edge_background = "#121212"
	local background = "#4E4E4E"
	local foreground = "#1C1B19"

	if tab.is_active then
		background = "#FBB829"
		foreground = "#1C1B19"
	elseif hover then
		background = "#FF8700"
		foreground = "#1C1B19"
	end

	local edge_foreground = background
	local process_name = tab.active_pane.foreground_process_name
	local pane_title = tab.active_pane.title
	local exec_name = basename(process_name):gsub("%.exe$", "")
	local title_with_icon

	if exec_name == "nu" then
		title_with_icon = NU_ICON .. " NuShell"
	elseif exec_name == "pwsh" then
		title_with_icon = PS_ICON .. " PS"
	elseif exec_name == "cmd" then
		title_with_icon = CMD_ICON .. " CMD"
	elseif exec_name == "elvish" then
		title_with_icon = ELV_ICON .. " Elvish"
	elseif exec_name == "yori" then
		title_with_icon = YORI_ICON .. " " .. pane_title:gsub(" %- Yori", "")
	elseif exec_name == "nvim" then
		title_with_icon = VIM_ICON .. " " .. pane_title:gsub("^(%S+)%s+(%d+/%d+) %- nvim", " %2 %1")
	elseif exec_name == "fzf" or exec_name == "hs" or exec_name == "peco" then
		title_with_icon = FUZZY_ICON .. " " .. exec_name:upper()
	elseif exec_name == "node" then
		title_with_icon = NODE_ICON .. " " .. exec_name:upper()
	elseif exec_name == "deno" then
		title_with_icon = DENO_ICON .. " " .. exec_name:upper()
	elseif exec_name == "bb" or exec_name == "cmd-clj" or exec_name == "janet" or exec_name == "hy" then
		title_with_icon = LAMBDA_ICON .. " " .. exec_name:gsub("bb", "Babashka"):gsub("cmd%-clj", "Clojure")
	else
		title_with_icon = HOURGLASS_ICON .. " " .. exec_name
	end

	if pane_title:match("^Administrator: ") then
		title_with_icon = title_with_icon .. " " .. ADMIN_ICON
	end

	local left_arrow = tab.tab_index == 0 and SOLID_LEFT_MOST or SOLID_LEFT_ARROW
	local title = " " .. wezterm.truncate_right(title_with_icon, max_width - 4) .. " "

	return {
		{ Attribute = { Intensity = "Bold" } },
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = left_arrow },
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = title },
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_RIGHT_ARROW },
		{ Attribute = { Intensity = "Normal" } },
	}
end

return M
