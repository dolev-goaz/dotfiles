import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Services.SystemTray

Rectangle {
    id: root
    required property list<QsMenuEntry> options
    property int paddingInline: 10
    property int paddingBlock: 15
    color: "#F5EFED"
    height: container.height + paddingBlock * 2
    property int listWidth: 300
    width: listWidth + paddingInline * 2
    radius: 8
    signal menuOptionSelected
    ListView {
        id: container
        height: contentHeight
        width: root.width
        x: root.paddingInline
        y: root.paddingBlock

        model: options
        orientation: Qt.Vertical
        delegate: Loader {
            id: entryLoader
            required property QsMenuEntry modelData
            sourceComponent: modelData.isSeparator ? separatorComponent : buttonComponent
        }
        Component {
            id: buttonComponent
            Button {
                id: control
                text: modelData.text
                width: root.listWidth
                enabled: modelData.enabled && !modelData.hasChildren
                contentItem: Text {
                    text: {
                        const parts = []
                        // https://quickshell.org/docs/v0.1.0/types/Quickshell/QsMenuButtonType/
                        if (modelData.buttonType === QsMenuButtonType.CheckBox) {
                            parts.push(modelData.checkState ? " " : " ")
                        }
                        parts.push(modelData.text)
                        if (modelData.hasChildren) {
                            parts.push("▶")
                        }
                        return parts.join(" ")
                    }
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 15
                    color: modelData.enabled ? "#111111" : "#777777"
                    elide: Text.ElideRight
                }

                background: Rectangle {
                    color: {
                        if (!modelData.enabled) {
                            return "transparent"
                        }
                        if (control.pressed) {
                            return "#cccccc"
                        } else if (control.hovered) {
                            return "#dddddd"
                        }
                        return "transparent"
                    }
                    radius: 6
                }
                onClicked: {
                    // const baseModel = {}
                    // for (const key of Object.keys(modelData)) {
                    //     if (typeof modelData[key] !== "object") {
                    //         baseModel[key] = modelData[key]
                    //     }
                    // }

                    if (modelData.hasChildren) {

                    } else {
                        modelData.triggered()
                        root.menuOptionSelected()
                    }
                }
            }
        }

        Component {
            id: separatorComponent
            Item {
                width: root.listWidth
                height: 12 // separator height + spacing
                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width
                    height: 1
                    color: "#cccccc"
                    opacity: 0.5
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }
}
