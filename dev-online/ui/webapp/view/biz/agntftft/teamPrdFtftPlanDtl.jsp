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
            
            _param = param; //이 페이지로 전달된 파라미터를 저장

            $a.page.setEventListener();
            $a.page.setCodeData();
            $a.page.setViewData();
        },
        setEventListener : function() {
            $("#btnSave").click(function(){
            	
            	var now = new Date();
        		var CNSL_DL_DT = $("#CNSL_DL_DT").val();
        		if(Number(now.getDate()) > CNSL_DL_DT ){
        			$.PSNM.alert("월 면담 계획 작성 기간이 초과되었습니다.\n(매월 "+CNSL_DL_DT+"일까지 가능)\n수시면담으로 작성하세요.");
        			return;
        		}
            	
            	if ( ! $.PSNM.isValid("#form") ) {
				    return false; //값 검증
				}
            	
            	var startDt = $("#CNSL_STA_TM").getValues() + $("#CNSL_STA_M").getValues();
				var endDt = $("#CNSL_END_TM").getValues() + $("#CNSL_END_M").getValues();
				
				if(startDt > endDt || startDt == endDt){
					$.PSNM.alert("면담예정일시 시/분을 다시 입력해 주십시오.");
            		return;
				}
               	
               	//1인당 2회까지 입력이 가능하다.
       			var requestData = $.PSNMUtils.getRequestData("form");
       			$.alopex.request("biz.AGNTFTFT@PAGENTCNSLPLN001_pDetailAgentCnslPlnInputYn", {
               		data: requestData,
                       success : function(res) {
                       	if( res.dataSet.fields.INPUT_YN === "N" ) {
           					var errMsg = $("#USER_NM").val() + "님은 " + $("#CNSL_DT").val().substr(0, 7) + "월에 이미 2건 이상의 면담계획을 수립하였습니다.";
           					$.PSNM.alert( errMsg );
           					return;
           				}
                       	
                      	//조사한 뒤, 2번이상 면담을 안했다면 아래 저장 함수 호출
                       	if(  $.PSNM.confirm("I004", ["저장"] ) ){
                           	$.alopex.request("biz.AGNTFTFT@PAGENTCNSLPLN001_pSaveAgentCnslPln", {
        	                    data: requestData,
        	                    success: function(res) { 
        	                        $a.navigate("teamPrdFtftList.jsp", _param);
        	                    }
                        	});
                   		}
                	}
				});
            });
			$("#btnSaveCnsl").click(function(){
            	
				if ( ! $.PSNM.isValid("#form2") ) {
				    return false; //값 검증
				}
				
				var startDt = $("#CNSL_STA_TM2").getValues() + $("#CNSL_STA_M2").getValues();
				var endDt = $("#CNSL_END_TM2").getValues() + $("#CNSL_END_M2").getValues();
				
				if(startDt > endDt || startDt == endDt){
					$.PSNM.alert("면담일시 시/분을 다시 입력해 주십시오.");
            		return;
				}
               	
               	if($("#CNSL_SUIT_CD").getValues() == "02"){
               		if($.PSNMUtils.isEmpty($("#CNSL_SUIT_RSN_NM").val())){
               			$.PSNM.alert("부적합 사유를  입력해주세요.");
        				$("#CNSL_SUIT_RSN_NM").focus();
        				return;
               		}
               	}
                       	
               	if(  $.PSNM.confirm("I004", ["저장"] ) ){
               		var requestData = $.PSNMUtils.getRequestData("form", "form2");
                   	$.alopex.request("biz.AGNTFTFT@PAGENTCNSL001_pSaveAgentCnsl", {
	                    data: requestData,
	                    success: function(res) { 
	                        $a.navigate("teamPrdFtftList.jsp", _param);
	                    }
                	});
           		}
            });
            $("#btnCnsl").click(function(){
            	
            	//1인당 2회까지 입력이 가능하다.
    			var requestData = $.PSNMUtils.getRequestData("form");
    			$.alopex.request("biz.AGNTFTFT@PAGENTCNSLPLN001_pDetailAgentCnslPlnCnslYn", {
            		data: requestData,
                    success : function(res) {
                    	if( res.dataSet.fields.CNSL_YN === "N" ) {
                    		var errMsg = "정기면담 등록기간을 초과하였습니다. 초과시에는 수시면담으로만 등록 가능합니다";
                    		$.PSNM.alert( errMsg );
        					return;
        				}
                    	
                		$a.navigate("prdFtftCnslDtl.jsp", _param);
                    }
                });
            });
            $("#btnDel").click(function(){
            	if(  $.PSNM.confirm("I004", ["삭제"] ) ){
            		var id = _param.data != null ? _param.data.AGENT_CNSL_PLN_NUM : "";
                	$.alopex.request("biz.AGNTFTFT@PAGENTCNSLPLN001_pDeleteAgentCnslPln", {
                		data: {dataSet: {fields: {AGENT_CNSL_PLN_NUM : id}}},
                        success : function(res) {
                        	$a.navigate("teamPrdFtftList.jsp", _param);
                        }
                    });
            	}
            });
            $("#btnList").click(function(){
            	$a.back(_param);
            });
            $("#btnFindAgent").click(function(){
            	
            	var id = _param.data != null ? _param.data.AGENT_CNSL_PLN_NUM : "";
            	if(!$.PSNMUtils.isEmpty(id)){
            		$.PSNM.alert("면담대상 회원은 수정할 수 없습니다.");
        			return;
            	}
            	
            	$a.session('alopex_parameters', '');
            	var oParam = new Object();
            	$.PSNMAction.popFindAgent(oParam, function(oResult) {
                    if ( oResult!=null && typeof oResult == "object" ) {
                        $("#USER_NM").val( oResult["USER_NM"] );
                        $("#USER_ID").val( oResult["USER_ID"] );
                        $("#DUTY_NM").val( oResult["DUTY_NM"] );
                        $("#RPSTY_NM").val( oResult["RPSTY_NM"] );
                        $("#HDQT_TEAM_ORG_NM").val( oResult["HDQT_TEAM_ORG_NM"] );
                        $("#HDQT_TEAM_ORG_ID").val( oResult["HDQT_TEAM_ORG_ID"] );
                        $("#HDQT_PART_ORG_NM").val( oResult["HDQT_PART_ORG_NM"] );
                        $("#HDQT_PART_ORG_ID").val( oResult["HDQT_PART_ORG_ID"] );
                        $("#SALE_DEPT_ORG_NM").val( oResult["SALE_DEPT_ORG_NM"] );
                        $("#SALE_DEPT_ORG_ID").val( oResult["SALE_DEPT_ORG_ID"] );
                        $("#SALE_TEAM_ORG_NM").val( oResult["SALE_TEAM_ORG_NM"] );
                        $("#SALE_TEAM_ORG_ID").val( oResult["SALE_TEAM_ORG_ID"] );
                    }
                });
            });
            /*
            $("#CNSL_DT").change(function(){
            	var now = new Date();
        		var dateArray = $(this).val().split("-"); 
        		var CNSL_DT = dateArray[0]+dateArray[1]+dateArray[2];
        		var CNSL_DL_DT = $("#CNSL_DL_DT").val();
        		
        		if(dateArray[1] == now.getMonth()+1 && Number(now.getDate()) > CNSL_DL_DT ){
        			alert(dateArray[1]+"월 면담 계획 작성 기간이 초과되었습니다.(매월 "+CNSL_DL_DT+"일까지 가능)\n수시면담으로 작성하세요.");
        			$("#CNSL_DT").val("");
        			return;
        		}
            });
            */
            $("#CNSL_SUIT_CD").change(function(){
            	if($(this).getValues() == "02"){
            		$("#CNSL_SUIT_RSN_NM").setEnabled(true);
            	}else{
            		$("#CNSL_SUIT_RSN_NM").setEnabled(false);
            		$("#CNSL_SUIT_RSN_NM").val("");
            	}
            });
        },
        setViewData : function() {
        	var userId 				= _param.data != null ? _param.data.USER_ID : "";
        	var plnNum 				= _param.data != null ? _param.data.AGENT_CNSL_PLN_NUM : "";
        	var agentCnslMgmtNum 	= _param.data != null ? _param.data.AGENT_CNSL_MGMT_NUM : ""; //면담번호
       		var cnslActCd 			= _param.data != null ? _param.data.CNSL_ACT_CD : "";
        	
       		$.alopex.request("biz.AGNTFTFT@PAGENTCNSLPLN001_pDetailAgentCnslPlnCnslDlDt", {
        		data: {dataSet: {fields: {DSM_WEB_STRD_CD_VAL : '04'}}}, //기본값설정 코드 '04'에 지정된 값을 기준으로 면담 확정일자 값 가져옴
                success : function(res) {
                    $("#CNSL_DL_DT").val(res.dataSet.fields.CNSL_DL_DT);
                }
            });
        	
        	//면담완료 건은 수정 불가
    		if(cnslActCd == "완료"){
    			$("#cnslPln").show();
    			$("#btnSaveCnsl").show();
    			$("#btnSave").hide();
    			$("#btnCnsl").hide();
    			$("#btnDel").hide();
    			$("#btnFindAgent").setEnabled(false);
    			$("#CNSL_DT").setEnabled(false);
    			$("#CNSL_STA_TM").setEnabled(false);
    			$("#CNSL_END_TM").setEnabled(false);
    			$("#CNSL_STA_M").setEnabled(false);
    			$("#CNSL_END_M").setEnabled(false);
    			$("#CNSL_PLC_NM").setEnabled(false);
    			$("#CNSL_RSN_NM").setEnabled(false);
    			$("#CNSL_RSN_CD").setEnabled(false);
    		}
        	
    		if($.PSNM.getSession("DUTY")=='14' || $.PSNM.getSession("DUTY")=='16' || $.PSNM.getSession("DUTY")=='19' || $.PSNM.getSession("DUTY")=='20'){	
        		$("#CNSL_SUIT_CD").setEnabled(false);
        		$("#CNSL_SUIT_RSN_NM").setEnabled(false);
    		}
        	
        	if($.PSNMUtils.isNotEmpty(plnNum)){
        		$.alopex.request("biz.AGNTFTFT@PAGENTCNSLPLN001_pDetailAgentCnslPln", {
            		data: {dataSet: {fields: {USER_ID : userId, AGENT_CNSL_PLN_NUM : plnNum, AGENT_CNSL_MGMT_NUM : agentCnslMgmtNum}}},
                    success:["#form", "#form2",  function(res) {
                    	
                    	//면담자와 로그인한 사용자가 같다면 , 그리고 로그인 사용자가 팀장이라면 면담 버튼을 활성화한다.
        				if( ($("#CNSLR_ID").val() === $.PSNM.getSession("USER_ID") && (PsnmUser.isDirector() || PsnmUser.isTeamLeader() || PsnmUser.isStaff())) && cnslActCd=="미완료") {
        					$("#btnCnsl").show();
        				} else {
        					$("#btnCnsl").hide();
        				}
                    	
        				if(!$.PSNMUtils.isEmpty(agentCnslMgmtNum)){
        					if(res.dataSet.fields.CNSL_SUIT_CD == "02"){
                        		$("#CNSL_SUIT_RSN_NM").setEnabled(true);
                        	}else{
                        		$("#CNSL_SUIT_RSN_NM").setEnabled(false);
                        	}
                    	}
        				
        				$("#textlimit").html(calculate_msglen($("#CNSL_CTT").val()));
                    }]
                });
        	}else{
        		$("#btnDel").hide();
        		$("#CNSLR_ID").val($.PSNM.getSession("USER_ID"));
        		$("#CNSLR_NM").val($.PSNM.getSession("USER_NM"));
        		$("#CNSLR_DUTY_NM").val($.PSNM.getSession("DUTY_NM"));
        		$("#CNSLR_RPSTY_NM").val($.PSNM.getSession("RPSTY_NM"));
        	}
        },
        setCodeData : function() {
        	$.PSNMUtils.setCodeData([
				{ t:'code', 'elemid' : 'CNSL_STA_TM', 	'codeid' : 'DSM_TM_CD' },
				{ t:'code', 'elemid' : 'CNSL_END_TM', 	'codeid' : 'DSM_TM_CD' },
				{ t:'code', 'elemid' : 'CNSL_STA_TM2', 	'codeid' : 'DSM_TM_CD' },
				{ t:'code', 'elemid' : 'CNSL_END_TM2', 	'codeid' : 'DSM_TM_CD' },
				{ t:'code', 'elemid' : 'CNSL_SUIT_CD', 	'codeid' : 'DSM_CNSL_SUIT_CD' },
				{ t:'code', 'elemid' : 'CNSL_RSN_CD', 	'codeid' : 'DSM_CNSL_RSN_CD' }
            ]);
        }
    });
    </script>

