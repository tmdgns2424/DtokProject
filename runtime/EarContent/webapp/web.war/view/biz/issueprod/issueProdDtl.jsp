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

    var _TX_SEARCH        = "biz.ISSUEPROD@PISSUEPROD001_pDetailIssueProd";
    var _param;
    $.alopex.page({
        init : function(id, param) { 
        	
            $.PSNM.initialize(id, param); //PSNM공통 초기화함수 호출
            _param = param;
            
            $a.page.setEventListener(); //버튼 초기화
        //    $a.page.setGrid(); //그리드 초기화
           
            $a.page.searchDtl(param);
            $a.page.setFileUpload();
        },
        setEventListener : function() {
        	$("#btnList").click(function(){
            	$a.back(_param);
            });
        }, 
        
        setFileUpload : function () {
        	$.PSNMUtils.setFileUploadAndGrid("ISS", "#fileupload", "#gridfile");
        },
        searchDtl : function(param){
              $.alopex.request(_TX_SEARCH, {
            	data: {dataSet: {fields: {ISS_ID : param.ISS_ID, DSM_BRD_FLAG : "R"}}}
            	,success: ["#form", function(res) {
					var gridList = res.dataSet.recordSets;
					
                    $.each(gridList, function(key, data) {
                    	$("#"+key).alopexGrid("dataSet", data.nc_list);
                    });
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
		<div class="ub_txt6"> <span class="txt6_img"><b>이달의 상품</b> <span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif"> <span class="a2">커뮤니티</span> <span class="a3"> > </span> <b>Main화면 알림</b> </span> </span> </div>
	</div>
	<!-- btn area -->
	<div class="btn_area">
		<div class="ab_btn_right">
            <button id="btnList" type="button" data-type="button" data-theme="af-btn14" data-altname="목록" data-authtype="R"></button>
        </div>
	</div>
	<!-- btn area end--> 
	<div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>이달의 상품</b></div>
	<!--view_table area -->
    <div class="view_list"> 
		<form id="form">
			<table class="board02">
	        	<colgroup>
		            <col style="width:13%"/>
		            <col style="width:20%"/>
		            <col style="width:13%"/>
		            <col style="width:20%"/>
		            <col style="width:13%"/>
		            <col style="width:*"/>
	            </colgroup>
				<tr>
					<th>제목</th>
					<td class="tleft" colspan="5"><label data-bind="text:ISS_TITL_NM"></label></td>
				</tr>
				<tr>
					<th>적용년월</th>
					<td class="tleft"><label data-bind="text:APLY_YM"></td>
					<th>게시자</th>
					<td class="tleft"><label data-bind="text:RGSTR_NM"></label></td>
					<th>게시일자</th>
					<td class="tleft"><label data-bind="text:RGST_DTM"></label></td>
				</tr>
				<tr>
					<td class="tleft" colspan="6"><label data-bind="html:ISS_CTT" ></label></td>
				</tr>
			</table>
		</form>  
     
	<!--view_list area -->
		<div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>첨부파일</b> : 하단 파일을 클릭하시면 저장 및 열기가 가능합니다.</div>
		<div id="gridfile" class="view_list" data-bind="grid:gridfile"></div>

	</div>
  
</div>
<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />
</body>
</html>