<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<title>회원가입요청등록</title>
<jsp:include page="/view/layouts/popup_head.jsp" flush="false" />
<script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/psnm-ns.js"></script>
<script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/vendor/jquery.ui.widget.js"></script>
<script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/jquery.iframe-transport.js"></script>
<script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/jquery.fileupload.js"></script>
<script type="text/javascript">
    $.alopex.page({

        init : function(id, param) {
        	var data = {USER_ID : $.PSNM.getSession("USER_ID")
        			    , USER_NM : $.PSNM.getSession("USER_NM")
        			    , HDQT_TEAM_ORG_NM : $.PSNM.getSession("HDQT_TEAM_ORG_NM")
        			    , HDQT_PART_ORG_NM : $.PSNM.getSession("HDQT_PART_ORG_NM")
        			    , DUTY_NM : $.PSNM.getSession("DUTY_NM")};
        	$("#form").setData(data);
        	$("#form").setData({WEDD_YN:"N"});
        	$("#form").setData({SMS_RCV_AGREE_YN:"Y"});        	
        	$("#form").setData({EMAIL_RCV_AGREE_YN:"Y"});
        	$("#form").setData({BIRTH_LUNAR_YN:"N"});
        	
        	$a.page.setImageFileUpload();
            $a.page.setEventListener();
        },
        setImageFileUpload : function() {
        	var oMyPicFileInfo = new Object();
        	$("#imgFileupload").fileupload({
                dataType: 'json',
                url : _FILE_HANDLER_URL + "?biz=pic",
                done: function (e, data) {
                    $.each(data.result, function (index, fileinfo) {
                    	var regex = /\.([j|J][p|P][g|G]|[j|J][p|P][e|E][g|G]|[g|G][i|I][f|F]|[p|P][n|N][g|G])$/; 
                    	if (!regex.test(fileinfo.name)) { 
	                    	alert("확장자가 jpg, jpeg, gif인 파일만 등록할 수 있습니다."); 
	                    	return false; 
                    	}
                    	
                    	oMyPicFileInfo["FILE_GRP_ID"] = fileinfo.group
                    	oMyPicFileInfo["FILE_PATH"] = fileinfo.dir
                    	oMyPicFileInfo["ATCH_FILE_ID"] = fileinfo.id
                    	oMyPicFileInfo["FILE_NM"] = fileinfo.name
                    	
                    	$("#ATCH_FILE_ID").val(fileinfo.id);
                    	$("#FILE_PATH").val(fileinfo.dir);
                    	$("#FILE_NM").val(fileinfo.name);
                    	$("#FILE_SIZE").val(fileinfo.size);
                    	
                    	var imgFileUrl = $.PSNMUtils.getDownloadUrl(oMyPicFileInfo); 
                    	$("#picture").attr("src", imgFileUrl);
                    });
                }
            });
        },
        setEventListener : function() {
            $("#btnChgPhone").click( openPopup );
        	$("#btnNickNm").click( openPopup );
        	$("#btnAddress").click( openPopup );
        	$("#btnEmail").click( openPopup );
        	
        	$("#btnConfirm").click( function(){
        		sendRequest( "joinMember" )	
        	});
        	$("#iconCancel").click( function (){$a.close();} );        	
        	$("#btnCancel").click( function(){$a.close();});        	        	
        },
    });
	
    function openPopup( event ){
    	var url, title, width, height, modal=false, data={}, windowpopup=false;
    	
    	switch( event.target.id ){
        	case "btnNickNm":
				url = "com/popupns/nickNmDupChkPopup";
				title = "닉네임 중복체크";
				width = "385";
				height = "238";
        	break;
            case "btnAddress":     
				url = "com/popupns/addrSearchPopup";
				title = "주소찾기";
				width = "500";
				height = "655";
		    break;
            case "btnEmail":     
				url = "com/popupns/emailDupChkPopup";
				data = {'ADD_INFO_01' : 'Y'};
				title = "E-mail 중복체크";
				width = "590";
				height = "238";
		    break;		
    		case "btnChgPhone":
    			url = "com/popupns/selfChkPopup";
    			title = "본인확인";
    			width = "500";
    			height = "600";
    			modal = false;
    			windowpopup = true;
    		break;		    
    	}
    	
        $a.popup({
            url: url,
            title : title,
            width: width,
            data : data,
            height: height,
            windowpopup: windowpopup,
            modal : modal,
            callback : function( oResult ) {
            	popupCallback( event.target.id, oResult);
            }
        });
    }
    
    function popupCallback (elemId, oResult){
    	switch (elemId){
    		case "btnNickNm":
    			$("#form").setData( oResult );
    		case "btnAddress":
    			$("#form").setData( oResult );
    			$("#ADDR_2").focus();
        	break;
    		case "btnEmail":
    			$("#form").setData( oResult );
    		break;
    		case "step2":
    			if( oResult.USER_NM != $.PSNM.getSession("USER_NM")){
    				$.PSNM.alert("PSNM-E022", [oResult.USER_NM, $.PSNM.getSession("USER_NM")]);
    				return false;
    			}
    			if( oResult.RESULT == "Y"){
    				$("#TEL_CO_CD").val( oResult.TEL_CO_CD );
    				$("#MBL_PHON_NUM1").val( oResult.MBL_PHON_NUM1 );
    				$("#MBL_PHON_NUM2").val( oResult.MBL_PHON_NUM2 );
    				$("#MBL_PHON_NUM3").val( oResult.MBL_PHON_NUM3 );
    			}
    		break;    		
    	}
    }
    
    function sendRequest( div ){
    	switch( div ){
    		case "joinMember": //회원가입요청을 등록한다.  
    	    	if(!$.PSNM.isValid("form")){
    	    		return false;
    	    	}    	    
    			if(getBytes($("#MAIN_JOB").val())>1000){
    				$.PSNM.alert('주업무는 1000byte를 초과할 수 없습니다.');
    				$("#MAIN_JOB").focus();
    				return false;
    			}    	    	    			    	    
				$.alopex.request("com.USERMGMT@PUSERMGMT001_pInsertEmpUser", {
			        data: "#form",
			        success: function(res) {
			        	if ( ! $.PSNM.success(res) ) { //서버측 FAIL응답
			        		return; 
			        	}	
			        	$a.close({"success":"Y"});
			        }
			    }); 
			break;
    	}
    }

