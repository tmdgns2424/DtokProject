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
    _LOG_LEVEL = 0; //로그레벨 :: 0=debug, 1=info, 2=error

    var _TX_SEARCH      = "biz.MAINSCHD@PSCHMGMT001_pDetailSchMgmt";
    var _TX_SAVE        = "biz.MAINSCHD@PSCHMGMT001_pSaveSchMgmt";
    var _TX_DELETE      = "biz.MAINSCHD@PSCHMGMT001_pDeleteSchMgmt";
    var _param;
    $.alopex.page({
		init : function(id, param) { 
         	
			$.PSNM.initialize(id, param); //PSNM공통 초기화함수 호출
			_param = param;
			$a.page.setEventListener(); //버튼 초기화
			$a.page.setCodeData();
			$a.page.setFileUpload();
			$a.page.setGridauthgrp();
			$a.page.setGridauthorg();
			if(param.SCH_ID == null) {
				$("#RGSTR_NM").setData({RGSTR_NM : $.PSNM.getSession("USER_NM")});
				$("#SCH_CTT").ckeditor(); 
				$("#btnDel").hide();
				$("#SCH_STA_DT").val(getCurrdate());
				$("#SCH_DT").val(getCurrdate());
				$a.page.searchDtl(param);
			}else {
			$a.page.searchDtl(param);
			}
        },
        setEventListener : function() {
            $("#btnCancel").click(function(){
            	$a.back(_param);
            });
			$("#btnList").click(function(){
				$a.navigate("mainSchdMgmtList.jsp", _param);
            });
			$("#btnSave").click(function(){
            	
				if ( ! $.PSNM.isValid("#form") ) {
				    return false; //값 검증
				}
               	if(  $.PSNM.confirm("I004", ["저장"] ) ){
               		var requestData = $.PSNMUtils.getRequestData("form", "gridauthgrp", "gridauthorg", "gridfile");
                   	$.alopex.request(_TX_SAVE, {
	                    data	: requestData,
	                    success : function(res) { 
	                        $a.navigate("mainSchdMgmtList.jsp", _param);
	                    }
                	});
           		}
            });
         	$("#btnFileDel").click(function(){
            	$.PSNMUtils.delFile();
            });
			$("#btnAddAuthGrp").click(function(){
            	$.PSNMAction.popFindAuthGrp(function(data) {
                    //팝업창에서 선택한 데이터를 처리하는 콜백함수 구현
                    if (null!=data && data.length>0) {
                        for(var i=0; i<data.length; i++) {
                            var authGrpId = data[i]["AUTH_GRP_ID"];
                            var arr = $("#gridauthgrp").alopexGrid('dataGet', {AUTH_GRP_ID: authGrpId});
                            if (arr.length>0) {
                            }else {
                                data[i]["FLAG"] = "I";
                                $("#gridauthgrp").alopexGrid("dataAdd", data[i]);
                                
                                $("#gridauthgrp").alopexGrid("startEdit");
                                $("#gridauthgrp").alopexGrid("endEdit");
                            }
                        }
                    }
                });
            });
            $("#btnDelAuthGrp").click(function(){
            	var oRecord = $("#gridauthgrp").alopexGrid( "dataGet" , { _state : { selected : true } } );
            	if(oRecord.length == 0){
            		$.PSNM.alert("삭제할 행을 선택해 주십시오.");
            		return;
            	}
            	
            	$("#gridauthgrp").alopexGrid("dataDelete", {_state:{selected:true}});
            	
            	/* // 시스템관리자일 경우 삭제 안됨
            	var result = true;
            	$.each(oRecord, function(index, val){
            		if(val.AUTH_GRP_ID=="99"){
            			result = false;
        			}
            	});
            	if(result){
            		$("#gridauthgrp").alopexGrid("dataDelete", {_state:{selected:true}});
            	}else{
            		$.PSNM.alert("시스템관리자권한은 삭제할 수 없습니다.");
    				return;
            	} */
            });
            $("#btnAddSaleDept").click(function(){
            	//'본사파트 찾기' 팝업창을 오픈하고, 선택된 데이터를 처리함
                $.PSNMAction.popFindHdqtPart(function(data) {
                    if (null!=data && data.length>0) {
                        for(var i=0; i<data.length; i++) {
                            var hdqtPartOrgId = data[i]["HDQT_PART_ORG_ID"];
                            var arr = $("#gridauthorg").alopexGrid('dataGet', {HDQT_PART_ORG_ID: hdqtPartOrgId});
                            if (arr.length>0) {
                            }else {
                                data[i]["FLAG"] = "I";
                                $("#gridauthorg").alopexGrid("dataAdd", data[i]);
                                
                                $("#gridauthorg").alopexGrid("startEdit");
                                $("#gridauthorg").alopexGrid("endEdit");
                            }
                        }
                    }
                });
            });
			$("#btnDelSaleDept").click(function(){
				var oRecord = $("#gridauthorg").alopexGrid( "dataGet" , { _state : { selected : true } } );
            	if(oRecord.length == 0){
            		$.PSNM.alert("삭제할 행을 선택해 주십시오.");
            		return;
            	}
            	$("#gridauthorg").alopexGrid("dataDelete", {_state:{selected:true}});
            });
        }, 
        setCodeData : function() {
        	$.PSNMUtils.setCodeData([
				{ t:'code', 'elemid' : 'DEL_CYCL_CD', 'codeid' : 'DSM_BLT_DEL_CYCL_CD', 'header' : '-선택-' }
            ]);
        },
        setFileUpload : function () {
			$.PSNMUtils.setFileUploadAndGrid("SCH", "#fileupload", "#gridfile");
        },
        setGridauthgrp : function () {
         	$("#gridauthgrp").alopexGrid({
                pager		  : false,
                height		  : "200px",
                columnMapping : [
					{ columnIndex : 0, selectorColumn : true, width : "20px" },
					{ columnIndex : 1, key : "AUTH_GRP_ID",     title : "권한그룹ID",		align : "center", width : "100px" },
					{ columnIndex : 2, key : "AUTH_GRP_NM",     title : "권한그룹명",		align : "left", width : "100px" },
					{ columnIndex : 3, key : "AUTH_GRP_DESC",   title : "권한그룹설명",		align : "left", width : "100px" }
                ]
            });
        },
        setGridauthorg : function () {
 			$("#gridauthorg").alopexGrid({
				pager : false,
				height : "200px",
				columnMapping : [
					{ columnIndex : 0, selectorColumn : true, width : "20px" },
					{ columnIndex : 1, key : "HDQT_PART_ORG_ID",     title : "본사파트ID",	align : "center", width : "100px" },
					{ columnIndex : 2, key : "HDQT_PART_ORG_NM",     title : "본사파트명",	align : "center", width : "100px" }
                ]
            });          	
 		},
        searchDtl : function(param){
			var id = _param.SCH_ID != null ? _param.SCH_ID : "";
        	 
			$.alopex.request(_TX_SEARCH, {
				data: {dataSet: {fields: {SCH_ID : id, DSM_BRD_FLAG : "R"}}}
				,success: ["#form", function(res) {
					var gridList = res.dataSet.recordSets;
					
					$.each(gridList, function(key, data) {
						$("#"+key).alopexGrid("dataSet", data.nc_list);
					});
					$("#SCH_CTT").ckeditor(); 
				}]
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
		<div class="ub_txt6"> <span class="txt6_img"><b>주요일정관리</b> <span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif"> <span class="a2">본사업무</span> <span class="a3"> > </span> <b>커뮤니티관리</b> </span> </span> </div>
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
	<div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>주요일정</b></div>
	<!--view_table area -->
    <div class="view_list"> 
		<form id="form">
			<input type="hidden" id="SCH_ID" name="SCH_ID"  data-bind="value:SCH_ID"/>
			<table class="board02">
	            <colgroup>
		            <col style="width:15%"/>
		            <col style="width:35%"/>
		            <col style="width:15%"/>
		            <col style="width:*"/>
	            </colgroup>
				<tr>
					<th scope="col" class="fontred">제목</th>
					<td class="tleft" colspan="3">
						<input id="SCH_TITL_NM" name="SCH_TITL_NM" data-bind="value:SCH_TITL_NM" data-type="textinput" data-validation-rule="{required:true}" data-validation-message="{required:$.PSNM.msg('E012', ['제목'])}" style="width:95%">
					</td>
				</tr>
				<tr>
					<th scope="col" class="fontred">일정</th>
					<td class="tleft time">
						<div data-type="daterange" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png">
							<input id="SCH_STA_DT" name="SCH_STA_DT" data-role="startdate" data-bind="value:SCH_STA_DT"  style="width:70px;" data-validation-rule="{required:true}" data-validation-message="{required:$.PSNM.msg('E012', ['일정'])}"/>
							~ <input id="SCH_DT" name="SCH_DT" data-role="enddate" data-bind="value:SCH_DT" style="width:70px;" data-validation-rule="{required:true}" data-validation-message="{required:$.PSNM.msg('E012', ['일정'])}"/>
						</div>
					</td>
	                <th scope="col" class="fontred">삭제주기</th>
	                <td class="tleft">
	                    <select id="DEL_CYCL_CD" data-bind="options: options_DEL_CYCL_CD, selectedOptions: DEL_CYCL_DT_CNT" data-type="select" 
	                    	   	data-validation-rule="{required:true}" 
	                           	data-validation-message="{required:$.PSNM.msg('E012', ['삭제주기'])}">
	                           	<option value="">-선택-</option>
	                    </select>
	                </td>
				</tr>
				<tr>
					<th scope="col">게시자</th>
					<td class="tleft"><label id="RGSTR_NM" data-bind="text:RGSTR_NM"></label></td>
					<th scope="col">게시일자</th>
					<td class="tleft"><label id="RGST_DTM" data-bind="text:RGST_DTM"></label></td>
				</tr>
				<tr>
					<td class="tleft" colspan="4">
						<textarea id="SCH_CTT" data-type="textarea" data-bind="value:SCH_CTT" rows="10" cols="80" style='overflow: auto; width: 100%;/*  height: 350px; */'></textarea>
					</td>
				</tr>
			</table>
		</form>  
	<!--view_list area -->
		<div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>첨부파일</b> : 하단 파일을 클릭하시면 저장 및 열기가 가능합니다.
			<div class="ab_pos1" style="float:right;">
				<div style="position:relative;">
					<span class="file-button type1"><input id="fileupload" type="file"></span>
					<button id="btnFileDel" data-type="button" class="af-n-btn5"></button>
				</div>
			</div>
		</div>
		<div id="gridfile" class="view_list" data-bind="grid:gridfile"></div>
		<div class="psnm-section">
			<div class="psnm-secleft">
				<div class="floatL4" style="clear:both;"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>공지할그룹</b>
					<p class="ab_pos1">
						<input id="btnAddAuthGrp" type="button" data-type="button" class="psnm-sbtn-add" />
						<input id="btnDelAuthGrp" type="button" data-type="button" class="psnm-sbtn-del" />
					</p>
				</div>
	<!-- 왼쪽 그리드1 -->
		        <div id="gridauthgrp" data-bind="grid:gridauthgrp"></div>
		    </div>
			<div class="psnm-secright">
				<div class="floatL4" style="clear:both;"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>공지할본사파트</b>
					<p class="ab_pos1">
						<input id="btnAddSaleDept" type="button" data-type="button" class="psnm-sbtn-add" />
						<input id="btnDelSaleDept" type="button" data-type="button" class="psnm-sbtn-del" />
					</p>
				</div>
	<!-- 오른쪽 그리드1 -->
				<div id="gridauthorg" data-bind="grid:gridauthorg"></div>
		    </div>
		</div>
	</div>
</div>
<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />
</body>
</html>