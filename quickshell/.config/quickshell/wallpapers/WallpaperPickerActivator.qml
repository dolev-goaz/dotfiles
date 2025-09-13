pragma ComponentBehavior: Bound
import QtQuick
import Quickshell

Rectangle {
    id: root
    property bool isPickerVisible: false

    color: "#494d64"
    border.width: 3
    border.color: "#b7bdf8"
    radius: 17

    Text {
        id: clockText
        anchors.centerIn: parent
        text: "󰸉"
        font.family: "JetBrainsMono Nerd Font"
        color: "white"
        font.pixelSize: 16
    }

    MouseArea {
        anchors.fill: parent
        onClicked: function() {
            isPickerVisible = !isPickerVisible;
        }
        cursorShape: Qt.PointingHandCursor
    }

    LazyLoader {
        active: root.isPickerVisible
        component: WallpaperPicker {}
    }

}
