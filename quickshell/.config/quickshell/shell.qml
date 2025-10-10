// for menu anchors (system tray menu)
//@ pragma UseQApplication
// for icon theme- https://quickshell.org/docs/v0.1.0/types/Quickshell/Quickshell/#iconPath
//@ pragma IconTheme breeze-dark

import Quickshell

Scope {
    // Global Services instance
    Services {
        id: services
    }
    
    Bar {
        updateService: services.systemUpdate
    }
}
