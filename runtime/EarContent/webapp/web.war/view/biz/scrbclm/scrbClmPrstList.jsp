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
            $a.page.setCodeData();
        },
        setEventListener : function() {
        	$("#btnSearch").click($a.page.searchList);
        	$("#btnExcelAll").click(function(){
            	var oExcelMetaInfo = {
                        filename  : "비정상영업소명현황.xls",
                        sheetname : "비정상영업소명현황",
                        gridname  : "gridScrbClmPrst" 
                    };

        		$.PSNMUtils.downloadExcelAll("searchForm", "biz.SCRBCLM@PSCRBCLM001_pSearchScrbClmPrst", "gridScrbClmPrst", oExcelMetaInfo);
            });
        	$("#btnExcelPage").click(function(){
            	var oExcelMetaInfo = {
                        filename  : "비정상영업소명현황.xls",
                        sheetname : "비정상영업소명현황",
                        gridname  : "gridScrbClmPrst" //그리드ID 
                    };
                $.PSNMUtils.downloadExcelPage("gridScrbClmPrst", oExcelMetaInfo);
        	});
        },
        setGrid : function() {
            $("#gridScrbClmPrst").alopexGrid({
                rowClickSelect : false,
                rowInlineEdit  : true,
                columnMapping  : [
                    { columnIndex : 0, key  : "YYYYMM",                    title : "발생월",		    align : "center", 	width : "100px", rowspan : true },
                    { columnIndex : 1, key  : "HDQT_PART_ORG_NM",  		   title : "본사파트",		align : "center", 	width : "95px",  rowspan : true },
                    { columnIndex : 2, key  : "SALE_DEPT_ORG_NM",          title : "영업국명",		align : "center", 	width : "100px", rowspan : true },
                    { columnIndex : 3, key  : "SALE_TEAM_ORG_NM",          title : "영업팀명",		align : "center", 	width : "100px", rowspan : true },
                    { columnIndex : 4, key  : "AGNT_ID", 	               title : "에이전트코드",	align : "center", 	width : "100px",  rowspan : true	},
                    { columnIndex : 5, key  : "RPSTY_NM",                  title : "직책명",	        align : "center", 	width : "100px", rowspan : true },
                    { columnIndex : 6, key  : "AGNT_NM", 			       title : "에이전트명",		align : "center", 	width : "80px",  rowspan : true	},
                    { columnIndex : 7, key  : "PGVC_TYP_NM", 	           title : "민원유형",		align : "center", 	width : "100px", rowspan : true	},
                    { columnIndex : 8, key  : "SUM_TOTAL", 	               title : "합계",		    align : "center", 	width : "100px"	},
                    { columnIndex : 9, key  : "SUM_N", 	                   title : "처리중",		    align : "center", 	width : "60px"	},
                    { columnIndex : 10, key : "SUM_Y", 		               title : "처리완료",	    align : "center", 	width : "60px"	},
                    { columnIndex : 11, key : "SUM_R", 		               title : "재처리중",		align : "center", 	width : "60px"	},                   
                ],
                on : {
                    pageSet : function(pageNoToGo) {
                    	var p = {};
	                        p.page = pageNoToGo;
	                        $a.page.searchList(p);
                    },
                }
            });
        },
        
        setCodeData : function() {
            $.PSNMUtils.setCodeData([
				{ t:'org1',  'elemid' : 'HDQT_TEAM_ORG_ID', 'codeid':'',  'header' : '-전체-' }                                     
               ,{ t:'code',  'elemid' : 'CLM_TYP_CD'     , 'codeid' : 'DSM_SCRB_CLM_TYP_CD', 'header' : '-전체-' }
               ,{ t:'code',  'elemid' : 'SCRB_CLM_ST_CD' , 'codeid' : 'DSM_CUST_PGCV_ST_CD', 'header' : '-전체-' }  
            ]);
        },
        
        searchList: function(param) {
        	if ( ! $.PSNM.isValid("#searchForm") ) {
        		return false; //값 검증
        	}        	
        	var _page_no = 1;
            if ( $.PSNMUtils.isNotEmpty(param) && $.PSNMUtils.isNotEmpty(param.page) ) {
                _page_no = param.page;
            }
            var _per_page = $("#gridScrbClmPrst").alopexGrid("pageInfo").perPage;
            
            $.alopex.request("biz.SCRBCLM@PSCRBCLM001_pSearchScrbClmPrst", {
                data: ["#searchTable", function() {
                	this.data.dataSet.fields.FROM_DT   = $.PSNMUtils.getDateInput("FROM_DT");
                	this.data.dataSet.fields.TO_DT     = $.PSNMUtils.getDateInput("TO_DT");
                    this.data.dataSet.fields.page      = _page_no;
                    this.data.dataSet.fields.page_size = _per_page;
                }],
                success: ["#gridScrbClmPrst", "#TOT_CNT", function(res) {
                	$("#TOT_CNT").setData( {"TOT_CNT" : $.PSNMUtils.numberformat(res.dataSet.fields.TOT_CNT)} );
                	$("#PRC_CNT").setData( {"PRC_CNT" : $.PSNMUtils.numberformat(res.dataSet.fields.PRC_CNT)} );
                	$("#REPRC_CNT").setData( {"REPRC_CNT" : $.PSNMUtils.numberformat(res.dataSet.fields.REPRC_CNT)} );
                	$("#END_CNT").setData( {"END_CNT" : $.PSNMUtils.numberformat(res.dataSet.fields.END_CNT)} );
                }]
            });
        },
    });

    </script>

