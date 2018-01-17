import QtQuick 2.2
import QtQuick.Dialogs 1.0

ColorDialog {
    id: colorDialog
    title: "Please choose a color"
    property color prevcolor
    //signal newColorSelected(string c)
    onAccepted: {
        console.log("You chose: " + colorDialog.color)
    }
    onRejected: {
        console.log("Canceled")
    }
    /*onColorChanged: {
        newColorSelected(''+colorDialog.color)
    }
    onCurrentColorChanged: {
        newColorSelected(''+colorDialog.currentColor)
    }*/
}
