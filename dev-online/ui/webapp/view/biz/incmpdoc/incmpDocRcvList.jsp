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
            $("#searchTable").setData(param);  //(설명) 상세페이지에서 돌아오는 경우, 이 값들이 세션스토리지에서 반환됨.
			$a.page.searchList(param);
        },
        setEventListener : function() {
            $("#btnSearch").click($a.page.searchList);
            $("#btnExcelPage").click( excelPage );
            $("#btnExcelAll").click( excelAll );
            $("#btnNew").click(function(){
            	var param = $('#searchTable').getData();
                param["page_size"] = $('#grid').alopexGrid('pageInfo').perPage;
    	        try { 
    	            param["page"]  = $("#grid").alopexGrid("pageInfo").customPaging.current; 
    	        } catch(E) {
    	            param["page"]  = 1; //디폴트 1페이지
    	        }
            	$a.navigate("incmpDocRcvRgst.jsp", param);
            });
        },
        setGrid : function() {
            $("#grid").alopexGrid({
                rowClickSelect : false,
                rowInlineEdit : true,
                columnMapping : [
                                 
                    { columnIndex : 0,	key : "RCV_TYP_CD_NM",	title : "접수유형",		align : "center",	width : "100px",
                    	render : function(value, data) {
	                    	var nwImg = data["F"] == "NEW" ? '<img src="${pageContext.request.contextPath}/image/blat_a11.gif">&nbsp;' : '';
	                		return nwImg + value ;
						}
                    },
                    { columnIndex : 1,	key : "CUST_NM",		title : "고객명",		align : "center",	width : "100px" },
                    { columnIndex : 2,	key : "OPEN_DT",		title : "개통일자",		align : "center",	width : "100px" },
                    { columnIndex : 3,	key : "RETL_ORG_NM",	title : "판매자",		align : "center",	width : "100px" },
                    { columnIndex : 4,	key : "RCV_USER_NM",	title : "접수자",		align : "center",	width : "100px" },
                    { columnIndex : 5,	key : "RGST_DTM",		title : "접수일자",		align : "center",	width : "100px" },
                    { columnIndex : 6,	key : "PROC_USER_NM",	title : "처리자",		align : "center",	width : "100px" },
                    { columnIndex : 7,	key : "PROC_ST_CD_NM",	title : "처리상태",		align : "center",	width : "100px" },
                    { columnIndex : 8,	key : "PROC_DTM",		title : "처리일시",		align : "center",	width : "100px" },
                    { columnIndex : 9,	key : "FILE_CNT",		title : "첨부수량",		align : "center",	width : "100px" }
                    
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
    							param["data"] 		= data;
    							param["page"]      	= $("#grid").alopexGrid("pageInfo").customPaging.current;
				            	param["page_size"] 	= $("#grid").alopexGrid("pageInfo").perPage;
			            		$a.navigate("incmpDocRcvDtl.jsp", param);
    						}
    					}
    				}
                }
            });
        },
        setCodeData : function() {
            $.PSNMUtils.setCodeData([
				{ t:'code', 'elemid' : 'PROC_ST_CD', 'codeid' : 'DSM_DOC_RCV_ST_CD', 'header' : '-전체-' }
            ]);
        },
        searchList: function(param) {
            var _page_no = 1;
            if ( $.PSNMUtils.isNotEmpty(param) && $.PSNMUtils.isNotEmpty(param.page) ) {
                _page_no = param.page;
            }
            var _per_page = $("#grid").alopexGrid("pageInfo").perPage;
            
            $.alopex.request("biz.INCMPDOC@PINCMPDOC001_pSearchIncmpDoc", {
                data: ["#searchTable", function() {
                	this.data.dataSet.fields.FROM_DT   = $.PSNMUtils.getDateInput("FROM_DT");
                	this.data.dataSet.fields.TO_DT     = $.PSNMUtils.getDateInput("TO_DT");
                    this.data.dataSet.fields.page      = _page_no;
                    this.data.dataSet.fields.page_size = _per_page;
                }],
                success: ["#grid",  function(res) {
                	$("#count").setData( {"count" : $.PSNMUtils.numberformat(res.dataSet.fields.count)} );
                	$("#PROC_ST_CNT").setData( {"PROC_ST_CNT" : $.PSNMUtils.numberformat(res.dataSet.fields.PROC_ST_CNT)} );                	
                }]
            });
        }
    });
    
    function excelPage() {
        var oExcelMetaInfo = {
                filename  : "미비서류접수_페이지.xls",
                sheetname : "미비서류접수_페이지",
                gridname  : "grid" //그리드ID 
            };
        $.PSNMUtils.downloadExcelPage("grid", oExcelMetaInfo);
    }
    function excelAll() {
        var oExcelMetaInfo = {
                filename  : "미비서류접수목록_전체.xls",
                sheetname : "미비서류접수목록_전체",
                gridname  : "grid" //그리드ID 
            };        
        $.PSNMUtils.downloadExcelAll("searchForm", "biz.INCMPDOC@PINCMPDOC001_pSearchIncmpDoc", "grid", oExcelMetaInfo);
    }

    </script>

