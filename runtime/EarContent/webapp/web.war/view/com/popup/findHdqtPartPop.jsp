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
        	
        	$.PSNM.setOrgSelectBox(); //$.PSNM.initOrgSelectBox(); //본사팀, 본사파트, 영업국 select 객체 초기화
        	
            $a.page.setEventListener();
            $a.page.setGrid();
            $a.page.searchList();
        },
        setEventListener : function() {
        	$("#btnSearch").click($a.page.searchList);
        	$("#btnConfirm").click(function(){
        		var oRecord = $("#grid").alopexGrid( "dataGet" , { _state : { selected : true } } );
        		if (oRecord.length == 0) {
                    alert("본사파트를 선택하십시오!");
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
					{ columnIndex : 0, selectorColumn : true, width : "20px" },
                    { columnIndex : 1, key : "HDQT_PART_ORG_ID",	title : "본사파트ID",	align : "center", 	width : "80px" },
                    { columnIndex : 2, key : "HDQT_PART_ORG_NM", 	title : "본사파트",   	align : "center",   width : "80px" }
                ]
            });
        },
        searchList : function() {
        	$.alopex.request("com.CODE@PCODE_pSearchHdqtPart", {
                data: "#sform",
                success: "#grid"
            });
        }
    });

    </script>
</head>
<body>

<div id="Wrap">

	<div class="pop_header" style="min-width: 600px;">

        <div class="textAR">
			<table class="board02" id="sform" style="width:90%;">
	        	<colgroup>
		            <col style="width:10%"/>
		            <col style="width:*"/>
	            </colgroup>
				<tr>
                 	<th scope="col">본사팀</th>
                 	<td class="tleft">
                     	<select id="HDQT_TEAM_ORG_ID" data-bind="options:options_HDQT_TEAM_ORG_ID, selectedOptions: HDQT_TEAM_ORG_ID" data-type="select" >
                    		<option value="">-선택-</option>
                    	</select>
                 	</td>
             	</tr>
           	</table>
            <div class="ab_pos5">
                <input id="btnSearch" type="button" value="" data-type="button" data-theme="af-psnm">
            </div>
        </div>

        <!-- view_table area -->
        <div class="textAR1" style="min-height:200px;">
            <div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>본사파트 목록</b>
                <p class="ab_pos2">
                </p>
            </div>

            <!-- main grid -->
            <div id="grid" data-bind="grid:grid"></div>
        </div>

        <!-- button area -->
        <div class="textAR" style="min-height:30px;">
            <p class="floatL2">
                <button id="btnConfirm" type="button" data-type="button" data-theme="af-btn8" data-altname="확인"></button>
                <button id="btnCancel" type="button" data-type="button" data-theme="af-btn10" data-altname="취소"></button>
            </p>
        </div>
    </div>

</div>

</body>
</html>