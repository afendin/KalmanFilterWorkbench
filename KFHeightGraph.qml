import QtQuick 2.0
import QtQuick.Controls.Material 2.2
import "d3.min.js" as D3

Canvas {
    id: canvas

    property color lineColor: "red"
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
    property var lineArray: []

    function addPoints(inPointsArray, color) {
        canvas.lineColor = color
        let found = false;

        for (let i = 0; i < lineArray.length; i++) {
            if (lineArray[i].color === color) {
                lineArray[i].line.push(inPointsArray)
                found = true
            }
        }

        if (!found)
            lineArray.push({color: color, line: inPointsArray});



        if (inPointsArray[0] >= maxX)
            maxX = inPointsArray[0] * 1.5

        if (inPointsArray[1] >= maxY)
            maxY = inPointsArray[1] * 1.5
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
        var xScale = d3.scaleLinear()
        .range([leftMargin, width])
        .domain([minX, maxX]);
        var yScale = d3.scaleLinear()
        .range([height - bottomMargin, 0])
        .domain([minY, maxY]);

        var line = lineFunction(xScale, yScale, context);

        context.beginPath();
        context.lineWidth = 1.5;
        context.strokeStyle = Material.foreground;
        context.fillStyle = Material.foreground;

        drawXAxis(context, 10);
        drawYAxis(context, 10);
        context.stroke();

        for (let i = 0; i < lineArray.length; i++) {
            context.beginPath();
            context.lineWidth = 1.5;
            context.strokeStyle = lineArray[i].color
            context.fillStyle = lineArray[i].color
            line(lineArray[i].line);
            context.stroke();
        }


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
        var yScale = d3.scaleLinear().range([0, height]).domain([height, 0]);
        var line = lineFunction(d3.scaleLinear().range([0, width]).domain([0, width]), yScale, context);
        line([[leftMargin, bottomMargin], [width, bottomMargin]]);
        context.font = '10px serif';
        var stepSize = (width - leftMargin) / steps;
        var plotStepSize = (maxX - minX) / steps;
        for (var i = 1; i < steps; i++) {
            line([[stepSize * i + leftMargin, bottomMargin],
                  [stepSize * i + leftMargin, bottomMargin + 20]])
            // Decimal points should be configured with dependency on max - min interval length
            var text = (minX + plotStepSize * i).toFixed(1).toString();
            context.fillText(text, stepSize * i + leftMargin -
                             context.measureText(text).width / 2, yScale(25 + bottomMargin));
        }
    }

    function drawYAxis(context, steps) {
        var yScale = d3.scaleLinear().range([0, height]).domain([height, 0]);
        var line = lineFunction(d3.scaleLinear().range([0, width]).domain([0, width]), yScale, context)
        line([[leftMargin, bottomMargin], [leftMargin, height - bottomMargin]]);
        context.font = '10px serif';
        var stepSize = (height - bottomMargin) / steps;
        var plotStepSize = (maxY - minY) / steps;
        for (var i = 1; i < steps; i++) {
            line([[leftMargin, stepSize * i + bottomMargin],
                  [leftMargin + 20, stepSize * i + bottomMargin]])
            // Decimal points should be configured with dependency on max - min interval length
            var text = (minY + plotStepSize * i).toFixed(1).toString();
            context.fillText(text, leftMargin + 25, yScale(stepSize * i + bottomMargin - 10));
        }
    }
}
