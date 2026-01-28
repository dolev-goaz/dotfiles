pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import "../common/drawer"
import "../common"

StyledButton {
    id: root
    property bool expanded: false
    
    text: "\uf011"
    textPixelSize: 14
    textColor: root.expanded ? "white" : "#888"
    
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
