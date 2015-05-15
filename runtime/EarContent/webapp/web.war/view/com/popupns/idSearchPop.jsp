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
    <title>아이디 찾기 - PS&Marketing</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />
    <!-- <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/psnm-ns.js"></script> -->

    <script type="text/javascript">
    _LOG_LEVEL = 0; //로그레벨 :: 0=debug, 1=info, 2=error

    var _TX_SEARCH = "com.MAINLOGIN@PUSER001_pSearchUserId";
    var _isValid   = true;
    var _initParam = null;

    $a.page({
        init : function(id, param) {
            _initParam = param;
            _debug('<idSearchPop> $.alopex.page.init (param) : \n###### ' + JSON.stringify(param));

            $a.page.setEventListener();
            $a.page.setValidators();
            $a.page.setCodeData();

            $.alopex.keyfilter.add('emailspecchar', '109', '\.\-_');

            $('#MBL_PHON_NUM1').focus();
            $("#USER_ID_TEXT").text("");
            $("#loginbox").hide();
        },
        setEventListener : function() {
            $("#btnConfirm").click( pSearchUserId );
            $("#btnCancel").click( closeWithout );
            $("#iconCancel").click( closeWithout );
            $("#EMAIL_DMN_CD").change( onChangeEmailDomain );
        },
        setCodeData : function() {
            $.PSNMUtils.setCodeData([
                { t:'code', 'elemid' : 'MBL_PHON_NUM1', 'codeid' : 'HP_FRST_NO', 'header' : '-선택-', 'ADD_INFO_01' : '' }
               ,{ t:'code', 'elemid' : 'EMAIL_DMN_CD',  'codeid' : 'EMAIL_ACC',  'header' : '-선택-', 'ADD_INFO_01' : 'Y' }
            ]);
        },
        setValidators : function() {
            $('#MBL_PHON_NUM1').validator({
                rule : { required: true },
                message: {
                    required: $.PSNM.msg('E012', ["전화번호"]), //{0} 항목은 필수값입니다!
                }
            });
            $('#MBL_PHON_NUM2').validator({
                rule : { required: true, minlength: 4 },
                message: {
                    required: $.PSNM.msg('E012', ["전화번호"]), //{0} 항목은 필수값입니다!
                    minlength: $.PSNM.msg('E013', ["전화번호", "4"]) //{{0} 항목은 {1}자 이상 입력하세요!
                }
            });
            $('#MBL_PHON_NUM3').validator({
                rule : { required: true, minlength: 4 },
                message: {
                    required: $.PSNM.msg('E012', ["전화번호"]), //{0} 항목은 필수값입니다!
                    minlength: $.PSNM.msg('E013', ["전화번호", "4"]) //{{0} 항목은 {1}자 이상 입력하세요!
                }
            });
            $('#EMAIL_ID').validator({
                rule : { required: true, minlength: 3 },
                message: {
                    required: $.PSNM.msg('E012', ["이메일ID"]), //{0} 항목은 필수값입니다!
                    minlength: $.PSNM.msg('E013', ["이메일ID", "3"]) //{{0} 항목은 {1}자 이상 입력하세요!
                }
            });
            $('#EMAIL_DMN_NM').validator({
                rule : { required: true, minlength: 4 },
                message: {
                    required: $.PSNM.msg('E012', ["이메일 도메인"]), //{0} 항목은 필수값입니다!
                    minlength: $.PSNM.msg('E013', ["이메일 도메인", "4"]) //{{0} 항목은 {1}자 이상 입력하세요!
                }
            });
        }
    });//end-of-$.alopex.page //-------------------------------------------------------------------------------------------------------//

    function closeWithout() {
        $a.close();
    }

    //
    function closeConfirm() {
        var oReturn = {};
        $a.close(oReturn);
    }

    //회원ID 조회
    function pSearchUserId() {
        if ( !$.PSNM.isValid("aform") ) {
            return;
        }

        var requestData = $.PSNMUtils.getRequestData("aform");
        _debug("idSearchPop", "requestData", JSON.stringify(requestData));

        $.alopex.request(_TX_SEARCH, {
            url: _NOSESSION_REQ_URL,
            data: requestData,
            success: function(res) {
                if ( ! $.PSNM.success(res) ) { //서버측 FAIL응답
                    //TO-DO :: 화면에서 오류시 처리하고자 할때 구현함.
                    return; 
                }
                var userId = res.dataSet.fields.USER_ID;
                $("#USER_ID_TEXT").text(userId);
                $("#loginbox").show();
                $("#btns-area").hide();
                setInputsEnable(false);
            }
        });
    } //end of saveAnnce()

    function onChangeEmailDomain(e) {
        var emailcode = $("#EMAIL_DMN_CD").val();

        if ( "99"==emailcode ) {
            $("#EMAIL_DMN_NM").val("");
            $("#EMAIL_DMN_NM").setEnabled(true);
            $("#EMAIL_DMN_NM").focus();
        }
        else {
            $("#EMAIL_DMN_NM").val( $("#EMAIL_DMN_CD option:selected").text() );
            $("#EMAIL_DMN_NM").setEnabled(false);
        }
    }

    function setInputsEnable(bEnable) {
        if ( false==bEnable ) {
            $("#aform input").setEnabled(false);
            $("#aform select").setEnabled(false);
        }
        else {
            $("#aform input").setEnabled(true);
            $("#aform select").setEnabled(true);
        }
    }

    function setTestData(e) {
        $("#MBL_PHON_NUM1").val("010");
        $("#MBL_PHON_NUM2").val("9319");
        $("#MBL_PHON_NUM3").val("6555");
        $("#EMAIL_ID").val("wizpol");
        $("#EMAIL_DMN_CD").val("13");
        $("#EMAIL_DMN_NM").val("naver.com");
    }
    </script>
