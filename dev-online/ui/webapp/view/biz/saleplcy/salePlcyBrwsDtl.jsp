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
            $a.page.setFileUpload();
            $a.page.setViewData();
            $.PSNMAction.setCmntData(param.data.DSM_SALES_PLCY_ID); // 댓글조회(이페이지로 전달된 아이디)
        },
        setEventListener : function() {
            $("#btnList").click(function(){
            	$a.back(_param);
            });
            $("#btnCmntSave").click(function(){
            	var id = _param.data.DSM_SALES_PLCY_ID; // 이페이지로 전달된 아이디
            	$.PSNMAction.saveCmntData(id, $("#cmnt")); // 댓글저장
            });
        },
        setViewData : function() {
        	var id = _param.data != null ? _param.data.DSM_SALES_PLCY_ID : "";
        	$.alopex.request("biz.SALEPLCY@PSALESPLCY001_pDetailSalesPlcy", {
        		data: {dataSet: {fields: {DSM_SALES_PLCY_ID : id, DSM_BRD_FLAG : "R"}}},
                success:["#form",  function(res) {
                	
                	var gridList = res.dataSet.recordSets;
					
                    $.each(gridList, function(key, data) {
                    	$("#"+key).alopexGrid("dataSet", data.nc_list);
                    });
                }]
            });
        },
        setFileUpload : function () {
        	$.PSNMUtils.setFileUploadAndGrid("PLC", "#fileupload", "#gridfile");
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
            <span class="txt6_img"><b>영업정책</b><span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif"> 
            <span class="a2">커뮤니티</span> <span class="a3"> > </span><b>Main화면 알림</b></span></span> 
        </div>
    </div>

    <!-- btn area -->
    <div class="btn_area">
        <div class="ab_btn_right">
            <button id="btnList" type="button" data-type="button" data-theme="af-btn14" data-altname="목록"></button>
        </div>
    </div>
    <!-- btn area end--> 

    <!--view_list area -->
    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>영업정책</b> 
    </div>

    <!--view_table area -->
    <div class="view_list">

        <form id="form" onsubmit="return false;">
            <table class="board02" style="width:100%;">
            <colgroup>
	            <col style="width:15%"/>
	            <col style="width:35%"/>
	            <col style="width:15%"/>
	            <col style="width:*"/>
            </colgroup>
            <tbody>
            <tr>
                <th scope="col">제목</th>
                <td colspan="3" class="tleft"><label data-bind="text:SALES_PLCY_NM"></label></td>
            </tr>
            <tr>
                <th scope="col">적용일자</th>
                <td class="tleft time"><label data-bind="text:APLY_STA_DT"></label></td>
                <th scope="col">정책유형</th>
                <td class="tleft"><label data-bind="text:DSM_SALES_PLCY_TYP_NM"></label></td>
            </tr>
            <tr>
            	<th scope="col">작성자</th>
                <td class="tleft"><label data-bind="text:USER_NM"></label></td>
                <th scope="col">작성일자</th>
                <td class="tleft time"><label data-bind="text:RGST_DTM"></label></td>
            </tr>
            <tr>
                <td colspan="4" class="cont"><label data-bind="html:SALES_PLCY_CTT"></label></td>
            </tr>
            </tbody>
            </table>
        </form>
    </div>

    <!--view_list area -->
    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>첨부파일</b> : 하단 파일을 클릭하시면 저장 및 열기가 가능합니다.</div>
    <div id="gridfile" class="view_list" data-bind="grid:gridfile"></div>
    
    <!--view_댓글 area -->
  	<jsp:include page="/view/layouts/cmnt_comm.jsp" flush="false" />

</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>