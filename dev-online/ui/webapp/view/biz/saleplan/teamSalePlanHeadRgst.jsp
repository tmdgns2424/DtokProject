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
    var _planDt = false;
    var _cnslDt = false;
    
    $.alopex.page({

        init : function(id, param) { 
            $.PSNM.initialize(id, param); //PSNM공통 초기화함수 호출
            
            _param = param; //이 페이지로 전달된 파라미터를 저장
            
         	// 계획수량기간
            $.alopex.request("biz.SALEPLAN@PMTHSALESPLAN001_pSearchSalePlanCnslDlDt", {
        		data: {dataSet: {fields: {AGENT_CNSL_PLN_NUM1 : '13', AGENT_CNSL_PLN_NUM2 : '14'}}},
                success : function(res) {
                    
                	var curDay = getCurrdate().split('-');
                    var CNSL_DL_DT_FROM = res.dataSet.fields.CNSL_DL_DT_FROM;
                    var CNSL_DL_DT_TO = res.dataSet.fields.CNSL_DL_DT_TO;
            		
    				if(CNSL_DL_DT_FROM <= parseInt(curDay[2]) && CNSL_DL_DT_TO >= parseInt(curDay[2]) ){
    					_planDt = true;
    				}
                    
                }
            });
            
          	//실행목표기간
        	$.alopex.request("biz.SALEPLAN@PMTHSALESPLAN001_pSearchSalePlanCnslDlDt", {
        		data: {dataSet: {fields: {AGENT_CNSL_PLN_NUM1 : '15', AGENT_CNSL_PLN_NUM2 : '16'}}},
                success : function(res) {
                    
                    var curDay = getCurrdate().split('-');
                    var CNSL_DL_DT_FROM = res.dataSet.fields.CNSL_DL_DT_FROM;
                    var CNSL_DL_DT_TO = res.dataSet.fields.CNSL_DL_DT_TO;
            		
    				if(CNSL_DL_DT_FROM <= parseInt(curDay[2]) && CNSL_DL_DT_TO >= parseInt(curDay[2]) ){
    					_cnslDt = true;
    				}
                }
            });
            
            $a.page.setGridTrgt();
            $a.page.setGridTrgtQty();
            $a.page.setGridTeam();
            $a.page.setViewData();
            $a.page.setEventListener();
            $a.page.setGridExcel();
        },
        setEventListener : function() {
			$("#btnSave").click(function(){
				$("#gridtrgt").alopexGrid("endEdit");
				$("#gridteam").alopexGrid("endEdit");
				
				if ( ! $.PSNM.isValid("#form1") ) {
				    return false; //값 검증
				}
            	
				var rowCountB = $("#cttListB tr").length;
				for(i=0; i<rowCountB; i++){
					if ( ! $.PSNM.isValidInput("#SALES_PLAN_CTT_B"+i) ) {
					    return false; //값 검증
					}
				}
				
				var rowCountC = $("#cttListC tr").length;
				for(i=0; i<rowCountC; i++){
					if ( ! $.PSNM.isValidInput("#SALES_PLAN_CTT_C"+i) ) {
					    return false; //값 검증
					}
				}
				
				var result = true;
				if(_cnslDt){
					var gridtrgtqty = $("#gridtrgtqty").alopexGrid("dataGet");
	                $.each(gridtrgtqty, function(idx, val) {
	                	if(parseInt(val.EXEC_TRGT_QTY_DSM) > parseInt(val.EXEC_TRGT_QTY)){
	                		$.PSNM.alert("상품별 실행목표 수량은 사무국 실행목표수량 이상이어야 합니다.");
	                		result = false;
	                		return false;
	                	}
	                });
				}
               	
                if(result){
                	if(  $.PSNM.confirm("I004", ["저장"] ) ){
                   		var requestData = $.PSNMUtils.getRequestData2("form1", "form2", "form3", "form4", "form5", "gridtrgt", "gridtrgtqty", "gridteam");
                       	$.alopex.request("biz.SALEPLAN@PMTHSALESPLAN001_pSaveMthDsmTrgtTeam", {
                       		data: requestData,
    	                    success: function(res) { 
    	                    	if("1" == _param.LVL){
    	        					$a.navigate("headSalePlanList.jsp", _param);
    	        				} else {
    	        					$a.navigate("teamSalePlanList.jsp", _param);
    	        				}
    	                    }
                    	});
               		}
                }
            });
			$("#btnList").click(function(){
				if("1" == _param.LVL){
					$a.navigate("headSalePlanList.jsp", _param);
				} else {
					$a.navigate("teamSalePlanList.jsp", _param);
				}
            });
            $("#btnCancel").click(function(){
            	$a.back(_param);
            });
			$("#SALE_TEAM_ORG_ID").change(function(){
            	
            	if($.PSNMUtils.isEmpty($(this).val())){
            		return;
            	}
            	$.alopex.request("biz.SALEPLAN@PMTHSALESPLAN001_pSearchMthExecTrgtTeam", {
            		data: {dataSet: {fields: {SALES_YM : $.PSNMUtils.getDateInput("SALES_YM")
            								, SALE_DEPT_ORG_ID : $("#SALE_DEPT_ORG_ID").val()
            								, SALE_TEAM_ORG_ID : $(this).val()
            								, HEADQ_YN : "N"
            								, ORG_LVL : "2"}}},
                    success:["#form5", function(res) {
                    	var gridList = res.dataSet.recordSets;
                    	
                        $.each(gridList, function(key, data) {
                        	$("#"+key).alopexGrid("dataSet", data.nc_list);
                        	if("gridcttb" == key) $("#cttListB").setData({gridcttb: data.nc_list});
                        	if("gridcttc" == key) $("#cttListC").setData({gridcttc: data.nc_list});
                        	if("gridcttp" == key) $("#cttListP").setData({gridcttp: data.nc_list});
                        });
                    }]
                });
            });
			$("#btnExcelTemplate").click(function(){
   	         	var oExcelMetaInfo = {
                        filename  : "영업목표.xls",
                        sheetname : "영업목표",
                        gridname  : "gridteam" //그리드ID 
				};
   	         	
   	         	var arr = new Array();
	         	if(!_planDt) arr.push(7);
	         	if(!_cnslDt) arr.push(8);
	        		 
	         	$.PSNMUtils.downloadExcelPage("gridteam", oExcelMetaInfo, arr);
   	           	
            });
        },
        setGridTrgt : function () {
        	$("#gridtrgt").alopexGrid({
                pager : false,
                rowInlineEdit  : true,
                rowClickSelect : false,
                columnMapping : [
					{ columnIndex : 0, key : "UNIT_TYP_CD",			hidden : true },
                    { columnIndex : 1, key : "UNIT_TYP_NM",			title : "상품명",				align : "center", width : "100px" },
                    { columnIndex : 2, key : "MTH_PLAN_QTY",		title : "계획수량",				align : "right",  width : "100px", render : {type : "string", rule : "comma"} },
                    { columnIndex : 3, key : "EXEC_TRGT_QTY_DSM",	title : "실행목표 수량(영업국)",	align : "right",  width : "100px", render : {type : "string", rule : "comma"} },
                    { columnIndex : 4, key : "EXEC_TRGT_QTY",		title : "실행목표 수량(영업팀)",	align : "right",  width : "100px", render : {type : "string", rule : "comma"} },
                    { columnIndex : 5, key : "RL_SELL_QTY",			title : "실제 판매 수량",			align : "right",  width : "100px"
                    	, editable : {type : "text", rule : "comma"}
                    	, render : {type : "string", rule : "comma"}
                    }
                ]
            });
        },
        setGridTrgtQty : function () {
        	$("#gridtrgtqty").alopexGrid({
                pager : false,
                rowInlineEdit  : true,
                rowClickSelect : false,
                columnMapping : [
					{ columnIndex : 0, key : "TOTAL",				title : "",						align : "center", width : "100px", rowspan : true } ,
					{ columnIndex : 1, key : "UNIT_TYP_CD",			hidden : true },
                    { columnIndex : 2, key : "UNIT_TYP_NM",			title : "상품구분",				align : "center", width : "100px" },
                    { columnIndex : 3, key : "MTH_PLAN_QTY",		title : "계획수량",				align : "right",  width : "100px", render : {type : "string", rule : "comma"} },
                    { columnIndex : 4, key : "EXEC_TRGT_QTY_DSM",	title : "실행목표 수량(영업국)",	align : "right",  width : "100px", render : {type : "string", rule : "comma"} },
                    { columnIndex : 5, key : "EXEC_TRGT_QTY",		title : "실행목표 수량",			align : "right",  width : "100px", render : {type : "string", rule : "comma"} }
                ]
            });
        },
        setGridTeam : function () {
        	$("#gridteam").alopexGrid({
                pager : false,
                rowInlineEdit  : true,
                rowClickSelect : false,
                height : "300px",
                columnMapping : [
					{ columnIndex : 0, key : "SALE_TEAM_ORG_ID",	title : "영업팀코드", 			hidden : true },
                    { columnIndex : 1, key : "SALE_TEAM_ORG_NM",	title : "영업팀명",				align : "center", width : "100px", 	rowspan :{by:3} },
                    { columnIndex : 2, key : "TEAM_LDR_NM",			title : "팀장명",				align : "center", width : "100px", 	rowspan :{by:3} },
                    { columnIndex : 3, key : "AGNT_ID",				title : "에이전트코드",			align : "center", width : "80px", 	rowspan :true },
                    { columnIndex : 4, key : "AGNT_NM",				title : "에이전트명",				align : "center", width : "80px", 	rowspan :{by:3} },
                    { columnIndex : 5, key : "UNIT_TYP_CD",			title : "상품구분코드",			hidden : true },
                    { columnIndex : 6, key : "UNIT_TYP_NM",			title : "상품구분",				align : "center", width : "100px" 	},
                    { columnIndex : 7, key : "MTH_PLAN_QTY",		title : "계획수량",				align : "right",  width : "80px"
                    	, editable : {type : "text", rule : "comma"}
	                    , render : {type : "string", rule : "comma"} 
						, allowEdit : function ( value , data, mapping ){
	                    	
            				if(_planDt){
                    			return true;
            				}
                    		return false;
	                    }
	                },
                    { columnIndex : 8, key : "EXEC_TRGT_QTY",		title : "실행목표 수량",			align : "right",  width : "80px"
                    	, editable : {type : "text", rule : "comma"}
                    	, render : {type : "string", rule : "comma"}
                    	, allowEdit : function ( value , data, mapping ){
	                    	
            				if(_cnslDt){
                    			return true;
            				}
                    		return false;
	                    }
                    }
                ],
                on : {
                    data : {
                        changed : function(type) {
                        	
                            if("edit" == type){
                            	var gridtrgtqty = $("#gridtrgtqty").alopexGrid("dataGet");
                                var gridteam = $("#gridteam").alopexGrid("dataGet");
                                
                                $.each(gridtrgtqty, function(idx, val) {
                                	var sumPlanQty = 0;
                                	var sumTrgtQty = 0;
                                	$.each(gridteam, function(i, value) {
                        				if(val.UNIT_TYP_CD == value.UNIT_TYP_CD){
                        					var planQty = value.MTH_PLAN_QTY;
                        					var trgtQty = value.EXEC_TRGT_QTY;
                        					
                        					if(planQty == "") planQty = 0;
                        					if(trgtQty == "") trgtQty = 0;
                        					
                        					sumPlanQty = sumPlanQty + parseInt(planQty);
                        					sumTrgtQty = sumTrgtQty + parseInt(trgtQty);
                        				}
                        			});
                                	$("#gridtrgtqty").alopexGrid("dataEdit", {"MTH_PLAN_QTY":sumPlanQty}, { _index: { data : idx } } );
                                	$("#gridtrgtqty").alopexGrid("dataEdit", {"EXEC_TRGT_QTY":sumTrgtQty}, { _index: { data : idx } } );
                                });
                            }
                        }
                    }
                }
            });
        },
        setGridExcel : function() {
            
        	//엑셀 템플릿 그리드 초기화
            var _excel_grid = {
                pager : false,
                columnMapping : [
                    { columnIndex : 0, key : "SALE_TEAM_ORG_ID",	title : "영업팀코드" 		},
                    { columnIndex : 1, key : "SALE_TEAM_ORG_NM",	title : "영업팀명"		},
                    { columnIndex : 2, key : "TEAM_LDR_NM",			title : "팀장명"			},
                    { columnIndex : 3, key : "AGNT_ID",				title : "에이전트코드"	},
                    { columnIndex : 4, key : "AGNT_NM",				title : "에이전트명"		},
                    { columnIndex : 5, key : "UNIT_TYP_CD",			title : "상품구분코드" 	},
                    { columnIndex : 6, key : "UNIT_TYP_NM",			title : "상품구분"		},
                    { columnIndex : 7, key : "MTH_PLAN_QTY",		title : "계획수량"		},
                    { columnIndex : 8, key : "EXEC_TRGT_QTY",		title : "실행목표 수량"	}
                ]
            };
            
            $("#gridexceltemplate").alopexGrid(_excel_grid);
            $("#gridexcelimported").alopexGrid(_excel_grid);
            
            if(!_planDt){
				$("#gridexceltemplate").alopexGrid("updateColumnMapping", "MTH_PLAN_QTY", {hidden:true});
				$("#gridexcelimported").alopexGrid("updateColumnMapping", "MTH_PLAN_QTY", {hidden:true});
			}
            
			if(!_cnslDt){
				$("#gridexceltemplate").alopexGrid("updateColumnMapping", "EXEC_TRGT_QTY", {hidden:true});
				$("#gridexcelimported").alopexGrid("updateColumnMapping", "EXEC_TRGT_QTY", {hidden:true});
			}
            
            $.PSNMUtils.setExcelUploadImport("#excelupload", "#gridexcelimported", $a.page.excelImportPostHandler);
        },
		excelImportPostHandler : function(arrDataList){
			
			/*
			if(_cnslDt || _planDt){
				
				$("#gridteam").alopexGrid("dataEmpty");
				$("#gridteam").alopexGrid("dataSet", arrDataList);
			}else{
				var dataList = $("#gridteam").alopexGrid("dataGet");
				$.extend(true, dataList, arrDataList);
				
				$("#gridteam").alopexGrid("dataEmpty");
				$("#gridteam").alopexGrid("dataSet", dataList);
			}
			*/
			
			var dataList = $("#gridteam").alopexGrid("dataGet");
			$.extend(true, dataList, arrDataList);
			
			$("#gridteam").alopexGrid("dataEmpty");
			$("#gridteam").alopexGrid("dataSet", dataList);
			
			var gridtrgtqty = $("#gridtrgtqty").alopexGrid("dataGet");
            var gridteam = $("#gridteam").alopexGrid("dataGet");
            $.each(gridtrgtqty, function(idx, val) {
            	var sumPlanQty = 0;
            	var sumTrgtQty = 0;
            	$.each(gridteam, function(i, value) {
    				if(val.UNIT_TYP_CD == value.UNIT_TYP_CD){
    					var planQty = value.MTH_PLAN_QTY;
    					var trgtQty = value.EXEC_TRGT_QTY;
    					
    					if(planQty == "") planQty = 0;
    					if(trgtQty == "") trgtQty = 0;
    					
    					sumPlanQty = sumPlanQty + parseInt(planQty);
    					sumTrgtQty = sumTrgtQty + parseInt(trgtQty);
    				}
    			});
            	$("#gridtrgtqty").alopexGrid("dataEdit", {"MTH_PLAN_QTY":sumPlanQty}, { _index: { data : idx } } );
            	$("#gridtrgtqty").alopexGrid("dataEdit", {"EXEC_TRGT_QTY":sumTrgtQty}, { _index: { data : idx } } );
            });
			
        },
        setViewData : function() {
        	var salesYm = _param.data != null ? _param.data.SALES_YM : "";
        	var saleDeptOrgId = _param.data != null ? _param.data.SALE_DEPT_ORG_ID : "";
        	var saleTeamOrgId = _param.data != null ? _param.data.SALE_TEAM_ORG_ID : "";
        	
        	if($.PSNMUtils.isNotEmpty(salesYm)){
        		var HDQT_TEAM_ORG_ID = _param.data != null ? _param.data.HDQT_TEAM_ORG_ID : "";
            	var HDQT_PART_ORG_ID = _param.data != null ? _param.data.HDQT_PART_ORG_ID : "";
            	var SALE_DEPT_ORG_ID = _param.data != null ? _param.data.SALE_DEPT_ORG_ID : "";
            	var SALE_TEAM_ORG_ID = _param.data != null ? _param.data.SALE_TEAM_ORG_ID : "";
            	var RGSTR_NM = _param.data != null ? _param.data.RGSTR_NM : "";
            	
        		var _salesYm = salesYm.substring(0,4) + "-" + salesYm.substring(4,6);
            	var arrSalesYm = _salesYm.split('-');
       			var iMonth = arrSalesYm[1];		
       	        iMonth = iMonth - 1;
       	        if(iMonth < 1){
       	        	iMonth = 12;
       	        }else if(iMonth > 12){
       	        	iMonth = 1;
    			}
       	  		
       	     	$("#SALES_YM").val(_salesYm);
     			$("#HDQT_TEAM_ORG_ID").setSelected(HDQT_TEAM_ORG_ID);
    	     	$("#HDQT_PART_ORG_ID").setSelected(HDQT_PART_ORG_ID);
    	  		$("#SALE_DEPT_ORG_ID").setSelected(SALE_DEPT_ORG_ID);
    	  		$("#SALE_TEAM_ORG_ID").setSelected(SALE_TEAM_ORG_ID);
    	  		$("#HDQT_TEAM_ORG_ID").setEnabled(false); 
    	  		$("#HDQT_PART_ORG_ID").setEnabled(false); 
    	  		$("#SALE_DEPT_ORG_ID").setEnabled(false); 
    	  		$("#SALE_TEAM_ORG_ID").setEnabled(false); 
    	  		$("#form1").setData({RGSTR_NM : RGSTR_NM});
    	  		
        		$(".prvMonth").setData({MONTH : iMonth});
        		$(".nowMonth").setData({MONTH : parseInt(arrSalesYm[1])});
        		
        		$.alopex.request("biz.SALEPLAN@PMTHSALESPLAN001_pSearchMthExecTrgtTeam", {
            		data: {dataSet: {fields: {SALES_YM : salesYm
            								, SALE_DEPT_ORG_ID : saleDeptOrgId
            								, SALE_TEAM_ORG_ID : saleTeamOrgId
            								, HEADQ_YN : "N"
            								, ORG_LVL : "2"}}},
                    success:["#form5", function(res) {
                    	var gridList = res.dataSet.recordSets;
                    	
                        $.each(gridList, function(key, data) {
                        	$("#"+key).alopexGrid("dataSet", data.nc_list);
                        	
                        	if("gridheadq" == key){ // 국장 실행목표 등록 여부 체크
                        		$.each(data.nc_list, function(i, val) {
                        			if(val.EXEC_TRGT_QTY != 0){
                        				_cnslDt = true;
                        				return;
                        			}else{
                        				_cnslDt = false;
                        			}
                        		});
                        	}
                        	
                        });
                        
                        var tableB = "<table class=\"board02\" style=\"width:100%;\">";
        	            tableB += "<colgroup>";
                        tableB += "<col style=\"width:15%\"/>";
                        tableB += "<col style=\"width:*\"/>";
                        tableB += "</colgroup>";
                        tableB += "<tbody id=\"cttListB\">";
                        var gridcttb =  res.dataSet.recordSets.gridcttb.nc_list;
                        $.each(gridcttb, function(i, val) {
                        	tableB += "<tr>";
                        	tableB += "<th id=\"limitctt\" scope=\"col\">";
                        	tableB += "<input id=\"STRD_MGMT_SEQ\" name=\"STRD_MGMT_SEQ\" type=\"hidden\" value=\""+val.STRD_MGMT_SEQ+"\"/>";
                        	tableB += ""+val.STRT_TITLE_NM+"<br/><br/><font color=\"red\">(100자 이상 입력필수)</font>&nbsp;&nbsp;<span id=\"textlimit\">0</span>/100";
                        	tableB += "</th>";
                        	tableB += "<td class=\"tleft\">";
                        	tableB += "<textarea id=\"SALES_PLAN_CTT_B"+i+"\" name=\"SALES_PLAN_CTT\" data-type=\"textarea\" value=\""+val.SALES_PLAN_CTT+"\" rows=\"3\" style=\"overflow: auto; width: 100%; height: 110px;\" onkeyup=\"updateCharFind(this);\" onkeydown=\"updateCharFind(this);\" ";
                        	tableB += "data-validation-rule=\"{required:true, minlength:100}\" data-validation-message=\"{required:$.PSNM.msg('E012', ['"+val.STRT_TITLE_NM+"']) ,minlength:$.PSNM.msg('E013', ['"+val.STRT_TITLE_NM+"','100'])}\">"+val.SALES_PLAN_CTT+"</textarea>";
                        	tableB += "</td>";
                        	tableB += "</tr>";
                        });
                        tableB += "</tbody>";
                       	tableB += "</table>";
                       	$("#form2").html(tableB);
                       	
                       	var tableC = "<table class=\"board02\" style=\"width:100%;\">";
                       	tableC += "<colgroup>";
                       	tableC += "<col style=\"width:15%\"/>";
                       	tableC += "<col style=\"width:*\"/>";
                       	tableC += "</colgroup>";
                       	tableC += "<tbody id=\"cttListC\">";
                        var gridcttc =  res.dataSet.recordSets.gridcttc.nc_list;
                        $.each(gridcttc, function(i, val) {
                        	tableC += "<tr>";
                        	tableC += "<th id=\"limitctt\" scope=\"col\">";
                        	tableC += "<input id=\"STRD_MGMT_SEQ\" name=\"STRD_MGMT_SEQ\" type=\"hidden\" value=\""+val.STRD_MGMT_SEQ+"\"/>";
                        	tableC += ""+val.STRT_TITLE_NM+"<br/><br/><font color=\"red\">(100자 이상 입력필수)</font>&nbsp;&nbsp;<span id=\"textlimit\">0</span>/100";
                        	tableC += "</th>";
                        	tableC += "<td class=\"tleft\">";
                        	tableC += "<textarea id=\"SALES_PLAN_CTT_C"+i+"\" name=\"SALES_PLAN_CTT\" data-type=\"textarea\" value=\""+val.SALES_PLAN_CTT+"\" rows=\"3\" style=\"overflow: auto; width: 100%; height: 110px;\" onkeyup=\"updateCharFind(this);\" onkeydown=\"updateCharFind(this);\" ";
                        	tableC += "data-validation-rule=\"{required:true, minlength:100}\" data-validation-message=\"{required:$.PSNM.msg('E012', ['"+val.STRT_TITLE_NM+"']) ,minlength:$.PSNM.msg('E013', ['"+val.STRT_TITLE_NM+"','100'])}\">"+val.SALES_PLAN_CTT+"</textarea>";
                        	tableC += "</td>";
                        	tableC += "</tr>";
                        });
                        tableC += "</tbody>";
                        tableC += "</table>";
                       	$("#form3").html(tableC);
                       	
                       	var tableP = "<table class=\"board02\" style=\"width:100%;\">";
                       	tableP += "<colgroup>";
                       	tableP += "<col style=\"width:15%\"/>";
                       	tableP += "<col style=\"width:*\"/>";
                       	tableP += "</colgroup>";
                       	tableP += "<tbody id=\"cttListP\">";
                        var gridcttp =  res.dataSet.recordSets.gridcttp.nc_list;
                        $.each(gridcttp, function(i, val) {
                        	tableP += "<tr>";
                        	tableP += "<th id=\"limitctt\" scope=\"col\">";
                        	tableP += "<input id=\"STRD_MGMT_SEQ\" name=\"STRD_MGMT_SEQ\" type=\"hidden\" value=\""+val.STRD_MGMT_SEQ+"\"/>";
                        	tableP += ""+val.STRT_TITLE_NM;
                        	tableP += "</th>";
                        	tableP += "<td class=\"tleft\">";
                        	tableP += "<textarea id=\"SALES_PLAN_CTT_P"+i+"\" name=\"SALES_PLAN_CTT\" data-type=\"textarea\" value=\""+val.SALES_PLAN_CTT+"\" rows=\"3\" style=\"overflow: auto; width: 100%; height: 110px;\" ";
                        	tableP += ">"+val.SALES_PLAN_CTT+"</textarea>";
                        	tableP += "</td>";
                        	tableP += "</tr>";
                        });
                        tableP += "</tbody>";
                        tableP += "</table>";
                       	$("#form4").html(tableP);
                    }]
                });
        		
        	}else{
        		
        		//매월 25일 이후에는 자동으로 다음 월이 셋팅되도록
    			var array_curdt = getCurrdate().split('-');

    			if(array_curdt[2]<25){
    				$("#SALES_YM").val(getAddMonthDate(1,"yyyymm"));
    			} else {
    				$("#SALES_YM").val(getAddMonthDate(2,"yyyymm"));
    			}
        		
       			var arrSalesYm = $("#SALES_YM").val().split('-');
       			var iMonth = arrSalesYm[1];		
       	        iMonth = iMonth - 1;
       	        if(iMonth < 1){
       	        	iMonth = 12;
       	        }else if(iMonth > 12){
       	        	iMonth = 1;
 				}
        		
        		$(".prvMonth").setData({MONTH : iMonth});
        		$(".nowMonth").setData({MONTH : parseInt(arrSalesYm[1])});
        		
        		$.alopex.request("biz.SALEPLAN@PMTHSALESPLAN001_pSearchMthExecTrgtTeam", {
            		data: {dataSet: {fields: {SALES_YM : $.PSNMUtils.getDateInput("SALES_YM")
            								, SALE_DEPT_ORG_ID : $("#SALE_DEPT_ORG_ID").val()
            								, SALE_TEAM_ORG_ID : $("#SALE_TEAM_ORG_ID").val()
            								, HEADQ_YN : "N"
            								, ORG_LVL : "2"}}},
                    success:["#form5", function(res) {
                    	var gridList = res.dataSet.recordSets;
                    	
                        $.each(gridList, function(key, data) {
                        	$("#"+key).alopexGrid("dataSet", data.nc_list);
                        	
                        	if("gridheadq" == key){ // 국장 실행목표 등록 여부 체크
                        		$.each(data.nc_list, function(i, val) {
                        			if(val.EXEC_TRGT_QTY != 0){
                        				_cnslDt = true;
                        				return;
                        			}else{
                        				_cnslDt = false;
                        			}
                        		});
                        	}
                        	
                        });
                        
                        var tableB = "<table class=\"board02\" style=\"width:100%;\">";
        	            tableB += "<colgroup>";
                        tableB += "<col style=\"width:15%\"/>";
                        tableB += "<col style=\"width:*\"/>";
                        tableB += "</colgroup>";
                        tableB += "<tbody id=\"cttListB\">";
                        var gridcttb =  res.dataSet.recordSets.gridcttb.nc_list;
                        $.each(gridcttb, function(i, val) {
                        	tableB += "<tr>";
                        	tableB += "<th id=\"limitctt\" scope=\"col\">";
                        	tableB += "<input id=\"STRD_MGMT_SEQ\" name=\"STRD_MGMT_SEQ\" type=\"hidden\" value=\""+val.STRD_MGMT_SEQ+"\"/>";
                        	tableB += ""+val.STRT_TITLE_NM+"<br/><br/><font color=\"red\">(100자 이상 입력필수)</font>&nbsp;&nbsp;<span id=\"textlimit\">0</span>/100";
                        	tableB += "</th>";
                        	tableB += "<td class=\"tleft\">";
                        	tableB += "<textarea id=\"SALES_PLAN_CTT_B"+i+"\" name=\"SALES_PLAN_CTT\" data-type=\"textarea\" value=\""+val.SALES_PLAN_CTT+"\" rows=\"3\" style=\"overflow: auto; width: 100%; height: 110px;\" onkeyup=\"updateCharFind(this);\" onkeydown=\"updateCharFind(this);\" ";
                        	tableB += "data-validation-rule=\"{required:true, minlength:100}\" data-validation-message=\"{required:$.PSNM.msg('E012', ['"+val.STRT_TITLE_NM+"']) ,minlength:$.PSNM.msg('E013', ['"+val.STRT_TITLE_NM+"','100'])}\"></textarea>";
                        	tableB += "</td>";
                        	tableB += "</tr>";
                        });
                        tableB += "</tbody>";
                       	tableB += "</table>";
                       	$("#form2").html(tableB);
                       	
                       	var tableC = "<table class=\"board02\" style=\"width:100%;\">";
                       	tableC += "<colgroup>";
                       	tableC += "<col style=\"width:15%\"/>";
                       	tableC += "<col style=\"width:*\"/>";
                       	tableC += "</colgroup>";
                       	tableC += "<tbody id=\"cttListC\">";
                        var gridcttc =  res.dataSet.recordSets.gridcttc.nc_list;
                        $.each(gridcttc, function(i, val) {
                        	tableC += "<tr>";
                        	tableC += "<th id=\"limitctt\" scope=\"col\">";
                        	tableC += "<input id=\"STRD_MGMT_SEQ\" name=\"STRD_MGMT_SEQ\" type=\"hidden\" value=\""+val.STRD_MGMT_SEQ+"\"/>";
                        	tableC += ""+val.STRT_TITLE_NM+"<br/><br/><font color=\"red\">(100자 이상 입력필수)</font>&nbsp;&nbsp;<span id=\"textlimit\">0</span>/100";
                        	tableC += "</th>";
                        	tableC += "<td class=\"tleft\">";
                        	tableC += "<textarea id=\"SALES_PLAN_CTT_C"+i+"\" name=\"SALES_PLAN_CTT\" data-type=\"textarea\" value=\""+val.SALES_PLAN_CTT+"\" rows=\"3\" style=\"overflow: auto; width: 100%; height: 110px;\" onkeyup=\"updateCharFind(this);\" onkeydown=\"updateCharFind(this);\" ";
                        	tableC += "data-validation-rule=\"{required:true, minlength:100}\" data-validation-message=\"{required:$.PSNM.msg('E012', ['"+val.STRT_TITLE_NM+"']) ,minlength:$.PSNM.msg('E013', ['"+val.STRT_TITLE_NM+"','100'])}\"></textarea>";
                        	tableC += "</td>";
                        	tableC += "</tr>";
                        });
                        tableC += "</tbody>";
                        tableC += "</table>";
                       	$("#form3").html(tableC);
                       	
                       	var tableP = "<table class=\"board02\" style=\"width:100%;\">";
                       	tableP += "<colgroup>";
                       	tableP += "<col style=\"width:15%\"/>";
                       	tableP += "<col style=\"width:*\"/>";
                       	tableP += "</colgroup>";
                       	tableP += "<tbody id=\"cttListP\">";
                        var gridcttp =  res.dataSet.recordSets.gridcttp.nc_list;
                        $.each(gridcttp, function(i, val) {
                        	tableP += "<tr>";
                        	tableP += "<th id=\"limitctt\" scope=\"col\">";
                        	tableP += "<input id=\"STRD_MGMT_SEQ\" name=\"STRD_MGMT_SEQ\" type=\"hidden\" value=\""+val.STRD_MGMT_SEQ+"\"/>";
                        	tableP += ""+val.STRT_TITLE_NM;
                        	tableP += "</th>";
                        	tableP += "<td class=\"tleft\">";
                        	tableP += "<textarea id=\"SALES_PLAN_CTT_P"+i+"\" name=\"SALES_PLAN_CTT\" data-type=\"textarea\" value=\""+val.SALES_PLAN_CTT+"\" rows=\"3\" style=\"overflow: auto; width: 100%; height: 110px;\" ";
                        	tableP += "></textarea>";
                        	tableP += "</td>";
                        	tableP += "</tr>";
                        });
                        tableP += "</tbody>";
                        tableP += "</table>";
                       	$("#form4").html(tableP);
                    }]
                });
        		
        		$("#btnCancel").hide();
        	}
        }
    });
    
    </script>

