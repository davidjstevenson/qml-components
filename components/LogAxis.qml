import QtQuick 2.0
import QtCharts 2.3

LogValueAxis {
    property ChartView chartView

    property int default_min
    property int default_max
    property real wheel_zoom_factor: 1.2

    function reset_to_default() {
        min = default_min;
        max = default_max;
    }

    function mouseXToProp(mouse_x) {
        // plot area limits
        let w = max - min

        // scale mouse x to range [0, 1]
        let x = ((mouse_x  - chartView.plotArea.x) / chartView.plotArea.width)
        if (x < 0 || x > 1)
            return

        return x
    }

    function mouseYToProp(mouse_y) {
        // plot area limits
        let h = max - min

        // scale mouse y to range [0, 1]
        let y = ((mouse_y - chartView.plotArea.y) / chartView.plotArea.height)
        y = 1 - y
        if (y < 0 || y > 1)
            return

        return y
    }

    function mapToX(mouse_x) {
        // plot area limits
        let w = max - min

        // scale mouse x to range [0, 1]
        let x = ((mouse_x  - chartView.plotArea.x) / chartView.plotArea.width)
        if (x < 0 || x > 1)
            return

        // scale mouse x to axisX
        let x_min = Math.log10(min)
        let x_max = Math.log10(max)

        x = x * (x_max - x_min) + x_min

        return Math.pow(10, x)
    }

    function mapToY(mouse_y) {
        // plot area limits
        let h = max - min

        // scale mouse y to range [0, 1]
        let y = ((mouse_y - chartView.plotArea.y) / chartView.plotArea.height)
        y = 1 - y
        if (y < 0 || y > 1)
            return

        // scale mouse y to axisY
        let y_min = Math.log10(min)
        let y_max = Math.log10(max)

        y = y * (y_max - y_min) + y_min

        return Math.pow(10, y)
    }

    function zoom_x(invariant_x, direction) {
        let factor = direction > 0 ? wheel_zoom_factor : 1/wheel_zoom_factor;
        let log_max = Math.log10(max);
        let log_min = Math.log10(min);
        let x = mouseXToProp(invariant_x);

        let log_inv = Math.log10(mapToX(invariant_x));

        let n_log_max = Math.log10(max * factor);
        let n_log_min = (log_inv - (n_log_max) * x) / (1 - x);

        let o_max = max;
        let o_min = min;

        min = Math.pow(10, n_log_min)
        max = Math.pow(10, n_log_max)
    }

    function zoom_y(invariant_y, direction) {
        let factor = direction > 0 ? wheel_zoom_factor : 1/wheel_zoom_factor;
        let log_max = Math.log10(max);
        let log_min = Math.log10(min);
        let y = mouseYToProp(invariant_y);

        let log_inv = Math.log10(mapToY(invariant_y));

        let n_log_max = Math.log10(max * factor);
        let n_log_min = (log_inv - (n_log_max) * y) / (1 - y);

        let o_max = max;
        let o_min = min;

        min = Math.pow(10, n_log_min)
        max = Math.pow(10, n_log_max)
    }
}
