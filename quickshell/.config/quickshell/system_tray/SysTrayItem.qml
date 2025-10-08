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
                // menu.open();
                expanded = !expanded;
            }
            break;
        }
        event.accepted = true;
    }

    // QsMenuAnchor {
    //     id: menu
    //
    //     menu: root.item.menu
    //     anchor.item: root
    //     anchor.rect.y: root.height
    //     anchor.rect.x: (root.width - width) / 2
    // }
    QsMenuOpener {
        id: menuOpener
        menu: root.item.menu
    }
    LazyLoader {
        active: root.expanded

        component: PopupWindow {
            id: popupWindow
            visible: true
            anchor.item: root
            anchor.rect.y: root.height + 10 // 10 is the gap
            anchor.rect.x: (root.width - width) / 2
            color: "transparent"
            implicitWidth: trayMenu.width
            implicitHeight: trayMenu.height

            SysTrayMenu {
                id: trayMenu
                options: menuOpener.children.values
                onMenuOptionSelected: {
                    root.expanded = false;
                }
            }
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
