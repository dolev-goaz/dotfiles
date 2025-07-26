import Quickshell
import QtQuick
import "./workspaces"
import "./power-controls"

Scope {
    id: root

    // for all screens
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: mainWindow
            required property ShellScreen modelData
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
                    monitor: mainWindow.modelData
                }
                ClockWidget {
                    anchors.centerIn: parent
                }
                Power {
                    width: 40
                    anchors {
                        right: parent.right
                        top: parent.top
                        bottom: parent.bottom
                    }
                }
            }
        }
    }
}
