<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE HTML>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>예제 - 영업국별/일별 접속현황</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />
    
    <script type="text/javascript">
    
    var _param;

    $.alopex.page({
        init : function(id, param) {
        	_param = param; //이 페이지로 전달된 파라미터를 저장
			
            $a.page.setEventListener();
            $a.page.setGrid();
            $a.page.setGridData(param);
        },
        setEventListener : function() {
            $("#btnConfirm").click(function(){
            	$a.close();
            });
        },
        setGrid : function() {
            $("#grid").alopexGrid({
                pager: false,
                columnMapping : [
                    { columnIndex : 0, key : "DSM_CONT_ID",	title : "영업정책ID",	align : "center", 	hidden:true },
                    { columnIndex : 1
                    		, key : "YMD"
                    		, title : "접속일"
                    		, align : "center"
                    		, width : "80px" 
                   			, render : function(value, data) {
               					if(data["YMD"]=="") {
               						return '<font color="#1B1760"><STRONG>합계</STRONG></font>';
               					}else{
               						return value;
               					}
               					return value;
               				}},
                    { columnIndex : 2, key : "TTLCNT", 		title : "합계",   		align : "center",   width : "80px" },
                    { columnIndex : 3, key : "K1CNT", 		title : "서울1국",     	align : "center",   width : "80px" },
                    { columnIndex : 4, key : "K2CNT", 		title : "서울2국",     	align : "center",   width : "80px" },
                    { columnIndex : 5, key : "K3CNT",       title : "서울3국", 		align : "center", 	width : "80px" },
                    { columnIndex : 6, key : "K4CNT", 		title : "서울K1국", 		align : "center",   width : "80px" },
                    { columnIndex : 7, key : "K5CNT", 		title : "서울K2국", 		align : "center",   width : "80px" },
                    { columnIndex : 8, key : "K6CNT", 		title : "서울K3국", 		align : "center",   width : "80px" },
                    { columnIndex : 9, key : "K7CNT", 		title : "서울K5국", 		align : "center",   width : "80px" }
                ],
                on : {
                    "cell" : {
    					"click" : function(data, eh, e) {
    						
    						if( data._key == "YMD" ) { return; }
    						
    						var id = 
    							data._key === "K1CNT" ? "01020000" :
    							data._key === "K2CNT" ? "01030000" :
    							data._key === "K3CNT" ? "01040000" :
    							data._key === "K4CNT" ? "01050000" :
    							data._key === "K5CNT" ? "01060000" : 
    							data._key === "K6CNT" ? "01070000" : 
    							data._key === "K7CNT" ? "01080000" : "" ;

    						data["DSM_SALES_PLCY_ID"] 	= _param.data.DSM_SALES_PLCY_ID;
    						data["SALE_DEPT_ORG_ID"] 	= id;
    						
    						$a.popup({
    		                    url: "salePlcyContact.jsp",
    		                    data: data,
    		                    title : "영업정책 접속현황",
    		                    width: 850,
    		                    height: 400,
    		                    windowpopup: false,
    		                    iframe: true
    		                });
    					}
    				}
                }
            });
        },
        setGridData : function(param) {
        	var id = param.data != null ? param.data.DSM_SALES_PLCY_ID : "";
        	$.alopex.request("biz.SALEPLCY@PSALESPLCY001_pSearchSalesPlcyStc", {
        		data: {dataSet: {fields: {DSM_CONT_ID : id}}},
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
      
        <!--view_table area -->
        <div class="textAR">

            <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>영업국별/일별 접속현황</b>
                <p class="ab_pos2">
                </p>
            </div>

            <!-- main grid -->
            <div id="grid" data-bind="grid"></div>

            <p class="floatL2">
                <input id="btnConfirm" type="button" data-type="button" data-theme="af-btn8">
            </p>
        </div>

    </div>

</div>

</body>
</html>