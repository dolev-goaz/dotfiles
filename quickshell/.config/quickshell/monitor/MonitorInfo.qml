pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import "../common"

StyledButton {
    id: root

    required property ShellScreen screen
    property bool expanded: false

    visible: Quickshell.screens.length > 1

    text: `󰍹 ${screen.name}`
    textColor: "#a6e3a1"
    textPixelSize: 13
    implicitWidth: labelMetrics.boundingRect.width + 20

    TextMetrics {
        id: labelMetrics
        font.family: root.fontFamily
        font.pixelSize: root.textPixelSize
        text: root.text
    }

    onClicked: function(mouse) {
        if (mouse.button === Qt.LeftButton) {
            expanded = !expanded
        }
    }

    Window {
        id: infoPopup
        visible: root.expanded
        flags: Qt.Popup
        color: "transparent"
        width: infoContent.implicitWidth
        height: infoContent.implicitHeight

        Component.onCompleted: reposition()
        onVisibleChanged: {
            if (visible) reposition()
            else root.expanded = false
        }
        onWidthChanged: if (visible) reposition()
        onHeightChanged: if (visible) reposition()

        function reposition() {
            const pos = root.mapToGlobal((root.width - width) / 2, root.height)
            x = pos.x
            y = pos.y + 10
        }

        Rectangle {
            id: infoContent
            color: "#494d64"
            border.width: 2
            border.color: "#b7bdf8"
            radius: 10
            implicitWidth: infoLayout.implicitWidth + 40
            implicitHeight: infoLayout.implicitHeight + 30

            Column {
                id: infoLayout
                anchors.centerIn: parent
                spacing: 8

                Text {
                    text: `󰍹  ${root.screen.name}`
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 14
                    font.bold: true
                    color: "#cdd6f4"
                }

                Text {
                    text: `Resolution: ${root.screen.width}×${root.screen.height}`
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 12
                    color: "#a6adc8"
                }

                Text {
                    text: `Position: (${root.screen.x}, ${root.screen.y})`
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 12
                    color: "#a6adc8"
                }
            }
        }
    }
}
