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
import uk 1.0
ApplicationWindow {
    id:app
    visible: true
    width: 1400
    height: 600
    visibility:"Maximized"
    title: 'unik-qml-blogger'
    property string tool: ""
    property string urlEditor: 'https://www.blogger.com/'
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
        category: 'Configuration'
        property string bgColorEditor: 'black'
        property string txtColorEditor: 'white'
    }
    FontLoader {name: "FontAwesome";source: "qrc:/fontawesome-webfont.ttf";}
    UK{
        id:uk
    }
    Connections {
        target: unik
        onUkStdChanged: {
            console.log('Writer dice: '+unik.ukStd)
       }
    }
    WebEngineView{
        id: wv
        width: app.width-xTools.width
        height: app.height
        anchors.left: xTools.right
        url: app.urlEditor
        profile: defaultProfile
        focus: true
        property QtObject defaultProfile: WebEngineProfile {
            storageName: "Default"
            onDownloadRequested: {
                download.path=uk.getPath(2)+'/main.qml'
                download.accept();
                console.log(download.path)
            }
            onDownloadFinished: {
                var d=''+uk.getFile(uk.getPath(2)+'/main.qml', true)
                console.log('--------->'+d)
                var m0=d.split('\n')
                var l1 = ''+m0[0]
                var fileName = l1.substring(2,l1.length)
                console.log('Saving: '+fileName)
                var m1 = fileName.split('/')

                var folder = fileName.replace('/'+m1[m1.length-1], '')
                var l2 = ''+m0[1]
                //var cl = l2.substring(2,l2.length)
                uk.mkdir(folder)
                uk.setFile(fileName,d,true)
                var cl = '-folder '+folder

                var appPath
                if(Qt.platform.os==='windows'){
                    appPath = '"'+uk.getPath(1)+'/'+uk.getPath(0)+'"'
                    uk.setFile('H:/cl.txt',cl,true)
                }
                if(Qt.platform.os==='linux'){
                    //appPath = '"'+uk.getPath(1)+'/'+uk.getPath(0)+'"'
                    //appPath = '"'+uk.getPath(1)+'/'+uk.getPath(0)+'"'
                    appPath = '"'+appExec+'"'
                }
                //uk.setFile('H:/cl.txt', appPath+' '+cl,true)
                //uk.setFile('/home/nextsigner/Escritorio/fn.txt', fileName,true)
                //uk.setFile('/home/nextsigner/Escritorio/cl.txt', appPath+' '+cl,true)
                console.log('Running: '+appPath+' '+cl)
                uk.run(appPath+' '+cl, true)
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

        onContextMenuRequested: function(request) {
            request.accepted = true;
            contextMenu.x = request.x;
            contextMenu.y = request.y;
            contextMenu.visible = true
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
        MenuItem { id: ccs; text: "Compilar Còdigo Seleccionado"
            onTriggered:{
                //wv.triggerWebAction(WebEngineView.Copy)
                var js='\'\'+window.getSelection()'
                wv.runJavaScript(js, function(result) {
                    console.log('[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]'+result);
                    compilarCS(result)
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

    Rectangle{
        id: xTools
        width: app.width*0.02
        height: app.height
        color: "#000"
        border.width: 1
        border.color: "white"
        Column{
            width: parent.width
            spacing:  width*0.5
            anchors.verticalCenter: parent.verticalCenter


            Boton{
                id: btnRun
                w:parent.width
                h: w
                t: "\uf04b"
                enabled: (''+wv.url).indexOf('blogger.com') !== -1
                opacity: enabled ? 1.0 : 0.5
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
                w:parent.width
                h: w
                t: '\uf015'
                onClicking: {
                    wv.url = 'https://blogger.com'
                }
            }
            Boton{
                id:btnBgColorEditor
                objectName: 'btnBGCTE'
                w:parent.width
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
                w:parent.width
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
                w:parent.width
                h: w
                t: "\uf121"
                onClicking: {
                    app.tool = app.tool === "quickcode" ? "" : "quickcode"
                }
            }
            Boton{
                w:parent.width
                h: w
                t: "\uf011"
                onClicking: {
                    Qt.quit()
                }
            }
        }
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
            uk.sqlQuery(sql, true)
            loadQC("")
            console.log(txt)
        }
    }
    Component.onCompleted:  {
        //bgcEditor = appSettings.bgColorEditor

        var sf = ((''+appsDir).replace('file:///', ''))+'/'+app.title+'.sqlite'
        var initSqlite = uk.sqliteInit(sf, true)
        var sql

        //Tabla quickcodes
        sql = 'CREATE TABLE IF NOT EXISTS quickcodes(
                       id INTEGER PRIMARY KEY AUTOINCREMENT,
                       nom TEXT,
                       qc NUMERIC
                        )'
        uk.sqlQuery(sql, true)
        //sql = 'DELETE FROM quickcodes'
        //uk.sqlQuery(sql, true)
        cleanBDQC()
        loadQC("")
    }
    Timer{
        id: ts
        running: true
        repeat: true
        interval: 250
        onTriggered: {
            setColorTextEditor()
            setColorDivs()
            setColorSpans()
            setStyle()
        }

    }    
    function setColorTextEditor(){
        wv.runJavaScript('document.getElementById("postingComposeBox").contentDocument.getElementsByTagName(\'p\').length', function(result) {
            //console.log("Cantindad de lineas: "+result)
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
            //console.log("Cantindad de lineas: "+result)
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
            var js='function setColorDiv(d){if(d.className!==\'goog-palette-colorswatch\'){d.style.backgroundColor="#333333";d.style.color="#fff";}};'
            for(var i=0;i<result;i++){
                js += 'setColorDiv(document.getElementsByTagName(\'span\')['+i+']);'
            }
            wv.runJavaScript(js, function(result2) {
                //console.log("Result Styles Divs: "+result2)
            })

        })
    }
    function setStyle(){
        var bgColorTextAreaEditor = appSettings.bgColorEditor
        var txtColorTextAreaEditor = appSettings.txtColorEditor
        var bgColor = '#000000'
        var fsColor = '#ffffff'
        var js = 'document.getElementsByTagName(\'html\')[0].style.backgroundColor="'+bgColor+'";'
        js = 'document.getElementsByTagName(\'html\')[0].style.color="'+fsColor+'";'
        js += 'document.getElementsByTagName(\'body\')[0].style.backgroundColor="'+bgColor+'";'
        js += 'document.getElementById("postingComposeBox").contentDocument.getElementsByTagName(\'body\')[0].style.backgroundColor="'+bgColorTextAreaEditor+'";'
        js += 'document.getElementById("postingComposeBox").contentDocument.getElementsByTagName(\'body\')[0].style.color="'+txtColorTextAreaEditor+'";'
        wv.runJavaScript(js, function(result) {
            //console.log("Result Style: "+result)

        })

    }

    function compilarCS(res){
        console.log('Compilando código seleccionado...')
        var js = ''
        var d=''+res;
        console.log('--------->'+d)
        uk.setFile('H:/cdd.txt', d,true)        
        var r = new Date(Date.now())
        var fileName = ''+unik.getPath(2)+'/'+r.getTime()+'/main.qml'
        console.log('Saving: '+fileName)
        var m1 = fileName.split('/')
        var folder = fileName.replace('/'+m1[m1.length-1], '')        
        uk.mkdir(folder)
        uk.setFile(fileName,d,true)
        var cl = '-folder '+folder

        var appPath
        if(Qt.platform.os==='windows'){
            appPath = '"'+uk.getPath(1)+'/'+uk.getPath(0)+'"'
            uk.setFile('H:/cl.txt',cl,true)
        }
        if(Qt.platform.os==='linux'){            
            appPath = '"'+appExec+'"'
        }
        uk.setFile('H:/cl.txt', appPath+' '+cl,true)        
        console.log('Running: '+appPath+' '+cl)
        if(uk.fileExist(fileName)){
            uk.run(appPath+' '+cl, true)
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

            var fileName = l1.substring(2,l1.length)
            console.log('Saving: '+fileName)
            var m1 = fileName.split('/')

            var folder = fileName.replace('/'+m1[m1.length-1], '')
            var l2 = ''+m0[1]
            //var cl = l2.substring(2,l2.length)
            uk.mkdir(folder)
            uk.setFile(fileName,app.wvResult,true)
            var cl = '-folder '+folder

            var appPath
            if(Qt.platform.os==='windows'){
                appPath = '"'+uk.getPath(1)+'/'+uk.getPath(0)+'"'
                uk.setFile('H:/cl.txt',cl,true)
            }
            if(Qt.platform.os==='linux'){                
                appPath = '"'+appExec+'"'
            }           
            console.log('Running: '+appPath+' '+cl)
            if(unik.fileExist(fileName)){
                uk.run(appPath+' '+cl, true)
            }else{

            }
        })
    }   
    function getVG(nom, valxdef){
        var sql = 'select val from varglob where nom=\''+nom+'\''
        var res = uk.getJsonSql('varglob', sql, 'sqlite', true)
        var json = JSON.parse(res)
        if(json['row0']!==undefined){
            return json['row0'].col0
        }else{
            sql = 'INSERT INTO varglob(id, nom, val)VALUES(NULL, \''+nom+'\', \''+valxdef+'\')'
            uk.sqlQuery(sql, true)
        }
        return ''
    }
    function cleanBDQC(){
        var sql = 'select id from quickcodes;'
        var c = ''+uk.getJsonSql('quickcodes', sql, 'sqlite', true)
        var j = JSON.parse(c)
        for(var i=0;i<Object.keys(j).length;i++){
            sql = 'select * from quickcodes where id=\''+j['row'+i].col0+'\';'
            var res = ''+uk.getJsonSql('quickcodes', sql, 'sqlite', true)
            var res2 = res.replace(/\r\n/g, '<br>')
            var res3 = res2.replace(/\t/g, '&#09;')
            var res4 = res3.replace(/\n/g, '<br>')
            var a
            try {
              a = JSON.parse(res4);
              console.log('QC id: '+j['row'+i].col0+' pass...')
            } catch (e) {
                sql = 'delete from quickcodes where id='+j['row'+i].c0+';'
                unik.sqlQuery(sql, true)
                console.log('QC id: '+j['row'+i].col0+' deleted...')
            }

        }
    }
    function loadQC(s){
        lmQC.clear()
        var sql = 'select * from quickcodes where nom like \'%'+s+'%\' or qc like \'%'+s+'%\''
        var res = ''+uk.getJsonSql('quickcodes', sql, 'sqlite', true)
        var res2 = res.replace(/\r\n/g, '<br>')
        var res3 = res2.replace(/\t/g, '&#09;')
        var res4 = res3.replace(/\n/g, '<br>')

        var json = JSON.parse(res4)
        for(var i=0; i < Object.keys(json).length; i++){
            var item = Object.keys(json)[i]
            var code = ''+json['row'+i].col2
            var rcode = ''+json['row'+i].col2
            var rcode1 = rcode.replace(/<br>/g, '\n')
            var rcode2 = rcode1.replace(/&#09;/g, '\t')
            var code1 = code.replace(/<br \/>/g, '<br>')
            var code2 = code1.replace(/&#09;/g, '--')
            lmQC.append(lmQC.add(json['row'+i].col0, json['row'+i].col1, code2, rcode2))
        }
    }
}
