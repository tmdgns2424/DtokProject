<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

    <jsp:include page="/view/layouts/default_head.jsp" flush="false" />
    <style>
	tr.row-style td {
		background-color : #d3e0f0!important;
	}
	</style>             
    <script type="text/javascript">
    $.alopex.page({

        init : function(id, param) { 
            $.PSNM.initialize(id, param); //PSNM공통 초기화함수 호출

            $a.page.setEventListener();
            $a.page.setGrid();
            $a.page.setCodeData();
            $a.page.setValidators();
            if(param.Search_DT==null){
            	var today = new Date();
                var Day = today.getFullYear()+"-"+((today.getMonth()+1)<10?"0"+(today.getMonth()+1):(today.getMonth()+1)); //현재 년/월
           		$("#Search_DT").val(Day);
           }
            $("#searchTable").setData(param);  //(설명) 상세페이지에서 돌아오는 경우, 이 값들이 세션스토리지에서 반환됨.
        },
        setEventListener : function() {
        	$("#btnSearch").click( searchList );
        	$("#btnExcelPage").click( excelPage );
            $("#AGNT_NM").keyup( $.PSNMAction.findAgent );
        },
        setGrid : function() {
            $("#gridMain").alopexGrid({
                rowClickSelect : false,
                rowInlineEdit : false,
                pager : false,
                height : "610px",
                headerGroup : [
                  				 { fromIndex:2,	 toIndex:10, 	title: "개통상품"	}
                ], 
                
                columnMapping : [
                                 { columnIndex : 0,  key  : "WEEK_DT", 		   				title : "주간차수",		align : "center", 	width : "70px", rowspan : true },
                                 { columnIndex : 1,  key  : "SALE_DT",  					title : "매출일자",		align : "center", 	width : "70px" },
                                 { columnIndex : 2,  key  : "QTY_TOT",    					title : "합계",			align : "center", 	width : "70px",		render:{type : "string", rule:"comma"} },
                                 { columnIndex : 3,  key  : "QTY_NEW", 						title : "010신규",		align : "center", 	width : "70px",		render:{type : "string", rule:"comma"} },
                                 { columnIndex : 4,  key  : "QTY_KMNP", 					title : "KMNP",			align : "center", 	width : "70px",		render:{type : "string", rule:"comma"} },
                                 { columnIndex : 5,  key  : "QTY_LMNP", 					title : "LMNP",			align : "center", 	width : "70px",		render:{type : "string", rule:"comma"} },
                                 { columnIndex : 6,  key  : "QTY_EMNP", 					title : "기타 MNP",		align : "center", 	width : "70px",		render:{type : "string", rule:"comma"} },
                                 { columnIndex : 7,  key  : "QTY_EQP_CHG", 					title : "기변",			align : "center", 	width : "70px",		render:{type : "string", rule:"comma"} },
                                 { columnIndex : 8,  key  : "QTY_ETC", 						title : "기타",			align : "center", 	width : "70px",		render:{type : "string", rule:"comma"} },
                                 { columnIndex : 9,  key  : "QTY_USIM", 					title : "USIM",			align : "center", 	width : "70px",		render:{type : "string", rule:"comma"} },
                                 { columnIndex : 10, key  : "QTY_SMART", 					title : "스마트Device",	align : "center", 	width : "70px",		render:{type : "string", rule:"comma"} },
                                 { columnIndex : 11, key  : "QTY_NEQP", 					title : "공기계",			align : "center", 	width : "70px",		render:{type : "string", rule:"comma"} }
                             ]
                /* footer : {
		        			position : "top",
		        			footerMapping : [
		        				{columnIndex:2, 	render:"sum(QTY_TOT)", 			align:"center"	},
		        				{columnIndex:3, 	render:"sum(QTY_NEW)", 			align:"center"	}, 
		        				{columnIndex:4, 	render:"sum(QTY_KMNP)", 		align:"center" 	}, 
		        				{columnIndex:5, 	render:"sum(QTY_LMNP)", 		align:"center" 	}, 
		        				{columnIndex:6, 	render:"sum(QTY_EMNP)", 		align:"center" 	},
		        				{columnIndex:7, 	render:"sum(QTY_EQP_CHG)", 		align:"center"	},
		        				{columnIndex:8, 	render:"sum(QTY_ETC)", 			align:"center"	},
		        				{columnIndex:9, 	render:"sum(QTY_USIM)", 		align:"center"	},
		        				{columnIndex:10,	render:"sum(QTY_SMART)", 		align:"center"	},
		        				{columnIndex:11, 	render:"sum(QTY_NEQP)", 		align:"center"	}
		        		
        				
        			]
        		}  */ 
        		,rowOption : {
					styleclass : function(data, rowOption) {
                        if(data["WEEK_DT"] == ""){
                            return "row-style";
                        }
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
   
        $.alopex.request("biz.SALEPRST@PSALEPRST001_pSearchDayRsltPrst", {
            data: ["#searchTable", function() {
                this.data.dataSet.fields.APLY_MTH      =  $.PSNMUtils.getDateInput("Search_DT");
            }],
            success: ["#gridMain", function(res) {
            	
            }]
         });
    } //end of searchList()

    function excelPage() {
        var oExcelMetaInfo = {
                filename  : "일별실적현황.xls",
                sheetname : "일별실적현황",
                gridname  : "gridMain" //그리드ID 
            };
        $.PSNMUtils.downloadExcelPage("gridMain", oExcelMetaInfo);
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
            <span class="txt6_img"><b id="sub-title">일별 실적현황</b>
                <span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif">
                <span class="a2">영업국업무</span> <span class="a3"> > </span> <span class="a4"><b>영업현황</b></span> 
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
            	<th class="fontred">조회월</th>
				<td class="tleft">
					<input id="Search_DT" name="Search_DT" data-type="dateinput" data-pickertype="monthly" data-bind="value:Search_DT" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png" style="width:60px;"
						   data-validation-rule="{required:true}"
						   data-validation-message="{required:$.PSNM.msg('E012', ['조회월'])}"/>
				</td>
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
            </tr>
            <tr>
            	<th class="fontred">영업국명</th>
				<td class="tleft">
                    <select id="SALE_DEPT_ORG_ID" name="SALE_DEPT_ORG_ID" data-bind="options:options_SALE_DEPT_ORG_ID, selectedOptions: SALE_DEPT_ORG_ID" data-type="select" data-wrap="false"
							data-validation-rule="{required:true}"
							data-validation-message="{required:$.PSNM.msg('E012', ['영업국명'])}">
                    	<option value="">-선택-</option>
                    </select>
                </td>
				<th>영업팀명</th>
				<td class="tleft">
                    <select id="SALE_TEAM_ORG_ID" name="SALE_TEAM_ORG_ID" data-bind="options:options_SALE_TEAM_ORG_ID, selectedOptions: SALE_TEAM_ORG_ID" data-type="select" data-wrap="false">
                    	<option value="">-선택-</option>
                    </select>
                </td>
                <th>에이전트명</th>
				<td class="tleft" colspan="3">
                    <input id="AGNT_NM" name="AGNT_NM" data-bind="value:AGNT_NM" data-type="textinput" data-agentid="AGNT_ID" style="width:70px;" maxlength="10" />
                    <input id="AGNT_ID" name="AGNT_ID" data-bind="value:AGNT_ID" data-type="textinput" data-disabled="true" style="width:70px;" />
                </td>
            </tr>
            <tr>
            	<th>상품코드</th>
            	<td class="tleft" colspan="5">
            		<input id="PROD_CD" name="PROD_CD" data-bind="value:PROD_CD" data-type="textinput" />
            	</td>
            </tr>
            </table>
			<div class="ab_pos5">
				<button id="btnSearch" type="button" data-type="button" data-theme="af-psnm"></button>
			</div>
        </form>
    </div>

    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>일별 실적현황</b>
        <p class="ab_pos2">
        	<button id="btnExcelPage" type="button" data-type="button" data-theme="af-btn3" data-altname="엑셀다운"></button>
        </p>
    </div>

    <!-- main grid -->
    <div id="gridMain" data-bind="grid:gridMain"></div>

</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>