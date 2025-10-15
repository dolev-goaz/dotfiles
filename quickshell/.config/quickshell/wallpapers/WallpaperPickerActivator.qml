pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import "../common"

StyledButton {
    id: root
    property bool isPickerVisible: false

    text: "󰸉"
    
    onClicked: function() {
        isPickerVisible = !isPickerVisible;
    }

    LazyLoader {
        active: root.isPickerVisible
        component: WallpaperPicker {
            onWallpaperSelected: {
                root.isPickerVisible = false;
            }
        }
    }

}
