<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

    <jsp:include page="/view/layouts/default_head.jsp" flush="false" />
    
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/vendor/jquery.ui.widget.js"></script>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/jquery.iframe-transport.js"></script>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/jquery.fileupload.js"></script>

    <script type="text/javascript">
    
    var _param;
    var _searchData; //상세조회 데이타
    $.alopex.page({

        init : function(id, param) { 
            $.PSNM.initialize(id, param); //PSNM공통 초기화함수 호출
            
            _param = param; //이 페이지로 전달된 파라미터를 저장
            
            $a.page.setEventListener();
            $a.page.setImageFileUpload();
            $a.page.setFileUpload();
            $a.page.setData(param);
            $.PSNMAction.setCmntData(param.data.USER_ID, 'N');
            $a.page.setButtonControl(param.data)            
        },
        setEventListener : function() {        
        	$("#btnFaxNo").click( openPopup );
        	$("#btnAddress").click( openPopup );
        	$("#btnEmail").click( openPopup );
        	$("#btnActvCareer").click( openPopup );
        	$("#BtnMbrStHst").click( openPopup );
        	$("#BtnEduHstPopup").click( openPopup );
        	$("#btnFtftHstPopup").click( openPopup );
        	$("#btnCareerMtrCntrt").click( openPopup );
        	$("#btnExcelSaleEx").click( openPopup );
        	$("#btnUnlawSaleEx").click( openPopup );
        	$("#agentCntrt").click( openPopup );
        	$("#btnAplCnsl").click( openPopup );
            $("#btnInitPwd").click(function(){
                if ( !confirm("비밀번호가 회원ID로 초기화됩니다.") ) {
                    return false;
                }
            	$.alopex.request("com.USERMGMT@PUSERMGMT001_pInitPassword", {
            		data: {dataSet: {fields: {"USER_ID" : _searchData.USER_ID}}},
                    success: function(res) {
                    }
                });
            });
            $("#btnBan").click(function(){
            	if( !$.PSNM.confirm("I004", ["승인"] ) ){
                    return false;
                }
      			_searchData.SCRB_ST_CD = "05";
            	openPopup( event );
            });
            $("#btnAccess").click(function(){
            	if( !$.PSNM.confirm("I004", ["승인"] ) ){
                    return false;
                }
            	_searchData.SCRB_ST_CD = "02";
            	openPopup( event );
            });
            $("#btnSave").click(function(){
            	var requestData = $.PSNMUtils.getRequestData("form", "gridfile");
            	requestData = $.extend(true, {dataSet: {fields: _searchData}}, requestData);
            	$.alopex.request("com.USERMGMT@PUSERMGMT001_pSaveUser", {
            		data: requestData,
                    success: function(res) {
                    	 if ( ! $.PSNM.success(res) ) { //서버측 FAIL응답
                    		 return false;
                    	 }
                    	$a.navigate("userInfoMgmtList.jsp", _param);                     
                    }
                });
            });
            $("#btnList").click(function(){
            	$a.back(_param);
            });
            $("#btnFileDel").click(function(){
            	$.PSNMUtils.delFile();
            });
            $("#btnCmntSave").click(function(){
            	var id = _param.data.USER_ID; // 이페이지로 전달된 아이디
            	$.PSNMAction.saveCmntData(id, $("#cmnt"), 'N'); // 댓글저장
            });
        },
        setButtonControl : function( data ){
            switch( data.SCRB_ST_CD ){
                case "02": //가입승인
            		$("#imgFileupload").setEnabled(true);
            		$("#btnSave").setEnabled(true);
            		$("#btnInitPwd").show();
            		$("#btnInitPwd").setEnabled(true);
            		$("#btnAccess").hide();
            		$("#btnBan").show();
            		$("#btnBan").setEnabled(true);
                break;
            	case "04": //해촉
            		$("#imgFileupload").setEnabled(false);
            		$("#btnSave").setEnabled(false);
            		$("#btnInitPwd").show();
            		$("#btnInitPwd").setEnabled(false);
            		$("#btnAccess").hide();
            		$("#btnBan").hide();  
            	break;
            	case "05": //일시정지
            		$("#imgFileupload").setEnabled(false);
            		$("#btnSave").setEnabled(false);
            		$("#btnInitPwd").show();
            		$("#btnInitPwd").setEnabled(false);
            		$("#btnAccess").show();
            		$("#btnAccess").setEnabled(true);
            		$("#btnBan").hide();
            	break;
            	default :
            		$("#imgFileupload").setEnabled(false);
        		    $("#btnSave").setEnabled(false);            		
                	$("#btnInitPwd").hide();
            		$("#btnBan").hide();
            		$("#btnAccess").hide();
                break;
            }

            if( data.ATTC_CAT != "4" ){ //외부사용자만 비밀번호 초기화 가능
        		$("#btnInitPwd").show();
        		$("#btnInitPwd").setEnabled(false);
            }
        },
        setData : function(param) {
        	var user_id = $.PSNMUtils.isNotEmpty(param.data)?param.data.USER_ID:"";
        	
        	$.alopex.request("com.USERMGMT@PUSERMGMT001_pSearchUserDtl", {
        		data: {dataSet: {fields: {"USER_ID" : user_id}}},
                success:["#form", "#gridfile", function(res) {
                	 if ( ! $.PSNM.success(res) ) { //서버측 FAIL응답
                		 return false;
                	 }
                	_searchData = res.dataSet.fields //변경되기 전 데이타 
                	
               	 	var reg = /(^\d{4})(\d{2})(\d{2})(.*)/;
               	 	$("#BIRTH_DT").val( res.dataSet.fields.BIRTH_DT.replace(reg, '$1' + '-' + '$2'+'-'+'$3'));
               	    $("#WEDD_DT").val( res.dataSet.fields.WEDD_DT.replace(reg, '$1' + '-' + '$2'+'-'+'$3'));
               	 
                	if( $.PSNMUtils.isEmpty( _searchData.SALE_DEPT_ORG_NM ) ){
                		$("#form").setData( { SALE_DEPT_ORG :""});
                	}else{
                		$("#form").setData( { SALE_DEPT_ORG :"(" + _searchData.SALE_DEPT_ORG_ID + ") " + _searchData.SALE_DEPT_ORG_NM } );
                	}
                	
                	if( $.PSNMUtils.isEmpty( _searchData.SALE_TEAM_ORG_NM ) ){
                		$("#form").setData( { SALE_TEAM_ORG:""});
                	}else{
                		$("#form").setData( { SALE_TEAM_ORG:"(" + _searchData.SALE_TEAM_ORG_ID + ") " + _searchData.SALE_TEAM_ORG_NM } );
                	}
                	
                	if( $.PSNMUtils.isEmpty( _searchData.AGNT_NM ) ){
                		$("#form").setData( { AGNT:""});
                	}else{
                		$("#form").setData( { AGNT:"(" + _searchData.AGNT_ID + ") " + _searchData.AGNT_NM } );
                	}
                	                		
                	var userAuthList = res.dataSet.recordSets.userAuthGrp.nc_list;
                	var userAuthCnt = res.dataSet.recordSets.userAuthGrp.nc_recordCount;
                	var userAuthNm = [];
                	for( var idx=0; idx < userAuthCnt; ++idx){
                		userAuthNm.push(userAuthList[idx].AUTH_GRP_NM);
                	}
                	$.unique( userAuthNm );
                	$("#form").setData({'USER_AUTH_GRP' : userAuthNm.join(',')});
                	
                    var imgFileUrl = $.PSNMUtils.getDownloadUrl2("PIC", res.dataSet.fields.ATCH_FILE_ID, "", res.dataSet.fields.FILE_PATH);
                    $("#picture").attr("src", imgFileUrl);                          
                }]
            });
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
        setFileUpload : function () {
        	$.PSNMUtils.setFileUploadAndGrid("USR", "#fileupload", "#gridfile");
        }        
    });
    
    function openPopup( event ){
    	var url, title, width, height, modal=true, windowpopup=false, param=null;    	
        
    	switch( event.target.id ){
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
				height = $.PSNM.popHeight(655);
		    break;
            case "btnEmail":     
				url = "com/popupns/emailDupChkPopup";
				title = "E-mail 중복체크";
				width = "590";
				height = "238";
		    break;	
            case "btnActvCareer":
				url = "com/usermgmt/actvCareerPopup";
				param = {USER_ID: _searchData.USER_ID, IS_EXCEL: "Y"};
				title = "활동경력";
				width = "570";
				height = $.PSNM.popHeight(700);            	
            break;
            case "BtnMbrStHst":
				url = "com/usermgmt/mbrStHstPopup";
				param = {USER_ID: _searchData.USER_ID};
				title = "회원상태 이력조회";
				width = "570";
				height = $.PSNM.popHeight(700);               	            	
            break;
            case "BtnEduHstPopup":
				url = "com/usermgmt/eduHstPopup";
				param = {USER_ID: _searchData.USER_ID};
				title = "교육이력 조회";
				width = "680";
				height = $.PSNM.popHeight(700);            	
            break;
            case "btnFtftHstPopup":
				url = "com/usermgmt/ftftHstPopup";
				param = {USER_ID: _searchData.USER_ID};
				title = "면담이력";
				width = $.PSNM.popWidth(950);
				height = "550";             	
            break;     
            case "btnExcelSaleEx":
				url = "com/usermgmt/excelSaleExPopup";
				param = {USER_ID: _searchData.USER_ID};
				title = "우수 영업사례";
				width = $.PSNM.popWidth(800);
				height = $.PSNM.popHeight(700);               	
            break;
            case "btnUnlawSaleEx":
				url = "com/usermgmt/unlawSaleExPopup";
				param = {USER_ID: _searchData.USER_ID};
				title = "불/편법 영업사례";
				width = $.PSNM.popWidth(800);
				height = $.PSNM.popHeight(700);            	
            break;       
            case "btnBan":
            case "btnAccess":
                 url = "com/userinfo/userScrbReqRsnPopup";
                 title = "결재의견";
                 width = "500";
                 height = "235";                     
             break;     
            case "agentCntrt":
            	
            	//화면사이즈구하기
                url = "com/popup/agentCntrtMgmtDtlPop";
                param = {CNTRT_MGMT_NUM : _searchData.CNTRT_MGMT_NUM, cntrtStCd : "readOnly"};
                title = "MA지원서";
                width = $.PSNM.popWidth(1000);
                height = $.PSNM.popHeight(800);
                modal = false;
                windowpopup = true;
            break;  
            case "btnAplCnsl":
                url = "com/usermgmt/agentCnslMgmtDtlPopup";
                param = {APLCNSL_MGMT_NUM : _searchData.APLCNSL_MGMT_NUM};
                title = "MA지원상담";
                width = $.PSNM.popWidth(800);
                height = "600";                     
            break;
    	}

        $a.popup({
            url: url,
            title : title,
            data  : param,
            width : width,
            height: height,
            modal : modal,
            windowpopup: windowpopup,
            callback : function( oResult ) {
            	popupCallback( event.target.id, oResult);
            }
        });
    }
    
    function popupCallback (elemId, oResult){
    	switch (elemId){
    		case "btnFaxNo":
    			$("#form").setData( oResult );
    		break;
    		case "btnAddress":
    			$("#form").setData( oResult );
    			$("#ADDR_2").val("");
    			$("#ADDR_2").focus();
        	break;
    		case "btnEmail":
    			$("#form").setData( oResult );
    		break;
    		case "btnBan":
    		case "btnAccess":    			
            	if( oResult.confirmYN == "N"){
            		return false;
            	}
            	_searchData['SCRB_ST_CHG_RSN'] = oResult.SCRB_ST_CHG_RSN;
            	$.alopex.request("com.USERMGMT@PUSERMGMT001_pSaveTempAccessOrDeny", {            		
            		data: {dataSet: {fields: _searchData}},
                    success: function(res) {
                        if ( ! $.PSNM.success(res) ) { //서버측 FAIL응답
                        	if(elemId=="btnBan"){
                        		_searchData.SCRB_ST_CD = "02";
                        	}if(elemId=="btnAccess"){
                        		_searchData.SCRB_ST_CD = "05";
                        	}
                            return false; 
                        }
                    	$a.page.setButtonControl(_searchData);
                    },
            		fail: function(res){
                    	if(elemId=="btnBan"){
                    		_searchData.SCRB_ST_CD = "02";
                    	}if(elemId=="btnAccess"){
                    		_searchData.SCRB_ST_CD = "05";
                    	}         			
            		}
                });
    		break;
    	}
    }
    </script>

</head>

<body>

<jsp:include page="/view/layouts/default_header.jsp" flush="false" />

<div id="contents">

    <!-- title area -->
    <div class="content_title">
        <div class="ub_txt6">
            <span class="txt6_img"><b>회원정보관리</b><span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif"> 
            <span class="a2">본사업무</span> <span class="a3"> > </span><b>회원정보관리</b></span></span> 
        </div>
    </div>

    <!-- btn area -->
    <div class="btn_area">
        <div class="ab_btn_left">
        	<button id="btnInitPwd" type="button" data-type="button" data-theme="af-btn18"  data-altname="비밀번호초기화" data-authtype="W"></button>
            <button id="btnBan" type="button" data-type="button" data-theme="af-btn42" data-altname="일시접근금지" data-authtype="W"></button>
            <button id="btnAccess" type="button" data-type="button" data-theme="af-btn41" data-altname="일시접근금지해제" data-authtype="W"></button>
        </div>        
        <div class="ab_btn_right">
        	<button id="btnSave" type="button" data-type="button" data-theme="af-btn4"  data-altname="저장" data-authtype="W"></button>
            <button id="btnList" type="button" data-type="button" data-theme="af-btn14" data-altname="목록" data-authtype="R"></button>
        </div>
    </div>
    <!-- btn area end--> 

    <!--view_list area -->
    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>회원정보관리</b> 
    </div>

    <!--view_table area -->
    <div class="view_list">

        <form id="form" onsubmit="return false;">
            <input id="ATCH_FILE_ID" name="ATCH_FILE_ID" data-bind="value:ATCH_FILE_ID" type="hidden" data-type="textinput" />
            <input id="BEFORE_ATCH_FILE_ID" name="BEFORE_ATCH_FILE_ID" data-bind="value:ATCH_FILE_ID" type="hidden" data-type="textinput" />
            <input id="FILE_PATH" name="FILE_PATH" data-bind="value:FILE_PATH" type="hidden" data-type="textinput" />
			<input id="FILE_NM" name="FILE_NM" data-bind="value:FILE_NM" type="hidden" data-type="textinput" />
			<input id="FILE_SIZE" name="FILE_SIZE" data-bind="value:FILE_SIZE" type="hidden" data-type="textinput" />			
	            <table class="board02" style="width:100%;">
	            <colgroup>
			    	<col style="width:15%">
			    	<col style="width:35%">
			    	<col style="width:15%">
			    	<col style="width:*">
			    	<col style="width:11%">
	            </colgroup>
	            <tbody>
	            <tr>
	                <th scope="col">사용자ID</th>
			        <td class="tleft">
			        	<label data-bind="text:USER_ID"></label>
			        	<!-- input type="hidden" name="USER_ID" id="USER_ID" data-type="textinput" data-bind="value:USER_ID" -->
			        </td>
			        <th >사용자명</th>
			        <td class="tleft"><label data-bind="text:USER_NM_M"></label></td>
			        <td rowspan="6" class="tleft1">
			        	<img id="picture" src="" alt="" width="114" height="154" onerror='this.src="<c:out value='${pageContext.request.contextPath}'/>/image/adminbox-sample-img.gif"'>
			        	<div style="position:relative; top:2px">
							<span class="file-button type3" style="display:block;float:none;margin:7px auto"><input type="file" id="imgFileupload" data-type="button"></span>
						</div>
						<button id="agentCntrt" type="button" data-type="button" data-theme="af-btn19" data-authtype="R"></button>
			        </td>
				</tr>
				<tr>
				    <th  scope="col">닉네임</th>
			        <td colspan="3" class="tleft"><label data-bind="text:NICK_NM"></label></td>
				</tr>
				<tr>
				    <th  scope="col">직무</th>
			        <td class="tleft">(<label data-bind="text:DUTY_CD"></label>)&nbsp;<label data-bind="text:DUTY_NM"></label>
			        	<input type="hidden" name="DUTY_CD" data-bind="value:DUTY_CD" data-type="textinput">
			        </td>
			        <th>본사팀</th>
			        <td class="tleft">(<label data-bind="text:HDQT_TEAM_ORG_ID"></label>)&nbsp;<label data-bind="text:HDQT_TEAM_ORG_NM"></label></td>
			    <tr>
			        <th height="33"  scope="col">본사파트</th>
			        <td class="tleft">(<label data-bind="text:HDQT_PART_ORG_ID"></label>)&nbsp;<label data-bind="text:HDQT_PART_ORG_NM"></label></td>
			        <th>영업국명</th>
			        <td class="tleft"><label data-bind="text:SALE_DEPT_ORG"></label></td>
			    </tr>
			    <tr>
			        <th  scope="col">영업팀명</th>
			        <td class="tleft"><label data-bind="text:SALE_TEAM_ORG"></label></td>
			        <th>에이전트명</th>
			        <td class="tleft"><label data-bind="text:AGNT"></label></td>
			    </tr>
			    <tr>
			        <th  scope="col">주업무</th>
			        <td colspan="3" class="tleft">
			        <textarea id="MAIN_JOB" name="MAIN_JOB" data-type="textarea" data-bind="value:MAIN_JOB" cols="40" rows="1" style="width:98%" data-theme="af-textarea"></textarea>
			        </td>
			    </tr>
			    <tr>
			        <th  scope="col">현주소(실거주지)</th>
			        <td colspan="4" class="tleft">
						<input id="POST_NUM1" data-bind="value:POST_NUM1" data-type="textinput" value="" size="4" data-disabled="true"
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
			        <th  scope="col">전화번호</th>
			        <td class="tleft">
		              	<input id="PHON_NUM1" data-bind="value:PHON_NUM1" data-type="textinput" size="4" data-keyfilter-rule="digits" maxlength="4"
					      		data-validation-rule="{required:true}" 
								data-validation-message="{required:$.PSNM.msg('E012', ['전화번호'])}">
					        -
					        <input id="PHON_NUM2" data-bind="value:PHON_NUM2" data-type="textinput" value="" size="4" data-keyfilter-rule="digits" maxlength="4"
					        	data-validation-rule="{required:true}" 
								data-validation-message="{required:$.PSNM.msg('E012', ['전화번호'])}">
					        -
					        <input id="PHON_NUM3" data-bind="value:PHON_NUM3" data-type="textinput" value="" size="4" data-keyfilter-rule="digits" maxlength="4"
					        	data-validation-rule="{required:true}" 
								data-validation-message="{required:$.PSNM.msg('E012', ['전화번호'])}">
			        </td>
			        <th>이동전화</th>
			        <td colspan="2" class="tleft">
			        	<input name="TEL_CO_CD" id="TEL_CO_CD" data-type="textinput" data-bind="value:TEL_CO_CD" size="4">
        				<input id="MBL_PHON_NUM1" data-bind="value:MBL_PHON_NUM1" data-type="textinput" size="4" data-keyfilter-rule="digits" maxlength="3"
        					data-validation-rule="{required:true}" 
							data-validation-message="{required:$.PSNM.msg('E012', ['이동전화'])}">
        				-
				        <input id="MBL_PHON_NUM2" data-bind="value:MBL_PHON_NUM2" data-type="textinput" size="4" data-keyfilter-rule="digits" maxlength="4"
				        	data-validation-rule="{required:true}" 
							data-validation-message="{required:$.PSNM.msg('E012', ['이동전화'])}">
				        -
				        <input id="MBL_PHON_NUM3" data-bind="value:MBL_PHON_NUM3" data-type="textinput" size="4" data-keyfilter-rule="digits" maxlength="4"
				        	data-validation-rule="{required:true}" 
							data-validation-message="{required:$.PSNM.msg('E012', ['이동전화'])}">
			        </td>
			    </tr>
			    <tr>
			        <th  scope="col">FAX번호</th>
			        <td colspan="4" class="tleft">
				        <input id="FAX_NUM1" data-bind="value:FAX_NUM1" data-disabled="true" data-type="textinput" size="11"
				      		data-validation-rule="{required:true}" 
							data-validation-message="{required:$.PSNM.msg('E012', ['FAX 번호'])}">
				        -
				        <input id="FAX_NUM2" data-bind="value:FAX_NUM2" data-disabled="true" data-type="textinput" size="11"
				      		data-validation-rule="{required:true}" 
							data-validation-message="{required:$.PSNM.msg('E012', ['FAX 번호'])}">
				        -
				        <input id="FAX_NUM3" data-bind="value:FAX_NUM3" data-disabled="true" data-type="textinput" size="11"
				            data-validation-rule="{required:true}" 
							data-validation-message="{required:$.PSNM.msg('E012', ['FAX 번호'])}">
				        <input id="btnFaxNo" type="button" data-type="button" data-theme="af-n-btn4">
			        </td>
			    </tr>
			    <tr>
			        <th  scope="col">생년월일</th>
			        <td class="tleft">
			        	<input id="BIRTH_DT" data-bind="value:BIRTH_DT" data-type="dateinput" style="width:70px;" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			        	<input type="radio" name="BIRTH_LUNAR_YN" value="Y" data-bind="checked:BIRTH_LUNAR_YN" data-type="radio">
        				음력
        				<input type="radio" name="BIRTH_LUNAR_YN" value="N" data-bind="checked:BIRTH_LUNAR_YN" data-type="radio">
        				양력
					</td>
			        <th>결혼유무
			        </th>
			        <td colspan="2" class="tleft">
				      	<select id="WEDD_YN" name="WEDD_YN" data-bind="selectedOptions: WEDD_YN" data-type="select" onchange="this.value=='Y'?$('#WEDD_DT').setEnabled(true):$('#WEDD_DT').setEnabled(false);$('#WEDD_DT').val('')">
				      		<option value="">미선택</option>
				      		<option value="Y">기혼</option>
				      		<option value="N">미혼</option>
				      	</select>		        
			        </td>
			    </tr>
			    <tr>
			        <th  scope="col">이메일 수신동의</th>
			        <td class="tleft">
			        	<input type="radio" name="EMAIL_RCV_AGREE_YN" value="Y" data-bind="checked:EMAIL_RCV_AGREE_YN" data-type="radio">
        				동의
        				<input type="radio" name="EMAIL_RCV_AGREE_YN" data-bind="checked:EMAIL_RCV_AGREE_YN" value="N" data-type="radio">
        				미동의
        			</td>
			        <th>결혼기념일</th>
			        <td colspan="2" class="tleft">
			        	<input id="WEDD_DT" data-bind="value:WEDD_DT" data-type="dateinput" style="width:70px;" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png">
			        </td>
			    </tr>
			    <tr>
			        <th  scope="col">이메일</th>
			        <td class="tleft">
						<input id="EMAIL_ID" data-bind="value:EMAIL_ID" data-type="textinput" data-disabled="true"
							data-validation-rule="{required:true}" 
							data-validation-message="{required:$.PSNM.msg('E012', ['이메일'])}">
						@
						<input id="EMAIL_DMN_NM" data-bind="value:EMAIL_DMN_NM" data-type="textinput" data-disabled="true"
						   	data-validation-rule="{required:true}" 
							data-validation-message="{required:$.PSNM.msg('E012', ['이메일'])}">
						<input id="EMAIL_DMN_CD" data-bind="value:EMAIL_DMN_CD" data-type="textinput" type="hidden">
						<input id="btnEmail" type="button" data-type="button" data-theme="af-n-btn4">			        
			        </td>
					<th>MA지원상담</th>
			        <td colspan="2" class="tleft">
			        	<button id="btnAplCnsl" type="button" data-type="button" data-theme="af-n-btn16" data-authtype="R" data-altname="상세조회" class="af-button af-n-btn16"></button>
			        </td>
			    </tr>
			    <tr>
			        <th scope="col">가입일자</th>
			        <td class="tleft"><label data-bind="text:RGST_DTM"></label></td>
					<th>매출발생일자</th>
			        <td colspan="2" class="tleft"><label data-bind="text:SALE_OCCR_DT"></label></td>
			    </tr>
			    <tr>
			        <th scope="col">활동경력</th>
			        <td class="tleft">
			        	<label data-bind="text:CAREER_YEAR"></label>년 <label data-bind="text:CAREER_MONTH"></label>월
			        	<button id="btnActvCareer" type="button" data-type="button" data-theme="af-n-btn16" data-authtype="R" data-altname="상세조회" class="af-button af-n-btn16"></button>
			        </td>
					<th>상태</th>
			        <td colspan="2" class="tleft">
			        	<label data-bind="text:COMM_CD_VAL_NM"></label>
			        	<button id="BtnMbrStHst" type="button" data-type="button" data-theme="af-n-btn16" data-authtype="R" data-altname="상세조회" class="af-button af-n-btn16"></button>
			        </td>
			    </tr>
			    <tr>
			        <th scope="col">면담이력</th>
			        <td class="tleft"><button id="btnFtftHstPopup" type="button" data-type="button" data-theme="af-n-btn16" data-authtype="R" data-altname="상세조회" class="af-button af-n-btn16"></button></td>
					<th>교육이력</th>
			        <td colspan="2" class="tleft"><button id="BtnEduHstPopup" type="button" data-type="button" data-theme="af-n-btn16" data-authtype="R" data-altname="상세조회" class="af-button af-n-btn16"></button></td>
			    </tr>
			    <tr>
			        <th scope="col">SMS수신동의</th>
			        <td colspan="1"class="tleft">
			        	<input type="radio" name="SMS_RCV_AGREE_YN" value="Y" data-bind="checked:SMS_RCV_AGREE_YN" data-type="radio">
        				동의
        				<input type="radio" name="SMS_RCV_AGREE_YN" data-bind="checked:SMS_RCV_AGREE_YN" value="N" data-type="radio">
        				미동의
			        </td>
					<th>권한</th>
			        <td colspan="2" class="tleft"><label data-bind="text:USER_AUTH_GRP"></label></td>
			    </tr>
			    <tr>
			        <th scope="col">우수 영업사례</th>
			        <td class="tleft"><button id="btnExcelSaleEx" type="button" data-type="button" data-theme="af-n-btn16" data-authtype="R" data-altname="상세조회" class="af-button af-n-btn16"></button></td>
					<th>불/편법 영업사례</th>
			        <td colspan="2" class="tleft"><button id="btnUnlawSaleEx" type="button" data-type="button" data-theme="af-n-btn16" data-authtype="R" data-altname="상세조회" class="af-button af-n-btn16"></button></td>
			    </tr>
			    <tr>
			        <th scope="col">메모</th>
			        <td colspan="4"class="tleft"><label data-bind="text:MEMO"></label></td>
			    </tr>	    
	            </tbody>
            </table>
        </form>
    </div>
    <!--view_list area -->
    <div class="floatL4">
		<img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>첨부파일</b> : 하단 파일을 클릭하시면 저장 및 열기가 가능합니다.
    	<div class="ab_pos1" style="float:right;">
      		<div style="position:relative;">
				<span class="file-button type1"><input id="fileupload" type="file"></span>
				<button id="btnFileDel" data-type="button" class="af-n-btn5"></button>
      		</div>
    	</div>
  	</div>
    <div id="gridfile" class="view_list" data-bind="grid:gridfile"></div>
    <div id="cmntArea">
  		<jsp:include page="/view/layouts/cmnt_comm.jsp" flush="false">
  			<jsp:param name="use" value="userInfo" />
  			<jsp:param name="IS_HEAD" value="N" />
  		</jsp:include>
 	</div>
</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>