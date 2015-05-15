var ZTransferXObject;

Initialize_ZT = function(ObjectID, ClassID, Width, Height, CodeBase, PluginType) {
    if(navigator.appName == "Microsoft Internet Explorer" || (navigator.userAgent.indexOf("Trident") > -1)) { //IE
        if(navigator.appVersion.indexOf("MSIE 6") > -1) {
            ZTransferXObject = document.createElement('<object ID = "' + ObjectID + '" width = "' + Width + '" height = "' + Height + '" classid = "' + ClassID + '" codebase = "' + CodeBase + '"></object>');
        } else {
            strZTransferXObject = '<object ID = "' + ObjectID + '" width = "' + Width + '" height = "' + Height + '" classid = "' + ClassID + '" codebase = "' + CodeBase + '">';
        }
    } else if(navigator.appName == "Netscape" || navigator.appName == "Opera") { //Safari, Firefox, Chrome, Opera
        ZTransferXObject = document.createElement('object');
        ZTransferXObject.setAttribute("id", ObjectID);
        ZTransferXObject.setAttribute("width", Width);
        ZTransferXObject.setAttribute("height", Height);
        ZTransferXObject.setAttribute("type", PluginType);
    }
}

function Insert_ZT_Param(ParameterName, ParameterValue) {
    if(navigator.appName == "Microsoft Internet Explorer" || (navigator.userAgent.indexOf("Trident") > -1)) { //IE
        if(navigator.appVersion.indexOf("MSIE 6") > -1) {
            var ZTransferXParam = document.createElement('<param name = "' + ParameterName + '" value = "' + ParameterValue + '">');
            ZTransferXObject.appendChild(ZTransferXParam);
        } else {
            strZTransferXObject += '<param name = "' + ParameterName + '" value = "' + ParameterValue + '"/>';
        }
    } else if(navigator.appName == "Netscape" || navigator.appName == "Opera") { //Safari, Firefox, Chrome, Opera
        var ZTransferXParam = document.createElement('param');
        ZTransferXParam.setAttribute("name", ParameterName);
        ZTransferXParam.setAttribute("value", ParameterValue);
        ZTransferXObject.appendChild(ZTransferXParam);
    }
}

function Start_ZT() {
    if((navigator.appName == "Microsoft Internet Explorer"  || (navigator.userAgent.indexOf("Trident") > -1))&& navigator.appVersion.indexOf("MSIE 6") == -1) { //IE
        strZTransferXObject += '</object>';
        InstallOZViewer.innerHTML = strZTransferXObject;
        return;
    } else if(navigator.appName == "Netscape" || navigator.appName == "Opera") { //Safari, Firefox, Chrome, Opera
        ZTransferXParam = document.createElement('a');
        ZTransferXParam.setAttribute("href", "http://127.0.0.1:8080/ozviewer/OZViewerPlugIn.exe");
        ZTransferXParam.setAttribute("style", "text-decoration: none;");
        var ZTransferXParamImg = document.createElement('img');
        ZTransferXParamImg.setAttribute("src", "http://127.0.0.1:8080/ozviewer/OZViewerPlugIn.jpg");
        ZTransferXParamImg.setAttribute("alt", "Install OZ plug-in");
        ZTransferXParamImg.setAttribute("style", "border-style: none");
        ZTransferXParam.appendChild(ZTransferXParamImg);
        ZTransferXObject.appendChild(ZTransferXParam);
    }
    InstallOZViewer.appendChild(ZTransferXObject);
}
