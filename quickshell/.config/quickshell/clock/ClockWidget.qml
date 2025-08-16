pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import "../calendar"

Rectangle {
    id: root
    property bool expanded: false
    color: "#494d64"
    border.width: 3
    border.color: "#b7bdf8"
    radius: 17

    Text {
        id: clockText
        anchors.centerIn: parent
        property string format: root.expanded ? "dd-MM-yyyy HH:mm:ss" : "d - ddd - hh:mm"
        text: Qt.formatDateTime(Time.time, format)
        font.family: "JetBrainsMono Nerd Font"
        color: "#f0c6c6"
        font.pixelSize: 16
    }

    width: clockText.paintedWidth + 20
    height: parent.height

    MouseArea {
        anchors.fill: parent
        onClicked: root.expanded = !root.expanded
        cursorShape: Qt.PointingHandCursor
    }

    LazyLoader {
        active: root.expanded

        component: PopupWindow {
            id: popupWindow
            visible: true
            anchor.item: root
            anchor.rect.y: root.height + 10 // 10 is the gap
            anchor.rect.x: (root.width - width) / 2
            implicitWidth: calendarWidget.width + 20 // +20 padding
            implicitHeight: calendarWidget.height + 20 // +20 padding
            color: "transparent"
            CalendarWidget {
                id: calendarWidget
                anchors.fill: parent
            }
        }
    }
}
