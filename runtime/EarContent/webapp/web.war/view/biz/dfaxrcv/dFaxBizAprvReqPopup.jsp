<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE HTML>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>DFAX 업무승인요청</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />
    
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/vendor/jquery.ui.widget.js"></script>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/jquery.iframe-transport.js"></script>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/jquery.fileupload.js"></script>
    
    <script type="text/javascript">
    var _param;
    
    $.alopex.page({
        init : function(id, param) {
        	_param = param; //이 페이지로 전달된 파라미터를 저장
        	
            $a.page.setEventListener();
            $a.page.setFileUpload();
            $a.page.setCodeData();
            
        },
        setEventListener : function() {
        	$("#btnSearch").click($a.page.searchList);
        	$("#btnConfirm").click(function(){
        		
        		if ( ! $.PSNM.isValid("#form") ) {
    			    return false; //값 검증
    			}
        		
        		if(  $.PSNM.confirm("I004", ["요청"] ) ){
        			var requestData = $.PSNMUtils.getRequestData("form", "gridfile");
        			requestData.dataSet.fields.FAX_RCV_NO = _param["data"][0].FAX_RCV_NO;
        			requestData.dataSet.fields.BIZ_APRV_REQ_CL_CD = _param["data"][0].BIZ_APRV_REQ_CL_CD;
        			requestData.dataSet.fields.BIZ_APRV_OP_ST_CD = "01";
        			requestData.dataSet.fields.BIZ_APRV_ST_CD = "N";
        			requestData.dataSet.fields.SALE_DEPT_ORG_ID = _param["data"][0].SALE_DEPT_ORG_ID;
        			requestData.dataSet.fields.SALE_DEPT_ORG_NM = _param["data"][0].SALE_DEPT_ORG_NM;
        			requestData.dataSet.fields.SALE_TEAM_ORG_NM = _param["data"][0].SALE_TEAM_ORG_NM;
        			requestData.dataSet.fields.AGNT_ID = _param["data"][0].AGNT_ID;
        			requestData.dataSet.fields.AGNT_NM = _param["data"][0].AGNT_NM;
        			requestData.dataSet.fields.BIZ_APRV_YN = "R"; // 요청,승인,반려 구분
        			
                   	$.alopex.request("biz.DFAXRCV@PFAXRCV001_pSaveFaxRcvBizAprv", {
	                    data: requestData,
	                    success: function(res) { 
	                    	$a.close("success");
	                    }
                	});
           		}
            });
            $("#btnCancel").click(function(){
            	$a.close();
            });
            $("#btnFileDel").click(function(){
            	$.PSNMUtils.delFile();
            });
        },
        setFileUpload : function () {
        	$.PSNMUtils.setFileUploadAndGrid("FAX", "#fileupload", "#gridfile");
        },
        setCodeData : function() {
            $.PSNMUtils.setCodeData([
                { t:'code',  'elemid' : 'BIZ_APRV_TPY_CD', 'codeid' : 'DSM_BIZ_APRV_TPY_CD', 'header' : '-전체-' }
            ]);
        }
    });

    </script>
</head>
<body>

<div class="psnm-pop-body">

    <!--view_list area -->
    <div class="floatL4" style="width:100%;"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>업무승인요청</b></div>
    <form id="form">
        <table class="board02"  style="width:100%;">
        	<colgroup>
	            <col style="width:100px;"/>
	            <col style="*"/>
            </colgroup>
	        <tr>
	            <th class="psnm-required">업무유형</th>
	            <td class="tleft">
	            	<select id="BIZ_APRV_TPY_CD" data-bind="options: options_BIZ_APRV_TPY_CD, selectedOptions: BIZ_APRV_TPY_CD" data-type="select" 
	            		data-validation-rule="{required:true}"
						data-validation-message="{required:$.PSNM.msg('E012', ['업무유형'])}"></select>
	            </td>
	        </tr>
	        <tr>
	            <th>사유</th>
	            <td class="tleft">
	            	<input id="BIZ_APRV_OP_RSN_CTT" name="BIZ_APRV_OP_RSN_CTT" data-bind="value:BIZ_APRV_OP_RSN_CTT" data-type="textinput" style="width:100%;" />
	            </td>
	        </tr>
        </table>
    </form>
    
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

    <!-- btn area -->
    <div class="btn_area">
		<p class="floatL3">
        	<input id="btnConfirm" type="button" data-type="button" data-theme="af-btn8">
        	<input id="btnCancel"  type="button" data-type="button" data-theme="af-btn10">
      	</p>
    </div>

</div>

</body>
</html>