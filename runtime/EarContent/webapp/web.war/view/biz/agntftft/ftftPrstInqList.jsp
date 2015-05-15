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

            $a.page.setEventListener();
            $a.page.setGrid();
            $("#CNSL_DT").val(getCurrdate().substr(0,7));
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
                        filename  : "면담현황조회.xls",
                        sheetname : "면담현황조회",
                        gridname  : "grid" //그리드ID 
                    };
        		var txid = "biz.AGNTFTFT@PAGENTCNSLPRSS001_pSearchAgentCnslPrssTotal";

        		$.PSNMUtils.downloadExcelAll("searchForm", txid, "grid", oExcelMetaInfo);
            });
        },
        setGrid : function() {
            $("#grid").alopexGrid({
            	rowClickSelect : false,
                rowInlineEdit : true,
                columnMapping : [
                    { columnIndex : 0, key : "CNSL_MTH",			title : "면담월",			align : "center", 	width : "80px"	},
                    { columnIndex : 1, key : "HDQT_PART_ORG_NM",    title : "본사파트",			align : "center", 	width : "100px" },
                    { columnIndex : 2, key : "SALE_DEPT_ORG_NM",	title : "영업국명",			align : "center", 	width : "100px" },
                    { columnIndex : 3, key : "SALE_TEAM_ORG_NM",	title : "영업팀명",			align : "center", 	width : "100px" },
                    { columnIndex : 4, key : "AGNT_ID",				title : "에이전트코드",		align : "center", 	width : "80px"	},
                    { columnIndex : 5, key : "RPSTY_NM",			title : "직책명",			align : "center", 	width : "100px" },
                    { columnIndex : 6, key : "AGNT_NM",				title : "에이전트명",			align : "center", 	width : "80px" 	},
                    { columnIndex : 7, key : "CNSLR_ID",			title : "면담자코드",			align : "center", 	width : "80px" 	},
                    { columnIndex : 8, key : "CNSLR_RPSTY_NM",		title : "면담자직책",			align : "center", 	width : "100px" },
                    { columnIndex : 9, key : "CNSLR_NM",			title : "면담자명",			align : "center", 	width : "80px" 	},
                    { columnIndex : 10, key : "TOT_SUIT",			title : "합계/적합",			align : "center", 	width : "100px" },
                    { columnIndex : 11, key : "RG_SUIT",			title : "정기면담/적합",		align : "center", 	width : "100px" },
                    { columnIndex : 12, key : "OC_SUIT",			title : "수시면담/적합",		align : "center", 	width : "100px" },
                    { columnIndex : 13, key : "TOT_UNSUIT",			title : "합계/부적합",		align : "center", 	width : "100px" },
                    { columnIndex : 14, key : "RG_UNSUIT",			title : "정기면담/부적합",	align : "center", 	width : "100px" },
					{ columnIndex : 15, key : "OC_UNSUIT",			title : "수시면담/부적합",	align : "center", 	width : "100px" }
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
            var _per_page = $("#grid").alopexGrid("pageInfo").perPage;
            
            $.alopex.request("biz.AGNTFTFT@PAGENTCNSLPRSS001_pSearchAgentCnslPrssTotal", {
                data: ["#searchTable", function() {
                	this.data.dataSet.fields.CNSL_DT   = $.PSNMUtils.getDateInput("CNSL_DT");
                	this.data.dataSet.fields.page      = _page_no;
                    this.data.dataSet.fields.page_size = _per_page;
                }],
                success: "#grid"
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
            <span class="txt6_img"><b id="sub-title">면담현황상세</b>
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
	            <col style="width:12%"/>
	            <col style="width:20%"/>
	            <col style="width:12%"/>
	            <col style="width:20%"/>
	            <col style="width:12%"/>
	            <col style="width:*"/>
            </colgroup>
            <tr>
                <th scope="col" class="fontred">시행월</th>
                <td class="tleft">
					<input id="CNSL_DT" name="CNSL_DT" data-type="dateinput" data-pickertype="monthly" data-bind="value:CNSL_DT" style="width:80px;" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png" style="width:70px"/>
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
				<td class="tleft" colspan="3">
                    <select id="SALE_TEAM_ORG_ID" data-bind="options:options_SALE_TEAM_ORG_ID, selectedOptions: SALE_TEAM_ORG_ID" data-type="select" >
                    	<option value="">-선택-</option>
                    </select>
                </td>
            </tr>
            </table>
			<div class="ab_pos4">
				<button id="btnSearch" type="button" data-type="button" data-theme="af-psnm" data-authtype="R"></button>
			</div>
        </form>
    </div>
    
    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>면담현황상세</b>
        <p class="ab_pos2">
        	<button id="btnExcelAll" type="button" data-type="button" data-theme="af-btn3" data-altname="엑셀다운"></button>
        </p>
    </div>

    <!-- main grid -->
    <div id="grid" data-bind="grid:grid"></div>

</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>