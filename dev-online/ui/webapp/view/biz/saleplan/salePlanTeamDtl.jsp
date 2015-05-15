<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

    <jsp:include page="/view/layouts/default_head.jsp" flush="false" />
    
    <script type="text/javascript">
    
    var _param;
    
    $.alopex.page({

        init : function(id, param) { 
            $.PSNM.initialize(id, param); //PSNM공통 초기화함수 호출
            
            _param = param; //이 페이지로 전달된 파라미터를 저장
            
            $a.page.setGridTrgt();
            $a.page.setGridTrgtQty();
            $a.page.setGridTeam();
            $a.page.setViewData();
            $a.page.setEventListener();
        },
        setEventListener : function() {
			$("#btnList").click(function(){
				$a.navigate("salePlanList.jsp", _param);
            });
            $("#btnCancel").click(function(){
            	$a.back(_param);
            });
        },
        setGridTrgt : function () {
        	$("#gridtrgt").alopexGrid({
                pager : false,
                rowClickSelect : false,
                columnMapping : [
					{ columnIndex : 0, key : "UNIT_TYP_CD",			hidden : true },
                    { columnIndex : 1, key : "UNIT_TYP_NM",			title : "상품명",				align : "center", width : "100px" },
                    { columnIndex : 2, key : "MTH_PLAN_QTY",		title : "계획수량",				align : "right",  width : "100px", render : {type : "string", rule : "comma"} },
                    { columnIndex : 3, key : "EXEC_TRGT_QTY_DSM",	title : "실행목표 수량(영업국)",	align : "right",  width : "100px", render : {type : "string", rule : "comma"} },
                    { columnIndex : 4, key : "EXEC_TRGT_QTY",		title : "실행목표 수량(영업팀)",	align : "right",  width : "100px", render : {type : "string", rule : "comma"} },
                    { columnIndex : 5, key : "RL_SELL_QTY",			title : "실제 판매 수량",			align : "right",  width : "100px", render : {type : "string", rule : "comma"} }
                ]
            });
        },
        setGridTrgtQty : function () {
        	$("#gridtrgtqty").alopexGrid({
                pager : false,
                rowClickSelect : false,
                columnMapping : [
					{ columnIndex : 0, key : "TOTAL",				title : "",						align : "center", width : "100px", rowspan : true } ,
					{ columnIndex : 1, key : "UNIT_TYP_CD",			hidden : true },
                    { columnIndex : 2, key : "UNIT_TYP_NM",			title : "상품구분",				align : "center", width : "100px" },
                    { columnIndex : 3, key : "MTH_PLAN_QTY",		title : "계획수량",				align : "right",  width : "100px", render : {type : "string", rule : "comma"} },
                    { columnIndex : 4, key : "EXEC_TRGT_QTY_DSM",	title : "실행목표 수량(영업국)",	align : "right",  width : "100px", render : {type : "string", rule : "comma"} },
                    { columnIndex : 5, key : "EXEC_TRGT_QTY",		title : "실행목표 수량",			align : "right",  width : "100px", render : {type : "string", rule : "comma"} }
                ]
            });
        },
        setGridTeam : function () {
        	$("#gridteam").alopexGrid({
                pager : false,
                rowClickSelect : false,
                height : "300px",
                columnMapping : [
					{ columnIndex : 0, key : "SALE_TEAM_ORG_ID",	hidden : true },
					{ columnIndex : 1, key : "SALE_TEAM_ORG_NM",	title : "영업팀명",				align : "center", width : "100px", 	rowspan :{by:3} },
                    { columnIndex : 2, key : "TEAM_LDR_NM",			title : "팀장명",				align : "center", width : "100px", 	rowspan :{by:3} },
                    { columnIndex : 3, key : "AGNT_ID",				title : "에이전트코드",			align : "center", width : "80px", 	rowspan :true },
                    { columnIndex : 4, key : "AGNT_NM",				title : "에이전트명",				align : "center", width : "80px", 	rowspan :{by:3} },
                    { columnIndex : 5, key : "UNIT_TYP_CD",			hidden : true },
                    { columnIndex : 6, key : "UNIT_TYP_NM",			title : "상품구분",				align : "center", width : "100px" 	},
                    { columnIndex : 7, key : "MTH_PLAN_QTY",		title : "계획수량",				align : "right",  width : "80px", render : {type : "string", rule : "comma"} },
                    { columnIndex : 8, key : "EXEC_TRGT_QTY",		title : "실행목표 수량",			align : "right",  width : "80px", render : {type : "string", rule : "comma"} }
                ]
            });
        },
        setViewData : function() {
        	var salesYm = _param.data != null ? _param.data.SALES_YM : "";
        	var saleDeptOrgId = _param.data != null ? _param.data.SALE_DEPT_ORG_ID : "";
        	var saleTeamOrgId = _param.data != null ? _param.data.SALE_TEAM_ORG_ID : "";
        	
        	var HDQT_TEAM_ORG_NM = _param.data != null ? _param.data.HDQT_TEAM_ORG_NM : "";
        	var HDQT_PART_ORG_NM = _param.data != null ? _param.data.HDQT_PART_ORG_NM : "";
        	var SALE_DEPT_ORG_NM = _param.data != null ? _param.data.SALE_DEPT_ORG_NM : "";
        	var SALE_TEAM_ORG_NM = _param.data != null ? _param.data.SALE_TEAM_ORG_NM : "";
        	var RGSTR_NM = _param.data != null ? _param.data.RGSTR_NM : "";
        	
        	var _salesYm = salesYm.substring(0,4) + "-" + salesYm.substring(4,6);
        	var arrSalesYm = _salesYm.split('-');
   			var iMonth = arrSalesYm[1];		
   	        iMonth = iMonth - 1;
   	        if(iMonth < 1){
   	        	iMonth = 12;
   	        }else if(iMonth > 12){
   	        	iMonth = 1;
			}
   	         
   	     	$("#form1").setData({SALES_YM : _salesYm});
   	     	$("#form1").setData({HDQT_TEAM_ORG_NM : HDQT_TEAM_ORG_NM});
   	  		$("#form1").setData({HDQT_PART_ORG_NM : HDQT_PART_ORG_NM});
   			$("#form1").setData({SALE_DEPT_ORG_NM : SALE_DEPT_ORG_NM});
   			$("#form1").setData({SALE_TEAM_ORG_NM : SALE_TEAM_ORG_NM});
   			$("#form1").setData({RGSTR_NM : RGSTR_NM});
   	     	$(".prvMonth").setData({MONTH : iMonth});
 			$(".nowMonth").setData({MONTH : parseInt(arrSalesYm[1])});
    		
			$.alopex.request("biz.SALEPLAN@PMTHSALESPLAN001_pSearchMthExecTrgtTeam", {
				data: {dataSet: {fields: {SALES_YM : salesYm
	     								, SALE_DEPT_ORG_ID : saleDeptOrgId
	     								, SALE_TEAM_ORG_ID : saleTeamOrgId
	     								, HEADQ_YN : "N"
	     								, ORG_LVL : "2"}}},
				success:["#form5", function(res) {
					var gridList = res.dataSet.recordSets;
	             	
					$.each(gridList, function(key, data) {
						$("#"+key).alopexGrid("dataSet", data.nc_list);
	                 	if("gridcttb" == key) $("#cttListB").setData({gridcttb: data.nc_list});
	                 	if("gridcttc" == key) $("#cttListC").setData({gridcttc: data.nc_list});
	                 	if("gridcttp" == key) $("#cttListP").setData({gridcttp: data.nc_list});
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
        <div class="ub_txt6">
            <span class="txt6_img"><b>영업계획관리</b><span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif"> 
            <span class="a2">본사업무</span> <span class="a3"> > </span><b>판매관리</b></span></span> 
        </div>
    </div>

    <!-- btn area -->
    <div class="btn_area">
        <div class="ab_btn_right">
            <button id="btnList" type="button" data-type="button" data-theme="af-btn14" data-altname="목록" data-authtype="R"></button>
        </div>
    </div>
    <!-- btn area end--> 

    <!--view_list area -->
    <div class="floatL4">&nbsp;</div>
    <div class="view_list">
    	<form id="form1" onsubmit="return false;">
        	<table class="board02" style="width:100%;">
        	<colgroup>
	            <col style="width:10%"/>
	            <col style="width:22%"/>
	            <col style="width:10%"/>
	            <col style="width:22%"/>
	            <col style="width:10%"/>
	            <col style="width:*"/>
            </colgroup>
            <tr>
                <th scope="col" class="fontred">대상월</th>
                <td class="tleft"><label data-bind="text:SALES_YM"></label></td>
				<th class="fontred">본사팀</th>
				<td class="tleft"><label data-bind="text:HDQT_TEAM_ORG_NM"></label></td>
                <th class="fontred">본사파트</th>
				<td class="tleft"><label data-bind="text:HDQT_PART_ORG_NM"></label></td>
            </tr>
            <tr>
            	<th class="fontred">영업국명</th>
				<td class="tleft"><label data-bind="text:SALE_DEPT_ORG_NM"></label></td>
				<th class="fontred">영업팀명</th>
				<td class="tleft"><label data-bind="text:SALE_TEAM_ORG_NM"></label></td>
				<th class="fontred">관리자명</th>
				<td class="tleft"><label data-bind="text:RGSTR_NM"></label></td>
            </tr>
            </table>
        </form>
    </div>
    
    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif">&nbsp;<b><label class="prvMonth" data-bind="text : MONTH"></label>월 영업실적</b></div>
    <div id="gridtrgt" data-bind="grid:gridtrgt"></div>
    
    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif">&nbsp;<b><label class="prvMonth" data-bind="text : MONTH"></label>월 영업결과분석</b></div>
    <div class="view_list">
        <form id="form2" onsubmit="return false;">
            <table class="board02" style="width:100%;">
            <colgroup>
	            <col style="width:15%"/>
	            <col style="width:*"/>
            </colgroup>
            <tbody id="cttListB" data-bind="foreach: gridcttb">
            <tr>
            	<th id="limitctt" scope="col"><label data-bind="text: STRT_TITLE_NM"></label></th>
                <td class="tleft"><label data-bind="text:SALES_PLAN_CTT"></label></td>
            </tr>
            </tbody>
            </table>
        </form>
    </div>
    
    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif">&nbsp;<b><label class="nowMonth" data-bind="text : MONTH"></label>월 영업목표</b></div>
    <form id="form5" onsubmit="return false;">
    <table class="board02" style="width:100%;">
		<colgroup>
            <col style="width:10%"/>
            <col style="width:22%"/>
            <col style="width:10%"/>
            <col style="width:22%"/>
            <col style="width:10%"/>
            <col style="width:*"/>
		</colgroup>
		<tr>
			<th scope="col">등록MA수</th>
			<td class="tleft"><label id="PRSN_CNT" data-bind="text:PRSN_CNT"></label></td>
			<th scope="col">활동MA수</th>
			<td class="tleft"><label id="ACTV_PRSN_CNT" data-bind="text:ACTV_PRSN_CNT"></label></td>
			<th scope="col">증원목표(명)</th>
			<td class="tleft"><label id="INCP_PLAN_PRSN_CNT" data-bind="text:INCP_PLAN_PRSN_CNT"></label></td>
		</tr>
	</table>
	</form>
    
    <div class="floatL4"></div>
    <div id="gridtrgtqty" data-bind="grid:gridtrgtqty"></div>
    
    <div id="gridteam" data-bind="grid:gridteam"></div>
    
    <div class="floatL4"></div>
    <div class="view_list">
        <form id="form4" onsubmit="return false;">
        	<table class="board02" style="width:100%;">
            <colgroup>
	            <col style="width:15%"/>
	            <col style="width:*"/>
            </colgroup>
            <tbody id="cttListP" data-bind="foreach: gridcttp">
            <tr>
            	<th id="limitctt" scope="col"><label data-bind="text: STRT_TITLE_NM"></label></th>
                <td class="tleft"><label data-bind="text:SALES_PLAN_CTT"></label></td>
            </tr>
            </tbody>
            </table>
        </form>
    </div>
    
    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif">&nbsp;<b><label class="nowMonth" data-bind="text : MONTH"></label>월 주요 전략 (목표달성을 위한 주요 행사 및 공략시장/ 판매방식 관련 특이사항)</b></div>
    <div class="view_list">
        <form id="form3" onsubmit="return false;">
            <table class="board02" style="width:100%;">
            <colgroup>
	            <col style="width:15%"/>
	            <col style="width:*"/>
            </colgroup>
            <tbody id="cttListC" data-bind="foreach: gridcttc">
            <tr>
            	<th id="limitctt" scope="col"><label data-bind="text: STRT_TITLE_NM"></label></th>
                <td class="tleft"><label data-bind="text:SALES_PLAN_CTT"></label></td>
            </tr>
            </tbody>
            </table>
        </form>
    </div>
    
</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>