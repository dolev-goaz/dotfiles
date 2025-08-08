pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray

Item {
    id: root

    height: parent.height
    implicitWidth: rowLayout.implicitWidth

    RowLayout {
        id: rowLayout

        anchors.fill: parent
        spacing: 15

        Repeater {
            model: SystemTray.items

            SysTrayItem {
                required property SystemTrayItem modelData

                item: modelData
            }
        }
    }
}
