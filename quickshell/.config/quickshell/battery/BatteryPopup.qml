pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import "../common"
import ".."

Rectangle {
    id: root
    property string status: Services.battery.status
    property int percentage: Services.battery.percentage
    property string timeRemaining: Services.battery.timeRemaining
    property string powerProfile: Services.battery.powerProfile
    property bool powerProfileAvailable: powerProfile !== "Not Available"

    implicitWidth: 300
    implicitHeight: contentColumn.implicitHeight + 24
    color: "#1e1e2e"
    border.width: 2
    border.color: "#b7bdf8"
    radius: 12

    Column {
        id: contentColumn
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            margins: 12
        }
        spacing: 12

        // Battery Status Section
        Column {
            width: parent.width
            spacing: 8

            Text {
                text: "Battery Status"
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 14
                font.bold: true
                color: "#cdd6f4"
            }

            Row {
                width: parent.width
                spacing: 8

                Text {
                    text: "Status:"
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 12
                    color: "#bac2de"
                    width: 100
                }

                Text {
                    text: root.status
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 12
                    color: root.status === "Charging" ? "#a6e3a1" : "#cdd6f4"
                }
            }

            Row {
                width: parent.width
                spacing: 8

                Text {
                    text: "Percentage:"
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 12
                    color: "#bac2de"
                    width: 100
                }

                Text {
                    text: root.percentage + "%"
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 12
                    color: "#cdd6f4"
                }
            }

            Row {
                width: parent.width
                spacing: 8
                visible: root.timeRemaining !== "" && root.timeRemaining !== "Unknown"

                Text {
                    text: root.status === "Charging" ? "Time to Full:" : "Time Left:"
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 12
                    color: "#bac2de"
                    width: 100
                }

                Text {
                    text: root.timeRemaining
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 12
                    color: "#f9e2af"
                }
            }
        }

        // Separator
        Rectangle {
            width: parent.width
            height: 1
            color: "#45475a"
        }

        // Power Profile Section
        Column {
            width: parent.width
            spacing: 8

            Text {
                text: "Power Options"
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 14
                font.bold: true
                color: "#cdd6f4"
            }

            Text {
                text: "Install power-profiles-daemon for power profile control"
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 10
                color: "#6c7086"
                wrapMode: Text.WordWrap
                width: parent.width
                visible: !root.powerProfileAvailable
            }

            Column {
                width: parent.width
                spacing: 4
                visible: root.powerProfileAvailable

                PowerProfileButton {
                    profile: "performance"
                    icon: "󰓅"
                    label: "Performance"
                    active: root.powerProfile === "performance"
                }

                PowerProfileButton {
                    profile: "balanced"
                    icon: "󰾅"
                    label: "Balanced"
                    active: root.powerProfile === "balanced"
                }

                PowerProfileButton {
                    profile: "power-saver"
                    icon: "󰂃"
                    label: "Power Saver"
                    active: root.powerProfile === "power-saver"
                }
            }
        }
    }

    component PowerProfileButton: Rectangle {
        property string profile: ""
        property string icon: ""
        property string label: ""
        property bool active: false

        width: parent.width
        height: 32
        color: hoverHandler.hovered ? "#313244" : (active ? "#45475a" : "transparent")
        border.width: active ? 1 : 0
        border.color: "#89b4fa"
        radius: 6

        Row {
            anchors {
                left: parent.left
                leftMargin: 8
                verticalCenter: parent.verticalCenter
            }
            spacing: 8

            Text {
                text: icon
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 16
                color: active ? "#89b4fa" : "#cdd6f4"
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                text: label
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 12
                color: active ? "#89b4fa" : "#cdd6f4"
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        HoverHandler {
            id: hoverHandler
            cursorShape: Qt.PointingHandCursor
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                // This will be used when power-profiles-daemon is available
                Quickshell.execDetached({
                    command: ["/bin/sh", "-c", `powerprofilesctl set ${profile}`]
                })
            }
        }
    }
}
