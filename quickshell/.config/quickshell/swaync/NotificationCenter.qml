pragma ComponentBehavior: Bound

import "../common/process"
import QtQuick
import Quickshell.Io

Item {
    id: root
    property int messageCount: 0
    property bool isDND: false
    property bool isOpen: false
    property bool isInhibited: false

    ProcessButton {
        id: swayncButton
        command: ["swaync-client", "-t"]
        text: "󰣇"
        textColor: root.isDND? "#f04747": "white"
        implicitWidth: root.implicitWidth
        implicitHeight: 30
        Rectangle {
            visible: root.messageCount > 0
            color: "red"
            radius: 8
            anchors {
                top: parent.top
                right: parent.right
                rightMargin: 8
                topMargin: 5
            }
            width: messageCountText.paintedWidth + 5
            height: 10
            z: 1

            Text {
                id: messageCountText
                text: root.messageCount
                font.pixelSize: 10
                color: "white"
                anchors.centerIn: parent
            }
        }
    }
    Process {
        id: swayncProcess
        running: true
        command: ["swaync-client", "-s"]
        stdout: StdioCollector {
            waitForEnd: false
            onTextChanged: {
                const updatesStr = this.text.split("\n").filter(Boolean)
                const lastUpdateStr = updatesStr[updatesStr.length - 1]
                const latestUpdate = JSON.parse(lastUpdateStr)

                root.messageCount = latestUpdate.count
                root.isDND = latestUpdate.dnd
                root.isOpen = latestUpdate.visible
                root.isInhibited = latestUpdate.inhibited
            }
        }
    }
}
