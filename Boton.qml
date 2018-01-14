import QtQuick 2.0

Item {
    id: raiz
    property int w: 10
    property int h: 10
    property alias t: txt.text
    property alias c: txt.color
    width: w
    height: h
    signal clicking
    Rectangle{
        id: rect
        width:  raiz.width
        height: width
        anchors.centerIn: raiz
        radius: raiz.h*0.05
        border.width: 1
        ParallelAnimation{
                id: an
                running: false
                NumberAnimation {
                    target: rect
                    property: "width"
                    from: rect.width*0.5
                    to: raiz.width
                    duration: 200
                    easing.type: Easing.InOutQuad
                }
        }
        Text {
            id: txt
            font.pixelSize: parent.height*0.8
            anchors.centerIn: parent
            font.family: "FontAwesome"
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
                an.start()
                clicking()
            }
        }

    }

}
