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
            
            _param = param;
            
            $("#SALES_YM").val(getCurrdate().substr(0,7));
            $a.page.setEventListener();
            $a.page.setGrid();
            $a.page.setGridTotal();
        },
        setEventListener : function() {
        	$("#btnSearch").click(function(){
        		if ( ! $.PSNM.isValid("#searchForm") ) {
    			    return false; //값 검증
    			}
        		$a.page.searchList();
        	});
            $("#btnSave").click(function(){
            	
            	$("#grid").alopexGrid("endEdit");
            	
            	var grid = $('#grid').alopexGrid('dataGet', {_state:{edited:true}});
            	if(grid.length == 0){
            		$.PSNM.alert("E011", ["변경된"]);
					return;
            	}
            	
            	if( $.PSNM.confirm("I004", ["저장"] ) ){
            		var requestData = $.PSNMUtils.getRequestData("grid");
            		requestData.dataSet.fields.SALES_YM = $.PSNMUtils.getDateInput("SALES_YM");
            		
                	$.alopex.request("biz.SALETRGT@PMTHSALESEXECTRGT001_pSaveSalesExecTrgt", {
                        data: requestData,
                        success: function(res) { 
                        	$a.page.searchList(_param);
                        }
                    });
            	}
            });
            $("#btnExcelAll").click(function(){
            	var oExcelMetaInfo = {
                        filename  : "영업목표관리.xls",
                        sheetname : "영업목표관리",
                        gridname  : "grid" //그리드ID 
                    };
        		var txid = "biz.SALETRGT@PMTHSALESEXECTRGT001_pSearchSalesExecTrgt";

        		$.PSNMUtils.downloadExcelAll("searchForm", txid, "grid", oExcelMetaInfo, [2,4]);
            });
            $("#btnExcelPage").click(function(){
            	var oExcelMetaInfo = {
                        filename  : "영업목표관리합계.xls",
                        sheetname : "영업목표관리합계",
                        gridname  : "gridtotal" //그리드ID 
                    };
            	
            	$.PSNMUtils.downloadExcelPage("gridtotal", oExcelMetaInfo, [0]);
            });
        },
        setGrid : function() {
            $("#grid").alopexGrid({
                pager: false,
                rowClickSelect : false,
                rowInlineEdit : true,
                height : "400px",
                columnMapping : [
                    { columnIndex : 0, key : "HDQT_TEAM_ORG_NM",	title : "본사팀",		align : "center", 	width : "100px", 	rowspan :{by:3}	},
                    { columnIndex : 1, key : "HDQT_PART_ORG_NM",	title : "본사파트",		align : "center", 	width : "100px", 	rowspan :{by:3}	},
                    { columnIndex : 2, key : "SALE_DEPT_ORG_ID",	title : "영업국ID",		hidden:true	},
                    { columnIndex : 3, key : "SALE_DEPT_ORG_NM",	title : "영업국명",		align : "center", 	width : "100px",	rowspan :true	},
                    { columnIndex : 4, key : "UNIT_TYP_CD",			title : "상품구분코드",	hidden:true	},
                    { columnIndex : 5, key : "UNIT_TYP_NM",			title : "상품구분",		align : "center", 	width : "100px"	},
                    { columnIndex : 6, key : "MGMT_RT",				title : "관리비율(%)",	align : "center", 	width : "80px"
                    	, editable : {
                    		type : "text"
                    		, rule : "comma"
                    	}
	                    , render : {
	                		type : "string"
	                		, rule : "comma"
	                	}
                    },
                    { columnIndex : 7, key : "EXEC_TRGT_QTY",		title : "실행목표",		align : "center", 	width : "80px"
                    	, editable : {
                    		type : "text"
                    		, rule : "comma"
                    	}
                    	, render : {
                    		type : "string"
                    		, rule : "comma"
                    	}
                    }
            	]
            });
        },
        setGridTotal : function() {
            $("#gridtotal").alopexGrid({
                pager: false,
                rowClickSelect : false,
                columnMapping : [
                    { columnIndex : 0, key : "TOTAL",				title : "",				align : "center", 	width : "100px", rowspan : true } ,
                    { columnIndex : 1, key : "UNIT_TYP_NM",			title : "상품구분",		align : "center", 	width : "100px"},
                    { columnIndex : 2, key : "SUM_EXEC_TRGT_QTY",	title : "실행목표",		align : "center", 	width : "100px"
                    	, render : {
                    		type : "string"
                    		, rule : "comma"
                    	}
                    }
            	]
            });
        },
        searchList: function(param) {
            $.alopex.request("biz.SALETRGT@PMTHSALESEXECTRGT001_pSearchSalesExecTrgt", {
            	 data: ["#searchTable", function() {
            		 this.data.dataSet.fields.SALES_YM   = $.PSNMUtils.getDateInput("SALES_YM");
                 }],
                success: ["#grid", "#gridtotal"]
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
            <span class="txt6_img"><b id="sub-title">영업목표관리</b>
                <span class="notice-more"> 
                	<img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif">
                	<span class="a2">본사업무</span> <span class="a3"> > </span> <span class="a4"><b>커뮤니티관리</b></span> 
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
	            <col style="width:22%"/>
	            <col style="width:10%"/>
	            <col style="width:22%"/>
	            <col style="width:10%"/>
	            <col style="width:*"/>
	        </colgroup>
	       	<tbody>
	       		<tr>
	                <th scope="col" class="fontred">대상월</th>
	                <td class="tleft">
	                	<input id="SALES_YM" name="SALES_YM" data-type="dateinput" data-pickertype="monthly" data-bind="value:SALES_YM" style="width:80px;" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png"/>
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
	                    <select id="HDQT_PART_ORG_ID" data-bind="options:options_HDQT_PART_ORG_ID, selectedOptions: HDQT_PART_ORG_ID" data-type="select" onchange-enable="false"
	                    	data-validation-rule="{required:true}"
							data-validation-message="{required:$.PSNM.msg('E012', ['본사파트'])}">
	                    	<option value="">-전체-</option>
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
    
    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>영업목표관리</b>
        <div class="ab_pos2">
        	<button id="btnSave" type="button" data-type="button" data-theme="af-btn4" data-altname="저장" data-authtype="W"></button>
        	<button id="btnExcelAll" type="button" data-type="button" data-theme="af-btn3" data-altname="엑셀다운" data-authtype="W"></button>
        </div>
    </div>

    <!-- main grid -->
    <div id="grid" data-bind="grid:grid"></div>
    
    <div class="floatL4">
        <div class="ab_pos5">
        	<button id="btnExcelPage" type="button" data-type="button" data-theme="af-btn3" data-altname="엑셀다운" data-authtype="W"></button>
        </div>
    </div>
    <div id="gridtotal" data-bind="grid:gridtotal"></div>

</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>