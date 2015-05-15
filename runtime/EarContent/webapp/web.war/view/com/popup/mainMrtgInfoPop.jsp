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
    <title>담보만료 안내 - PS&Marketing</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />

    <script type="text/javascript">
    _LOG_LEVEL = 0; //로그레벨 :: 0=debug, 1=info, 2=error

    var _TX_SAVE = "com.MAINLOGIN@PMAIN001_pMergeMrtgExpir";
    var _param = null;

    $a.page({
        init : function(id, param) {
            _param = param;
            _debug('담보만료안내(팝업)', JSON.stringify(param));

            $("#days-before").text(param["DAYS_BEFORE"]);
            $a.page.setEventListener();
        },
        setEventListener : function() {
            $("#btnYes").click( pSaveMrtgExpirHst );
            $("#btnNo").click( pSaveMrtgExpirHst );
            $("#iconCancel").click( closeWithout );
        }
    });

    function closeWithout() {
        $a.close({});
    }

    function closeConfirm(oReturn) {
        //var oReturn = {};
        $a.close(oReturn);
    }

    function pSaveMrtgExpirHst(e) {
        //var requestData = $.PSNMUtils.getRequestData("aform");
        var yn = "";
        if ( "btnYes" === e.target.id ) {
            yn = "Y";
        }
        else if ( "btnNo" === e.target.id ) {
            yn = "N";
        }
        _param["MRTG_EXPIR_RE_CNTRCT_YN"] = yn; //담보만료재계약여부
        _param["MRTG_EXPIR_DT"] = _param["EXPIR_DT"]; //담보만료일자
        _param["SMS_SND_YN"] = ""; //SMS발송여부

        _debug("담보만료안내(팝업)", "requestData", JSON.stringify(_param), e.target.id);

        $.alopex.request(_TX_SAVE, {
            data: { dataSet : { fields : _param } },
            success: function(res) {
                _debug("담보만료안내(팝업)", "responseData", JSON.stringify(res.dataSet.message));
                if ( ! $.PSNM.success(res) ) {
                    //return false;
                }
                $.PSNM.alert("I002", ["처리"]); //"정상적으로 {0} 되었습니다."
                closeConfirm(_param);
                
                //var oPopupObject = $a.popup({
                //    url: "com/popup/mainMrtgConfirmPop"
                //  , data: _param
                //  //, modal:  false
                //  //, windowpopup: true //DIV팝업 X
                //  , width: 400
                //  , height: 270
                //  , title: "담보만료확인"
                //});
            }
        });

    }

    </script>
</head>

<body>

<div class="psnm-pop-body" style="">

    <div class="floatL4" style="width:100%;"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>담보만료안내</b></div>
    <form id="aform">
        <table class="board02" style="width:100%;">
        <tr>
            <td class="tleft">
                <p>제출하신 담보의 만료 기간이 <span id="days-before">○○</span>일 남았습니다.</p>
                <p>담보 기간 연장을 통한 재계약을 원하십니까?</p>
            </td>
        </tr>
        </table>
    </form>

    <!-- btn area -->
    <div class="btn_area" style="width:99%;">
      <p class="floatL3">
        <input id="btnYes" type="button" data-type="button" value="" data-theme="af-n-btn31">
        <input id="btnNo"  type="button" data-type="button" value="" data-theme="af-n-btn32">
      </p>
    </div>

</div>

</body>
</html>