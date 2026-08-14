local M = {}

-- TODO: special workspace API changed

M.mainMod = "SUPER"

M.terminal = "wezterm"
M.menu = "~/.local/bin/rofi-toggle.sh"
M.fileManager = "thunar"
M.browser = "zen-browser"
M.taskManager = "~/.local/bin/toggle-btop.sh"

-- Basic binds
hl.bind(M.mainMod .. " + Return", hl.dsp.exec_cmd(M.terminal))
hl.bind(M.mainMod .. " + SHIFT + C", hl.dsp.window.close())
hl.bind(M.mainMod .. " + M", hl.dsp.exec_cmd(M.browser))
hl.bind(M.mainMod .. " + E", hl.dsp.exec_cmd(M.fileManager))
hl.bind(M.mainMod .. " + Space", hl.dsp.exec_cmd(M.menu))
hl.bind(M.mainMod .. " + P", hl.dsp.window.pseudo())
-- hl.bind(M.mainMod .. " + J", hl.dsp.layout("togglesplit"))

-- Move focus
hl.bind(M.mainMod .. " + h", hl.dsp.focus({ direction = "l" }))
hl.bind(M.mainMod .. " + j", hl.dsp.focus({ direction = "d" }))
hl.bind(M.mainMod .. " + k", hl.dsp.focus({ direction = "u" }))
hl.bind(M.mainMod .. " + l", hl.dsp.focus({ direction = "r" }))
hl.bind("CTRL + SHIFT + Escape", hl.dsp.exec_cmd(M.taskManager))

-- Screenshots
hl.bind("PRINT", hl.dsp.exec_cmd("hyprshot -m region --clipboard-only --freeze"))
hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd("hyprshot -m window --clipboard-only"))
hl.bind(M.mainMod .. " + PRINT", hl.dsp.exec_cmd("hyprshot -m output --clipboard-only"))

-- Emoji picker
hl.bind(M.mainMod .. " + COMMA", hl.dsp.exec_cmd("rofi -modi emoji -show emoji"))

-- Workspaces
for i = 1, 9 do
	hl.bind(M.mainMod .. " + " .. i, hl.dsp.focus({ workspace = tostring(i) }))
	hl.bind(M.mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = tostring(i) }))
end
hl.bind(M.mainMod .. " + 0", hl.dsp.focus({ workspace = "10" }))
hl.bind(M.mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = "10" }))

-- Move active window to next/previous monitor
hl.bind(M.mainMod .. " + SHIFT + h", hl.dsp.window.move({ monitor = "mon:-1" }))
hl.bind(M.mainMod .. " + SHIFT + l", hl.dsp.window.move({ monitor = "mon:+1" }))

-- Clipboard manager
hl.bind(M.mainMod .. " + V", hl.dsp.exec_cmd("clipse-gui"))

-- Scripts & toggles
hl.bind(M.mainMod .. " + S", hl.dsp.exec_cmd("~/.local/bin/toggle-chats.sh"))
-- hl.bind(M.mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:chats" }))

-- Scroll workspaces
hl.bind(M.mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+2" }))
hl.bind(M.mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-2" }))

-- Mouse binds (replace bindm)
hl.bind(M.mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(M.mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Media & System keys (replace bindel/bindl)
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ repeating = true, locked = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ repeating = true, locked = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ repeating = true, locked = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ repeating = true, locked = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { repeating = true, locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { repeating = true, locked = true })

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- convert to lua

-- hyprctl dispatch togglespecialworkspace chats
--
-- if ! pgrep -f ferdium >/dev/null; then
-- 	hyprctl dispatch exec "[workspace special:chats] ferdium"
-- 	sleep 0.5 # Give it a moment to start before toggling
-- fi

-- local function toggle_chats()
-- 	hl.dispatch(hl.dsp.workspace.toggle_special("chats"))
-- 	if not os.execute("pgrep -f ferdium > /dev/null") then
-- 		hl.dispatch(hl.dsp.exec_cmd("ferdium", { workspace = "special:chats" }))
-- 	end
-- end
--
-- hl.bind(M.mainMod .. " + S", toggle_chats)

return M
