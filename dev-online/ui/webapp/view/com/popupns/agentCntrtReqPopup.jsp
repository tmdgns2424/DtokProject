<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>MA 지원</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />

    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/psnm-ns.js"></script>
	<script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/vendor/jquery.ui.widget.js"></script>
	<script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/jquery.iframe-transport.js"></script>
	<script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/jquery.fileupload.js"></script>
    
    <script type="text/javascript">
    
    $a.page({
        init : function(id, param) {
        	$a.page.setEventListener();
            $a.page.setCodeData();
            $a.page.setImageFileUpload();
            $a.page.setGridSchship();          //그리드 초기화
            $a.page.setGridCareer(); 
            $.PSNMNS.setBasicOrgSelectBox();
            //$a.page.setViewBtn();
        },
        setEventListener : function() {
            $("#EMAIL_DMN_CD").change( changeEmailDomain );
            $("#btnAddress").click( addOpenPopup );

            $("#AGREE_Y1").click( setViewObject );   //개인정보 수집 및 이용1 동의 클릭
            $("#AGREE_N1").click( setViewObject );  //개인정보 수집 및 이용1 미동의 클릭
            $("#AGREE_Y2").click( setViewObject );   //개인정보 수집 및 이용2 동의 클릭
            $("#AGREE_N2").click( setViewObject );  //개인정보 수집 및 이용2 미동의 클릭
            $("#DEPT_Y").click( setViewObject );
            $("#DEPT_N").click( setViewObject );            

            $("#btnAcademyAdd").click( addOpenPopup );  //학력추가 클릭
            $("#btnAcademyDel").click( delRow );        //학력삭제 클릭
            $("#btnCareerAdd").click( addOpenPopup );  //경력추가 클릭
            $("#btnCareerDel").click( delRow );        //경력삭제 클릭
            
            $("#DSM_RETL_TYPE").change( changeRetlType );   //판매형태         
            
            $("#btnConfirm").click( saveConfirm );  //지원요청 클릭
            $("#btnCancel").click( closeWithout ); //지원취소 클릭
            $("#btnGuide").click( addOpenPopup );  //MA 지원서 작성 방법
            
        },      
        setCodeData : function() {
            
            $.PSNMUtils.setCodeData([
                { t:'code', 'elemid' : 'DSM_RETL_TYPE', 'codeid' : 'DSM_RETL_TYPE', 'header' : '-선택-', 'ADD_INFO_01' : 'Y' },   //판매형태
                { t:'code', 'elemid' : 'PHON_NUM1', 'codeid' : 'TEL_FRST_NO', 'header' : '-선택-' },   //자택전화
                { t:'code', 'elemid' : 'MBL_PHON_NUM1', 'codeid' : 'HP_FRST_NO', 'header' : '-선택-' },   //이동전화
                { t:'code', 'elemid' : 'EMAIL_DMN_CD',  'codeid' : 'EMAIL_ACC',  'header' : '-선택-', 'ADD_INFO_01' : 'Y'},
                
                
                //{ t:'org1', 'elemid' : 'HDQT_TEAM_ORG_ID', 'header' : '-전체-' },
                //{ t:'org2', 'elemid' : 'HDQT_PART_ORG_ID', 'header' : '-전체-' }, //REQ_OUT_ORG_ID
                //{ t:'org3', 'elemid' : 'SALE_DEPT_ORG_ID', 'header' : '-전체-' },  //REQ_DSM_HEADQ_CD                
            ]);
            
        },
        setImageFileUpload : function() {
            var oMyPicFileInfo = new Object();
            $("#fileupload").fileupload({
                dataType: 'json',
                url : _FILE_HANDLER_URL + "?biz=cnt",
                done: function (e, data) {
                    $.each(data.result, function (index, fileinfo) {
                        var regex = /\.([j|J][p|P][g|G]|[j|J][p|P][e|E][g|G]|[g|G][i|I][f|F]|[p|P][n|N][g|G])$/; 
                        if (!regex.test(fileinfo.name)) { 
                            $.PSNM.alert("확장자가 jpg, jpeg, gif인 파일만 등록할 수 있습니다."); 
                            return false; 
                        }
                        
                        oMyPicFileInfo["FILE_GRP_ID"] = fileinfo.group
                        oMyPicFileInfo["FILE_PATH"] = fileinfo.dir
                        oMyPicFileInfo["ATCH_FILE_ID"] = fileinfo.id
                        oMyPicFileInfo["FILE_NM"] = fileinfo.name
                        $("#ATCH_FILE_ID").val(fileinfo.id); 
                        $("#FILE_NM").val(fileinfo.name);
                        $("#FILE_PATH").val(fileinfo.dir);
                        $("#FILE_SIZE").val(fileinfo.size);
                        
                        var imgFileUrl = $.PSNMUtils.getDownloadUrl(oMyPicFileInfo); 
                        $("#picture").attr("src", imgFileUrl);
                    });
                }
            });
        },
        setGridSchship : function () {         
            $("#gridSchship").alopexGrid({   //학력사항
                pager : false,
                rowClickSelect : false,
                rowInlineEdit : true,
                columnMapping : [
					{ columnIndex : 0, key : "FLAG",        title : "F",           align : "center", width : "30px",   refreshBy:true, 
					    value : function(value, data) {
					        if (data._state.added) return 'I';
					        if (data._state.deleted) return 'D';
					        if (data._state.edited) return 'U';
					        return ''; 
					    }
					},
					{ columnIndex : 1,  selectorColumn : true, width : "20px" },
                    { columnIndex : 2,  key : "APLY_STA_DT",   title : "시작일",     align : "center", width : "80px" },
                    { columnIndex : 3,  key : "APLY_END_DT",   title : "종료일",     align : "center", width : "80px" },
                    { columnIndex : 4,  key : "SCHSHIP_CL_NM", title : "학력구분",   align : "center", width : "80px" },
                    { columnIndex : 5,  key : "SCHSHIP_CL_CD", title : "학력코드",   align : "center", width : "60px", hidden:true },
                    { columnIndex : 6,  key : "SCHL_NM",       title : "학교명",     align : "center", width : "80px" },
                    { columnIndex : 7,  key : "SCHL_DEPT_NM",  title : "학과(전공)", align : "center", width : "80px" },
                    { columnIndex : 8,  key : "SCHL_DR_NM",    title : "학위",       align : "center", width : "80px" },
                    { columnIndex : 9,  key : "SCHL_DR_CD",    title : "학위코드",   align : "center", width : "60px", hidden:true  }
                ]                                                                            
            });         
        },
        setGridCareer : function () {         
            $("#gridCareer").alopexGrid({  //경력사항
                pager : false,
                rowClickSelect : false,
                rowInlineEdit : true,
                columnMapping : [
					{ columnIndex : 0, key : "FLAG",        title : "F",           align : "center", width : "30px",   refreshBy:true, 
					    value : function(value, data) {
					        if (data._state.added) return 'I';
					        if (data._state.deleted) return 'D';
					        if (data._state.edited) return 'U';
					        return ''; 
					    }
					},
					{ columnIndex : 1,  selectorColumn : true, width : "20px" },
                    { columnIndex : 2,  key : "APLY_STA_DT",    title : "시작일",     align : "center", width : "80px" },
                    { columnIndex : 3,  key : "APLY_END_DT",    title : "종료일",     align : "center", width : "80px" },
                    { columnIndex : 4,  key : "CAREER_CL_NM",   title : "경력구분",   align : "center", width : "80px" },
                    { columnIndex : 5,  key : "CAREER_CL_CD",   title : "경력코드",   align : "center", width : "60px", hidden:true },
                    { columnIndex : 6,  key : "CAREER_CO_NM",   title : "직장명",     align : "center", width : "80px" },
                    { columnIndex : 7,  key : "CAREER_CHRG_OP", title : "담당업무",   align : "center", width : "80px" },
                    { columnIndex : 8,  key : "POS_NM",         title : "직위",       align : "center", width : "80px" },
                    { columnIndex : 9,  key : "POS_CD",         title : "직위코드",   align : "center", width : "60px", hidden:true }
                ]                                                                            
            });
        },

        updateChar : function( obj ){
        	
        	var length = calculate_msglen(obj.value);
        	
        	switch( obj.id ){
	        	case "SELF_INTDC":     
	                $("#textlimit1").text( length );
                break;
	        	case "SALE_PLAN":     
                    $("#textlimit2").text( length );
                break;
        	}
        },
        
    });
    
    function closeWithout() {
        $a.close();
    }
    
    function setViewObject( event ) {
    	
    	$("#btnAcademyAdd").hide();
        $("#btnCareerAdd").hide();   
        
        switch( event.target.id ){
            //동의1 클릭
	        case "AGREE_Y1":     
	        	$("#btnAcademyAdd").show();
	            $("#btnCareerAdd").show();

	            $("#SELF_INTDC").setEnabled(true); //자기소개
	            
	            /* 월별판매계획 */
                $("#QUART1_MTH_AVG_QTY").setEnabled(true);
                $("#QUART2_MTH_AVG_QTY").setEnabled(true);
                $("#SHYR_MTH_AVG_QTY").setEnabled(true);
                
	            $("#SALE_PLAN").setEnabled(true);  //판매계획
	            break;
	        
	        //미동의1 클릭
	        case "AGREE_N1":     
	        	$("#btnAcademyAdd").hide();
	            $("#btnCareerAdd").hide();
	            
	            /* 자기소개 */
	            $("#SELF_INTDC").setEnabled(false);
	            $("#SELF_INTDC").val("");
	            $("#textlimit1").text("0");

	            /* 월별판매계획 */
	            $("#QUART1_MTH_AVG_QTY").setEnabled(false);
                $("#QUART1_MTH_AVG_QTY").val("");
                $("#QUART1_MTH_TOT_QTY").text("");
                
                $("#QUART2_MTH_AVG_QTY").setEnabled(false);
                $("#QUART2_MTH_AVG_QTY").val("");
                $("#QUART2_MTH_TOT_QTY").text("");

                $("#SHYR_MTH_AVG_QTY").setEnabled(false);
                $("#SHYR_MTH_AVG_QTY").val("");
                $("#SHYR_MTH_TOT_QTY").text("");
                
                $("#YR_MTH_AVG_QTY").text("");
                $("#YR_MTH_TOT_QTY").text("");
                
	            /* 판매계획 */
	            $("#SALE_PLAN").setEnabled(false);
	            $("#SALE_PLAN").val("");
	            $("#textlimit2").text("0");
	        	break;
            
	        //동의2 클릭
	        case "AGREE_Y2":     
	        	/* 기타사항 */
	            $("#GUIDE_PRCPL").setEnabled(true);
	            $("#HOBBY_SKILL").setEnabled(true);
	            $("#HEIGHT").setEnabled(true);
	            $("#WEIGHT").setEnabled(true);
	            $("#MAIN_ACTV_AREA").setEnabled(true);
	            $("#DSM_RETL_TYPE").setEnabled(true);
	            $("#ACTV_ACQN_NM").setEnabled(true);
	        	break;
	        
        	//미동의2 클릭
	        case "AGREE_N2":
	        	/* 기타사항 */
	            $("#GUIDE_PRCPL").setEnabled(false);
	            $("#HOBBY_SKILL").setEnabled(false);
	            $("#HEIGHT").setEnabled(false);
	            $("#WEIGHT").setEnabled(false);
	            $("#MAIN_ACTV_AREA").setEnabled(false);
	            $("#DSM_RETL_TYPE").setEnabled(false);
	            $("#DSM_RETL_TYPE_RMK").setEnabled(false);
	            $("#ACTV_ACQN_NM").setEnabled(false);

	            /* 기타사항 초기화*/
	            $("#GUIDE_PRCPL").val("");
	            $("#HOBBY_SKILL").val("");
	            $("#HEIGHT").val("");
	            $("#WEIGHT").val("");
	            $("#MAIN_ACTV_AREA").val("");
	            $("#DSM_RETL_TYPE").val("");
	            $("#DSM_RETL_TYPE_RMK").val("");
	            $("#ACTV_ACQN_NM").val("");
                break;
                
	        //희망부서 Y 클릭
	        case "DEPT_Y":     
	        	/* 희망부서 영역*/
	        	$("#HDQT_PART_ORG_ID").setEnabled(true); //희망지역명
                $("#SALE_DEPT_ORG_ID").setEnabled(true); //영업국명
                $("#REQ_DSM_TEAM_NM").setEnabled(true);  //영업팀명
                break;
                
	        //희망부서 N 클릭
	        case "DEPT_N":	        	
	        	/* 희망부서 영역*/
	        	$("#HDQT_PART_ORG_ID").setEnabled(false); //희망지역명
                $("#SALE_DEPT_ORG_ID").setEnabled(false); //영업국명
                $("#REQ_DSM_TEAM_NM").setEnabled(false);  //영업팀명
                $("#HDQT_PART_ORG_ID").val("");
                $("#SALE_DEPT_ORG_ID").val("");
                $("#REQ_DSM_TEAM_NM").val("");
                break;                    
        }
        
    }
    
    //월 별 판매계획 입력
    function updateAvgQty( obj ) {
    	
    	switch( obj.id ){
	    	case "QUART1_MTH_AVG_QTY":     
	    		$("#QUART1_MTH_TOT_QTY").val( obj.value * 3 );
	    		break;
	    	case "QUART2_MTH_AVG_QTY":     
                $("#QUART2_MTH_TOT_QTY").val( obj.value * 3 );
                break;
	    	case "SHYR_MTH_AVG_QTY":     
                $("#SHYR_MTH_TOT_QTY").val( obj.value * 6 );
                break;
    	}
    	
    	
    	$("#YR_MTH_TOT_QTY").val( Number( $("#QUART1_MTH_TOT_QTY").val() ) + Number( $("#QUART2_MTH_TOT_QTY").val() ) + Number( $("#SHYR_MTH_TOT_QTY").val() ) );    	
    	$("#YR_MTH_AVG_QTY").val( Math.round( Number( $("#YR_MTH_TOT_QTY").val() ) / 12 * 10 )/10 );   //소수점 2자리에서 반올림 처리
    	
    }
    
    function changeEmailDomain (){
        var emailcode = $("#EMAIL_DMN_CD").val();

        if ( "99"==emailcode ) {
            $("#EMAIL_DMN_NM").val("");
            $("#EMAIL_DMN_NM").setEnabled(true);
            $("#EMAIL_DMN_NM").focus();
        }
        else if ( ""==emailcode ) {
            $("#EMAIL_DMN_NM").val("");
            $("#EMAIL_DMN_NM").setEnabled(false);
        }
        else {
        	$("#EMAIL_DMN_NM").setEnabled(false);
        	$("#EMAIL_DMN_NM").val( $("#EMAIL_DMN_CD option:selected").text() );            
        }
    }
    
    function changeRetlType (){
        var retltype = $("#DSM_RETL_TYPE").val();

        //판매형태의 기타를 선택시, 판매형태 비고를 활성화 처리 
        if ( "06"==retltype ) {
            //$("#DSM_RETL_TYPE_RMK").val("");
            $("#DSM_RETL_TYPE_RMK").setEnabled(true);
            $("#DSM_RETL_TYPE_RMK").focus();
        }
        else {
            $("#DSM_RETL_TYPE_RMK").setEnabled(false);
            $("#DSM_RETL_TYPE_RMK").val("");            
        }
    }
    
    function addOpenPopup( event ){
        var url, title, width, height, windowpopup=false;
        
        switch( event.target.id ){
            case "btnAddress":     
                url = "com/popupns/addrSearchPopup";
                title = "주소찾기";
                width = "500";
                height = "655";
            break;
            case "btnAcademyAdd":     
                url = "com/popupns/academyAddPopup";
                title = "학력";
                width = "420";
                height = "330";
            break;
            case "btnCareerAdd":
                url = "com/popupns/careerAddPopup";
                title = "경력";
                width = "420";
                height = "330";
            break;
            case "btnGuide":
                url = "com/popupns/maGuidePopup";
                title = "MA 지원서 작성 방법";
                width = "865";
                height = "800";
                windowpopup=true;
            break;

        }
        
        $a.popup({
            url: url,
            title : title,
            width: width,
            height: height,
            windowpopup: windowpopup,
            callback : function( oResult ) {
                popupCallback( event.target.id, oResult);
            }
        });
    }
    
    function popupCallback (elemId, oResult){
        switch (elemId){
            case "btnAddress":
                $("#form").setData( oResult );
                $("#ADDR_2").focus();
                break;
            case "btnAcademyAdd":
            	$("#gridSchship").alopexGrid('dataAdd', oResult);
            	$("#gridSchship").alopexGrid("startEdit");
            	$("#gridSchship table.table tr").removeClass("editing"); 
             	//$("#SELF_INTDC").focus();  //안해주면 editbox가 먹통됨,원인파악중
                break;
            case "btnCareerAdd":
                $("#gridCareer").alopexGrid('dataAdd', oResult);
                $("#gridCareer").alopexGrid("startEdit");
                $("#gridCareer table.table tr").removeClass("editing"); 
                //$("#SELF_INTDC").focus();   //안해주면 editbox가 먹통됨,원인파악중
                break;
            default :
            	break; 
                            
        }
    }
    
    function delRow( event ){
    	
    	switch( event.target.id ){

	    	case "btnAcademyDel":
	    		   var selCheck = $("#gridSchship").alopexGrid('dataGet', {_state:{selected:true}});
	    		   if ( null==selCheck || selCheck.length<1 ) {
	    	            $.PSNM.alert("E011", ["선택된"]);
	    	            return false;
	    	        }
	    	        if ( ! $.PSNM.confirm("I004", ["삭제"]) ) {
	    	            return false;
	    	        }
	    	        $("#gridSchship").alopexGrid("dataDelete", {_state:{selected:true}, "FLAG":"I"}); //추가된 데이터는 화면에서 삭제
	    	        $("#gridSchship").alopexGrid("dataEdit", {_state:{deleted:true}}, {_state:{selected:true}});
	    	        $("#gridSchship").alopexGrid("dataEdit", {_state:{selected:false}}, {_state:{selected:true}});
	    	        $("#gridSchship table.table tr").removeClass("editing");
	    	        $("#gridSchship table.table tr").removeClass("deleted");	    	        
	    		   break;
	    	case "btnCareerDel":
                var selCheck = $("#gridCareer").alopexGrid('dataGet', {_state:{selected:true}});
                if ( null==selCheck || selCheck.length<1 ) {
                     $.PSNM.alert("E011", ["선택된"]);
                     return false;
                 }
                 if ( ! $.PSNM.confirm("I004", ["삭제"]) ) {
                     return false;
                 }
                 $("#gridCareer").alopexGrid("dataDelete", {_state:{selected:true}, "FLAG":"I"}); //추가된 데이터는 화면에서 삭제
                 $("#gridCareer").alopexGrid("dataEdit", {_state:{deleted:true}}, {_state:{selected:true}});
                 $("#gridCareer").alopexGrid("dataEdit", {_state:{selected:false}}, {_state:{selected:true}});
                 $("#gridCareer table.table tr").removeClass("editing");
                 $("#gridCareer table.table tr").removeClass("deleted");
                break;
    	}
    }
    
    function saveConfirm(){
        
    	//필수입력항목 체크
    	if(!$.PSNM.isValid("form")){
            return false;
        }
        
        if( getBytes($("#ADDR_2").val()) > 200 ){
            $.PSNM.alert('상세주소는 200byte를 초과할 수 없습니다.');
            $("#ADDR_2").focus();
            return false;
        }
        
        //동의1 선택
        if( $("#AGREE_Y1").is(":checked") ) {

        	//학력사항 필수 체크
        	var gridCount = $("#gridSchship").alopexGrid("dataGet").length;        	
        	if( gridCount == 0 ) {
        		$.PSNM.alert('학력입력은 필수 입니다.');
        		return false;
        	}
        	
        	if( $("#SELF_INTDC").val().length < 200 ){
                $.PSNM.alert('자기소개는 200자 이상 입력해 주세요.');
                $("#SELF_INTDC").focus();
                return false;
            }
            
            if( $("#SALE_PLAN").val().length < 300 ){
                $.PSNM.alert('판매계획는 300자 이상 입력해 주세요.');
                $("#SALE_PLAN").focus();
                return false;
            }
        	
        }
    	
        //동의2 선택
        if( $("#AGREE_Y2").is(":checked") ) {

        	//필수항목체크
        	if($.PSNMUtils.isEmpty( $("#GUIDE_PRCPL").val()) ){
                $.PSNM.alert('E012',['생활신조']);
                $("#GUIDE_PRCPL").focus();
                return false;
            }
        	
        	if($.PSNMUtils.isEmpty( $("#HOBBY_SKILL").val()) ){
                $.PSNM.alert('E012',['취미/특기']);
                $("#HOBBY_SKILL").focus();
                return false;
            }
        	
        	if($.PSNMUtils.isEmpty( $("#HEIGHT").val()) ){
                $.PSNM.alert('E012',['신장']);
                $("#HEIGHT").focus();
                return false;
            }
        	
        	if($.PSNMUtils.isEmpty( $("#WEIGHT").val()) ){
                $.PSNM.alert('E012',['체중']);
                $("#WEIGHT").focus();
                return false;
            }
        	
        	if( getBytes($("#GUIDE_PRCPL").val()) > 500 ){
                $.PSNM.alert('생활신조는 500byte를 초과할 수 없습니다.');
                $("#GUIDE_PRCPL").focus();
                return false;
            }
            
            if( getBytes($("#HOBBY_SKILL").val()) > 100 ){
                $.PSNM.alert('취미/특기는 100byte를 초과할 수 없습니다.');
                $("#HOBBY_SKILL").focus();
                return false;
            }
        	
        }

        //미동의1, 미동의2가 선택되었을 경우.
        if( $("#AGREE_N1").is(":checked") || $("#AGREE_N2").is(":checked") ) {
        	
        	var confirmYN1 = $.PSNM.confirm("I004", ["선택정보수집 및 개인정보수집 이용에 대한 동의를 하지 않았습니다.\n제출"] );        	 
        	
        	if( !confirmYN1 ) {                
        		return false;        		
            }
        	else{
        		
        	    //희망부서 'Y' 클릭시, 영업팀명 필수체크
                if( $("#DEPT_Y").is(":checked") ) {

                    if( $.PSNMUtils.isEmpty( $("#REQ_DSM_TEAM_NM").val() ) ) {
                        $.PSNM.alert('배치 희망 영업조직이 있을 경우 영업팀명은 필수적으로 입력해야 합니다.');
                        $("#REQ_DSM_TEAM_NM").focus();
                        return false;   
                    }           
                }
        	      
                //희망부서 'N' 클릭시,
        		if( $("#DEPT_N").is(":checked") ) {	
        		//if( $.PSNMUtils.isEmpty( $("#HDQT_PART_ORG_ID").val() ) ||  $.PSNMUtils.isEmpty( $("#SALE_DEPT_ORG_ID").val() ) || $.PSNMUtils.isEmpty( $("#REQ_DSM_TEAM_NM").val() ) ){	
        			var confirmYN2 = $.PSNM.confirm("I004", ["배치 희망 영업국이 지정되지 않았습니다. 이 경우 사무국에서 임의적으로 배치 합니다 .\n제출"] );
                    if( !confirmYN2 ) {               
                        return false;
                    }
        		}
        		
            }
        }
        
        //폼과 첨부파일 그리드 모두 합쳐 request 데이터를 생성함. 그리드가 1개이상 가능함.
        var requestData = $.PSNMUtils.getRequestData("form", "gridSchship", "gridCareer");
        
        $.alopex.request('agn.AGNTMGMT@PAGENTCNTRT001_pInsertAgentCntrt', {

        	url: _NOSESSION_REQ_URL,
        	data: requestData,
            success: function(res) {
                
            	if ( !$.PSNM.success(res) ) { //서버측에서 오류시 
                    return false;
                }
                
                $.PSNM.alert('성공적으로 제출되었습니다. 좋은 결과 있기를 바랍니다.\n지원 내용 검토 후 내용이 사실과 다르거나 무성의 하게 작성된 경우 반려 처리 됩니다.');                
                $a.close();  
            }
        });
    }
    
    function js_trim(obj){
        
    	$("#" + obj.id).val( obj.value.replace(/\s+/gi,"") );
    }
    
    </script>
