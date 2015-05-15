var OZViewerObject;
var strOZViewerObject = "";
function Create_Div() {
    var objDiv = document.createElement("div");
    objDiv.id = "RunOZViewer";
    document.body.appendChild(objDiv);
}

function Initialize_OZViewer(ObjectID, ClassID, Width, Height, Type) {
    document.getElementById('RunOZViewer').style['width'] = Width;
    document.getElementById('RunOZViewer').style['height'] = Height;
    if(navigator.appName == "Microsoft Internet Explorer" || (navigator.userAgent.indexOf("Trident") > -1)) { //IE
        if(navigator.appVersion.indexOf("MSIE 6") > -1) {
            OZViewerObject = document.createElement('<object id = "' + ObjectID + '" classid = "' + ClassID + '" style = "width:100%;height:100%"></object>');
        } else {
            strOZViewerObject = '<object id = "' + ObjectID + '" classid = "' + ClassID + '" style = "width:100%;height:100%">';
        }
    } else if(navigator.appName == "Netscape" || navigator.appName == "Opera") { //Safari, Firefox, Chrome, Opera
        OZViewerObject = document.createElement('object');
        OZViewerObject.setAttribute("id", ObjectID);
        OZViewerObject.setAttribute("width", "100%");
        OZViewerObject.setAttribute("height", "100%");
        OZViewerObject.setAttribute("type", Type);
    }
}

function Insert_OZViewer_Param(ParameterName, ParameterValue) {
    if(navigator.appName == "Microsoft Internet Explorer" || (navigator.userAgent.indexOf("Trident") > -1)) { //IE
        if(navigator.appVersion.indexOf("MSIE 6") > -1) {
            var OZViewerParam = document.createElement('<param name = "' + ParameterName + '" value = "' + ParameterValue + '">');
            OZViewerObject.appendChild(OZViewerParam);
        } else {
            strOZViewerObject += '<param name = "' + ParameterName + '" value = "' + ParameterValue + '"/>';
        }
    } else if(navigator.appName == "Netscape" || navigator.appName == "Opera") { //Safari, Firefox, Chrome, Opera
        var OZViewerParam = document.createElement('param');
        OZViewerParam.setAttribute("name", ParameterName);
        OZViewerParam.setAttribute("value", ParameterValue);
        OZViewerObject.appendChild(OZViewerParam);
    }
}

function Start_OZViewer() {
    if((navigator.appName == "Microsoft Internet Explorer"  || (navigator.userAgent.indexOf("Trident") > -1))&& navigator.appVersion.indexOf("MSIE 6") == -1) { //IE
        strOZViewerObject += '</object>';
        document.getElementById('RunOZViewer').innerHTML = strOZViewerObject;
        return;
    }
    document.getElementById('RunOZViewer').appendChild(OZViewerObject);
}
