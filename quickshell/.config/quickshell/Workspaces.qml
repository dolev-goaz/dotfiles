import QtQuick
import Quickshell.Hyprland
import Quickshell.Io

Row {
    id: workspacesRow
    property string monitor
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

        Rectangle {
            visible: modelData.name == "special:chats"
            width: 32
            height: 24
            radius: 15
            color: modelData.focused ? "#4caf50" : "#333333"
            border.color: "#555555"
            border.width: 2
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    processOpenChats.running = true;
                }
                cursorShape: Qt.PointingHandCursor
            }
            Text {
                text: "💬"
                anchors.centerIn: parent
                color: modelData.active ? "#ffffff" : "#cccccc"
                font.pixelSize: 12
                font.family: "Inter, sans-serif"
            }
        }
    }
    Repeater {
        model: Hyprland.workspaces
        Rectangle {
            visible: modelData.id >= 0 && modelData.monitor.name === workspacesRow.monitor // filter special workspaces
            width: 32
            height: 24
            radius: 15
            color: modelData.focused ? "#4caf50" : "#333333"
            border.color: "#555555"
            border.width: 2
            MouseArea {
                anchors.fill: parent
                onClicked: modelData.activate()
                cursorShape: Qt.PointingHandCursor
            }
            Text {
                text: modelData.id
                anchors.centerIn: parent
                color: modelData.active ? "#ffffff" : "#cccccc"
                font.pixelSize: 12
                font.family: "Inter, sans-serif"
            }
        }
    }

    Text {
        visible: Hyprland.workspaces.length === 0
        text: "No workspaces"
        color: "#ffffff"
        font.pixelSize: 12
    }
}
