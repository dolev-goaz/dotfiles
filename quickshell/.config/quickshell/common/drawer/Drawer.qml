import QtQuick 2.15
import Quickshell

PopupWindow {
    id: popupWindow
    property bool expanded: false
    property Component menuComponent
    signal drawerExpandedChanged(bool expanded)

    visible: expanded || popupContent.opacity > 0
    implicitHeight: popupContent.implicitHeight
    implicitWidth: popupContent.width
    color: "transparent"
    Rectangle {
        id: popupContent
        width: 36
        color: "#222"
        radius: 8
        property real dynamicContentHeight: contentLoader.item ? contentLoader.item.implicitHeight : 0
        implicitHeight: dynamicContentHeight + 24

        // Animate position and opacity for drawer effect
        property real closedY: -height  // hidden above
        property real openY: 0           // fully visible
        property real animationDuration: 150

        y: popupWindow.expanded ? openY : closedY
        opacity: popupWindow.expanded ? 1 : 0

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

        Loader {
            id: contentLoader
            anchors.fill: parent
            sourceComponent: popupWindow.menuComponent
        }

        HoverHandler {
            onHoveredChanged: {
                popupWindow.drawerExpandedChanged(hovered);
            }
        }
    }
}
