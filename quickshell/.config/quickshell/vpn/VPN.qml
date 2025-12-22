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
    
    text: "󰌆 VPN"
    textColor: isConnected ? "#50fa7b" : "#ff5555"
    backgroundColor: isConnected ? "#1e1e2e" : "#2a2a3e"
    borderColor: isConnected ? "#50fa7b" : "#ff5555"
    tooltipText: isConnected ? "VPN Connected (tun0)" : "VPN Disconnected"
    
    Behavior on textColor {
        ColorAnimation { duration: 200 }
    }
    Behavior on backgroundColor {
        ColorAnimation { duration: 200 }
    }
    Behavior on borderColor {
        ColorAnimation { duration: 200 }
    }
    
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
