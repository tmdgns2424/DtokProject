<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
    var field; //상세조회 데이타
    $.alopex.page({

        init : function(id, param) { 
            $.PSNM.initialize(id, param); //PSNM공통 초기화함수 호출
            
            _param = param; //이 페이지로 전달된 파라미터를 저장
            
            $a.page.setEventListener();
            //$a.page.setFileUpload();
            $a.page.setData(param);
            //$.PSNMAction.setCmntData(param.data.DSM_SALES_PLCY_ID); // 댓글조회(이페이지로 전달된 아이디)
        },
        setEventListener : function() {
        	
            $("#btnAppr, #btnReturn").click(function(event){
            	var msg;
            	if(event.target.id == 'btnAppr'){
            		msg = '승인';
            	}else{
            		msg = '반려';
            	}
            	
            	if(  $.PSNM.confirm("I004", [msg] ) ){
            		$a.page.openRsnPopup( event.target.id );
           		}
            });
            $("#btnList").click(function(){
            	$a.back(_param);
            });
            /*
            $("#btnCmntSave").click(function(){
            	var dsmContId = _param.data.DSM_SALES_PLCY_ID; // 이페이지로 전달된 아이디
            	$.PSNMAction.saveCmntData(dsmContId, $("#cmnt")); // 댓글저장
            });
            */
        },
        setData : function(param) {
        	var req_seq = $.PSNMUtils.isNotEmpty(param.data)?param.data.SCRB_REQ_SEQ:"";
        	var user_id = $.PSNMUtils.isNotEmpty(param.data)?param.data.USER_ID:"";
        	
        	$.alopex.request("com.USERINFO@PUSERSCRBREQ001_pSearchUserScrbReqDtl", {
        		data: {dataSet: {fields: {"SCRB_REQ_SEQ" : req_seq, "USER_ID" : user_id}}},
                success:["#form", function(res) {
	               	if ( ! $.PSNM.success(res) ) { //서버측 FAIL응답
	            	 	return false;
	            	}
                    detailDs = res.dataSet;                	
                    
                    var imgFileUrl = $.PSNMUtils.getDownloadUrl2("PIC", res.dataSet.fields.ATCH_FILE_ID, "", res.dataSet.fields.FILE_PATH);
                    $("#picture").attr("src", imgFileUrl);
                	
                	var userAuthList = res.dataSet.recordSets.userAuthGrp.nc_list;
                	var userAuthCnt = res.dataSet.recordSets.userAuthGrp.nc_recordCount;
                	var userAuthNm = [];
                	for( var idx=0; idx < userAuthCnt; ++idx){
                		userAuthNm.push(userAuthList[idx].AUTH_GRP_NM);
                	}
                	$.unique( userAuthNm );
                	$("#form").setData({'USER_AUTH_GRP' : userAuthNm.join(',')});
                	
                	switch (res.dataSet.fields.SCRB_ST_CD){
                		case '01' :
                    		$("#btnAppr").setEnabled(true);
                    		$("#btnReturn").setEnabled(true);
                			break;
                		case '03' :
                    		$("#btnAppr").setEnabled(false);
                			$("#btnReturn").setEnabled(false);              
                			break;
                	}
                }]
            });
        },
        /*
        setFileUpload : function () {
        	$.PSNMUtils.setFileUploadAndGrid("DSM", "#fileupload", "#gridfile");
        }
        */
        openRsnPopup : function( srcId ) {
        	$a.popup({                		
                url: "com/userinfo/userScrbReqRsnPopup",
                title : "결재의견",
                width: 500,
                height: 235,
                windowpopup: false,
                iframe: true,
                callback: function (data) {
                	if( data.confirmYN == "N"){
                		return false;
                	}
                	var requestData = $.PSNMUtils.getRequestData("form");
                	                	
                	requestData.dataSet.fields = detailDs.fields;                	
                	requestData.dataSet.fields.SCRB_ST_CHG_RSN = data;
					
                	if( srcId == 'btnAppr' ){ //승인
                		requestData.dataSet.fields.SCRB_ST_CD = "02";
                	}else{ //반려
                		requestData.dataSet.fields.SCRB_ST_CD = "03";
                	}
                	
                	$.alopex.request("com.USERINFO@PUSERSCRBREQ001_pApprUserScrbReq", {
                		data: requestData,
                        success: function(res) {
        	               	if ( ! $.PSNM.success(res) ) { //서버측 FAIL응답
        	            	 	return false;
        	            	}
                        	$("#btnList").click();
                        }
                    });                	
                }                        
            });  
        }
    });
    
    </script>

</head>

<body>

<jsp:include page="/view/layouts/default_header.jsp" flush="false" />

