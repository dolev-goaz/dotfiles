import QtQuick
import QtQuick.Controls
import "../common/widgets"

Button {
    id: root
    property string buttonText: ""
    property bool forceCircle: false

    implicitHeight: 30
    implicitWidth: forceCircle ? implicitHeight : (contentItem.implicitWidth + 10 * 2)
    Behavior on implicitWidth {
        SmoothedAnimation {
            velocity: 650
        }
    }

    background: Rectangle {
        anchors.fill: parent
        property color currentColor: "#f5a97f"
        color: root.pressed
            ? Qt.darker(currentColor, 1.3)
            : root.hovered
                ? Qt.darker(currentColor, 1.15)
                : currentColor
        radius: 8
    }


    contentItem: StyledText {
        text: root.buttonText
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 19
        font.family: "JetBrainsMono Nerd Font"
        color: "#363a4f"
        font.weight: Font.DemiBold
    }
}
