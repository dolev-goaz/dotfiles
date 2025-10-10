pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Io // for process
import Quickshell

Item {
    id: root
    property int textPixelSize: 16
    property color backgroundColor: "#494d64"
    property color borderColor: "#b7bdf8"
    property int borderWidth: 3
    property int borderRadius: 17
    property var updateService
    property var updateCounts: updateService ? updateService.updateCounts : null
    property int totalUpdates: updateService ? updateService.totalUpdates : 0
    property color textColor: totalUpdates < 20
                                ? "#a6e3a1" // ok - green
                                : totalUpdates < 50
                                    ? "#f9e2af" // warning - yellow
                                    : "#f38ba8"; // critical - red

    visible: root.updateCounts !== null
    implicitWidth: backgroundRect.implicitWidth
    Rectangle {
        id: backgroundRect
        color: root.backgroundColor
        border.width: root.borderWidth
        border.color: root.borderColor
        radius: root.borderRadius
        anchors.fill: parent
        implicitWidth: contentRow.width + 24

        Row {
            id: contentRow
            anchors.centerIn: parent
            spacing: 5

            Text {
                id: updateCountText
                text: `${root.totalUpdates}`
                font.family: "JetBrainsMono Nerd Font"
                color: root.textColor
                font.pixelSize: root.textPixelSize
                y: (arrowText.height - updateCountText.height) / 2 + 1
            }
            Text {
                id: arrowText
                text: "󰁞"
                font.family: "JetBrainsMono Nerd Font"
                color: root.textColor
                font.pixelSize: root.textPixelSize * 1.2
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: function() {
                if (root.updateService) {
                    root.updateService.performUpdate();
                }
            }
            cursorShape: Qt.PointingHandCursor
        }
    }
}

