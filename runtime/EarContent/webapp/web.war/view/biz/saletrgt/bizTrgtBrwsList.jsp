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
            
            $("#FROM_YM").val(getCurrdate().substr(0,7));
            $("#TO_YM").val(getCurrdate().substr(0,7));
            $a.page.setEventListener();
            $a.page.setGrid();
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
                        filename  : "영업목표조회.xls",
                        sheetname : "영업목표조회",
                        gridname  : "grid" //그리드ID 
                    };
        		var txid = "biz.SALETRGT@PMTHSALESEXECTRGT001_pSearchSalesExecTrgtBrws";

        		$.PSNMUtils.downloadExcelAll("searchForm", txid, "grid", oExcelMetaInfo);
            });
        },
        setGrid : function() {
            $("#grid").alopexGrid({
                pager: false,
                rowClickSelect : false,
                height : "600px",
                columnMapping : [
                    { columnIndex : 0, key : "SALES_YM",			title : "대상월",		align : "center", 	width : "80px",  rowspan : true	},
                    { columnIndex : 1, key : "HDQT_TEAM_ORG_NM",	title : "본사팀",		align : "center", 	width : "100px", rowspan : true	},
                    { columnIndex : 2, key : "HDQT_PART_ORG_NM",	title : "본사파트",		align : "center", 	width : "100px", rowspan : true	},
                    { columnIndex : 3, key : "SALE_DEPT_ORG_NM",	title : "영업국명",		align : "center", 	width : "100px", rowspan : true	},
                    { columnIndex : 4, key : "UNIT_TYP_NM",			title : "상품구분",		align : "center", 	width : "100px"	},
                    { columnIndex : 5, key : "MGMT_RT",				title : "관리비율(%)",	align : "center", 	width : "80px"
	                    , render : {
	                		type : "string"
	                		, rule : "comma"
	                	}
                    },
                    { columnIndex : 6, key : "EXEC_TRGT_QTY",		title : "실행목표(수량)",		align : "center", 	width : "80px"
                    	, render : {
                    		type : "string"
                    		, rule : "comma"
                    	}
                    }
            	]
            });
        },
        searchList: function(param) {
            $.alopex.request("biz.SALETRGT@PMTHSALESEXECTRGT001_pSearchSalesExecTrgtBrws", {
            	 data: ["#searchTable", function() {
            		 this.data.dataSet.fields.FROM_YM   = $.PSNMUtils.getDateInput("FROM_YM");
            		 this.data.dataSet.fields.TO_YM   	= $.PSNMUtils.getDateInput("TO_YM");
                 }],
                success: "#grid"
            });
        }
    });

    </script>

</head>

<body>

<jsp:include page="/view/layouts/default_header.jsp" flush="false" />

<div id="contents">

    <!-- sub title area -->
    <div class="content_title">
        <div id="ub_txt6">
            <span class="txt6_img"><b id="sub-title">영업목표조회</b>
                <span class="notice-more"> 
                	<img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif">
                	<span class="a2">커뮤니티</span> <span class="a3"> > </span> <span class="a4"><b>Main화면알림</b></span> 
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
	            <col style="width:*"/>
	        </colgroup>
	       	<tbody>
	       		<tr>
	                <th scope="col" class="fontred">조회기간</th>
	                <td class="tleft">
	                	<div data-type="daterange" data-pickertype="monthly" data-format="yyyy-MM" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png" >
	                		<input id="FROM_YM" name="FROM_YM" data-role="startdate" data-bind="value:FROM_YM" style="width:70px;"/>
							~ <input id="TO_YM" name="TO_YM" data-role="enddate" data-bind="value:TO_YM" style="width:70px;"/>
	                	</div>
					</td>
	            	<th scope="col" class="fontred">본사팀</th>
					<td class="tleft">
	                    <select id="HDQT_TEAM_ORG_ID" data-bind="options:options_HDQT_TEAM_ORG_ID, selectedOptions: HDQT_TEAM_ORG_ID" data-type="select"
	                    	data-validation-rule="{required:true}"
							data-validation-message="{required:$.PSNM.msg('E012', ['본사팀'])}">
	                    	<option value="">-전체-</option>
	                    </select>
	                </td>
	                <th scope="col" class="fontred">본사파트</th>
					<td class="tleft">
	                    <select id="HDQT_PART_ORG_ID" data-bind="options:options_HDQT_PART_ORG_ID, selectedOptions: HDQT_PART_ORG_ID" data-type="select" 
	                    	data-validation-rule="{required:true}"
							data-validation-message="{required:$.PSNM.msg('E012', ['본사파트'])}">
	                    	<option value="">-전체-</option>
	                    </select>
	                </td>
	            </tr>
	            <tr>
	                <th>영업국명</th>
					<td class="tleft"  colspan="5">
	                    <select id="SALE_DEPT_ORG_ID" data-bind="options:options_SALE_DEPT_ORG_ID, selectedOptions: SALE_DEPT_ORG_ID" data-type="select" >
	                    	<option value="">-선택-</option>
	                    </select>
	                </td>
	            </tr>
	       	</tbody>
	        </table>
			<div class="ab_pos5">
				<button id="btnSearch" type="button" data-type="button" data-theme="af-psnm" data-authtype="R"></button>
			</div>
	    </form>
    </div>
    
    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>영업목표조회</b>
        <div class="ab_pos2">
        	<button id="btnExcelAll" type="button" data-type="button" data-theme="af-btn3" data-altname="엑셀다운" data-authtype="W"></button>
        </div>
    </div>

    <!-- main grid -->
    <div id="grid" data-bind="grid:grid"></div>

</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>