pragma ComponentBehavior: Bound
import "../common"
import ".."

StyledButton {
    property int percentage: Services.battery.percentage
    property string status: Services.battery.status

    property var levels: [
        // 0% - 9%
        { icon: "󰁺", color: "#ff5555" },
        // 10% - 19%
        { icon: "󰁻", color: "#ff5555" },
        // 20% - 29%
        { icon: "󰁼", color: "#ffb86c" },
        // 30% - 39%
        { icon: "󰁽", color: "#ffb86c" },
        // 40% - 49%
        { icon: "󰁾", color: "#f1fa8c" },
        // 50% - 59%
        { icon: "󰁿", color: "#50fa7b" },
        // 60% - 69%
        { icon: "󰂀", color: "#50fa7b" },
        // 70% - 79%
        { icon: "󰂁", color: "#50fa7b" },
        // 80% - 89%
        { icon: "󰂂", color: "#50fa7b" },
        // 90% - 100%
        { icon: "󰁹", color: "#50fa7b" }
    ]

    property int currentLevel: {
        return Math.min(Math.floor(percentage / (100 / levels.length)), levels.length - 1)
    }

    property string icon: {
        if (status === "Charging") {
            return ""
        }
        return levels[currentLevel].icon
    }
        
    property string fgColor: {
        if (status === "Charging") {
            return "#7dc4e4"
        }
        return levels[currentLevel].color
    }

    text: `${icon} ${percentage}%`
    textColor: fgColor
}

