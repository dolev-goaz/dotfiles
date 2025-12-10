pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Io
import Quickshell

QtObject {
    id: root
    
    property string basePath: "/sys/class/power_supply"
    property string batteryName: ""
    property int percentage: 0
    property string status: "Unknown"
    property string timeRemaining: "Unknown"
    property string powerProfile: "Not Available"
    property bool batteryPresent: batteryName !== ""

    property Process getBatteryName: Process {
        running: true
        command: ["/bin/sh", "-c", `ls ${basePath}`]
        stdout: StdioCollector {
            waitForEnd: true
            onStreamFinished: {
                root.batteryName = this.text.trim().split("\n").find(name => name.startsWith("BAT")) || ""
                batteryProcess.running = true
            }
        }
    }
    
    property Process batteryProcess: Process {
        id: batteryProcess
        running: false
        command: [
            "/bin/sh", "-c", "~/.local/bin/quickshell-get-battery.sh " + root.batteryName
        ]
        stdout: StdioCollector {
            waitForEnd: false
            onTextChanged: {
                const lastLine = this.text.trim().split("\n").pop() 
                const parts = lastLine.split(", ")
                root.status = parts[0]
                root.percentage = parseInt(parts[1])
                root.timeRemaining = parts[2] || "Unknown"
                root.powerProfile = parts[3] || "Not Available"
            }
        }
    }
}
