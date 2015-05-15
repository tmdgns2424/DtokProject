<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>처리내용 - PS&Marketing</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />

    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/vendor/jquery.ui.widget.js"></script>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/jquery.iframe-transport.js"></script>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/jquery.fileupload.js"></script>

    <script type="text/javascript">
    var _param = null, _searchData = null;

    $a.page({
        init : function(id, param) {
            _param = param;
            if( $.PSNMUtils.isEmpty(_param.OP_SEQ) ){
            	$.PSNMUtils.setDefaultYmd("OP_DT");
            }else{
            	$a.page.setData();
            }
            $a.page.setFileUpload();
            $a.page.setEventListener();
            
        	setVisible( param.SCRB_CLM_ST_CD );
        },
        setData : function() {           	
           	$.alopex.request("biz.SCRBCLM@PSCRBCLM001_pSearchScrbClmOpDtl", {
           		data: {dataSet: {fields: {"RCV_MGMT_NUM" : _param.RCV_MGMT_NUM, "OP_SEQ":_param.OP_SEQ}}},
                   success:["#form", "#gridfile", function(res) {
                   	 if ( ! $.PSNM.success(res) ) { //서버측 FAIL응답
                   		 return false;
                   	 }           
                	 var reg = /(^\d{4})(\d{2})(\d{2})(.*)/;
                	 $("#OP_DT").val( res.dataSet.fields.OP_DT.replace(reg, '$1' + '-' + '$2'+'-'+'$3'));
                   	 //_searchData = res.dataSet.fields //변경되기 전 데이타
                   }]
               });
        },
        setEventListener : function() {
        	$("#OP_TM").change( function(){
        		if(this.value.length == 1){
        			this.value = "0"+this.value;
        		}
        	});  
        	$("#OP_MM").change( function(){
        		if(this.value.length == 1){
        			this.value = "0"+this.value;
        		}
        	});        	
            $("#btnFindAgent").click( popFindAgent2 );
            $("#OPR_NM").keyup($.PSNMAction.findAgent);
            $("#btnFileDel").click(function(){
            	$.PSNMUtils.delFile();
            });
            $("#btnSave").click(function(){
				
        		if ( ! $.PSNM.isValid("#form") ) {
    			    return false;
    			}
        		/*
        		if ( $.PSNMUtils.isEmpty($("#OPR_ID").val()) ) {
        			$.PSNM.alert("유효한 회원이 아닙니다."); 
        			$("#OPR_NM").focus();
    			    return false;
    			}
        		*/
        		if( !$.PSNM.confirm("I004", ["저장"] ) ){
        			return false;
        		}
        		
            	var requestData = $.PSNMUtils.getRequestData("form", "gridfile");
            	requestData = $.extend(true, {dataSet: {fields: {RCV_MGMT_NUM:_param.RCV_MGMT_NUM
																 , OP_SEQ:_param.OP_SEQ
																 , SMS_CUST_NM:_param.CUST_NM
													             , SMS_AGNT_NM:_param.AGNT_NM
													             , SMS_SALE_DEPT_ORG_NM:_param.SALE_DEPT_ORG_NM
													             , SMS_SALE_TEAM_ORG_NM:_param.SALE_TEAM_ORG_NM}}}, requestData);
            	$.alopex.request("biz.SCRBCLM@PSCRBCLM001_pSaveScrbClmOp", {
            		data: requestData,
                    success: function(res) {
                    	 if ( ! $.PSNM.success(res) ) { //서버측 FAIL응답
                    		 return false;
                    	 }
                    	$a.close("success");                     
                    }
                });
        	});
            $("#btnDelete").click(function(){
        		if( !$.PSNM.confirm("I004", ["삭제"] ) ){
        			return false;
        		}

            	$.alopex.request("biz.SCRBCLM@PSCRBCLM001_pDeleteScrbClmOp", {
            		data: {dataSet: {fields: {RCV_MGMT_NUM:_param.RCV_MGMT_NUM, OP_SEQ:_param.OP_SEQ}}},
                    success: function(res) {
                    	 if ( ! $.PSNM.success(res) ) { //서버측 FAIL응답
                    		 return false;
                    	 }
                    	$a.close("success");                     
                    }
                });
            });
        },
        setFileUpload : function () {
        	$.PSNMUtils.setFileUploadAndGrid("SCR", "#fileupload", "#gridfile");
        }        
    });

    function popFindAgent2() {        
        $.PSNMAction.popFindAgent(null, function(oResult) {
        	$("#form").setData( oResult );
        	$("#OPR_ID").val( oResult.USER_ID );        	
        	$("#OPR_NM").val( oResult.AGNT_NM );
        });
    }

    function onAgentFound( oAgent ){
    	$("#form").setData( oAgent );
    	$("#OPR_ID").val( oAgent.USER_ID );        	
    	$("#OPR_NM").val( oAgent.AGNT_NM );   	
    }
    
    function setVisible( div ){
    	switch( div ){
    		case "Y":
    			$("#btnSave").hide();
    			$("#btnDelete").hide();
    			$("#fileupload").setEnabled( false );
    			$("#btnFileDel").setEnabled( false );
    		break;
    	}
    }
    function closeWithout() {
        $a.close();
    }
    </script>
