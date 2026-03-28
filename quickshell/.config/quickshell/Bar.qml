import Quickshell
import QtQuick
import "./workspaces"
import "./power_controls"
import "./system_tray"
import "./clock"
import "./clipboard"
import "./wallpapers"
import "./system_update"
import "./swaync"
import "./keyboard"
import "./system_manager"
import "./battery"
import "./audio"
import "./vpn"
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
                left: 10 + 3
                right: 10 + 3
                top: 0 + 5
                bottom: -10 + 5 // idk why we need the -10 for the offset
            }
            Rectangle {
                id: bar
                anchors.fill: parent
                color: "transparent"
                radius: 15
                RowLayout {
                    anchors {
                        left: parent.left
                        top: parent.top
                        bottom: parent.bottom
                    }
                    spacing: 30
                    
                    Workspaces {
                        monitor: mainWindow.modelData
                    }
                    VPN {
                        Layout.fillHeight: true
                        implicitWidth: 40
                    }
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
                    Battery {
                        Layout.fillHeight: true
                        implicitWidth: 80
                    }
                    Audio {
                        Layout.fillHeight: true
                        implicitWidth: 90
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
                    NotificationCenter {
                        implicitWidth: 40
                        Layout.fillHeight: true
                    }
                    SystemUpdater {
                        Layout.fillHeight: true
                    }
                    CurrentLanguage {
                        Layout.fillHeight: true
                    }
                    SystemManager {
                        implicitWidth: 40
                        Layout.fillHeight: true
                    }
                }
            }
        }
    }
}
