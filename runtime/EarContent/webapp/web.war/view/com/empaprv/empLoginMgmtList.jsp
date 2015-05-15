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
            $a.page.setGrid();
            $a.page.setCodeData();
            $a.page.setDutyCd();
			$a.page.searchList(param);
        },
        setEventListener : function() {
            $("#btnSearch").click($a.page.searchList);
            $("#btnSave").click(function(){
            	
            	var validator = $("#form").validator();
                if ( !validator.validate() ) {
                    var errormessages = validator.getErrorMessage();
                    for(var name in errormessages) {
                        for(var i=0; i < errormessages[name].length; i++) {
                            $.PSNM.alert(errormessages[name][i]);
                            $("#form").find("#" + name).focus();
                            return false; //여기서 반환
                        }
                    }
                }
            	
            	if( $.PSNM.confirm("I004", ["저장"] ) ){
            		var requestData = $.PSNMUtils.getRequestData("form");
                	
                	$.alopex.request("com.EMPAPRV@PEMPAPPROVE001_pSaveAprove", {
                        data: requestData,
                        success: function(res) { 
                        	if(res.dataSet.fields.count != 0){
                        		$.PSNM.alert("중복된 회원ID입니다.");
            					return;
                        	}
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
                	$.alopex.request("com.EMPAPRV@PEMPAPPROVE001_pDeleteAprove", {
                		data: requestData,
                        success : function(res) {
                        	$a.page.searchList(_param);
                        }
                    });
            	}
            });
            $("#btnNew").click(function(){
            	var data = {"USER_ID":"","USER_NM":"","DUTY_CD":"","JOB_DESC":"","HEADQ_YN":"N","SMS_YN":"N"}
            	$("#form").setData(data);
				$("#detail").show();
				$("#form").find("#FLAG").val("I");
				$("#form").find("#USER_ID").setEnabled(true);
            });
            $("#form").find("#USER_ID").keypress(function(event){
            	if ( event.which == 13 ) {
            		if($.PSNMUtils.isEmpty($("#form").find("#USER_ID").val())){
            			$.PSNM.alert("회원ID를 입력해주세요.");
        				$("#form").find("#USER_ID").focus();
        				return;
        			}	
        		  	
        		  	$.alopex.request("com.EMPAPRV@PEMPAPPROVE001_pSearchAproveUser", {
        		  		data: {dataSet: {fields: {USER_ID : $("#form").find("#USER_ID").val()}}},
                        success : function(res) {
                        	
                        	var resultData = res.dataSet.recordSets.grid.nc_list;
                        	if($.PSNMUtils.isEmpty(resultData)){
                        		$.PSNM.alert("존재하지않는 회원 ID입니다.");
                        		$("#form").find("#USER_ID").val("");
                        		$("#form").find("#USER_NM").val("");
                        		return;
                        	}
                        	
                        	for(var i=0 ; i<resultData.length ; i++) {
                        		$("#form").find("#USER_NM").val(resultData[i].USER_NM);
                        		$("#form").find("#DUTY_CD").setSelected(resultData[i].DUTY_CD);
            				}
                        }
                    });
            	}
            });
            $("#btnExcelPage").click(function(){
            	var oExcelMetaInfo = {
                        filename  : "임직원로그인관리.xls",
                        sheetname : "임직원로그인관리",
                        gridname  : "grid" //그리드ID 
                    };
            	
            	$.PSNMUtils.downloadExcelPage("grid", oExcelMetaInfo,[0,1,2]);
            });
        },
        setGrid : function() {
            $("#grid").alopexGrid({
                pager: false,
                rowSingleSelect : false,
                rowClickSelect : true,
                rowInlineEdit : true,
                height : "400px",
                columnMapping : [
					{ columnIndex : 0, selectorColumn : true, 		width : "30px" },
					{ columnIndex : 1, numberingColumn : true,		title : "번호",		align : "center",	width : "30px" },
					{ columnIndex : 2, key : "FLAG", 				hidden : true  
						, value : function(value, data) {
                            if ( "I" == value || "D" == value ) { return value; } //추가|삭제는 그냥둠
                            return ( (data._state.edited) ? 'U' : '' ); 
                        }	
					},
                    { columnIndex : 3, key : "USER_ID",				title : "회원ID",		align : "center", 	width : "80px"	},
                    { columnIndex : 4, key : "HDQT_TEAM_ORG_NM",	title : "본사팀",		align : "center", 	width : "100px"	},
                    { columnIndex : 5, key : "HDQT_PART_ORG_NM",	title : "본사파트",		align : "center", 	width : "100px"	},
                    { columnIndex : 6, key : "USER_NM",				title : "임직원명",		align : "center", 	width : "100px"	},
                    { columnIndex : 7, key : "HEADQ_YN",			title : "사무국여부",	align : "center", 	width : "100px"	},
                    { columnIndex : 8, key : "SMS_YN",			    title : "문자수신여부<br/>※ 문자발송화면적용",	align : "center", 	width : "100px"	},
                    { columnIndex : 9, key : "JOB_DESC",			title : "담당업무",		align : "left", 	width : "150px"	},
                    { columnIndex : 10, key : "DUTY_NM",			title : "직무",			align : "left", 	width : "120px"	},
                    { columnIndex : 11, key : "RGST_DTM",			title : "등록일자",		align : "left", 	width : "100px"	}
            	],
                on : {
                    "cell" : {
    					"click" : function(data, eh, e) {
    						if(data._index.column != 0) {
    							$("#form").setData(data);
    							$("#detail").show();
    							$("#form").find("#FLAG").val("U");
    							$("#form").find("#USER_ID").setEnabled(false);
    						}
    					}
    				}
                }
            });
        },
        setCodeData : function() {
            $.PSNMUtils.setCodeData([
				{ t:'code', 'elemid' : 'HEADQ_YN', 	 'codeid' : 'DSM_YN_CD' }, 
				{ t:'code', 'elemid' : 'SMS_YN', 	 'codeid' : 'DSM_YN_CD' },
				{ t:'code', 'elemid' : 'W_HEADQ_YN', 'codeid' : 'DSM_YN_CD', 'header' : '-전체-'  }, 
				{ t:'code', 'elemid' : 'W_SMS_YN', 	 'codeid' : 'DSM_YN_CD', 'header' : '-전체-'  }
            ]);
        },
        setDutyCd : function() {
        	$.alopex.request("com.EMPAPRV@PEMPAPPROVE001_pSearchDutyMgmt", {
	        	success: function(res) {
	                var codeList = res.dataSet.recordSets.resultList.nc_list;
	
	                var codeOptions = [];
	                    codeOptions.push({ value: "", text: "-전체-"});
	
	                $.each(codeList, function (index, codeinfo) {
	                    var codeOpt = new Object();
	                        codeOpt["value"] = codeinfo.DUTY_CD;
	                        codeOpt["text"]  = codeinfo.DUTY_NM;
	                    codeOptions.push(codeOpt);
	                });
	                var optData = new Object();
	                    optData["options_DUTY_CD"] = codeOptions;
	                    
	                $("#DUTY_CD").setData(optData);
	                    
	                var wOptData = new Object();
	                	wOptData["options_W_DUTY_CD"] = codeOptions;
	
	                $("#W_DUTY_CD").setData(wOptData);
	                
	            }
            });
        },
        searchList: function(param) {
        	$("#detail").hide();
            $.alopex.request("com.EMPAPRV@PEMPAPPROVE001_pSearchAprove", {
                data: "#searchTable",
                success: ["#grid", "#HEADQ_CNT", "#NON_HEADQ_CNT", function(res) {
                }]
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
            <span class="txt6_img"><b id="sub-title">임직원로그인관리</b>
                <span class="notice-more"> 
                	<img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif">
                	<span class="a2">본사업무</span> <span class="a3"> > </span> <span class="a4"><b>공통관리</b></span> 
                </span>
            </span>
        </div>
    </div>

    <!-- find condition area -->
    <div id="searchDiv" class="textAR">
       	<table id="searchTable" class="board02" style="width:92%;">
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
       	<tbody>
       	<tr>
			<th>본사팀</th>
			<td class="tleft">
				<select id="HDQT_TEAM_ORG_ID" data-bind="options:options_HDQT_TEAM_ORG_ID, selectedOptions: HDQT_TEAM_ORG_ID" data-type="select" >
					<option value="">-전체-</option>
				</select>
			</td>
			<th>본사파트</th>
			<td class="tleft">
				<select id="HDQT_PART_ORG_ID" data-bind="options:options_HDQT_PART_ORG_ID, selectedOptions: HDQT_PART_ORG_ID" data-type="select" >
					<option value="">-전체-</option>
				</select>
			</td>
			<th scope="col">직무</th>
			<td class="tleft" colspan="3">
				<select id="W_DUTY_CD" data-bind="options: options_W_DUTY_CD, selectedOptions: W_DUTY_CD" data-type="select"></select>
			</td>
		</tr>
       	<tr>
            <th>회원ID</th>
			<td class="tleft">
				<input id="USER_ID" name="USER_ID" data-bind="value:USER_ID" data-type="textinput" style="width:100px;" />
            </td>
			<th>임직원명</th>
			<td class="tleft">
            	<input id="USER_NM" name="USER_NM" data-bind="value:USER_NM" data-type="textinput" style="width:100px;" />
            </td>
            <th scope="col">사무국여부</th>
			<td class="tleft">
				<select id="W_HEADQ_YN" name="W_HEADQ_YN" data-type="select" style="width:70px;"
				data-bind="options: options_W_HEADQ_YN, selectedOptions: W_HEADQ_YN"></select>
			</td>
			<th scope="col">문자수신</th>
			<td class="tleft">
				<select id="W_SMS_YN" name="W_SMS_YN" data-type="select" style="width:70px;"
				data-bind="options: options_W_SMS_YN, selectedOptions: W_SMS_YN"></select>
			</td>
		</tr>
       	</tbody>
        </table>
		<div class="ab_pos5">
			<button id="btnSearch" type="button" data-type="button" data-theme="af-psnm" data-authtype="R"></button>
		</div>
    </div>
    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>임직원로그인관리</b>
     (사무국&nbsp;<label id="HEADQ_CNT" data-bind="text:HEADQ_CNT">0</label>&nbsp;명, 비사무국&nbsp;<label id="NON_HEADQ_CNT" data-bind="text:NON_HEADQ_CNT">0</label>&nbsp;명)
        <div class="ab_pos2">
        	<button id="btnNew" type="button" data-type="button" data-theme="af-btn2" data-altname="신규" data-authtype="W"></button>
	        <button id="btnDel"  type="button" data-type="button" data-theme="af-btn13" data-altname="삭제" data-authtype="W"></button>
        	<button id="btnSave" type="button" data-type="button" data-theme="af-btn4" data-altname="저장" data-authtype="W"></button>
        	<button id="btnExcelPage" type="button" data-type="button" data-theme="af-btn3" data-altname="엑셀다운" data-authtype="W"></button>
        </div>
    </div>

    <!-- main grid -->
    <div id="grid" data-bind="grid:grid"></div>
    
	<div id="detail" style="display: none;">
		<div class="floatL4">
			<img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"/><b>임직원관리상세</b>&nbsp;&nbsp;&nbsp;&nbsp;
			<font size="2" color="red">회원ID 입력 후 ENTER를 누르세요. </font>
		</div>
		<form id="form" onsubmit="return false;">
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
				<th scope="col" class="fontred">회원ID</th>
				<td class="tleft">
					<input id="USER_ID" name="USER_ID" data-bind="value:USER_ID" data-type="textinput" data-disabled="true"
						data-validation-rule="{required:true}"
						data-validation-message="{required:$.PSNM.msg('E012', ['회원ID'])}"/>
				</td>
				<th scope="col">임직원명</th>
				<td class="tleft">
					<input id="USER_NM" name="USER_NM" data-bind="value:USER_NM" data-type="textinput" data-disabled="true"/>
				</td>
				<th scope="col" class="fontred">직무</th>
				<td class="tleft">
					<select id="DUTY_CD" data-bind="options: options_DUTY_CD, selectedOptions: DUTY_CD" data-type="select"
						data-validation-rule="{required:true}"
						data-validation-message="{required:$.PSNM.msg('E012', ['직무'])}"></select>
				</td>
				<th scope="col">사무국여부</th>
				<td class="tleft">
					<select id="HEADQ_YN" name="HEADQ_YN" data-type="select" style="width:50px;" 
						data-bind="options: options_HEADQ_YN, selectedOptions: HEADQ_YN"
						data-validation-rule="{required:true}"
						data-validation-message="{required:$.PSNM.msg('E012', ['사무국배정'])}"></select>
				</td>
			</tr>
			<tr>
				<th scope="col">담당업무</th>
				<td class="tleft" colspan="5">
					<input id="JOB_DESC" name="JOB_DESC" data-bind="value:JOB_DESC" data-type="textinput" style="width:706px;"/>
				</td>
				<th scope="col">문자수신</th>
				<td class="tleft">
					<select id="SMS_YN" name="SMS_YN" data-type="select" style="width:50px;" 
						data-bind="options: options_SMS_YN, selectedOptions: SMS_YN"
						data-validation-rule="{required:true}"
						data-validation-message="{required:$.PSNM.msg('E012', ['SMS수신'])}"></select>
				</td>
			</tr>
		</table>
		</form>
	</div>    

</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>