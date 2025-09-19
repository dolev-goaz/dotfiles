pragma ComponentBehavior: Bound

import "../common/process"
import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root
    property string currentLayout: "en"
    implicitWidth: 80

    ProcessButton {
        id: toggleLangButton
        command: ["/bin/sh", "-c", "~/.local/bin/quickshell-toggle-language.sh"]
        text: ` [${currentLayout}]`
        textColor: "#b7bdf8"
        implicitWidth: root.implicitWidth
        implicitHeight: 30
    }
    Process {
        id: languageListener
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
}
