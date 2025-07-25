import QtQuick

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
}