</head>
<body>
<div id="Wrap">

<!-- title area -->
<div class="pop_header" > 
    
	<!--view_table area -->
	<div class="textAR">
	
		<!-- btn area -->
	    <div class="floatL2">  
	        <div class="ab_btn_right">
	            <button id="btnGuide" name="btnGuide" type="button" data-type="button" data-theme="af-btn57"  data-altname="MA 지원서 작성 방법"></button>      
	        </div>
	    </div>
    
	<form id="form" onsubmit="return false;">
	   
		<div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>지원서작성_인적 사항(필수)</b></div>
		<div class="info1">수집된 정보는 본인 확인 및 지원 심사 결과 통보에 이용하며, 필수정보 미제공시 계약이 이뤄지지 않습니다.</div>
		<div id="searchDiv" class="textAR">
		    <table id="searchTable" class="board02">
		        <colgroup>
		            <col style="width:18%">
		            <col style="width:10%">
		            <col style="width:30%">
		            <col style="width:10%">
		            <col style="width:*">
		        </colgroup>
		        <tbody>
		        <tr>
		            <td rowspan="5">
		                <img id="picture" src="" alt="" width="114" height="154" onerror='this.src="<c:out value='${pageContext.request.contextPath}'/>/image/adminbox-sample-img.gif"'>
		                <br><br>		                
		                <div style="position:relative; top:2px;left:50px;">
                            <span class="file-button type3"><input type="file" id="fileupload" data-type="button"></span>
                        </div>
                        
				        <input id="ATCH_FILE_ID" name="ATCH_FILE_ID" data-bind="value:ATCH_FILE_ID" type="hidden" data-type="textinput" 
				               data-validation-rule="{required:true}" 
                               data-validation-message="{required:$.PSNM.msg('E012', ['사진'])}"/>
				        <input id="FILE_NM" name="FILE_NM" type="hidden" />
				        <input id="FILE_PATH" name="FILE_PATH" type="hidden" />
				        <input id="FILE_SIZE" name="FILE_SIZE" type="hidden" />

		            </td>
		            <th height="40" scope="col" class="fontred">성명(한글)</th>
		            <td class="tleft">
		                <input id="NAME_KOR" data-bind="value:NAME_KOR" data-type="textinput" onBlur="js_trim(this);"
					           data-validation-rule="{required:true}" 
					           data-validation-message="{required:$.PSNM.msg('E012', ['성명(한글)'])}">
		            </td>
		            <th height="40" scope="col" class="fontred">성명(한자)</th>
		            <td class="tleft">
		                <input id="NAME_HAN" data-bind="value:NAME_HAN" data-type="textinput" onBlur="js_trim(this);"
                               data-validation-rule="{required:true}" 
                               data-validation-message="{required:$.PSNM.msg('E012', ['성명(한자)'])}">
		            </td>
		        </tr>
		        <tr>
		            <th height="40" scope="col" class="fontred">생년월일</th>
		            <td class="tleft">
		                <input id="BIRTH_DT" data-bind="value:BIRTH_DT" data-type="dateinput" data-keyfilter="-" data-keyfilter-rule="digits" style="width:80px;" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png"></div>			                
		                <input type="radio" name="BIRTH_LUNAR_YN" data-type="radio" value="Y" data-bind="checked:BIRTH_LUNAR_YN"/>음력
		                <input type="radio" name="BIRTH_LUNAR_YN" data-type="radio" value="N" data-bind="checked:BIRTH_LUNAR_YN" checked="checked"/>양력
		                <ul class="info3">
                            <li>(직접입력가능 입력예 : 1980-01-01)</li>
                        </ul>
		            </td>
		            <th height="40" scope="col" class="fontred">결혼유무</th>
		            <td class="tleft">
		                <input type="radio" name="WEDD_YN" data-type="radio" value="Y" data-bind="checked:WEDD_YN" />기혼
				        <input type="radio" name="WEDD_YN" data-type="radio" value="N" data-bind="checked:WEDD_YN" checked="checked" />미혼				        
		            </td>
		        </tr>
		        <tr>
		            <th height="40" scope="col" class="fontred">자택전화</th>
		            <td class="tleft">
	
		                <select id="PHON_NUM1" name="PHON_NUM1" data-bind="options: options_PHON_NUM1, selectedOptions: PHON_NUM1" data-type="select" data-wrap="false" style="width:60px"
		                        data-validation-rule="{required:true}" 
                                data-validation-message="{required:$.PSNM.msg('E012', ['전화번호'])}">
                        </select> -
    
                        <!-- 
		                <input id="PHON_NUM1" data-bind="value:PHON_NUM1" data-type="textinput" size="4" data-keyfilter-rule="digits"
					            data-validation-rule="{required:true}" 
					            data-validation-message="{required:$.PSNM.msg('E012', ['전화번호'])}"> -
					     -->
					    <input id="PHON_NUM2" data-bind="value:PHON_NUM2" data-type="textinput" data-keyfilter-rule="digits" size="4" maxlength="4"
					            data-validation-rule="{required:true}" 
					            data-validation-message="{required:$.PSNM.msg('E012', ['전화번호'])}"> -
					    <input id="PHON_NUM3" data-bind="value:PHON_NUM3" data-type="textinput" data-keyfilter-rule="digits" size="4" maxlength="4"
					            data-validation-rule="{required:true}" 
					            data-validation-message="{required:$.PSNM.msg('E012', ['전화번호'])}">
		            </td>
		            <th height="40" scope="col" class="fontred">이동전화</th>
		            <td class="tleft">

				        <select id="MBL_PHON_NUM1" name="MBL_PHON_NUM1" data-bind="options: options_MBL_PHON_NUM1, selectedOptions: MBL_PHON_NUM1" data-type="select" data-wrap="false" style="width:60px"
				                data-validation-rule="{required:true}" 
                                data-validation-message="{required:$.PSNM.msg('E012', ['이동전화'])}">
                        </select>
                      - <input id="MBL_PHON_NUM2" data-bind="value:MBL_PHON_NUM2" type="text" data-type="textinput" data-keyfilter-rule="digits" size="4" maxlength="4"
					            data-validation-rule="{required:true}" 
					            data-validation-message="{required:$.PSNM.msg('E012', ['이동전화'])}"> -
				        <input id="MBL_PHON_NUM3" data-bind="value:MBL_PHON_NUM3" type="text" data-type="textinput" data-keyfilter-rule="digits" size="4" maxlength="4"
					            data-validation-rule="{required:true}" 
					            data-validation-message="{required:$.PSNM.msg('E012', ['이동전화'])}">           
		            </td>
		        </tr>
		        <tr>
		            <th height="40" scope="col" class="fontred">현주소</th>
		            <td class="tleft" colspan="3">
		                <input id="POST_NUM1" data-bind="value:POST_NUM1" data-type="textinput" value="" size="4" data-disabled="true"
				               data-validation-rule="{required:true}" 
				               data-validation-message="{required:$.PSNM.msg('E012', ['우편번호'])}">
			          - <input id="POST_NUM2" data-bind="value:POST_NUM2" data-type="textinput" value="" size="4" data-disabled="true"
			                   data-validation-rule="{required:true}" 
			                   data-validation-message="{required:$.PSNM.msg('E012', ['우편번호'])}">
			            <input id="btnAddress" type="button" data-type="button" data-theme="af-n-btn4"><br>
			            <input id="ADDR_1" data-bind="value:ADDR_1" data-type="textinput" style="width:350px" value="" data-disabled="true">
			            <input id="ADDR_2" data-bind="value:ADDR_2" data-type="textinput" style="width:350px" value="" 
   				               data-validation-rule="{required:true}" 
					           data-validation-message="{required:$.PSNM.msg('E012', ['상세주소'])}">
                            
		            </td>
		        </tr>
		        <tr>
		            <th height="40" scope="col" class="fontred">이메일</th>
		            <td class="tleft" colspan="3">
		                <input id="EMAIL_ID" data-bind="value:EMAIL_ID" data-type="textinput" data-keyfilter="a-zA-Z0-9\.\-_"
					            data-validation-rule="{required:true}" 
					            data-validation-message="{required:$.PSNM.msg('E012', ['이메일'])}">@
				        <input id="EMAIL_DMN_NM" data-bind="value:EMAIL_DMN_NM" data-type="textinput" data-disabled="false"
					            data-validation-rule="{required:true}" 
					            data-validation-message="{required:$.PSNM.msg('E012', ['이메일'])}">
				        
				        <select name="EMAIL_DMN_CD" id="EMAIL_DMN_CD" data-type="select" data-bind="options:options_EMAIL_DMN_CD, selectedOptions: EMAIL_DMN_CD">
				            <option value="99">직접입력</option>
				        </select>
        
		            </td>
		        </tr>
		        </tbody>
		    </table>
		</div>
		
		<!-- 개인정보수집에 대한 이용 동의1 area -->
		<div class="info_txt_bottom">
		    <ul class="info1">
		        <li>본인 및 파일의 확장자가 jpg,jpeg.gif인 사진 파일만 등록할 수 있습니다.(주민등록증 촬영 및 상태 불량 사진 등록 시 승인 거절) </li></br>
		        <li>수집된 정보[학력사항/경력사항/자기소개/연간 판매 예상수량/판매계획]는 지원자 자격 심사에 이용하며, 선택 정보수집 및 이용에 동의하지 않을 권리가 있으나, 미 동의 시 심사에 불리하게 작용할 수 있습니다.</li>
		    </ul>
		</div>
		<div class="t-center mgt30">
		    <strong style="font-size:18px;">개인정보 수집 및 이용에 대해 동의 하십니까?</strong><br><br>
		    <input id="AGREE_Y1" name="AGREE_YN1" type="radio" data-type="radio" value="Y" data-bind="checked:AGREE_YN1" />동의
		    <input id="AGREE_N1" name="AGREE_YN1" type="radio" data-type="radio" value="N" data-bind="checked:AGREE_YN1" checked="checked"/>미동의
		</div>
		
		<!-- 학력사항 area -->
		<div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>학력사항</b> 
		    <div class="ab_pos1">
		        <button id="btnAcademyAdd" data-type="button" data-theme="af-btn16" style="display:none;"></button>
		        <button id="btnAcademyDel" data-type="button" data-theme="af-btn28"></button>
		    </div>
		    <div id="gridSchship" data-bind="gridSchship" data-ui="ds"></div>
		</div>
		
		<!-- 경력사항 area -->
		<div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>경력사항</b> 
		    <div class="ab_pos1">
		        <button id="btnCareerAdd" data-type="button" data-theme="af-btn16" style="display:none;"></button>
		        <button id="btnCareerDel" data-type="button" data-theme="af-btn28"></button>
		    </div>
		    <div id="gridCareer" data-bind="gridCareer" data-ui="ds"></div>
		</div>
		
		<!-- 자기소개 area -->
		<div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>자기소개(성격 및 경력 중심)-<span class="fontred">200자 이상 입력 필수</span></b></div>
            <textarea id="SELF_INTDC" data-bind="value:SELF_INTDC" style="width:97%; margin-bottom:10px; margin-top:10px;" cols="40" rows="6" data-type="textarea" 
                      onkeyup="$a.page.updateChar( this );" onkeydown="$a.page.updateChar( this );" data-disabled="true" ></textarea>
 		<div class="t-right mgt10">(<span id="textlimit1">0</span>/200)</div>
 		
		<!-- 연간 판매 예상수량 area -->
		<div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>이동전화 년간 판매계획</b></div>

	    <div class="view_table">
	        <table data-type="table">
	            <colgroup>
	                <col style="width:13%;" />
	                <col style="width:12%;" />
	                <col style="width:13%;" />
	                <col style="width:12%;" />
	                <col style="width:13%;" />
	                <col style="width:12%;" />
	                <col style="width:13%;" />
	                <col style="width:12%;" />
	            </colgroup>
	            <thead>
	                <!-- <tr>
	                  <th colspan="8">이동전화 년간 판매계획</th>
	                </tr> -->
	                <tr>
	                  <th colspan="2">1~3차월</th>
	                  <th colspan="2">4~6차월</th>
	                  <th colspan="2">7~12차월</th>
	                  <th colspan="2">1년 누계</th>
	                </tr>
	                <tr>
	                  <th class="fontred">월평균</th>
	                  <th>계</th>
	                  <th class="fontred">월평균</th>
	                  <th>계</th>
	                  <th class="fontred">월평균</th>
	                  <th>계</th>
	                  <th>월평균</th>
	                  <th>계</th>
	                </tr>
	            </thead>
	            <tbody>
	                <tr>
		                <td>
		                    <input id="QUART1_MTH_AVG_QTY" name="QUART1_MTH_AVG_QTY" data-bind="value:QUART1_MTH_AVG_QTY" data-type="textinput" style="width:90%;text-align:center" data-keyfilter-rule="digits" data-disabled="true" onblur="updateAvgQty( this );"
		                    	data-validation-rule="{required:true}" 
			                	data-validation-message="{required:$.PSNM.msg('E012', ['월평균'])}">
		                </td>
                        <td><input id="QUART1_MTH_TOT_QTY" data-bind="value:QUART1_MTH_TOT_QTY" data-type="textinput" style="width:90%;text-align:center" data-disabled="true"></td>
                        <td>
                            <input id="QUART2_MTH_AVG_QTY" name="QUART2_MTH_AVG_QTY" data-bind="value:QUART2_MTH_AVG_QTY" data-type="textinput" style="width:90%;text-align:center" data-keyfilter-rule="digits" data-disabled="true" onblur="updateAvgQty( this );"
                            	data-validation-rule="{required:true}" 
			                	data-validation-message="{required:$.PSNM.msg('E012', ['월평균'])}">
                        </td>
                        <td><input id="QUART2_MTH_TOT_QTY" data-bind="value:QUART2_MTH_TOT_QTY" data-type="textinput" style="width:90%;text-align:center" data-disabled="true"></td>
                        <td>
                            <input id="SHYR_MTH_AVG_QTY" name="SHYR_MTH_AVG_QTY" data-bind="value:SHYR_MTH_AVG_QTY" data-type="textinput" style="width:90%;text-align:center" data-keyfilter-rule="digits" data-disabled="true" onblur="updateAvgQty( this );"
                            	data-validation-rule="{required:true}" 
			                	data-validation-message="{required:$.PSNM.msg('E012', ['월평균'])}">
                        </td>
                        <td><input id="SHYR_MTH_TOT_QTY"   data-bind="value:SHYR_MTH_TOT_QTY" data-type="textinput" style="width:90%;text-align:center" data-disabled="true"></td>
                        <td><input id="YR_MTH_AVG_QTY"     data-bind="value:YR_MTH_AVG_QTY"   data-type="textinput" style="width:90%;text-align:center" data-disabled="true"></td>
                        <td><input id="YR_MTH_TOT_QTY"     data-bind="value:YR_MTH_TOT_QTY"   data-type="textinput" style="width:90%;text-align:center" data-disabled="true"></td>
	                </tr>
	            </tbody>
	        </table>
	    </div>

 		<!-- 판매계획 area -->
		<div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>판매계획(목표 공략 시장 및 판매전략)-<span class="fontred">300자 이상 입력 필수</span></b></div>
		    <textarea id="SALE_PLAN" data-bind="value:SALE_PLAN" style="width:97%; margin-bottom:10px; margin-top:10px;" cols="40" rows="6" data-type="textarea" 
                      onkeyup="$a.page.updateChar( this );" onkeydown="$a.page.updateChar( this );" data-disabled="true" ></textarea>
		<div class="t-right mgt10">(<span id="textlimit2">0</span>/300)</div>
		
		<!-- 개인정보수집에 대한 이용 동의2 area -->
		<div class="tit_type1_box mgt10">
		    <div class="info1 f-left">수집된 정보[기타사항]는 지원자의 영업 및 직무적성능력 판단을 위한 참고자료로 이용하며, 개인정보수집 및 이용에 동의하지 않을 권리가 있으나, 미 동의 시 심사에 불리하게 작용할 수 있습니다.</div>
		</div>
		<div class="t-center mgt30">
		    <strong style="font-size:18px;">개인정보 수집 및 이용에 대해 동의 하십니까?</strong><br><br>
		    <input id="AGREE_Y2" name="AGREE_YN2" type="radio" data-type="radio" value="Y" data-bind="checked:AGREE_YN2" />동의
            <input id="AGREE_N2" name="AGREE_YN2" type="radio" data-type="radio" value="N" data-bind="checked:AGREE_YN2" checked="checked"/>미동의
		</div>
        
        <!-- 기타사항 area -->
		<div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>기타사항(선택)</b></div>
		<div id="searchDiv" class="textAR">
		    <table id="searchTable" class="board02">
		        <colgroup>
		            <col style="width:13%">
		            <col style="width:30%">
		            <col style="width:10%">
		            <col style="width:*">
		            <col style="width:10%">
		            <col style="width:*">
		        </colgroup>
		        <tbody>
		        <tr>
		            <th height="40" scope="col">생활신조</th>
		            <td class="tleft" colspan="5">
		                <input id="GUIDE_PRCPL" data-bind="value:GUIDE_PRCPL" data-type="textinput" data-disabled="true" style="width:100%" >
		            </td>
		        </tr>
		        <tr>
		            <th height="40" scope="col">취미/특기</th>
		            <td class="tleft">
		                <input id="HOBBY_SKILL" data-bind="value:HOBBY_SKILL" data-type="textinput" data-disabled="true" style="width:100%" >
		            </td>
		            <th>신장</th>
		            <td class="tleft">
		                <input id="HEIGHT" data-bind="value:HEIGHT" data-type="textinput" data-keyfilter-rule="digits" data-disabled="true" style="width:75%"> cm
		            </td>
		            <th>체중</th>
		            <td class="tleft">
		                <input id="WEIGHT" data-bind="value:WEIGHT" data-type="textinput" data-keyfilter-rule="digits" data-disabled="true" style="width:75%"> kg
		            </td>
		        </tr>
		        <tr>
		            <th height="40" scope="col">주 활동지역</th>
		            <td class="tleft">
		                <input id="MAIN_ACTV_AREA" data-bind="value:MAIN_ACTV_AREA" data-type="textinput" data-disabled="true" style="width:100%">
		            </td>
		            <th>판매형태</th>
		            <td class="tleft" colspan="3">
		                <select id="DSM_RETL_TYPE" name="DSM_RETL_TYPE" data-bind="options: options_DSM_RETL_TYPE, selectedOptions: DSM_RETL_TYPE" data-type="select" data-disabled="true" data-wrap="false"></select>
		                <input id="DSM_RETL_TYPE_RMK" data-bind="value:DSM_RETL_TYPE_RMK" data-type="textinput" data-disabled="true" style="width:74%">
		            </td>
		        </tr>
		        <tr>
		            <th height="40" scope="col">활동지인 이름</th>
		            <td class="tleft" colspan="5">
		                <input id="ACTV_ACQN_NM" data-bind="value:ACTV_ACQN_NM" data-type="textinput" data-disabled="true" style="width:100%">
		            </td>
		        </tr>
		        </tbody>
		    </table>
		</div>
		<div class="info_txt_bottom">
		    <ul class="info3">
		        <li>활동지인 이름은 당사 소속 MA로 활동하고 있는 판매원을 말하며 복수일 경우 모두 기입하시기 바랍니다.</li>
		    </ul>
		</div>
		<div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>희망부서 (생략 가능 하며,이 경우 회사가 임의적으로 배치합니다.)</b> 
		    <!--우측 버튼
		    <div class="ab_pos1">
		        <button id="btnInit" data-type="button" data-theme="af-btn16"></button>
		        <button id="btnInit" data-type="button" data-theme="af-btn28"></button>
		    </div>
		    -->
		</div>
		<div id="searchDiv" class="textAR">
		    <table id="searchTable" class="board02">
		        <colgroup>
		            <col style="width:14%">
		            <col style="width:*">
		            <col style="width:10%">
		            <col style="width:*">
		            <col style="width:*">
                    <col style="width:*">
		        </colgroup>
		        <tbody>
		        <tr>
		            <th height="40" scope="col" colspan="2">배치를 희망하는  영업조직이 있습니까?</th>
		            <td class="tleft" colspan="4">
		                <input id="DEPT_Y" name="DEPT_YN" type="radio" data-type="radio" value="Y" data-bind="checked:DEPT_YN" checked="checked" />예
                        <input id="DEPT_N" name="DEPT_YN" type="radio" data-type="radio" value="N" data-bind="checked:DEPT_YN" />아니오
		            </td>
		        </tr>
		        <tr>
		            <th>본사파트명</th>
		            <td class="tleft">
		                <select id="HDQT_PART_ORG_ID" data-type="select" data-bind="options:options_HDQT_PART_ORG_ID, selectedOptions:HDQT_PART_ORG_ID" style="width:150px;"></select>
		            </td>
		            <th height="40" scope="col">영업국명</th>
		            <td class="tleft">
		                <select id="SALE_DEPT_ORG_ID" data-type="select" data-bind="options:options_SALE_DEPT_ORG_ID, selectedOptions:SALE_DEPT_ORG_ID" style="width:150px;"></select>
		            </td>
		            <th>영업팀명</th>
		            <td class="tleft">
		                <input id="REQ_DSM_TEAM_NM" data-bind="value:REQ_DSM_TEAM_NM" data-type="textinput" style="width:100%">
		            </td>
		        </tr>
		        </tbody>
		    </table>
		</div>
		<div class="info_txt_bottom">
		    <ul class="info2">
		        <li>(개인정보 취급위탁 고지) 수집된 개인정보 일체는 정보전산 처리 및 유지/관리를 위해 ㈜SK C&C에 취급 위탁하여 안전하게 관리합니다.</li>
		        <li>(개인정보 파기) 수집된 개인정보는 계약 시 계약 종료 후 2년간 보관하며, 미 계약 시 개인 통보 후 지체 없이 파기합니다.</li>
		    </ul>
		</div>
		<div class="floatL2">
		  <button id="btnConfirm" type="button" data-type="button" data-theme="af-n-btn9"  data-altname="지원요청"></button>
		  <button id="btnCancel"  type="button" data-type="button" data-theme="af-n-btn10" data-altname="지원취소"></button>
		</div>
	
	</form>
	</div>    
    
</div>
</div>
</body>
</html>
