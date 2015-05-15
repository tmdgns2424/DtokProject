<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>팩스번호 중복체크 - PS&Marketing</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />

    <script type="text/javascript">
    $a.page({
        init : function(id, param) {
            $a.page.setEventListener();
            $('#FAX_NUM1').focus();
        },
        setEventListener : function() {
            $("#btnChk").click( faxNumDupChk );
            $("#btnConfirm").click( closeConfirm );
            $("#btnCancel").click( closeWithout );
            $("#FAX_NUM3").keypress( function(){
            	if ( event.which == 13 ) {
            		faxNumDupChk();
            	}
            });
        },
    });

    function closeWithout() {
        $a.close();
    }

    function closeConfirm() {        
    	if( $("#confirmYN").val() == "Y" ){
    		$a.close( $('#form').getData() );
    	}else{
    		$.PSNM.alert("중복조회를 실행하세요.");
    	}    	
    }

    function faxNumDupChk() {
    	if(!$.PSNM.isValid("form")){
    		return false;
    	}
       	$.alopex.request("com.USERINFO@PUSERSCRBREQ001_pSearchFaxNumChk", {
       		url : _NOSESSION_REQ_URL,
       		data: '#form',
            success: function(res) {
               			if (res.dataSet.fields.dupCnt == '0'){
               				$("#confirmYN").val("Y")
               				$.PSNM.alert('사용 가능한 팩스번호입니다');
               			}else{
               				$("#confirmYN").val("N")
               				$.PSNM.alert('중복된 팩스번호가 있습니다');
               			}
               		 }
        });
    }
    </script>
</head>

<body>

<!-- title area -->
<div class="psnm-pop-body" style="">

    <!--view_list area -->
    <div class="floatL4" style="width:100%;"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>팩스번호</b></div>
    <form id="form" onsubmit="return false;">
        <table class="board02"  style="width:100%;">
        <tr>
            <th width="160px" class="psnm-required">팩스번호</th>
            <td class="tleft">
                <input id="FAX_NUM1" name="FAX_NUM1"  type="text" data-type="textinput"  data-bind="value:FAX_NUM1" maxlength="10"  size="11" data-keyfilter-rule="digits"
                			        data-validation-rule="{required:true}" 
			                		data-validation-message="{required:$.PSNM.msg('E012', ['팩스번호'])}" onchange="$('#confirmYN').val('N')" />
                - <input id="FAX_NUM2" name="FAX_NUM2"  type="text" data-type="textinput"  data-bind="value:FAX_NUM2" maxlength="10" size="11" data-keyfilter-rule="digits"
                					data-validation-rule="{required:true}" 
			                		data-validation-message="{required:$.PSNM.msg('E012', ['팩스번호'])}" onchange="$('#confirmYN').val('N')" />
                - <input id="FAX_NUM3" name="FAX_NUM3"  type="text" data-type="textinput"  data-bind="value:FAX_NUM3" maxlength="10" size="11" data-keyfilter-rule="digits"
                					data-validation-rule="{required:true}" 
			                		data-validation-message="{required:$.PSNM.msg('E012', ['팩스번호'])}" onchange="$('#confirmYN').val('N')" />
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