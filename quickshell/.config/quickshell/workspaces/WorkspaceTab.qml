import QtQuick
import "../common"

StyledButton {
    id: root
    property bool active: false
    property bool urgent: false
    property real flashPhase: 0
    property int textSize: 12
    signal workspaceClick
    
    width: 32
    height: 24
    borderRadius: 15
    backgroundColor: root.active ? "#8087a2" : "#494d64"
    borderColor: root.urgent
        ? Qt.rgba(1, flashPhase, flashPhase, 1)
        : "#b7bdf8"
    borderWidth: 2
    textColor: root.active ? "#ffffff" : "#cccccc"
    textPixelSize: root.textSize
    fontFamily: "Inter, sans-serif"

    tooltipText: getTooltipText()
    function getTooltipText() {
        const components = [
            `Workspace ${root.text}`,
        ]
        root.active && components.push("(active)");
        root.urgent && components.push("- urgent!");
        return components.join(" ");
    }
    
    onClicked: root.workspaceClick()

    property int animationDuration: 500
    SequentialAnimation on flashPhase {
        running: root.urgent
        loops: Animation.Infinite
        NumberAnimation { from: 0; to: 1; duration: animationDuration; easing.type: Easing.InOutQuad }
        NumberAnimation { from: 1; to: 0; duration: animationDuration; easing.type: Easing.InOutQuad }
        onStopped: flashPhase = 0
    }
}
