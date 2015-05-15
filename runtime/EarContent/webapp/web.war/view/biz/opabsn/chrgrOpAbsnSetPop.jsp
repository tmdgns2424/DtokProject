<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE HTML>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>회원정보조회</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />
    
    <script type="text/javascript">

    $.alopex.page({
        init : function(id, param) {
        	
            $a.page.setEventListener();
            $a.page.setGrid();
            $a.page.searchList(param);
        },
        setEventListener : function() {
        	$("#btnConfirm").click(function(){
        		var oRecord = $("#grid").alopexGrid( "dataGet" , { _state : { selected : true } } );
        		if (oRecord.length == 0) {
                    alert("담당자정보를 선택하십시오!");
                    return;
                }
        		$a.close( oRecord[0] );
            });
            $("#btnCancel").click(function(){
            	$a.close();
            });
        },
        setGrid : function() {
            $("#grid").alopexGrid({
                pager: false,
                rowSingleSelect : true,
                columnMapping : [
                    { columnIndex : 0, key : "HDQT_TEAM_ORG_NM",	title : "본사팀",		align : "center", 	width : "80px" },
                    { columnIndex : 1, key : "HDQT_PART_ORG_NM", 	title : "본사파트",   	align : "center",   width : "80px" },
                    { columnIndex : 2, key : "SALE_DEPT_ORG_NM", 	title : "담당영업국",   	align : "center",   width : "100px"},
                    { columnIndex : 3, key : "USER_NM", 			title : "담당자명",		align : "center",   width : "80px" }
                ]
            });
        },
        searchList : function(param) {
        	$.alopex.request("biz.OPABSN@PCHRGROPABSN001_pSearchChrgrOpabsnUser", {
        		data: function() {
                    this.data.dataSet.fields = param;
                },
                success: "#grid"
            });
        }
    });

    </script>
</head>
<body>

<div id="Wrap">

    <!-- title area -->
    <div class="pop_header">
      
        <!--view_table area -->
        <div class="textAR">

            <div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>담당자 목록</b>
                <p class="ab_pos2"></p>
            </div>

            <!-- main grid -->
            <div id="grid" data-bind="grid:grid"></div>

            <p class="floatL2">
                <input id="btnConfirm" type="button" data-type="button" data-theme="af-btn8">
                <input id="btnCancel"  type="button" data-type="button" data-theme="af-btn10">
            </p>
        </div>

    </div>

</div>

</body>
</html>