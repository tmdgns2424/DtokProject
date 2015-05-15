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
    <title>권한그룹 등록 - PS&Marketing</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />

    <script type="text/javascript">
    _LOG_LEVEL = 0; //로그레벨 :: 0=debug, 1=info, 2=error

    var _TX_SAVE   = "com.AUTH@PAUTHGRP_pSaveAuthGrp";
    var _mode      = "insert";
    var _gridauthgrp = null; //등록시 현재 권한그룹목록 데이터(배열)
    var _authgrp     = null; //수정시 현재 선택된 권한그룹

    $a.page({
        init : function(id, param) {
            _mode = param["mode"];
            _debug("authGrpRegPop", "mode="+_mode);

            if ( "insert"==_mode ) {
                _gridauthgrp = param["gridauthgrp"]; //
                _debug("authGrpRegPop", "param[gridauthgrp]", JSON.stringify(_gridauthgrp));
                $('#AUTH_GRP_ID').setEnabled(true);
                $('#AUTH_GRP_ID').focus();
            }
            else {
                _authgrp = param["authgrp"]; //
                _debug("authGrpRegPop", "param[authgrp]", JSON.stringify(_authgrp));
                $('#aform').setData(_authgrp);
                $('#AUTH_GRP_ID').setEnabled(false);
                $('#AUTH_GRP_NM').focus();
            }

            $a.page.setEventListener();
            $a.page.setValidators();
        },
        setEventListener : function() {
            $("#btnSave").click( pSaveAuthGrp );
            $("#btnCancel").click( closeWithout );
            $("#iconCancel").click( closeWithout );
        },
        setGrid : function() {
        },
        setCodeData : function() {
        },
        setValidators : function() {
            $('#AUTH_GRP_ID').validator({
                rule : { required: true, digits:true, minlength: 2 },
                message: {
                    required: $.PSNM.msg('E012', ["권한그룹ID"]), //{0} 항목은 필수값입니다!
                    digits: $.PSNM.msg('E017', ["권한그룹ID"]), //{0} 항목은 숫자만 입력하세요!
                    minlength: $.PSNM.msg('E013', ["권한그룹ID", "2"]) //{{0} 항목은 {1}자 이상 입력하세요!
                }
            });
            $('#AUTH_GRP_NM').validator({
                rule : { required: true, minlength: 2 },
                message: {
                    required: $.PSNM.msg('E012', ["권한그룹명"]), //{0} 항목은 필수값입니다!
                    minlength: $.PSNM.msg('E013', ["권한그룹명", "2"]) //{{0} 항목은 {1}자 이상 입력하세요!
                }
            });
            $('#AUTH_PRTY').validator({
                rule : { required: true, digits:true },
                message: {
                    required: $.PSNM.msg('E012', ["우선순위"]), //{0} 항목은 필수값입니다!
                    digits: $.PSNM.msg('E017', ["우선순위"]) //{0} 항목은 숫자만 입력하세요!
                }
            });
        }
    });//end-of-$.alopex.page //-------------------------------------------------------------------------------------------------------//

    function closeWithout() {
        $a.close({"result":""});
    }

    //
    function closeConfirm(oReturn) {
        $a.close(oReturn);
    }

    function pSaveAuthGrp() {
        _debug("authGrpRegPop", "시작 ...");
        var validator = $("#aform").validator();
        if ( !validator.validate() ) {
            var errormessages = validator.getErrorMessage(); //
            _debug( JSON.stringify(validator.getErrorMessage()) );
            for(var name in errormessages) {
                for(var i=0; i < errormessages[name].length; i++) {
                    $.PSNM.alert(errormessages[name][i]);
                    $("#" + name).focus();
                    return; //여기서 반환
                }
            }
        }

        var requestData = $.PSNMUtils.getRequestData("aform");
        _debug("authGrpRegPop", "requestData", JSON.stringify(requestData));

        $.alopex.request(_TX_SAVE, {
            data: requestData,
            success: function(res) {
                _debug("authGrpRegPop", "responseData", JSON.stringify(res.dataSet.message));
                if ( "FAIL" == res.dataSet.message.result ) {
                    $.PSNM.alert( res.dataSet.message.messageName ); //오류메시지 from 서버
                }
                else {
                    $.PSNM.alert("I002", ["저장"]); //"정상적으로 {0} 되었습니다."
                    $a.close({"result":"success"});
                }
            }
        });
    } //end of saveAnnce()

    </script>
</head>

<body>

<!-- title area -->
<div class="psnm-pop-body" style="">

    <!--view_list area -->
    <div class="floatL4" style="width:100%;"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>권한그룹 등록</b></div>
    <form id="aform">
        <table class="board02"  style="width:100%;">
       	<colgroup>
            <col style="width:25%"/>
            <col style="width:*"/>
        </colgroup>
        <tr>
            <th class="psnm-required">권한그룹ID</th>
            <td class="tleft">
                <input id="AUTH_GRP_ID" name="AUTH_GRP_ID" type="text" data-type="textinput" data-bind="value:AUTH_GRP_ID" maxlength="2" 
                       class="psnm-login-passwd input_text" style="width:160px"/>
            </td>
        </tr>
        <tr>
            <th class="psnm-required">권한그룹명</th>
            <td class="tleft">
                <input id="AUTH_GRP_NM" name="AUTH_GRP_NM" type="text" data-type="textinput" data-bind="value:AUTH_GRP_NM" maxlength="20" 
                       class="psnm-login-passwd input_text" style="width:160px"/>
            </td>
        </tr>
        <tr>
            <th class="psnm-required">우선순위</th>
            <td class="tleft">
                <input id="AUTH_PRTY" name="AUTH_PRTY" type="text" data-type="textinput" data-bind="value:AUTH_PRTY" maxlength="3" 
                       class="psnm-login-passwd input_text" style="width:160px"/>
                <!-- <input id="AUTH_PRTY" name="AUTH_PRTY" value="0" data-bind="value:AUTH_PRTY" 
                            data-type="spinner" data-min="1" data-max="200" data-step="1" maxlength="3" style="width:160px" /> -->
            </td>
        </tr>
        <tr>
            <th class="psnm-required">사용여부</th>
            <td class="tleft">
                <input name="USE_YN" id="USE_YN_Y" type="radio" data-type="radio" data-bind="checked:USE_YN" value="Y" checked="checked" />
                <label for="radioId">사용</label>
                <input name="USE_YN" id="USE_YN_N" type="radio" data-type="radio" data-bind="checked:USE_YN" value="N" />
                <label for="radioId2">미사용</label><br/>
            </td>
        </tr>
        <tr>
            <th class="">권한그룹설명</th>
            <td class="tleft">
                <textarea id="AUTH_GRP_DESC" data-type="textarea" data-bind="value:AUTH_GRP_DESC" rows="3" maxlength="100" 
                          style="overflow: auto; width: 95%; margin: 2px;"></textarea>
            </td>
        </tr>
        </table>
    </form>

    <!-- btn area -->
    <div class="btn_area" style="width:100%;">
      <p class="floatL3">
        <!-- <input id="btnConfirm" type="button" data-type="button" value="" data-theme="af-btn8"> -->
        <!-- <input id="btnCancel"  type="button" data-type="button" value="" data-theme="af-btn10"> -->
        <button id="btnSave"   data-type="button" data-theme="af-btn4"  data-authtype="W" data-altname="저장"></button>
        <button id="btnCancel" data-type="button" data-theme="af-btn10" data-authtype="R" data-altname="취소"></button>
      </p>
    </div>

</div>

</body>
</html>