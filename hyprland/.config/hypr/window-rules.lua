hl.window_rule({
	name = "bitwarden-extension-popup",
	match = { title = ".*Bitwarden.*" },
	float = true,
	center = true,
	stay_focused = true,
})

hl.window_rule({
	name = "custom-popup-yad",
	match = { class = "^(yad)$" },
	float = true,
	center = true,
	stay_focused = true,
})

hl.window_rule({
	name = "blueman-manager-popup",
	match = { class = "^(blueman-manager)$" },
	float = true,
	center = true,
})

hl.window_rule({
	name = "network-manager-connection-editor",
	match = { class = "^(nm-connection-editor)$" },
	float = true,
	stay_focused = true,
	move = "cursor -50% -50%",
})

hl.window_rule({
	name = "clipse-clipboard-manager",
	match = { class = "^(clipse-gui)$" },
	float = true,
	stay_focused = true,
	size = "622 652",
	center = true,
})

hl.window_rule({
	name = "pavucontrol",
	match = { class = "^(pavucontrol)$" },
	float = true,
	stay_focused = true,
	size = "422 652",
})

hl.window_rule({
	name = "lxqt-policykit-agent",
	match = { class = "^(lxqt-policykit-agent)$" },
	float = true,
	center = true,
	size = "600 0",
	stay_focused = true,
})

hl.window_rule({
	name = "thunar-rename",
	match = { class = "^(thunar)$", title = "^(Rename .*)$" },
	float = true,
	center = true,
	stay_focused = true,
})

hl.window_rule({
	name = "open-tablet-driver-ux",
	match = { class = "^(OpenTabletDriver.UX)$" },
	float = true,
	center = true,
})

hl.layer_rule({
	name = "swaync-control-center",
	match = { namespace = "^(swaync-control-center)$" },
	blur = true,
	ignore_alpha = 0.5,
})

hl.layer_rule({
	name = "swaync-notification-window",
	match = { namespace = "^(swaync-notification-window)$" },
	blur = true,
	ignore_alpha = 0.5,
})

hl.window_rule({
	name = "zed-settings",
	match = { class = "^(dev.zed.Zed)$", title = "^(Zed — Settings)$" },
	float = true,
	center = true,
	stay_focused = true,
	size = "1600 1000",
})

hl.window_rule({
	name = "suppress-maximize-events",
	match = { class = ".*" },
	suppress_event = "maximize",
})

hl.window_rule({
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})
