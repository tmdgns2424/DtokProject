<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>닉네임 중복체크 - PS&Marketing</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />

    <script type="text/javascript">
    $a.page({
        init : function(id, param) {
            $a.page.setEventListener();
            $('#NICK_NM').focus();
        },
        setEventListener : function() {
            $("#btnChk").click( nickNmDupChk );
            $("#btnCancel").click( closeWithout );
            $("#btnConfirm").click( closeConfirm );
            $("#NICK_NM").keypress( function(){
            	if ( event.which == 13 ) {
            		nickNmDupChk();
            	}
            });
        },
    });

    function closeWithout() {
        $a.close();
    }

    function closeConfirm() {    
    	if( $("#confirmYN").val() == "Y" ){
        	$a.close( $('#NICK_NM').getData() );
    	}else{
    		$.PSNM.alert("중복조회를 실행하세요.");
    	}
    }

    function nickNmDupChk() {
    	if(!$.PSNM.isValid("form")){
    		return false;
    	}
	   	$.alopex.request("com.USERINFO@PUSERSCRBREQ001_pSearchNickNmChk", {
	   		url : _NOSESSION_REQ_URL,
	   		data: '#form',
            success: function(res) {
	         			if (res.dataSet.fields.dupCnt == '0'){
	         				$.PSNM.alert("사용 가능한 닉네임입니다.");
	           				$("#confirmYN").val("Y")
	         		 	}else{
	         		 		$.PSNM.alert('중복된 닉네임이 있습니다');
	           				$("#confirmYN").val("N")
	           				$("#NICK_NM").focus();
	         		 	}
           			}
	    });
    }
    </script>
</head>

<body>

<!-- title area -->
<div class="psnm-pop-body">

    <!--view_list area -->
    <div class="floatL4" style="width:100%;"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>닉네임</b></div>
    <form id="form" onsubmit="return false;">
        <table class="board02"  style="width:100%;">
        <tr>
            <th width="100px" class="psnm-required">닉네임</th>
            <td class="tleft">
                <input id="NICK_NM" name="NICK_NM"  type="text" data-type="textinput"  data-bind="value:NICK_NM" maxlength="20"
		                data-validation-rule="{required:true}" 
			            data-validation-message="{required:$.PSNM.msg('E012', ['닉네임'])}" onchange="$('#confirmYN').val('N')"/>
			    <input type="hidden" id="confirmYN" value="N">
                <input id="btnChk" type="button" data-type="button"  value=""  data-theme="af-btn34">
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