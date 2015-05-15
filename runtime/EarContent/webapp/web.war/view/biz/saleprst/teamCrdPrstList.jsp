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
            $a.page.setCodeData();
            $a.page.setValidators();
            $("#searchTable").setData(param);  //(설명) 상세페이지에서 돌아오는 경우, 이 값들이 세션스토리지에서 반환됨.
//			$a.page.searchList(param);
        },
        setEventListener : function() {
        	$("#btnSearch").click( searchList );
        	$("#btnExcelPage").click( excelPage );
        	$("#btnExcelAll").click( excelPageAll );
            $("#AGNT_NM").keyup( $.PSNMAction.findAgent );
        },
        setGrid : function() {
            $("#gridMain").alopexGrid({
                rowClickSelect : false,
                rowInlineEdit : false,
                height : "610px",
                headerGroup : [
                               { fromIndex:7,	 	toIndex:8, 	title: "여신조정금액"	},
                               { fromIndex:10,	toIndex:12, 	title: "여신사용금액(-)"}
                           ],                 
                columnMapping : [
                                 { columnIndex : 0, key : "ORG_NM1", 		title : "본사파트",			align : "left", 	width : "80px" },
                                 { columnIndex : 1, key : "ORG_NM2", 		title : "영업국명",			align : "left", 	width : "80px" },
                                 { columnIndex : 2, key : "ORG_NM3",  		title : "영업팀명",			align : "left", 	width : "80px" },
                                 { columnIndex : 3, key : "AGNT_ID",    		title : "에이전트코드",	align : "center", 	width : "80px" },
                                 { columnIndex : 4, key : "DUTY_NM", 		title : "직책명",			align : "center", 	width : "80px"	},
                                 { columnIndex : 5, key : "AGNT_NM", 		title : "에이전트명",		align : "center", 	width : "100px"	},
                                 { columnIndex : 6, key : "BAS_AMT", 		title : "담보금액",			align : "right", 	width : "100px",	render:{type:"string", rule:"comma"} },
                                 { columnIndex : 7, key : "ADJ_INC_AMT", 	title : "신용여신(+)",		align : "right", 	width : "100px",	render:{type:"string", rule:"comma"} },
                                 { columnIndex : 8, key : "ADJ_DEC_AMT", 	title : "여신조정(-)",		align : "right", 	width : "100px",	render:{type:"string", rule:"comma"} },
                                 { columnIndex : 9, key : "LMT_AMT", 		title : "여신한도금액",	align : "right", 	width : "100px",	render:{type:"string", rule:"comma"} },
                                 { columnIndex : 10, key : "STK_AMT", 		title : "재고금액",			align : "right", 	width : "100px",	render:{type:"string", rule:"comma"} },
                                 { columnIndex : 11, key : "FEE_AMT", 		title : "요금채권",			align : "right", 	width : "100px",	render:{type:"string", rule:"comma"} },
                                 { columnIndex : 12, key : "SALE_AMT", 		title : "기타채권",			align : "right", 	width : "100px",	render:{type:"string", rule:"comma"} },
                                 { columnIndex : 13, key : "BAL_AMT", 		title : "여신잔액",			align : "right", 	width : "100px",	render:{type:"string", rule:"comma"} },
                                 { columnIndex : 14, key : "EFF_END_DT", 	title : "담보만료예정일",	align : "center", 	width : "100px"	, render : function (value, data, mapping) {return $.PSNMUtils.getFormatedDate(value, "yyyy-mm-dd");}}
                             ],
                             footer : {
                     			position : "top",
                     			footerMapping : [
                     	        				{columnIndex:6, 	render:"sum(BAS_AMT)", 		align:"right" 	}, 
                     	        				{columnIndex:7, 	render:"sum(ADJ_INC_AMT)", 	align:"right" 	},
                     	        				{columnIndex:8, 	render:"sum(ADJ_DEC_AMT)", align:"right" 	},
                     	        				{columnIndex:9, 	render:"sum(LMT_AMT)", 		align:"right"	},
                     	        				{columnIndex:10, 	render:"sum(STK_AMT)", 		align:"right"	},
                     	        				{columnIndex:11, 	render:"sum(FEE_AMT)", 		align:"right"	},
                     	        				{columnIndex:12,	render:"sum(SALE_AMT)", 		align:"right"	},
                     	        				{columnIndex:13, 	render:"sum(EFF_END_DT)", 		align:"right"	}
                     		
                     				
                     			]
                     		},
                on : {
                	pageSet : function(pageNoToGo) {
                        var p = {};
                            p.page = pageNoToGo;
                            //$a.page.searchList(p);
                            searchList(p);
                    }
                }
            });
        },
        setCodeData : function() {
            //$.PSNMUtils.setCodeData([ { t:'org1',  'elemid' : 'HDQT_TEAM_ORG_ID', 'header' : '-선택-' } ]);
        },
        setValidators : function() {
        	//I006 - 조회조건 {0}(을)를 입력(선택)하세요.
        	//$('#HDQT_TEAM_ORG_ID').validator({ rule : { required: true}, message: { required: $.PSNM.msg('I006', ["본사팀"]), } });
        	//$('#HDQT_PART_ORG_ID').validator({ rule : { required: true}, message: { required: $.PSNM.msg('I006', ["본사파트"]), } });
        	//$('#SALE_DEPT_ORG_ID').validator({ rule : { required: true}, message: { required: $.PSNM.msg('I006', ["영업국명"]), } });
        }
    });
  	//end-of-$.alopex.page //-------------------------------------------------------------------------------------------------------//
  	
  	//조회 처리 : param은 페이지 이동시에만 값이 전달됨
    function searchList(param) {
//     	var errormessages = ""; var objStr = ""; var validator = null;
//     	objStr = "HDQT_TEAM_ORG_ID"; validator = $("#"+objStr).validator();
//         if ( !validator.validate() ) {
//             //alert('form is not valid');
//             errormessages = validator.getErrorMessage(); alert(errormessages); $("#"+objStr).focus(); return;
//         }
        var validator = $("#searchForm").validator();
        if ( !validator.validate() ) {
            var errormessages = validator.getErrorMessage();
            for(var name in errormessages) {
                for(var i=0; i < errormessages[name].length; i++) {
                    $.PSNM.alert(errormessages[name][i]);
                    $("#" + name).focus();
                    return;
                }
            }
        }
        
        var _page_no = 1;
        if ( $.PSNMUtils.isNotEmpty(param) && $.PSNMUtils.isNotEmpty(param.page) ) {
            _page_no = param.page;
        }
        var _per_page = $("#gridMain").alopexGrid("pageInfo").perPage;
        
        $.alopex.request("biz.SALEPRST@PSALEPRST001_pSearchCrdPrst", {
            data: ["#searchTable", function() {
                this.data.dataSet.fields.page      = _page_no;
                this.data.dataSet.fields.page_size = _per_page;
            }],
            success: ["#gridMain", function(res) {
            }]
         });
    } //end of searchList()

    function excelPage() {
        var oExcelMetaInfo = {
                filename  : "여신현황.xls",
                sheetname : "여신현황",
                gridname  : "gridMain" //그리드ID 
            };
        $.PSNMUtils.downloadExcelPage("gridMain", oExcelMetaInfo);
    }
    function excelPageAll() {
        var oExcelMetaInfo = {
                filename  : "여신현황상세.xls",
                sheetname : "여신현황상세",
                gridname  : "gridMain" //그리드ID 
            };
        var txid = "biz.SALEPRST@PSALEPRST001_pSearchCrdPrst";
        $.PSNMUtils.downloadExcelAll("searchForm", txid, "gridMain", oExcelMetaInfo);
    }
    
    </script>

