pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Io
import Quickshell

QtObject {
    id: root
    
    property bool isAvailable: false
    property bool isConnected: false
    
    // Check if AWS VPN Client is installed
    property Process checkInstalledProcess: Process {
        id: checkInstalledProcess
        running: true
        command: ["/bin/sh", "-c", "if [ -f '/opt/awsvpnclient/AWS VPN Client' ]; then echo 'true'; else echo 'false'; fi"]
        stdout: StdioCollector {
            waitForEnd: true
            onStreamFinished: {
                root.isAvailable = this.text.trim() === "true"
                if (root.isAvailable) {
                    statusCheckProcess.running = true // initial status
                    monitorProcess.running = true // on status update
                }
            }
        }
    }
    
    // Check current VPN status 
    property Process statusCheckProcess: Process {
        id: statusCheckProcess
        running: false
        command: ["/bin/sh", "-c", "if ip link show tun0 up > /dev/null 2>&1; then echo 'true'; else echo 'false'; fi"]
        stdout: StdioCollector {
            waitForEnd: true
            onStreamFinished: {
                root.isConnected = this.text.trim() === "true"
                // Check again every 2 seconds
                statusCheckTimer.restart()
            }
        }
    }
    
    // Monitor for tun0 link changes
    property Process monitorProcess: Process {
        id: monitorProcess
        running: false
        command: ["/bin/sh", "-c", "~/.local/bin/quickshell-monitor-vpn.sh"]
        stdout: StdioCollector {
            waitForEnd: false
            onTextChanged: {
                const lastLine = this.text.trim().split("\n").pop()
                if (lastLine === "connected") {
                    root.isConnected = true
                } else if (lastLine === "disconnected") {
                    root.isConnected = false
                }
            }
        }
    }
}

