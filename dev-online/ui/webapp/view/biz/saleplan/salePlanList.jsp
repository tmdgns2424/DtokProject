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
            $a.page.setCodeData();
            $("#searchTable").setData(param);  //(설명) 상세페이지에서 돌아오는 경우, 이 값들이 세션스토리지에서 반환됨.
			$a.page.searchList(param);
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
                        filename  : "월별영업계획.xls",
                        sheetname : "월별영업계획",
                        gridname  : "grid" //그리드ID 
                    };
        		var txid = "biz.SALEPLAN@PMTHSALESPLAN001_pSearchHeadSalePlan";

        		$.PSNMUtils.downloadExcelAll("searchForm", txid, "grid", oExcelMetaInfo);
            });
        },
        setGrid : function() {
            $("#grid").alopexGrid({
                rowClickSelect : false,
                rowInlineEdit : true,
                columnMapping : [
                    { columnIndex : 0, key : "SALES_YM",            title : "대상월",	align : "center", 	width : "80px" 	},
                    { columnIndex : 1, key : "ORG_LVL_NM",  		title : "유형",		align : "center", 	width : "80px"  },
                    { columnIndex : 2, key : "HDQT_PART_ORG_NM",    title : "본사파트",	align : "center", 	width : "100px" },
                    { columnIndex : 3, key : "SALE_DEPT_ORG_NM",    title : "영업국명",	align : "center", 	width : "100px" },
                    { columnIndex : 4, key : "SALE_TEAM_ORG_NM", 	title : "영업팀명",	align : "center", 	width : "100px"	},
                    { columnIndex : 5, key : "RGSTR_NM",      		title : "관리자명",	align : "center", 	width : "80px" 	},
                    { columnIndex : 6, key : "RGST_DTM", 			title : "작성일시",	align : "center", 	width : "100px"	}
                ],
                on : {
                    pageSet : function(pageNoToGo) {
                    	var p = {};
	                        p.page = pageNoToGo;
	                        $a.page.searchList(p);
                    },
                    "cell" : {
    					"dblclick" : function(data, eh, e) {
    						if(data._index.column != 0) {
    							var param = $("#searchTable").getData({selectOptions:true});
    			        			param["data"]      = data;
    								param["page"]      = $("#grid").alopexGrid("pageInfo").customPaging.current; //
    				            	param["page_size"] = $("#grid").alopexGrid("pageInfo").perPage;
    							
    							if("1" == data["ORG_LVL"]){
    								$a.navigate("salePlanHeadDtl.jsp", param);
    							} else {
    								$a.navigate("salePlanTeamDtl.jsp", param);
    							}
    						}
    					}
    				}
                }
            });
        },
        setCodeData : function() {
            $.PSNMUtils.setCodeData([
                { t:'code',  'elemid' : 'ORG_LVL', 'codeid' : 'DSM_ORG_LVL', 'header' : '-전체-' }
            ]);
        },
        searchList: function(param) {
        	var _page_no = 1;
            if ( $.PSNMUtils.isNotEmpty(param) && $.PSNMUtils.isNotEmpty(param.page) ) {
                _page_no = param.page;
            }
            var _per_page = $("#grid").alopexGrid("pageInfo").perPage;
            
            $.alopex.request("biz.SALEPLAN@PMTHSALESPLAN001_pSearchHeadSalePlan", {
                data: ["#searchForm", function() {
                	this.data.dataSet.fields.FROM_YM   = $.PSNMUtils.getDateInput("FROM_YM");
           		 	this.data.dataSet.fields.TO_YM   	= $.PSNMUtils.getDateInput("TO_YM");
                    this.data.dataSet.fields.page      = _page_no;
                    this.data.dataSet.fields.page_size = _per_page;
                }],
                success: ["#grid", "#totcount"]
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
            <span class="txt6_img"><b id="sub-title">영업계획관리</b>
                <span class="notice-more"> 
                	<img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif">
                	<span class="a2">본사업무</span> <span class="a3"> > </span> <span class="a4"><b>판매관리</b></span> 
                </span>
            </span>
        </div>
    </div>

    <!-- find condition area -->
    <div id="searchDiv" class="textAR">
		<form id="searchForm" onsubmit="return false;">
			<input type="hidden" id="HEADQ_YN" name="HEADQ_YN" data-bind="value:HEADQ_YN" value="Y" />
			
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
                	<div data-type="daterange" data-pickertype="monthly" data-format="yyyy-MM" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png" >
                		<input id="FROM_YM" name="FROM_YM" data-role="startdate" data-bind="value:FROM_YM" style="width:70px;"/>
						~ <input id="TO_YM" name="TO_YM" data-role="enddate" data-bind="value:TO_YM" style="width:70px;"/>
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
                    <select id="HDQT_PART_ORG_ID" data-bind="options:options_HDQT_PART_ORG_ID, selectedOptions: HDQT_PART_ORG_ID" data-type="select">
                    	<option value="">-선택-</option>
                    </select>
                </td>
            </tr>
            <tr>
                <th>영업국명</th>
				<td class="tleft">
                    <select id="SALE_DEPT_ORG_ID" data-bind="options:options_SALE_DEPT_ORG_ID, selectedOptions: SALE_DEPT_ORG_ID" data-type="select">
                    	<option value="">-선택-</option>
                    </select>
                </td>
				<th>유형</th> 
				<td class="tleft">
                    <select id="ORG_LVL" data-bind="options:options_ORG_LVL, selectedOptions: ORG_LVL" data-type="select"></select>
                </td>
                <th>관리자명</th>
				<td class="tleft">
                    <input id="RGSTR_NM" name="RGSTR_NM" data-bind="value:RGSTR_NM" data-type="textinput" style="width:70px;" />
                </td>
            </tr>
            </table>
			<div class="ab_pos4">
				<button id="btnSearch" type="button" data-type="button" data-theme="af-psnm" data-authtype="R"></button>
			</div>
        </form>
    </div>

    <div id="totcount" class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>영업계획관리</b>
    	(영업국 <label data-bind="text:CNT1">0</label>건, 영업팀 <label data-bind="text:CNT2">0</label>건)
        <p class="ab_pos2">
        	<button id="btnExcelAll" type="button" data-type="button" data-theme="af-btn3" data-altname="엑셀다운" data-authtype="W"></button>
        </p>
    </div>

    <!-- main grid -->
    <div id="grid" data-bind="grid:grid"></div>

</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>