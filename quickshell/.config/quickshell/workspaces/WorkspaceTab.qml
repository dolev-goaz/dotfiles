import QtQuick

Rectangle {
    id: root
    property var active: false
    property var text
    signal workspaceClick
    width: 32
    height: 24
    radius: 15
    color: root.active ? "#4caf50" : "#333333"
    border.color: "#555555"
    border.width: 2
    MouseArea {
        anchors.fill: parent
        onClicked: root.workspaceClick()
        cursorShape: Qt.PointingHandCursor
    }
    Text {
        text: root.text
        anchors.centerIn: parent
        color: root.active ? "#ffffff" : "#cccccc"
        font.pixelSize: 12
        font.family: "Inter, sans-serif"
    }
}
