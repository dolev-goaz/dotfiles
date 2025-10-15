pragma ComponentBehavior: Bound

import "../common"
import QtQuick
import Quickshell
import Quickshell.Io
import ".."

Item {
    id: root
    property int messageCount: Services.notifications.messageCount
    property bool isDND: Services.notifications.isDND
    property bool isOpen: Services.notifications.isOpen
    property bool isInhibited: Services.notifications.isInhibited

    StyledButton {
        id: swayncButton
        text: "󰣇"
        textColor: root.isDND? "#f04747": "white"
        implicitWidth: root.implicitWidth
        implicitHeight: 30
        onClicked: (mouse) => {
            if (mouse.button == Qt.RightButton) {
                Services.notifications.toggleDND()
            } else {
                Services.notifications.togglePanel()
            }
        }
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
}
