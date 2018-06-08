/*
Jaunary 2018
This file is created by nextsigner
This code is used for the unik qml engine system too created by nextsigner.
Please read the Readme.md from https://github.com/nextsigner/unik-qml-blogger.git
Contact
    email: nextsigner@gmail.com
    whatsapps: +541138024370
*/
import QtQuick 2.7
import QtQuick.Controls 2.0
import Qt.labs.settings 1.0
import QtWebEngine 1.4
import LogView 1.0
ApplicationWindow {
    id:app
    visible: true
    width: 1400
    height: 600
    visibility:"Maximized"
    title: 'unik-qml-blogger'
    color: '#333'
    property int fs: app.width*0.02
    property color c1: "#1fbc05"
    property color c2: "#4fec35"
    property color c3: "white"
    property color c4: "black"
    property color c5: "#333333"
    property string tool: ""
    property string urlEditor: 'http://unikode.org/search?q=qml+unik'
    property var wvResult
    onToolChanged: {
        if(app.tool === "quickcode"){
            xQuickCode.state = "show"
        }else{
            xQuickCode.state = "hide"
        }
    }
    Settings{
        id: appSettings
        category: 'conf-unik-qml-blogger'
        property string bgColorEditor: 'black'
        property string txtColorEditor: 'white'
        property int pyLineRH1
        property bool logVisible: false
        property string currentFolder
        property string uRS: ''
        property int lvfs
    }
    FontLoader {name: "FontAwesome";source: "qrc:/fontawesome-webfont.ttf";}
    Row{
        anchors.fill: parent
        Rectangle{
            id: xTools
            width: app.width*0.02
            height: app.height
            color: "#000"
            //border.width: 1
            //border.color: "white"
            Column{
                id: colTools
                width: parent.width*0.9
                spacing:  width*0.5
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter


                Boton{
                    id: btnRun
                    w:parent.width*0.9
                    anchors.horizontalCenter: parent.horizontalCenter
                    h: w
                    t: "\uf04b"
                    b: app.c5
                    c: app.c1
                    visible: (''+wv.url).indexOf('blogger.com') !== -1

                    onClicking: {
                        if(app.urlEditor==='https://www.blogger.com/'){
                            compilar()
                        }else{
                            wv.runJavaScript('chooseExport(\'txt\', \'Download text file\'); exportDoc();', function(result) {
                                console.log(result);

                            })
                        }
                    }
                    Timer{
                        running: true
                        repeat: true
                        interval: 500
                        onTriggered: {
                            //btnRun.opacity = (''+wv.url).indexOf('blogger.com') !== -1 ? 1.0 : 0.5
                        }

                    }


                }
                Boton{
                    id:btnhome
                    w:parent.width*0.9
                    anchors.horizontalCenter: parent.horizontalCenter
                    h: w
                    t: '\uf015'
                    b: (''+wv.url).indexOf('https://blogger.com')==0?app.c2:app.c5
                    c: (''+wv.url).indexOf('https://blogger.com')===0?app.c5:app.c1
                    onClicking: {
                        wv.url = 'https://blogger.com'

                    }
                }
                Boton{
                    id:btnSearch2
                    w:parent.width*0.9
                    anchors.horizontalCenter: parent.horizontalCenter
                    h: w
                    t: "\uf002"
                    b: app.tool === "search"?app.c2:app.c5
                    c: app.tool === "search"?app.c5:app.c1
                    onClicking: {
                        app.tool = app.tool === "search" ? "" : "search"
                    }
                }
                Boton{
                    id:btnBlog
                    property string url
                    w:parent.width*0.9
                    anchors.horizontalCenter: parent.horizontalCenter
                    h: w
                    t: '\uf1ea'
                    b: (''+wv.url).indexOf(btnBlog.url.toString())!==-1?app.c2:app.c5
                    c: (''+wv.url).indexOf(btnBlog.url.toString())!==-1?app.c5:app.c1
                    onClicking: {
                        wv.url = btnBlog.url
                    }
                }
                Boton{
                    id:btnBgColorEditor
                    objectName: 'btnBGCTE'
                    w:parent.width*0.9
                    anchors.horizontalCenter: parent.horizontalCenter
                    h: w
                    t: 'E'
                    b: appSettings.bgColorEditor
                    c: appSettings.txtColorEditor
                    onClicking: {
                        colorPicker.obj = btnBgColorEditor
                        //colorPicker.colorSeted = appSettings.bgColorEditor
                        colorPicker.visible = true
                    }
                }
                Boton{
                    id:btnTextColorEditor
                    objectName: 'btnTXTCTE'
                    w:parent.width*0.9
                    anchors.horizontalCenter: parent.horizontalCenter
                    h: w
                    t: 'T'
                    b: appSettings.bgColorEditor
                    c: appSettings.txtColorEditor
                    onClicking: {
                        colorPicker.obj = btnTextColorEditor
                        //colorPicker.colorSeted = appSettings.txtColorEditor
                        colorPicker.visible = true
                    }
                }
                Boton{
                    w:parent.width*0.9
                    anchors.horizontalCenter: parent.horizontalCenter
                    h: w
                    t: "\uf188"
                    b: appSettings.logVisible?app.c2:app.c5
                    c: appSettings.logVisible?app.c5:app.c1
                    onClicking: {
                        //appSettings.logVisible =  !appSettings.logVisible
                        appSettings.logVisible = !appSettings.logVisible
                        unik.setProperty("logViewVisible", appSettings.logVisible)
                    }
                }
                Boton{
                    w:parent.width*0.9
                    anchors.horizontalCenter: parent.horizontalCenter
                    h: w
                    t: "\uf121"
                    b: app.tool === "quickcode"?app.c2:app.c5
                    c: app.tool === "quickcode"?app.c5:app.c1
                    onClicking: {
                        app.tool = app.tool === "quickcode" ? "" : "quickcode"
                    }
                }
                Boton{
                    id: btnCurrentFolder
                    w:parent.width*0.9
                    anchors.horizontalCenter: parent.horizontalCenter
                    h: w
                    t: "\uf07b"
                    b: app.tool === "currentFolder"?app.c2:app.c5
                    c: app.tool === "currentFolder"?app.c5:app.c1
                    onClicking: {
                        app.tool = app.tool === "currentFolder" ? "" : "currentFolder"
                    }
                }
                Boton{
                    w:parent.width*0.9
                    anchors.horizontalCenter: parent.horizontalCenter
                    h: w
                    t: "\uf128"
                    b: (''+wv.url).indexOf('unik-qml-blogger-help')!==-1?app.c2:app.c5
                    c: (''+wv.url).indexOf('unik-qml-blogger-help')!==-1?app.c5:app.c1
                    onClicking: {
                        wv.url = 'https://unikode.org/2018/01/unik-qml-blogger-help.html'
                    }
                }
                Boton{//Update
                    id:btnUpdate
                    w:parent.width
                    h: w
                    t: '\uf021'
                    b: up ? 'red':app.c5
                    c: up ? 'white':app.c1
                    property bool up: false
                    onClicking: {
                        if(!up){
                            unik.restartApp("-git=https://github.com/nextsigner/unik-qml-blogger.git")
                        }else{
                            var args = '-folder '+unik.getPath(3)+'/unik/unik-qml-blogger'
                            args += ' -dim='+app.width+'x'+app.height+' -pos='+app.x+'x'+app.y
                            unik.restartApp(args)
                        }
                    }
                }
                Boton{//Quit
                    w:parent.width*0.9
                    anchors.horizontalCenter: parent.horizontalCenter
                    h: w
                    t: "\uf011"
                    b: app.c5
                    c: app.c1
                    onClicking:Qt.quit()
                    onPChanged: app.close()
                }
            }
        }

        Rectangle{
            id:container
            width: parent.width-xTools.width
            height: parent.height
            color: '#333'
            WebEngineView{
                id: wv
                width: parent.width
                height: parent.height
                url: app.urlEditor
                profile: defaultProfile
                focus: true
                property string linkContextRequested
                property QtObject defaultProfile: WebEngineProfile {
                    storageName: "Default"
                    onDownloadRequested: {
                        download.path=unik.getPath(2)+'/main.qml'
                        download.accept();
                        console.log(download.path)
                    }
                    onDownloadFinished: {
                        var d=''+unik.getFile(unik.getPath(2)+'/main.qml', true)
                        console.log('--------->'+d)
                        var m0=d.split('\n')
                        var l1 = ''+m0[0]
                        var fileName = l1.substring(2,l1.length)
                        console.log('Saving: '+fileName)
                        var m1 = fileName.split('/')

                        var folder = fileName.replace('/'+m1[m1.length-1], '')
                        var l2 = ''+m0[1]
                        //var cl = l2.substring(2,l2.length)
                        unik.mkdir(folder)
                        unik.setFile(fileName,d,true)
                        var cl = '-folder '+folder

                        var appPath
                        if(Qt.platform.os==='windows'){
                            appPath = '"'+unik.getPath(1)+'/'+unik.getPath(0)+'"'
                            unik.setFile('H:/cl.txt',cl,true)
                        }
                        if(Qt.platform.os==='linux'){
                            //appPath = '"'+unik.getPath(1)+'/'+unik.getPath(0)+'"'
                            //appPath = '"'+unik.getPath(1)+'/'+unik.getPath(0)+'"'
                            appPath = '"'+appExec+'"'
                        }
                        //unik.setFile('H:/cl.txt', appPath+' '+cl,true)
                        //unik.setFile('/home/nextsigner/Escritorio/fn.txt', fileName,true)
                        //unik.setFile('/home/nextsigner/Escritorio/cl.txt', appPath+' '+cl,true)
                        console.log('Running: '+appPath+' '+cl)
                        unik.run(appPath+' '+cl, true)
                    }
                }
                settings.javascriptCanOpenWindows: true
                settings.allowRunningInsecureContent: false
                //settings.hyperlinkAuditingEnabled:  true
                settings.javascriptCanAccessClipboard: true
                settings.localStorageEnabled: true
                settings.javascriptEnabled: true
                onNewViewRequested: {
                    request.openIn(wv)
                    request.accepted = true;
                }

                onLoadProgressChanged: {
                    if(loadProgress!==100){
                        wv.opacity = 0.0
                    }else{
                        wv.opacity = 1.0
                    }
                }
                onContextMenuRequested: function(request) {
                    //console.log('---------->'+request.linkUrl)
                    var lurl = ''+request.linkUrl
                    if(lurl!==''){
                        wv.linkContextRequested = lurl
                        menuLink.visible = true
                    }
                    request.accepted = true;
                    contextMenu.x = request.x;
                    contextMenu.y = request.y;
                    contextMenu.visible = true
                }
                property int previsibility: 1
                onFullScreenRequested: {
                    if(request.toggleOn){
                        wv.previsibility=app.visibility
                        app.visibility = "FullScreen"
                        wv.state = "FullScreen"
                        xTools.width=0
                    }else{
                        app.visibility = wv.previsibility
                        wv.state = ""
                        xTools.width=app.width*0.02
                    }
                    request.accept()
                }
                onUrlChanged: {
                    console.log("Url: "+url)
                }

                Shortcut {
                    sequence: "Ctrl+Tab"
                    onActivated: {
                        clipboard.setText("     ")
                        wv.focus = true
                        wv.triggerWebAction(WebEngineView.Paste)
                    }
                }
                Shortcut {
                    sequence: "Ctrl+R"
                    onActivated: {
                        compilar()
                    }
                }



            }

            Menu {
                id: contextMenu
                onVisibleChanged: {
                    if(!visible){
                        menuLink.visible = false
                        ccs.visible = false
                    }
                }
                MenuItem { id: menuLink; text: "Copiar Url"
                    visible: false
                    enabled: visible
                    height: visible ? undefined : 0
                    onTriggered:{
                        clipboard.setText(wv.linkContextRequested)
                    }
                }
                MenuItem { id: ccs; text: "Run Mode 1"
                    enabled: visible
                    height: visible ? undefined : 0
                    visible: false
                    onTriggered:{
                        //wv.triggerWebAction(WebEngineView.Copy)
                        var js='\'\'+window.getSelection()'
                        wv.runJavaScript(js, function(result) {
                            console.log(result)
                            compilarCS(result, 1)
                        });
                    }
                }
                MenuItem { id: ccs2; text: "Run Mode 2"
                    enabled: visible
                    height: visible ? undefined : 0
                    visible: false
                    onTriggered:{
                        //wv.triggerWebAction(WebEngineView.Copy)
                        var js='\'\'+window.getSelection()'
                        wv.runJavaScript(js, function(result) {
                            console.log(result)
                            compilarCS(result, 2)
                        });
                    }
                }
                MenuItem { id: ccs3; text: "Run Mode 3"
                    enabled: visible
                    height: visible ? undefined : 0
                    visible: false
                    onTriggered:{
                        //wv.triggerWebAction(WebEngineView.Copy)
                        var js='\'\'+window.getSelection()'
                        wv.runJavaScript(js, function(result) {
                            console.log(result)
                            compilarCS(result, 3)
                        });
                    }
                }
                MenuItem { text: "Guardar Còdigo"
                    onTriggered:{
                        wv.triggerWebAction(WebEngineView.Copy)
                        guardarCodigo.visible = true
                    }
                }
                MenuItem { text: "Atras"
                    onTriggered:{
                        wv.goBack()
                    }
                }
                MenuItem { text: "Adelante"
                    onTriggered:{
                        wv.goForward()
                    }
                }
                MenuItem { text: "Cortar"
                    onTriggered:{
                        wv.triggerWebAction(WebEngineView.Cut)
                    }
                }
                MenuItem { text: "Copiar"
                    onTriggered:{
                        wv.triggerWebAction(WebEngineView.Copy)
                        var js='\'\'+window.getSelection()'
                        wv.runJavaScript(js, function(result) {
                            console.log(result);
                        });

                        //console.log(wv.ViewSource.toString())
                    }
                }
                MenuItem {
                    id: menuPegar
                    text: "Pegar"
                    onTriggered:{
                        wv.triggerWebAction(WebEngineView.Paste)
                    }
                }
            }
            LogView{
                id:logView
                height: appSettings.pyLineRH1
                width: parent.width
                topHandlerHeight:4
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                visible: appSettings.logVisible
                onHeightChanged: appSettings.pyLineRH1=height
            }
        }

    }

    Rectangle{
        id: xCurrentFolder
        width: tiCurrentFolder.width*1.05
        height: xTools.width
        color: "#333"
        border.color: "white"
        radius: height*0.25
        y: btnCurrentFolder.y+(colTools.y)
        TextInput{
            id: tiCurrentFolder
            width: contentWidth<300 ? 300 : contentWidth
            height: parent.height*0.9
            anchors.centerIn: parent
            font.pixelSize: parent.height*0.8
            color: 'white'
            onTextChanged: {
                if(text!==''&&text!==appSettings.currentFolder){
                    appSettings.currentFolder = text
                }
            }
        }
        state: app.tool === "currentFolder" ? "show" : "hide"
        states:  [
            State {
                name: "hide"
                PropertyChanges {
                    target: xCurrentFolder
                    x: 0-xCurrentFolder.width
                }
            },
            State {
                name: "show"
                PropertyChanges {
                    target: xCurrentFolder
                    x: 0+xTools.width
                }
            }

        ]
        transitions: [
            Transition {
                from: "hide"
                to: "show"
                NumberAnimation { properties: "x"; easing.type: Easing.InOutQuad; duration: 250 }
            },
            Transition {
                from: "show"
                to: "hide"
                NumberAnimation { properties: "x"; easing.type: Easing.InOutQuad; duration: 250 }
            }
        ]
    }

    Rectangle{
        id: xTiSearch
        width: tiSearch2.width*1.05
        height: xTools.width
        color: "#333"
        border.color: "white"
        radius: height*0.25
        y: btnSearch2.y+(colTools.y)
        onXChanged: {
            if(x===xTools.width){
                timerTiSearch.start()
            }
        }
        Timer{
            id:timerTiSearch
            running: false
            repeat: false
            interval: 5000
            onTriggered: {
                app.tool = ''
            }
        }
        TextInput{
            id: tiSearch2
            width: contentWidth<300 ? 300 : contentWidth
            height: parent.height*0.9
            anchors.centerIn: parent
            font.pixelSize: parent.height*0.65
            color: text==='search' ? '#ccc' : 'white'
            text: 'search'
            Keys.onReturnPressed: {
                wv.url = 'http://unikode.org/search?q='+text.replace(/ /g,'+')
            }
            onFocusChanged: {
                if(text==='search'){
                    tiSearch.selectAll()
                }
            }
            onTextChanged: {
                timerTiSearch.restart()
            }
        }
        state: app.tool === "search" ? "show" : "hide"
        states:  [
            State {
                name: "hide"
                PropertyChanges {
                    target: xTiSearch
                    x: 0-xTiSearch.width
                }
            },
            State {
                name: "show"
                PropertyChanges {
                    target: xTiSearch
                    x: 0+xTools.width
                }
            }

        ]
        transitions: [
            Transition {
                from: "hide"
                to: "show"
                NumberAnimation { properties: "x"; easing.type: Easing.InOutQuad; duration: 250 }
            },
            Transition {
                from: "show"
                to: "hide"
                NumberAnimation { properties: "x"; easing.type: Easing.InOutQuad; duration: 250 }
            }
        ]
    }

    Rectangle{
        id: xQuickCode
        width: app.width*0.2
        height: app.height
        color: "#333"
        border.width: 1
        border.color: "white"
        state: app.tool === "quickcode" ? "show" : "hide"
        states:  [
            State {
                name: "hide"
                PropertyChanges {
                    target: xQuickCode
                    x: 0-xQuickCode.width
                }
            },
            State {
                name: "show"
                PropertyChanges {
                    target: xQuickCode
                    x: 0
                }
            }

        ]
        transitions: [
            Transition {
                from: "hide"
                to: "show"
                NumberAnimation { properties: "x"; easing.type: Easing.InOutQuad; duration: 500 }
            },
            Transition {
                from: "show"
                to: "hide"
                NumberAnimation { properties: "x"; easing.type: Easing.InOutQuad; duration: 250 }
            }
        ]
        Column{
            anchors.fill: parent
            Text {
                id: txtTitQC
                text: "QuickCode"
                font.pixelSize: app.width*0.01
                anchors.horizontalCenter: parent.horizontalCenter
                color: "white"
            }
            Rectangle{
                id: xSearch
                width: parent.width
                height: txtTitQC.contentHeight*1.4
                color: "#ccc"
                TextInput{
                    id: tiSearch
                    width: parent.width*0.98-btnSearch.w
                    height: parent.height*0.98
                    anchors.centerIn: parent
                    font.pixelSize: parent.height*0.9
                    text: "search"
                    anchors.left: parent.left
                    anchors.leftMargin: parent.height*0.02
                    onFocusChanged: {
                        selectAll()
                    }
                    onTextChanged: {
                        loadQC(text)
                    }
                }
                Boton{
                    id: btnSearch
                    w:parent.height*0.9
                    h: w
                    t: "\uf002"
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    onClicking: {
                        loadQC(tiSearch.text)
                    }
                }
            }
            Rectangle{
                width: parent.width
                height: parent.height-txtTitQC.contentHeight-xSearch.height
                color: "#ccc"
                border.width: 1
                border.color: "white"

                ListView{
                    id:listQC
                    width: parent.width*0.98
                    height: parent.height
                    anchors.centerIn: parent
                    clip: true
                    model: lmQC
                    delegate: delQC
                    spacing: 10
                    ListModel{
                        id: lmQC
                        function add(i, n, c, rc){
                            return {
                                cid: i,
                                nom: n,
                                code: c,
                                rcode: rc
                            }
                        }
                    }
                    Component{
                        id: delQC
                        Rectangle{
                            width: parent.width
                            height: labelNomQC.height+labelCodeQC.height
                            property string realCode: rcode
                            Text{
                                id: labelNomQC
                                text: nom+'\n'
                                font.pixelSize: parent.width*0.05
                                wrapMode: Text.WordWrap
                            }
                            Text{
                                id: labelCodeQC
                                text: code
                                font.pixelSize: parent.width*0.025
                                width: parent.width*0.98
                                anchors.horizontalCenter: parent.horizontalCenter
                                //textFormat: Text.RichText
                                wrapMode: Text.WordWrap
                                anchors.top: labelNomQC.bottom
                            }
                            MouseArea{
                                anchors.fill: parent
                                onClicked: {
                                    clipboard.setText(rcode)
                                    wv.triggerWebAction(WebEngineView.Paste)
                                }
                            }
                            Boton{
                                w:parent.width*0.04
                                h: w
                                t: "X"
                                anchors.right: parent.right
                                onClicking: {
                                    var sql = 'DELETE FROM quickcodes WHERE id='+cid
                                    unik.sqlQuery(sql, true)
                                    loadQC("")
                                }
                            }
                        }

                    }

                }

            }
        }
        Boton{
            w: txtTitQC.height
            h: w
            t:"X"
            anchors.right: parent.right
            onClicking: app.tool = ""
        }
    }

    ColorPicker{
        id:colorPicker;
        visible: false;
        property var obj
        onCurrentColorChanged: {
            if(obj.objectName==='btnBGCTE'){appSettings.bgColorEditor=currentColor}
            if(obj.objectName==='btnTXTCTE'){appSettings.txtColorEditor=currentColor}
        }
        onRejected: {
            if(obj.objectName==='btnBGCTE'){appSettings.bgColorEditor=prevcolor}
            if(obj.objectName==='btnTXTCTE'){appSettings.txtColorEditor=prevcolor}
        }
        onAccepted: {
            if(obj.objectName==='btnBGCTE'){appSettings.bgColorEditor=color}
            if(obj.objectName==='btnTXTCTE'){appSettings.txtColorEditor=color}
        }
    }

    GuardarCodigo{
        id: guardarCodigo
        visible:false
        onGuardandoComo: {
            var txt = ''+clipboard.getText();
            var  sql = 'INSERT INTO quickcodes(id, nom, qc)VALUES(NULL, \''+n+'\', \''+txt+'\')'
            unik.sqlQuery(sql, true)
            loadQC("")
            console.log(txt)
        }
    }
    Timer{
        id:tu
        running: true
        repeat: true
        interval: 1000*60*60
        onTriggered: {
            unik.log('Checking unik-qml-blogger updates from https://github.com/nextsigner/unik-qml-blogger...')
            unik.setDebugLog(false)
            var d = new Date(Date.now())
            var ur0 = ''+unik.getHttpFile('https://github.com/nextsigner/unik-qml-blogger/commits/master?r='+d.getTime())
            var m0=ur0.split("commit-title")
            var m1=(''+m0[1]).split('</p>')
            var m2=(''+m1[0]).split('\">')
            var m3=(''+m2[1]).split('\"')
            var ur = ''+m3[1]
            //unik.log("Update key control: "+ur)
            if(appSettings.uRS!==''&&appSettings.uRS!==ur){
                appSettings.uRS = ur
                var fd=unik.getPath(3)+'/unik'
                unik.setDebugLog(true)
                var downloaded = unik.downloadGit('https://github.com/nextsigner/unik-qml-blogger', fd)
                tu.stop()
                if(downloaded){
                    btnUpdate.up=true
                }else{
                    tu.start()
                }
            }else{
                appSettings.uRS=ur
            }
            unik.setDebugLog(true)
        }
    }
    Timer{
        id: ts
        running: true
        repeat: true
        interval: 250
        onTriggered: {
            if((''+wv.url).indexOf('#editor') !== -1&&(''+wv.url).indexOf('blogspot.com') !== -1){
                setColorTextEditor()
            }
            if((''+wv.url).indexOf('blogger.g') !== -1){

                setColorDivs()
                setColorSpans()
                setColorLinks()
                setStyle()
                getUrlBlog()
            }
            setMenuCS()
        }

    }
    Component.onCompleted:  {
        unik.debugLog = true
        if(appSettings.pyLineRH1===0||appSettings.pyLineRH1===undefined){
            appSettings.pyLineRH1 = 100
        }
        if(appSettings.currentFolder===undefined||appSettings.currentFolder===''){
            var cf = ''+unikDocs+'/unik-qml-blogger'
            tiCurrentFolder.text = cf
        }else{
            tiCurrentFolder.text = appSettings.currentFolder
        }
        var sf = ((''+appsDir).replace('file:///', ''))+'/'+app.title+'.sqlite'
        var initSqlite = unik.sqliteInit(sf, true)
        var sql

        //Tabla quickcodes
        sql = 'CREATE TABLE IF NOT EXISTS quickcodes(
                       id INTEGER PRIMARY KEY AUTOINCREMENT,
                       nom TEXT,
                       qc NUMERIC
                        )'
        unik.sqlQuery(sql, true)
        loadQC("")

        //Creating Desktop LNK
        var exec
        var ad = ''
        if(Qt.platform.os==='linux'){
            ad = ''+unik.getPath(6)+'/unik-qml-blogger.desktop'
            if(!unik.fileExist(ad)){
                exec = ''+unik.getPath(1)+'/unik -folder '+sourcePath
                console.log('Unik Qml Blogger Exec Path: '+exec)
                unik.createLink(exec, ad, 'unik-qml-blogger', 'This is a desktop file created by main.qml blogger!')
            }
        }
        if(Qt.platform.os==='windows'){
            ad = ''+unik.getPath(6)+'/unik-qml-blogger.lnk'
            if(!unik.fileExist(ad)){
                exec = ''+unik.getPath(1)+'/unik.exe -folder '+sourcePath
                console.log('Windows desktop shortcut not configured: '+exec)
                //console.log('Unik Qml Blogger Exec Path: '+exec)
                //unik.createLink(exec, ad, 'unik-qml-blogger', 'This is a desktop file created by main.qml blogger!')
            }
        }
        console.log('Unik Qml Blogger LNK file location: '+ad)

    }
    function setColorTextEditor(){
        wv.runJavaScript('document.getElementById("postingComposeBox").contentDocument.getElementsByTagName(\'p\').length', function(result) {

            var js=''
            for(var i=0;i<result;i++){
                js += 'document.getElementById("postingComposeBox").contentDocument.getElementsByTagName(\'p\')['+i+'].style.color="'+txtcEditor+'";'
            }
            wv.runJavaScript(js, function(result2) {
                //console.log("Result Styles Paragraph: "+result2)

            })

        })
    }
    function setColorDivs(){
        wv.runJavaScript('document.getElementsByTagName(\'div\').length', function(result) {
            var js='function setColorDiv(d){if(d.className!==\'goog-palette-colorswatch\'){d.style.backgroundColor="#333333";d.style.color="#fff";}};'
            for(var i=0;i<result;i++){
                js += 'setColorDiv(document.getElementsByTagName(\'div\')['+i+']);'
            }
            wv.runJavaScript(js, function(result2) {
                //console.log("Result Styles Divs: "+result2)
            })

        })
    }
    function setColorSpans(){
        wv.runJavaScript('document.getElementsByTagName(\'span\').length', function(result) {
            //console.log("Cantindad de lineas: "+result)
            var js='function setColorDiv(d){if(d.className!==\'blogg-menu-button-content\'&&d.className!==\'OAVLIQC-A-a\'&&d.className!==\'blogg-disclosureindicator\'){d.style.backgroundColor="#333333";d.style.color="#fff";}};'
            for(var i=0;i<result;i++){
                js += 'setColorDiv(document.getElementsByTagName(\'span\')['+i+']);'
            }
            wv.runJavaScript(js, function(result2) {
                //console.log("Result Styles Divs: "+result2)
            })

        })
    }
    function setColorLinks(){
        wv.runJavaScript('document.getElementsByTagName(\'a\').length', function(result) {
            //console.log("Cantindad de lineas: "+result)
            var js='function setColorDiv(d){if(d.className!==\'blogg-menu-button-content\'&&d.className!==\'OAVLIQC-A-a\'){d.style.backgroundColor="#333333";d.style.color="#fff";}};'
            for(var i=0;i<result;i++){
                js += 'setColorDiv(document.getElementsByTagName(\'a\')['+i+']);'
            }
            wv.runJavaScript(js, function(result2) {
                //console.log("Result Styles Divs: "+result2)
            })

        })
    }
    function getUrlBlog(){
        wv.runJavaScript('document.getElementsByClassName(\'OAVLIQC-i-F\')[0].href', function(result) {
            btnBlog.url = result
        })
    }
    function setStyle(){
        var bgColorTextAreaEditor = appSettings.bgColorEditor
        var txtColorTextAreaEditor = appSettings.txtColorEditor
        var bgColor = '#000000'
        var fsColor = '#ffffff'
        var js = 'document.getElementsByTagName(\'html\')[0].style.backgroundColor="'+bgColor+'";'
        js += 'document.getElementsByTagName(\'html\')[0].style.color="'+fsColor+'";'
        js += 'document.getElementsByTagName(\'body\')[0].style.backgroundColor="'+bgColor+'";'
        if((''+wv.url).indexOf('#editor') !== -1){
            js += 'document.getElementById("postingComposeBox").contentDocument.getElementsByTagName(\'body\')[0].style.backgroundColor="'+bgColorTextAreaEditor+'";'
            js += 'document.getElementById("postingComposeBox").contentDocument.getElementsByTagName(\'body\')[0].style.color="'+txtColorTextAreaEditor+'";'
        }
        wv.runJavaScript(js, function(result) {
            //console.log("Result Style: "+result)

        })

    }
    function setMenuCS(){
        if((''+wv.url).indexOf('blogspot.com') !== -1){
            var js='\'\'+window.getSelection()'
            wv.runJavaScript(js, function(result) {
                var s = ''+result
                if(s.indexOf('import') !== -1 && s.indexOf('ApplicationWindow') !== -1){
                    ccs.visible = s!==''
                }
                ccs2.visible = s!==''
                ccs3.visible = s!==''
            });
        }
    }
    function compilarCS(res, modo){
        console.log('Compilando código seleccionado...')
        var js = ''
        var d=''+res;
        console.log('Còdigo: '+d)

        var r = new Date(Date.now())
        var fileName
        var m1
        var folder
        var cl
        if(modo===1){
            fileName = ''+unik.getPath(2)+'/'+r.getTime()+'/main.qml'
            console.log('Saving: '+fileName)
            m1 = fileName.split('/')
            folder = fileName.replace('/'+m1[m1.length-1], '')
            unik.mkdir(folder)
            unik.setFile(fileName,d,true)
            cl = '-folder '+folder+' -debug'
        }
        if(modo===2){
            var m0=d.split('\n')
            var l1 = ''
            for(var i=0;i<m0.length;i++){
                var l = ''+m0[i]
                if(l.substring(0,2)==='//'){
                    l1 = ''+m0[i]
                    break;
                }
            }
            fileName = tiCurrentFolder.text+'/'+l1.substring(2,l1.length)
            console.log('Saving with filename: ['+fileName+']')
            m1 = fileName.split('/')
            folder = fileName.replace('/'+m1[m1.length-1], '')
            var l2 = ''+m0[1]
            //var cl = l2.substring(2,l2.length)
            unik.mkdir(folder)
            unik.setFile(fileName,d,true)
            if(!unik.fileExist(fileName)){
                console.log('Error! Not found a filename valid location or name: ['+fileName+']')
                console.log('Compilation ir aborted.')
                return
            }
            cl = '-folder '+folder+' -debug'
        }
        if(modo===3){
            fileName = ''+unik.getPath(2)+'/'+r.getTime()+'/main.qml'
            console.log('Saving: '+fileName)
            m1 = fileName.split('/')
            folder = fileName.replace('/'+m1[m1.length-1], '')
            unik.mkdir(folder)
            var fullcode = ''
            fullcode += 'import QtQuick 2.7\n'
            fullcode += 'import QtQuick.Controls 2.0\n'
            fullcode += 'import QtQuick.Layouts 1.3\n'
            fullcode += 'import QtQuick.Window 2.0\n'
            fullcode += 'import QtQuick.Dialogs 1.2\n'
            fullcode += 'import QtQuick.LocalStorage 2.0\n'
            fullcode += 'import QtQuick.Particles 2.0\n'
            fullcode += 'import QtQuick.Window 2.0\n'
            fullcode += 'import QtQuick.XmlListModel 2.0\n'
            fullcode += 'import QtQuick.Controls.Styles 1.4\n'
            fullcode += 'import QtMultimedia 5.9\n'
            fullcode += 'import QtWebView 1.1\n'
            fullcode += 'import uk 1.0\n'
            fullcode += 'ApplicationWindow {\n'
            fullcode +=     'id: app\n'
            fullcode +=     'visible: true\n'
            if( d.indexOf('flags:') !== -1&&d.indexOf('flags=') !== -1&&d.indexOf('flags =') !== -1){
                fullcode +=     'flags: Qt.Window | Qt.FramelessWindowHint\n'
            }
            fullcode += '   property int fs: app.width*0.025\n'
            fullcode += '   UK{id:uk}\n'
            fullcode += '   FontLoader {name: "FontAwesome";source: "qrc:/fontawesome-webfont.ttf";}\n'
            fullcode += '\n'+d+'\n'
            fullcode +='   Item{\n'
            fullcode +='        Component.onCompleted:{\n'
            fullcode +='            if(app.width<=0){app.width = Screen.desktopAvailableWidth;}\n'
            fullcode +='            if(app.height<=0){app.height = Screen.desktopAvailableHeight;}\n'
            fullcode +='        }\n'
            fullcode +='    }\n'
            fullcode +='}\n'
            unik.setFile(fileName,fullcode,true)
            console.log('Full code: '+fullcode)
            cl = '-folder '+folder+' -debug'
        }
        var appPath
        if(Qt.platform.os==='osx'){
            appPath = '"'+unik.getPath(1)+'/'+unik.getPath(0)+'"'
        }
        if(Qt.platform.os==='windows'){
            appPath = '"'+unik.getPath(1)+'/'+unik.getPath(0)+'"'
        }
        if(Qt.platform.os==='linux'){
            appPath = '"'+appExec+'"'
        }
        console.log('Running: '+appPath+' '+cl)
        if(unik.fileExist(fileName)){
            unik.run(appPath+' '+cl, true)
        }else{

        }
    }
    function compilar(){
        console.log('Compilando...')
        var js = ''
        js += 'document.getElementById("postingComposeBox").contentDocument.getElementsByTagName(\'body\')[0].innerHTML;'
        wv.runJavaScript(js, function(result) {
            var tagPre1 = '<'+'/pre>\n'
            var c1 = ''+result+'<br />'
            console.log('QML Trim: '+c1.replace(/<(?:.|\n)*?>/gm, ''))
            var c2 = c1.replace(/<[\/p]>/g, '')//encuentra inicio parrafo
            var c3 = c2.replace(/<\/[p]>/g, '\n')//encuentra fin parrafo
            var c4 = c3.replace(/<\/(pre)>/g, tagPre1)
            var c5 = c4.replace(/<[\/b][\/r] \/>/g, '\n')//encuentra < br / >
            var c6 = c5.replace(/<[\/b][\/r]>/g, '\n')//encuentra < br >
            var c7 = c6.replace(/(&nbsp);/g, ' ')//encuentra espacio html
            var c8 = c7.replace(/<(?:.|\n)*?>/gm, '')
            var c9 = c8.replace("p, li { white-space: pre-wrap; }", '')
            app.wvResult = c9
            console.log('QML: '+app.wvResult)
            var m0=c9.split('\n')
            var l1 = ''
            for(var i=0;i<m0.length;i++){
                var l = ''+m0[i]
                if(l.substring(0,2)==='//'){
                    l1 = ''+m0[i]
                    break;
                }
            }

            var fileName = tiCurrentFolder.text+'/'+l1.substring(2,l1.length)

            console.log('Saving with filename: ['+fileName+']')
            var m1 = fileName.split('/')

            var folder = fileName.replace('/'+m1[m1.length-1], '')
            var l2 = ''+m0[1]
            unik.mkdir(folder)
            unik.setFile(fileName,app.wvResult,true)
            if(!unik.fileExist(fileName)){
                console.log('Error! Not found a filename valid location or name: ['+fileName+']')
                console.log('Compilation ir aborted.')
                return
            }
            var cl = '-folder '+folder+' -debug'
            var appPath=''
            if(Qt.platform.os==='osx'){
                appPath = '"'+unik.getPath(1)+'/'+unik.getPath(0)+'"'
            }
            if(Qt.platform.os==='windows'){
                appPath = '"'+unik.getPath(1)+'/'+unik.getPath(0)+'"'
            }
            if(Qt.platform.os==='linux'){
                appPath = '"'+appExec+'"'
            }
            console.log('Running: '+appPath+' '+cl)
            if(unik.fileExist(fileName)){
                unik.run(appPath+' '+cl)
            }else{

            }
        })
    }
    function loadQC(s){
        lmQC.clear()
        var sql = 'select * from quickcodes where nom like \'%'+s+'%\' or qc like \'%'+s+'%\''
        var rows = unik.getSqlData('quickcodes', sql, 'sqlite')
        for(var i=0; i < rows.length; i++){
            var code = ''+rows[i].col[2]
            var rcode = ''+rows[i].col[2]
            var rcode1 = rcode.replace(/<br>/g, '\n')
            var rcode2 = rcode1.replace(/&#09;/g, '\t')
            var code1 = code.replace(/<br \/>/g, '<br>')
            var code2 = code1.replace(/&#09;/g, '--')
            lmQC.append(lmQC.add(rows[i].col[0], rows[i].col[1], code2, rcode2))
        }
    }
}
