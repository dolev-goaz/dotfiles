local machine = require("machine")
hl.on("hyprland.start", function()
	-- activate graphical-session.target so xdg-desktop-portal and screen sharing work
	-- (required since xdg-desktop-portal 1.22)
	hl.exec_cmd("systemctl --user start hyprland-session.target")

	hl.exec_cmd("nm-applet")
	hl.exec_cmd("swaync")
	hl.exec_cmd("awww-daemon")
	hl.exec_cmd("quickshell")

	if machine.is_desktop then
		-- tablet support
		hl.exec_cmd("~/.local/bin/run-if-exists.sh otd-daemon")
	end

	if machine.is_laptop then
		hl.exec_cmd("~/.local/bin/run-if-exists.sh hypridle")
	end

	-- auto mounting and file management
	hl.exec_cmd("lxqt-policykit-agent")
	hl.exec_cmd("udiskie --tray")
	hl.exec_cmd("thunar --daemon")

	-- clipboard manager
	hl.exec_cmd("clipse -listen")

	-- keyring
	hl.exec_cmd("/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh,gpg")
end)
