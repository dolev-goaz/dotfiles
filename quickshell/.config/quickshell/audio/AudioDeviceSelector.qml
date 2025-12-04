pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io
import QtQuick.Layouts

Item {
    id: deviceSelector
    
    signal deviceSelected
    
    property var devices: []
    implicitWidth: deviceListContainer.width
    implicitHeight: deviceListContainer.height
    
    function refresh() {
        fetchDevicesProcess.running = true
    }
    
    Process {
        running: false
        id: fetchDevicesProcess
        command: ["/bin/bash", "/home/dolev/.local/bin/quickshell-get-audio-devices.sh"]
        stdout: StdioCollector {
            onStreamFinished: {
                const lines = this.text.trim().split("\n")
                const deviceObjects = []
                
                for (let i = 0; i < lines.length; i++) {
                    const parts = lines[i].split("|")
                    if (parts.length >= 3) {
                        deviceObjects.push({
                            id: parts[0],
                            name: parts[1],
                            isDefault: parts[2] === "true"
                        })
                    }
                }
                
                devices = deviceObjects
            }
        }
    }
    
    Rectangle {
        id: deviceListContainer
        width: 300
        height: deviceList.implicitHeight + 40
        color: "#494d64"
        border.width: 2
        border.color: "#b7bdf8"
        radius: 10
        
        ColumnLayout {
            id: deviceList
            anchors {
                fill: parent
                margins: 20
            }
            spacing: 10
            
            Text {
                text: "Audio Output Devices"
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 14
                font.bold: true
                color: "#cdd6f4"
                Layout.fillWidth: true
                Layout.bottomMargin: 10
            }
            
            Repeater {
                model: deviceSelector.devices
                
                delegate: Rectangle {
                    required property var modelData
                    
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40
                    
                    color: deviceMouseArea.containsMouse ? "#585b70" : "#45475a"
                    radius: 8
                    border.width: modelData.isDefault ? 2 : 0
                    border.color: "#89b4fa"
                    
                    RowLayout {
                        anchors {
                            fill: parent
                            margins: 10
                        }
                        spacing: 10
                        
                        Text {
                            text: modelData.isDefault ? "󰄬" : "󰓃"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 16
                            color: modelData.isDefault ? "#89b4fa" : "#cdd6f4"
                        }
                        
                        Text {
                            text: modelData.name
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 12
                            color: "#cdd6f4"
                            Layout.fillWidth: true
                            elide: Text.ElideRight
                        }
                    }
                    
                    MouseArea {
                        id: deviceMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        
                        onClicked: {
                            Quickshell.execDetached({
                                command: ["/bin/bash", "/home/dolev/.local/bin/quickshell-set-audio-device.sh", parent.modelData.id]
                            })
                            deviceSelector.deviceSelected()
                        }
                    }
                }
            }
        }
    }
}
