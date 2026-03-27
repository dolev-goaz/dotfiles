import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../common/widgets"

Button {
    id: root
    property string day
    property int isToday   // 1 = today, 0 = current month, -1 = adjacent month
    property bool bold
    property bool isHeader: false

    Layout.fillWidth: false
    Layout.fillHeight: false
    implicitWidth: 36
    implicitHeight: 36

    background: Item {
        Rectangle {
            anchors.centerIn: parent
            width: 32
            height: 32
            radius: 16
            color: "#313244"
            opacity: root.hovered && !root.isHeader && root.isToday !== 1 ? (root.pressed ? 1.0 : 0.7) : 0.0
            Behavior on opacity {
                NumberAnimation { duration: 100 }
            }
        }

        Rectangle {
            anchors.centerIn: parent
            width: 32
            height: 32
            radius: 16
            color: "#89b4fa"
            opacity: root.isToday === 1 ? 1.0 : 0.0
            scale: root.isToday === 1 ? 1.0 : 0.7
            Behavior on opacity {
                NumberAnimation { duration: 150 }
            }
            Behavior on scale {
                NumberAnimation { duration: 150; easing.type: Easing.OutBack }
            }
        }
    }

    contentItem: StyledText {
        anchors.fill: parent
        text: root.day
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: root.isHeader ? 11 : 14
        font.weight: root.isHeader ? Font.Medium : (root.isToday === 1 ? Font.Bold : Font.Normal)
        color: root.isHeader
            ? "#585b70"
            : (root.isToday === 1)
                ? "#1e1e2e"
                : (root.isToday === 0)
                    ? "#cdd6f4"
                    : "#3b3f5c"

        Behavior on color {
            ColorAnimation { duration: 150 }
        }
    }
}
