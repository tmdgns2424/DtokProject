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
            $a.page.setGrid1();
            $a.page.setViewData();
        },
        setEventListener : function() {
            $("#btnList").click(function(){
            	$a.back(_param);
            });
        },
        setViewData : function() {
        	var id = _param.data != null ? _param.data.AGENT_EDUT_MGMT_NUM : "";
        	$.alopex.request("biz.AGNTEDU@PAGENTEDU001_pDetailAgentEdu", {
        		data: {dataSet: {fields: {AGENT_EDUT_MGMT_NUM : id}}},
                success:["#form",  function(res) {
                	var gridList = res.dataSet.recordSets;
					
                    $.each(gridList, function(key, data) {
                    	$("#"+key).alopexGrid("dataSet", data.nc_list);
                    });
                	$("#form").setData({STU_MA_COUNT : $("#grid1").alopexGrid("dataGet").length});
                }]
            });
        },
        setGrid1 : function () {
        	$("#grid1").alopexGrid({
                pager : false,
                rowClickSelect : false,
                height : "300px", 
                columnMapping : [
                    { columnIndex : 0, key : "HDQT_PART_ORG_NM",	title : "본사파트",		align : "center", width : "100px" },
                    { columnIndex : 1, key : "SALE_DEPT_ORG_NM",	title : "영업국명",		align : "center", width : "100px" },
                    { columnIndex : 2, key : "SALE_TEAM_ORG_NM",	title : "영업팀명",		align : "center", width : "100px" },
                    { columnIndex : 3, key : "AGNT_ID",   			title : "에이전트코드",	align : "center", width : "100px" },
                    { columnIndex : 4, key : "RPSTY_NM",   			title : "직책명",		align : "center", width : "100px" },
                    { columnIndex : 5, key : "AGNT_NM",   			title : "에이전트명",		align : "center", width : "100px" },
                    { columnIndex : 6, key : "EDU_MANN_CD_NM",   	title : "교육태도",		align : "center", width : "100px" },
                    { columnIndex : 7, key : "EVAL_RSLT_CD_NM",   	title : "평가결과",		align : "center", width : "100px" },
                    { columnIndex : 8, key : "MEMO",   				title : "특이사항",		align : "center", width : "150px" }
                ]
            });
        },
        setFileUpload : function () {
        	$.PSNMUtils.setFileUploadAndGrid("EDU", "#fileupload", "#gridfile");
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
            <span class="txt6_img"><b>교육관리</b><span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif"> 
            <span class="a2">영업팀업무</span> <span class="a3"> > </span><b>에이전트관리</b></span></span> 
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
    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>교육관리</b></div>

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
                <th scope="col">교육명</th>
                <td class="tleft"><label data-bind="text:EDU_NM"></label></td>
                <th scope="col">본사파트</th>
                <td class="tleft"><label data-bind="text:HDQT_PART_ORG_NM"></label></td>
            </tr>
            <tr>
                <th scope="col">교육주체</th>
                <td class="tleft time"><label data-bind="text:EDUT_OWNR_NM"></label></td>
                <th scope="col">강사명</th>
                <td class="tleft"><label data-bind="text:LECTR_NM"></label></td>
            </tr>
            <tr>
            	<th scope="col">시행일시</th>
                <td class="tleft" colspan="3">
                	<label data-bind="text:EDU_DT"></label>&nbsp;&nbsp;
                	<label data-bind="text:EDU_STA_H"></label> : <label data-bind="text:EDU_STA_M"></label> ~ 
                	<label data-bind="text:EDU_END_H"></label> : <label data-bind="text:EDU_END_M"></label>
                </td>
            </tr>
            <tr>
            	<th scope="col">교육장소</th>
                <td class="tleft"><label data-bind="text:EDU_PLC_NM"></label></td>
                <th scope="col">참석인원</th>
                <td class="tleft"><label data-bind="text:STU_MA_COUNT"></label></td>
            </tr>
            <tr>
            	<th scope="col">교육내용</th>
                <td colspan="3" class="tleft"><label data-bind="text:EDU_CTT"></label></td>
            </tr>
            </tbody>
            </table>
        </form>
    </div>
    
    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>참석자현황 및 결과</b></div>
    <div id="grid1" data-bind="grid:grid1"></div>

    <!--view_list area -->
    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>첨부파일</b> : 하단 파일을 클릭하시면 저장 및 열기가 가능합니다.</div>
    <div id="gridfile" class="view_list" data-bind="grid:gridfile"></div>

</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>