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
            
            $a.page.setEventListener();
            $a.page.setGrid1();
            $a.page.setGrid2();
			$a.page.searchList(param);
        },
        setEventListener : function() {
            $("#btnSearch").click($a.page.searchList);
			$("#btnSave").click(function(){
				
				var oRecord = $("#grid1").alopexGrid( "dataGet" , { _state : { selected : true } } );
            	if(oRecord.length == 0){
            		$.PSNM.alert("E021", ["영업국"]);
            		return;
            	}
            	
            	$("#grid2").alopexGrid("endEdit");
            	
            	var edited = $('#grid2').alopexGrid('dataGet', {_state:{edited:true}});
            	if(edited.length == 0){
            		$.PSNM.alert("E011", ["변경된"]);
					return;
            	}
				
				var oRecord = $("#grid2").alopexGrid( "dataGet" );
				for(var i = 0, length = oRecord.length; i < length; i++) { 
					if(oRecord[i].USER_ID == "") {
						$.PSNM.alert("E012", ["회원ID"]);
						return;
					}
					if(oRecord[i].SMS_YN == "") {
						$.PSNM.alert("E012", ["SMS수신여부"]);
						return;
					}
					if(oRecord[i].DSM_CHRGR_ROLE_CL_CD == "") {
						$.PSNM.alert("E012", ["역할"]);
						return;
					}				
				}
				
               	if(  $.PSNM.confirm("I004", ["저장"] ) ){
               		
               		var grid1Data = $("#grid1").alopexGrid( "dataGet" , { _state : { selected : true } } );
    				var requestData = $.PSNMUtils.getRequestData("grid2");
    				requestData.dataSet.fields.DSM_HEADQ_CD = grid1Data[0].SALE_DEPT_ORG_ID;
    				_param["DSM_HEADQ_CD"] = grid1Data[0].SALE_DEPT_ORG_ID;
               		
                   	$.alopex.request("biz.HEADCHRGR@PCHRGRHEADQ001_pSaveChrgrHeadq", {
	                    data: requestData,
	                    success: function(res) {
	                    	$a.page.searchList(_param);
	                    }
                	});
           		}
            });
            $("#btnGridAdd").click(function(){
            	
            	var oRecord = $("#grid1").alopexGrid( "dataGet" , { _state : { selected : true } } );
            	if(oRecord.length == 0){
            		$.PSNM.alert("E021", ["영업국"]);
            		return;
            	}
            	
            	var oParam = {"SALE_DEPT_ORG_ID" : oRecord[0].SALE_DEPT_ORG_ID};
            	$a.popup({
                	url: "biz/headchrgr/headqChrgrPop",
                    data: oParam,
    				title : "회원정보찾기",
    				width: 900,
    				height: 600,
                    callback : function(oResult) {
                    	if ( oResult != null && typeof oResult == "object" ) {
                        	var curResult = $("#grid2").alopexGrid("dataGet");
                        	//회원중복체크
            				for(var i=0 ; i<oResult.length ; i++) {
            					var flag = false;
            					for(var j=0 ; j<curResult.length ; j++) {
            						if(oResult[i].USER_ID == curResult[j].USER_ID){
            							flag = true;
            							break;
            						}	
            					}	
            					if(flag == false){
            						$("#grid2").alopexGrid("dataAdd", oResult[i], {_index : { data : 0 }});
            						$("#grid2").alopexGrid("dataEdit", {"FLAG":"I"}, {_index : { data : 0 }});
            						
            						$("#grid2").alopexGrid("startEdit");
                                    $("#grid2").alopexGrid("endEdit");
            					}						
            				}
                        }
                    }
                });
            });
            $("#btnGridDel").click(function(){
            	var oRecord = $("#grid2").alopexGrid( "dataGet" , { _state : { selected : true } } );
            	if(oRecord.length == 0){
            		$.PSNM.alert("E021", ["삭제할 행을"]);
            		return;
            	}
            	
            	$("#grid2").alopexGrid( "dataEdit", {"FLAG":"D"}, { _state: { selected : true } } );
            	
            	var grid1Data = $("#grid1").alopexGrid( "dataGet" , { _state : { selected : true } } );
				var requestData = $.PSNMUtils.getRequestData("grid2");
				requestData.dataSet.fields.DSM_HEADQ_CD = grid1Data[0].SALE_DEPT_ORG_ID;
				_param["DSM_HEADQ_CD"] = grid1Data[0].SALE_DEPT_ORG_ID;
               	
               	if(  $.PSNM.confirm("I004", ["삭제"] ) ){
                   	$.alopex.request("biz.HEADCHRGR@PCHRGRHEADQ001_pSaveChrgrHeadq", {
	                    data: requestData,
	                    success: function(res) { 
	                    	$a.page.searchList(_param);
	                    }
                	});
           		}
            });
        },
        setGrid1 : function() {
            $("#grid1").alopexGrid({
            	pager : false,
            	rowSingleSelect : true,
                height : "400px",
                columnMapping : [
                    { columnIndex : 0, key : "SALE_DEPT_ORG_ID",    title : "영업국코드",	align : "center", 	width : "60px" },
                    { columnIndex : 1, key : "SALE_DEPT_ORG_NM",  	title : "영업국명",	align : "center", 	width : "60px" }
                ],
                on : {
                    "cell" : {
    					"click" : function(data, eh, e) {
    						if(data._index.column != 0) {
    							if(data._state.selected){
    								$.alopex.request("biz.HEADCHRGR@PCHRGRHEADQ001_pSearchChrgrHeadqUser", {
        								data: {dataSet: {fields: {DSM_HEADQ_CD : data.SALE_DEPT_ORG_ID}}},
        				                success: "#grid2"
        				            });
    							}else{
    								$.alopex.request("biz.HEADCHRGR@PCHRGRHEADQ001_pSearchChrgrHeadqUser", {
        								data: {dataSet: {fields: {DSM_HEADQ_CD : ''}}},
        				                success: "#grid2"
        				            });
    							}
    						}
    					}
    				}
                }
            });
        },
        setGrid2 : function() {
            $("#grid2").alopexGrid({
            	pager : false,
            	rowInlineEdit  : true,
                height : "400px",
                columnMapping : [
					{ columnIndex : 0, selectorColumn : true, 		width : "30px" },
                    { columnIndex : 1, key : "DSM_CHRGR_ROLE_CL_CD",title : "역할",		align : "center", 	width : "80px"
                    	, render : {
            				type : "string"
           					, rule : function() {
									var oParam = { t:'code', 'codeid' : 'DSM_CHRGR_ROLE_CL_CD', 'header' : ' ' };	
									return $.PSNMUtils.getCode(oParam);
                            }
            			}
                    	, editable : {
            				type : "select"
           					, rule : function() {
									var oParam = { t:'code', 'codeid' : 'DSM_CHRGR_ROLE_CL_CD', 'header' : ' ' };	
									return $.PSNMUtils.getCode(oParam);
                            }
            			}
                    },
					{ columnIndex : 2, key : "FLAG", 				hidden : true
						, value : function(value, data) {
                            if ( "I" == value || "D" == value ) { return value; } //추가|삭제는 그냥둠
                            return ( (data._state.edited) ? 'U' : '' ); 
                        }
					},
                    { columnIndex : 3, key : "USER_ID",    			title : "회원ID",		align : "center", 	width : "80px" },
                    { columnIndex : 4, key : "USER_NM",  			title : "회원명",		align : "center", 	width : "80px" },
                    { columnIndex : 5, key : "SMS_YN",  			title : "SMS수신여부<br/>※ 업무승인적용",	align : "center", 	width : "80px" 
                    	, editable : {
            				type : "select"
           					, rule : function() {
									var oParam = { t:'code', 'codeid' : 'DSM_YN_CD' };	
									return $.PSNMUtils.getCode(oParam);
                            }
            			}	
                   	},
                    { columnIndex : 6, key : "DUTY_NM",  			title : "직무",			align : "left", 	width : "130px"},
                    { columnIndex : 7, key : "JOB_DESC",  			title : "담당업무",		align : "left", 	width : "130px"}
                ]
            });
        },
        searchList: function(param) {
            $.alopex.request("biz.HEADCHRGR@PCHRGRHEADQ001_pSearchChrgrHeadq", {
            	data : ["#searchForm", function(){
    				this.data.dataSet.fields.DSM_HEADQ_CD = param.DSM_HEADQ_CD;
				}],
	            success : function(res) {
	            	
	            	var gridList = res.dataSet.recordSets;
					
	                $.each(gridList, function(key, data) {
	                	$("#"+key).alopexGrid("dataSet", data.nc_list);
	                });
	                
	                var oRecord = $("#grid1").alopexGrid( "dataGet" );
	                for(var i=0 ; i<oRecord.length ; i++) {
	                	if(oRecord[i].SALE_DEPT_ORG_ID == param.DSM_HEADQ_CD){
	                		$("#grid1").alopexGrid("dataEdit", {_state:{selected:true}}, {_index:{data:i}});
	                	}
	                }
	            }
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
            <span class="txt6_img"><b id="sub-title">영업국별 담당자 관리</b>
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
        	<table id="searchTable" class="board02" style="width:85%;">
        	<colgroup>
	            <col style="width:15%"/>
	            <col style="width:20%"/>
	            <col style="width:15%"/>
	            <col style="width:*"/>
            </colgroup>
        	<tbody>
        	<tr>
                <th scope="col">본사팀</th>
				<td class="tleft">
                    <select id="HDQT_TEAM_ORG_ID" data-bind="options:options_HDQT_TEAM_ORG_ID, selectedOptions: HDQT_TEAM_ORG_ID" data-type="select" >
                    	<option value="">-전체-</option>
                    </select>
                </td>
                <th scope="col">본사파트</th>
				<td class="tleft">
                    <select id="HDQT_PART_ORG_ID" data-bind="options:options_HDQT_PART_ORG_ID, selectedOptions: HDQT_PART_ORG_ID" data-type="select" >
                    	<option value="">-전체-</option>
                    </select>
                </td>
            </tr>
        	</tbody>
            </table>
        </form>
		<div class="ab_pos5">
			<button id="btnSearch" type="button" data-type="button" data-theme="af-psnm" data-authtype="R"></button>
			<button id="btnSave" type="button" data-type="button" data-theme="af-btn4" data-authtype="W"></button>
		</div>
    </div>

    <!-- main grid -->
    <div class="psnm-section">
		<div class="psnm-secleft" style="width:30%">
			<div class="psnm-secleft-head">
                <span class="psnm-section-title"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif">영업국목록</span>
                <span class="psnm-section-buttons"></span>
            </div>
			<div id="grid1" data-bind="grid:grid1"></div>
		</div>
		<div class="psnm-secright" style="width:66%">
			<div class="psnm-secleft-head">
                <span class="psnm-section-title"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif">영업국별 담당자 현황</span>
                <span class="psnm-section-buttons">
                	<span class="ab_pos3">
		                 <input id="btnGridAdd" type="button" data-type="button" class="addButton" data-authtype="R"/>
		                 <input id="btnGridDel" type="button" data-type="button" class="inputButton" data-authtype="R"/>
			        </span>
                </span>
            </div>
			<div id="grid2" data-bind="grid:grid2"></div>
		</div>
	</div>

</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>