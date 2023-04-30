import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import KalmanFilterWorkbench

SpinBox {
    id: spinbox

    property int decimals: 1
    property real realValue: value / factor
    property real realFrom: 0
    property real realTo: 1.0
    property real realStepSize: 0.1
    property real factor: Math.pow(10, decimals)


    value: realValue*factor
    to : realTo*factor
    from : realFrom*factor
    stepSize: realStepSize*factor

    validator: DoubleValidator {
        bottom: Math.min(spinbox.from, spinbox.to)*spinbox.factor
        top:  Math.max(spinbox.from, spinbox.to)*spinbox.factor
    }

    textFromValue: function(value, locale) {
        return Number(value / factor).toLocaleString(locale, 'f', spinbox.decimals)
    }

    valueFromText: function(text, locale) {
        return Math.round(Number.fromLocaleString(locale, text) * factor)
    }
}
