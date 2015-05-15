<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE HTML>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>공지사항 필수 확인현황</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />
    
    <script type="text/javascript">

    $.alopex.page({
        init : function(id, param) {
        	
            $a.page.setEventListener();
            $a.page.setGrid();
            $a.page.setViewData(param);
        },
        setEventListener : function() {
        	$("#btnExcelPage").click(function(){
            	var oExcelMetaInfo = {
                        filename  : "공지사항필수확인현황.xls",
                        sheetname : "공지사항필수확인현황",
                        gridname  : "grid" //그리드ID 
                    };
            	
            	$.PSNMUtils.downloadExcelPage("grid", oExcelMetaInfo);
            });
            $("#btnConfirm").click(function(){
            	$a.close();
            });
        },
        setGrid : function() {
            $("#grid").alopexGrid({
                pager: false,
                rowSingleSelect : true,
                columnMapping : [
                    { columnIndex : 0, key : "SALE_DEPT_ORG_NM",	title : "영업국명",		align : "center", 	width : "80px" },
                    { columnIndex : 1, key : "SALE_TEAM_ORG_NM", 	title : "영업팀명",   	align : "center",   width : "80px" },
                    { columnIndex : 2, key : "AGNT_ID", 			title : "에이전트코드",	align : "center",   width : "80px" },
                    { columnIndex : 3, key : "RPSTY_NM", 			title : "직책명",     	align : "center",   width : "80px" },
                    { columnIndex : 4, key : "AGNT_NM",       		title : "에이전트명", 	align : "center", 	width : "80px" },
                    { columnIndex : 5, key : "CTCT_TM", 			title : "확인시간", 		align : "center",   width : "80px" }
                ]
            });
        },
        setViewData : function(param) {
        	var annceId 		= param != null ? param.ANNCE_ID : "";
        	var ymd 			= param != null ? param.YMD : "";
        		ymd 			= ymd == "합계" ? "" : ymd;
        	var saleDeptOrgId 	= param != null ? param.SALE_DEPT_ORG_ID : "";
        	
        	$.alopex.request("com.ANNCEMGMT@PANNCEMGMT001_pSearchAnnceMndtChk", {
        		data: {dataSet: {fields: {ANNCE_ID : annceId
        								, YMD : ymd
        								, SALE_DEPT_ORG_ID : saleDeptOrgId}}},
                success: ["#grid", function(res) {
                	$("#count").html(res.dataSet.fields.count);
                }]
            });
        }
    });

    </script>
</head>
<body>

<div id="contents">

    <!-- title area -->
    <div class="pop_header">
      
        <!--view_table area -->
        <div class="textAR">

            <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>공지사항 필수 확인현황</b>
                <p class="ab_pos2">
                	(총<label id="count"></label>건)
                	<button id="btnExcelPage" type="button" data-type="button" data-theme="af-btn3" data-altname="엑셀다운"></button>
                </p>
            </div>

            <!-- main grid -->
            <div id="grid" data-bind="grid:grid"></div>

            <p class="floatL2">
                <input id="btnConfirm" type="button" data-type="button" data-theme="af-btn8">
            </p>
        </div>
        
        <div id="footer-hidden-area" style="display:none;">
    		<iframe id="footer-hidden-iframe" src="" width="90%;" height="50"></iframe>
		</div>

    </div>

</div>

</body>
</html>