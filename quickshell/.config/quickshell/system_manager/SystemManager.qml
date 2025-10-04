pragma ComponentBehavior: Bound
import "../common/process"

ProcessButton {
    text: ""
    command: ["/bin/sh", "-c", "~/.local/bin/toggle-btop.sh"]
}

