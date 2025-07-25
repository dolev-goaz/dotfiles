import QtQuick
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell // for ShellScreen type

Row {
    id: workspacesRow
    required property ShellScreen monitor
    anchors {
        left: parent.left
        verticalCenter: parent.verticalCenter
        leftMargin: 16
    }
    spacing: 8
    Process {
        id: processOpenChats
        command: ["/bin/sh", "-c", "~/.local/bin/toggle-chats.sh"] // -c to allow expanding the ~
    }
    Repeater {
        model: Hyprland.workspaces
        WorkspaceTab {
            required property HyprlandWorkspace modelData

            visible: modelData.name == "special:chats"
            text: "💬"
            active: false
            onWorkspaceClick: {
                processOpenChats.running = true;
            }
        }
    }
    // repeated for 'normal' workspaces
    Repeater {
        model: Hyprland.workspaces
        WorkspaceTab {
            required property HyprlandWorkspace modelData

            visible: modelData.id >= 0 && modelData.monitor.name === workspacesRow.monitor.name
            text: modelData.id
            active: modelData.focused
            onWorkspaceClick: modelData.activate()
        }
    }
}
