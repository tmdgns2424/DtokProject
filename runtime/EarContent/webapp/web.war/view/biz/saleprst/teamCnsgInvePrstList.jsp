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
                columnMapping : [
                    { columnIndex : 0, key : "HDQT_PART_ORG_NM",  	 title : "본사파트",			align : "center", 	width : "80px" },
                    { columnIndex : 1, key : "SALE_DEPT_ORG_NM", 	 title : "영업국명",			align : "center", 	width : "80px" },
                    { columnIndex : 2, key : "SALE_TEAM_ORG_NM",     title : "영업팀명",			align : "center", 	width : "80px" },
                    { columnIndex : 3, key : "AGNT_ID", 			 title : "에이전트코드",			align : "center", 	width : "80px"	},
                    { columnIndex : 4, key : "RETL_CLASS_NM", 		 title : "직책명",				align : "center", 	width : "80px"	},
                    { columnIndex : 5, key : "AGNT_NM", 			 title : "에이전트명",			align : "center", 	width : "80px" },
                    { columnIndex : 6, key : "IN_DT", 			     title : "현위탁처출고일자",		align : "center", 	width : "100px"	},
                    { columnIndex : 7, key : "STTL_OWNR_NM", 		 title : "제조사",				align : "right", 	width : "120px"	},
                    { columnIndex : 8, key : "PROD_NM", 			 title : "상품명",				align : "right", 	width : "100px"	},
                    { columnIndex : 9, key : "CRD_AMT", 			 title : "여신가",				align : "right", 	width : "80px"	},
                    { columnIndex : 10, key : "COLOR_NM", 			 title : "색상명",				align : "right", 	width : "80px"	},
                    { columnIndex : 11, key : "PROD_SER_NUM", 		 title : "일련번호",			align : "right", 	width : "80px"	},
                    { columnIndex : 12, key : "ST_NM", 				 title : "상태",				align : "center", 	width : "55px"	},
                    { columnIndex : 13, key : "DSM_UNIT_NM", 		 title : "운영방향",			align : "center", 	width : "80px"	},
                    { columnIndex : 14, key : "IN_DCHA", 			 title : "현위탁처보유기간",		align : "center", 	width : "100px"	}
                ],
                on : {
                	perPageChange : function(arg1) {
                    },
                	pageSet : function(pageNoToGo) {
                        var p = {};
                            p.page = pageNoToGo;
                            searchList(p);
                    }
                }
            });
        },
        setCodeData : function() {
           //$.PSNMUtils.setCodeData([ { t:'org1',  'elemid' : 'HDQT_TEAM_ORG_ID', 'header' : '-전체-' } ]);
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
        $.alopex.request("biz.SALEPRST@PSALEPRST001_pSearchCnsgInvePrst", {
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
                filename  : "위탁재고현황.xls",
                sheetname : "위탁재고현황",
                gridname  : "gridMain" //그리드ID 
            };
        $.PSNMUtils.downloadExcelPage("gridMain", oExcelMetaInfo);
    }
    function excelPageAll() {
        var oExcelMetaInfo = {
                filename  : "위탁재고현황상세.xls",
                sheetname : "위탁재고현황상세",
                gridname  : "gridMain" //그리드ID 
            };
        var txid = "biz.SALEPRST@PSALEPRST001_pSearchCnsgInvePrst";
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
            <span class="txt6_img"><b id="sub-title">위탁재고 현황</b>
                <span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif">
                <span class="a2">영업팀업무</span> <span class="a3"> > </span> <span class="a4"><b>영업현황</b></span> 
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
				<td class="tleft">
                    <input id="AGNT_NM" name="AGNT_NM" data-bind="value:AGNT_NM" data-type="textinput" data-agentid="AGNT_ID" style="width:70px;" maxlength="10" />
                    <input id="AGNT_ID" name="AGNT_ID" data-bind="value:AGNT_ID" data-type="textinput" data-disabled="true" style="width:70px;" />
                </td>
                <th>상품명</th>
				<td class="tleft">
                    <input id="PROD_NM" name="PROD_NM" data-bind="value:PROD_NM" data-type="textinput" data-agentid="PROD_NM" style="width:70px;" maxlength="10" />                    
                </td>
            </tr>
            </table>
			<div class="ab_pos4">
				<button id="btnSearch" type="button" data-type="button" data-theme="af-psnm"></button>
			</div>
        </form>
    </div>

    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>위탁재고 현황</b>
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