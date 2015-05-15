<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>회원인증 - PS&Marketing</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />
    <!-- <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/psnm-ns.js"></script> -->

    <script type="text/javascript">
    var _initParam = null;

    $a.page({
        init : function(id, param) {
            _initParam = param;

            $a.page.setEventListener();
            $("#PWD").focus()
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
    	$.alopex.request("com.USERMGMT@PUSERMGMT001_pSearchCertMember", {
    		data: "#form",
            success: function(res) {
                if ( ! $.PSNM.success(res) ) { //서버측 FAIL응답
                    return false; 
                }
                if( res.dataSet.fields.CNT == 0 ){
                	alert("회원 인증에 실패하였습니다.");
                	return false;
                }
                closeConfirm( {CHK_YN: "Y"} );
            }
        });	
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
        <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>회원인증</b>
    </div>
    <form id="form" onsubmit="return false;">
        <table class="board02"  style="width:100%;">
        <tr>
            <th class="psnm-required" style="width:120px;">비밀번호</th>
            <td class="tleft">
                <input id="PWD" name="PWD" type="password" data-type="textinput" data-bind="value:PWD" size="15" maxlength="12"
                		data-validation-rule="{required:true}" 
						data-validation-message="{required:$.PSNM.msg('E012', ['비밀번호'])}">
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