<div id="contents">

    <!-- title area -->
    <div class="content_title">
        <div class="ub_txt6">
            <span class="txt6_img"><b>회원가입요청관리</b><span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif"> 
            <span class="a2"></span> <span class="a3"> > </span> <span class="a4"></span> 
        </div>
    </div>

    <!-- btn area -->
    <div class="btn_area">
            <div class="ab_btn_left">
            <button id="btnAppr" type="button" data-type="button" data-theme="af-btn5" data-altname="승인" data-authtype="W"></button>
            <button id="btnReturn" type="button" data-type="button" data-theme="af-btn6" data-altname="반려" data-authtype="W"></button>
        </div>
        <div class="ab_btn_right">
            <button id="btnList" type="button" data-type="button" data-theme="af-btn14" data-altname="목록" data-authtype="R"></button>
        </div>
    </div>
    <!-- btn area end--> 

    <!--view_list area -->
    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>회원가입요청관리</b> 
    </div>

    <!--view_table area -->
    <div class="view_list">

        <form id="form" onsubmit="return false;">
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
			        <td class="tleft"><label data-bind="text:USER_ID"></label></td>
			        <th >사용자명</th>
			        <td class="tleft"><label data-bind="text:M_USER_NM"></label></td>
			        <td rowspan="4" class="tleft1"><img id="picture" src="" alt="" width="114" height="154" onerror='this.src="<c:out value='${pageContext.request.contextPath}'/>/image/adminbox-sample-img.gif"'></td>
				</tr>
				<tr>
				    <th  scope="col">닉네임</th>
			        <td colspan="3" class="tleft"><label data-bind="text:NICK_NM"></label></td>
				</tr>
				<tr>
				    <th  scope="col">직무</th>
			        <td class="tleft">(<label data-bind="text:DUTY"></label>)&nbsp;<label data-bind="text:DUTY_NM"></label></td>
			        <th>회원가입요청일시</th>
			        <td class="tleft"><label data-bind="text:REQ_DTM"></label></td>
			    <tr>
			        <th height="33"  scope="col">본사팀</th>
			        <td class="tleft">(<label data-bind="text:HDQT_TEAM_ORG_ID"></label>)&nbsp;<label data-bind="text:HDQT_TEAM_ORG_NM"></label></td>
			        <th>영업국명</th>
			        <td class="tleft">(<label data-bind="text:SALE_DEPT_ORG_ID"></label>)&nbsp;<label data-bind="text:SALE_DEPT_ORG_NM"></label></td>
			    </tr>
			    <tr>
			        <th  scope="col">영업팀명</th>
			        <td class="tleft">(<label data-bind="text:SALE_TEAM_ORG_ID"></label>)&nbsp;<label data-bind="text:SALE_TEAM_ORG_NM"></label></td>
			        <th>에이전트명</th>
			        <td colspan="2" class="tleft">(<label data-bind="text:AGNT_ID"></label>)&nbsp;<label data-bind="text:AGNT_NM"></label></td>
			    </tr>
			    <tr>
			        <th  scope="col">주업무</th>
			        <td colspan="4" class="tleft"><label data-bind="text:MAIN_JOB"></label></td>
			    </tr>
			    <tr>
			        <th  scope="col">현주소</th>
			        <td colspan="4" class="tleft"><label data-bind="text:POST_NUM_1"></label>-<label data-bind="text:POST_NUM_2"></label>&nbsp;<label data-bind="text:ADDR_1"></label>&nbsp;<label data-bind="text:ADDR_2"></label></td>
			    </tr>
			    <tr>
			        <th  scope="col">전화번호</th>
			        <td class="tleft"><label data-bind="text:PHON_NUM1"></label>-<label data-bind="text:PHON_NUM2"></label>-<label data-bind="text:PHON_NUM3"></label></td>
			        <th>이동전화</th>
			        <td colspan="2" class="tleft"><label data-bind="text:TEL_CO_CD"></label>&nbsp;<label data-bind="text:MBL_PHON_NUM1"></label>-<label data-bind="text:MBL_PHON_NUM2"></label>-<label data-bind="text:MBL_PHON_NUM3"></label></td>
			    </tr>
			    <tr>
			        <th  scope="col">FAX번호</th>
			        <td colspan="4" class="tleft"><label data-bind="text:FAX_NUM1"></label>-<label data-bind="text:FAX_NUM2"></label>-<label data-bind="text:FAX_NUM3"></label></td>
			    </tr>
			    <tr>
			        <th  scope="col">생년월일</th>
			        <td class="tleft"><label data-bind="text:BIRTH_DT"></label></td>
			        <th>결혼유무</th>
			        <td colspan="2" class="tleft"><label data-bind="text:WEDD_YN_NM"></label></td>
			    </tr>
			    <tr>
			        <th  scope="col">이메일 수신동의</th>
			        <td class="tleft"><label data-bind="text:EMAIL_RCV_AGREE"></label></td>
			        <th>결혼기념일</th>
			        <td colspan="2" class="tleft"><label data-bind="text:WEDD_DT"></label></td>
			    </tr>
			    <tr>
			        <th  scope="col">이메일</th>
			        <td class="tleft"><label data-bind="text:EMAIL_ID"></label>@<label data-bind="text:EMAIL_DMN_NM"></label></td>
			        <th  scope="col">권한</th>
			        <td colspan="2" class="tleft"><label data-bind="text:USER_AUTH_GRP"></label></td>			        
			    </tr>
			    <tr>
			        <th  scope="col">메모</th>
			        <td colspan="4" class="tleft"><label data-bind="text:MEMO"></label></td>
			    </tr>
	            </tbody>
            </table>
        </form>
    </div>
</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>