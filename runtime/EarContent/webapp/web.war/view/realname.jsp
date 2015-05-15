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
    <title>본인확인(분기) - PS&Marketing</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />

    <script type="text/javascript">
    _LOG_LEVEL = 0;
    _RUNTIME_MODE = "<%=nexcore.framework.core.util.BaseUtils.getRuntimeMode()%>";

    var _TX_SAVE = "com.MAINLOGIN@PMAIN001_pUpdateNameCheck";

    var kmcert_pop = null;

    $a.page({
        init : function(id, param) {
            $a.page.setEventListener();
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

    function cancelVerify() {
        $.PSNM.alert("본인확인하지 않으면 본 시스템을 사용할 수 없습니다!");
        $.PSNM.logout();
    }

    //분기별 본인확인
    function verifyRealname() {
        if ( null != kmcert_pop) {
            $(kmcert_pop).close();
            //kmcert_pop = null;
        }
        var param = {};

        kmcert_pop = $a.popup({
            url: "com/popupns/selfChkPopup",
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

        if ( "step2" != div ) {
            return false;
        }

        if ( oResult.RESULT != "Y") {
            $.PSNM.alert("본인확인하지 않으면 본 시스템을 사용할 수 없습니다!");
            $.PSNM.logout();
            return;
        }

        var param = {};

        $.alopex.request(_TX_SAVE, {
            data: { dataSet : { fields : param } },
            success: function(res) {
                _debug("본인확인성공 저장", "responseData", JSON.stringify(res.dataSet.message));
                if ( ! $.PSNM.success(res) ) {
                    return false;
                }
                //$.PSNM.alert("I002", ["처리"]); //"정상적으로 {0} 되었습니다."
                verifySuccess();
            }
        });
    }

    //본인확인이 최종 성공 -> 메인페이지로 이동
    function verifySuccess() {
        $a.navigate( _MAINPAGE_URL ); //goto main page
    }

    </script>

</head>

<body>

<div id="Wrap"> 
    <!-- header start -->
    <div id="header">
        <div class="floatL2">
            <p class="floatL">
                D-tok은 분기 1회 본인 인증을 의무화하고 있습니다. <br/>
                아래 버튼을 클릭하시면 본인 인증 절차가 진행됩니다.
            </p>
            <p class="floatL">
                ※ 회원外 D-tok 접속은 계약 해지 사유입니다. <br/>
                　 ID/PW 타인 대여는 절대 금지 입니다. 
            </p>
        </div>

        <p class="floatL2">
            <input id="btnConfirm" type="button" value="" data-type="button" data-theme="af-btn8">
            <input id="btnCancel"  type="button" value="" data-type="button" data-theme="af-btn10">
        </p>
        <p class="floatL2" id="test-btn-area" style="display:none;">
            <input id="btnTestGo" type="button" value="　　개발TEST 로그인진행　　" data-type="button">
        </p>
    </div>
</div>

</body>
</html>
