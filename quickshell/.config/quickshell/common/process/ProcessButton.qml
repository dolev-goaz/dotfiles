pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Io // for process
import ".."

StyledButton {
    id: root
    required property list<string> command

    Process {
        id: processRunner
        // TODO: maybe always prefix ["/bin/sh", "-c"]
        command: root.command
    }

    onClicked: function(mouse) {
        if (mouse.button == Qt.LeftButton) {
            processRunner.running = true;
        }
    }
}
