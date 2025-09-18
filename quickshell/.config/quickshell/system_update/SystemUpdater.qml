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
    property var updateCounts: null
    property int totalUpdates: root.updateCounts ? root.updateCounts.total : 0
    property color textColor: totalUpdates < 20
                                ? "#a6e3a1" // ok - green
                                : totalUpdates < 50
                                    ? "#f9e2af" // warning - yellow
                                    : "#f38ba8"; // critical - red

    implicitWidth: backgroundRect.implicitWidth
    Rectangle {
        id: backgroundRect
        visible: root.updateCounts !== null
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
                updateProcess.running = true;
            }
            cursorShape: Qt.PointingHandCursor
        }
    }
    Timer {
        id: updateTimer
        interval: 5 * 60 * 1000 // 5 minutes
        running: true
        repeat: true
        onTriggered: updateCountProcess.running = true
    }
    Process {
        id: updateCountProcess
        running: true
        command: ["/bin/sh", "-c", "~/scripts/available-updates-arch.sh"]
        stdout: StdioCollector {
            onStreamFinished: {
                const updateCounts = JSON.parse(this.text);
                root.updateCounts = updateCounts.total > 0 ? updateCounts : null;
            }
        }
    }
    Process {
        id: updateProcess
        running: false
        command: ["/bin/sh", "-c", "~/.local/bin/quickshell-update-system.sh"]
    }
}

