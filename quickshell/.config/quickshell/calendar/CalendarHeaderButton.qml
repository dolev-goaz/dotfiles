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
        color: "#f5a97f"
        radius: 8
    }


    contentItem: StyledText {
        text: root.buttonText
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 19
        color: "#363a4f"
        font.weight: Font.DemiBold
    }
}
