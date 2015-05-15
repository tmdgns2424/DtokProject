/*
 * Copyright (c) 2015 PS&M. All rights reserved.
 */

var _WC_INSTALL_URL_IE   = "/IEdefault.htm";
var _WC_INSTALL_URL_NOIE = "/setupM.htm";
var _URL_NOT_ALLOWED_BROWSER = "/not_allowed_browser.jsp";


function gf_get_ie_version() {
    var ua = navigator.userAgent;
    var appnm = navigator.appName;

    var version = -1.0;

    if ( ua.indexOf("MSIE") >= 0 ) {
        var sIdx = ua.indexOf("MSIE") + 5;
        var eIdx = ua.indexOf(";", sIdx);
        var strVer = ua.substring(sIdx, eIdx);
        version = parseFloat(strVer);
    }
    else if ( ua.indexOf("Trident") >= 0 ) {
        var sIdx = ua.indexOf("rv:") + 3;
        var eIdx = ua.indexOf(")", sIdx);
        var strVer = ua.substring(sIdx, eIdx);
        version = parseFloat(strVer);
    }
    //if (navigator.appName == 'Microsoft Internet Explorer') {
    //    var re = new RegExp("MSIE ([0-9]{1,}[\.0-9]{0,})");
    //    if (re.exec(ua) != null) {
    //        version = parseFloat(RegExp.$1);
    //    }
    //}
    return version;
}

function gf_get_browser_name() {
    if ( gf_get_ie_version() > 0 ) {
        return "IE";
    }

    var ua = navigator.userAgent;

    if ( ua.indexOf("Chrome") >= 0 ) {
        return "Chrome";
    }
    else if ( ua.indexOf("Opera") > 0 || ua.indexOf("OPR") > 0 ) {
        return "Opera";
    }
    else if ( ua.indexOf("Firefox") > 0 ) {
        return "Firefox";
    }
    else if ( ua.indexOf("Safari") > 0 ) {
        return "Safari";
    }
    return navigator.appName;
}


function gf_is_mobile() {
    var userAgent = navigator.userAgent.toLowerCase();
    var b = false;
    if (userAgent.match(/iphone|ipod|ios|ipad|android|windows ce|blackberry|symbian|windows phone|webos|opera mini|opera mobi|polaris|iemobile|lgtelecom|nokia|sonyericsson/i) != null || userAgent.match(/lg|samsung/) != null) {
        b = true;
    }
    return b;
}

function gf_is_local() {
    var b = false;
    var lochref = document.location.href;
    if ( lochref.indexOf("127.0.0.1") >=0 || lochref.indexOf("localhost") >=0 ) {
        b = true;
    }
    return b;
}

//다른 프레임에서 이 변수를 확인함으로써 OCX가 초기화 되었나 판단하는 변수. true : 초기화 됨, false : 초기화 안됨
var isInitOCX = false;

//ActiveX가 제대로 설치되었나 안되었나 확인하는 변수. -1:알수 없음, 0:설치안됨, 1:설치됨
var isInstallActiveX = -1;

//본문 load가 끝났음에도 ActiveX 설치여부가 결정되지 않았을때 재 확인하기 위한 재귀호출을 하는데 무한루프에 빠지지 않도록 방어하기 위해 재귀횟수를 기록하는 변수
var nLoop = 0;

//SetProtect 기능을 정의하고자하는 전역변수
var ProtectString = "";


// object onerror 이벤트 발생시 호출되는 함수 (IE가 발생시키는 이벤트) (object 태그 onerror 이벤트에 정의되어 있음.)
// isInstallActiveX 변수 값을 0으로 세팅
function NoneActiveX() {
    isInstallActiveX = 0;
}

// object onreadystatechange 이벤트 발생시 호출되는 함수 (IE가 발생시키는 이벤트) (object 태그 onreadystatechange 이벤트에 정의되어 있음.)
// readystate가 4일때 isInstallActiveX 변수 값을 1로 세팅
function SetActiveXState() {
    if (isInstallActiveX != 0 && Obj.readyState == 4) {
        isInstallActiveX = 1;
    }
}

// body onload 이벤트 발생시 호출되는 함수 (IE가 발생시키는 이벤트) (body 태그 onload 이벤트에 정의되어 있음.)
// body load가 된 후에 ActiveX 설치여부를 확인
function ie_check_webcube() {
    if (1 != isInstallActiveX) { //웹큐브가 설치 안된 경우
        alert('웹보안 프로그램을 참조하지 못하였습니다.\n\n프로그램을 설치한 후 사용할 수 있습니다.');
        document.location = _WC_INSTALL_URL_IE; //설치 페이지로 이동함
        return false;
    }
}

