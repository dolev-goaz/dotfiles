pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray

Item {
    id: root

    height: parent.height
    implicitWidth: rowLayout.implicitWidth

    anchors.leftMargin: 10
    anchors.rightMargin: 10
    Rectangle {
        anchors.fill: parent
        color: "#494d64"
        z: -1
        border.width: 3
        border.color: "#b7bdf8"
        radius: 17
    }

    RowLayout {
        id: rowLayout

        anchors.fill: parent
        spacing: 15

        property int paddingBlock: 7
        property int paddingInline: 15
        anchors.topMargin: paddingBlock
        anchors.bottomMargin: paddingBlock

        Repeater {
            model: SystemTray.items

            SysTrayItem {
                required property SystemTrayItem modelData
                required property int index

                item: modelData
                property bool isFirst: index === 0
                property bool isLast: index === SystemTray.items.values.length - 1
                Layout.leftMargin: isFirst ? rowLayout.paddingInline : 0
                Layout.rightMargin: isLast ? rowLayout.paddingInline : 0
            }
        }
    }
}
