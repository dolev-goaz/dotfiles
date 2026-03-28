import QtQuick
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell // for ShellScreen type

Row {
    id: workspacesRow
    required property ShellScreen monitor
    spacing: 8
    Process {
        id: processOpenChats
        command: ["/bin/sh", "-c", "~/.local/bin/toggle-chats.sh"] // -c to allow expanding the ~
    }
    WorkspaceTab {
        text: "󰭻"
        textSize: 16
        active: false
        onWorkspaceClick: {
            processOpenChats.running = true;
        }
    }
    // repeated for 'normal' workspaces
    Repeater {
        model: Hyprland.workspaces.values.filter(ws => ws.monitor?.name === workspacesRow.monitor.name && ws.id >= 0)
        WorkspaceTab {
            required property HyprlandWorkspace modelData
            text: modelData.id
            active: modelData.focused
            urgent: modelData.urgent
            onWorkspaceClick: modelData.activate()
        }
    }
}
