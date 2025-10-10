pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Io
import Quickshell

QtObject {
    id: root
    
    property var updateCounts: null
    property int totalUpdates: root.updateCounts ? root.updateCounts.total : 0
    property bool isUpdating: false
    property bool isChecking: false
    
    signal updateFinished()
    
    property Timer updateTimer: Timer {
        interval: 5 * 60 * 1000 // 5 minutes
        running: true
        repeat: true
        onTriggered: root.checkForUpdates()
    }
    
    property Process updateCountProcess: Process {
        running: false
        command: ["/bin/sh", "-c", "~/scripts/available-updates-arch.sh"]
        stdout: StdioCollector {
            onStreamFinished: {
                const updateCounts = JSON.parse(this.text);
                root.updateCounts = updateCounts.total > 0 ? updateCounts : null;
                root.isChecking = false;
            }
        }
    }
    
    property Process updateProcess: Process {
        running: false
        command: ["/bin/sh", "-c", "~/.local/bin/quickshell-update-system.sh"]
    }
    
    function checkForUpdates() {
        if (!root.isChecking && !updateCountProcess.running) {
            root.isChecking = true;
            updateCountProcess.running = true;
        }
    }
    
    function performUpdate() {
        if (!root.isUpdating && !updateProcess.running) {
            root.isUpdating = true;
            updateProcess.running = true;
        }
    }
    
    Component.onCompleted: {
        root.checkForUpdates();
    }
}