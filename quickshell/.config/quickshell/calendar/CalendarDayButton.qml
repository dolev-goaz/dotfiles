import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../common/widgets"

Button {
    id: root
    property string day
    property int isToday
    property bool bold

    Layout.fillWidth: false
    Layout.fillHeight: false
    implicitWidth: 38
    implicitHeight: 38

    contentItem: StyledText {
        anchors.fill: parent
        text: root.day
        horizontalAlignment: Text.AlignHCenter
        font.weight: root.bold ? Font.DemiBold : Font.Normal
        color: (root.isToday == 1) ? "#452152" : (root.isToday == 0) ? "#CFC3CD" : "#4C444D"

        Behavior on color {
            ColorAnimation {
                duration: 200
                easing.type: Easing.BezierSpline
                easing.bezierCurve: [0.34, 0.80, 0.34, 1.00, 1, 1]
            }
        }
    }
}
