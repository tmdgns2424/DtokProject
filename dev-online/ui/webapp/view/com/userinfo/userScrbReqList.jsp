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
            $("#searchTable").setData(param);
            if( $.PSNMUtils.isEmpty(param.FROM_DT) ){
            	$("#SCRB_ST_CD").val("01");
            }
			if( $.PSNMUtils.isNotEmpty($("#HDQT_TEAM_ORG_ID").val()) || param.PREV_PAGE == "MAIN" ){
				$a.page.searchList(param);
			}
        },
        setEventListener : function() {
        	$("#btnSearch").click($a.page.searchList);
        	$("#btnExcelPage").click($a.page.excelPage);
        	/*
        	$("#btnNew").click(function(){
            	var param = $('#searchTable').getData();
                param["page_size"] = $('#grid').alopexGrid('pageInfo').perPage;
    	        try { 
    	            param["page"]  = $("#grid").alopexGrid("pageInfo").customPaging.current; 
    	        } catch(E) {
    	            param["page"]  = 1; //디폴트 1페이지
    	        }
            	$a.navigate("prdFtftPlanDtl.jsp", param);
            });
        	
        	$("#btnExcelAll").click(function(){
            	var oExcelMetaInfo = {
                        filename  : "면담계획_정기면담.xls",
                        sheetname : "면담계획_정기면담",
                        gridname  : "grid" //그리드ID 
                    };
        		var txid = "biz.AGNTFTFT@PAGENTCNSLPLN001_pSearchAgentCnslPln";

        		$.PSNMUtils.downloadExcelAll("searchForm", txid, "grid", oExcelMetaInfo);
            });
        	*/
        	//$("#AGNT_NM").keyup( $.PSNMAction.findAgent );
        },
        setGrid : function() {
            $("#grid").alopexGrid({
                rowClickSelect : false,
                rowInlineEdit : true,
                columnMapping : [
                    { columnIndex : 0, key : "SCRB_REQ_SEQ",        title : "요청순번",		align : "center", 	width : "100px" },
                    { columnIndex : 1, key : "SCRB_ST_NM",  		title : "가입상태",		align : "center", 	width : "80px"  },
                    { columnIndex : 2, key : "USER_ID",             title : "회원ID",		align : "center", 	width : "100px" },
                    { columnIndex : 3, key : "USER_NM",             title : "회원명",		align : "center", 	width : "80px" },
                    { columnIndex : 4, key : "DUTY_NM", 	        title : "직무",		    align : "center", 	width : "80px"	},
                    { columnIndex : 5, key : "HDQT_PART_ORG_NM",    title : "본사파트",	    align : "center", 	width : "100px" },
                    { columnIndex : 6, key : "SALE_DEPT_ORG_NM",    title : "영업국명",	    align : "center", 	width : "100px" },
                    { columnIndex : 7, key : "AGNT_ID", 			title : "에이전트코드",	align : "center", 	width : "80px"	},
                    { columnIndex : 8, key : "AGNT_NM", 			title : "에이전트명",		align : "center", 	width : "100px"	},
                    { columnIndex : 9, key : "SCRB_REQ_DT", 		title : "가입요청일시",	align : "center", 	width : "100px"	},
                    { columnIndex : 10, key : "SCRB_APRVR_NM", 		title : "승인자",		align : "center", 	width : "80px"	},
                    { columnIndex : 11, key : "SCRB_APRV_DT", 		title : "처리일",		align : "center", 	width : "100px"	},
                    { columnIndex : 12, key : "SCRB_ST_CD", 		hidden: true},
                ],
                on : {
                    pageSet : function(pageNoToGo) {
                    	var p = {};
	                        p.page = pageNoToGo;
	                        $a.page.searchList(p);
                    },
                }
            });
        
	        $("#grid").alopexGrid('updateOption', {
	            on : {
	                'cell' : {
	
						"dblclick" : function(data, eh, e) {
							if(data._index.column != 0) {
								var param = $("#searchTable").getData({selectOptions:true});
				        			param["data"]      = data;
									param["page"]      = $("#grid").alopexGrid("pageInfo").customPaging.current;
					            	param["page_size"] = $("#grid").alopexGrid("pageInfo").perPage;
	
				            	if( data.SCRB_ST_CD == "01" || data.SCRB_ST_CD == "03" ){	
					            	$a.navigate("userScrbReqDtl.jsp", param);
				            	}else{
				            		$a.navigate("<c:out value='${pageContext.request.contextPath}'/>/view/com/usermgmt/userInfoMgmtDtl.jsp", param);
				            	}
							}
						},
	                    
	                    "click" : function(data, eh, e) {    //표준 : 더블클릭시 상세페이지로 이동함.
	                    
	                    	if ( $.PSNMUtils.isMobile() ) {
	    						if(data._index.column != 0) {
	    							var param = $("#searchTable").getData({selectOptions:true});
	    			        			param["data"]      = data;
	    								param["page"]      = $("#grid").alopexGrid("pageInfo").customPaging.current;
	    				            	param["page_size"] = $("#grid").alopexGrid("pageInfo").perPage;
	   
	    			            	if( data.SCRB_ST_CD == "01" || data.SCRB_ST_CD == "03" ){	
	    				            	$a.navigate("userScrbReqDtl.jsp", param);
	    			            	}else{
	    			            		$a.navigate("<c:out value='${pageContext.request.contextPath}'/>/view/com/usermgmt/userInfoMgmtDtl.jsp", param);
	    			            	}
	    						}
	                    	}
	                    },
	                }
	            }
	        });
        },
        setCodeData : function() {
            $.PSNMUtils.setCodeData([
                { t:'org1',  'elemid' : 'HDQT_TEAM_ORG_ID', 'header' : '-전체-' }
                ,{ t:'code',  'elemid' : 'SCRB_ST_CD', 'codeid' : 'DSM_SCRB_ST_CD', 'header' : '-전체-' }
                ,{ t:'duty',  'elemid' : 'DUTY', 'codeid' : '1', 'header' : '-전체-' }
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
            var _per_page = $("#grid").alopexGrid("pageInfo").perPage;
            
            $.alopex.request("com.USERINFO@PUSERSCRBREQ001_pSearchUserScrbReq", {
                data: ["#searchTable", function() {
                	this.data.dataSet.fields.FROM_DT   = $.PSNMUtils.getDateInput("FROM_DT");
                	this.data.dataSet.fields.TO_DT     = $.PSNMUtils.getDateInput("TO_DT");
                    this.data.dataSet.fields.page      = _page_no;
                    this.data.dataSet.fields.page_size = _per_page;
                }],
                success: ["#grid", "#buttonDiv", function(res) {
                }]
            });
        },
        excelPage : function(){
        	var oExcelMetaInfo = {
                    filename  : "회원가입요청.xls",
                    sheetname : "회원가입요청",
                    gridname  : "grid" //그리드ID 
                };
            $.PSNMUtils.downloadExcelPage("grid", oExcelMetaInfo, [12]);
        }
    });

    </script>

