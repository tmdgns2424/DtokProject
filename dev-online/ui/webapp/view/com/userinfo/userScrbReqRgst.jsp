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
        	$.PSNMNS.setBasicOrgSelectBox();
        	$a.page.setImageFileUpload();
            $a.page.setEventListener();
            $a.page.setCodeData();
        	$("#form").setData(param);
        	$("#form").setData({SMS_RCV_AGREE_YN:"Y"});        	
        	$("#form").setData({EMAIL_RCV_AGREE_YN:"Y"});
        	$("#form").setData({BIRTH_LUNAR_YN:"N"});
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
        	$("#btnNickNm").click( openPopup );
        	$("#btnFaxNo").click( openPopup );
        	$("#btnAddress").click( openPopup );
        	$("#btnEmail").click( openPopup );
        	
        	$("#SALE_AGNT_ORG_ID").change( function(){
	    		$("#AGNT_ID").val( $("#SALE_AGNT_ORG_ID").val() );
	    	    if( $.PSNMUtils.isNotEmpty($(this).val()) ){
	    	    	var userNm = ($("#SALE_AGNT_ORG_ID")).getTexts()[0].replace(/^\(.*\)\s/,"");	    	    	
	    	    	if( $("#USER_NM").val() != userNm ){
	    	    		$.PSNM.alert("PSNM-E020", [$("#USER_NM").val(), userNm]);
	    	    		$("#HDQT_TEAM_ORG_ID").setSelected( "" );
	    	        	
	    	    		return false;
	    	    	}	    	    	
	    	    	$("#USER_ID").val( "M"+$("#SALE_AGNT_ORG_ID").val() );
        		}
        	});
        	$("#AGNT_ID").keyup( function( event ){
                if (13==event.which) {
                	$("#HDQT_TEAM_ORG_ID").setEnabled( true );
                	$("#HDQT_PART_ORG_ID").setEnabled( true );
                	$("#SALE_DEPT_ORG_ID").setEnabled( true );
                	$("#SALE_TEAM_ORG_ID").setEnabled( true );
                	$("#SALE_AGNT_ORG_ID").setEnabled( true );
                	
                	$("#HDQT_TEAM_ORG_ID").val("");
                	$("#HDQT_PART_ORG_ID").val("");
                	$("#SALE_DEPT_ORG_ID").val("");
                	$("#SALE_TEAM_ORG_ID").val("");
                	$("#SALE_AGNT_ORG_ID").val("");
                	$("#USER_ID").val("");
                	
            		$.PSNMAction.findAgent( event ); 
                }
        	});
        	
        	$("#btnConfirm").click( function(){
        		sendRequest( "joinMember" )	
        	});
        	$("#iconCancel").click( function (){$a.close();} );        	
        	$("#btnCancel").click( function(){$a.close();});        	        	
        },
        setCodeData : function() {
        	
            $.PSNMUtils.setCodeData([
                { t:'duty',  'elemid' : 'DUTY_CD', 'codeid' : '4', 'header' : '-선택-' }
            ]);
        	
        },
    });
	
    function openPopup( event ){
    	var url, title, width, height, data={}, windowpopup=false;
    	
    	switch( event.target.id ){
        	case "btnNickNm":
				url = "com/popupns/nickNmDupChkPopup";
				title = "닉네임 중복체크";
				width = "385";
				height = "238";
        	break;
            case "btnFaxNo":   
				url = "com/popupns/faxNumDupChkPopup";
				title = "팩스번호 중복체크";
				width = "580";
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
    	}
    	
        $a.popup({
            url: url,
            title : title,
            width: width,
            data : data,
            height: height,
            windowpopup: windowpopup,
            callback : function( oResult ) {
            	popupCallback( event.target.id, oResult);
            }
        });
    }
    
    function popupCallback (elemId, oResult){
    	switch (elemId){
    		case "btnNickNm":
    			$("#form").setData( oResult );
    		case "btnFaxNo":
    			$("#form").setData( oResult );
    		case "btnAddress":
    			$("#form").setData( oResult );
    			$("#ADDR_2").focus();
        	break;
    		case "btnEmail":
    			$("#form").setData( oResult );
    		break;
    	}
    }
    
    function sendRequest( div ){
    	switch( div ){
    		case "joinMember": //회원가입요청을 등록한다.  
    	    	if(!$.PSNM.isValid("form")){
    	    		return false;
    	    	}
    	    	if( !isPwdValidate($("#SCRT_NUM").val()) ){
    	    		return false;
    	    	}
    	    	if( $("#SCRT_NUM").val() != $("#SCRT_NUM2").val()){
    	    		$.PSNM.alert("비밀번호가 일치하지 않습니다.");
    	    		return false;
    	    	}
    			if(getBytes($("#MAIN_JOB").val())>1000){
    				$.PSNM.alert('주업무는 1000byte를 초과할 수 없습니다.');
    				$("#MAIN_JOB").focus();
    				return false;
    			}    	    	
    			if(getBytes($("#MEMO").val())>2000){
    				$.PSNM.alert('메모는 2000byte를 초과할 수 없습니다.');
    				$("#MEMO").focus();
    				return false;
    			}	    	    	
				$.alopex.request("com.USERINFO@PUSERSCRBREQ001_pInsertUserScrbReq", {
					url: _NOSESSION_REQ_URL,
			        data: "#form",
			        success: function(res) {
			        	if ( ! $.PSNM.success(res) ) { //서버측 FAIL응답
			        		return; 
			        	}	
			        	$.PSNM.alert('정상적으로 처리되었습니다.');
			        	close();
			        }
			    }); 
			break;
    	}
    }
    
    function onAgentFound( oAgent ){    
    	var hdqt_team = oAgent.HDQT_TEAM_ORG_ID;
    	var hdqt_part = oAgent.HDQT_PART_ORG_ID;
    	var sale_dept = oAgent.SALE_DEPT_ORG_ID;
    	var sale_team = oAgent.SALE_TEAM_ORG_ID;
    	var sale_agnt = oAgent.AGNT_ID;
        
    	$("#HDQT_TEAM_ORG_ID").setSelected( hdqt_team );
    	$("#HDQT_PART_ORG_ID").setSelected( hdqt_part );
    	$("#SALE_DEPT_ORG_ID").setSelected( sale_dept );
    	$("#SALE_TEAM_ORG_ID").setSelected( sale_team );
    	$("#SALE_AGNT_ORG_ID").setSelected( sale_agnt );    	
    	
    	$("#HDQT_TEAM_ORG_ID").setEnabled( false );
    	$("#HDQT_PART_ORG_ID").setEnabled( false );
    	$("#SALE_DEPT_ORG_ID").setEnabled( false );
    	$("#SALE_TEAM_ORG_ID").setEnabled( false );
    	$("#SALE_AGNT_ORG_ID").setEnabled( false );  
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
        <th scope="col" class="psnm-required">에이전트 코드</th>
        <td colspan="2" class="tleft">
        	<input id="AGNT_ID" data-type="textinput" data-bind="value:AGNT_ID" data-islogin="false" style="width:175px" data-callback="onAgentFound"
        			data-validation-rule="{required:true}" 
			        data-validation-message="{required:$.PSNM.msg('E012', ['에이전트 코드'])}">
			<label>&nbsp;&nbsp;코드/성명을 입력 후 ENTER를 누르세요.</label>
        </td>
        <td rowspan="9" style="position:relative;">
        	<img id="picture" src="" alt="" width="114" height="154"><br><br>  
        	<div style="position:relative;">
				<span class="file-button type3" style="display:block;float:none;margin:7px auto"><input type="file" id="imgFileupload" data-type="button"></span>
			</div>
			<p class="psnm-required">
                * 본인 및 파일의 확장자가 <br> jpg,jpeg.gif인 사진 파일만<br> 등록할 수 있습니다.<br>(주민등록증 촬영 및 상태 <br>  불량 사진 등록 시 승인 거절)
            </p>
        </td>
    </tr>
    <tr>
      <th scope="col" class="psnm-required">직무</th>
      <td colspan="2" class="tleft">
      	<select name="DUTY_CD" id="DUTY_CD" data-bind="options:options_DUTY_CD, selectedOptions: DUTY_CD" data-type="select" style="width: 180px;" 
      		data-validation-rule="{required:true}" 
			data-validation-message="{required:$.PSNM.msg('E012', ['직무'])}"></select></td>
    </tr>
    <tr>
      <th scope="col" class="psnm-required">본사팀</th>
      <td colspan="2" class="tleft">
      	<select id="HDQT_TEAM_ORG_ID" data-bind="options:options_HDQT_TEAM_ORG_ID, selectedOptions: HDQT_TEAM_ORG_ID" data-type="select" style="width: 180px;" 
      		data-validation-rule="{required:true}" 
			data-validation-message="{required:$.PSNM.msg('E012', ['본사팀'])}">
      		<option value="">-선택-</option>
      	</select>
    </tr>
    <tr>
      <th scope="col" class="psnm-required">본사파트</th>
      <td colspan="2" class="tleft">
      	<select id="HDQT_PART_ORG_ID" data-bind="options:options_HDQT_PART_ORG_ID, selectedOptions: HDQT_PART_ORG_ID" data-type="select" style="width: 180px;" 
      		data-validation-rule="{required:true}" 
			data-validation-message="{required:$.PSNM.msg('E012', ['본사파트'])}">
      		<option value="">-선택-</option>
      	</select>
    </tr>    
    <tr>
      <th scope="col" class="psnm-required">영업국명</th>
      <td colspan="2" class="tleft">
      	<select id="SALE_DEPT_ORG_ID" data-bind="options:options_SALE_DEPT_ORG_ID, selectedOptions: SALE_DEPT_ORG_ID" data-type="select" style="width: 180px;" 
      		data-validation-rule="{required:true}" 
			data-validation-message="{required:$.PSNM.msg('E012', ['영업국명'])}">
      		<option value="">-선택-</option>
      	</select>
    </tr>
    <tr>
      <th class="psnm-required" scope="col">영업팀명</th>
      <td colspan="2" class="tleft">
      	<select id="SALE_TEAM_ORG_ID" data-bind="options:options_SALE_TEAM_ORG_ID, selectedOptions: SALE_TEAM_ORG_ID" data-type="select" style="width: 180px;" 
      		data-validation-rule="{required:true}" 
			data-validation-message="{required:$.PSNM.msg('E012', ['영업팀명'])}">
      		<option value="">-선택-</option>
      	</select>
      </td>
    </tr>
    <tr>
      <th class="psnm-required" scope="col">에이전트명</th>
      <td colspan="2" class="tleft">
      	<select id="SALE_AGNT_ORG_ID" data-type="select" data-bind="options:options_SALE_AGNT_ORG_ID, selectedOptions:SALE_AGNT_ORG_ID" style="width:180px;"
      		data-validation-rule="{required:true}" 
			data-validation-message="{required:$.PSNM.msg('E012', ['에이전트명'])}">
      		<option value="">-선택-</option>
      	</select>
      </td>
    </tr>
    <tr>
      <th class="psnm-required" scope="col">회원ID</th>
      <td colspan="2" class="tleft"><input id="USER_ID" data-bind="value:USER_ID" data-disabled="true" data-type="textinput"
      		data-validation-rule="{required:true}" 
			data-validation-message="{required:$.PSNM.msg('E012', ['회원ID'])}"></td>
    </tr>
    <tr>
      <th scope="col" class="psnm-required">회원명</th>
      <td colspan="3" class="tleft"><input id="USER_NM" data-bind="value:USER_NM" data-disabled="true" data-type="textinput"
      		data-validation-rule="{required:true}" 
			data-validation-message="{required:$.PSNM.msg('E012', ['회원명'])}"></td>
    </tr>
    <tr>
      <th scope="col" class="psnm-required">비밀번호</th>
      <td colspan="3" class="tleft"><input id="SCRT_NUM" data-bind="value:SCRT_NUM" data-type="textinput" type="password"
      		data-validation-rule="{required:true}" 
			data-validation-message="{required:$.PSNM.msg('E012', ['비밀번호'])}"></td>
    </tr>
    <tr>
      <th class="psnm-required" scope="col">비밀번호 확인</th>
      <td colspan="3" class="tleft"><input id="SCRT_NUM2" data-type="textinput" type="password"
      		data-validation-rule="{required:true}" 
			data-validation-message="{required:$.PSNM.msg('E012', ['비밀번호 확인'])}"></td>
    </tr>
    <tr>
      <th class="psnm-required" scope="col">닉네임</th>
      <td colspan="3" class="tleft"><input id="NICK_NM" data-bind="value:NICK_NM" data-disabled="true" data-type="textinput"
      		data-validation-rule="{required:true}" 
			data-validation-message="{required:$.PSNM.msg('E012', ['닉네임'])}">
      <input id="btnNickNm" type="button" data-type="button" data-theme="af-n-btn4"></td>
    </tr>
    <tr>
      <th scope="col">FAX 번호</th>
      <td colspan="3" class="tleft"><input id="FAX_NUM1" data-bind="value:FAX_NUM1" data-disabled="true" data-type="textinput" size="11" maxlength="10">
        -
        <input id="FAX_NUM2" data-bind="value:FAX_NUM2" data-disabled="true" data-type="textinput" size="11" maxlength="10">
        -
        <input id="FAX_NUM3" data-bind="value:FAX_NUM3" data-disabled="true" data-type="textinput" size="11" maxlength="10">
        <input id="btnFaxNo" type="button" data-type="button" data-theme="af-n-btn4"></td>
    </tr>
    <tr>
      <th scope="col">주업무(JOB)</th>
      <td colspan="3" class="tleft"><textarea id="MAIN_JOB" data-bind="value:MAIN_JOB" style="width:97%; margin-bottom:10px; margin-top:10px;" cols="40" rows="6" data-type="textarea"></textarea></td>
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
      <th class="psnm-required" scope="col">전화번호</th>
      <td colspan="3" class="tleft">
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
		※ SKT외 타사 가입자는 팩스접수현황 및 업무관련 문자 수신이 불가합니다.</td>
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
      <td width="42%" class="tleft">
      	<select id="WEDD_YN" name="WEDD_YN" data-bind="selectedOptions: WEDD_YN" data-type="select" onchange="this.value=='Y'?$('#WEDD_DT').setEnabled(true):$('#WEDD_DT').setEnabled(false);$('#WEDD_DT').val('')">
      		<option value="">미선택</option>
      		<option value="Y">기혼</option>
      		<option value="N">미혼</option>
      	</select>
      </td>
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
      <th scope="col">메모</th>
      <td colspan="3" class="tleft"><input id="MEMO" data-bind="value:MEMO" data-type="textinput" style="width:80%"></td>
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