function noie_check_webcube() {
    if ( "Chrome" != gf_get_browser_name() ) {
        document.location = _URL_NOT_ALLOWED_BROWSER; //사용할수 없는 브라우저
        return false;
    }

    var WebcubeMVersion = ""; //(예) webcubem,version=1.0.3.8

    for(var iPos=0; iPos < navigator.mimeTypes.length; iPos++) {
        if (String(navigator.mimeTypes[iPos].type).indexOf("webcubem")>-1) {
            _debug("- navigator.mimeTypes[" + iPos + "].type = [" + navigator.mimeTypes[iPos].type + "]");
            WebcubeMVersion = navigator.mimeTypes[iPos].type;
        }
    }

    if (WebcubeMVersion != "")
    {
        //alert( WebcubeMVersion.substring( 1+WebcubeMVersion.indexOf("=") ) );
        if (WebcubeMVersion.substring(17) >= "1.0.3.8")
        {
            _debug("웹큐브확인! 브라우저 = [" + navigator.userAgent + "] WebcubeMVersion = [" + WebcubeMVersion + "]");
            document.getElementById("webcubem").innerHTML="<embed id='webcubeobj' type=" + WebcubeMVersion + " width='0' height='0'>";
            noie_policy_setup(); //policyStart();
        }
        else
        {
            document.location = _WC_INSTALL_URL_NOIE;
        }
    }
    else {
        _debug("웹큐브확인창입니다. 스킵하세요!\n\n2. 브라우저 = [" + navigator.userAgent + "] WebcubeMVersion = [" + WebcubeMVersion + "]");
        document.location = _WC_INSTALL_URL_NOIE; //document.location.href = "./setupM.htm";
    }
}

function noie_policy_setup() {
	try {
		var arrSetProtect = new Array();

		arrSetProtect[0] = "G";		// CheckSum ("G"값 고정)
		arrSetProtect[1] = "1";		// VmWare, Terminal 기능 차단(0) / 허용(1)
		arrSetProtect[2] = "0";		// Print 기능 차단(0) / 허용(1)
		arrSetProtect[3] = "0";		// SaveAs 기능 차단(0) / 허용(1)
		arrSetProtect[4] = "0";		// Mouse 기능 차단(0) / 허용(1)
		arrSetProtect[5] = "0";		// ScreenCapture 기능 차단(0) / 허용(1)
		arrSetProtect[6] = "0";		// SourceView 기능 차단(0) / 허용(1)
		arrSetProtect[7] = "0";		// Word Editor 기능 차단(0) / 허용(1)
		arrSetProtect[8] = "0";		// Mail로 보내기 기능 차단(0) / 허용(1)
		arrSetProtect[9] = "0";		// ClipBorad(Ctrl+C)기능 차단(0) / 허용 (1)
		arrSetProtect[10] = "0";	// ClipBorad(Ctrl+V) 기능 차단(0) / 허용 (1)

		ProtectString = arrSetProtect.join("");
		webcubeobj.funcSetProtect(ProtectString);
		webcubeobj.funcSetPolicy("#basic#,annceMgmtRgst.jsp:v-/mainSchdMgmtRgst.jsp:v-/issueProdMgmtDtl.jsp:v-/salePlcyRgst.jsp:v-/custPgcvDtl.jsp:cv-/scrbClmDtl.jsp:cv-/headSalePlanHeadRgst.jsp:v-/prdFtftPlanDtl.jsp:v-/agentEduRgst.jsp:v-/agentEduDtl.jsp:v-/agentPrzDtl.jsp:v-/agentDscplDtl.jsp:v-/annceMgmtDtl.jsp:v-/mainSchdMgmtDtl.jsp:v-/headPrdFtftPlanDtl.jsp:v-/incmpDocRcvDtl.jsp:v-/bltnBrdRgst.jsp:v-/bltnBrdDtl.jsp:v-/userScrbRgst.jsp:v-/faqMgmtRgst.jsp:v-");
		//document.location.href = "/index.jsp"; //index.jsp에서는 다시 이동할 필요없음!
	}
	catch (e) {
		document.getElementById("Execute").style.display = "block";
	}
}
