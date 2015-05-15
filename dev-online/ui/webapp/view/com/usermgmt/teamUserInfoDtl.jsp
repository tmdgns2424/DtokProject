<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

    <jsp:include page="/view/layouts/default_head.jsp" flush="false" />
    <script type="text/javascript">
    
    var _param;
    var _searchData; //상세조회 데이타
    $.alopex.page({

        init : function(id, param) { 
            $.PSNM.initialize(id, param); //PSNM공통 초기화함수 호출
            
            _param = param; //이 페이지로 전달된 파라미터를 저장            
            $a.page.setEventListener();
            $a.page.setData(param);        
        },
        setEventListener : function() {        
        	$("#btnActvCareer").click( openPopup );
        	$("#BtnMbrStHst").click( openPopup );
        	$("#BtnEduHstPopup").click( openPopup );
        	$("#btnFtftHstPopup").click( openPopup );
        	$("#btnCareerMtrCntrt").click( openPopup );
        	$("#btnExcelSaleEx").click( openPopup );
        	$("#btnUnlawSaleEx").click( openPopup );

            $("#btnSave").click(function(){
            	var requestData = $.PSNMUtils.getRequestData("form", "comment");
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
        },        
        setData : function(param) {
        	var user_id = $.PSNMUtils.isNotEmpty(param.data)?param.data.USER_ID:"";
        	
        	$.alopex.request("com.USERMGMT@PUSERMGMT001_pSearchUserDtl", {
        		data: {dataSet: {fields: {"USER_ID" : user_id}}},
                success:["#form", function(res) {
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
    });
    
    function openPopup( event ){
    	var url, title, width, height, windowpopup=false, param=null;
    	
    	switch( event.target.id ){	
            case "btnActvCareer":
				url = "com/usermgmt/actvCareerPopup";
				param = {USER_ID: _searchData.USER_ID};
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
            case "btnCareerMtrCntrt":
				url = "com/usermgmt/careerMtrCntrtPopup";
				param = {USER_ID: _searchData.USER_ID};
				title = "경력사항(계약 후)";
				width = "680";
				height = $.PSNM.popHeight(700);           	
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
    	}

        $a.popup({
            url: url,
            title : title,
            data  : param,
            width : width,
            height: height,
            windowpopup: windowpopup,
            callback : function( oResult ) {
            	popupCallback( event.target.id, oResult);
            }
        });
    }
    
    function popupCallback (elemId, oResult){
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
            <input id="FILE_PATH" name="FILE_PATH" data-bind="value:FILE_PATH" type="hidden" data-type="textinput" />
			<input id="FILE_NM" name="FILE_NM" data-bind="value:FILE_NM" type="hidden" data-type="textinput" />
			<input id="FILE_SIZE" name="FILE_SIZE" data-bind="value:FILE_SIZE" type="hidden" data-type="textinput" />
	            <table class="board02" style="width:100%;">
	            <colgroup>
		            <col style="width:15%"/>
		            <col style="width:35%"/>
		            <col style="width:13%"/>
		            <col style="width:26%"/>
		            <col style="width:*"/>
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
			        <td rowspan="5" class="tleft1">
			        	<img id="picture" src="" alt="" width="114" height="154" onerror='this.src="<c:out value='${pageContext.request.contextPath}'/>/image/adminbox-sample-img.gif"'>
			        </td>
				</tr>
				<tr>
				    <th scope="col">닉네임</th>
			        <td colspan="3" class="tleft"><label data-bind="text:NICK_NM"></label></td>
				</tr>
				<tr>
				    <th scope="col">직무</th>
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
			        <td colspan="4" class="tleft">
			        <textarea id="MAIN_JOB" name="MAIN_JOB" data-type="textarea" data-bind="value:MAIN_JOB" cols="40" rows="1" style="width:98%" data-theme="af-textarea" data-disabled="true"></textarea>
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
				        </br><input id="ADDR_1" data-bind="value:ADDR_1" data-type="textinput" style="width:350px" value="" data-disabled="true">
				        <input id="ADDR_2" data-bind="value:ADDR_2" data-type="textinput" style="width:350px" value=""  data-disabled="true"
				        	data-validation-rule="{required:true}" 
							data-validation-message="{required:$.PSNM.msg('E012', ['상세주소'])}">			        
			        </td>
			    </tr>
			    <tr>
			        <th  scope="col">전화번호</th>
			        <td class="tleft">
		              	<input id="PHON_NUM1" data-bind="value:PHON_NUM1" data-type="textinput" size="4" data-keyfilter-rule="digits" data-disabled="true"
					      		data-validation-rule="{required:true}" 
								data-validation-message="{required:$.PSNM.msg('E012', ['전화번호'])}">
					        -
					        <input id="PHON_NUM2" data-bind="value:PHON_NUM2" data-type="textinput" value="" size="4" data-keyfilter-rule="digits" data-disabled="true"
					        	data-validation-rule="{required:true}" 
								data-validation-message="{required:$.PSNM.msg('E012', ['전화번호'])}">
					        -
					        <input id="PHON_NUM3" data-bind="value:PHON_NUM3" data-type="textinput" value="" size="4" data-keyfilter-rule="digits" data-disabled="true"
					        	data-validation-rule="{required:true}" 
								data-validation-message="{required:$.PSNM.msg('E012', ['전화번호'])}">
			        </td>
			        <th>이동전화</th>
			        <td colspan="2" class="tleft">
			        	<input name="TEL_CO_CD" id="TEL_CO_CD" data-type="textinput" data-bind="value:TEL_CO_CD" size="4" data-disabled="true">
        				<input id="MBL_PHON_NUM1" data-bind="value:MBL_PHON_NUM1" data-type="textinput" size="4" data-disabled="true" 
        					data-validation-rule="{required:true}" 
							data-validation-message="{required:$.PSNM.msg('E012', ['이동전화'])}">
        				-
				        <input id="MBL_PHON_NUM2" data-bind="value:MBL_PHON_NUM2" data-type="textinput" size="4" data-disabled="true"
				        	data-validation-rule="{required:true}" 
							data-validation-message="{required:$.PSNM.msg('E012', ['이동전화'])}">
				        -
				        <input id="MBL_PHON_NUM3" data-bind="value:MBL_PHON_NUM3" data-type="textinput" size="4" data-disabled="true"
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
			        </td>
			    </tr>
			    <tr>
			        <th  scope="col">생년월일</th>
			        <td class="tleft">
			        	<input id="BIRTH_DT" data-bind="value:BIRTH_DT" data-type="dateinput" style="width:70px;" data-disabled="true" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			        	<input type="radio" name="BIRTH_LUNAR_YN" value="Y" data-bind="checked:BIRTH_LUNAR_YN" data-type="radio" data-disabled="true">
        				음력
        				<input type="radio" name="BIRTH_LUNAR_YN" value="N" data-bind="checked:BIRTH_LUNAR_YN" data-type="radio" data-disabled="true">
        				양력
					</td>
			        <th>결혼유무
			        </th>
			        <td colspan="2" class="tleft">
						<input type="radio" name="WEDD_YN" value="Y" data-bind="checked:WEDD_YN" data-type="radio" data-disabled="true">
        				기혼
        				<input type="radio" name="WEDD_YN" value="N" data-bind="checked:WEDD_YN" data-type="radio" data-disabled="true">
        				미혼			        
			        </td>
			    </tr>
			    <tr>
			        <th  scope="col">이메일 수신동의</th>
			        <td class="tleft">
			        	<input type="radio" name="EMAIL_RCV_AGREE_YN" value="Y" data-bind="checked:EMAIL_RCV_AGREE_YN" data-type="radio" data-disabled="true">
        				동의
        				<input type="radio" name="EMAIL_RCV_AGREE_YN" data-bind="checked:EMAIL_RCV_AGREE_YN" value="N" data-type="radio" data-disabled="true">
        				미동의
        			</td>
			        <th>결혼기념일</th>
			        <td colspan="2" class="tleft">
			        	<input id="WEDD_DT" data-bind="value:WEDD_DT" data-type="dateinput" style="width:70px;" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png" data-disabled="true">
			        </td>
			    </tr>
			    <tr>
			        <th  scope="col">이메일</th>
			        <td colspan="4" class="tleft">
						<input id="EMAIL_ID" data-bind="value:EMAIL_ID" data-type="textinput" data-disabled="true"
							data-validation-rule="{required:true}" 
							data-validation-message="{required:$.PSNM.msg('E012', ['이메일'])}">
						@
						<input id="EMAIL_DMN_NM" data-bind="value:EMAIL_DMN_NM" data-type="textinput" data-disabled="true"
						   	data-validation-rule="{required:true}" 
							data-validation-message="{required:$.PSNM.msg('E012', ['이메일'])}">
						<input id="EMAIL_DMN_CD" data-bind="value:EMAIL_DMN_CD" data-type="textinput" type="hidden">			        
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
			        	<input type="radio" name="SMS_RCV_AGREE_YN" value="Y" data-bind="checked:SMS_RCV_AGREE_YN" data-type="radio" data-disabled="true">
        				동의
        				<input type="radio" name="SMS_RCV_AGREE_YN" data-bind="checked:SMS_RCV_AGREE_YN" value="N" data-type="radio" data-disabled="true">
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
</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>