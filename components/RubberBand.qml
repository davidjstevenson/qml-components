import QtQuick 2.14
import QtQuick.Shapes 1.14

Item {
    id: root

    property alias rubberband_opacity: rubberband.opacity
    property alias rubberband_color: rubberband.color
    property alias rubberband_border: rubberband.border
    property alias enabled: mouseArea.enabled

    signal released(var mouse, rect area)

    MouseArea {
        id: mouseArea
        anchors.fill: parent

        onPressed: {
            rubberband.visible = true;
            rubberband.origin = [mouseArea.mouseX, mouseArea.mouseY];
        }

        onReleased: {
            rubberband.visible = false;
            root.released(mouse, Qt.rect(rubberband.x, rubberband.y, rubberband.width, rubberband.height));
        }
    }

    Rectangle {
        id: rubberband
        visible: false

        property var origin: [100, 100]

        x: mouseArea.mouseX > origin[0] ? origin[0] || 0
                                        : mouseArea.mouseX
        y: mouseArea.mouseY > origin[1] ? origin[1] || 0
                                        : mouseArea.mouseY

        width: mouseArea.mouseX > origin[0] ? mouseArea.mouseX - x
                                            : origin[0] - mouseArea.mouseX
        height: mouseArea.mouseY > origin[1] ? mouseArea.mouseY - y
                                             : origin[1] - mouseArea.mouseY

        opacity: 0.25
        border.width: 0
        color: "gray"

        Shape {
            ShapePath {
                id: path
                strokeStyle: ShapePath.DashLine
                strokeColor: "black"
                strokeWidth: 1
                fillColor: "transparent"
                capStyle: ShapePath.SquareCap

                dashPattern: [10, 10]
                property int dashLength: path.dashPattern.reduce(function (acc, value) {return acc + value}, 0)

                NumberAnimation on dashOffset {
                    from: path.dashLength * path.strokeWidth
                    to: 0
                    running: true
                    loops: Animation.Infinite
                    duration: Math.abs(to - from) * 50
                }

                startX: 1
                startY: 1
                PathLine { x: rubberband.width; y: 1 }
                PathLine { x: rubberband.width; y: rubberband.height }
                PathLine { x: 1; y: rubberband.height }
                PathLine { x: 1; y: 1 }
            }
        }
    }
}
