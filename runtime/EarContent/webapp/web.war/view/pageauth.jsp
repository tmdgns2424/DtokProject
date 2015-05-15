<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="nexcore.framework.core.Constants"%>
<%@ page import="nexcore.framework.core.code.ICode"%>
<%@ page import="nexcore.framework.core.data.user.IUserInfo"%>
<%@ page import="nexcore.framework.core.util.BaseUtils"%>
<%@ page import="nexcore.framework.online.channel.util.WebUtils"%>
<%
    response.setHeader("Pragma","no-cache");			// HTTP1.0 캐쉬 방지
    response.setDateHeader("Expires",0);				// proxy 서버의 캐쉬 방지
    response.setHeader("Pragma", "no-store");			// HTTP1.1 캐쉬 방지
    if(request.getProtocol().equals("HTTP/1.1"))
    response.setHeader("Cache-Control", "no-cache");    // HTTP1.1 캐쉬 방지

    //IUserInfo userInfo = WebUtils.getSessionUserInfo(request);
    String ip0 = request.getHeader("X-Forwarded-For"); //X-Forwarded-For
    String ip1 = request.getHeader("HTTP_X_FORWARDED_FOR");
    String addr = request.getRemoteAddr();
    String _IP = (null==ip0 || "".equals(ip0) ? (null==ip1 || "".equals(ip1) ? addr : ip1) : ip0);

    if ( ! "R".equals(nexcore.framework.core.util.BaseUtils.getRuntimeMode()) ) {
        System.out.println("<pageauth> RuntimeMode = " + nexcore.framework.core.util.BaseUtils.getRuntimeMode());
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>본인확인(화면) - PS&Marketing</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />

    <script type="text/javascript">
    _LOG_LEVEL = 0;
    _RUNTIME_MODE = "<%=nexcore.framework.core.util.BaseUtils.getRuntimeMode()%>";

    var kmcert_pop = null;
    var _param = null;

    $a.page({
        init : function(id, param) {
            if ( $.PSNMUtils.isEmpty(param) || jQuery.isEmptyObject(param) ) {
                $a.navigate( _MAINPAGE_URL ); //goto main page
                return;
            }
            _param = param;
            $a.page.setEventListener();
            verifyRealname(); //본인인증 팝업창 오픈
        }
        ,
        setEventListener : function() {
            $("#btnCancel").click( cancelVerify );
            //$("#btnTestGo").click( verifySuccess );
            if ( "R"!= _RUNTIME_MODE ) {
                $a.page.setTestEvent();
            }
        }
        ,
        setTestEvent : function() {
            $("#btnTestGo").click( verifySuccess );
            $("#test-btn-area").show();
        }
    });

    function cancelVerify() {
        $.PSNM.alert("본인확인하지 않으면 해당 메뉴를 사용할 수 없습니다!");
        $a.navigate( _MAINPAGE_URL ); //goto main page
    }

    //본인확인
    function verifyRealname() {
        if ( null != kmcert_pop) {
            $(kmcert_pop).close();
            //kmcert_pop = null;
        }
        var param = {};

        kmcert_pop = $a.popup({
            url: "com/popupns/selfChkPopup", //"p",
            data: param,
            title : "본인확인",
            width: "500",
            height: "600",
            modal: false,
            iframe: false,
            windowpopup: true
        });
    }

    //본인확인의 최종결과를 처리하는 함수로 이 함수명은 "com/popupns/selfChkPopup"에서 참조하므로 명칭을 변경하면 안됨.(주의)
    function popupCallback(div, oResult) { //_popup_realname_callback
        _debug("본인확인 콜백 : div = " + div + ", oResult : " + JSON.stringify(oResult));

        //if ( "step2" != div ) {
        //    return false;
        //}

        if ( oResult.RESULT != "Y" ) {
            $.PSNM.alert("본인확인하지 않으면 본 시스템을 사용할 수 없습니다!");
            $a.navigate( _MAINPAGE_URL );
            return;
        }
        if ( oResult.USER_NM != $.PSNM.getSession("USER_NM") ) {
            $.PSNM.alert("본인확인 결과 성명이 다릅니다!");
            $a.navigate( _MAINPAGE_URL );
            return;
        }
        verifySuccess();
    }

    //본인확인이 최종 성공 -> 메인페이지로 이동
    function verifySuccess() {
        if ( null != kmcert_pop) {
            $(kmcert_pop).close();
        }
        if ( $.PSNMUtils.isEmpty(_param) ) {
            $a.navigate( _MAINPAGE_URL ); //goto main page
            return;
        }

        var sUrl = _param["MENU_URL"];

        if ( $.PSNMUtils.isEmpty(sUrl) ) {
            $a.navigate( _MAINPAGE_URL ); //goto main page
            return;
        }

        //현재 메뉴 정보를 세션스토리지 psnm_params._menu 에 저장해둠
        sessionStorage.setItem($.PSNM.SESSION_PARAM_KEY, JSON.stringify({ "_menu": _param}) ); //SESSION_PARAM_KEY : "psnm_params"
        sessionStorage.setItem($.PSNM.SESSION_PAGEAUTH_KEY, "Y");

        if ( sUrl.indexOf(_CTX_PATH + "view/") < 0 ) {
            sUrl = _CTX_PATH + "view/" + sUrl;
        }
        if ( 0>=sUrl.indexOf(".jsp") ) { //if ( !sUrl.endsWith(".jsp") ) {
            sUrl = sUrl + ".jsp";
        }
        $a.navigate(sUrl, {});
    }

    </script>

</head>

<body>

<div id="Wrap"> 
    <div id="header">
        <div class="floatL2">
            <p class="floatL" style="padding: 10px;">
                본인 인증이 필요한 화면입니다.　　　　　　　　　　　　　&nbsp;&nbsp;
            </p>
            <p class="floatL" style="padding: 10px;">
                본인 인증 성공시 또다른 인증 필요 화면도 접근할 수 있습니다.
            </p>
        </div>

        <p class="floatL2">
            <!-- <input id="btnConfirm" type="button" value="" data-type="button" data-theme="af-btn8"> -->
            <input id="btnCancel"  type="button" value="" data-type="button" data-theme="af-btn10">
        </p>
        <p class="floatL2" id="test-btn-area" style="display:none;">
            <a href="#" id="btnTestGo"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/icon_go_next.png"> 바로이동(개발용)</a>
            <!-- <input id="btnTestGo" type="button" value="　　개발TEST 진행　　" data-type="button"> -->
        </p>
    </div>
</div>

</body>
</html>
