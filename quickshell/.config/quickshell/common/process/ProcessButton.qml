pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Io // for process

Rectangle {
    id: root
    required property string text
    required property list<string> command
    property color textColor: "white"
    property int textPixelSize: 16
    property color backgroundColor: "#494d64"
    property color borderColor: "#b7bdf8"
    property int borderWidth: 3
    property int borderRadius: 17

    color: backgroundColor
    border.width: borderWidth
    border.color: borderColor
    radius: borderRadius

    Text {
        id: clockText
        anchors.centerIn: parent
        text: root.text
        font.family: "JetBrainsMono Nerd Font"
        color: root.textColor
        font.pixelSize: root.textPixelSize
    }

    Process {
        id: processRunner
        command: root.command
    }

    MouseArea {
        anchors.fill: parent
        onClicked: function() {
            processRunner.running = true;
        }
        cursorShape: Qt.PointingHandCursor
    }
}
