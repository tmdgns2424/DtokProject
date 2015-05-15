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
    <title>비밀번호 변경 - PS&Marketing</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />

    <script type="text/javascript">
    _LOG_LEVEL = 0; //로그레벨 :: 0=debug, 1=info, 2=error

    var _TX_UPDATE_PWD = "com.MAINLOGIN@PLOGIN001_pUpdatePwd";
    var _isValid   = true;
    var _initParam = null;

    $a.page({
        init : function(id, param) {
            _initParam = param;
            _debug('<mainPasswdPop> $.alopex.page.init (param) : \n###### ' + JSON.stringify(param));

            if ( $.PSNMUtils.isNotEmpty(param) && "Y"==param["NEED_TO_CHANGE_PWD"] ) {
                $("#pop-title").empty();
                var mHtml = "<span style='color:blue; font-weight:bold;'>※ 비밀번호를 변경하지 않으면 자동으로 로그아웃 합니다!</span>";
                $("#pop-title").html( mHtml );
            }

            $a.page.setEventListener();
            $a.page.setValidators();

            $('#OLD_PWD').focus();
        },
        setEventListener : function() {
            $("#btnConfirm").click( pUpdatePwd );
            $("#btnCancel").click( closeWithout );
            $("#iconCancel").click( closeWithout );
        },
        setGrid : function() {
        },
        setCodeData : function() {
        },
        setValidators : function() {
            $('#OLD_PWD').validator({
                rule : { required: true, minlength: 4 },
                message: {
                    required: $.PSNM.msg('E012', ["기존 비밀번호"]), //{0} 항목은 필수값입니다!
                    minlength: $.PSNM.msg('E013', ["기존 비밀번호", "4"]) //{{0} 항목은 {1}자 이상 입력하세요!
                }
            });
            $('#NEW_PWD').validator({
                rule : { required: true, minlength: 10 },
                message: {
                    required: $.PSNM.msg('E012', ["신규 비밀번호"]), //{0} 항목은 필수값입니다!
                    minlength: $.PSNM.msg('E013', ["신규 비밀번호", "10"]) //{{0} 항목은 {1}자 이상 입력하세요!
                }
            });
            $('#NEW_PWD2').validator({
                rule : { required: true, minlength: 10 },
                message: {
                    required: $.PSNM.msg('E012', ["신규 비밀번호 확인"]), //{0} 항목은 필수값입니다!
                    minlength: $.PSNM.msg('E013', ["신규 비밀번호 확인", "10"]) //{{0} 항목은 {1}자 이상 입력하세요!
                }
            });
        }
    });//end-of-$.alopex.page //-------------------------------------------------------------------------------------------------------//

    function closeWithout() {
        $a.close();
    }

    //
    function closeConfirm(successYn) {
        var oReturn = new Object();
        if ( $.PSNMUtils.isNotEmpty(successYn) ) {
            oReturn["SUCCESS"] = successYn;
        }
        $a.close(oReturn);
    }

    function pUpdatePwd() {
        // 폼 검증 1 : setValidators() 에서 지정된 것
        if ( !$.PSNM.isValid("aform") ) {
            return false;
        }
        if ( $("#NEW_PWD").val() != $("#NEW_PWD2").val() ) {
            $.PSNM.alert("신규 비밀번호가 서로 다릅니다!");
            return;
        }
        if ( $("#NEW_PWD").val() == $("#OLD_PWD").val() ) {
            $.PSNM.alert("이전 비밀번호와 신규 비밀번호가 같습니다!");
            return;
        }

        var pwd = $("#NEW_PWD").val();

        if ( !isPwdValidate( pwd ) ) {
            $("#NEW_PWD").focus();
            return false;
        }

        var requestData = $.PSNMUtils.getRequestData("aform");
        _debug("mainPasswdPop", "requestData", JSON.stringify(requestData));

        $.alopex.request(_TX_UPDATE_PWD, {
            data: requestData,
            success: function(res) {
                _debug("mainPasswdPop", "responseData", JSON.stringify(res.dataSet.message));
                if ( !$.PSNM.success(res) ) { //서버측에서 오류시 
                    return false;
                }
                $.PSNM.alert("I002", ["변경"]); //"정상적으로 {0} 되었습니다."
                closeConfirm("Y");
            }
        });
    } //end of saveAnnce()

    </script>
</head>

<body>

<!-- title area -->
<div class="psnm-pop-body" style="">

    <!--view_list area -->
    <div class="floatL4" style="width:100%;" id="pop-title"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>비밀번호 변경</b></div>
    <form id="aform">
        <table class="board02"  style="width:100%;">
        <tr>
            <th width="200px" class="psnm-required">기존 비밀번호</th>
            <td class="tleft">
                <input id="OLD_PWD" name="OLD_PWD" type="password" data-type="textinput" maxlength="12" 
                       onfocus="this.className='psnm-login-passwd input_text focus';" onblur="if (this.value.length==0) {this.className='psnm-login-passwd input_text'}else {this.className='psnm-login-passwd input_text focusnot'};"
                       class="psnm-login-passwd input_text" style="width:160px"/>
            </td>
        </tr>
        <tr>
            <th width="200px" class="psnm-required">신규 비밀번호</th>
            <td class="tleft">
                <input id="NEW_PWD" name="NEW_PWD" type="password" data-type="textinput" maxlength="12" 
                       onfocus="this.className='psnm-login-passwd input_text focus';" onblur="if (this.value.length==0) {this.className='psnm-login-passwd input_text'}else {this.className='psnm-login-passwd input_text focusnot'};"
                       class="psnm-login-passwd input_text" style="width:160px"/>
            </td>
        </tr>
        <tr>
            <th width="200px" class="psnm-required">신규 비밀번호 확인</th>
            <td class="tleft">
                <input id="NEW_PWD2" name="NEW_PWD2" type="password" data-type="textinput" maxlength="12" 
                       onfocus="this.className='psnm-login-passwd input_text focus';" onblur="if (this.value.length==0) {this.className='psnm-login-passwd input_text'}else {this.className='psnm-login-passwd input_text focusnot'};"
                       class="psnm-login-passwd input_text" style="width:160px"/>
            </td>
        </tr>
        </table>
    </form>

    <!-- btn area -->
    <div class="btn_area" style="width:500px;">
      <p class="floatL3">
        <input id="btnConfirm" type="button" data-type="button" value="" data-theme="af-btn8">
        <input id="btnCancel"  type="button" data-type="button" value="" data-theme="af-btn10">
      </p>
    </div>

</div>

</body>
</html>