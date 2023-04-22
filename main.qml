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
    height: 1000
    visible: true
    color: "gray"

    Rectangle {
        id: scene

        width: 700
        height: 300

        Timer {
            id: timer

            property int value: 0

            interval: 100
            repeat: true
            running: true
            onTriggered: {
                value++
                const bias = root.getRandomIntInclusive(-sbBiasDistance.value,
                                                        sbBiasDistance.value)
                DrawManager.update(distanceSlider.value + bias, value)
            }
        }

        Slider {
            id: distanceSlider

            anchors.centerIn: parent
            width: parent.width
            from: 0
            to: 1000
        }

        Rectangle {
            color: 'red'
            width: 30
            height: width
            opacity: 0.5
            x: (700 - ((1000 - DrawManager.estimated_distance) * (700 / 1000))) - width / 2
        }
    }

    ColumnLayout {
        anchors.bottom: parent.bottom

        Row {
            Label {
                text: qsTr("Velocity bias")
            }

            SpinBox {
                value: DrawManager.bias_velocity
                onValueChanged: DrawManager.bias_velocity !== value ?
                                DrawManager.bias_velocity = value : null
                editable: true
            }
        }

        Row {
            Label {
                text: qsTr("Distance bias (up to in meters)")
            }

            SpinBox {//TODO give apropriate names
                id: sbBiasDistance

                value: DrawManager.bias_distance
                onValueChanged: DrawManager.bias_distance !== value ?
                                DrawManager.bias_distance = value : null
                editable: true
            }
        }

        Row {
            Label {
                text: qsTr("Velocity trust")
            }

            SpinBox {
                id: sbTrustVelocity

                property real realValue: value / 10

                value: DrawManager.trust_velocity * 10
                onRealValueChanged: DrawManager.trust_velocity !== realValue ?
                                DrawManager.trust_velocity = realValue : null
                from: 1 //TODO: convert SB to decimals
                to : 10
                editable: true
            }
        }

        Row {
            Label {
                text: qsTr("Distance trust")
            }

            SpinBox {
                id: sbTrustDistance

                property real realValue: value / 10

                value: DrawManager.trust_distance * 10
                onRealValueChanged: {DrawManager.trust_distance !== realValue ?
                                DrawManager.trust_distance = realValue : null; console.log(realValue)}
                from: 1 //TODO: convert SB to decimals
                to : 10
                editable: true
            }
        }

    }
}
