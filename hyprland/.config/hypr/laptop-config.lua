hl.monitor({ output = "DP-1", mode = "1920x1080@60", position = "0x0", scale = 1 })
hl.monitor({ output = "eDP-1", mode = "1920x1200@60", position = "1920x190", scale = 1 })

local function get_monitor_for_workspace(workspace)
	return (workspace % 2 == 0) and "DP-1" or "eDP-1"
end

for i = 1, 10 do
	hl.workspace_rule({
		workspace = tostring(i),
		monitor = get_monitor_for_workspace(i),
	})
end

hl.device({ name = "wacom-intuos-s-pen", output = "DP-1" })