</head>

<body>

<jsp:include page="/view/layouts/default_header.jsp" flush="false" />

<!-- contents area -->
<div id="contents">

	<!-- sub title area -->
    <div id="ub_txt6">
        <span class="txt6_img"><b id="sub-title">비정상영업소명 현황</b>
            <span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif">
            <span class="a2">본사업무</span> <span class="a3"> > </span> <span class="a4"><b>비정상영업소명 현황</b></span> 
        </span>
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
            <tr>
                <th scope="col" class="fontred">조회기간</th>
                <td class="tleft">
					<div data-type="daterange" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png" >
						<input id="FROM_DT" name="FROM_DT" data-role="startdate" data-bind="value:FROM_DT" style="width:70px;"
							data-validation-rule="{required:true}"
							data-validation-message="{required:$.PSNM.msg('E012', ['시작일자'])}">
						~ <input id="TO_DT" name="TO_DT" data-role="enddate" data-bind="value:TO_DT" style="width:70px;"
							data-validation-rule="{required:true}"
							data-validation-message="{required:$.PSNM.msg('E012', ['종료일자'])}">
					</div>
				</td>
				<th>본사팀</th>
				<td class="tleft">
                    <select id="HDQT_TEAM_ORG_ID" data-bind="options:options_HDQT_TEAM_ORG_ID, selectedOptions: HDQT_TEAM_ORG_ID" data-type="select">
                    	<option value="">-선택-</option>
                    </select>
                </td>
                <th>본사파트</th>
				<td class="tleft">
                    <select id="HDQT_PART_ORG_ID" data-bind="options:options_HDQT_PART_ORG_ID, selectedOptions: HDQT_PART_ORG_ID" data-type="select">
                    	<option value="">-선택-</option>
                    </select>
                </td>
            </tr>
            <tr>
                <th>영업국명</th>
				<td class="tleft">
                    <select id="SALE_DEPT_ORG_ID" data-bind="options:options_SALE_DEPT_ORG_ID, selectedOptions: SALE_DEPT_ORG_ID" data-type="select" style="width:150px">
                    	<option value="">-선택-</option>
                    </select>
                </td>
				<th>영업팀명</th>
				<td class="tleft">
                    <select id="SALE_TEAM_ORG_ID" data-bind="options:options_SALE_TEAM_ORG_ID, selectedOptions: SALE_TEAM_ORG_ID" data-type="select" style="width:150px">
                    	<option value="">-선택-</option>
                    </select>
                </td>
                <th>민원유형</th>
				<td class="tleft">
                    <select id="CLM_TYP_CD" data-bind="options:options_CLM_TYP_CD, selectedOptions: CLM_TYP_CD" data-type="select" style="width:150px">
                        <option value="">-선택-</option>
                    </select>
                </td>
            </tr>
            <tr>
                <th>상태</th>
				<td class="tleft">
                    <select id="SCRB_CLM_ST_CD" data-bind="options: options_SCRB_CLM_ST_CD, selectedOptions: SCRB_CLM_ST_CD" data-type="select" style="width:150px"></select>
                </td>
                <th>에이전트코드</th>
				<td class="tleft">
                    <input id="AGNT_ID" data-bind="value:AGNT_ID" data-type="textinput" style="width:150px"/>
                </td>
                <th>에이전트명</th>
				<td class="tleft">
                    <input id="AGNT_NM" data-bind="value:AGNT_NM" data-type="textinput" style="width:150px"/>
                </td> 
            </tr>
            <tr>
                <th>고객명</th>
				<td class="tleft" colspan="5">
                    <input id="CUST_NM" data-bind="value:CUST_NM" data-type="textinput" style="width:150px"/>
                </td>
            </tr>            
            </table>
			<div class="ab_pos4">
				<button id="btnSearch" type="button" data-type="button" data-theme="af-psnm" data-authtype="R"></button>
			</div>
        </form>
    </div>

    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>비정상영업소명 현황</b>
    (총&nbsp;<label id="TOT_CNT" data-bind="text:TOT_CNT">0</label>&nbsp;건&nbsp;:&nbsp;<b>처리중&nbsp;<label id="PRC_CNT" data-bind="text:PRC_CNT">0</label>&nbsp;건</b>,&nbsp;재처리중&nbsp;<label id="REPRC_CNT" data-bind="text:REPRC_CNT">0</label>&nbsp;건,&nbsp;처리완료&nbsp;<label id="END_CNT" data-bind="text:END_CNT">0</label>&nbsp;건)
        <p class="ab_pos2">
        	<button id="btnExcelAll" type="button" data-type="button" data-theme="af-n-btn27" data-altname="상세엑셀다운" data-authtype="R"></button>
        	<button id="btnExcelPage" type="button" data-type="button" data-theme="af-btn3" data-altname="엑셀다운" data-authtype="R"></button>
        </p>
    </div>

    <!-- main grid -->
    <div id="gridScrbClmPrst" data-bind="grid:gridScrbClmPrst"></div>

</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>