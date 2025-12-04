pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Io
import Quickshell

QtObject {
    id: root
    
    property int volume: 0
    property bool muted: false
    property string currentSink: ""
    
    property Process audioProcess: Process {
        id: audioProcess
        running: true
        command: [
            "/bin/sh", "-c", "~/.local/bin/quickshell-get-audio.sh"
        ]
        stdout: StdioCollector {
            waitForEnd: false
            onTextChanged: {
                const lastLine = this.text.trim().split("\n").pop() 
                const parts = lastLine.split(", ")
                if (parts.length >= 3) {
                    root.volume = parseInt(parts[0])
                    root.muted = parts[1] === "true"
                    root.currentSink = parts[2]
                }
            }
        }
    }
}
