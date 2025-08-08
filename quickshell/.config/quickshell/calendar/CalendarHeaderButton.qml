import QtQuick
import QtQuick.Controls
import "../common/widgets"

Button {
    id: root
    property string buttonText: ""
    property string tooltipText: ""
    property bool forceCircle: false

    implicitHeight: 30
    implicitWidth: forceCircle ? implicitHeight : (contentItem.implicitWidth + 10 * 2)
    Behavior on implicitWidth {
        SmoothedAnimation {
            velocity: 650
        }
    }

    background.anchors.fill: root

    contentItem: StyledText {
        text: root.buttonText
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 19
        color: "#CFC3CD"
    }

    // StyledToolTip {
    //     content: tooltipText
    //     extraVisibleCondition: tooltipText.length > 0
    // }
}
