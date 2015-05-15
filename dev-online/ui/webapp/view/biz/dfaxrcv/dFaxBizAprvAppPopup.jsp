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
        	
            $("#form").setData(_param["data"][0]);
        	
            $a.page.setEventListener();
            $a.page.setViewData();
            $a.page.setCodeData();
            $a.page.setFileUpload();
            
            if("N" == _param["data"][0].BIZ_APRV_YN){ // 반려일때 업무유형 수정 불가
            	$("#BIZ_APRV_TPY_CD").setEnabled(false); 
            }
            
        },
        setEventListener : function() {
        	$("#btnSearch").click($a.page.searchList);
        	$("#btnConfirm").click(function(){
        		
        		if ( ! $.PSNM.isValid("#form") ) {
    			    return false; //값 검증
    			}
        		
        		var msg = "";
        		if("N" == _param["data"][0].BIZ_APRV_YN){
        			msg = "반려";
        		}else{
        			msg = "승인";
        		}
        		
        		if(  $.PSNM.confirm("I004", [msg] ) ){
        			var requestData = $.PSNMUtils.getRequestData("form");
        			requestData.dataSet.fields.FAX_RCV_NO = _param["data"][0].FAX_RCV_NO;
        			requestData.dataSet.fields.BIZ_APRV_REQ_CL_CD = _param["data"][0].BIZ_APRV_REQ_CL_CD; // 승인요청구분
        			requestData.dataSet.fields.BIZ_APRV_OP_ST_CD = _param["data"][0].BIZ_APRV_OP_ST_CD; // 승인처리상태
        			requestData.dataSet.fields.BIZ_APRV_TPY_CD = $("#BIZ_APRV_TPY_CD").val().split("-")[0];
        			requestData.dataSet.fields.SALE_DEPT_ORG_ID = _param["data"][0].SALE_DEPT_ORG_ID;
        			requestData.dataSet.fields.SALE_DEPT_ORG_NM = _param["data"][0].SALE_DEPT_ORG_NM;
        			requestData.dataSet.fields.SALE_TEAM_ORG_NM = _param["data"][0].SALE_TEAM_ORG_NM;
        			requestData.dataSet.fields.AGNT_ID = _param["data"][0].AGNT_ID;
        			requestData.dataSet.fields.AGNT_NM = _param["data"][0].AGNT_NM;
        			requestData.dataSet.fields.BIZ_APRV_YN = _param["data"][0].BIZ_APRV_YN;  // 요청,승인,반려 구분
        			
        			if("Y" == _param["data"][0].BIZ_APRV_YN){ // 승인업무이면
        				requestData.dataSet.fields.BIZ_APRV_FNSHR_ID = $.PSNM.getSession("USER_ID"); // 승인완료자ID
        				
        				if("00" == _param["data"][0].BIZ_APRV_REQ){ // 담당M
        					requestData.dataSet.fields.BIZ_APRV_ST_CD = "Y"; // 승인상태(승인)
        				}else{ // 국장
        					if("Y" == $("#BIZ_APRV_TPY_CD").val().split("-")[1]){ // 국장승인업무유형이면
                				if("02" == $("#BIZ_APRV_TPY_CD").val().split("-")[0]){ // 긴급
                					requestData.dataSet.fields.BIZ_APRV_ST_CD = "R"; // 승인상태(긴급)
                				}else{ // 긴급이 아니면
                					requestData.dataSet.fields.BIZ_APRV_ST_CD = "Y"; // 승인상태(승인)
                				}
                			}else{ // 국장승인업무유형이아니면
                				requestData.dataSet.fields.BIZ_APRV_ST_CD = "N"; // 승인상태(미승인)
                			}
        				}
        			}
        			
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
        },
        setViewData : function() {
        	$.alopex.request("biz.DFAXRCV@PFAXRCV001_pSearchFaxRcvFile", {
        		data: {dataSet: {fields: {FAX_RCV_NO : _param["data"][0].FAX_RCV_NO}}},
                success:["#form",  function(res) {
                	var gridList = res.dataSet.recordSets;
					
                    $.each(gridList, function(key, data) {
                    	$("#"+key).alopexGrid("dataSet", data.nc_list);
                    });
                }]
            });
        },
        setCodeData : function() {
        	
        	var setCode = {};
        	
        	if("00" == _param["data"][0].BIZ_APRV_REQ){
        		setCode = { t:'code',  'elemid' : 'BIZ_APRV_TPY_CD', 'codeid' : 'DSM_BIZ_APRV_TPY_CD', 'header' : '-전체-', 'ADD_INFO_01' : 'N' };
        	}else{
        		setCode = { t:'code',  'elemid' : 'BIZ_APRV_TPY_CD', 'codeid' : 'DSM_BIZ_APRV_TPY_CD', 'header' : '-전체-' };
        	}
        	
            $.PSNMUtils.setCodeData([
				setCode
            ], function(params, rsCodeList) {
                var rcvTypCdData = rsCodeList["BIZ_APRV_TPY_CD"].nc_list;
                
                var codeOptions = [];
                codeOptions.push({ value: "", text: "-전체-"});

                var setSelected = "";
	            $.each(rcvTypCdData, function (index, codeinfo) {
	                var codeOpt = new Object();
	                    codeOpt["value"] = codeinfo.COMM_CD_VAL + "-" + codeinfo.ADD_INFO_01;
	                    codeOpt["text"]  = codeinfo.COMM_CD_VAL_NM;
	                    
	                    if(codeinfo.COMM_CD_VAL == _param["data"][0].BIZ_APRV_TPY_CD){
	                    	setSelected = codeinfo.COMM_CD_VAL + "-" + codeinfo.ADD_INFO_01;
	                    }
	                    
	                codeOptions.push(codeOpt);
	            });
	            var optData = new Object();
	                optData["options_BIZ_APRV_TPY_CD"] = codeOptions;
	
	            $("#BIZ_APRV_TPY_CD").setData(optData);
	            $("#BIZ_APRV_TPY_CD").setSelected(setSelected);
	            
            });
        },
        setFileUpload : function () {
        	$.PSNMUtils.setFileUploadAndGrid("FAX", "#fileupload", "#gridfile");
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
	            <th>요청구분</th>
	            <td class="tleft"><label data-bind="text:BIZ_APRV_REQ_CL_NM"></label></td>
	        </tr>
	        <tr>
	            <th class="psnm-required">업무유형</th>
	            <td class="tleft">
	            	<select id="BIZ_APRV_TPY_CD" data-bind="options: options_BIZ_APRV_TPY_CD, selectedOptions: BIZ_APRV_TPY_CD" data-type="select" 
	            		data-validation-rule="{required:true}"
						data-validation-message="{required:$.PSNM.msg('E012', ['업무유형'])}"></select>
	            </td>
	        </tr>
	        <tr>
	            <th>승인/반려 사유</th>
	            <td class="tleft">
	            	<input id="BIZ_APRV_OP_RSN_CTT" name="BIZ_APRV_OP_RSN_CTT" data-bind="value:BIZ_APRV_OP_RSN_CTT" data-type="textinput" style="width:100%;" />
	            </td>
	        </tr>
        </table>
    </form>
    
    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>첨부파일</b> : 하단 파일을 클릭하시면 저장 및 열기가 가능합니다.</div>
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