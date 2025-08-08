import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets

MouseArea {
    id: root

    required property SystemTrayItem item
    property bool targetMenuOpen: false
    property int trayItemWidth: 19

    acceptedButtons: Qt.LeftButton | Qt.RightButton
    Layout.fillHeight: true
    implicitWidth: trayItemWidth
    onClicked: event => {
        switch (event.button) {
        case Qt.LeftButton:
            item.activate();
            break;
        case Qt.RightButton:
            if (item.hasMenu)
                menu.open();
            break;
        }
        event.accepted = true;
    }

    QsMenuAnchor {
        id: menu

        menu: root.item.menu
        anchor.item: root
        anchor.rect.y: root.height
        anchor.rect.x: (root.width - width) / 2
    }

    IconImage {
        id: trayIcon
        // TODO: figure out how to set icon theme
        source: root.item.icon
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
    }
}
