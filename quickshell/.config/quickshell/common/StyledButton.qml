pragma ComponentBehavior: Bound

import QtQuick

Rectangle {
    id: root
    required property string text
    property color textColor: "white"
    property int textPixelSize: 16
    property color backgroundColor: "#494d64"
    property color borderColor: "#b7bdf8"
    property int borderWidth: 3
    property int borderRadius: 17

    signal clicked(var mouse)

    color: backgroundColor
    border.width: borderWidth
    border.color: borderColor
    radius: borderRadius

    Text {
        anchors.centerIn: parent
        text: root.text
        font.family: "JetBrainsMono Nerd Font"
        color: root.textColor
        font.pixelSize: root.textPixelSize
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.AllButtons
        onClicked: function(mouse) {
            root.clicked(mouse)
        }
        cursorShape: Qt.PointingHandCursor
    }
}