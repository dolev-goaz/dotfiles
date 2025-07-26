pragma ComponentBehavior: Bound
import Quickshell
import QtQuick

Rectangle {
    id: root
    property bool expanded: false
    color: "transparent"
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

    PopupWindow {
        id: popupWindow
        visible: root.expanded || popupContent.opacity > 0
        anchor.item: root
        anchor.rect.y: root.height - 5 // 0 is the gap
        anchor.rect.x: (root.width - width) / 2
        implicitHeight: popupContent.implicitHeight
        implicitWidth: popupContent.width
        color: "transparent"
        Rectangle {
            id: popupContent
            width: 36
            color: "#222"
            radius: 8
            implicitHeight: contentColumn.implicitHeight + 24

            // Animate position and opacity for drawer effect
            property real closedY: -height  // hidden above
            property real openY: 0           // fully visible
            property real animationDuration: 150

            y: root.expanded ? openY : closedY
            opacity: root.expanded ? 1 : 0

            Behavior on y {
                NumberAnimation {
                    duration: popupContent.animationDuration
                    easing.type: Easing.OutQuad
                }
            }
            Behavior on opacity {
                NumberAnimation {
                    duration: popupContent.animationDuration
                }
            }

            PowerMenu {
                id: contentColumn
            }
            HoverHandler {
                onHoveredChanged: {
                    root.expanded = hovered;
                }
            }
        }
    }
}
