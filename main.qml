import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import KalmanFilterWorkbench

Window {
    id: root

    width: 1000
    height: 1000
    visible: true
    color: "gray"

    Rectangle {
        id: scene

        width: 700
        height: 300

        Timer {
            id: timer

            property int value: 999999999

            interval: 100
            repeat: true
            running: true
            onTriggered: value--
        }

        Rectangle {
            anchors {
                bottom: parent.bottom
                bottomMargin: 10
            }

            width: parent.width
            height: 2
            color: "black"


            Repeater {
                model: 4

                KFDelimiter {
                    anchors.verticalCenter: parent.bottom
                    x: (timer.value - parent.width / (index + 2))*10 % parent.width
                }
            }
        }

    }

    ColumnLayout {
        anchors.bottom: parent.bottom

        Row {

        }

        Row {
            Label {
                text: qsTr("Velocity bias")
            }

            SpinBox {
//                value: DrawManager.trust_distance
//                onValueChanged: DrawManager.trust_distance !== value ?
//                                DrawManager.trust_distance = value : null
                editable: true
            }
        }

        Row {
            Label {
                text: qsTr("Distance bias")
            }

            SpinBox {//TODO give apropriate names
//                value: DrawManager.trust_distance
//                onValueChanged: DrawManager.trust_distance !== value ?
//                                DrawManager.trust_distance = value : null
                editable: true
            }
        }

        Row {
            Label {
                text: qsTr("Velocity trust")
            }

            SpinBox {
                value: DrawManager.trust_velocity
                onValueChanged: DrawManager.trust_velocity !== value ?
                                DrawManager.trust_velocity = value : null
                editable: true
            }
        }

        Row {
            Label {
                text: qsTr("Distance trust")
            }

            SpinBox {
                value: DrawManager.trust_distance
                onValueChanged: DrawManager.trust_distance !== value ?
                                DrawManager.trust_distance = value : null
                editable: true
            }
        }

    }
}
