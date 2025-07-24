import QtQuick

Text {
    text: Qt.formatDateTime(Time.time, "ddd MMM d hh:mm:ss AP t yyyy")
    color: "#ffffff"
}
