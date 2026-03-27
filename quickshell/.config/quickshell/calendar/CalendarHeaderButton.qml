import QtQuick
import QtQuick.Controls
import "../common/widgets"

Button {
    id: root
    property string buttonText: ""
    property bool forceCircle: false
    property bool dimmed: false

    implicitHeight: 32
    implicitWidth: forceCircle ? implicitHeight : (contentItem.implicitWidth + 8 * 2)
    Behavior on implicitWidth {
        SmoothedAnimation {
            velocity: 650
        }
    }

    background: Item {
        Rectangle {
            visible: root.forceCircle
            anchors.centerIn: parent
            width: parent.height
            height: parent.height
            radius: height / 2
            color: "#313244"
            opacity: root.hovered ? (root.pressed ? 1.0 : 0.7) : 0.0
            Behavior on opacity {
                NumberAnimation { duration: 100 }
            }
        }

        Rectangle {
            visible: !root.forceCircle
            anchors.fill: parent
            radius: 6
            color: "#313244"
            opacity: root.hovered ? (root.pressed ? 0.8 : 0.5) : 0.0
            Behavior on opacity {
                NumberAnimation { duration: 100 }
            }
        }
    }

    contentItem: StyledText {
        text: root.buttonText
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 15
        font.family: "JetBrainsMono Nerd Font"
        color: root.dimmed ? "#585b70" : "#cdd6f4"
        font.weight: Font.Medium

        Behavior on color {
            ColorAnimation { duration: 200 }
        }
    }
}