</script>
<body>
<div id="Wrap">

<!-- title area -->
<div class="pop_header" >
	<div class="pop_title">
		<span class="title">회원가입</span> 
		<a id="iconCancel" href="#" class="pop_close"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a9.gif" alt="팝업닫기" ></a>
	</div>
  <!--view_table area -->
    <div class="textAR" >
    <form id="form" onsubmit="return false;">
    <input id="ATCH_FILE_ID" name="ATCH_FILE_ID" data-bind="value:ATCH_FILE_ID" type="hidden" data-type="textinput"
    	data-validation-rule="{required:true}" 
		data-validation-message="{required:$.PSNM.msg('E012', ['사진등록'])}"/>
	<input id="FILE_PATH" name="FILE_PATH" data-bind="value:FILE_PATH" type="hidden" data-type="textinput" />
	<input id="FILE_NM" name="FILE_NM" data-bind="value:FILE_NM" type="hidden" data-type="textinput" />
	<input id="FILE_SIZE" name="FILE_SIZE" data-bind="value:FILE_SIZE" type="hidden" data-type="textinput" />
    <table class="board02" style="width:100%;">
    <colgroup>
    	<col style="width:15%">
    	<col style="width:30%">
    	<col style="width:15%">
    	<col style="width:30%">
    </colgroup>
    <tr>
      <th class="psnm-required" scope="col">회원ID</th>
      <td colspan="2" class="tleft">
      		<label data-bind="text:USER_ID"></label>
      </td>          
      <td rowspan="7" style="position:relative;">
        	<img id="picture" src="" alt="" width="114" height="154"><br><br>  
        	<div style="position:relative;">
				<span class="file-button type3" style="display:block;float:none;margin:7px auto"><input type="file" id="imgFileupload" data-type="button"></span>
			</div>
      </td>
    </tr>
    <tr>
      <th class="psnm-required" scope="col">회원명</th>
      <td colspan="2" class="tleft"><label data-bind="text:USER_NM"></label></td>
    </tr>    
    <tr>
    <th scope="col" class="psnm-required">본사팀</th>
      <td colspan="2" class="tleft">
      	<label data-bind="text:HDQT_TEAM_ORG_NM"></label>
      	</td>
    </tr>
    <tr>
      <th scope="col" class="psnm-required">본사파트</th>
      <td colspan="2" class="tleft">
      	<label data-bind="text:HDQT_PART_ORG_NM"></label>   
    </tr>
    <tr>
      <th scope="col" class="psnm-required">직무</th>
      <td colspan="2" class="tleft"><label data-bind="text:DUTY_NM"></label></td> 
    </tr>
    <tr>
      <th class="psnm-required" scope="col">전화번호</th>
      <td colspan="2" class="tleft">
      	<input id="PHON_NUM1" data-bind="value:PHON_NUM1" data-type="textinput" size="4" data-keyfilter-rule="digits"
      		data-validation-rule="{required:true}" 
			data-validation-message="{required:$.PSNM.msg('E012', ['전화번호'])}">
        -
        <input id="PHON_NUM2" data-bind="value:PHON_NUM2" data-type="textinput" value="" size="4" data-keyfilter-rule="digits"
        	data-validation-rule="{required:true}" 
			data-validation-message="{required:$.PSNM.msg('E012', ['전화번호'])}">
        -
        <input id="PHON_NUM3" data-bind="value:PHON_NUM3" data-type="textinput" value="" size="4" data-keyfilter-rule="digits"
        	data-validation-rule="{required:true}" 
			data-validation-message="{required:$.PSNM.msg('E012', ['전화번호'])}"></td>
    </tr>
    <tr>
      <th class="psnm-required" scope="col">이동전화</th>
      <td colspan="3" class="tleft"><input name="TEL_CO_CD" id="TEL_CO_CD" data-type="textinput" data-bind="value:TEL_CO_CD" data-disabled="true" size="4">
        <input id="MBL_PHON_NUM1" data-bind="value:MBL_PHON_NUM1" data-type="textinput" data-disabled="true" size="4"
        	data-validation-rule="{required:true}" 
			data-validation-message="{required:$.PSNM.msg('E012', ['이동전화'])}">
        -
        <input id="MBL_PHON_NUM2" data-bind="value:MBL_PHON_NUM2" data-type="textinput" data-disabled="true" size="4"
        	data-validation-rule="{required:true}" 
			data-validation-message="{required:$.PSNM.msg('E012', ['이동전화'])}">
        -
        <input id="MBL_PHON_NUM3" data-bind="value:MBL_PHON_NUM3" data-type="textinput" data-disabled="true" size="4"
        	data-validation-rule="{required:true}" 
			data-validation-message="{required:$.PSNM.msg('E012', ['이동전화'])}">
		<button id="btnChgPhone" name="btnChgPhone" type="button" data-type="button" data-theme="af-n-btn29"></button>
	  </td>
    </tr>    
    <tr>
      <th class="psnm-required" scope="col">닉네임</th>
      <td colspan="3" class="tleft"><input id="NICK_NM" data-bind="value:NICK_NM" data-disabled="true" data-type="textinput"
      		data-validation-rule="{required:true}" 
			data-validation-message="{required:$.PSNM.msg('E012', ['닉네임'])}">
      <input id="btnNickNm" type="button" data-type="button" data-theme="af-n-btn4"></td>
    </tr>
    <tr>
      <th class="psnm-required" scope="col">현주소(실거주지)</th>
      <td colspan="3" class="tleft"><input id="POST_NUM1" data-bind="value:POST_NUM1" data-type="textinput" value="" size="4" data-disabled="true"
           	data-validation-rule="{required:true}" 
			data-validation-message="{required:$.PSNM.msg('E012', ['우편번호'])}">
        - <input id="POST_NUM2" data-bind="value:POST_NUM2" data-type="textinput" value="" size="4" data-disabled="true"
            data-validation-rule="{required:true}" 
			data-validation-message="{required:$.PSNM.msg('E012', ['우편번호'])}">
        <input id="btnAddress" type="button" data-type="button" data-theme="af-n-btn4">
        </br><input id="ADDR_1" data-bind="value:ADDR_1" data-type="textinput" style="width:350px" value="" data-disabled="true">
        <input id="ADDR_2" data-bind="value:ADDR_2" data-type="textinput" style="width:350px" value="" 
        	data-validation-rule="{required:true}" 
			data-validation-message="{required:$.PSNM.msg('E012', ['상세주소'])}">
      </td>        
    </tr>
    <tr>
      <th scope="col">생년월일</th>
      <td class="tleft"><input id="BIRTH_DT" data-bind="value:BIRTH_DT" data-type="dateinput" style="width:70px;" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png"></td>
      <td colspan="2" style="text-align:left;border-left:0px">
      <input type="radio" name="BIRTH_LUNAR_YN" value="Y" data-bind="checked:BIRTH_LUNAR_YN" data-type="radio">
        음력
        <input type="radio" name="BIRTH_LUNAR_YN" value="N" data-bind="checked:BIRTH_LUNAR_YN" data-type="radio">
        양력</td>
    </tr>
    <tr>
      <th scope="col">결혼유무</th>
      <td width="42%" class="tleft"><input type="radio" name="WEDD_YN" value="Y" data-bind="checked:WEDD_YN" data-type="radio"  onclick="$('#WEDD_DT').setEnabled(true)">
        기혼
        <input type="radio" name="WEDD_YN" value="N" data-bind="checked:WEDD_YN" data-type="radio" onclick="$('#WEDD_DT').setEnabled(false);$('#WEDD_DT').val('')">
        미혼</td>
      <th scope="col">결혼기념일</th>
      <td class="tleft"><input id="WEDD_DT" data-bind="value:WEDD_DT" data-type="dateinput" style="width:70px;" data-disabled="true" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png"></td>
    </tr>
    <tr>
      <th class="psnm-required" scope="col">SMS 수신동의</th>
      <td colspan="3" class="tleft"><input type="radio" name="SMS_RCV_AGREE_YN" value="Y" data-bind="checked:SMS_RCV_AGREE_YN" data-type="radio">
        동의
        <input type="radio" name="SMS_RCV_AGREE_YN" data-bind="checked:SMS_RCV_AGREE_YN" value="N" data-type="radio">
        미동의</td>
    </tr>    
    <tr>
      <th class="psnm-required" scope="col">이메일 수신동의</th>
      <td colspan="3" class="tleft"><input type="radio" name="EMAIL_RCV_AGREE_YN" value="Y" data-bind="checked:EMAIL_RCV_AGREE_YN" data-type="radio">
        동의
        <input type="radio" name="EMAIL_RCV_AGREE_YN" data-bind="checked:EMAIL_RCV_AGREE_YN" value="N" data-type="radio">
        미동의</td>
    </tr>
    <tr>
      <th class="psnm-required" scope="col">이메일</th>
      <td colspan="3" class="tleft"><input id="EMAIL_ID" data-bind="value:EMAIL_ID" data-type="textinput" data-disabled="true"
      		data-validation-rule="{required:true}" 
			data-validation-message="{required:$.PSNM.msg('E012', ['이메일'])}">
        @
        <input id="EMAIL_DMN_NM" data-bind="value:EMAIL_DMN_NM" data-type="textinput" data-disabled="true"
        	data-validation-rule="{required:true}" 
			data-validation-message="{required:$.PSNM.msg('E012', ['이메일'])}">
		<input id="EMAIL_DMN_CD" data-bind="value:EMAIL_DMN_CD" data-type="textinput" type="hidden">
        <input id="btnEmail" type="button" data-type="button" data-theme="af-n-btn4">
      </td>
    </tr>
    <tr>
      <th scope="col">주업무(JOB)</th>
      <td colspan="3" class="tleft"><textarea id="MAIN_JOB" data-bind="value:MAIN_JOB" style="width:97%; margin-bottom:10px; margin-top:10px;" cols="40" rows="6" data-type="textarea"></textarea></td>
    </tr>    
  </table>
        
        
        
    <p class="floatL2">
      <input id="btnConfirm" type="button" value="" data-type="button" data-theme="af-btn8">
      <input id="btnCancel" type="button" value="" data-type="button" data-theme="af-btn10">
    </p>
    
    </div>
    </form>
</div>
</div>
</body>
</html>