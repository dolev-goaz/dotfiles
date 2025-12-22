import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets

MouseArea {
    id: root

    required property SystemTrayItem item
    property int trayItemWidth: 19
    property bool expanded: false

    acceptedButtons: Qt.LeftButton | Qt.RightButton
    Layout.fillHeight: true
    implicitWidth: trayItemWidth
    onClicked: event => {
        switch (event.button) {
        case Qt.LeftButton:
            item.activate();
            break;
        case Qt.RightButton:
            if (item.hasMenu) {
                expanded = !expanded;
            }
            break;
        }
        event.accepted = true;
    }
    Window {
        id: menuWindow
        visible: root.expanded
        flags: Qt.Popup
        color: "transparent"
        width: trayMenu.implicitWidth
        height: trayMenu.implicitHeight

        Component.onCompleted: reposition()
        onVisibleChanged: {
            if (visible) reposition()
            else root.expanded = false
        }
        onActiveChanged: {
            if (!active) return;
            trayMenu.clear()
        }
        onWidthChanged: if (visible) reposition()
        onHeightChanged: if (visible) reposition()

        function reposition() {
            const pos = root.mapToGlobal((root.width - width) / 2, root.height)
            x = pos.x
            y = pos.y + 10
        }

        SysTrayMenu {
            id: trayMenu
            handle: root.item.menu
            // onMenuOptionSelected: root.expanded = false
        }
    }

    IconImage {
        id: trayIcon
        source: root.item.icon
        anchors.centerIn: parent
        width: 20
        height: 20
    }
}
