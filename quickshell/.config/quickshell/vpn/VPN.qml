pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io
import "../common"
import ".."

StyledButton {
    id: root
    
    visible: Services.vpn.isAvailable
    
    property bool isConnected: Services.vpn.isConnected
    
    text: isConnected ? "󰌆  VPN" : "VPN"
    textColor: isConnected ? "#50fa7b" : "#ff5555"
    tooltipText: isConnected ? "VPN Connected (tun0 active)" : "VPN Disconnected"
    
    onClicked: function(mouse) {
        if (mouse.button === Qt.LeftButton) {
            openOrFocusAwsVpn.running = true
        }
    }
    
    property Process openOrFocusAwsVpn: Process {
        command: ["/bin/sh", "-c", "~/.local/bin/open-or-focus-vpn.sh"]
        running: false
    }
}
