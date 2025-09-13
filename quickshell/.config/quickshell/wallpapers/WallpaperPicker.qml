pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io

PanelWindow {
    id: wallpaperPicker
    anchors {
        bottom: true;
        left: true;
        right: true
    }
    margins {
        // same as hyprland
        left: 10
        right: 20
        bottom: 20
    }
    color: "transparent"
    implicitHeight: 200
    exclusiveZone: 0

    Rectangle {
        anchors.fill: parent
        color: "#333"
        radius: 10
    }
    property list<string> images: []
    property string basePath: "/home/dolev/Pictures/Wallpapers/"
    Process {
        id: fetchImagesProcess
        command: ["/bin/sh", "-c", "ls " + basePath + " 2>/dev/null"]
        stdout: StdioCollector {
            onStreamFinished: {
                images = this.text.trim().split("\n").map((fileName) => basePath + fileName)
            }
        }
    }
    Component.onCompleted: {
        fetchImagesProcess.running = true
    }

    Rectangle {
        color: "transparent"
        anchors {
            fill: parent
            margins: 20
            verticalCenter: parent.verticalCenter
        }
        ListView {
            height: parent.height
            width: parent.width
            id: container

            model: images
            orientation: Qt.Horizontal
            spacing: 15
            delegate: Image {
                id: wallpaper
                required property string modelData
                source: modelData
                fillMode: Image.PreserveAspectCrop
                anchors.verticalCenter: parent.verticalCenter

                property bool hovered: false
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: wallpaper.hovered = true
                    onExited: wallpaper.hovered = false
                    onClicked: {
                        // TODO: actual set wallpaper logic
                        console.log("Setting wallpaper to " + wallpaper.modelData)
                    }
                }

                Behavior on height {
                    NumberAnimation { duration: 150; easing.type: Easing.InOutQuad }
                }
                Behavior on width {
                    NumberAnimation { duration: 150; easing.type: Easing.InOutQuad }
                }

                height: hovered ? container.height : container.height - 20
                width: hovered ? 400: 300
            }
        }
    }
}
