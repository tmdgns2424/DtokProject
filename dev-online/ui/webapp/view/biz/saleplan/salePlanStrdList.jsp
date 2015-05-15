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
            
            $("#SALES_YM").val(getCurrdate().substr(0,7));
            $a.page.setEventListener();
            $a.page.setGridProd();
            $a.page.setGridCtt();
			$a.page.searchList(param);
        },
        setEventListener : function() {
            $("#btnSearch").click($a.page.searchList);
			$("#btnSave").click(function(){
				
				$("#gridprod").alopexGrid("endEdit");
				$("#gridctt").alopexGrid("endEdit");
				
				var gridprod = $('#gridprod').alopexGrid('dataGet', {_state:{edited:true}});
				var gridctt = $('#gridctt').alopexGrid('dataGet', {_state:{edited:true}});
            	if(gridprod.length == 0 && gridctt.length == 0){
            		$.PSNM.alert("E011", ["변경된"]);
					return;
            	}
				
				if ( ! $.PSNM.isValid("#gridprod") ) {
				    return false; //값 검증
				}
				
               	if(  $.PSNM.confirm("I004", ["저장"] ) ){
               		var requestData = $.PSNMUtils.getRequestData("gridprod", "gridctt");
                   	$.alopex.request("biz.SALEPLAN@PSALEPLANSTRD001_pSaveSalePlanStrd", {
	                    data: requestData,
	                    success: function(res) {
	                    	$a.page.searchList(_param);
	                    }
                	});
           		}
            });
			$("#btnCopy").click(function(){
				
				if ( ! $.PSNM.isValid("#gridprod") ) {
				    return false; //값 검증
				}
				
				if($.PSNMUtils.isEmpty($("#COPY_YM").val())){
           			$.PSNM.alert("기준복사년월을  입력해주세요.");
    				$("#COPY_YM").focus();
    				return;
           		}
				
				$("#gridprod").alopexGrid("endEdit");
				$("#gridctt").alopexGrid("endEdit");
				
               	if(  $.PSNM.confirm("I004", ["기준복사"] ) ){
               		var requestData = $.PSNMUtils.getRequestData("gridprod", "gridctt");
               		requestData.dataSet.fields.COPY_YM = $.PSNMUtils.getDateInput("COPY_YM");
               		
                   	$.alopex.request("biz.SALEPLAN@PSALEPLANSTRD001_pCopySalePlanStrd", {
	                    data: requestData,
	                    success: function(res) {
	                    	$a.page.searchList(_param);
	                    }
                	});
           		}
            });
            $("#btnGridAddProd").click(function(){
            	
            	var nGrid = $("#gridprod").alopexGrid("dataGet", { _state: { editing : true } });
            	
            	if(nGrid.length != 0){
            		$.PSNM.alert("추가항목 입력 완료후 추가해 주십시오.");
    				return;
            	}
            	
            	var seqLen = $("#gridprod").alopexGrid("dataGet").length + 1;
            	$("#gridprod").alopexGrid("dataAdd", {
                    "FLAG"        	: "I",
                    "SALES_YM" 		: $.PSNMUtils.getDateInput("SALES_YM"),
                    "UNIT_TYP_CD" 	: "",
                    "SORT_SEQ"    	: seqLen
                });
            	$("#gridprod").alopexGrid("startEdit", {_index : { data : seqLen-1 }});
            	
            });
            $("#btnGridDelProd").click(function(){
            	var oRecord = $("#gridprod").alopexGrid( "dataGet" , { _state : { selected : true } } );
            	if(oRecord.length == 0){
            		$.PSNM.alert("E021", ["삭제할 행을"]);
            		return;
            	}
            	
            	$("#gridprod").alopexGrid("dataEdit", {"FLAG":"D"}, { _state: { selected : true } } );
            	$("#gridprod").alopexGrid("dataDelete", {_state:{selected:true}});
            });
            $("#btnGridAddCtt").click(function(){
            	var seqLen = $("#gridctt").alopexGrid("dataGet").length + 1;
            	$("#gridctt").alopexGrid("dataAdd", {
                    "FLAG"        	: "I",
                    "SALES_YM" 		: $.PSNMUtils.getDateInput("SALES_YM"),
                    "ORG_LVL" 		: "",
                    "STRD_CL"		: "",
                    "STRT_TITLE_NM"	: "",
                    "SORT_SEQ"    	: seqLen
                });
            	$("#gridctt").alopexGrid("startEdit", {_index : { data : seqLen-1 }});
            });
            $("#btnGridDelCtt").click(function(){
            	var oRecord = $("#gridctt").alopexGrid( "dataGet" , { _state : { selected : true } } );
            	if(oRecord.length == 0){
            		$.PSNM.alert("E021", ["삭제할 행을"]);
            		return;
            	}
            	
            	$("#gridctt").alopexGrid("dataEdit", {"FLAG":"D"}, { _state: { selected : true } } );
            	$("#gridctt").alopexGrid("dataDelete", {_state:{selected:true}});
            });
        },
        setGridProd : function() {
            $("#gridprod").alopexGrid({
            	pager : false,
            	rowInlineEdit  : true,
                height : "400px",
                leaveDeleted : true,
                columnMapping : [
					{ columnIndex : 0, selectorColumn : true, 		width : "30px" 	},
					{ columnIndex : 1, key : "FLAG", 				hidden : true	
						, value : function(value, data) {
                            if ( "I" == value || "D" == value ) { return value; } //추가|삭제는 그냥둠
                            return ( (data._state.edited) ? 'U' : '' ); 
                        }	
					},
                    { columnIndex : 2, key : "SALES_YM",    title : "영업년월",	align : "center", 	width : "80px" },
                    { columnIndex : 3, key : "UNIT_TYP_CD",	title : "상품유형",	align : "center", 	width : "80px"
                    	, render : {
            				type : "string"
           					, rule : function() {
								var oParam = { t:'code', 'codeid' : 'DSM_FAX_UNIT_TYP_CD', 'header' : ' ' };	
								return $.PSNMUtils.getCode(oParam);
                            }
            			}
	                    , editable : {
	        				type : "select"
	       					, rule : function(value, data) {
       							var oParam = { t:'code', 'codeid' : 'DSM_FAX_UNIT_TYP_CD', 'header' : ' ' };	
       							var oCode = $.PSNMUtils.getCode(oParam);
       							var oGrid = $("#gridprod").alopexGrid("dataGet");
       							
       							for(var i=0; i < oGrid.length; i++){
       								for(var j=0; j < oCode.length; j++){
       									if(oGrid[i].UNIT_TYP_CD == oCode[j].value && oGrid[i].UNIT_TYP_CD != value){
       										oCode.splice(j, 1);
       									}
       								}
       							}
								return oCode;
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
	                    	,message : {required : $.PSNM.msg('E012', ['상품유형'])}
	                    }
                    },
                    { columnIndex : 4, key : "SORT_SEQ",  	title : "순서",		align : "center", 	width : "50px"
                    	, render : {
            				type : "string"
            			}
	                    , editable : {
	        				type : "select"
	       					, rule : function(value, data) {
       							var oGrid = $("#gridprod").alopexGrid("dataGet");
       							
       							var select = [];
           						for(var i=1; i < oGrid.length+1; i++){
           							select.push({"text":i,"value":i});
           						}
								return select;
	                        }
	        			}
	            	}
                ]
            });
        },
        setGridCtt : function() {
            $("#gridctt").alopexGrid({
            	pager : false,
            	rowInlineEdit  : true,
                height : "400px",
                leaveDeleted : true,
                columnMapping : [
					{ columnIndex : 0, selectorColumn : true, 		width : "20px" 	},
					{ columnIndex : 1, key : "FLAG", 				hidden : true	
						, value : function(value, data) {
                            if ( "I" == value || "D" == value ) { return value; } //추가|삭제는 그냥둠
                            return ( (data._state.edited) ? 'U' : '' ); 
                        }	
					},
                    { columnIndex : 2, key : "SALES_YM", 		title : "영업년월",	align : "center", 	width : "80px" },
                    { columnIndex : 3, key : "ORG_LVL",  		title : "구분",		align : "center", 	width : "80px" 
                    	, render : {
            				type : "string"
           					, rule : function() {
								var oParam = { t:'code', 'codeid' : 'DSM_ORG_LVL', 'header' : ' ' };	
								return $.PSNMUtils.getCode(oParam);
                            }
            			}
                    	, editable : {
            				type : "select"
           					, rule : function() {
								var oParam = { t:'code', 'codeid' : 'DSM_ORG_LVL' };	
								return $.PSNMUtils.getCode(oParam);
                            }
            			}		
                    },
                    { columnIndex : 4, key : "STRD_CL",			title : "기준구분",	align : "center", 	width : "80px" 
                    	, render : {
            				type : "string"
           					, rule : function() {
           						var select = [];
           						select.push({"text":"전월 결과분석","value":"B"});
           						select.push({"text":"당월 영업계획","value":"C"});
           						//select.push({"text":"당월영업목표","value":"P"});
                               	return select;
                            }
            			}
                    	, editable : {
            				type : "select"
           					, rule : function(value, data) {
								var select = [];
								select.push({"text":"전월 결과분석","value":"B"});
								select.push({"text":"당월 영업계획","value":"C"});
								//select.push({"text":"당월영업목표","value":"P"});
                               	return select;
							}
            			}	
                   	},
                    { columnIndex : 5, key : "STRT_TITLE_NM",	title : "기준제목",	align : "left", 	width : "150px", editable :true},
                    { columnIndex : 6, key : "SORT_SEQ", 		title : "순서",		align : "center", 	width : "50px"
                    	, render : {
            				type : "string"
            			}
	                    , editable : {
	        				type : "select"
	       					, rule : function(value, data) {
       							var oGrid = $("#gridctt").alopexGrid("dataGet");
       							
       							var select = [];
           						for(var i=1; i < oGrid.length+1; i++){
           							select.push({"text":i,"value":i});
           						}
								return select;
	                        }
	        			}
                   	}	
                ]
            });
        },
        searchList: function(param) {
            $.alopex.request("biz.SALEPLAN@PSALEPLANSTRD001_pSearchSalePlanStrd", {
            	data : ["#searchForm", function(){
            		this.data.dataSet.fields.SALES_YM   = $.PSNMUtils.getDateInput("SALES_YM");
				}],
	            success : function(res) {
	            	
	            	var gridList = res.dataSet.recordSets;
					
	                $.each(gridList, function(key, data) {
	                	$("#"+key).alopexGrid("dataSet", data.nc_list);
	                });
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
            <span class="txt6_img"><b id="sub-title">영업계획기준관리</b>
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
	            <col style="width:*"/>
            </colgroup>
        	<tbody>
        	<tr>
                <th scope="col">영업년월</th>
				<td class="tleft">
                    <input id="SALES_YM" name="SALES_YM" data-type="dateinput" data-pickertype="monthly" data-bind="value:SALES_YM" style="width:80px;" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png"/>
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
    
    <div class="floatL4">
    	<button id="btnCopy" type="button" data-type="button" data-theme="af-btn95" data-authtype="W"></button>
    	<input id="COPY_YM" name="COPY_YM" data-type="dateinput" data-pickertype="monthly" style="width:80px;" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png"/>
    </div>

    <!-- main grid -->
    <div class="psnm-section">
        <div class="psnm-secleft" style="width:30%;">
            <div class="floatL4" style="clear:both;"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>상품유형</b>
		        <p class="ab_pos1">
		            <input id="btnGridAddProd" type="button" data-type="button" class="psnm-sbtn-add" />
                    <input id="btnGridDelProd" type="button" data-type="button" class="psnm-sbtn-del" />
		        </p>
		    </div>
            <!-- 왼쪽 그리드1 -->
            <div id="gridprod" data-bind="grid:gridprod"></div>
        </div>
        <div class="psnm-secright" style="width:65%;">
        	<div class="floatL4" style="clear:both;"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>기준제목</b>
		        <p class="ab_pos1">
		            <input id="btnGridAddCtt" type="button" data-type="button" class="psnm-sbtn-add" />
                    <input id="btnGridDelCtt" type="button" data-type="button" class="psnm-sbtn-del" />
		        </p>
		    </div>
            <!-- 오른쪽 그리드1 -->
            <div id="gridctt" data-bind="grid:gridctt"></div>
        </div>
    </div>

</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>