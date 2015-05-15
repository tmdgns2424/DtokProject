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
            
            $a.page.setEventListener();
            $a.page.setFileUpload();
            $a.page.setCodeData();
            $a.page.setGrid1();
            $a.page.setGrid2();
            $a.page.setViewData();
            $a.page.setAuthPart();
            $a.page.setGridExcel();//엑셀그리드
        },
        setEventListener : function() {
			$("#btnSave").click(function(){
				$("#grid1").alopexGrid("endEdit");
				
				if ( ! $.PSNM.isValid("#form") ) {
				    return false; //값 검증
				}
				
				var startDt = $("#EDU_STA_H").getValues() + $("#EDU_STA_M").getValues();
				var endDt = $("#EDU_END_H").getValues() + $("#EDU_END_M").getValues();
				
				if(startDt >= endDt){
					//$.PSNM.alert("시행일시 시/분을 다시 입력해 주십시오.");
					$.PSNM.alert("시행종료일시가 시행시작일시보다 작거나 같을 수 없습니다.");
            		return;
				}
               	
               	if(  $.PSNM.confirm("I004", ["저장"] ) ){
               		var requestData = $.PSNMUtils.getRequestData("form", "grid1", "grid3", "gridfile");
                   	$.alopex.request("biz.AGNTEDU@PAGENTEDU001_pSaveAgentEdu", {
	                    data: requestData,
	                    success: function(res) { 
	                        $a.navigate("agentEduList.jsp", _param);
	                    }
                	});
           		}
            });
			$("#btnList").click(function(){
				$a.navigate("agentEduList.jsp", _param);
            });
            $("#btnCancel").click(function(){
            	$a.back(_param);
            });
            $("#btnFileDel").click(function(){
            	$.PSNMUtils.delFile();
            });
            $("#btnGridAdd").click(function(){
            	
            	var oParam = new Object();
            	$.PSNMAction.popFindUser(oParam, function(oResult) {
                    if ( oResult != null && typeof oResult == "object" ) {
                    	var curResult = $("#grid1").alopexGrid("dataGet");
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
        						$("#grid1").alopexGrid("dataAdd", oResult[i], {_index : { data : 0 }});
        						
        						$("#grid1").alopexGrid("startEdit");
                                $("#grid1").alopexGrid("endEdit");
        					}						
        				}
                    }
                    $("#form").setData({STU_MA_COUNT : $("#grid1").alopexGrid("dataGet").length});
                });
            });
            $("#btnGridDel").click(function(){
				var getData = $("#grid1").alopexGrid("dataGet", {_state:{selected:true}});
            	if(getData.length == 0){
            		$.PSNM.alert("E021", ["삭제할 행을"]);
            		return;
            	}
				
				$("#grid3").alopexGrid("dataAdd", getData);
            	$("#grid1").alopexGrid("dataDelete", {_state:{selected:true}});
            	$("#form").setData({STU_MA_COUNT : $("#grid1").alopexGrid("dataGet").length});
            });
            $("#btnExcelTemplate").click(function(){
            	var aSampleData = [
   	           		{ "AGNT_ID" : "123456", "EDU_MANN_CD" : "10", "EVAL_RSLT_CD" : "10", "MEMO" : "교육참여도가 좋습니다." }
   	           	];
   	   	        var oExcepMetaInfo = { filename  : "EP_"+getCurrdate()+".xls", sheetname : "교육관리 참석자현황" };
   	           	$.PSNMUtils.downloadExcelTemplate("#gridexceltemplate", aSampleData, oExcepMetaInfo);
            });
        },
        setGrid1 : function () {
        	$("#grid1").alopexGrid({
                pager : false,
                rowInlineEdit  : true,
                height : "300px", 
                columnMapping : [
					{ columnIndex : 0, selectorColumn : true, width : "30px" },
					{ columnIndex : 1, key : "USER_ID",				title : "아이디",		hidden:true },
                    { columnIndex : 2, key : "HDQT_PART_ORG_NM",	title : "본사파트",		align : "center", width : "100px" },
                    { columnIndex : 3, key : "SALE_DEPT_ORG_NM",	title : "영업국명",		align : "center", width : "100px" },
                    { columnIndex : 4, key : "SALE_TEAM_ORG_NM",	title : "영업팀명",		align : "center", width : "100px" },
                    { columnIndex : 5, key : "AGNT_ID",   			title : "에이전트코드",	align : "center", width : "100px" },
                    { columnIndex : 6, key : "RPSTY_NM",   			title : "직책명",		align : "center", width : "100px" },
                    { columnIndex : 7, key : "AGNT_NM",   			title : "에이전트명",		align : "center", width : "100px" },
                    { columnIndex : 8
                    		, key : "EDU_MANN_CD"
                    		, title : "교육태도"
                    		, align : "center"
                    		, width : "100px" 
                    		, editable : {
                    				type : "select"
                    				, rule : function() {
										var oParam = { t:'code', 'codeid' : 'DSM_EDU_MANN_CD', 'header' : ' ' };	
										return $.PSNMUtils.getCode(oParam);
                                    }
                    			}},
                    { columnIndex : 9
                    		, key : "EVAL_RSLT_CD"
                    		, title : "평가결과"
                    		, align : "center"
                    		, width : "100px"
                    		, editable : {
                    				type : "select"
                   					, rule : function() {
   										var oParam = { t:'code', 'codeid' : 'DSM_EDU_MANN_CD', 'header' : ' ' };	
   										return $.PSNMUtils.getCode(oParam);
                                    }
                    			}},
                    { columnIndex : 10, key : "MEMO",   				title : "특이사항",		align : "center", width : "150px", editable : { type : "text" } }
                ]
            });
        },
        setGrid2 : function () {
        	$("#grid2").alopexGrid({
                pager : false,
                rowInlineEdit  : true,
                height : "300px", 
                columnMapping : [
					{ columnIndex : 1, key : "USER_ID",				title : "아이디",		hidden:true },
                    { columnIndex : 2, key : "HDQT_PART_ORG_NM",	title : "본사파트",		align : "center", width : "50px"  },
                    { columnIndex : 3, key : "SALE_DEPT_ORG_NM",	title : "영업국명",		align : "center", width : "50px"  },
                    { columnIndex : 4, key : "SALE_TEAM_ORG_NM",	title : "영업팀명",		align : "center", width : "50px"  },
                    { columnIndex : 5, key : "AGNT_ID",   			title : "에이전트코드",	align : "center", width : "100px" },
                    { columnIndex : 6, key : "RPSTY_NM",   			title : "직책명",		align : "center", width : "50px"  },
                    { columnIndex : 7, key : "AGNT_NM",   			title : "에이전트명",		align : "center", width : "100px" },
                    { columnIndex : 8, key : "EDU_MANN_CD", 		title : "교육태도", 		align : "center", width : "50px"  },
                    { columnIndex : 9, key : "EVAL_RSLT_CD", 		title : "평가결과", 		align : "center", width : "50px"  },
                    { columnIndex : 10, key : "MEMO",   			title : "특이사항",		align : "center", width : "150px" },
                    { columnIndex : 11, key : "MESSAGE",   			title : "실패사유",		align : "center", width : "250px" }
                ]
            });
        },
        setViewData : function() {
        	var id = _param.data != null ? _param.data.AGENT_EDUT_MGMT_NUM : "";
        	
        	if($.PSNMUtils.isNotEmpty(id)){
        		$.alopex.request("biz.AGNTEDU@PAGENTEDU001_pDetailAgentEdu", {
            		data: {dataSet: {fields: {AGENT_EDUT_MGMT_NUM : id}}},
                    success:["#form",  function(res) {
                    	var gridList = res.dataSet.recordSets;
    					
                        $.each(gridList, function(key, data) {
                        	$("#"+key).alopexGrid("dataSet", data.nc_list);
                        });
                    	$("#form").setData({STU_MA_COUNT : $("#grid1").alopexGrid( "dataGet" ).length});
                    }]
                });
        	}else{
        		$("#btnCancel").hide();
        	}
        },
        setCodeData : function() {
        	$.PSNMUtils.setCodeData([
				{ t:'code', 'elemid' : 'EDU_STA_H', 'codeid' : 'DSM_TM_CD' },
				{ t:'code', 'elemid' : 'EDU_END_H', 'codeid' : 'DSM_TM_CD' }
            ]);
        },
        setFileUpload : function () {
        	$.PSNMUtils.setFileUploadAndGrid("EDU", "#fileupload", "#gridfile");
        },
        setGridExcel : function() {
            //엑셀 템플릿 그리드 초기화
            var _excel_grid = {
                pager : false,
                columnMapping : [
                    { columnIndex : 0, key : "AGNT_ID",		title : "에이전트코드", 	align : "center", width : "100px"},
                    { columnIndex : 1, key : "EDU_MANN_CD",	title : "교육태도",		align : "center", width : "100px"},
                    { columnIndex : 2, key : "EVAL_RSLT_CD",title : "평가결과",		align : "center", width : "100px"},
                    { columnIndex : 3, key : "MEMO",		title : "특이사항", 		align : "center", width : "200px"}
                ]
            };
            
            $("#gridexceltemplate").alopexGrid(_excel_grid);
            $("#gridexcelimported").alopexGrid(_excel_grid);
            
            $.PSNMUtils.setExcelUploadImport("#excelupload", "#gridexcelimported", $a.page.excelImportPostHandler);
        },
		excelImportPostHandler : function(arrDataList){
			
			$("#gridexcelimported").alopexGrid("dataSet", arrDataList);
			
			var id = _param.data != null ? _param.data.AGENT_EDUT_MGMT_NUM : "";
			var data = $.PSNMUtils.getRequestData("gridexcelimported");
			data.dataSet.fields.AGENT_EDUT_MGMT_NUM = id;
			
           	$.alopex.request('biz.AGNTEDU@PAGENTEDU001_pSearchAgentEduAtndr', {
       			data : data,
				success : function(res) {
                   	var succesData = res.dataSet.recordSets.succesData.nc_list;
                   	var failData = res.dataSet.recordSets.failData.nc_list;
                   	
                   	if($.PSNMUtils.isNotEmpty(succesData) && succesData.length > 0){
                   		var curResult = $("#grid1").alopexGrid("dataGet");
                    	//회원중복체크
        				for(var i=0 ; i<succesData.length ; i++) {
        					var flag = false;
        					for(var j=0 ; j<curResult.length ; j++) {
        						if(succesData[i].USER_ID == curResult[j].USER_ID){
        							flag = true;
        							break;
        						}
        					}
        					if(flag == false){
        						$("#grid1").alopexGrid("dataAdd", succesData[i], {_index : { data : 0 }});
        						
        						$("#grid1").alopexGrid("startEdit");
                                $("#grid1").alopexGrid("endEdit");
        					}						
        				}
        				$("#form").setData({STU_MA_COUNT : $("#grid1").alopexGrid("dataGet").length});
                   	}
                   	
                   	if($.PSNMUtils.isNotEmpty(failData) && failData.length > 0){
                   		$("#noneGrid").show();
                   		$("#grid2").alopexGrid("dataSet", failData);
                   	}
				}
			});
        },
        setAuthPart : function() {
        	$.alopex.request("biz.DATAAUTH@PDATAAUTH001_pSearchDataAuthPart", {
	        	success: function(res) {
	                var codeList = res.dataSet.recordSets.resultList.nc_list;
	
	                var codeOptions = [];
	                    codeOptions.push({ value: "", text: "-전체-"});
	
	                $.each(codeList, function (index, codeinfo) {
	                    var codeOpt = new Object();
	                        codeOpt["value"] = codeinfo.OUT_ORG_ID;
	                        codeOpt["text"]  = codeinfo.OUT_ORG_NM;
	                    codeOptions.push(codeOpt);
	                });
	                var optData = new Object();
	                    optData["options_OUT_ORG_ID"] = codeOptions;
	
	                $("#OUT_ORG_ID").setData(optData);
	            }
            });
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
            <span class="txt6_img"><b>교육관리</b><span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif"> 
            <span class="a2">본사업무</span> <span class="a3"> > </span><b>에이전트관리</b></span></span> 
        </div>
    </div>

    <!-- btn area -->
    <div class="btn_area">
        <div class="ab_btn_right">
            <button id="btnCancel" type="button" data-type="button" data-theme="af-btn10" data-altname="취소" data-authtype="R"></button>
            <button id="btnSave" type="button" data-type="button" data-theme="af-btn4"  data-altname="저장" data-authtype="W"></button>
            <button id="btnList" type="button" data-type="button" data-theme="af-btn14" data-altname="목록" data-authtype="R"></button>
            <button id="btnExcelTemplate" type="button" data-type="button" data-theme="af-btn48" data-altname="업로드템플릿" data-authtype="W"></button>
        	<button id="btnExcelUpload" type="button" data-type="button" data-theme="af-btn47" data-altname="엑셀업로드" data-authtype="W"></button>
            <div class="ab_pos1" style="top:0px;">
				<div style="position:relative;">
					<span class="file-button type2"><input id="excelupload" type="file" style="cursor:pointer;"></span>
				</div>
			</div>
        </div>
    </div>
    <!-- btn area end--> 

    <!--view_list area -->
    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>교육관리</b></div>

    <!--view_table area -->
    <div class="view_list">

        <form id="form" onsubmit="return false;">
        	<input type="hidden" id="AGENT_EDUT_MGMT_NUM" name="AGENT_EDUT_MGMT_NUM"  data-bind="value:AGENT_EDUT_MGMT_NUM"/>
        	
            <table class="board02" style="width:100%;">
            <colgroup>
		            <col style="width:15%"/>
		            <col style="width:35%"/>
		            <col style="width:15%"/>
		            <col style="width:*"/>
            </colgroup>
            <tbody>
            <tr>
                <th scope="col" class="fontred">교육명</th>
                <td class="tleft">
                	<input id="EDU_NM" name="EDU_NM" data-bind="value:EDU_NM" data-type="textinput" 
	                		data-validation-rule="{required:true}" 
	                		data-validation-message="{required:$.PSNM.msg('E012', ['교육명'])}" style="width:95%">
                </td>
                <th scope="col" class="fontred">본사파트</th>
				<td class="tleft">
					<select id="OUT_ORG_ID" data-bind="options: options_OUT_ORG_ID, selectedOptions: OUT_ORG_ID" data-type="select"
						data-validation-rule="{required:true}"
						data-validation-message="{required:$.PSNM.msg('E012', ['본사파트'])}"></select>
				</td>
            </tr>
            <tr>
                <th scope="col" class="fontred">교육주체</th>
                <td class="tleft">
                	<input id="EDUT_OWNR_NM" name="EDUT_OWNR_NM" data-bind="value:EDUT_OWNR_NM" data-type="textinput" 
	                		data-validation-rule="{required:true}" 
	                		data-validation-message="{required:$.PSNM.msg('E012', ['교육주체'])}">
                </td>
                <th scope="col" class="fontred">강사명</th>
                <td class="tleft">
                	<input id="LECTR_NM" name="LECTR_NM" data-bind="value:LECTR_NM" data-type="textinput" 
	                		data-validation-rule="{required:true}" 
	                		data-validation-message="{required:$.PSNM.msg('E012', ['강사명'])}">
                </td>
            </tr>
            <tr>
            	<th scope="col" class="fontred">시행일시</th>
                <td class="tleft" colspan="3">
                	<input id="EDU_DT" name="EDU_DT" data-bind="value:EDU_DT" data-type="dateinput" style="width:100px;" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png"
						data-validation-rule="{required:true}"
						data-validation-message="{required:$.PSNM.msg('E012', ['시행일시'])}"/>
						<select id="EDU_STA_H" name="EDU_STA_H" data-type="select" style="width:50px;"
						data-bind="options: options_EDU_STA_H, selectedOptions: EDU_STA_H">
						</select>시  
						<select id="EDU_STA_M" name="EDU_STA_M" data-type="select" style="width:50px;"
						data-bind="options: options_EDU_STA_M, selectedOptions: EDU_STA_M">
							<option value="00">00</option>
    						<option value="05">05</option>
    						<option value="10">10</option>
    						<option value="15">15</option>
    						<option value="20">20</option>
    						<option value="25">25</option>
    						<option value="30">30</option>
    						<option value="35">35</option>
    						<option value="40">40</option>
    						<option value="45">45</option>
    						<option value="50">50</option>
    						<option value="55">55</option>
						</select>분
						 ~
						<select id="EDU_END_H" name="EDU_END_H" data-type="select" style="width:50px;"
						data-bind="options: options_EDU_END_H, selectedOptions: EDU_END_H">
						</select>시  
						<select id="EDU_END_M" name="EDU_END_M" data-type="select" style="width:50px;"
						data-bind="options: options_EDU_END_M, selectedOptions: EDU_END_M">
							<option value="00">00</option>
    						<option value="05">05</option>
    						<option value="10">10</option>
    						<option value="15">15</option>
    						<option value="20">20</option>
    						<option value="25">25</option>
    						<option value="30">30</option>
    						<option value="35">35</option>
    						<option value="40">40</option>
    						<option value="45">45</option>
    						<option value="50">50</option>
    						<option value="55">55</option>
						</select>분
                </td>
            </tr>
            <tr>
            	<th scope="col">교육장소</th>
                <td class="tleft">
                	<input id="EDU_PLC_NM" name="EDU_PLC_NM" data-bind="value:EDU_PLC_NM" data-type="textinput">
                </td>
                <th scope="col">참석인원</th>
                <td class="tleft"><label data-bind="text:STU_MA_COUNT"></label></td>
            </tr>
            <tr>
            	<th scope="col" class="fontred">교육내용</th>
                <td colspan="3" class="tleft">
                	<textarea id="EDU_CTT" name="EDU_CTT" data-type="textarea" data-bind="value:EDU_CTT" rows="10" cols="80" 
                              data-validation-rule="{required:true}" 
                              data-validation-message="{required:$.PSNM.msg('E012', ['교육내용'])}" 
                              style='overflow: auto; width: 95%;'></textarea>
                </td>
            </tr>
            </tbody>
            </table>
        </form>
    </div>
    
    <!--view_list area -->
    <div class="floatL4">
		<img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>첨부파일</b> : 하단 파일을 클릭하시면 저장 및 열기가 가능합니다.
    	<div class="ab_pos1" style="float:right;">
      		<div style="position:relative;">
				<span class="file-button type1"><input id="fileupload" type="file"></span>
				<button id="btnFileDel" data-type="button" class="af-n-btn5"></button>
      		</div>
    	</div>
  	</div>
    <div id="gridfile" class="view_list" data-bind="grid:gridfile"></div>
    
    <div class="floatL4">
    	<img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>참석자현황 및 결과</b>
    	<div class="ab_pos1">
            <div style="width:95px; height: 24px; border:0px;">
                 <input id="btnGridAdd" type="button" data-type="button" class="addButton">
                 <input id="btnGridDel" type="button" data-type="button" class="inputButton">
            </div>
        </div>
    </div>
    <div id="grid1" data-bind="grid:grid1"></div>
    
    <div id="noneGrid" style="display:none;">
    	<div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>엑셀업로드 데이터 검증 실패 목록</b></div>
    	<div id="grid2" data-bind="grid:grid2"></div>
    </div>
    
    <div id="grid3" data-bind="grid:grid3" style="display:none;"></div>
    
	<!--excel area -->
	<div id="gridexceltemplate" data-bind="grid:gridexceltemplate" style="display:none;"></div><!-- 템플릿 엑셀그리드 -->
  	<div id="gridexcelimported" data-bind="grid:gridexcelimported" style="display:none;"></div><!-- 업로드 엑셀그리드 -->
</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>