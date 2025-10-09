import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Services.SystemTray

StackView {
    id: root
    signal menuOptionSelected
    required property QsMenuHandle handle
    implicitWidth: currentItem.width
    implicitHeight: currentItem.height

    initialItem: Menu {
        handle: root.handle
    }

    pushEnter: NoAnim {}
    pushExit: NoAnim {}
    popEnter: NoAnim {}
    popExit: NoAnim {}
    component NoAnim: Transition {
        NumberAnimation {
            duration: 0
        }
    }

    component Menu: Item {
        property bool isSubMenu: false
        required property QsMenuHandle handle
        property int paddingInline: 10
        property int paddingBlock: 15
        property int listWidth: 300
        width: content.implicitWidth + paddingInline * 2
        height: content.implicitHeight + paddingBlock * 2
        QsMenuOpener {
            id: menuOpener
            menu: handle
        }
        Rectangle {
            anchors.fill: parent
            color: "#F5EFED"
            radius: 8
        }
        Column {
            id: content
            x: paddingInline
            y: paddingBlock
            Repeater {
                model: menuOpener.children.values
                delegate: Loader {
                    required property QsMenuEntry modelData
                    sourceComponent: modelData.isSeparator ? separatorComponent : buttonComponent
                }
            }
            Button {
                id: backButton
                visible: isSubMenu
                contentItem: Text {
                    text: " Back "
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 15
                    color: "#111111"
                }
                background: Rectangle {
                    color: {
                        if (backButton.pressed) {
                            return "#cccccc"
                        } else if (backButton.hovered) {
                            return "#F2C7BE"
                        }
                        return "#ffd9e3"
                    }
                    radius: 20
                }
                onClicked: {
                    root.pop()
                }
            }
            Component {
                id: buttonComponent
                Button {
                    id: control
                    text: modelData.text
                    width: listWidth
                    enabled: modelData.enabled
                    contentItem: Text {
                        text: {
                            const parts = []
                            // https://quickshell.org/docs/v0.1.0/types/Quickshell/QsMenuButtonType/
                            if (modelData.buttonType === QsMenuButtonType.CheckBox) {
                                parts.push(modelData.checkState ? " " : " ")
                            }
                            parts.push(modelData.text)
                            if (modelData.hasChildren) {
                                parts.push("")
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
                        if (modelData.hasChildren) {
                            root.push(subMenuGenerator.createObject(null, {
                                handle: modelData,
                            }))

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
                    width: listWidth
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
    Component {
        id: subMenuGenerator

        Menu {
            isSubMenu: true
        }
    }
}
