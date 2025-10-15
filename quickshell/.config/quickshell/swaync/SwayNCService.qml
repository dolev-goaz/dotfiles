pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Io
import Quickshell

QtObject {
    id: root
    
    property int messageCount: 0
    property bool isDND: false
    property bool isOpen: false
    property bool isInhibited: false
    
    property Process swayncProcess: Process {
        running: true
        command: ["swaync-client", "-s"]
        stdout: StdioCollector {
            waitForEnd: false
            onTextChanged: {
                const updatesStr = this.text.split("\n").filter(Boolean)
                const lastUpdateStr = updatesStr[updatesStr.length - 1]
                const latestUpdate = JSON.parse(lastUpdateStr)

                root.messageCount = latestUpdate.count
                root.isDND = latestUpdate.dnd
                root.isOpen = latestUpdate.visible
                root.isInhibited = latestUpdate.inhibited
            }
        }
    }
    
    function togglePanel() {
        Quickshell.execDetached({
            command: ["swaync-client", "-t"]
        })
    }
    
    function toggleDND() {
        const dndFlag = root.isDND ? "--dnd-off" : "--dnd-on"
        Quickshell.execDetached({
            command: ["swaync-client", dndFlag]
        })
    }
}