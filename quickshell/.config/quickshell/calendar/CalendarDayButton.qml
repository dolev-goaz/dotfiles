import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../common/widgets"

Button {
    id: root
    property string day
    property int isToday
    property bool bold
    property bool isHeader: false

    property color otherMonthBackgroundColor: "transparent"
    property color todayBackgroundColor: "#89b4fa"
    property color baseBackgroundColor: "#313244"
    property color headerBackgroundColor: "transparent"

    Layout.fillWidth: false
    Layout.fillHeight: false
    implicitWidth: 38
    implicitHeight: 38

    background: Rectangle {
        property color currentColor: root.isHeader
            ? root.headerBackgroundColor
            : (root.isToday === 1)
                ? root.todayBackgroundColor
                : (root.isToday === 0)
                    ? root.baseBackgroundColor
                    : root.otherMonthBackgroundColor
        color: root.pressed
            ? Qt.darker(currentColor, 1.4)
            : root.hovered && !root.isHeader
                ? Qt.lighter(currentColor, 1.3)
                : currentColor
        radius: 10

        Behavior on color {
            ColorAnimation { duration: 120 }
        }
    }

    contentItem: StyledText {
        anchors.fill: parent
        text: root.day
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: root.isHeader ? 12 : 14
        font.weight: root.bold ? Font.DemiBold : Font.Normal
        color: root.isHeader
            ? "#6c7086"
            : (root.isToday === 1)
                ? "#1e1e2e"
                : (root.isToday === 0)
                    ? "#cdd6f4"
                    : "#45475a"

        Behavior on color {
            ColorAnimation {
                duration: 200
                easing.type: Easing.BezierSpline
                easing.bezierCurve: [0.34, 0.80, 0.34, 1.00, 1, 1]
            }
        }
    }
}
