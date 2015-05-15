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
    
    $.alopex.page({
    	
        init : function(id, param) { 
            $.PSNM.initialize(id, param); //PSNM공통 초기화함수 호출
            
            _param = param; //이 페이지로 전달된 파라미터를 저장
            
            $a.page.setEventListener();
            $a.page.setCodeData();
            $a.page.setFileUpload();
            $a.page.setViewData();
            
        },
        setEventListener : function() {
            $("#btnSave").click(function(){
            	if ( ! $.PSNM.isValid("#form") ) {
				    return false; //값 검증
				}
            	
            	if( $.PSNM.confirm("I004", ["저장"] ) ){
            		var requestData = $.PSNMUtils.getRequestData("form", "grid", "gridfile");
                	
                	$.alopex.request("biz.SALEEX@PEXCELSALEEX001_pSaveExcelSaleEx", {
                        data: requestData,
                        success: function(res) { 
                            $a.navigate("excelSaleExList.jsp", _param);
                        }
                    });
            	}
            });
            $("#btnList").click(function(){
            	$a.navigate("excelSaleExList.jsp", _param);
            });
            $("#btnDel").click(function(){
            	if( $.PSNM.confirm("I004", ["삭제"] ) ){
            		var id = _param.data != null ? _param.data.EXCEL_MGMT_NUM : "";
                	$.alopex.request("biz.SALEEX@PEXCELSALEEX001_pDeleteExcelSaleEx", {
                		data: {dataSet: {fields: {EXCEL_MGMT_NUM : id}}},
                        success : function(res) {
                        	$a.navigate("excelSaleExList.jsp", _param);
                        }
                    });
            	}
            });
			$("#btnFindAgent").click(function(){
            	
            	$a.session('alopex_parameters', '');
            	var oParam = new Object();
            	$.PSNMAction.popFindAgent(oParam, function(oResult) {
                    if ( oResult!=null && typeof oResult == "object" ) {
                        $("#AGNT_NM").val( oResult["AGNT_NM"] );
                        $("#AGNT_ID").val( oResult["AGNT_ID"] );
                        $("#RPSTY").val( oResult["RPSTY"] );
                        $("#RPSTY_NM").val( oResult["RPSTY_NM"] );
                        $("#HDQT_TEAM_ORG_NM").val( oResult["HDQT_TEAM_ORG_NM"] );
                        $("#HDQT_TEAM_ORG_ID").val( oResult["HDQT_TEAM_ORG_ID"] );
                        $("#HDQT_PART_ORG_NM").val( oResult["HDQT_PART_ORG_NM"] );
                        $("#HDQT_PART_ORG_ID").val( oResult["HDQT_PART_ORG_ID"] );
                        $("#SALE_DEPT_ORG_NM").val( oResult["SALE_DEPT_ORG_NM"] );
                        $("#SALE_DEPT_ORG_ID").val( oResult["SALE_DEPT_ORG_ID"] );
                        $("#SALE_TEAM_ORG_NM").val( oResult["SALE_TEAM_ORG_NM"] );
                        $("#SALE_TEAM_ORG_ID").val( oResult["SALE_TEAM_ORG_ID"] );
                    }
                });
            });
            $("#btnFileDel").click(function(){
            	$.PSNMUtils.delFile();
            });
        },
        setViewData : function() {
        	var id = _param.data != null ? _param.data.EXCEL_MGMT_NUM : "";
        	
        	if($.PSNMUtils.isNotEmpty(id)){
        		$.alopex.request("biz.SALEEX@PEXCELSALEEX001_pDetailExcelSaleEx", {
            		data: {dataSet: {fields: {EXCEL_MGMT_NUM : id}}},
                    success:["#form",  function(res) {
                    	
                    	$("#EXCEL_SALE_EX_CTT").ckeditor();
                    	
                    	var gridList = res.dataSet.recordSets;
    					
                        $.each(gridList, function(key, data) {
                        	$("#"+key).alopexGrid("dataSet", data.nc_list);
                        });
                    }]
                });
        	}else{
        		$("#EXCEL_SALE_EX_CTT").ckeditor();
        		$("#RGSTR_NM").val($.PSNM.getSession("USER_NM"));
        		$("#RGST_DTM").val(getCurrdate());
        		$("#btnDel").hide();
        	}
        },
        setCodeData : function() {
        	$.PSNMUtils.setCodeData([
				{ t:'code', 'elemid' : 'DSM_FAX_UNIT_TYP_CD', 'codeid' : 'DSM_FAX_UNIT_TYP_CD', 'header' : '-전체-' }
            ]);
        },
        setFileUpload : function () {
        	$.PSNMUtils.setFileUploadAndGrid("EXC", "#fileupload", "#gridfile");
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
            <span class="txt6_img"><b>우수영업사례</b><span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif"> 
            <span class="a2">본사업무</span> <span class="a3"> > </span><b>에이전트관리</b></span></span> 
        </div>
    </div>

    <!-- btn area -->
    <div class="btn_area">
        <div class="ab_btn_right">
            <button id="btnDel"  type="button" data-type="button" data-theme="af-btn13" data-altname="삭제" data-authtype="W"></button>
            <button id="btnSave" type="button" data-type="button" data-theme="af-btn4"  data-altname="저장" data-authtype="W"></button>
            <button id="btnList" type="button" data-type="button" data-theme="af-btn14" data-altname="목록" data-authtype="R"></button>
        </div>
    </div>
    <!-- btn area end--> 

    <!--view_list area -->
    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>우수영업사례</b></div>

    <!--view_table area -->
    <div class="view_list">

        <form id="form" onsubmit="return false;">
        	<input type="hidden" id="EXCEL_MGMT_NUM" name="EXCEL_MGMT_NUM"  data-bind="value:EXCEL_MGMT_NUM"/>
        	<div>
	            <table class="board02" style="width:100%;">
	            <colgroup>
		            <col style="width:15%"/>
		            <col style="width:35%"/>
		            <col style="width:15%"/>
		            <col style="width:*"/>
	            </colgroup>
	            <tbody>
	            <tr>
	                <th scope="col" class="fontred">에이전트</th>
					<td class="tleft">
						<input id="AGNT_NM" name="AGNT_NM" data-bind="value:AGNT_NM" data-type="textinput" data-disabled="true" style="width:130px;"
						data-validation-rule="{required:true}"
						data-validation-message="{required:$.PSNM.msg('E012', ['에이전트'])}"/>
						<input id="btnFindAgent" type="button" data-type="button" class="searchButton">
						<input id="AGNT_ID" name="AGNT_ID" data-bind="value:AGNT_ID" data-type="textinput" data-disabled="true" style="width:75px;"/>
					</td>
					<th scope="col">직책명</th>
					<td class="tleft">
						<input id="RPSTY_NM" name="RPSTY_NM" data-bind="value:RPSTY_NM" data-type="textinput" data-disabled="true" style="width:150px;"/>
						<input id="RPSTY" name="RPSTY" data-bind="value:RPSTY" data-type="textinput" data-disabled="true" style="width:75px;"/>
					</td>
	            </tr>
	            <tr>
					<th scope="col">본사팀</th>
					<td class="tleft">
						<input id="HDQT_TEAM_ORG_NM" name="HDQT_TEAM_ORG_NM" data-bind="value:HDQT_TEAM_ORG_NM" data-type="textinput" data-disabled="true" style="width:150px;"/>
						<input id="HDQT_TEAM_ORG_ID" name="HDQT_TEAM_ORG_ID" data-bind="value:HDQT_TEAM_ORG_ID" data-type="textinput" data-disabled="true" style="width:75px;"/>
					</td>
					<th scope="col">본사파트</th>
					<td class="tleft">
						<input id="HDQT_PART_ORG_NM" name="HDQT_PART_ORG_NM" data-bind="value:HDQT_PART_ORG_NM" data-type="textinput" data-disabled="true" style="width:150px;"/>
						<input id="HDQT_PART_ORG_ID" name="HDQT_PART_ORG_ID" data-bind="value:HDQT_PART_ORG_ID" data-type="textinput" data-disabled="true" style="width:75px;"/>
					</td>
				</tr>
				<tr>
					<th scope="col">영업국명</th>
					<td class="tleft">
						<input id="SALE_DEPT_ORG_NM" name="SALE_DEPT_ORG_NM" data-bind="value:SALE_DEPT_ORG_NM" data-type="textinput" data-disabled="true" style="width:150px;"/>
						<input id="SALE_DEPT_ORG_ID" name="SALE_DEPT_ORG_ID" data-bind="value:SALE_DEPT_ORG_ID" data-type="textinput" data-disabled="true" style="width:75px;"/>
					</td>	
					<th scope="col">영업팀명</th>
					<td class="tleft">
						<input id="SALE_TEAM_ORG_NM" name="SALE_TEAM_ORG_NM" data-bind="value:SALE_TEAM_ORG_NM" data-type="textinput" data-disabled="true" style="width:150px;"/>
						<input id="SALE_TEAM_ORG_ID" name="SALE_TEAM_ORG_ID" data-bind="value:SALE_TEAM_ORG_ID" data-type="textinput" data-disabled="true" style="width:75px;"/>
					</td>
				</tr>
				<tr>
	            	<th scope="col">작성자</th>
	                <td class="tleft">
	                    <input id="RGSTR_NM" name="RGSTR_NM" data-type="textinput" data-bind="value:RGSTR_NM" style="width:120px" data-disabled="true"/>
	                </td>
	                <th scope="col">작성일자</th>
	                <td class="tleft time">
	                    <input id="RGST_DTM" name="RGST_DTM" data-type="dateinput" data-bind="value:RGST_DTM" data-disabled="true" style="width:120px;"/>
	                </td>
	            </tr>
	            <tr>
	            	<th scope="col" class="fontred">상품유형</th>
	                <td class="tleft" colspan="3">
	                    <select id="DSM_FAX_UNIT_TYP_CD" data-bind="options: options_DSM_FAX_UNIT_TYP_CD, selectedOptions: DSM_FAX_UNIT_TYP_CD" data-type="select" 
	                    	   	data-validation-rule="{required:true}" 
	                           	data-validation-message="{required:$.PSNM.msg('E012', ['상품유형'])}"></select>
	                </td>
	            </tr>
	            <tr>
	                <td colspan="4" class="tleft">
	                    <textarea id="EXCEL_SALE_EX_CTT" name="EXCEL_SALE_EX_CTT" data-type="textarea" data-bind="value:EXCEL_SALE_EX_CTT" rows="10" cols="80" 
	                              data-validation-rule="{required:true}" 
	                              data-validation-message="{required:$.PSNM.msg('E012', ['내용'])}" 
	                              style='overflow: auto; width: 100%;'></textarea>
	                </td>
	            </tr>
	            </tbody>
	            </table>
            </div>
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

</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>