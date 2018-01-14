import QtQuick 2.0

Rectangle {
    id: raiz
    width:  app.width*0.3
    height:  app.height*0.2
    anchors.centerIn: parent
    color: "#333"
    border.width: 1
    border.color: "white"
    radius: raiz.width*0.01
    //z:1000000000000
    onVisibleChanged: {
            if(visible){
                    raiz.focus = true
                    xTi.focus =  true
            }
    }
    signal guardandoComo(string n)
    MouseArea{
        anchors.fill: raiz
    }
    Item{
        width: raiz.width*0.98
        height: raiz.height*0.98
        anchors.centerIn: raiz
        Column{
            anchors.centerIn: raiz
            spacing: raiz.width*0.05
            Text {
                id: l1
                text: "Guardar Còdigo Como:"
                font.pixelSize: raiz.width*0.05
                color: "white"
            }
            Rectangle{
                id: xTi
                width: parent.width
                height: l1.font.pixelSize*1.2
                clip: true
                focus: true
                TextInput {
                    id: ti1
                    text: ""
                     width: parent.width*0.98
                     height: parent.height*0.98
                     anchors.centerIn: parent
                    font.pixelSize: raiz.width*0.05
                    focus: true
                }
            }
            Row{
                anchors.right: parent.right
                spacing: raiz.width*0.05
                Boton{
                    w: raiz.width*0.05
                    h: w
                    t: "X"
                    onClicking: {
                            raiz.visible = false
                    }
                }
                Boton{//fa-check
                    w: raiz.width*0.05
                    h: w
                    t: "\uf00c"
                    onClicking: {
                            guardandoComo(ti1.text)
                            raiz.visible = false
                    }
                }
            }
        }

    }

}
