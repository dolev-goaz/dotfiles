pragma ComponentBehavior: Bound

import QtQuick
import Quickshell

Rectangle {
    id: root
    required property string text
    property color textColor: "white"
    property int textPixelSize: 16
    property string fontFamily: "JetBrainsMono Nerd Font"
    property color backgroundColor: "#494d64"
    property color borderColor: "#b7bdf8"
    property int borderWidth: 2
    property int borderRadius: 17
    property bool showTooltip: false

    property string tooltipText: ""
    property int tooltipDelay: 500
    property color tooltipBackgroundColor: "#2e3440"
    property color tooltipTextColor: "#eceff4"
    property color tooltipBorderColor: "#5e81ac"

    signal clicked(var mouse)

    color: backgroundColor
    border.width: borderWidth
    border.color: borderColor
    radius: borderRadius

    Text {
        anchors.centerIn: parent
        text: root.text
        font.family: root.fontFamily
        color: root.textColor
        font.pixelSize: root.textPixelSize
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.AllButtons
        hoverEnabled: root.tooltipText !== ""
        onClicked: function(mouse) {
            root.clicked(mouse)
        }
        onEntered: function() {
            tooltipTimer.start()
        }
        onExited: function() {
            tooltipTimer.stop()
            root.showTooltip = false
        }
    }
    Timer {
        id: tooltipTimer
        interval: root.tooltipDelay
        repeat: false
        onTriggered: {
            root.showTooltip = true
        }
    }
    LazyLoader {
        active: root.showTooltip

        component: PopupWindow {
            id: tooltip
            visible: true
            anchor.item: root
            implicitHeight: tooltipContent.implicitHeight
            implicitWidth: tooltipContent.implicitWidth
            anchor.rect.y: root.height + 10 // 10 is the gap
            anchor.rect.x: (root.width - width) / 2
            color: "transparent"
            Rectangle {
                id: tooltipContent
                color: root.tooltipBackgroundColor
                implicitWidth: tooltipText.width + 20 // +20 padding
                implicitHeight: tooltipText.height + 10 // +10 padding
                radius: 6
                border.color: root.tooltipBorderColor
                Text {
                    id: tooltipText
                    text: root.tooltipText
                    anchors.centerIn: parent
                    color: root.tooltipTextColor
                }
            }
        }
    }
}
