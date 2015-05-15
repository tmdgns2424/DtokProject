<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="nexcore.framework.core.Constants"%>
<%@ page import="nexcore.framework.core.code.ICode"%>
<%@ page import="nexcore.framework.core.data.user.IUserInfo"%>
<%@ page import="nexcore.framework.core.util.BaseUtils"%>
<%@ page import="nexcore.framework.online.channel.util.WebUtils"%>
<%
    IUserInfo userInfo = WebUtils.getSessionUserInfo(request);

    if ( ! "R".equals(nexcore.framework.core.util.BaseUtils.getRuntimeMode()) ) {
        System.out.println("<realname> RuntimeMode = " + nexcore.framework.core.util.BaseUtils.getRuntimeMode());
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>임직원등록 - PS&amp;Marketing</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />

    <script type="text/javascript">
    _LOG_LEVEL = 0;
    _RUNTIME_MODE = "<%=nexcore.framework.core.util.BaseUtils.getRuntimeMode()%>";

    $a.page({
        init : function(id, param) {
            //$a.page.setEventListener();
            toRegEmp();
        }
        ,
        setEventListener : function() {
            $("#btnConfirm").click( verifyRealname );
            $("#btnCancel").click( cancelVerify );
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

    //등록
    function toRegEmp() {
        var param = {};
        kmcert_pop = $a.popup({
            url: "com/popup/empUserRgstPopup",
            data: param,
            title : "임직원 등록",
            width: $.PSNM.popWidth(800),
            height: $.PSNM.popWidth(650),
            modal: true,
            iframe: true,
            windowpopup: false,
            callback : popupCallback
        });
    }

    function popupCallback(oResult) {
        if (null==oResult) {
            $.PSNM.alert("임직원으로 등록하지 않으면 본 시스템을 사용할 수 없습니다!");
            $.PSNM.logout();
            return;
        }
        var successYn = oResult["success"];
        if ( "Y"==successYn) {
            $.PSNM.alert('정상적으로 등록되었습니다.\n\n다시 로그인하시길 바랍니다.');
        }
        else {
            $.PSNM.alert("임직원으로 등록하지 않으면 본 시스템을 사용할 수 없습니다!");
        }
        $.PSNM.logout();
    }
    </script>

</head>

<body>

<div id="Wrap"> 

    <div id="header">

        <div class="floatL2">
            <p class="floatL">
                임직원 등록 절차를 진행하십시오. <br/>
            </p>
            <p class="floatL">
                ※ 임직원으로 등록하지 않으면 본 시스템을 사용할 수 없습니다!
            </p>
        </div>

    </div>
</div>

</body>
</html>
