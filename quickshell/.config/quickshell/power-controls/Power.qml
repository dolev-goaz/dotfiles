pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import "../common/drawer"

Rectangle {
    id: root
    property bool expanded: false
    color: "#494d64"
    border.width: 3
    border.color: "#b7bdf8"
    radius: 17
    Text {
        text: "\uf011"
        font.family: "JetBrainsMono Nerd Font" // Change if you use a different Nerd Font
        font.pixelSize: 14
        color: root.expanded ? "white" : "#888"
        anchors.centerIn: parent
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: {
                root.expanded = true;
            }
            onExited: {
                root.expanded = false;
            }
        }
    }

    Drawer {
        expanded: root.expanded
        onDrawerExpandedChanged: function (expanded) {
            root.expanded = expanded;
        }
        menuComponent: PowerMenu {}
        anchor.item: root
        anchor.rect.y: root.height - 5 // 0 is the gap
        anchor.rect.x: (root.width - width) / 2
    }
}
