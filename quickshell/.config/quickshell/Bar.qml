import Quickshell
import QtQuick
import "./workspaces"
import "./power_controls"
import "./system_tray"
import "./clock"
import "./clipboard"
import "./wallpapers"
import QtQuick.Layouts

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
                right: 20
                top: 10
            }
            Rectangle {
                id: bar
                anchors.fill: parent
                color: "transparent"
                radius: 15
                Workspaces {
                    monitor: mainWindow.modelData
                }
                ClockWidget {
                    anchors.centerIn: parent
                }
                RowLayout {
                    layoutDirection: Qt.RightToLeft
                    spacing: 20

                    anchors {
                        right: parent.right
                        top: parent.top
                        bottom: parent.bottom
                    }
                    Power {
                        Layout.fillHeight: true
                        implicitWidth: 40
                    }
                    SysTray {
                        Layout.fillHeight: true
                    }
                    ClipboardHistory {
                        Layout.fillHeight: true
                        implicitWidth: 40
                    }
                    WallpaperPickerActivator {
                        Layout.fillHeight: true
                        implicitWidth: 40
                    }
                }
            }
        }
    }
}
