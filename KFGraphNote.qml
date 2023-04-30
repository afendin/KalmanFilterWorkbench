import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import KalmanFilterWorkbench

Row {
    property alias color: line.color
    property alias label: label.text

    spacing: 10

    Rectangle {
        id: line

        anchors.verticalCenter: parent.verticalCenter
        width: 30
        height: 2
    }

    Label { id: label }
}
