pragma ComponentBehavior: Bound
import "./calendar_layout.js" as CalendarLayout
import QtQuick
import QtQuick.Layouts
import "../common/widgets"

// somewhat stolen from https://github.com/end-4/dots-hyprland

Item {
    id: root
    anchors.topMargin: 10
    property int monthShift: 0
    property var viewingDate: CalendarLayout.getDateInXMonthsTime(monthShift)
    property var calendarLayout: CalendarLayout.getCalendarLayout(viewingDate, monthShift === 0)
    width: calendarColumn.width
    implicitHeight: calendarColumn.height + 10 * 2

    Keys.onPressed: event => {
        if ((event.key === Qt.Key_PageDown || event.key === Qt.Key_PageUp) && event.modifiers === Qt.NoModifier) {
            if (event.key === Qt.Key_PageDown) {
                monthShift++;
            } else if (event.key === Qt.Key_PageUp) {
                monthShift--;
            }
            event.accepted = true;
        }
    }
    MouseArea {
        anchors.fill: parent
        onWheel: event => {
            if (event.angleDelta.y > 0) {
                root.monthShift--;
            } else if (event.angleDelta.y < 0) {
                root.monthShift++;
            }
        }
    }

    ColumnLayout {
        id: calendarColumn
        anchors.centerIn: parent
        spacing: 5

        // Calendar header
        RowLayout {
            Layout.fillWidth: true
            spacing: 5
            CalendarHeaderButton {
                buttonText: `${root.viewingDate.toLocaleDateString(Qt.locale(), "MM/yy")}${root.monthShift != 0 ? " •" : ""}`
                onClicked: {
                    root.monthShift = 0;
                }
            }
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: false
            }
            CalendarHeaderButton {
                forceCircle: true
                onClicked: {
                    root.monthShift--;
                }
                contentItem: Text {
                    text: "<"
                    font.pointSize: 16
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: "#CFC3CD"
                }
            }
            CalendarHeaderButton {
                forceCircle: true
                onClicked: {
                    root.monthShift++;
                }
                contentItem: Text {
                    text: ">"
                    font.pointSize: 16
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: "#CFC3CD"
                }
            }
        }

        // Week days row
        RowLayout {
            id: weekDaysRow
            Layout.alignment: Qt.AlignHCenter
            Layout.fillHeight: false
            spacing: 5
            Repeater {
                model: CalendarLayout.weekDays
                delegate: CalendarDayButton {
                    required property var modelData
                    day: modelData.day
                    isToday: modelData.today
                    bold: true
                    enabled: false
                }
            }
        }

        // Real week rows
        Repeater {
            id: calendarRows
            model: 6
            delegate: RowLayout {
                id: rowLayout
                required property int modelData
                Layout.alignment: Qt.AlignHCenter
                Layout.fillHeight: false
                spacing: 5
                Repeater {
                    model: Array(7).fill(rowLayout.modelData)
                    delegate: CalendarDayButton {
                        required property var modelData
                        required property int index
                        day: root.calendarLayout[modelData][index].day
                        isToday: root.calendarLayout[modelData][index].today
                    }
                }
            }
        }
    }
}
