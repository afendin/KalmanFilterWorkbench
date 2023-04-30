import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import KalmanFilterWorkbench

Window {
    id: root

    // thanks to https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/random#getting_a_random_integer_between_two_values_inclusive
    function getRandomIntInclusive(min, max) {
      min = Math.ceil(min);
      max = Math.floor(max);
      return Math.floor(Math.random() * (max - min + 1) + min); // The maximum is inclusive and the minimum is inclusive
    }

    width: 1000
    height: 914
    visible: true
    color: "gray"

    ColumnLayout {
        anchors.fill: parent

        Rectangle {
            id: scene

            Layout.fillWidth: true
            Layout.preferredHeight: 300

            Timer {
                id: timer

                property int value: 0
                property int realDistance: value * 10

                interval: 100
                repeat: true
                running: true
                onTriggered: {
                    value++
                    const bias = root.getRandomIntInclusive(-sbBiasDistance.value,
                                                            sbBiasDistance.value)
                    StateManager.update(realDistance + bias, value)
                    heightGraph.addPoints([value, StateManager.estimated_distance], "red")
                    heightGraph.addPoints([value, StateManager.measured_distance], "blue")
                    heightGraph.addPoints([value, realDistance], "green")
                    heightGraph.addPoints([value, StateManager.predicted_distance], "gray")
                }
            }

            Image {
                anchors.centerIn: parent

                sourceSize: Qt.size(40, 40)
                source: "qrc:/assets/plane.svg"

                Image {
                    x: (StateManager.estimated_distance - timer.realDistance)
                    y: - height - 10
                    sourceSize: Qt.size(40, 40)
                    source: "qrc:/assets/plane.svg"
                    opacity: 0.5

                    Label {
                        anchors.bottom: parent.top
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: qsTr("Estimated position")
                    }

                    Behavior on x {

                        NumberAnimation {
                            //This specifies how long the animation takes
                            duration: timer.interval
                        }
                    }
                }
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
                        x: (parent.width) - (timer.realDistance % parent.width + index * parent.width / 4)
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 5
            Layout.rightMargin: 5

            Rectangle {
                Layout.preferredWidth: 600
                Layout.preferredHeight: width
                border.width: 1

                KFHeightGraph {
                    id: heightGraph

                    anchors.fill: parent
                    initMinX: 0
                    initMaxX: 10
                    initMinY: 0
                    initMaxY: 10
                    bottomMargin: 0
                    leftMargin: 0

                    Label {
                        anchors {
                            top: parent.top
                            left: parent.left
                            topMargin: 4
                            leftMargin: 4
                        }

                        text: qsTr("Distance")
                    }

                    Label {
                        anchors {
                            bottom: parent.bottom
                            right: parent.right
                            bottomMargin: 4
                            rightMargin: 4
                        }

                        text: qsTr("Time")
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                border.width: 1

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    Row {
                        Label {
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: 14
                            text: qsTr("Distance measurement bias(m):")
                        }

                        SpinBox {//TODO give apropriate names
                            id: sbBiasDistance

                            value: StateManager.bias_distance
                            onValueChanged: StateManager.bias_distance !== value ?
                                            StateManager.bias_distance = value : null
                            editable: true
                            width: 130
                        }
                    }

                    Row {
                        Label {
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: 14
                            text: qsTr("Trust distance:")
                        }

                        DoubleSpinBox {
                            id: sbTrustDistance

                            editable: true
                            width: 130
                            value: StateManager.trust_distance * factor
                            onRealValueChanged: StateManager.trust_distance !== realValue ?
                                                    StateManager.trust_distance = realValue : null
                        }
                    }

                    Row {
                        Label {
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: 14
                            text: qsTr("Trust velocity:")
                        }

                        DoubleSpinBox {
                            id: sbTrustVelocity

                            editable: true
                            width: 130
                            value: StateManager.trust_velocity * factor
                            onRealValueChanged: StateManager.trust_velocity !== realValue ?
                                                StateManager.trust_velocity = realValue : null


                        }
                    }

                    KFGraphNote {
                        color: "green"
                        label: "True values"
                    }

                    KFGraphNote {
                        color: "blue"
                        label: "Measurements"
                    }

                    KFGraphNote {
                        color: "red"
                        label: "Estimates"
                    }

                    KFGraphNote {
                        color: "gray"
                        label: "Prediction"
                    }

                    Row {
                        spacing: 16

                        Button {
                            text: timer.running ? "Pause" : "Play"
                            onClicked: timer.running ? timer.stop() : timer.start()
                        }

                        Button {
                            text: "Restart"
                            onClicked: {
                                StateManager.restart()
                                timer.value = 0
                                heightGraph.clear()
                            }
                        }
                    }

                    Item {
                        width: 1
                        Layout.fillHeight: true
                    }
                }
            }
        }

        Item {
            width: 1
            Layout.fillHeight: true
        }
    }

}
