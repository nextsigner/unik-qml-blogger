import QtQuick 2.0

Item {
    id: raiz
    property int w: 10
    property int h: 10
    property alias t: txt.text
    property alias c: txt.color
    property alias b: rect.color
    property bool p: false
    width: w
    height: h
    signal clicking
    signal dobleclicking
    Rectangle{
        id: rect
        width:  raiz.width
        height: width
        anchors.centerIn: raiz
        radius: raiz.h*0.05
        border.width: 1
        border.color: txt.color
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
            id:ma
            property bool pre: false
            anchors.fill: parent
            onClicked: {
                ma.pre=false
                an.start()
                clicking()
            }
            onPressed: {ma.pre=true;tp.start()}
            onReleased: {ma.pre=false;tp.stop()}
            Timer{
                id: tp
                running: false
                repeat: false
                interval: 1500
                onTriggered: {
                        raiz.p = !raiz.p
                }
            }

        }

    }

}
