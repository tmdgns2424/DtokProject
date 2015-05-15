<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>비밀번호 변경- PS&Marketing</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />
    <!-- <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/psnm-ns.js"></script> -->

    <script type="text/javascript">
    var _initParam = null;

    $a.page({
        init : function(id, param) {
            _initParam = param;

            $a.page.setEventListener();
            $("#OLD_PWD").focus()
        },
        setEventListener : function() {
        	$("#PWD").keypress( function( event ){
        		if ( event.which == 13 ) {
        			sendRequest();
      		   }
        	});
            $("#btnConfirm").click( sendRequest );
            $("#btnCancel").click( closeWithout );
        }
    });
	
    function sendRequest(){
		if ( ! $.PSNM.isValid("#form") ) {
		    return false; 
		}
		if ( !isPwdValidate( $("#PWD").val() ) ){
			$("#PWD").focus();
			return false;
		}
		if ( $("#PWD").val() != $("#PWD2").val()){
			alert( "신규 비밀번호가 일치하지 않습니다." );
			$("#PWD2").focus()
			return false;
		}
		if(  $.PSNM.confirm("I004", ["변경"]) ){
	    	$.alopex.request("com.USERMGMT@PUSERMGMT001_pUpdatePassword", {
	    		data: "#form",
	            success: function(res) {
	                if ( ! $.PSNM.success(res) ) { //서버측 FAIL응답
		            	if (res.dataSet.message.messageId == "PSNM-E007"){
		            		$("#OLD_PWD").focus();
		            	}
	                    return false; 
	                }
	                $a.close();
	            }
	        });	
		}
    }
    
    function closeWithout() {
        $a.close();
    }

    function closeConfirm( oResult ) {
        $a.close( oResult );
    }
    </script>
</head>

<body>

<div class="psnm-pop-body" style="">

    <div class="floatL4" style="width:100%;">
        <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>비밀번호 변경</b>
    </div>
    <form id="form" onsubmit="return false;">
        <table class="board02"  style="width:100%;">
        <tr>
            <th class="psnm-required" style="width:120px;">기존 비밀번호</th>
            <td class="tleft">
                <input id="OLD_PWD" name="OLD_PWD" type="password" data-type="textinput" data-bind="value:OLD_PWD" size="15" maxlength="12"
                		data-validation-rule="{required:true}" 
						data-validation-message="{required:$.PSNM.msg('E012', ['기존 비밀번호'])}">
            </td>
        </tr>
        <tr>
            <th class="psnm-required" style="width:120px;">신규 비밀번호</th>
            <td class="tleft">
                <input id="PWD" name="PWD" type="password" data-type="textinput" data-bind="value:PWD" size="15" maxlength="12"
                		data-validation-rule="{required:true}" 
						data-validation-message="{required:$.PSNM.msg('E012', ['신규 비밀번호'])}">
            </td>
        </tr>
        <tr>
            <th class="psnm-required" style="width:120px;">신규 비밀번호 확인</th>
            <td class="tleft">
                <input id="PWD2" name="PWD2" type="password" data-type="textinput" size="15" maxlength="12">
            </td>
        </tr>
        </table>
    </form>

    <p class="floatL2" id="btns-area">
        <input id="btnConfirm" type="button" data-type="button" data-theme="af-btn8">
        <input id="btnCancel"  type="button" data-type="button" data-theme="af-btn10">
    </p>

</div>
</body>
</html>