</head>

<body>

<jsp:include page="/view/layouts/default_header.jsp" flush="false" />

<div id="contents">

    <!-- sub title area -->
    <div class="content_title">
        <div id="ub_txt6">
            <span class="txt6_img"><b id="sub-title">미비서류접수관리</b>
                <span class="notice-more"> 
                	<img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif">
                	<span class="a2">본사업무</span> <span class="a3"> > </span> <span class="a4"><b>미비접수관리</b></span>
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
		            <col style="width:25%"/>
		            <col style="width:12%"/>
		            <col style="width:21%"/>
		            <col style="width:12%"/>
		            <col style="width:*"/>
	            </colgroup>
	        	<tbody>
		        	<tr>
		                <th class="fontred">조회기간</th>
		                <td class="tleft">
		                	<div data-type="daterange" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png" >
								<input id="FROM_DT" name="FROM_DT" data-role="startdate" data-bind="value:FROM_DT" style="width:70px;"/>
								~ <input id="TO_DT" name="TO_DT" data-role="enddate" data-bind="value:TO_DT" style="width:70px;"/>
							</div>
						</td>
						<th>본사팀</th>
						<td class="tleft">
		                    <select id="HDQT_TEAM_ORG_ID" name="HDQT_TEAM_ORG_ID" data-bind="options:options_HDQT_TEAM_ORG_ID, selectedOptions: HDQT_TEAM_ORG_ID" data-type="select" data-wrap="false">
		                    	<option value="">-선택-</option>
		                    </select>
		                </td>
		                <th>본사파트</th>
						<td class="tleft">
		                    <select id="HDQT_PART_ORG_ID" name="HDQT_PART_ORG_ID" data-bind="options:options_HDQT_PART_ORG_ID, selectedOptions: HDQT_PART_ORG_ID" data-type="select" data-wrap="false">
		                    	<option value="">-선택-</option>
		                    </select>
		                </td>
		            </tr>
		            <tr>
		            	<th>영업국명</th>
						<td class="tleft">
		                    <select id="SALE_DEPT_ORG_ID" name="SALE_DEPT_ORG_ID" data-bind="options:options_SALE_DEPT_ORG_ID, selectedOptions: SALE_DEPT_ORG_ID" data-type="select" data-wrap="false">
		                    	<option value="">-선택-</option>
		                    </select>
		                </td>
						<th>영업팀명</th>
						<td class="tleft">
		                    <select id="SALE_TEAM_ORG_ID" name="SALE_TEAM_ORG_ID" data-bind="options:options_SALE_TEAM_ORG_ID, selectedOptions: SALE_TEAM_ORG_ID" data-type="select" data-wrap="false">
		                    	<option value="">-선택-</option>
		                    </select>
		                </td>
		                <th>상태</th>
						<td class="tleft">
		                    <select id="PROC_ST_CD" name="PROC_ST_CD" data-bind="options: options_PROC_ST_CD, selectedOptions: PROC_ST_CD" data-type="select" ></select>
		                </td>
		            </tr>
		            <tr>                
						<th>조회조건</th>
						<td class="tleft" colspan="5">
		                    <select id="SEARCH_KIND" name="SEARCH_KIND" data-type="select" data-bind="options: options_SEARCH_KIND, selectedOptions: SEARCH_KIND">
		                    	<option value="" selected>-전체-</option>
		                    	<option value="A.CUST_NM">고객명</option>
							    <option value="B.USER_NM">판매자</option>
							    <option value="C.USER_NM">접수자</option>
							    <option value="D.USER_NM">처리자</option>		
		                    </select>
		                    <input id="SEARCH_VALUE" name="SEARCH_VALUE" data-type="textinput" data-bind="value:SEARCH_VALUE"/>
		                </td>
		            </tr>
	        	</tbody>
            </table>
        </form>
		<div class="ab_pos5">
			<!-- <button id="btnInit"   type="button" data-type="button" data-theme="af-psnm0" data-authtype="R">초기화</button> -->
			<button id="btnSearch" type="button" data-type="button" data-theme="af-psnm" data-authtype="R"></button>			
		</div>
    </div>

    <div class="floatL4">
    	<img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>미비서류접수</b> (<b>총 <label id="count" data-bind="text:count">0</label> 건</b> : <label id="PROC_ST_CNT" data-bind="text:PROC_ST_CNT"></label>)
    	<p class="ab_pos2"> 
    		<button id="btnNew"       data-type="button" data-theme="af-btn2"  data-authtype="W"></button>  
    		<button id="btnExcelPage" data-type="button" data-theme="af-btn3"  data-authtype="W"></button>                       
            <button id="btnExcelAll"  data-type="button" data-theme="af-n-btn27"  data-authtype="W"></button>
        </p>
    </div>

    <!-- main grid -->
    <div id="grid" data-bind="grid:grid"></div>

</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>