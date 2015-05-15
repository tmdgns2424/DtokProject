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
            $.PSNM.initialize(id, param);
            
            _param = param;
            
            $a.page.setEventListener();
            $a.page.setFileUpload();
            $a.page.setViewData();
        },
        setEventListener : function() {
        	$("#btnModi").click(function(){
            	$a.navigate("faqMgmtRgst.jsp", _param);
            });
            $("#btnList").click(function(){
            	$a.navigate("faqMgmtList.jsp", _param);
            });
            $("#btnDel").click(function(){
            	if(  $.PSNM.confirm("I004", ["삭제"] ) ){
            		var id = _param.data != null ? _param.data.FAQ_ID : "";
                	$.alopex.request("com.FAQMGMT@PFAQMGMT001_pDeleteFaq", {
                		data: {dataSet: {fields: {FAQ_ID : id}}},
                        success : function(res) {
                        	$a.navigate("faqMgmtList.jsp", _param);
                        }
                    });
            	}
            });
        },
        setViewData : function() {
        	var id = _param.data != null ? _param.data.FAQ_ID : "";
        	$.alopex.request("com.FAQMGMT@PFAQMGMT001_pDetailFaq", {
        		data: {dataSet: {fields: {FAQ_ID : id, DSM_BRD_FLAG : "R"}}},
                success:["#form", "#gridfile"]
            });
        },
        setFileUpload : function () {
        	$.PSNMUtils.setFileUploadAndGrid("FAQ", "#fileupload", "#gridfile");
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
            <span class="txt6_img"><b>FAQ관리</b><span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif"> 
            <span class="a2">나의 D-tok</span> <span class="a3"> > </span><b>소통의장</b></span></span> 
        </div>
    </div>

    <!-- btn area -->
    <div class="btn_area">
        <div class="ab_btn_right">
        	<button id="btnDel"  type="button" data-type="button" data-theme="af-btn13" data-altname="삭제" data-authtype="W"></button>
            <button id="btnModi" type="button" data-type="button" data-theme="af-btn17" data-altname="수정" data-authtype="W"></button>
            <button id="btnList" type="button" data-type="button" data-theme="af-btn14" data-altname="목록" data-authtype="R"></button>
        </div>
    </div>
    <!-- btn area end--> 

    <!--view_list area -->
    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>FAQ관리</b></div>

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
		                <th scope="col" class="fontred">제목</th>
		                <td class="tleft">
		                    <label data-bind="text:FAQ_TITL_NM"></label>
		                </td>
		                <th scope="col" class="fontred">FAQ유형</th>
		                <td class="tleft">
		                    <label data-bind="text:FAQ_TYP_NM"></label>
		                </td>
		            </tr>
		            <tr>
		            	<th scope="col">작성자</th>
		                <td class="tleft">
		                    <label data-bind="text:RGSTR_NM"></label>
		                </td>
		                <th scope="col">작성일자</th>
		                <td class="tleft time">
		                    <label data-bind="text:RGSTR_DT"></label>
		                </td>
		            </tr>
		            <tr>
		                <td colspan="4" class="tleft">
		                    <label data-bind="html:FAQ_CTT"></label>
		                </td>
		            </tr>
	            </tbody>
            </table>
            
        </form>
    </div>

    <!--view_list area -->
    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>첨부파일</b> : 하단 파일을 클릭하시면 저장 및 열기가 가능합니다.</div>
    <div id="gridfile" class="view_list" data-bind="grid:gridfile"></div>

</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>