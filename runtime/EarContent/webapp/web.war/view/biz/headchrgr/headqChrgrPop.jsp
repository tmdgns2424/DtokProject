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
 			$("#form").setData(param);           
        },
        setEventListener : function() {
        	$("#btnSearch").click($a.page.searchList);
        	$("#btnConfirm").click(function(){
        		var oRecord = $("#grid").alopexGrid( "dataGet" , { _state : { selected : true } } );
        		if (oRecord.length == 0) {
        			$.PSNM.alert("회원정보를 선택하십시오!");
                    return;
                }
        		$a.close( oRecord );
            });
            $("#btnCancel").click(function(){
            	$a.close();
            });
        },
        setGrid : function() {
            $("#grid").alopexGrid({
                pager: false,
                height: "300px",
                columnMapping : [
					{ columnIndex : 0, selectorColumn : true, 	width : "30px" },
                    { columnIndex : 1, key : "USER_ID",			title : "회원ID",		align : "center", 	width : "80px" },
                    { columnIndex : 2, key : "USER_NM", 		title : "회원명",   		align : "center",   width : "80px" },
                    { columnIndex : 3, key : "DUTY_NM", 		title : "직무",			align : "center",   width : "80px" },
                    { columnIndex : 4, key : "JOB_DESC", 		title : "담당업무",     	align : "center",   width : "80px" },
                    { columnIndex : 5, key : "HDQT_TEAM_ORG_NM",		title : "본사팀",     	align : "center",   width : "80px" },
                    { columnIndex : 6, key : "HDQT_PART_ORG_NM", 		title : "본사파트",     	align : "center",   width : "80px" },
                    { columnIndex : 7, key : "SMS_YN",			title : "SMS수신여부", 	hidden : true }
                ]
            });
        },
        searchList : function() {
        	$.alopex.request("biz.HEADCHRGR@PCHRGRHEADQ001_pSearchChrgrHeadqApprove", {
                data: "#form",
                success: ["#grid", function(res) {
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
    	
    	<div class="psnm-find-area" style="height:65px;">
			<div class="psnm-find-condarea">
                <form id="form">
		        	<input id=SALE_DEPT_ORG_ID data-type="hidden" data-bind="value:SALE_DEPT_ORG_ID" type="hidden"/>
		        	<table id="searchTable" class="board02">
		        	<colgroup>
			            <col style="width:15%"/>
			            <col style="width:20%"/>
			            <col style="width:15%"/>
			            <col style="width:*"/>
		            </colgroup>
		            <tr>
						<th>회원ID</th>
						<td class="tleft">
		                    <input id="USER_ID" name="USER_ID" data-bind="value:USER_ID" data-type="textinput" style="width:70px;" maxlength="10" />
		                </td>
		                <th>회원명</th>
						<td class="tleft" colspan="3">
		                    <input id="USER_NM" name="USER_NM" data-bind="value:USER_NM" data-type="textinput" style="width:70px;" />
		                </td>
		            </tr>
		            </table>
	            </form>
			</div>
            <div class="psnm-find-btnarea">
                <button id="btnSearch" type="button" data-type="button" data-theme="af-psnm" data-authtype="R"></button>
            </div>
        </div>
      
        <!--view_table area -->
        <div class="textAR">
        	<div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>사용자목록</b></div>
            <div id="grid" data-bind="grid"></div>
            <p class="floatL2">
                <button id="btnConfirm" type="button" data-type="button" data-theme="af-btn8" data-altname="확인"></button>
                <button id="btnCancel" type="button" data-type="button" data-theme="af-btn10" data-altname="취소"></button>
            </p>
        </div>
        
    </div>

</div>

</body>
</html>