</head>

<body>

<div class="psnm-pop-body" style="">

    <div class="floatL4" style="width:100%;">
        <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>아이디 찾기</b>
    </div>
    <form id="aform">
        <table class="board02"  style="width:100%;">
        <tr>
            <th class="psnm-required" style="width:80px;">이동전화</th>
            <td class="tleft">
                <select id="MBL_PHON_NUM1" name="MBL_PHON_NUM1" 
                        data-bind="options: options_MBL_PHON_NUM1, selectedOptions: MBL_PHON_NUM1" data-type="select" data-wrap="false" 
                        data-type="select" data-wrap="false" style="width:60px">
                    <option value="">-선택-</option>
                </select>
                - <input id="MBL_PHON_NUM2" name="MBL_PHON_NUM2" type="text" data-type="textinput" data-keyfilter-rule="digits" style="width:50px" maxlength="4">
                - <input id="MBL_PHON_NUM3" name="MBL_PHON_NUM3" type="text" data-type="textinput" data-keyfilter-rule="digits" style="width:50px" maxlength="4">
                <a href="#" style="display: none;"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/btn_a5.gif" width="83" height="24"></a>
                <input type="text" data-type="textinput" placeholder="인증번호" style="width:70px; display: none;">
            </td>
        </tr>
        <tr>
            <th class="psnm-required"">이메일</th>
            <td class="tleft">
                <input id="EMAIL_ID" name="EMAIL_ID" type="text" data-type="textinput" data-keyfilter="a-zA-Z0-9\.\-_" maxlength="30" style="width:150px;">
                @
                <select id="EMAIL_DMN_CD" name="EMAIL_DMN_CD" data-type="select" data-wrap="false" 
                        data-bind="options: options_EMAIL_DMN_CD, selectedOptions: EMAIL_DMN_CD"
                        style="width:120px;">
                    <option value="99">직접입력</option>
                </select>
                <input id="EMAIL_DMN_NM" name="EMAIL_DMN_NM" type="text" data-type="textinput" data-disabled="false" data-keyfilter="a-zA-Z0-9\.\-_" maxlength="30" style="width:120px;" >
            </td>
        </tr>
        </table>
    </form>

    <p class="floatL2" id="btns-area">
        <input id="btnConfirm" type="button" data-type="button" data-theme="af-btn8">
        <input id="btnCancel"  type="button" data-type="button" data-theme="af-btn10">
    </p>

    <table width="100%" id="loginbox" style="display:none;">
    <tr>
        <td height="55" class="fnt_align" style="padding: 20px;">
            고객님의 정보와 일치하는 아이디는 <span class="fnt_blue" id="USER_ID_TEXT"></span> 입니다.
        </td>
    </tr>
    </table>

</div>

<!--
<div id="Wrap">
    <div class="pop_header">
        <span class="title">비밀번호 찾기</span> 
        <a href="#" class="pop_close" onclick="javascript:self.close();"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a9.gif" alt="팝업닫기" ></a> 

        <div class="textAR">
            <table class="board02" width="100%" >
            <tr>
                <th width="15%" style=" color:#ea002c;" scope="col">이동전화</th>
                <td class="tleft">
                    <select name=""  data-type="select" data-wrap="true" style="width:30px">
                    <option value="korea">선택</option>
                </select>
                -
                <input id="textId3"  data-type="textinput1" style="width:60px" value="0000">
                -
                <input id="textId4"  data-type="textinput1" style="width:60px" value="0000">
                <a href="#"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/btn_a5.gif" width="83" height="24"></a>
                <input type="text" data-type="textinput" placeholder="인증번호 6자리 숫자 입력" style="width:200px; float:right; margin-top: 4px; line-height:24px;">
                </td>
            </tr>
            <tr>
                <th  scope="col"><span style=" color:#ea002c;">이메일</span></th>
                <td class="tleft"><input id="textId2"  data-tydpe="textinput1" style="width:200px" value="">
                @
                <select name="select2" data-type="select" data-wrap="true" style="width:100px">
                    <option value="dreamwiz.com" >dreamwiz.com</option>
                </select>
                
                <input type="text" data-type="textinput" placeholder="" style="width:200px; float:right; margin-top: 4px;"></td>
            </tr>
            </table>
            <p class="floatL2">
            <input type="button" value="" data-type="button" data-theme="af-btn8">
            <input type="button" value="" data-type="button" data-theme="af-btn10">
            </p>
            <table width="100%"  id="loginbox">
            <tr>
                <td width="987" height="140" bgcolor="#ffffff">고객님의 정보와 일치하는<br>
                아이디는 <span class="fnt_blue">Lechosue</span> 입니다</td>
            </tr>
            <tr>
                <td height="152" class="fnt_align">ㆍ로그인 페이지로 이동하시어 안내해 드린 아이디와 비밀번호를 통해서 로그인을 해주시기 바랍니다. <br>
                ㆍ비밀번호가 기억나지 않으실 경우 <a href="#">비밀번호 찾기</a>를 클릭하세요.</td>
            </tr>
            </table>
        </div>
    </div>
</div>
-->

</body>
</html>