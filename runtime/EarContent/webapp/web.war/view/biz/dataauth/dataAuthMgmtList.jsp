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
            $a.page.setAuthPart();
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
                            return false;
                        }
                    }
                }
            	
            	if( $.PSNM.confirm("I004", ["저장"] ) ){
            		var requestData = $.PSNMUtils.getRequestData("form");
                	$.alopex.request("biz.DATAAUTH@PDATAAUTH001_pSaveDataAuth", {
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
                	$.alopex.request("biz.DATAAUTH@PDATAAUTH001_pDeleteDataAuth", {
                		data: requestData,
                        success : function(res) {
                        	$a.page.searchList(_param);
                        }
                    });
            	}
            });
            $("#btnNew").click(function(){
            	var data = {"USER_ID":"","USER_NM":"","HDQT_TEAM_ORG_NM":"","HDQT_PART_ORG_NM":"","AUTH_STA_DT":"","AUTH_END_DT":"","OUT_ORG_ID":""}
            	$("#form").setData(data);
				$("#detail").show();
				$("#form").find("#FLAG").val("I");
				$("#form").find("#USER_NM").setEnabled(true);
            });
            $("#form").find("#USER_NM").keypress(function(event){
            	if ( event.which == 13 ) {
            		if($.PSNMUtils.isEmpty($("#form").find("#USER_NM").val())){
            			$.PSNM.alert("임직원명을 입력해주세요.");
        				$("#form").find("#USER_NM").focus();
        				return;
        			}
            		
            		var param = new Object();
            		param["USER_NM"] = $("#form").find("#USER_NM").val();
            		
        		  	$.alopex.request("biz.DATAAUTH@PDATAAUTH001_pSearchDataAuthUser", {
        		  		data: function() {
                            this.data.dataSet.fields = param;
                        },
                        success : function(res) {
                        	
                        	var resultData = res.dataSet.recordSets.grid.nc_list;
                        	
                        	if($.PSNMUtils.isEmpty(resultData)){
                        		$.PSNM.alert("존재하지않는 임직원 입니다.");
                        		$("#form").find("#USER_ID").val("");
                        		$("#form").find("#USER_NM").val("");
                        		$("#form").find("#HDQT_TEAM_ORG_NM").val("");
                        		$("#form").find("#HDQT_PART_ORG_NM").val("");
                        		return;
                        	}
                        	
                        	if (resultData.length == 1) {
                        		$("#form").find("#USER_ID").val( resultData[0]["USER_ID"] );
                        		$("#form").find("#USER_NM").val( resultData[0]["USER_NM"] );
                        		$("#form").find("#HDQT_TEAM_ORG_NM").val( resultData[0]["HDQT_TEAM_ORG_NM"] );
                        		$("#form").find("#HDQT_PART_ORG_NM").val( resultData[0]["HDQT_PART_ORG_NM"] );
                        	}else{
                        		$a.popup({
                                    url: "biz/dataauth/dataAuthMgmtPop",
                                    data: param,
                                    width: $.PSNM.popWidth(900),
                                    height: 500,
                                    title: "임직원 찾기",
                                    callback : function(returnVal) {
                                        if ( null!=returnVal && typeof returnVal == "object" ) {
                                            $("#form").find("#USER_ID").val( returnVal["USER_ID"] );
                                    		$("#form").find("#USER_NM").val( returnVal["USER_NM"] );
                                    		$("#form").find("#HDQT_TEAM_ORG_NM").val( returnVal["HDQT_TEAM_ORG_NM"] );
                                    		$("#form").find("#HDQT_PART_ORG_NM").val( returnVal["HDQT_PART_ORG_NM"] );
                                        }
                                    }
                                });
                        	}
                        }
                    });
            	}
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
					{ columnIndex : 1, key : "FLAG", 				hidden : true  
						, value : function(value, data) {
                            if ( "I" == value || "D" == value ) { return value; } //추가|삭제는 그냥둠
                            return ( (data._state.edited) ? 'U' : '' ); 
                        }	
					},
                    { columnIndex : 2, key : "HDQT_TEAM_ORG_NM",	title : "본사팀",		align : "center", 	width : "100px"	},
                    { columnIndex : 3, key : "HDQT_PART_ORG_NM",	title : "본사파트",		align : "center", 	width : "100px"	},
                    { columnIndex : 4, key : "USER_NM",				title : "임직원명",		align : "center", 	width : "100px"	},
                    { columnIndex : 5, key : "AUTH_STA_DT",			title : "권한시작일자",	align : "center", 	width : "80px"	},
                    { columnIndex : 6, key : "AUTH_END_DT",			title : "권한종료일자",	align : "center", 	width : "80px"	},
                    { columnIndex : 7, key : "OUT_ORG_NM",			title : "권한본사파트",	align : "center", 	width : "100px"	},
                    { columnIndex : 8, key : "AUTH_SEQ",			hidden : true  }
            	],
                on : {
                    "cell" : {
    					"click" : function(data, eh, e) {
    						if(data._index.column != 0) {
    							$("#form").setData(data);
    							$("#detail").show();
    							$("#form").find("#FLAG").val("U");
    							$("#form").find("#USER_NM").setEnabled(false);
    						}
    					}
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
        },
        searchList: function(param) {
        	$("#detail").hide();
            $.alopex.request("biz.DATAAUTH@PDATAAUTH001_pSearchDataAuth", {
            	 data: "#searchTable",
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
            <span class="txt6_img"><b id="sub-title">데이터권한관리</b>
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
            <col style="width:12%"/>
            <col style="width:21%"/>
            <col style="width:12%"/>
            <col style="width:21%"/>
            <col style="width:12%"/>
            <col style="width:*"/>
           </colgroup>
       	<tbody>
       		<tr>
				<th scope="col">본사팀</th>
				<td class="tleft">
                    <select id="HDQT_TEAM_ORG_ID" data-bind="options:options_HDQT_TEAM_ORG_ID, selectedOptions: HDQT_TEAM_ORG_ID" data-type="select">
                    	<option value="">-전체-</option>
                    </select>
                </td>
                <th scope="col">본사파트</th>
				<td class="tleft">
                    <select id="HDQT_PART_ORG_ID" data-bind="options:options_HDQT_PART_ORG_ID, selectedOptions: HDQT_PART_ORG_ID" data-type="select" >
                    	<option value="">-전체-</option>
                    </select>
                </td>
                <th scope="col">임직원명</th>
                <td class="tleft">
                	<input id="USER_NM" name="USER_NM" data-bind="value:USER_NM" data-type="textinput"/>
				</td>
            </tr>
       	</tbody>
        </table>
		<div class="ab_pos5">
			<button id="btnSearch" type="button" data-type="button" data-theme="af-psnm" data-authtype="R"></button>
		</div>
    </div>
    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>데이터권한관리</b>
        <div class="ab_pos2">
        	<button id="btnNew" type="button" data-type="button" data-theme="af-btn2" data-altname="신규" data-authtype="W"></button>
	        <button id="btnDel"  type="button" data-type="button" data-theme="af-btn13" data-altname="삭제" data-authtype="W"></button>
        	<button id="btnSave" type="button" data-type="button" data-theme="af-btn4" data-altname="저장" data-authtype="W"></button>
        </div>
    </div>

    <!-- main grid -->
    <div id="grid" data-bind="grid:grid"></div>
    
	<div id="detail" style="display: none;">
		<div class="floatL4">
			<img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"/><b>권한등록</b>&nbsp;&nbsp;&nbsp;&nbsp;
			<font size="2" color="red">임직원명 입력 후 ENTER를 누르세요. </font>
		</div>
		<form id="form" onsubmit="return false;">
		<input id="FLAG" name="FLAG" type="hidden"/>
		<input id="AUTH_SEQ" name="AUTH_SEQ" data-bind="value:AUTH_SEQ" type="hidden"/>
		<table class="board02" style="width:100%;">
        	<colgroup>
	            <col style="width:10%"/>
	            <col style="width:20%"/>
	            <col style="width:10%"/>
	            <col style="width:30%"/>
	            <col style="width:10%"/>
	            <col style="width:*"/>
            </colgroup>
			<tr>
				<th scope="col" class="fontred">임직원명</th>
				<td class="tleft">
					<input id="USER_NM" name="USER_NM" data-bind="value:USER_NM" data-type="textinput" data-disabled="true"
						data-validation-rule="{required:true}"
						data-validation-message="{required:$.PSNM.msg('E012', ['임직원명'])}"/>
				</td>
				<th scope="col" class="fontred">임직원ID</th>
				<td class="tleft">
					<input id="USER_ID" name="USER_ID" data-bind="value:USER_ID" data-type="textinput" data-disabled="true"
						data-validation-rule="{required:true}"
						data-validation-message="{required:$.PSNM.msg('E012', ['임직원ID'])}"/>
				</td>
				<th scope="col">본사팀</th>
				<td class="tleft">
					<input id="HDQT_TEAM_ORG_NM" name="HDQT_TEAM_ORG_NM" data-bind="value:HDQT_TEAM_ORG_NM" data-type="textinput" data-disabled="true"/>
				</td>
			</tr>
			<tr>
				<th scope="col">본사파트</th>
				<td class="tleft">
					<input id="HDQT_PART_ORG_NM" name="HDQT_PART_ORG_NM" data-bind="value:HDQT_PART_ORG_NM" data-type="textinput" data-disabled="true"/>
				</td>
				<th scope="col" class="fontred">권한기간</th>
				<td class="tleft">
					<div data-type="daterange" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png" >
                		<input id="AUTH_STA_DT" name="AUTH_STA_DT" data-role="startdate" data-bind="value:AUTH_STA_DT" style="width:70px;"
                			data-validation-rule="{required:true}"
							data-validation-message="{required:$.PSNM.msg('E012', ['권한시작일'])}"/>
						~ <input id="AUTH_END_DT" name="AUTH_END_DT" data-role="enddate" data-bind="value:AUTH_END_DT" style="width:70px;"
							data-validation-rule="{required:true}"
							data-validation-message="{required:$.PSNM.msg('E012', ['권한종료일'])}"/>
                	</div>
				</td>
				<th scope="col" class="fontred">권한본사파트</th>
				<td class="tleft">
					<select id="OUT_ORG_ID" data-bind="options: options_OUT_ORG_ID, selectedOptions: OUT_ORG_ID" data-type="select"
						data-validation-rule="{required:true}"
						data-validation-message="{required:$.PSNM.msg('E012', ['권한본사파트'])}"></select>
				</td>
			</tr>
		</table>
		</form>
	</div>    

</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>