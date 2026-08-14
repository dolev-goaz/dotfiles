if hl.plugin.overview ~= nil then
	-- Workspace view- https://github.com/KZDKM/Hyprspace
	-- hl.on("hyprland.start", function()
	--     hl.exec_cmd("hyprctl plugin load ~/.config/hypr/plugins/Hyprspace/Hyprspace.so")
	-- end)
	local binds = require("binds")
	hl.bind(binds.mainMod .. " + SHIFT + e", hl.dsp.exec_cmd("hyprctl dispatch overview:toggle all"))

	hl.config({
		plugin = {
			overview = {
				enabled = true,
				autoDrag = true,
				centerAligned = true,
				onBottom = true,
				drawActiveWorkspace = true,
				exitOnClick = true,
				switchOnDrop = false,
				-- adaptiveHeight = true,
				-- exitOnSwitch = true,
				dragAlpha = 0.8,
				disableGestures = 1,

				workspaceMargin = 40,
				panelHeight = 250,
				workspaceActiveBorder = "rgb(5c64f1)",
				panelBorderWidth = 2,
				panelBorderColor = "rgb(5c64f1)",

				showNewWorkspace = false,
				showEmptyWorkspace = true,
				affectStrut = false,
				disableBlur = false,
			},
		},
	})
end
