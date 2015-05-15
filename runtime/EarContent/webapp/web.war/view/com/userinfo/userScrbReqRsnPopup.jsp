<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="nexcore.framework.core.Constants"%>
<%@ page import="nexcore.framework.core.code.ICode"%>
<%@ page import="nexcore.framework.core.data.user.IUserInfo"%>
<%@ page import="nexcore.framework.core.util.BaseUtils"%>
<%@ page import="nexcore.framework.online.channel.util.WebUtils"%>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>회원가입요청 승인/반려 결제의견</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />

    <script type="text/javascript">
    $a.page({
        init : function(id, param) {
            $a.page.setEventListener();
            $('#SCRB_ST_CHG_RSN').focus();
        },
        setEventListener : function() {
            $("#btnConfirm").click( closeWith );
            $("#btnCancel").click( closeWithout );
        }
    });
    
    //현재창을 닫고 객체를 반환
    function closeWith( val ) {
        $a.close(  {SCRB_ST_CHG_RSN: $("#SCRB_ST_CHG_RSN").val(), confirmYN: "Y"}  );
    }

    function closeWithout() {
        $a.close( {confirmYN: "N"});
    }    
    </script>
</head>

<body>

<!-- title area -->
<div class="psnm-pop-body" style="">
    <form id="form" onsubmit="return false;">
        <table class="board02"  style="width:98%;">
	    <colgroup>
	    	<col style="width:100px">
	    	<col style="width:*">
	    </colgroup>
        <tr>
            <th >결재의견</th>
            <td class="tleft">
				<textarea id="SCRB_ST_CHG_RSN" name="SCRB_ST_CHG_RSN"  data-type="textarea" cols="40" rows="3" style="width:95%" data-theme="af-textarea"></textarea>
            </td>
        </tr>        
        </table>
    </form>

    <!-- btn area -->
    <div class="btn_area" style="width:100%;">
      <p class="floatL3">
        <input id="btnConfirm" type="button" data-type="button" value="" data-theme="af-btn8">
        <input id="btnCancel"  type="button" data-type="button" value="" data-theme="af-btn10">
      </p>
    </div>

</div>

</body>
</html>