import Quickshell
import QtQuick

Scope {
    id: root

    // for all screens
    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData
            color: "transparent"
            implicitHeight: 30

            anchors {
                top: true
                left: true
                right: true
            }
            margins {
                left: 10
                right: 10
                top: 10
            }
            Rectangle {
                id: bar
                anchors.fill: parent
                color: "#1a1a1a"
                radius: 15
                border.color: "#555555"
                border.width: 2
                // add padding
                Workspaces {
                    monitor: modelData.name
                }
                ClockWidget {
                    anchors.centerIn: parent
                }
            }
        }
    }
}
