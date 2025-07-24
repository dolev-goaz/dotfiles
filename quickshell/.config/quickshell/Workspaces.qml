import QtQuick
import Quickshell.Hyprland

Row {
    id: workspacesRow
    anchors {
        left: parent.left
        verticalCenter: parent.verticalCenter
        leftMargin: 16
    }
    spacing: 8
    Repeater {
        model: Hyprland.workspaces
        Rectangle {
            visible: modelData.id >= 0 // filter special workspaces
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
