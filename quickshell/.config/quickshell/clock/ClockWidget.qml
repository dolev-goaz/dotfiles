pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import "../calendar"

Rectangle {
    id: root
    property bool expanded: false
    color: "transparent"

    Text {
        id: clockText
        anchors.centerIn: parent
        property string format: root.expanded ? "dddd, MMMM d yyyy hh:mm:ss AP" : "d - ddd - hh:mm"
        text: Qt.formatDateTime(Time.time, format)
        color: "#ffffff"
    }

    width: clockText.paintedWidth + 20
    height: clockText.paintedHeight + 10

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
            // Rectangle {}
            CalendarWidget {
                id: calendarWidget
                anchors.fill: parent
            }
        }
    }
}
