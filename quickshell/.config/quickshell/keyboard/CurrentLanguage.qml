pragma ComponentBehavior: Bound

import "../common"
import QtQuick
import Quickshell
import Quickshell.Io
import ".."

Item {
    id: root
    property string currentLayout: Services.keyboard.currentLayout
    implicitWidth: 80

    StyledButton {
        id: toggleLangButton
        text: ` [${currentLayout}]`
        textColor: "#b7bdf8"
        implicitWidth: root.implicitWidth
        implicitHeight: 30
        onClicked: Services.keyboard.toggleLanguage()
    }
}
