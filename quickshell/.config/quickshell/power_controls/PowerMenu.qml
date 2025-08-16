import QtQuick
import Quickshell.Io // for process

Column {
    id: contentColumn
    anchors.fill: parent
    anchors.margins: 12
    spacing: 16
    Process {
        id: shutdownProcess
        command: ["/bin/sh", "-c", "~/.local/bin/waybar-verify-action.sh 'Shutdown' && shutdown now"]
    }
    PowerOption {
        text: "󰐥"
        textColorHovered: "#ff5555"
        onPowerOptionClicked: {
            shutdownProcess.running = true;
        }
    }
    Process {
        id: rebootProcess
        command: ["/bin/sh", "-c", "~/.local/bin/waybar-verify-action.sh 'Reboot' && reboot"]
    }
    PowerOption {
        text: "󰜉"
        textColorHovered: "#ffb86c"
        onPowerOptionClicked: {
            rebootProcess.running = true;
        }
    }
    Process {
        id: lockProcess
        command: ["hyprlock"]
    }
    PowerOption {
        text: "󰍁"
        textColorHovered: "#8be9fd"
        onPowerOptionClicked: {
            lockProcess.running = true;
        }
    }
    // Process {
    //     id: sleepProcess
    //     command: ["systemctl", "suspend"]
    // }
    // PowerOption {
    //     text: "󰤄"
    //     textColorHovered: "#50fa7b"
    //     onPowerOptionClicked: {
    //         sleepProcess.running = true;
    //     }
    // }
    Process {
        id: exitProcess
        command: ["/bin/sh", "-c", "~/.local/bin/waybar-verify-action.sh 'Exit Hyprland' && hyprctl dispatch exit"]
    }
    PowerOption {
        text: "󰗼"
        textColorHovered: "#bd93f9"
        onPowerOptionClicked: {
            exitProcess.running = true;
        }
    }
}
