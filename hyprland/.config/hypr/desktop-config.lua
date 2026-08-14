for i = 1, 10 do
	-- even: DP-2, odd: DP-3
	local monitor = (i % 2 == 0) and "DP-2" or "DP-3"
	hl.workspace_rule({
		workspace = tostring(i),
		monitor = monitor,
	})
end

hl.on("hyprland.start", function()
	hl.exec_cmd("~/.local/bin/run-if-exists.sh otd-daemon")
	hl.exec_cmd("~/.local/bin/run-if-exists.sh udiskie")
end)
hl.monitor({ output = "DP-2", mode = "1920x1080@165", position = "1920x0", scale = 1 })
hl.monitor({ output = "DP-3", mode = "1920x1080@165", position = "0x0", scale = 1 })
hl.monitor({ output = "Virtual-1", mode = "2560x1600@120", position = "1300x1080", scale = 2.13 })

hl.device({ name = "wacom-intuos-s-pen", output = "DP-2" })
hl.device({ name = "weylus-touch", output = "Virtual-1" })
hl.device({ name = "weylus-stylus", output = "Virtual-1" })