</head>

<body>

<div id="Wrap"> 
    <div class="pop_header" style="overflow-y: auto;">
    	<div class="btn_area">
	        <div class="ab_btn_right">
	            <button id="btnSave" type="button" data-type="button" data-theme="af-btn4"  style="z-index:1" data-altname="저장" data-authtype="W"></button>
	            <button id="btnDelete"  type="button" data-type="button" data-theme="af-btn13" style="z-index:1" data-altname="삭제" data-authtype="W"></button>
	        </div>
    	</div>
    	<form id="form" onsubmit="return false;">
	    <div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>내용등록</b>
	    	<font color="red" size="2">&nbsp;처리사항에 이름, 전화번호 등 개인정보 기재를 금지함. <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;불가피한 경우 마스킹 전제로 기재 가능하나 문제 발생시 작성자 책임 부과함.</font>
	    </div>	    
	    <table class="board02">
        	<colgroup>
	            <col style="width:15%"/>
	            <col style="width:30%"/>
	            <col style="width:15%"/>
	            <col style="width:*"/>
            </colgroup>
	        <tr>
	            <th scope="col" class="fontred">처리일시</th>
	            <td class="tleft">
					<input id="OP_DT" name="OP_DT" data-bind="value:OP_DT" data-type="dateinput" style="width:70px;" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png"
				      		data-validation-rule="{required:true}" 
							data-validation-message="{required:$.PSNM.msg('E012', ['처리일시'])}">
					<input id="OP_TM" name="OP_TM" data-bind="value:OP_TM" data-type="textinput" size="2" data-keyfilter-rule="digits" maxlength="2"
				      		data-validation-rule="{required:true, min:0,max:24,range:[0,24]}" 
							data-validation-message="{required:$.PSNM.msg('E012', ['처리일시'])}"> 시
					<input id="OP_MM" name="OP_MM" data-bind="value:OP_MM" data-type="textinput" size="2" data-keyfilter-rule="digits" maxlength="2"
				      		data-validation-rule="{required:true, min:0,max:59,range:[0,59]}" 
							data-validation-message="{required:$.PSNM.msg('E012', ['처리일시'])}"> 분	
	            </td>
	            <th scope="col" class="fontred">처리자</th>
	            <td class="tleft">
	                <input id="OPR_NM" name="OPR_NM" data-bind="value:OPR_NM" data-type="textinput" data-callback="onAgentFound" style="width:130px;"> 
	                <input id="btnFindAgent" type="button" data-type="button" data-theme="af-n-btn4">
	                <input id="OPR_ID" name="OPR_ID" data-bind="value:OPR_ID" data-type="textinput" data-disabled="true" style="width:130px;"
	                		data-validation-rule="{required:true}" 
							data-validation-message="{required:$.PSNM.msg('E012', ['처리자'])}">
	            </td>            
	        </tr>
	        <tr>
	            <th scope="col">본사팀</th>
	            <td class="tleft" >
	                <input id="HDQT_TEAM_ORG_NM" name="HDQT_TEAM_ORG_NM" data-bind="value:HDQT_TEAM_ORG_NM" data-type="textinput" data-disabled="true" style="width:130px;">
	                <input id="HDQT_TEAM_ORG_ID" name="HDQT_TEAM_ORG_ID" data-bind="value:HDQT_TEAM_ORG_ID" data-type="textinput" data-disabled="true" style="width:50px;">
	            </td>
	            <th scope="col">본사파트</th>
	            <td class="tleft">
	                <input id="HDQT_PART_ORG_NM" name="HDQT_PART_ORG_NM" data-bind="value:HDQT_PART_ORG_NM" data-type="textinput" data-disabled="true" style="width:130px;">
	                <input id="HDQT_PART_ORG_ID" name="HDQT_PART_ORG_ID" data-bind="value:HDQT_PART_ORG_ID" data-type="textinput" data-disabled="true" style="width:50px;">
	            </td>            
	        </tr>        <tr>
	            <th scope="col">영업국명</th>
	            <td class="tleft">
	                <input id="SALE_DEPT_ORG_NM" name="SALE_DEPT_ORG_NM" data-bind="value:SALE_DEPT_ORG_NM" data-type="textinput" data-disabled="true" style="width:130px;">
	                <input id="SALE_DEPT_ORG_ID" name="SALE_DEPT_ORG_ID" data-bind="value:SALE_DEPT_ORG_ID" data-type="textinput" data-disabled="true" style="width:50px;">
	            </td>
	            <th scope="col">영업팀명</th>
	            <td class="tleft">
	                <input id="SALE_TEAM_ORG_NM" name="SALE_TEAM_ORG_NM" data-bind="value:SALE_TEAM_ORG_NM" data-type="textinput" data-disabled="true" style="width:130px;">
	                <input id="SALE_TEAM_ORG_ID" name="SALE_TEAM_ORG_ID" data-bind="value:SALE_TEAM_ORG_ID" data-type="textinput" data-disabled="true" style="width:50px;">
	            </td>            
	        </tr>        
	        <tr>
	            <th scope="col">등록자</th>
	            <td class="tleft">
	                <input id="RGSTR_NM" name="RGSTR_NM" data-bind="value:RGSTR_NM" data-type="textinput" data-disabled="true" style="width:130px;">
	            </td>
	            <th scope="col">등록일시</th>
	            <td class="tleft">
	                <input id="RGST_DTM" name="RGST_DTM" data-bind="value:RGST_DTM" data-type="textinput" data-disabled="true" style="width:130px;">
	            </td>            
	        </tr>       
			<tr>
	            <th scope="col">처리사항</th>
	            <td class="tleft" colspan="3">
		            <textarea id="OP_CTT" name="OP_CTT" data-type="textarea" data-bind="value:OP_CTT" rows="10" 
		                   style='overflow: auto; width: 97%;'></textarea>
	            </td>       
	        </tr>
	    </table>
		</form>
	     <!-- 첨부파일 area -->
	     <div class="floatL4" id="area-gridfile-head"> 
	         <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>첨부파일</b> <span id="gridfile-title-info"></span> : 하단 파일을 클릭하시면 저장 및 열기가 가능합니다.
		    	<div class="ab_pos1" style="float:right;">
		      		<div style="position:relative;">
						<span class="file-button type1"><input id="fileupload" data-type="button" type="file"></span>
						<button id="btnFileDel" data-type="button" class="af-n-btn5"></button>
		      		</div>
		    	</div>
	     </div>
	     <div id="gridfile" class="view_list" data-bind="grid:gridfile" data-ui="ds"></div>	     
     </div>
</div>

</body>
</html>