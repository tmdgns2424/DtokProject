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
            
            $.PSNMUtils.setDefaultYmd("#FROM_DT", "TO_DT");
            $a.page.setEventListener();
            $a.page.setGrid();
            $a.page.setCodeData();            
        	$("#detail").hide();
			//$a.page.searchList(param);
        },
        setEventListener : function() {
        	
			/* grid에 데이타 반영 */
        	$("#AGNT_NM").keyup( $.PSNMAction.findAgent );
            $("#btnSearch").click($a.page.searchList);
            
            $("#btnAppr").click(function(){
            	
            	var oRecord = AlopexGrid.trimData( $("#gridPrfIsue").alopexGrid( "dataGet" , { _state : { selected : true } } ) );
        		if (oRecord.length == 0) {
        			$.PSNM.alert("E021", ["승인할 행을"]);
                    return false;
                }
        		
        		if( oRecord[0].PRF_ISUE_ST_CD != "02"){
        			$.PSNM.alert("발급의뢰건만 승인이 가능합니다.");
        			return false;
        		}
				/*
            	if( (oRecord[0].PRF_CL_CD=="02" || oRecord[0].PRF_CL_CD=="03") && $.PSNMUtils.isEmpty($("#ISUE_RSN_CTT").val()) ){
            		$.PSNM.alert("E012", ["해촉통보서, 해촉확인서의 경우 발급사유"]);
            		$("#ISUE_RSN_CTT").focus();
            		return false;
            	}
            	*/
            	if( !$.PSNM.confirm("I004", ["승인"] ) ){
            		return false;
            	}

            	$("#gridPrfIsue").alopexGrid( "dataEdit" , $.extend(true, $("#detail").getData(), { FLAG : "04" }), { _state : { selected : true } } );
            	
            	var gridData = $("#gridPrfIsue").alopexGrid( "dataGet",  { _state : { selected : true } } );
            	
            	var dataSet = {}, dataSetData = {}, recordSetsData= {};
                dataSetData["fields"] = {};
                recordSetsData["gridPrfIsue"] = {nc_list: AlopexGrid.trimData( gridData ) };
                dataSetData["recordSets"] = recordSetsData;
                dataSet["dataSet"] = dataSetData;
                
               	$.alopex.request("biz.PRFISUE@PPRFISUEMGMT001_pSavePrfIsueStCd", {
                       data: dataSet,
                       success: function(res) { 
                      	 if ( ! $.PSNM.success(res) ) { //서버측 FAIL응답
                    		 return false;
                    	 }
                      	 AlopexGrid.trimData( $("#gridPrfIsue").alopexGrid( "dataEdit", { PRF_ISUE_ST_CD : "04"}, { _state : { selected : true } } ) );
                      	 $("#PRF_ISUE_ST_CD").val("04")
                       }
                });
               	
            });
            
            $("#btnReturn").click(function(){
            	var oRecord = AlopexGrid.trimData( $("#gridPrfIsue").alopexGrid( "dataGet" , { _state : { selected : true } } ) );
            	
        		if (oRecord.length == 0) {
        			$.PSNM.alert("E021", ["반려할 행을"]);
                    return false;
                }
        		
        		if( oRecord[0].PRF_ISUE_ST_CD != "02"){
        			$.PSNM.alert("발급의뢰건만 반려가 가능합니다.");
        			return false;
        		}
        		
            	if( $.PSNMUtils.isEmpty($("#RJCT_RSN_CTT").val()) ){
            		$.PSNM.alert("E012", ["반려사유"]);
            		$("#RJCT_RSN_CTT").focus();
            		return false;
            	}
            	
            	if( !$.PSNM.confirm("I004", ["반려"] ) ){
            		return false;
            	}
            	
            	$("#gridPrfIsue").alopexGrid( "dataEdit" , $.extend(true, $("#detail").getData(), { FLAG : "05" }), { _state : { selected : true } } );

            	var gridData = $("#gridPrfIsue").alopexGrid( "dataGet",  { _state : { selected : true } } );
            	var dataSet = {}, dataSetData = {}, recordSetsData= {};
                dataSetData["fields"] = {};
                recordSetsData["gridPrfIsue"] = {nc_list: AlopexGrid.trimData( gridData ) };
                dataSetData["recordSets"] = recordSetsData;
                dataSet["dataSet"] = dataSetData;
                
               	$.alopex.request("biz.PRFISUE@PPRFISUEMGMT001_pSavePrfIsueStCd", {
                       data: dataSet,
                       success: function(res) { 
                      	 if ( ! $.PSNM.success(res) ) { //서버측 FAIL응답
                    		 return false;
                    	 }
                      	 AlopexGrid.trimData( $("#gridPrfIsue").alopexGrid( "dataEdit", { PRF_ISUE_ST_CD : "05"}, { _state : { selected : true } } ) );
                      	$("#PRF_ISUE_ST_CD").val("05")
                       }
                });
               	
            });
            
            
            $("#btnExcelPage").click(function(){
                var oExcelMetaInfo = {
                        filename  : "증명서발급 관리.xls",
                        sheetname : "증명서발급 관리",
                        gridname  : "gridPrfIsue" //그리드ID 
                    };
                //$.PSNMUtils.downloadExcelPage("gridPrfIsue", oExcelMetaInfo, [11,12,13,14,15,16,17,18]);
                oExcelMetaInfo.gridname = "gridPrfIsueExcel";
                $.PSNMUtils.downloadExcelPage("gridPrfIsueExcel", oExcelMetaInfo);
            });
        },
        setGrid : function() {
            $("#gridPrfIsue").alopexGrid({
                pager: false,
                rowSingleSelect : true,
                rowClickSelect : true,
                rowInlineEdit : false,
                height : "400px",
                columnMapping : [
					{ columnIndex : 0, key : "PRF_MGMT_NUM", 		hidden : true  },
                    { columnIndex : 1, key : "OUT_ORG_NM",			title : "본사파트",		align : "center", 	width : "80px"	},
                    { columnIndex : 2, key : "DSM_HEADQ_NM",		title : "영업국명",		align : "center", 	width : "100px"	},
                    { columnIndex : 3, key : "DSM_TEAM_NM",		    title : "영업팀명",		align : "center", 	width : "100px"	},
                    { columnIndex : 4, key : "AGNT_ID",			    title : "에이전트코드",	align : "center", 	width : "100px"	},
                    { columnIndex : 5, key : "RPSTY_NM",			title : "직책명",		align : "center", 	width : "80px"	},
                    { columnIndex : 6, key : "AGNT_NM",				title : "에이전트명",	    align : "center", 	width : "120px"	},
                    { columnIndex : 7, key : "PRF_CL_CD",			title : "증명서구분",	    align : "center", 	width : "120px"	
                       , render : {
            				          type : "string",
               					      rule : function() {
										            var oParam = { t:'code', 'codeid' : 'DSM_PRF_CL_CD', 'header' : ' ' };	
										        	return $.PSNMUtils.getCode(oParam);
                                               }
                			        }
                    },
                    { columnIndex : 8, key : "REQ_DTM",				title : "의뢰일시",	    align : "center", 	width : "120px"	},
                    { columnIndex : 9, key : "ISUE_QTY",			title : "매수",	    align : "center", 	width : "50px"	},
                    { columnIndex : 10, key : "PRF_ISUE_ST_CD",		title : "상태",	    align : "center", 	width : "120px"
                        , render : {
		  				              type : "string",
		     					      rule : function(value, data) {
										            var oParam = { t:'code', 'codeid' : 'DSM_PRF_ISUE_ST_CD', 'header' : ' ' };	
										        	return $.PSNMUtils.getCode(oParam);
                                      }
      			        }
                    },
                    { columnIndex :11, key : "ISUE_DTM",			title : "발급일시",	    align : "center", 	width : "120px"	},
                    
                    { columnIndex :12, key : "ORG_ID",				title : "ORG_ID",	        align : "center", 	width : "120px", hidden : true	},
                    { columnIndex :13, key : "OUT_ORG_ID",		    title : "OUT_ORG_ID",	    align : "center", 	width : "120px", hidden : true	},
                    { columnIndex :14, key : "DSM_HEADQ_CD",		title : "DSM_HEADQ_CD",	    align : "center", 	width : "120px", hidden : true	},
                    { columnIndex :15, key : "DSM_TEAM_CD",		    title : "DSM_TEAM_CD",	    align : "center", 	width : "120px", hidden : true	},
                    { columnIndex :16, key : "PRF_USG_CD",			title : "PRF_USG_CD",	    align : "center", 	width : "120px", hidden : true	},
                    { columnIndex :17, key : "ISUE_RSN_CTT",	    title : "ISUE_RSN_CTT",     align : "center", 	width : "120px", hidden : true  },
                    { columnIndex :18, key : "RJCT_RSN_CTT",	    title : "RJCT_RSN_CTT",     align : "center", 	width : "120px", hidden : true  },
                    { columnIndex :19, key : "FLAG",			    title : "FLAG",             align : "center", 	width : "120px", hidden : true  },
            	],
                on : {
                    "row" : {
    					"click" : function(data, eh, e) {
    						if(data._index.column != 0) {    							
    							$("#form").setData( data );
    							$("#detail").show();
    						}
    					}
    				}
                }
            });
            $a.page.setGrid2(); //엑셀다운로드용 그리드 초기화
        },
        setGrid2 : function() { //엑셀다운로드용 그리드 초기화
            $("#gridPrfIsueExcel").alopexGrid({
                pager: false,
                rowSingleSelect : true,
                rowClickSelect : true,
                rowInlineEdit : false,
                height : "300px",
                columnMapping : [
                    { columnIndex : 0, key : "OUT_ORG_NM",        title : "본사파트",     align : "center", width : "80px"  },
                    { columnIndex : 1, key : "DSM_HEADQ_NM",      title : "영업국명",     align : "center", width : "100px" },
                    { columnIndex : 2, key : "DSM_TEAM_NM",		  title : "영업팀명",		align : "center", 	width : "100px"	},
                    { columnIndex : 3, key : "AGNT_ID",           title : "에이전트코드", align : "center", width : "100px" },
                    { columnIndex : 4, key : "RPSTY_NM",          title : "직책명",       align : "center", width : "80px"  },
                    { columnIndex : 5, key : "AGNT_NM",           title : "에이전트명",   align : "center", width : "120px" },
                    { columnIndex : 6, key : "PRF_CL_CD_NM",      title : "증명서구분",   align : "center", width : "120px" },
                    { columnIndex : 7, key : "REQ_DTM",           title : "의뢰일시",     align : "center", width : "120px" },
                    { columnIndex : 8, key : "ISUE_QTY",          title : "매수",         align : "center", width : "50px"  },
                    { columnIndex : 9, key : "PRF_ISUE_ST_CD_NM", title : "상태",         align : "center", width : "120px" },
                    { columnIndex : 10, key : "ISUE_DTM",         title : "발급일시",     align : "center", width : "120px" }
                ]
            });
        },
        setCodeData : function() {
            $.PSNMUtils.setCodeData([
				{ t:'code', 'elemid' : 'PRF_CL_CD', 'codeid' : 'DSM_PRF_CL_CD', 'header' : '-선택-' },
				{ t:'code', 'elemid' : 'PRF_USG_CD', 'codeid' : 'DSM_PRF_USG_CD', 'header' : '-선택-' },
				{ t:'code', 'elemid' : 'PRF_ISUE_ST_CD', 'codeid' : 'DSM_PRF_ISUE_ST_CD', 'header' : '-전체-' },
				{ t:'code', 'elemid' : 'SEARCH_PRF_ISUE_ST_CD', 'codeid' : 'DSM_PRF_ISUE_ST_CD', 'header' : '-전체-' }
            ], function() {
            	$("#SEARCH_PRF_ISUE_ST_CD").children("[value='01']").remove();
            	$("#SEARCH_PRF_ISUE_ST_CD").children("[value='02']").remove();
            	}
            );
        },
        searchList: function(param) {
        	if ( ! $.PSNM.isValid("#searchForm") ) {
    			return false; //값 검증
    		}
            $.alopex.request("biz.PRFISUE@PPRFISUEMGMT001_pSearchPrfIsue", {
                data: ["#searchTable", function(){
                	this.data.dataSet.fields.FROM_DT   = $.PSNMUtils.getDateInput("FROM_DT");
                	this.data.dataSet.fields.TO_DT     = $.PSNMUtils.getDateInput("TO_DT");
                	this.data.dataSet.fields.GUBN      = "DEPT";
                }],
                success: ["#gridPrfIsue", "#gridPrfIsueExcel", function(){
                	//$("#gridPrfIsue").alopexGrid( "run", "", "rowSelect", { PRF_ISUE_ST_CD : "05"}, true);
                	//$("#gridPrfIsue").alopexGrid( "rowSelect", { PRF_ISUE_ST_CD : "05"}, true);
                }],
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
            <span class="txt6_img"><b id="sub-title">증면서발급 관리</b>
                <span class="notice-more"> 
                	<img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif">
                	<span class="a2">영업국업무</span> <span class="a3"> > </span> <span class="a4"><b>증면서발급 관리</b></span> 
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
	            <col style="width:25%"/>
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
					<input id="AGNT_NM" name="AGNT_NM" data-bind="value:AGNT_NM" data-type="textinput" data-agentid="AGNT_ID" data-findtype="ALL" size="15"/>
					<input id="AGNT_ID" name="AGNT_ID" data-bind="value:AGNT_ID" data-type="textinput" data-disabled="true" size="15"/>	
                </td>
            </tr>   
                                           <tr>
                <th>상태</th>
				<td class="tleft" colspan="5">
                    <select id="SEARCH_PRF_ISUE_ST_CD" data-bind="options:options_SEARCH_PRF_ISUE_ST_CD, selectedOptions: SEARCH_PRF_ISUE_ST_CD" data-type="select" style="width:150px">
                    </select>
                </td>
            </tr>
            </table>
			<div class="ab_pos4">
				<button id="btnSearch" type="button" data-type="button" data-theme="af-psnm" data-authtype="R"></button>
			</div>
        </form>
    </div>
    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>증명서발급 목록</b>
        <div class="ab_pos2">
            <button id="btnAppr" type="button" data-type="button" data-theme="af-btn5" data-altname="승인" data-authtype="W"></button>
            <button id="btnReturn" type="button" data-type="button" data-theme="af-btn6" data-altname="반려" data-authtype="W"></button>    
            <button id="btnExcelPage" type="button" data-type="button" data-theme="af-btn3" data-altname="엑셀다운" data-authtype="R"></button>    	
        </div>
    </div>

    <!-- main grid -->
    <div id="gridPrfIsue" data-bind="grid:gridPrfIsue"></div>
    
	<div id="detail" style="display: none;">
		<div class="floatL4">
			<img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"/> <b>증명서발급 상세</b>
		</div>
		<form id="form" onsubmit="return false;">
		
		<input id="ORG_ID" name="ORG_ID" type="hidden" data-bind="value:ORG_ID" data-type="textinput">
		<input id="OUT_ORG_ID" name="OUT_ORG_ID" type="hidden" data-bind="value:OUT_ORG_ID" data-type="textinput">
		<input id="DSM_HEADQ_CD" name="DSM_HEADQ_CD" type="hidden" data-bind="value:DSM_HEADQ_CD" data-type="textinput">
		<input id="DSM_TEAM_CD" name="DSM_TEAM_CD" type="hidden" data-bind="value:DSM_TEAM_CD" data-type="textinput">
		<input id="RPSTY_NM" name="RPSTY_NM" type="hidden" data-bind="value:RPSTY_NM" data-type="textinput">
		
		<input id="FLAG" name="FLAG" type="hidden"/>
		<table class="board02" style="width:100%;">
			<colgroup>
	            <col style="width:10%"/>
	            <col style="width:15%"/>
	            <col style="width:10%"/>
	            <col style="width:15%"/>
	            <col style="width:10%"/>
	            <col style="width:15%"/>
	            <col style="width:10%"/>
	            <col style="width:*"/>
			</colgroup>
			<tr>
				<th scope="col">에이전트명</th>
				<td class="tleft">
					<label id="AGNT_NM" name="AGNT_NM" data-bind="text:AGNT_NM"></label>					
				</td>
				<th scope="col">생년월일</th>
				<td class="tleft">
					<label id="BIRTH_DT" name="BIRTH_DT" data-bind="text:BIRTH_DT"></label>	
				</td>
				<th scope="col">증명서구분</th>
				<td class="tleft">
					<select id="PRF_CL_CD" name="PRF_CL_CD" data-type="select" style="width:150px;"
						data-bind="options: options_PRF_CL_CD, selectedOptions: PRF_CL_CD" data-disabled="true"></select>
				</td>
				<th scope="col">용도</th>
				<td class="tleft">
					<select id="PRF_USG_CD" name="PRF_USG_CD" data-type="select" style="width:150px;" 
						data-bind="options: options_PRF_USG_CD, selectedOptions: PRF_USG_CD" data-disabled="true"></select>
				</td>				
			</tr>
			<tr>
				<th scope="col">본사파트</th>
				<td class="tleft">
					<label id="OUT_ORG_NM" data-bind="text:OUT_ORG_NM"></label>
				</td>
				<th scope="col">영업국명</th>
				<td class="tleft">
					<label id="DSM_HEADQ_NM" data-bind="text:DSM_HEADQ_NM"></label>					
				</td>
				<th scope="col">영업팀명</th>
				<td class="tleft">
					<label id="DSM_TEAM_NM" data-bind="text:DSM_TEAM_NM"></label>					
				</td>
				<th scope="col">매수</th>
				<td class="tleft">
					<label id="ISUE_QTY" name="ISUE_QTY" data-bind="text:ISUE_QTY"></label>	
				</td>				
			</tr>
			<tr>
				<th scope="col">상태</th>
				<td class="tleft">
					<select id="PRF_ISUE_ST_CD" name="PRF_ISUE_ST_CD" data-type="select" style="width:150px;" data-disabled="true"
						data-bind="options: options_PRF_ISUE_ST_CD, selectedOptions: PRF_ISUE_ST_CD">
					</select>
				</td>
				<th scope="col">의뢰일자</th>
				<td class="tleft">
					<label id="REQ_DTM" data-bind="text:REQ_DTM"></label>
				</td>
				<th scope="col">발급일시</th>
				<td class="tleft" colspan="3">
					<label id="ISUE_DTM" data-bind="text:ISUE_DTM"></label>
				</td>				
			</tr>
			<tr>
				<th scope="col">요청사유</th>
				<td class="tleft" colspan="7">
					<label id="ISUE_RSN_CTT" data-bind="text:ISUE_RSN_CTT"></label>
				</td>				
			</tr>			
			<tr>
				<th scope="col">반려사유</th>
				<td class="tleft" colspan="7">
					<input id="RJCT_RSN_CTT" data-bind="value:RJCT_RSN_CTT" data-type="textinput" style="width:95%" />
				</td>				
			</tr>
		</table>
		</form>
	</div>    

    <div id="gridPrfIsueExcel" data-bind="grid:gridPrfIsue" style="display: none;"></div><!-- 엑셀다운로드용 -->
</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>