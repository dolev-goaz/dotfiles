import Quickshell
import Quickshell.Io
import QtQuick

Scope {
    id: root

    // add a property in the root
    property string time

    // for all screens
    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 30

            Text {
                // remove the id as we don't need it anymore

                anchors.centerIn: parent

                // bind the text to the root object's time property
                text: root.time
            }
        }
    }

    Process {
        id: dateProc
        command: ["date"]
        running: true

        stdout: StdioCollector {
            // update the property instead of the clock directly
            onStreamFinished: root.time = this.text
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: dateProc.running = true
    }
}
