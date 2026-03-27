import QtQuick
import QtQuick.Controls
import "../common/widgets"

Button {
    id: root
    property string buttonText: ""
    property bool forceCircle: false

    implicitHeight: 32
    implicitWidth: forceCircle ? implicitHeight : (contentItem.implicitWidth + 12 * 2)
    Behavior on implicitWidth {
        SmoothedAnimation {
            velocity: 650
        }
    }

    background: Rectangle {
        anchors.fill: parent
        property color currentColor: "#313244"
        color: root.pressed
            ? Qt.lighter(currentColor, 1.4)
            : root.hovered
                ? Qt.lighter(currentColor, 1.2)
                : currentColor
        radius: root.forceCircle ? parent.height / 2 : 8

        Behavior on color {
            ColorAnimation { duration: 120 }
        }
    }

    contentItem: StyledText {
        text: root.buttonText
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 19
        font.family: "JetBrainsMono Nerd Font"
        color: "#cdd6f4"
        font.weight: Font.Medium
    }
}
