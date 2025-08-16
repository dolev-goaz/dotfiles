pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Io // for process

Rectangle {
    id: root
    color: "#494d64"
    border.width: 3
    border.color: "#b7bdf8"
    radius: 17

    Text {
        id: clockText
        anchors.centerIn: parent
        text: "󰅌"
        font.family: "JetBrainsMono Nerd Font"
        color: "white"
        font.pixelSize: 16
    }

    Process {
        id: processOpenClipboardHistory
        command: ["/bin/sh", "-c", "clipse-gui"]
    }
    MouseArea {
        anchors.fill: parent
        onClicked: function() {
            processOpenClipboardHistory.running = true;
        }
        cursorShape: Qt.PointingHandCursor
    }
}
