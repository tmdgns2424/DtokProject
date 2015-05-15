<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

    <jsp:include page="/view/layouts/default_head.jsp" flush="false" />

    <script type="text/javascript">
    $.alopex.page({

        init : function(id, param) { 
            $.PSNM.initialize(id, param); //PSNM공통 초기화함수 호출

            $.PSNMUtils.setDefaultYmd("#FROM_DT", "TO_DT");
            $a.page.setEventListener();
            $a.page.setGrid();
            $("#searchTable").setData(param);  //(설명) 상세페이지에서 돌아오는 경우, 이 값들이 세션스토리지에서 반환됨.
        },
        setEventListener : function() {
        	$("#btnSearch").click(function(){
        		if ( ! $.PSNM.isValid("#searchForm") ) {
    			    return false; //값 검증
    			}
        		$a.page.searchList();
        	});
            $("#btnExcelAll").click(function(){
            	var oExcelMetaInfo = {
                        filename  : "교육현황.xls",
                        sheetname : "교육현황",
                        gridname  : "gridedu" //그리드ID 
                    };
        		var txid = "biz.AGNTEDU@PAGENTEDU001_pSearchAgentEduPrst";

        		$.PSNMUtils.downloadExcelAll("searchForm", txid, "gridedu", oExcelMetaInfo);
            });
            $("#AGNT_NM").keyup( $.PSNMAction.findAgent );
        },
        setGrid : function() {
            $("#gridedu").alopexGrid({
                rowClickSelect : false,
                rowInlineEdit : true,
                columnMapping : [
                    { columnIndex : 0, key : "EDU_DT",            	title : "교육일자",		align : "center", width : "100px" },
                    { columnIndex : 1, key : "EDU_NM",  			title : "교육명",		align : "left",   width : "250px" },
                    { columnIndex : 2, key : "HDQT_PART_ORG_NM",    title : "본사파트",		align : "center", width : "100px" },
                    { columnIndex : 3, key : "SALE_DEPT_ORG_NM",	title : "영업국명",		align : "center", width : "100px" },
                    { columnIndex : 4, key : "SALE_TEAM_ORG_NM",	title : "영업팀명",		align : "center", width : "100px" },
                    { columnIndex : 5, key : "AGNT_ID",   			title : "에이전트코드",	align : "center", width : "100px" },
                    { columnIndex : 6, key : "RPSTY_NM",   			title : "직책명",		align : "center", width : "100px" },
                    { columnIndex : 7, key : "AGNT_NM",   			title : "에이전트명",		align : "center", width : "100px" },
                    { columnIndex : 8, key : "EDU_MANN_CD_NM",   	title : "교육태도",		align : "center", width : "100px" },
                    { columnIndex : 9, key : "EVAL_RSLT_CD_NM",   	title : "평가결과",		align : "center", width : "100px" },
                    { columnIndex : 10, key : "MEMO",   			title : "특이사항",		align : "center", width : "150px" }
                ],
                on : {
                	pageSet : function(pageNoToGo) {
                        var p = {};
                            p.page = pageNoToGo;
                            $a.page.searchList(p);
                    }
                }
            });
        },
        searchList: function(param) {
            var _page_no = 1;
            if ( $.PSNMUtils.isNotEmpty(param) && $.PSNMUtils.isNotEmpty(param.page) ) {
                _page_no = param.page;
            }
            var _per_page = $("#gridedu").alopexGrid("pageInfo").perPage;
            
            $.alopex.request("biz.AGNTEDU@PAGENTEDU001_pSearchAgentEduPrst", {
                data: ["#searchTable", function() {
                	this.data.dataSet.fields.FROM_DT   = $.PSNMUtils.getDateInput("FROM_DT");
                	this.data.dataSet.fields.TO_DT     = $.PSNMUtils.getDateInput("TO_DT");
                    this.data.dataSet.fields.page      = _page_no;
                    this.data.dataSet.fields.page_size = _per_page;
                }],
                success: ["#gridedu", function(res) {
                }]
            });
        }
    });

    </script>

