<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="nexcore.framework.core.Constants"%>
<%@ page import="nexcore.framework.core.code.ICode"%>
<%@ page import="nexcore.framework.core.data.user.IUserInfo"%>
<%@ page import="nexcore.framework.core.util.BaseUtils"%>
<%@ page import="nexcore.framework.online.channel.util.WebUtils"%>
<%
    IUserInfo userInfo = WebUtils.getSessionUserInfo(request);

%>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>담보만료 확인 - PS&Marketing</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />

    <script type="text/javascript">
    _LOG_LEVEL = 0; //로그레벨 :: 0=debug, 1=info, 2=error

    var _param = null;

    $a.page({
        init : function(id, param) {
            _param = param;
            _debug('담보만료확인(팝업)', JSON.stringify(param));

            $a.page.setEventListener();

            var reCntrctYn = param["MRTG_EXPIR_RE_CNTRCT_YN"];
            var expirDt = param["MRTG_EXPIR_DT"];

            var mrtgMesg = "";

            if ( $.PSNMUtils.isNotEmpty(expirDt) ) {
                mrtgMesg += "" + expirDt.substring(0,4) + "년 ";
                mrtgMesg += "" + expirDt.substring(4,6) + "월 ";
                mrtgMesg += "" + expirDt.substring(6) + "일";
            }

            if ( "Y"==reCntrctYn ) {
                mrtgMesg += "까지 재계약을 완료해야 합니다.";
            }
            else if ( "N"==reCntrctYn ) {
                mrtgMesg += "부터 새로운 위탁출고가 불가합니다.";
            }
            else {
                mrtgMesg += "담보만료를 확인할 수 없습니다. (오류)";
            }
            $("#mrtg_mesg").html(mrtgMesg);
        },
        setEventListener : function() {
            $("#btnConfirm").click( closeConfirm );
            $("#iconCancel").click( closeWithout );
        }
    });

    function closeWithout() {
        $a.close({});
    }

    function closeConfirm() {
        var oReturn = {};
        $a.close(oReturn);
    }

    </script>
</head>

<body>

<div class="psnm-pop-body" style="">

    <div class="floatL4" style="width:100%;"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>담보만료확인</b></div>
    <form id="aform">
        <table class="board02" style="width:100%;">
        <tr>
            <td class="tleft">
                <p id="mrtg_mesg">&nbsp;</p>
                <!-- <p>X월X일까지 재계약을 완료해야 합니다.</p><p>X월X일부터 새로운 위탁출고가 불가합니다.</p> -->
                <!-- <span id="mrtg_expir_dt">X월X일</span><span id="etc-text">까지 재계약을 완료해야 합니다.</span> -->
            </td>
        </tr>
        </table>
    </form>

    <!-- btn area -->
    <div class="btn_area" style="width:99%;">
        <p class="floatL3">
            <input id="btnConfirm" type="button" data-type="button" value="" data-theme="af-btn8">
        </p>
    </div>

</div>

</body>
</html>