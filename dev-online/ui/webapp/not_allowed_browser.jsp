<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="org.apache.commons.lang.StringUtils"%>
<%@ page import="nexcore.framework.core.data.user.IUserInfo"%>
<%@ page import="nexcore.framework.online.channel.util.WebUtils"%>
<%
    String _ROOT = "";
    String _RUNTIME_MODE = nexcore.framework.core.util.BaseUtils.getRuntimeMode();

    String ip0 = request.getHeader("X-Forwarded-For"); //X-Forwarded-For
    String ip1 = request.getHeader("HTTP_X_FORWARDED_FOR");
    String addr = request.getRemoteAddr();
    String _IP = (null==ip0 || "".equals(ip0) ? (null==ip1 || "".equals(ip1) ? addr : ip1) : ip0);
    String runmodeName = "";

    if ( StringUtils.equals("L", _RUNTIME_MODE) ) {
        runmodeName = " - (로컬)";
    }
    else if ( StringUtils.equals("D", _RUNTIME_MODE) ) {
        runmodeName = " - (개발)";
    }

    IUserInfo userInfo = WebUtils.getSessionUserInfo(request);

    if ( null != userInfo ) {
        String loginId = userInfo.getLoginId();
        if ( null != loginId && !"".equals(loginId) && !"Anonymous".equals(loginId) ) {
            if ( ! "R".equals(_RUNTIME_MODE) ) {
                System.out.println("<index> 사용자(ID=" + loginId + ")는 이미 로그인되었음. 메인화면으로 이동!\n\n");
            }
            response.sendRedirect("/view/main.jsp");
        }
    }

    String ua = request.getHeader("user-agent");
    String browser = "IE";
    double ieVer = -1.0;

    if ( ua.indexOf("Chrome") > 0 ) {
        browser = "Chrome";
    }
    else if ( ua.indexOf("Opera") > 0 || ua.indexOf("OPR") > 0 ) {
        browser = "Opera";
    }
    else if ( ua.indexOf("Firefox") > 0 ) {
        browser = "Firefox";
    }
    else if ( ua.indexOf("Safari") > 0 ) {
        browser = "Safari";
    }
    else {
        if ( ua.indexOf("MSIE") > 0 ) {
            int s = ua.indexOf("MSIE") + 5;
            String tmp = ua.substring( s, ua.indexOf(";", s) );
            ieVer = Float.parseFloat( tmp.trim() );
        }
        else {
            if ( ua.indexOf("Trident/7") > 0 ) {
                ieVer = 11.0;
            }
        }
    }
    if ( "L".equals(_RUNTIME_MODE) ) {
        System.out.println("<index> IP : [" +  _IP + "] browser : '" + browser + ("IE".equals(browser) ? "', ie ver. : '" + ieVer : "") + "'"); //, user-agent : [" + ua + "] 
    }

%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>D-TOK<%=runmodeName%></title>

    <link rel="stylesheet" type="text/css" href="<c:out value='${pageContext.request.contextPath}'/>/css/psnm-login.css">
    <link rel="stylesheet" type="text/css" href="<c:out value='${pageContext.request.contextPath}'/>/css/psnm-default.css">
    <link rel="stylesheet" type="text/css" href="<c:out value='${pageContext.request.contextPath}'/>/css/psnm-alopex-ui.css">

<%-- //아래 효과없음.
    <!--[if lte IE 8]>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/jquery-1.10.1.js"></script>
    <![endif]-->
    <!--[if gte IE 9]>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/jquery-1.11.2.min.js"></script>
    <![endif]-->
    <!--[if !IE]>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/jquery-1.11.2.min.js"></script>
    <![endif]-->
--%>
    <!--[if lt IE 8]>
    <script src="http://ie7-js.googlecode.com/svn/version/2.1(beta4)/IE8.js"></script>
    <![endif]-->
    <!--[if IE 8]>
    <script src="http://ie7-js.googlecode.com/svn/version/2.1(beta4)/IE9.js"></script>
    <![endif]-->

    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/jquery-1.11.2.min.js"></script>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/alopex-ui.js"></script>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/alopex-grid.js"></script>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/alopex-grid-render.js"></script>

    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/psnm-config.js"></script>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/psnm-common.js"></script>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/psnm-utils.js"></script>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/psnm-misc.js"></script>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/psnm-webcube.js"></script>

    <script type="text/javascript">
    _LOG_LEVEL = 0;

    $.alopex.page({
        init : function(id, param) {
        }

    });

    function checkIEVersion() {
        //if (navigator.userAgent.toLowerCase().indexOf("msie") > -1 || navigator.userAgent.toLowerCase().indexOf("trident") > -1) {
        var nIEVer = getIEVersion();
        _debug("_IE_VER = " + _IE_VER + ", IE version = " + nIEVer);

        if ( _IE_VER > 0 ) {
            _is_IE = true;
            $("#IE-message-area").show();
            $("#IE-message-area #msg3").show();

            if ( nIEVer>0 && nIEVer < 9 ) {
                $("#IE-message-area #msg1").show();
                $("#IE-message-area #msg2").show();
            }
            else {
                $("#IE-message-area #msg1").hide();
                $("#IE-message-area #msg2").hide();
            }
        }
        else {
            _is_IE = false;
            $("#IE-message-area").hide();
        }

        var ie_version = gf_get_ie_version();
        _debug("_IE_VER(자바) = " + _IE_VER + ", IE version(옛) = " + nIEVer + ", ie_version(신) = " + ie_version);

        if ( ie_version > 0 ) {
            ie_check_webcube();
        }
        else {
            noie_check_webcube();
        }
    }

    function close() {
        window.close();
    }

    </script>
</head>

<body onload="javascript:checkIEVersion();">

<div id="wrap">

    <div id="container">
        <section>
            <div class="loginWrap" id="aform">
                <div class="loginTitle">
                    <h3>접속 브라우저 확인</h3>
                    <p>&nbsp;</p>
                    <p>&nbsp;</p>
                    <h4>'인터넷 익스플로러'나 '크롬' 브라우저로 접속하십시오.</h4>
                    <p>&nbsp;</p>
                    <p>&nbsp;</p>
                </div><!-- //loginTitle end -->
                <div style="text-align: center; ">
                    <button data-type="button" id="btnClose" style="border-radius: 5px; background-color: #fd2f2f; height: 65px; color: #fff; font-size: 1.3em; font-weight: 900;" onclick="javascript:close();">확인</button>
                </div>
            </div>
        </section>
    </div>

</div>


</body>
</html>