</head>

<body>

<jsp:include page="/view/layouts/default_header.jsp" flush="false" />

<div id="contents">

    <!-- title area -->
    <div class="content_title">
        <div class="ub_txt6">
            <span class="txt6_img"><b>월별영업계획</b><span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif"> 
            <span class="a2">영업팀업무</span> <span class="a3"> > </span><b>판매관리</b></span></span> 
        </div>
    </div>

    <!-- btn area -->
    <div class="btn_area">
        <div class="ab_btn_right">
            <button id="btnCancel" type="button" data-type="button" data-theme="af-btn10" data-altname="취소" data-authtype="R"></button>
            <button id="btnSave" type="button" data-type="button" data-theme="af-btn4"  data-altname="저장" data-authtype="W"></button>
            <button id="btnList" type="button" data-type="button" data-theme="af-btn14" data-altname="목록" data-authtype="R"></button>
        </div>
    </div>
    <!-- btn area end--> 

    <!--view_list area -->
    <div class="floatL4">&nbsp;</div>
    <div class="view_list">
    	<form id="form1" onsubmit="return false;">
    	
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
                <th scope="col" class="fontred">대상월</th>
                <td class="tleft">
                	<input id="SALES_YM" name="SALES_YM" data-type="dateinput" data-pickertype="monthly" data-format="yyyy-MM" data-bind="value:SALES_YM" style="width:80px;" data-enabled="false"/>
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
				<th class="fontred">관리자명</th>
				<td class="tleft"><label data-bind="text:RGSTR_NM"></label></td>
            </tr>
            </table>
        </form>
    </div>
    
    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif">&nbsp;<b><label class="prvMonth" data-bind="text : MONTH"></label>월 영업실적</b></div>
    <div id="gridtrgt" data-bind="grid:gridtrgt"></div>
    
    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif">&nbsp;<b><label class="prvMonth" data-bind="text : MONTH"></label>월 영업결과분석</b></div>
    <div class="view_list">
        <form id="form2" onsubmit="return false;">
        </form>
    </div>
    
    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif">&nbsp;<b><label class="nowMonth" data-bind="text : MONTH"></label>월 영업목표</b></div>
    <form id="form5" onsubmit="return false;">
    <table class="board02" style="width:100%;">
		<colgroup>
            <col style="width:10%"/>
            <col style="width:22%"/>
            <col style="width:10%"/>
            <col style="width:22%"/>
            <col style="width:10%"/>
            <col style="width:*"/>
		</colgroup>
		<tr>
			<th scope="col">등록MA수</th>
			<td class="tleft">
              	<label id="PRSN_CNT" data-bind="text:PRSN_CNT"></label>
			</td>
			<th scope="col">활동MA수</th>
			<td class="tleft">
              	<input id="ACTV_PRSN_CNT" name="ACTV_PRSN_CNT" data-type="textnput" data-bind="value:ACTV_PRSN_CNT" style="width:80px;"/>
			</td>
			<th scope="col">증원목표(명)</th>
			<td class="tleft">
              	<input id="INCP_PLAN_PRSN_CNT" name="INCP_PLAN_PRSN_CNT" data-type="textnput" data-bind="value:INCP_PLAN_PRSN_CNT" style="width:80px;"/>
			</td>
		</tr>
	</table>
	</form>
	
	<div class="floatL4"></div>
    <div id="gridtrgtqty" data-bind="grid:gridtrgtqty"></div>
    
    <div class="floatL4"></div>
    <div class="btn_area">
        <div class="ab_btn_right">
            <button id="btnExcelTemplate" type="button" data-type="button" data-theme="af-btn48" data-altname="업로드템플릿" data-authtype="W"></button>
        	<button id="btnExcelUpload" type="button" data-type="button" data-theme="af-btn47" data-altname="엑셀업로드" data-authtype="W"></button>
            <div class="ab_pos1" style="top:0px;">
				<div style="position:relative;">
					<span class="file-button type2"><input id="excelupload" type="file" style="cursor:pointer;"></span>
				</div>
			</div>
        </div>
    </div>
    <div class="floatL4">&nbsp;</div>
    <div id="gridteam" data-bind="grid:gridteam"></div>
    
    <div class="floatL4"></div>
    <div class="view_list">
        <form id="form4" onsubmit="return false;">
        </form>
    </div>
    
    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif">&nbsp;<b><label class="nowMonth" data-bind="text : MONTH"></label>월 주요 전략 (목표달성을 위한 주요 행사 및 공략시장/ 판매방식 관련 특이사항)</b></div>
    <div class="view_list">
        <form id="form3" onsubmit="return false;">
        </form>
    </div>
    
    <!--excel area -->
	<div id="gridexceltemplate" data-bind="grid:gridexceltemplate" style="display:none;"></div><!-- 템플릿 엑셀그리드 -->
  	<div id="gridexcelimported" data-bind="grid:gridexcelimported" style="display:none;"></div><!-- 업로드 엑셀그리드 -->
    
</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>