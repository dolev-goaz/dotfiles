pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import "../common"
import ".."

StyledButton {
    id: root
    property int volume: Services.audio.volume
    property bool muted: Services.audio.muted
    property string currentSink: Services.audio.currentSink
    property bool expanded: false

    property string icon: {
        if (muted) {
            return "󰖁"
        } else if (volume === 0) {
            return "󰕿"
        } else if (volume < 33) {
            return "󰖀"
        } else if (volume < 66) {
            return "󰕾"
        } else {
            return "󰕾"
        }
    }

    property string fgColor: {
        if (muted) {
            return "#6c7086"
        }
        return "#89b4fa"
    }

    text: `${icon} ${volume}%`
    textColor: fgColor
    tooltipText: currentSink
    
    onClicked: function(mouse) {
        if (mouse.button === Qt.LeftButton) {
            expanded = !expanded
        } else if (mouse.button === Qt.MiddleButton) {
            // Toggle mute with middle click
            Quickshell.execDetached({
                command: ["/bin/sh", "-c", "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"]
            })
        }
    }

    Window {
        id: deviceSelectorWindow
        visible: root.expanded
        flags: Qt.Popup
        color: "transparent"
        width: deviceSelector.implicitWidth
        height: deviceSelector.implicitHeight

        Component.onCompleted: reposition()
        onVisibleChanged: {
            if (visible) {
                reposition()
                deviceSelector.refresh()
            }
            else root.expanded = false
        }
        onWidthChanged: if (visible) reposition()
        onHeightChanged: if (visible) reposition()

        function reposition() {
            const pos = root.mapToGlobal((root.width - width) / 2, root.height)
            x = pos.x
            y = pos.y + 10
        }

        AudioDeviceSelector {
            id: deviceSelector
            onDeviceSelected: root.expanded = false
        }
    }
}
