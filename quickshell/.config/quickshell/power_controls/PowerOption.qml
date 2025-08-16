import QtQuick

Rectangle {
    id: root
    color: "transparent"
    property string text
    property string textColor: "white"
    property string textColorHovered: "white"
    property bool hovered: false
    signal powerOptionClicked
    width: parent.width
    height: 20
    Text {
        font.family: "JetBrainsMono Nerd Font" // Change if you use a different Nerd Font
        font.pixelSize: 20
        anchors.verticalCenter: parent.verticalCenter
        text: root.text
        color: root.hovered ? root.textColorHovered : root.textColor
    }
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true
        onEntered: {
            root.hovered = true;
        }
        onExited: {
            root.hovered = false;
        }
        onClicked: root.powerOptionClicked()
    }
}
