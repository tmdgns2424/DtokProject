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
            $a.page.setCodeData();
            $a.page.setFileUpload();
            $a.page.setGridauthgrp();
            $a.page.setGridauthorg();
            $a.page.setViewData();
            
        },
        setEventListener : function() {
            $("#btnSave").click(function(){
            	if ( ! $.PSNM.isValid("#form") ) {
				    return false; //값 검증
				}
            	
            	if( "Y" == $("#ANNCE_YN").getValue() ){
        			if($.PSNMUtils.isEmpty($("#ANNCE_STA_DT").val())){
        				$.PSNM.alert("공지기간 시작일을 입력하세요.");
        				$("#ANNCE_STA_DT").focus();
        				return;
        			}
        			if($.PSNMUtils.isEmpty($("#ANNCE_END_DT").val())){
        				$.PSNM.alert("공지기간 종료일을 입력하세요.");
        				$("#ANNCE_END_DT").focus();
        				return;
        			}
        		}
            	
            	if( $.PSNM.confirm("I004", ["저장"] ) ){
            		var requestData = $.PSNMUtils.getRequestData("form", "gridauthgrp", "gridauthorg", "gridfile");
                	
                	$.alopex.request("biz.SALEPLCY@PSALESPLCY001_pSaveSalesPlcy", {
                        data: requestData,
                        success: function(res) { 
                            $a.navigate("salePlcyList.jsp", _param);
                        }
                    });
            	}
            });
            $("#btnList").click(function(){
            	$a.navigate("salePlcyList.jsp", _param);
            });
            $("#btnCancel").click(function(){
            	$a.back(_param);
            });
            $("#btnTot").click(function(){
            	$a.popup({
                    url: "biz/saleplcy/salePlcyStcList",
                    data: _param,
                    title : "영업국별/일별 접속현황",
                    width: 1000,
                    height: 700
                });
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
            		$.PSNM.alert("E021", ["삭제할 행을"]);
            		return;
            	}
            	
            	$("#gridauthgrp").alopexGrid("dataDelete", {_state:{selected:true}});
            	
            	// 시스템관리자일 경우 삭제 안됨 -- 2015.03.13 주석
            	/*
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
            	}
            	*/
            });
            $("#btnAddSaleDept").click(function(){
            	//'영업국 찾기' 팝업창을 오픈하고, 선택된 데이터를 처리함
                $.PSNMAction.popFindSaleDept(function(data) {
                    if (null!=data && data.length>0) {
                        for(var i=0; i<data.length; i++) {
                            var saleDeptOrgId = data[i]["SALE_DEPT_ORG_ID"];
                            var arr = $("#gridauthorg").alopexGrid('dataGet', {SALE_DEPT_ORG_ID: saleDeptOrgId});
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
            		$.PSNM.alert("E021", ["삭제할 행을"]);
            		return;
            	}
            	$("#gridauthorg").alopexGrid("dataDelete", {_state:{selected:true}});
            });
            $("input[name=ANNCE_YN]").click(function(){
            	if( "Y" == $(this).getValue() ){
            		$("#ANNCE_STA_DT").setEnabled(true);
            		$("#ANNCE_END_DT").setEnabled(true);
            		$("#ANNCE_STA_DT").val(getCurrdate());
        			$("#ANNCE_END_DT").val(getAddDate(getCurrdate(),3));
            	}else{
            		$("#ANNCE_STA_DT").setEnabled(false);
            		$("#ANNCE_END_DT").setEnabled(false);
            		$("#ANNCE_STA_DT").val("");
        			$("#ANNCE_END_DT").val("");
            	}
            });
        },
        setGridauthgrp : function () {
        	$("#gridauthgrp").alopexGrid({
                pager : false,
                height : "200px",
                columnMapping : [
                    { columnIndex : 0, selectorColumn : true, width : "30px" },
                    { columnIndex : 1, key : "AUTH_GRP_ID",     title : "권한그룹ID",	align : "center", 	width : "100px" },
                    { columnIndex : 2, key : "AUTH_GRP_NM",     title : "권한그룹명",		align : "left", 	width : "100px" },
                    { columnIndex : 3, key : "AUTH_GRP_DESC",   title : "권한그룹설명",	align : "left", 	width : "100px" }
                ]
            });
        },
		setGridauthorg : function () {
			$("#gridauthorg").alopexGrid({
                pager : false,
                height : "200px",
                columnMapping : [
                    { columnIndex : 0, selectorColumn : true, width : "30px" },
                    { columnIndex : 1, key : "SALE_DEPT_ORG_ID",     title : "영업국코드",	align : "center", width : "100px" },
                    { columnIndex : 2, key : "SALE_DEPT_ORG_NM",     title : "영업국명",		align : "center", width : "100px" }
                ]
            });          	
		},
        setViewData : function() {
        	var id = _param.data != null ? _param.data.DSM_SALES_PLCY_ID : "";
        	
        	$.alopex.request("biz.SALEPLCY@PSALESPLCY001_pDetailSalesPlcy", {
        		data: {dataSet: {fields: {DSM_SALES_PLCY_ID : id}}},
                success:["#form",  function(res) {
                	
                	$("#SALES_PLCY_CTT").ckeditor();
                	
                	var gridList = res.dataSet.recordSets;
					
                    $.each(gridList, function(key, data) {
                    	$("#"+key).alopexGrid("dataSet", data.nc_list);
                    });
                    
                    if($.PSNMUtils.isNotEmpty(id)){
                		if("N" == $("#ANNCE_YN").getValue()){
                			$("#ANNCE_STA_DT").setEnabled(false);
                    		$("#ANNCE_END_DT").setEnabled(false);
                    	}
                	}else{
                		if("Y" == $("#ANNCE_YN").getValue()){
                    		$("#ANNCE_STA_DT").val(getCurrdate());
                			$("#ANNCE_END_DT").val(getAddDate(getCurrdate(),3));
                    	}
                		
                		$("#USER_NM").val($.PSNM.getSession("USER_NM"));
                		$("#RGST_DTM").val(getCurrdate());
                		$("#btnTot").hide();
                	}
                }]
            });
        	
        },
        setCodeData : function() {
        	$.PSNMUtils.setCodeData([
				{ t:'code', 'elemid' : 'DSM_SALES_PLCY_TYP_CD', 'codeid' : 'DSM_FAX_UNIT_TYP_CD', 'header' : '-선택-' },
				{ t:'code', 'elemid' : 'DEL_CYCL_CD', 'codeid' : 'DSM_BLT_DEL_CYCL_CD', 'header' : '-선택-'}
            ]);
        },
        setFileUpload : function () {
        	$.PSNMUtils.setFileUploadAndGrid("PLC", "#fileupload", "#gridfile");
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
            <span class="txt6_img"><b>영업정책관리</b><span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif"> 
            <span class="a2">본사업무</span> <span class="a3"> > </span><b>판매관리</b></span></span> 
        </div>
    </div>

    <!-- btn area -->
    <div class="btn_area">
        <div class="ab_btn_right">
        	<button id="btnTot" type="button" data-type="button" data-theme="af-n-btn2" data-altname="통계" data-authtype="W"></button>
            <button id="btnCancel" type="button" data-type="button" data-theme="af-btn10" data-altname="취소" data-authtype="R"></button>
            <button id="btnSave" type="button" data-type="button" data-theme="af-btn4"  data-altname="저장" data-authtype="W"></button>
            <button id="btnList" type="button" data-type="button" data-theme="af-btn14" data-altname="목록" data-authtype="R"></button>
        </div>
    </div>
    <!-- btn area end--> 

    <!--view_list area -->
    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>영업정책관리</b></div>

    <!--view_table area -->
    <div class="view_list">

        <form id="form" onsubmit="return false;">
        	<input type="hidden" id="DSM_SALES_PLCY_ID" name="DSM_SALES_PLCY_ID"  data-bind="value:DSM_SALES_PLCY_ID"/>
        	<div>
	            <table class="board02" style="width:100%;">
	            <colgroup>
		            <col style="width:15%"/>
		            <col style="width:35%"/>
		            <col style="width:15%"/>
		            <col style="width:*"/>
	            </colgroup>
	            <tbody>
	            <tr>
	                <th scope="col" class="fontred">제목</th>
	                <td colspan="3" class="tleft">
	                    <input id="SALES_PLCY_NM" name="SALES_PLCY_NM" data-bind="value:SALES_PLCY_NM" data-type="textinput" 
	                           data-validation-rule="{required:true}" 
	                           data-validation-message="{required:$.PSNM.msg('E012', ['제목'])}" style="width:95%">
	                </td>
	            </tr>
	            <tr>
	                <th scope="col" class="fontred">적용일자</th>
	                <td class="tleft time">
	                    <input id="APLY_STA_DT" name="APLY_STA_DT" data-type="dateinput" data-bind="value:APLY_STA_DT" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png" style="width:80px;"
	                    	   data-validation-rule="{required:true}" 
	                           data-validation-message="{required:$.PSNM.msg('E012', ['적용일자'])}"/>
	                </td>
	                <th scope="col" class="fontred">정책유형</th>
	                <td class="tleft">
	                    <select id="DSM_SALES_PLCY_TYP_CD" data-bind="options: options_DSM_SALES_PLCY_TYP_CD, selectedOptions: DSM_SALES_PLCY_TYP_CD" data-type="select" 
	                    	   	data-validation-rule="{required:true}" 
	                           	data-validation-message="{required:$.PSNM.msg('E012', ['정책유형'])}"></select>
	                </td>
	            </tr>
	            <tr>
	                <th scope="col">공지여부</th>
	                <td class="tleft">
	                    <input id="ANNCE_YN" name="ANNCE_YN" type="radio" data-type="radio" data-bind="checked:ANNCE_YN" value="Y" checked="checked"/>
	                    <label for="radioId">Y</label>
	                    <input id="ANNCE_YN" name="ANNCE_YN" type="radio" data-type="radio" data-bind="checked:ANNCE_YN" value="N" />
	                    <label for="radioId2">N</label><br/>
	                </td>
	                <th scope="col">공지기간</th>
	                <td class="tleft time">
						<input id="ANNCE_STA_DT" name="ANNCE_STA_DT" data-type="dateinput" data-bind="value:ANNCE_STA_DT" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png" style="width:80px;"/>
						~ <input id="ANNCE_END_DT" name="ANNCE_END_DT" data-type="dateinput" data-bind="value:ANNCE_END_DT" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png" style="width:80px;"/>
					</td>
	            </tr>
	            <tr>
	                <th scope="col" class="fontred">삭제주기</th>
	                <td colspan="3" class="tleft">
	                    <select id="DEL_CYCL_CD" data-bind="options: options_DEL_CYCL_CD, selectedOptions: DEL_CYCL_DT_CNT" data-type="select" 
	                    	   	data-validation-rule="{required:true}" 
	                           	data-validation-message="{required:$.PSNM.msg('E012', ['삭제주기'])}"></select>
	                </td>
	            </tr>
	            <tr>
	            	<th scope="col">작성자</th>
	                <td class="tleft">
	                    <input id="USER_NM" name="USER_NM" data-type="textinput" data-bind="value:USER_NM" style="width:120px" data-disabled="true"/>
	                </td>
	                <th scope="col">작성일자</th>
	                <td class="tleft time">
	                    <input id="RGST_DTM" name="RGST_DTM" data-type="dateinput" data-bind="value:RGST_DTM" data-disabled="true" style="width:100px;"/>
	                </td>
	            </tr>
	            <tr>
	                <td colspan="4" class="tleft">
	                    <textarea id="SALES_PLCY_CTT" name="SALES_PLCY_CTT" data-type="textarea" data-bind="value:SALES_PLCY_CTT" rows="10" cols="80" 
	                              data-validation-rule="{required:true}" 
	                              data-validation-message="{required:$.PSNM.msg('E012', ['내용'])}" 
	                              style='overflow: auto; width: 100%;'></textarea>
	                </td>
	            </tr>
	            </tbody>
	            </table>
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
		        	<div class="floatL4" style="clear:both;"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>공지할영업국</b>
				        <p class="ab_pos1">
				            <input id="btnAddSaleDept" type="button" data-type="button" class="psnm-sbtn-add" />
		                    <input id="btnDelSaleDept" type="button" data-type="button" class="psnm-sbtn-del" />
				        </p>
				    </div>
		            <!-- 오른쪽 그리드1 -->
		            <div id="gridauthorg" data-bind="grid:gridauthorg"></div>
		        </div>
		    </div>
        </form>
    </div>

</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>