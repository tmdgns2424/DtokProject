<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

    <jsp:include page="/view/layouts/default_head.jsp" flush="false" />
	<STYLE TYPE="TEXT/CSS">
	.gridRedColor{COLOR:RED;}
	.gridBlueColor{COLOR:BLUE}
	.gridBlackColor{COLOR:BLACK}
	.gridBold{FONT-WEIGHT:BOLD}
	</STYLE>
    <script type="text/javascript">
    $.alopex.page({

        init : function(id, param) { 
            $.PSNM.initialize(id, param); //PSNM공통 초기화함수 호출

            $.PSNMUtils.setDefaultYmd("#FROM_DT", "TO_DT");
            $a.page.setEventListener();
            $a.page.setGrid();
            $a.page.setCodeData();
            $("#searchTable").setData(param);  //(설명) 상세페이지에서 돌아오는 경우, 이 값들이 세션스토리지에서 반환됨.
			if( $.PSNMUtils.isNotEmpty($("#HDQT_TEAM_ORG_ID").val()) && $.PSNMUtils.isNotEmpty($("#HDQT_PART_ORG_ID").val()) 
					&& $.PSNMUtils.isNotEmpty($("#SALE_DEPT_ORG_ID").val()) && $.PSNMUtils.isNotEmpty($("#SALE_TEAM_ORG_ID").val()) ){
				$a.page.searchList(param);
			}  
        },
        setEventListener : function() {
        	$("#btnSearch").click($a.page.searchList);
        	$("#btnNew").click( function(){
        		$a.navigate("scrbClmRgst.jsp", null);
        	} );
        	$("#btnExcelPage").click($a.page.excelPage);
        },
        setGrid : function() {
            $("#gridScrbClm").alopexGrid({
                rowClickSelect : false,
                rowInlineEdit  : true,
                rowOption : {
                	styleclass : function(data, rowOption) {
                		    var rtnVal = "";
                		    /*폰트색*/
                		    if( data.SCRB_CLM_ST_CD == "Y" ){   //처리완료
	            				rtnVal = "gridBlackColor";
	            			}else if( data.OP_CNT == 0 ){        //접수
	            				rtnVal += "gridRedColor";
                			}else if( data.OP_CNT > 0 ){         //처리중(재처리중)
                				rtnVal += "gridBlueColor";
                			}
	            			return rtnVal;
                        }
                },
                headerGroup    : [
					{ fromIndex : 0 , toIndex : 3 , title : "접수정보" },
					{ fromIndex : 4 , toIndex :11 , title : "판매정보" },
					{ fromIndex :12 , toIndex :16 , title : "상담정보" },
					{ fromIndex :17 , toIndex :19 , title : "처리정보" },
					{ fromIndex :20 , toIndex :22 , title : "Penalty내역" },
                ],
                columnMapping  : [
                    { columnIndex : 0, key : "SCRB_CLM_ST_NM",         title : "상태",		    align : "center", 	width : "100px" },
                    { columnIndex : 1, key : "RCV_MGMT_NUM",  		   title : "접수번호",		align : "center", 	width : "95px"  },
                    { columnIndex : 2, key : "RCV_DTM",        	       title : "접수일시",		align : "center", 	width : "100px" },
                    { columnIndex : 3, key : "RCV_OWNR_NM",            title : "접수주체",		align : "center", 	width : "100px" },
                    { columnIndex : 4, key : "SALE_DTM", 	           title : "개통일",		    align : "center", 	width : "80px"	},
                    { columnIndex : 5, key : "MBL_PHON_NUM",           title : "개통번호",	    align : "center", 	width : "100px" },
                    { columnIndex : 6, key : "CUST_NM", 			   title : "고객명",		    align : "center", 	width : "100px"	},
                    { columnIndex : 7, key : "HDQT_PART_ORG_ID", 	   title : "본사파트",		align : "center", 	width : "100px"	},
                    { columnIndex : 8, key : "SALE_DEPT_ORG_ID", 	   title : "영업국명",		align : "center", 	width : "100px"	},
                    { columnIndex : 9, key : "SALE_TEAM_ORG_ID", 	   title : "영업팀명",		align : "center", 	width : "60px"	},
                    { columnIndex : 10, key : "AGNT_ID", 		       title : "에이전트코드",	align : "center", 	width : "100px"	},
                    { columnIndex : 11, key : "AGNT_NM2", 		       title : "에이전트명",		align : "center", 	width : "100px"	},
                    { columnIndex : 12, key : "CNSLR_NM", 		       title : "상담사명",		    align : "center", 	width : "100px"	},
                    { columnIndex : 13, key : "CNSLR_TEL", 		       title : "상담사 연락처",	align : "center", 	width : "100px"	},
                    { columnIndex : 14, key : "CLM_TYP_NM", 		   title : "민원유형",		align : "center", 	width : "100px"	},
                    { columnIndex : 15, key : "OP_CNT", 		       title : "건수",		    align : "center", 	width : "100px"	},
                    { columnIndex : 16, key : "OP_CLS_DTM",		       title : "처리시한",		align : "center", 	width : "100px"	},
                    { columnIndex : 17, key : "FNSH_DTM", 		       title : "처리완료일시",	align : "center", 	width : "100px"	},
                    { columnIndex : 18, key : "SELLER_PEN_AMT", 	   title : "판매자",		    align : "center", 	width : "100px", 	render:{type : "string", rule:"comma"}	},
                    { columnIndex : 19, key : "TEAM_LDR_PEN_AMT", 	   title : "국장",		    align : "center", 	width : "100px", 	render:{type : "string", rule:"comma"}	},
                    { columnIndex : 20, key : "DRTR_PEN_AMT", 		   title : "팀장",		    align : "center", 	width : "100px", 	render:{type : "string", rule:"comma"}	},                    
                ],
                on : {
                    pageSet : function(pageNoToGo) {
                    	var p = {};
	                        p.page = pageNoToGo;
	                        $a.page.searchList(p);
                    },
                    "cell" : {
    					"click" : function(data, eh, e) {
    						if(data._index.column != 0) {
    							var param = $("#searchTable").getData({selectOptions:true});
    			        			param["data"]      = data;
    								param["page"]      = $("#gridScrbClm").alopexGrid("pageInfo").customPaging.current;
    				            	param["page_size"] = $("#gridScrbClm").alopexGrid("pageInfo").perPage;
    			            	    $a.navigate("teamScrbClmDtl.jsp", param);
    						}
    					}
    				}
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
            var _per_page = $("#gridScrbClm").alopexGrid("pageInfo").perPage;
            
            $.alopex.request("biz.SCRBCLM@PSCRBCLM001_pSearchScrbClm", {
                data: ["#searchTable", function() {
                	this.data.dataSet.fields.FROM_DT   = $.PSNMUtils.getDateInput("FROM_DT");
                	this.data.dataSet.fields.TO_DT     = $.PSNMUtils.getDateInput("TO_DT");
                    this.data.dataSet.fields.page      = _page_no;
                    this.data.dataSet.fields.page_size = _per_page;
                }],
                success: ["#gridScrbClm", function(res) {
                }]
            });
        },
        excelPage : function(){
        	var oExcelMetaInfo = {
                    filename  : "비정상영업소명관리.xls",
                    sheetname : "비정상영업소명",
                    gridname  : "gridScrbClm" //그리드ID 
                };
            $.PSNMUtils.downloadExcelPage("gridScrbClm", oExcelMetaInfo);
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
        <span class="txt6_img"><b id="sub-title">비정상영업소명 관리</b>
            <span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif">
            <span class="a2">본사업무</span> <span class="a3"> > </span> <span class="a4"><b>비정상영업소명 관리</b></span> 
        </span>
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
                    <select id="SALE_DEPT_ORG_ID" data-bind="options:options_SALE_DEPT_ORG_ID, selectedOptions: SALE_DEPT_ORG_ID" data-type="select" style="width:150px"
                    		data-validation-rule="{required:true}"
							data-validation-message="{required:$.PSNM.msg('E012', ['영업국명'])}">
                    	<option value="">-선택-</option>
                    </select>
                </td>
				<th class="fontred">영업팀명</th>
				<td class="tleft">
                    <select id="SALE_TEAM_ORG_ID" data-bind="options:options_SALE_TEAM_ORG_ID, selectedOptions: SALE_TEAM_ORG_ID" data-type="select" style="width:150px"
                    		data-validation-rule="{required:true}"
							data-validation-message="{required:$.PSNM.msg('E012', ['영업팀명'])}">
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

    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>비정상영업소명 목록</b>
        <p class="ab_pos2">
            <button id="btnNew" type="button" data-type="button" data-theme="af-btn2" data-altname="신규" data-authtype="W"></button>
        	<button id="btnExcelPage" type="button" data-type="button" data-theme="af-btn3" data-altname="엑셀다운" data-authtype="R"></button>
        </p>
    </div>

    <!-- main grid -->
    <div id="gridScrbClm" data-bind="grid:gridScrbClm"></div>

</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>