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
            spacing: 10
            delegate: Image {
                required property string modelData
                source: modelData
                width: 300
                fillMode: Image.PreserveAspectCrop
                height: container.height
            }
        }
    }
}
