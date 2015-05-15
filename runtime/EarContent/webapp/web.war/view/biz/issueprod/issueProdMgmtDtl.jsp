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
    _LOG_LEVEL = 0; //로그레벨 :: 0=debug, 1=info, 2=error

    var _TX_SEARCH      = "biz.ISSUEPROD@PISSUEPROD001_pDetailIssueProd";
    var _TX_SAVE        = "biz.ISSUEPROD@PISSUEPROD001_pSaveIssueProd";
    var _TX_DELETE        = "biz.ISSUEPROD@PISSUEPROD001_pDeleteIssueProd";
    var _param;
    $.alopex.page({
		init : function(id, param) { 
         	
			$.PSNM.initialize(id, param); //PSNM공통 초기화함수 호출
			_param = param;
            $a.page.setEventListener(); //버튼 초기화
			if(param.ISS_ID == null){
				$("#RGSTR_NM").setData({RGSTR_NM : $.PSNM.getSession("USER_NM")});
				$("#ISS_CTT").ckeditor();
				var today = new Date();
	            var Day = today.getFullYear()+"-"+((today.getMonth()+1)<10?"0"+(today.getMonth()+1):(today.getMonth()+1)); //현재 년/월
	           	$("#APLY_YM").val(Day);
	            $("#btnDel").hide();
            }
            else{
				$a.page.searchDtl(param);
   			}
            $a.page.setFileUpload();
        },
        setEventListener : function() {
         	$("#btnList").click(function(){
			$a.back(_param);
            });
         	$("#btnFileDel").click(function(){
            	$.PSNMUtils.delFile();
            });
			$("#btnSave").click(function(){
				if ( ! $.PSNM.isValid("#form") ) {
				    return false; //값 검증
				}
               	
               	if(  $.PSNM.confirm("I004", ["저장"] ) ){
               		var requestData = $.PSNMUtils.getRequestData("form", "gridfile");
                   	$.alopex.request(_TX_SAVE, { 
													 data	: requestData,
													 success: function(res) { 
														$a.navigate("issueProdMgmtList.jsp", _param);
													 }
                	});
           		}
            });
			$("#btnDel").click(function(){
            	if(  $.PSNM.confirm("I004", ["삭제"] ) ){
            		var id = _param.ISS_ID != null ? _param.ISS_ID : "";
                	$.alopex.request(_TX_DELETE, {
													data	: {dataSet: {fields: {ISS_ID : id}}},
													success : function(res) {
														$a.navigate("issueProdMgmtList.jsp", _param);
													}
                    });
            	}
            });
        }, 
         
        setFileUpload : function () {
			$.PSNMUtils.setFileUploadAndGrid("ISS", "#fileupload", "#gridfile");
        },
        searchDtl : function(param){
			var id = _param.ISS_ID != null ? _param.ISS_ID : "";
			$.alopex.request(_TX_SEARCH, {
											data	: {dataSet: {fields: {ISS_ID : id, DSM_BRD_FLAG : "R"}}},
											success	: ["#form", function(res) {
														var gridList = res.dataSet.recordSets;
														$.each(gridList, function(key, data) {
															$("#"+key).alopexGrid("dataSet", data.nc_list);
														});
														$("#ISS_CTT").ckeditor();
											}]
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
		<div class="ub_txt6"> <span class="txt6_img"><b>이달의 상품관리</b> <span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif"> <span class="a2">본사업무</span> <span class="a3"> > </span> <b>커뮤니티관리</b> </span> </span> </div>
	</div>
	<!-- btn area -->
    <!-- btn area -->
	<div class="btn_area">
		<div class="ab_btn_right">
			<button id="btnDel"  type="button" data-type="button" data-theme="af-btn13" data-altname="삭제" data-authtype="W"></button>
			<button id="btnSave" type="button" data-type="button" data-theme="af-btn4"  data-altname="저장" data-authtype="W"></button>
			<button id="btnList" type="button" data-type="button" data-theme="af-btn14" data-altname="목록" data-authtype="R"></button>
        </div>
    </div>
    <!-- btn area end--> 
	<!-- btn area end--> 
	<div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>이달의 상품관리</b></div>
	<!--view_table area -->
    <div class="view_list"> 
		<form id="form">
			<input type="hidden" id="ISS_ID" name="ISS_ID"  data-bind="value:ISS_ID"/>
			<table class="board02">
	        	<colgroup>
		            <col style="width:10%"/>
		            <col style="width:22%"/>
		            <col style="width:10%"/>
		            <col style="width:22%"/>
		            <col style="width:10%"/>
		            <col style="width:*"/>
	            </colgroup>
				<tr>
					<th class="fontred">제목</th>
					<td class="tleft" colspan="5">
						<input id="ISS_TITL_NM" name="ISS_TITL_NM" data-bind="value:ISS_TITL_NM" data-type="textinput" data-validation-rule="{required:true}" data-validation-message="{required:$.PSNM.msg('E012', ['제목'])}" style="width:95%">
					</td>
				</tr>
				<tr>
					<th>적용년월</th>
					<td class="tleft">
						<input id="APLY_YM" name="APLY_YM" data-type="dateinput" data-pickertype="monthly" data-bind="value:APLY_YM" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png" style="width:70px"/>
					</td>
					<th>게시자</th>
					<td class="tleft"><label id="RGSTR_NM" data-bind="text:RGSTR_NM"></label></td>
					<th>게시일자</th>
					<td class="tleft"><label id="RGST_DTM" data-bind="text:RGST_DTM"></label></td>
				</tr>
				<tr>
					<td class="tleft" colspan="6">
						<textarea id="ISS_CTT" name="ISS_CTT" data-type="textarea" data-bind="value:ISS_CTT" rows="10" cols="80"  style='overflow: auto; width: 100%;'>
						</textarea>
					</td>
				</tr>
			</table>
		</form>  
     
	<!--view_list area -->
		<div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>첨부파일</b> : 하단 파일을 클릭하시면 저장 및 열기가 가능합니다.
			<div class="ab_pos1" style="float:right;">
				<div style="position:relative;">
					<span class="file-button type1"><input id="fileupload" type="file"></span>
					<button id="btnFileDel" data-type="button" class="af-n-btn5"></button>
				</div>
			</div>
		</div>
		<div id="gridfile" class="view_list" data-bind="grid:gridfile"></div>
		
	</div>
</div>
<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />
</body>
</html>