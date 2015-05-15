<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

    <jsp:include page="/view/layouts/default_head.jsp" flush="false" />
    
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/vendor/jquery.ui.widget.js"></script>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/jquery.iframe-transport.js"></script>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/jquery.fileupload.js"></script>

    <script type="text/javascript">
    
    var _param;
    
    $.alopex.page({

        init : function(id, param) { 
            $.PSNM.initialize(id, param); //PSNM공통 초기화함수 호출
            
            _param = param; //이 페이지로 전달된 파라미터를 저장

            $.PSNMUtils.setDefaultYmd("#FROM_DT", "TO_DT");
            $a.page.setEventListener();
            $a.page.setGrid();
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
                        filename  : "징계관리.xls",
                        sheetname : "징계관리",
                        gridname  : "grid" //그리드ID 
                    };
        		var txid = "biz.AGNTPRZ@PAGENTDSCPL001_pSearchAgentDscpl";

        		$.PSNMUtils.downloadExcelAll("searchForm", txid, "grid", oExcelMetaInfo);
            });
        	$("#AGNT_NM").keyup( $.PSNMAction.findAgent );
        },
        setGrid : function() {
            $("#grid").alopexGrid({
                rowClickSelect : false,
                rowInlineEdit : true,
                columnMapping : [
					{ columnIndex : 0, key  : "DISPL_DT",     		title : "일자",       	align : "center", 	width : "80px"  },
                    { columnIndex : 1, key  : "DISPL_RSN_NM", 		title : "사유",     		align : "left", 	width : "150px" },
                    { columnIndex : 2, key  : "DISPL_CTT",      	title : "PENALTY내용",   align : "left", 	width : "250px" },
                    { columnIndex : 3, key  : "HDQT_PART_ORG_NM",  	title : "본사파트",     	align : "center", 	width : "100px" },
                    { columnIndex : 4, key  : "SALE_DEPT_ORG_NM",  	title : "영업국명",     	align : "center", 	width : "100px" },
                    { columnIndex : 5, key  : "SALE_TEAM_ORG_NM",	title : "영업팀명",   	align : "center", 	width : "100px" },
                    { columnIndex : 6, key  : "AGNT_ID", 			title : "에이전트코드", 	align : "center", 	width : "80px"  },
                    { columnIndex : 7, key  : "RPSTY_NM", 			title : "직책명", 		align : "center", 	width : "100px" },
                    { columnIndex : 8, key  : "AGNT_NM",  			title : "에이전트명",   	align : "center", 	width : "100px" }
                    
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
    			            	$a.navigate("teamAgentDscplDtl.jsp", param);
    						}
    					}
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
            
            $.alopex.request("biz.AGNTPRZ@PAGENTDSCPL001_pSearchAgentDscpl", {
                data: ["#searchTable", function() {
                	this.data.dataSet.fields.FROM_DT   = $.PSNMUtils.getDateInput("FROM_DT");
                	this.data.dataSet.fields.TO_DT     = $.PSNMUtils.getDateInput("TO_DT");
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
            <span class="txt6_img"><b id="sub-title">징계관리</b>
                <span class="notice-more"> 
                	<img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif">
                	<span class="a2">영업팀업무</span> <span class="a3"> > </span> <span class="a4"><b>에이전트관리</b></span> 
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
	            <col style="width:15%"/>
	            <col style="width:12%"/>
	            <col style="width:*"/>
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
                <th class="fontred">본사파트</th>
				<td class="tleft">
                    <select id="HDQT_PART_ORG_ID" data-bind="options:options_HDQT_PART_ORG_ID, selectedOptions: HDQT_PART_ORG_ID" data-type="select" 
                    	data-validation-rule="{required:true}"
						data-validation-message="{required:$.PSNM.msg('E012', ['본사파트'])}">
                    	<option value="">-선택-</option>
                    </select>
                </td>
            </tr>
            <tr>
                <th class="fontred">영업국명</th>
				<td class="tleft">
                    <select id="SALE_DEPT_ORG_ID" data-bind="options:options_SALE_DEPT_ORG_ID, selectedOptions: SALE_DEPT_ORG_ID" data-type="select" 
                    	data-validation-rule="{required:true}"
						data-validation-message="{required:$.PSNM.msg('E012', ['영업국명'])}">
                    	<option value="">-선택-</option>
                    </select>
                </td>
				<th class="fontred">영업팀명</th>
				<td class="tleft">
                    <select id="SALE_TEAM_ORG_ID" data-bind="options:options_SALE_TEAM_ORG_ID, selectedOptions: SALE_TEAM_ORG_ID" data-type="select" 
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
            </tr>
            </table>
			<div class="ab_pos4">
				<button id="btnSearch" type="button" data-type="button" data-theme="af-psnm" data-authtype="R"></button>
			</div>
			<p>
				<font size="2" color="red">징계 당시의 에이전트 정보로 조회하시기 바랍니다.</font> 
			</p>
        </form>
    </div>

    <div class="floatL4">
    	<img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>징계관리</b>
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