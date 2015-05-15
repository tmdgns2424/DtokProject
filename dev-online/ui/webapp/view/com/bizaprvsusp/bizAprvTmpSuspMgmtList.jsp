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
        },
        setEventListener : function() {
            $("#btnSearch").click($a.page.searchList);
            $("#btnSave").click(function(){
            	
            	$("#grid").alopexGrid("endEdit");
            	
            	var grid = $('#grid').alopexGrid('dataGet', {_state:{edited:true}});
            	if(grid.length == 0){
            		$.PSNM.alert("E011", ["변경된"]);
					return;
            	}
            	
            	if ( ! $.PSNM.isValid("#grid") ) {
				    return false; //값 검증
				}
            	
            	if( $.PSNM.confirm("I004", ["저장"] ) ){
            		var requestData = $.PSNMUtils.getRequestData("grid");
                	$.alopex.request("com.BIZAPRVSUSP@PBIZAPRVSUSP001_pSaveBizAprvSusp", {
                        data: requestData,
                        success: function(res) { 
                        	$a.page.searchList(_param);
                        }
                    });
            	}
            });
            $("#btnDel").click(function(){
            	var oRecord = $("#grid").alopexGrid( "dataGet" , { _state : { selected : true } } );
        		if (oRecord.length == 0) {
        			$.PSNM.alert("E021", ["삭제할 행을"]);
                    return;
                }
        		
        		$("#grid").alopexGrid( "dataEdit", {"FLAG":"D"}, { _state: { selected : true } } );
            	
            	if( $.PSNM.confirm("I004", ["삭제"] ) ){
            		var requestData = $.PSNMUtils.getRequestData("grid");
                	$.alopex.request("com.BIZAPRVSUSP@PBIZAPRVSUSP001_pDeleteBizAprvSusp", {
                		data: requestData,
                        success : function(res) {
                        	$a.page.searchList(_param);
                        }
                    });
            	}
            });
            $("#btnNew").click(function(){
            	
            	if ( ! $.PSNM.isValid("#searchTable") ) {
    			    return false; //값 검증
    			}
            	
				var nGrid = $("#grid").alopexGrid("dataGet", { _state: { editing : true } });
            	
            	if(nGrid.length != 0){
            		$.PSNM.alert("추가항목 입력 완료후 추가해 주십시오.");
    				return;
            	}
            	
            	$("#grid").alopexGrid("dataAdd", {
                    "FLAG"        	  : "I",
                    "DSM_HEADQ_CD" 	  : "",
                    "BIZ_APRV_TPY_CD" : "",
                    "SUSP_STA_DT" 	  : "",
                   	"SUSP_END_DT"     : "",
                    "SUSP_RSN_CTT"    : "",
                }, {_index : { data : 0 }});
            	
            	$("#grid").alopexGrid("startEdit" , { _state : { added : true } } );
            });
        },
        setGrid : function() {
            $("#grid").alopexGrid({
                pager: false,
                rowClickSelect : false,
                rowInlineEdit : true,
                height : "500px",
                columnMapping : [
					{ columnIndex : 0, selectorColumn : true, 			width : "30px" },
					{ columnIndex : 1, key : "FLAG", 					hidden : true
						, value : function(value, data) {
                            if ( "I" == value || "D" == value ) { return value; } //추가|삭제는 그냥둠
                            return ( (data._state.edited) ? 'U' : '' ); 
                        }
					},
					{ columnIndex : 2, key : "BIZ_APRV_SUSP_HST_SEQ",	hidden : true  },
                    { columnIndex : 3, key : "DSM_HEADQ_CD",			title : "영업국",		align : "center", 	width : "100px"
						, render : {
            				type : "string"
           					, rule : function(value, data) {
              						
   								var select = [];
              						
								$("#SALE_DEPT_ORG_ID").find("option").each(function() {
									select.push({"text":$(this).text(),"value":$(this).val()});
              					});
              						
   								return select;
   							}
            			}
                    	, editable : {
            				type : "select"
           					, rule : function(value, data) {
           						
								var select = [];
              						
          						$("#SALE_DEPT_ORG_ID").find("option").each(function() {
          							select.push({"text":$(this).text(),"value":$(this).val()});
          					   	});
              						
   								return select;
							}
            			}
                    	, allowEdit : function ( value , data, mapping ){
	                    	if(data._state.added){
	                    		return true;
	                    	}
	                    	return false;
	                    }
                    	, validate : {
	                    	rule : {required:true}
	                    	,message : {required : $.PSNM.msg('E012', ['영업국'])}
	                    }
                    },
                    { columnIndex : 4, key : "BIZ_APRV_TPY_CD",			title : "업무유형",		align : "center", 	width : "100px"
                    	, render : {
            				type : "string"
           					, rule : function() {
								var oParam = { t:'code', 'codeid' : 'DSM_BIZ_APRV_TPY_CD', 'header' : ' ' };	
								return $.PSNMUtils.getCode(oParam);
                            }
            			}
                    	, editable : {
            				type : "select"
           					, rule : function() {
								var oParam = { t:'code', 'codeid' : 'DSM_BIZ_APRV_TPY_CD', 'header' : ' ' };	
								return $.PSNMUtils.getCode(oParam);
                            }
            			}
                    	, validate : {
	                    	rule : {required:true}
	                    	,message : {required : $.PSNM.msg('E012', ['업무유형'])}
	                    }
                    },
                    { columnIndex : 5, key : "SUSP_STA_DT",				title : "제한시작일자",	align : "center", 	width : "80px"
                    	, editable : function(value, data) {
                    		
                    		var str = '<input id="SUSP_STA_DT" value="'+value+'" data-type="dateinput" style="width:80px;" data-image="${pageContext.request.contextPath}/image/ico_calendar.png"/>';
        					
                    		return str;
        				}	
                    	, editedValue : function(cell) {
        					return $(cell).find('#SUSP_STA_DT').val();
        				}
                    	, validate : {
	                    	rule : {required:true}
	                    	,message : {required : $.PSNM.msg('E012', ['제한시작일자'])}
	                    	,onchange : function (valid, errorMessage, cell, value){
	                    		var staDt = $.PSNMUtils.getDateInput("SUSP_STA_DT");
	                    		var endDt = $.PSNMUtils.getDateInput("SUSP_END_DT");
	                    		
	                    		if("" != staDt && "" != endDt){
	                    			if(staDt > endDt){
	                    				$.PSNM.alert("제한시작일자를 다시 입력해 주십시오.");
		                    			$(cell).find('#SUSP_STA_DT').val("");
		                    			return;
		                    		}
	                    		}
	                    	}
	                    }
                    },
                    { columnIndex : 6, key : "SUSP_END_DT",				title : "제한종료일자",	align : "center", 	width : "80px"
						, editable : function(value, data) {
                    		
                    		var str = '<input id="SUSP_END_DT" value="'+value+'" data-type="dateinput" style="width:80px;" data-image="${pageContext.request.contextPath}/image/ico_calendar.png"/>';
        					
                    		return str;
        				}	
                    	, editedValue : function(cell) {
        					return $(cell).find('#SUSP_END_DT').val();
        				}
                    	, validate : {
	                    	rule : {required:true}
	                    	,message : {required : $.PSNM.msg('E012', ['제한종료일자'])}
	                    	,onchange : function (valid, errorMessage, cell, value){
	                    		var staDt = $.PSNMUtils.getDateInput("SUSP_STA_DT");
	                    		var endDt = $.PSNMUtils.getDateInput("SUSP_END_DT");
	                    		
	                    		if("" != staDt && "" != endDt){
	                    			if(staDt > endDt){
	                    				$.PSNM.alert("제한종료일자를 다시 입력해 주십시오.");
		                    			$(cell).find('#SUSP_END_DT').val("");
		                    			return;
		                    		}
	                    		}
	                    	}
	                    }
                    },
                    { columnIndex : 7, key : "SUSP_RSN_CTT",			title : "제한사유",		align : "left", 	width : "200px", editable: true	}
            	]
            });
        },
        searchList: function(param) {
    		if ( ! $.PSNM.isValid("#searchForm") ) {
			    return false; //값 검증
			}
        	
            $.alopex.request("com.BIZAPRVSUSP@PBIZAPRVSUSP001_pSearchBizAprvSusp", {
            	 data: ["#searchTable", function() {
                 	this.data.dataSet.fields.FROM_DT   = $.PSNMUtils.getDateInput("FROM_DT");
                 	this.data.dataSet.fields.TO_DT     = $.PSNMUtils.getDateInput("TO_DT");
                 }],
                success: "#grid"
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
            <span class="txt6_img"><b id="sub-title">업무승인일시정지관리</b>
                <span class="notice-more"> 
                	<img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif">
                	<span class="a2">본사업무</span> <span class="a3"> > </span> <span class="a4"><b>공통관리</b></span> 
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
            <col style="width:30%"/>
            <col style="width:10%"/>
            <col style="width:20%"/>
            <col style="width:10%"/>
            <col style="width:*"/>
        </colgroup>
       	<tbody>
       		<tr>
                <th scope="col" class="fontred">조회기간</th>
                <td class="tleft">
                	<div data-type="daterange" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png" >
                		<input id="FROM_DT" name="FROM_DT" data-role="startdate" data-bind="value:FROM_DT" style="width:70px;"/>
						~ <input id="TO_DT" name="TO_DT" data-role="enddate" data-bind="value:TO_DT" style="width:70px;"/>
                	</div>
				</td>
            	<th scope="col" class="fontred">본사팀</th>
				<td class="tleft">
                    <select id="HDQT_TEAM_ORG_ID" data-bind="options:options_HDQT_TEAM_ORG_ID, selectedOptions: HDQT_TEAM_ORG_ID" data-type="select"
                    	data-validation-rule="{required:true}"
						data-validation-message="{required:$.PSNM.msg('E012', ['본사팀'])}">
                    	<option value="">-전체-</option>
                    </select>
                </td>
                <th scope="col" class="fontred">본사파트</th>
				<td class="tleft">
                    <select id="HDQT_PART_ORG_ID" data-bind="options:options_HDQT_PART_ORG_ID, selectedOptions: HDQT_PART_ORG_ID" data-type="select" 
                    	data-validation-rule="{required:true}"
						data-validation-message="{required:$.PSNM.msg('E012', ['본사파트'])}">
                    	<option value="">-전체-</option>
                    </select>
                </td>
            </tr>
            <tr>
                <th scope="col">영업국명</th>
				<td class="tleft" colspan="5">
                    <select id="SALE_DEPT_ORG_ID" data-bind="options:options_SALE_DEPT_ORG_ID, selectedOptions: SALE_DEPT_ORG_ID" data-type="select" onchange-enable="false">
                    	<option value="">-선택-</option>
                    </select>
                </td>
            </tr>
       	</tbody>
        </table>
		<div class="ab_pos5">
			<button id="btnSearch" type="button" data-type="button" data-theme="af-psnm" data-authtype="R"></button>
		</div>
		</form>
    </div>
    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>업무승인일시정지관리</b>
        <div class="ab_pos2">
        	<button id="btnNew" type="button" data-type="button" data-theme="af-btn2" data-altname="신규" data-authtype="W"></button>
	        <button id="btnDel"  type="button" data-type="button" data-theme="af-btn13" data-altname="삭제" data-authtype="W"></button>
        	<button id="btnSave" type="button" data-type="button" data-theme="af-btn4" data-altname="저장" data-authtype="W"></button>
        </div>
    </div>

    <!-- main grid -->
    <div id="grid" data-bind="grid:grid"></div>

</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>