</head>

<body>


<jsp:include page="/view/layouts/default_header.jsp" flush="false" />

<!-- contents area -->
<div id="contents">

    <!-- sub title area -->
    <div class="content_title">
        <div class="ub_txt6">
            <span class="txt6_img"><b id="sub-title">여신현황</b>
                <span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif">
                <span class="a2">영업팀업무</span> <span class="a3"> > </span> <span class="a4"><b>판매관리</b></span> 
            </span>
        </div>
    </div>
    
    <!-- find condition area -->
    <div id="searchDiv" class="textAR">
		<form id="searchForm" onsubmit="return false;">
        	<table id="searchTable" class="board02" style="width:92%;">
        	<colgroup>
	            <col style="width:12%"/>
	            <col style="width:21%"/>
	            <col style="width:12%"/>
	            <col style="width:21%"/>
	            <col style="width:12%"/>
	            <col style="width:*"/>
            </colgroup>
            <tr>
				<th class="fontred">본사팀</th>
				<td class="tleft">
                    <select id="HDQT_TEAM_ORG_ID" name="HDQT_TEAM_ORG_ID" data-bind="options:options_HDQT_TEAM_ORG_ID, selectedOptions: HDQT_TEAM_ORG_ID" data-type="select" data-wrap="false"
                    		data-validation-rule="{required:true}"
							data-validation-message="{required:$.PSNM.msg('E012', ['본사팀'])}">
                    	<option value="">-선택-</option>
                    </select>
                </td>
                <th class="fontred">본사파트</th>
				<td class="tleft">
                    <select id="HDQT_PART_ORG_ID" name="HDQT_PART_ORG_ID" data-bind="options:options_HDQT_PART_ORG_ID, selectedOptions: HDQT_PART_ORG_ID" data-type="select" data-wrap="false"
                    		data-validation-rule="{required:true}"
							data-validation-message="{required:$.PSNM.msg('E012', ['본사파트'])}">
                    	<option value="">-선택-</option>
                    </select>
                </td>
                <th class="fontred">영업국명</th>
				<td class="tleft">
                    <select id="SALE_DEPT_ORG_ID" name="SALE_DEPT_ORG_ID" data-bind="options:options_SALE_DEPT_ORG_ID, selectedOptions: SALE_DEPT_ORG_ID" data-type="select" data-wrap="false"
                    		data-validation-rule="{required:true}"
							data-validation-message="{required:$.PSNM.msg('E012', ['영업국명'])}">
                    	<option value="">-선택-</option>
                    </select>
                </td>
            </tr>
            <tr>
				<th class="fontred">영업팀명</th>
				<td class="tleft">
                    <select id="SALE_TEAM_ORG_ID" name="SALE_TEAM_ORG_ID" data-bind="options:options_SALE_TEAM_ORG_ID, selectedOptions: SALE_TEAM_ORG_ID" data-type="select" data-wrap="false"
                    		data-validation-rule="{required:true}"
							data-validation-message="{required:$.PSNM.msg('E012', ['영업팀명'])}">
                    	<option value="">-선택-</option>
                    </select>
                </td>
                <th>에이전트명</th>
				<td class="tleft" colspan="3">
                    <input id="AGNT_NM" name="AGNT_NM" data-bind="value:AGNT_NM" data-type="textinput" data-agentid="AGNT_ID" style="width:70px;" maxlength="10" />
                    <input id="AGNT_ID" name="AGNT_ID" data-bind="value:AGNT_ID" data-type="textinput" data-disabled="true" style="width:70px;" />
                </td>
            </tr>
            </table>
			<div class="ab_pos4">
				<button id="btnSearch" type="button" data-type="button" data-theme="af-psnm"></button>
			</div>
        </form>
    </div>

    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>여신현황</b>
        <p class="ab_pos2">
        	<button id="btnExcelAll" type="button" data-type="button" data-theme="af-n-btn27" data-altname="상세다운"></button>
        	<button id="btnExcelPage" type="button" data-type="button" data-theme="af-btn3" data-altname="엑셀다운"></button>
        </p>
    </div>

    <!-- main grid -->
    <div id="gridMain" data-bind="grid:gridMain"></div>

</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>