import QtQuick

Rectangle {
    id: root
    property bool active: false
    property string text
    property bool urgent: false
    property real flashPhase: 0
    signal workspaceClick
    width: 32
    height: 24
    radius: 15
    color: root.active ? "#8087a2" : "#494d64"
    border.color: root.urgent
        ? Qt.rgba(1, flashPhase, flashPhase, 1)
        : "#b7bdf8"
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

    property int animationDuration: 500
    SequentialAnimation on flashPhase {
        running: root.urgent
        loops: Animation.Infinite
        NumberAnimation { from: 0; to: 1; duration: animationDuration; easing.type: Easing.InOutQuad }
        NumberAnimation { from: 1; to: 0; duration: animationDuration; easing.type: Easing.InOutQuad }
        onStopped: flashPhase = 0
    }
}
