<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>이메일 중복체크 - PS&Marketing</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />

    <script type="text/javascript">
    var _param = null;
    $a.page({
        init : function(id, param) {
        	_param = param;
            $a.page.setEventListener();
            $a.page.setCodeData();
            $('#EMAIL_ID').focus();
        },
        setEventListener : function() {
        	$("#EMAIL_DMN_CD").change( 
        			function( event ){
        				eventHandler( event ) ;
        			});
            $("#btnChk").click( emailDupChk );
            $("#btnCancel").click( closeWithout );
            $("#btnConfirm").click( closeConfirm );
        },    	
        setCodeData : function() {
            $.PSNMUtils.setCodeData([
				$.extend(true,  { t:'code',  'elemid' : 'EMAIL_DMN_CD', 'codeid' : 'EMAIL_ACC', 'header' : '-선택-' }, _param)                  
            ]);
        	
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

    function eventHandler ( event ){
    	switch( event.target.id ){
	    	case "EMAIL_DMN_CD" : //email 도메인 변경시
	    		if ( $("#EMAIL_DMN_CD").val()=='99' ){
	    			$("#EMAIL_DMN_NM").setEnabled( true );
	    			$("#EMAIL_DMN_NM").focus();
	    		}else{
	    			$("#EMAIL_DMN_NM").setEnabled( false );
	    			$("#EMAIL_DMN_NM").val( $("#EMAIL_DMN_CD").getTexts() );
	    		}
	    	break;
    	}
    }
        
    function emailDupChk() {
    	if(!$.PSNM.isValid("form")){
    		return false;
    	}
	   	$.alopex.request("com.USERINFO@PUSERSCRBREQ001_pSearchEmailChk", {
	   		url : _NOSESSION_REQ_URL,
	   		data: '#form',
            success: function(res) {
	         			if (res.dataSet.fields.dupCnt == '0'){
	         				$("#confirmYN").val("Y")
	           				$.PSNM.alert('사용 가능한 이메일입니다');
	         		 	}else{
	         		 		$("#confirmYN").val("N")
	           				$.PSNM.alert('중복된 이메일이 있습니다');
	           				$('#EMAIL_ID').focus();
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
    <div class="floatL4" style="width:100%;"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>이메일</b></div>
    <form id="form" onsubmit="return false;">
        <table class="board02"  style="width:100%;">
			<tr>
		      <th class="psnm-required" scope="col" style="width:10%;">이메일</th>
		      <td colspan="4" class="tleft"><input id="EMAIL_ID" data-bind="value:EMAIL_ID" data-type="textinput" onchange="$('#confirmYN').val('N')"
		      		data-validation-rule="{required:true}" 
					data-validation-message="{required:$.PSNM.msg('E012', ['이메일'])}">
		        @
		        <input id="EMAIL_DMN_NM" data-bind="value:EMAIL_DMN_NM" data-type="textinput" data-disabled="true" onchange="$('#confirmYN').val('N')"
		        	data-validation-rule="{required:true}" 
					data-validation-message="{required:$.PSNM.msg('E012', ['이메일'])}">
		        <select name="EMAIL_DMN_CD" id="EMAIL_DMN_CD" data-type="select" data-bind="options:options_EMAIL_DMN_CD, selectedOptions: EMAIL_DMN_CD" onchange="$('#confirmYN').val('N')"></select>
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