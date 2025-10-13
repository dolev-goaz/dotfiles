pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import "./system_update"

QtObject {
    id: root
    
    readonly property SystemUpdateService systemUpdate: SystemUpdateService {}
}