</head>

<body>

<jsp:include page="/view/layouts/default_header.jsp" flush="false" />

<!-- contents area -->
<div id="contents">

	<!-- sub title area -->
    <div id="ub_txt6">
        <span class="txt6_img"><b id="sub-title">회원가입요청관리</b>
            <span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif">
            <span class="a2"></span> <span class="a3"> > </span> <span class="a4"></span> 
        </span>
    </div>

    <!-- find condition area -->
    <div id="searchDiv" class="textAR">
		<form id="searchForm" onsubmit="return false;">
        	<table id="searchTable" class="board02" style="width:92%;">
        	<colgroup>
	            <col style="width:15%"/>
	            <col style="width:30%"/>
	            <col style="width:15%"/>
	            <col style="width:20%"/>
	            <col style="width:15%"/>
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
                    <select id="HDQT_TEAM_ORG_ID" data-bind="options:options_HDQT_TEAM_ORG_ID, selectedOptions: HDQT_TEAM_ORG_ID" data-type="select" style="width:150px">
                    	<option value="">-선택-</option>
                    </select>
                </td>
                <th>본사파트</th>
				<td class="tleft">
                    <select id="HDQT_PART_ORG_ID" data-bind="options:options_HDQT_PART_ORG_ID, selectedOptions: HDQT_PART_ORG_ID" data-type="select" style="width:150px">
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
                <th>에이전트명</th>
				<td class="tleft">
                    <select id="SALE_AGNT_ORG_ID" data-bind="options:options_SALE_AGNT_ORG_ID, selectedOptions: SALE_AGNT_ORG_ID" data-type="select" style="width:150px">
                        <option value="">-선택-</option>
                    </select>
                </td>
            </tr>
            <tr>
                <th>직무</th>
				<td class="tleft">
                    <select id="DUTY" data-bind="options: options_DUTY, selectedOptions: DUTY" data-type="select" style="width:150px"></select>
                </td>
                <th>가입상태</th>
				<td class="tleft">
                    <select id="SCRB_ST_CD" data-bind="options: options_SCRB_ST_CD, selectedOptions: SCRB_ST_CD" data-type="select" style="width:150px"></select>
                </td>
                <th>회원ID</th>
				<td class="tleft">
                    <input id="USER_ID" data-bind="value:USER_ID" data-type="textinput" />
                </td> 
            </tr>
            <tr>
                <th>회원명</th>
				<td class="tleft" colspan="5">
                    <input id="USER_NM" data-bind="value:USER_NM" data-type="textinput" />
                </td>
            </tr>            
            </table>
			<div class="ab_pos4">
				<button id="btnSearch" type="button" data-type="button" data-theme="af-psnm" data-authtype="R"></button>
			</div>
        </form>
    </div>

    <div id="buttonDiv" class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>회원가입 목록</b>
    	(가입요청&nbsp;<label data-bind="text:REQ_CNT">0</label>&nbsp;명, 가입승인&nbsp;<label data-bind="text:APPR_CNT">0</label>&nbsp;명)
        <p class="ab_pos2">
        	<button id="btnExcelPage" type="button" data-type="button" data-theme="af-btn3" data-altname="엑셀다운" data-authtype="R"></button>
        </p>
    </div>

    <!-- main grid -->
    <div id="grid" data-bind="grid"></div>

</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>