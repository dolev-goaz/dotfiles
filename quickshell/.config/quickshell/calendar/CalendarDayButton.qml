import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../common/widgets"

Button {
    id: root
    property string day
    property int isToday
    property bool bold

    property color otherMonthBackgroundColor: "#24273a"
    property color todayBackgroundColor: "#8aadf4"
    property color baseBackgroundColor: "#494d64"

    Layout.fillWidth: false
    Layout.fillHeight: false
    implicitWidth: 38
    implicitHeight: 38
    background: Rectangle {
        property color currentColor: (root.isToday === 1)
                                        ? root.todayBackgroundColor
                                        : (root.isToday === 0)
                                            ? root.baseBackgroundColor
                                            : root.otherMonthBackgroundColor
        color: root.pressed
            ? Qt.darker(currentColor, 1.3)
            : root.hovered
                ? Qt.darker(currentColor, 1.15)
                : currentColor
        radius: 8
    }

    contentItem: StyledText {
        anchors.fill: parent
        text: root.day
        horizontalAlignment: Text.AlignHCenter
        font.weight: root.bold ? Font.DemiBold : Font.Normal
        color: (root.isToday === 1) ? "8087a2" : (root.isToday === 0) ? "#cad3f5" : "#cad3f5" 

        Behavior on color {
            ColorAnimation {
                duration: 200
                easing.type: Easing.BezierSpline
                easing.bezierCurve: [0.34, 0.80, 0.34, 1.00, 1, 1]
            }
        }
    }
}
