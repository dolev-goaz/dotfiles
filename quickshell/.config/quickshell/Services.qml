pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import "./system_update"
import "./swaync"
import "./keyboard"
import "./battery"

QtObject {
    id: root
    
    readonly property SystemUpdateService systemUpdate: SystemUpdateService {}
    readonly property SwayNCService notifications: SwayNCService {}
    readonly property KeyboardService keyboard: KeyboardService {}
    readonly property BatteryService battery: BatteryService {}
}