</head>

<body>


<jsp:include page="/view/layouts/default_header.jsp" flush="false" />

<!-- contents area -->
<div id="contents">

    <!-- title area -->
    <div class="content_title">
        <div class="ub_txt6">
            <span class="txt6_img"><b>면담계획/정기면담</b><span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif"> 
            <span class="a2">영업팀업무</span> <span class="a3"> > </span><b>에이전트관리</b></span></span> 
        </div>
    </div>
    
    <!-- btn area -->
    <div class="btn_area">
        <div class="ab_btn_right">
        	<button id="btnCnsl" type="button" data-type="button" data-theme="af-n-btn1" data-altname="면담" data-authtype="W" style="display:none;"></button>
            <button id="btnDel"  type="button" data-type="button" data-theme="af-btn13" data-altname="삭제" data-authtype="W"></button>
            <button id="btnSave" type="button" data-type="button" data-theme="af-btn4"  data-altname="저장" data-authtype="W"></button>
            <button id="btnSaveCnsl" type="button" data-type="button" data-theme="af-btn4" data-altname="저장" data-authtype="W" style="display:none;"></button>
            <button id="btnList" type="button" data-type="button" data-theme="af-btn14" data-altname="목록" data-authtype="R"></button>
        </div>
    </div>
    <!-- btn area end-->
    
	<!--view_table area -->
    <div class="view_list">
	
	    <form id="form" onsubmit="return false;">
	    	<input id="AGENT_CNSL_PLN_NUM" name="AGENT_CNSL_PLN_NUM" data-bind="value:AGENT_CNSL_PLN_NUM" type="hidden">
	    	<input id="AGENT_CNSL_MGMT_NUM" name="AGENT_CNSL_MGMT_NUM" data-bind="value:AGENT_CNSL_MGMT_NUM" type="hidden">
	    	<input id="CNSL_DL_DT" name="CNSL_DL_DT" type="hidden">
	    
	    	<div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"/><b>면담자</b></div>
	        <table class="board02" style="width:100%;">
	        	<colgroup>
		            <col style="width:15%"/>
		            <col style="width:35%"/>
		            <col style="width:15%"/>
		            <col style="width:*"/>
	            </colgroup>
	        	<tr>
	            	<th scope="col" class="fontred">에이전트</th>
					<td class="tleft">
						<input id="CNSLR_NM" name="CNSLR_NM" data-bind="value:CNSLR_NM" data-type="textinput" data-disabled="true" style="width:130px;"
						data-validation-rule="{required:true}"
						data-validation-message="{required:$.PSNM.msg('E012', ['면담자'])}"/>
						<input id="CNSLR_ID" name="CNSLR_ID" data-bind="value:CNSLR_ID" data-type="textinput" data-disabled="true" style="width:75px;"/>
					</td>
					<th scope="col">직책명</th>
					<td class="tleft">
						<input id="CNSLR_DUTY_NM" name="CNSLR_DUTY_NM" data-bind="value:CNSLR_DUTY_NM" data-type="textinput" data-disabled="true" style="width:150px;"/>
						<input id="CNSLR_RPSTY_NM" name="CNSLR_RPSTY_NM" data-bind="value:CNSLR_RPSTY_NM" data-type="textinput" data-disabled="true" style="width:75px;"/>
					</td>
	         	</tr>
	        </table>
	        
	        <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"/><b>면담대상자</b></div>
	        <table class="board02" style="width:100%;">
	        	<colgroup>
		            <col style="width:15%"/>
		            <col style="width:35%"/>
		            <col style="width:15%"/>
		            <col style="width:*"/>
	            </colgroup>
	        	<tr>
					<th scope="col" class="fontred">에이전트</th>
					<td class="tleft">
						<input id="USER_NM" name="USER_NM" data-bind="value:USER_NM" data-type="textinput" data-disabled="true" style="width:130px;"
						data-validation-rule="{required:true}"
						data-validation-message="{required:$.PSNM.msg('E012', ['면담대상'])}"/>
						<input id="btnFindAgent" type="button" data-type="button" class="searchButton">
						<input id="USER_ID" name="USER_ID" data-bind="value:USER_ID" data-type="textinput" data-disabled="true" style="width:75px;"/>
					</td>
					<th scope="col">직책명</th>
					<td class="tleft">
						<input id="DUTY_NM" name="DUTY_NM" data-bind="value:DUTY_NM" data-type="textinput" data-disabled="true" style="width:150px;"/>
						<input id="RPSTY_NM" name="RPSTY_NM" data-bind="value:RPSTY_NM" data-type="textinput" data-disabled="true" style="width:75px;"/>
					</td>
				</tr>
				<tr>
					<th scope="col">본사팀</th>
					<td class="tleft">
						<input id="HDQT_TEAM_ORG_NM" name="HDQT_TEAM_ORG_NM" data-bind="value:HDQT_TEAM_ORG_NM" data-type="textinput" data-disabled="true" style="width:150px;"/>
						<input id="HDQT_TEAM_ORG_ID" name="HDQT_TEAM_ORG_ID" data-bind="value:HDQT_TEAM_ORG_ID" data-type="textinput" data-disabled="true" style="width:75px;"/>
					</td>
					<th scope="col">본사파트</th>
					<td class="tleft">
						<input id="HDQT_PART_ORG_NM" name="HDQT_PART_ORG_NM" data-bind="value:HDQT_PART_ORG_NM" data-type="textinput" data-disabled="true" style="width:150px;"/>
						<input id="HDQT_PART_ORG_ID" name="HDQT_PART_ORG_ID" data-bind="value:HDQT_PART_ORG_ID" data-type="textinput" data-disabled="true" style="width:75px;"/>
					</td>
				</tr>
				<tr>
					<th scope="col">영업국명</th>
					<td class="tleft">
						<input id="SALE_DEPT_ORG_NM" name="SALE_DEPT_ORG_NM" data-bind="value:SALE_DEPT_ORG_NM" data-type="textinput" data-disabled="true" style="width:150px;"/>
						<input id="SALE_DEPT_ORG_ID" name="SALE_DEPT_ORG_ID" data-bind="value:SALE_DEPT_ORG_ID" data-type="textinput" data-disabled="true" style="width:75px;"/>
					</td>	
					<th scope="col">영업팀명</th>
					<td class="tleft">
						<input id="SALE_TEAM_ORG_NM" name="SALE_TEAM_ORG_NM" data-bind="value:SALE_TEAM_ORG_NM" data-type="textinput" data-disabled="true" style="width:150px;"/>
						<input id="SALE_TEAM_ORG_ID" name="SALE_TEAM_ORG_ID" data-bind="value:SALE_TEAM_ORG_ID" data-type="textinput" data-disabled="true" style="width:75px;"/>
					</td>
				</tr>
	        </table>
	        
	        <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"/><b>면담계획</b></div>
	        <table class="board02" style="width:100%;">
	        	<colgroup>
		            <col style="width:15%"/>
		            <col style="width:45%"/>
		            <col style="width:15%"/>
		            <col style="width:*"/>
	            </colgroup>
	        	<tr>
					<th scope="col" class="fontred">면담예정일시</th>
					<td class="tleft">
						<input id="CNSL_DT" name="CNSL_DT" data-bind="value:CNSL_DT" data-type="dateinput" style="width:100px;" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png"
						data-validation-rule="{required:true}"
						data-validation-message="{required:$.PSNM.msg('E012', ['면담예정일시'])}"/>
						<select id="CNSL_STA_TM" name="CNSL_STA_TM" data-type="select" style="width:50px;"
						data-bind="options: options_CNSL_STA_TM, selectedOptions: CNSL_STA_TM">
						</select>시 
						<select id="CNSL_STA_M" name="CNSL_STA_M" data-type="select" style="width:50px;"
						data-bind="options: options_CNSL_STA_M, selectedOptions: CNSL_STA_M">
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
						<select id="CNSL_END_TM" name="CNSL_END_TM" data-type="select" style="width:50px;"
						data-bind="options: options_CNSL_END_TM, selectedOptions: CNSL_END_TM">
						</select>시
						<select id="CNSL_END_M" name="CNSL_END_M" data-type="select" style="width:50px;"
						data-bind="options: options_CNSL_END_M, selectedOptions: CNSL_END_M">
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
					<th scope="col" class="fontred">면담예정장소</th>
					<td class="tleft">
						<input id="CNSL_PLC_NM" name="CNSL_PLC_NM" data-bind="value:CNSL_PLC_NM" data-type="textinput" style="width:150px;"
						data-validation-rule="{required:true}"
						data-validation-message="{required:$.PSNM.msg('E012', ['면담예정장소'])}"/>
					</td>
				</tr>
				<tr>
					<th scope="col">면담목적</th>
					<td class="tleft" colspan="3">
						<input id="CNSL_RSN_NM" name="CNSL_RSN_NM" data-bind="value:CNSL_RSN_NM" data-type="textinput" style="width:150px;"
						data-validation-rule="{minlength:3}"
						data-validation-message="{minlength:$.PSNM.msg('E013', ['면담목적','3'])}"/>
					</td>
				</tr>
	        </table>
	    </form>
	    
	    <form id="form2">
	    	<div id="cnslPln" style="display:none;">
	        <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"/><b>면담일지</b></div>
	        <table class="board02" style="width:100%;">
	        	<colgroup>
		            <col style="width:15%"/>
		            <col style="width:45%"/>
		            <col style="width:15%"/>
		            <col style="width:*"/>
	            </colgroup>
	        	<tr>
					<th scope="col" class="fontred">면담일시</th>
					<td class="tleft">
						<input id="CNSL_DT2" name="CNSL_DT2" data-bind="value:CNSL_DT2" data-type="dateinput" style="width:100px;" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png"
						data-validation-rule="{required:true}"
						data-validation-message="{required:$.PSNM.msg('E012', ['면담일시'])}"/>
						<select id="CNSL_STA_TM2" name="CNSL_STA_TM2" data-type="select" style="width:50px;"
						data-bind="options: options_CNSL_STA_TM2, selectedOptions: CNSL_STA_TM2">
						</select>시
						<select id="CNSL_STA_M2" name="CNSL_STA_M2" data-type="select" style="width:50px;"
						data-bind="options: options_CNSL_STA_M2, selectedOptions: CNSL_STA_M2">
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
						<select id="CNSL_END_TM2" name="CNSL_END_TM2" data-type="select" style="width:50px;"
						data-bind="options: options_CNSL_END_TM2, selectedOptions: CNSL_END_TM2">
						</select>시
						<select id="CNSL_END_M2" name="CNSL_END_M2" data-type="select" style="width:50px;"
						data-bind="options: options_CNSL_END_M2, selectedOptions: CNSL_END_M2">
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
					<th scope="col" class="fontred">면담장소</th>
					<td class="tleft">
						<input id="CNSL_PLC_NM2" name="CNSL_PLC_NM2" data-bind="value:CNSL_PLC_NM2" data-type="textinput" style="width:150px;"
						data-validation-rule="{required:true}"
						data-validation-message="{required:$.PSNM.msg('E012', ['면담장소'])}"/>
					</td>
				</tr>
				<tr>
					<th scope="col" class="fontred">면담유형/면담목적</th>
					<td class="tleft">
						<select id="CNSL_RSN_CD" name="CNSL_RSN_CD" data-type="select" style="width:70px;"
						data-bind="options: options_CNSL_RSN_CD, selectedOptions: CNSL_RSN_CD"
						data-validation-rule="{required:true}"
						data-validation-message="{required:$.PSNM.msg('E012', ['면담유형'])}">
						</select>
						<input id="CNSL_RSN_NM2" name="CNSL_RSN_NM2" data-bind="value:CNSL_RSN_NM2" data-type="textinput" style="width:150px;"
						data-validation-rule="{required:true, minlength:3}"
						data-validation-message="{required:$.PSNM.msg('E012', ['면담목적']) ,minlength:$.PSNM.msg('E013', ['면담목적','3'])}"/> 
					</td>
					<th scope="col">적합여부</th>
					<td class="tleft">
						<select id="CNSL_SUIT_CD" name="CNSL_SUIT_CD" data-type="select" style="width:70px;"
						data-bind="options: options_CNSL_SUIT_CD, selectedOptions: CNSL_SUIT_CD"></select>
						<input id="CNSL_SUIT_RSN_NM" name="CNSL_SUIT_RSN_NM" data-bind="value:CNSL_SUIT_RSN_NM" data-type="textinput" style="width:150px;"/>
					</td>
				</tr>
	        </table>
	        <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"/><b>면담내용</b></div>
		  	<div class="textAR">
		    	<textarea id="CNSL_CTT" name="CNSL_CTT" data-bind="value:CNSL_CTT" cols="40" rows="6" style="width:100%" data-theme="af-textarea" onkeyup="updateChar(this);" onkeydown="updateChar(this);"
		    	data-validation-rule="{required:true, minlength:100}"
				data-validation-message="{required:$.PSNM.msg('E012', ['면담내용']) ,minlength:$.PSNM.msg('E013', ['면담내용','100'])}"></textarea>
		    	<span id="textlimit">0</span>/100 <font size="2" color="red">100자 이상 입력 필수.</font>
		  	</div>
		  	</div>
	    </form>
	    
	</div>
</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>