</head>

<body>


<jsp:include page="/view/layouts/default_header.jsp" flush="false" />

<!-- contents area -->
<div id="contents">

	<!-- sub title area -->
    <div class="content_title">
        <div id="ub_txt6">
            <span class="txt6_img"><b id="sub-title">교육현황</b>
                <span class="notice-more"> 
                	<img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif">
                	<span class="a2">본사업무</span> <span class="a3"> > </span> <span class="a4"><b>에이전트관리</b></span>
                </span> 
            </span>
        </div>
    </div>

    <!-- find condition area -->
    <div id="searchDiv" class="textAR">
		<form id="searchForm" onsubmit="return false;">
        	<table id="searchTable" class="board02" style="width:92%;">
        	<colgroup>
	            <col style="width:10%"/>
	            <col style="width:30%"/>
	            <col style="width:10%"/>
	            <col style="width:20%"/>
	            <col style="width:10%"/>
	            <col style="width:*;"/>
            </colgroup>
            <tr>
                <th scope="col" class="fontred">조회기간</th>
                <td class="tleft">
                	<div data-type="daterange" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png" >
						<input id="FROM_DT" name="FROM_DT" data-role="startdate" data-bind="value:FROM_DT" style="width:70px;"/>
						~ <input id="TO_DT" name="TO_DT" data-role="enddate" data-bind="value:TO_DT" style="width:70px;"/>
					</div>
				</td>
				<th class="fontred">본사팀</th>
				<td class="tleft">
                    <select id="HDQT_TEAM_ORG_ID" data-bind="options:options_HDQT_TEAM_ORG_ID, selectedOptions: HDQT_TEAM_ORG_ID" data-type="select" 
                    	data-validation-rule="{required:true}"
						data-validation-message="{required:$.PSNM.msg('E012', ['본사팀'])}">
                    	<option value="">-선택-</option>
                    </select>
                </td>
                <th>본사파트</th>
				<td class="tleft">
                    <select id="HDQT_PART_ORG_ID" data-bind="options:options_HDQT_PART_ORG_ID, selectedOptions: HDQT_PART_ORG_ID" data-type="select" >
                    	<option value="">-선택-</option>
                    </select>
                </td>
            </tr>
            <tr>
                <th>영업국명</th>
				<td class="tleft">
                    <select id="SALE_DEPT_ORG_ID" data-bind="options:options_SALE_DEPT_ORG_ID, selectedOptions: SALE_DEPT_ORG_ID" data-type="select" >
                    	<option value="">-선택-</option>
                    </select>
                </td>
				<th>영업팀명</th>
				<td class="tleft">
                    <select id="SALE_TEAM_ORG_ID" data-bind="options:options_SALE_TEAM_ORG_ID, selectedOptions: SALE_TEAM_ORG_ID" data-type="select" >
                    	<option value="">-선택-</option>
                    </select>
                </td>
                <th>에이전트명</th>
				<td class="tleft">
                    <input id="AGNT_NM" name="AGNT_NM" data-bind="value:AGNT_NM" data-type="textinput" data-agentid="AGNT_ID" style="width:70px;" maxlength="10" />
                    <input id="AGNT_ID" name="AGNT_ID" data-bind="value:AGNT_ID" data-type="textinput" data-disabled="true" style="width:70px;" />
                </td>
            </tr>
            </table>
			<div class="ab_pos4">
				<button id="btnSearch" type="button" data-type="button" data-theme="af-psnm" data-authtype="R"></button>
			</div>
        </form>
    </div>

    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>교육현황</b>
        <p class="ab_pos2">
        	<button id="btnExcelAll" type="button" data-type="button" data-theme="af-btn3" data-altname="엑셀다운" data-authtype="W"></button>
        </p>
    </div>

    <!-- main grid -->
    <div id="gridedu" data-bind="grid:gridedu"></div>

</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>