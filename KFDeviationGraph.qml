import QtQuick 2.0
import QtQuick.Controls.Material 2.2
import "d3.min.js" as D3

Canvas {
    id: canvas

    property real initMinX: -width / 2
    property real initMaxX: width / 2
    property real initMinY: -height / 2
    property real initMaxY: height / 2
    property real minX: initMinX
    property real maxX: initMaxX
    property real minY: initMinY
    property real maxY: initMaxY
    property int leftMargin: 10
    property int bottomMargin: 10
    property var yScaleValue: d3.scaleLinear().range([height - bottomMargin, 0]).domain([minY, maxY]);
    property var yScaleSize: d3.scaleLinear().range([0, height]).domain([height, 0]);
    property var xScale: d3.scaleLinear().range([leftMargin, width]).domain([minX, maxX]);
    property var lineValue: lineFunction(xScale, yScaleValue, context);
    property var lineSize: lineFunction(d3.scaleLinear().range([0, width]).domain([0, width]), yScaleSize, context);
    property var lineArray: []

    function addPoints(inPointsArray) {
        lineArray = inPointsArray;

        for (var i = 0; i < lineArray.length; i++) {
            if (lineArray[i][0] >= maxX)
                maxX = lineArray[i][0] * 1.5

            if (Math.abs(lineArray[i][1]) >= maxY) {
                maxY = Math.abs(lineArray[i][1]) * 1.5
                minY = -Math.abs(lineArray[i][1]) * 1.5
            }
        }
        requestPaint()
    }

    function clear() {
        minX = initMinX
        maxX = initMaxX
        minY = initMinY
        maxY = initMaxY
        lineArray = []
        requestPaint()
    }

    width: 200
    height: 200
    onPaint: {
        var context = getContext('2d');
        context.clearRect(0,0,canvas.width,canvas.height)

        context.beginPath();
        context.lineWidth = 1.5;
        context.strokeStyle = Material.foreground;
        context.fillStyle = Material.foreground;
        context.font = '10px serif';

        drawXAxis(context, 10);
        drawYAxis(context, 10);
        context.stroke();

        context.beginPath();
        context.lineWidth = 1.5;
        context.strokeStyle = vsStyle.red;
        context.fillStyle = vsStyle.red;

        lineValue(lineArray);
        context.stroke();
    }

    function lineFunction(xScale, yScale, context) {
        return d3.line().x(function (d) {
            return xScale(d[0]);
        }).y(function (d) {
            return yScale(d[1]);
        }).curve(d3.curveMonotoneX)
        .context(context);
    }

    function drawXAxis(context, steps) {
        lineValue([[0, 0], [maxX, 0]]);
        var stepSize = (width - leftMargin) / steps;
        var plotStepSize = (maxX - minX) / steps;
        for (var i = 1; i < steps; i++) {
            lineSize([[stepSize * i + leftMargin, yScaleValue(0)],
                  [stepSize * i + leftMargin, yScaleValue(0) + 20]])
            // Decimal points should be configured with dependency on max - min interval length
            var text = (minX + plotStepSize * i).toFixed(1).toString();
            context.fillText(text, stepSize * i + leftMargin -
                             context.measureText(text).width / 2, yScaleValue(0) + 25);
        }
    }

    function drawYAxis(context, steps) {
        lineSize([[leftMargin, bottomMargin], [leftMargin, height - bottomMargin]]);
        var stepSize = (height - bottomMargin) / steps;
        var plotStepSize = (maxY - minY) / steps;
        for (var i = 1; i < steps; i++) {
            lineSize([[leftMargin, stepSize * i + bottomMargin],
                  [leftMargin + 20, stepSize * i + bottomMargin]])
            // Decimal points should be configured with dependency on max - min interval length
            var number = (minY + plotStepSize * i);
            var text = ''
            if (number > 0)
                text = qsTr("Л ") + number.toFixed(1).toString()
            else if (number < 0)
                text = qsTr("П ") + Math.abs(number).toFixed(1).toString()
            context.fillText(text, leftMargin + 25, yScaleSize(stepSize * i + bottomMargin - 10));
        }
    }
}
