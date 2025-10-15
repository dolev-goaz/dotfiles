pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Io
import Quickshell

QtObject {
    id: root
    
    property string currentLayout: "en"
    
    property Process languageListener: Process {
        running: true
        command: ["/bin/sh", "-c", "~/.local/bin/quickshell-keyboard-layout-listener.sh"]
        stdout: StdioCollector {
            waitForEnd: false
            onTextChanged: {
                const updatesStr = this.text.split("\n").filter(Boolean)
                const lastUpdateStr = updatesStr[updatesStr.length - 1]
                root.currentLayout = lastUpdateStr.trim().substring(0, 2).toLowerCase()
            }
        }
    }
    
    function toggleLanguage() {
        Quickshell.execDetached({
            command: ["/bin/sh", "-c", "~/.local/bin/quickshell-toggle-language.sh"]
        })
    }
}