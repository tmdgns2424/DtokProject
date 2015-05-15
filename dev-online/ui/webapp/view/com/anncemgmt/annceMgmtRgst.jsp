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
            	
            	if( "Y" == $("#POPUP_YN").getValue() ){
        			if($.PSNMUtils.isEmpty($("#POPUP_STA_DT").val())){
        				$.PSNM.alert("팝업기간 시작일을 입력하세요.");
        				$("#POPUP_STA_DT").focus();
        				return;
        			}
        			if($.PSNMUtils.isEmpty($("#POPUP_END_DT").val())){
        				$.PSNM.alert("팝업기간 종료일을 입력하세요.");
        				$("#POPUP_END_DT").focus();
        				return;
        			}
        		}
            	
            	if( $.PSNM.confirm("I004", ["저장"] ) ){
            		var requestData = $.PSNMUtils.getRequestData("form", "gridauthgrp", "gridauthorg", "gridfile");
                	
                	$.alopex.request("com.ANNCEMGMT@PANNCEMGMT001_pSaveAnnce", {
                        data: requestData,
                        success: function(res) { 
                            $a.navigate("annceMgmtList.jsp", _param);
                        }
                    });
            	}
            });
            $("#btnList").click(function(){
            	$a.navigate("annceMgmtList.jsp", _param);
            });
            $("#btnCancel").click(function(){
            	$a.back(_param);
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
            $("input[name=POPUP_YN]").click(function(){
            	if( "Y" == $(this).getValue() ){
            		$("#POPUP_STA_DT").setEnabled(true);
            		$("#POPUP_END_DT").setEnabled(true);
            		$("#POPUP_STA_DT").val(getCurrdate());
        			$("#POPUP_END_DT").val(getAddDate(getCurrdate(),3));
            	}else{
            		
            		var MNDT_CHK_YN = $("input:radio[name=MNDT_CHK_YN]:checked").val();
            		
            		if("N" == MNDT_CHK_YN){
            			$("#POPUP_STA_DT").setEnabled(false);
                		$("#POPUP_END_DT").setEnabled(false);
                		$("#POPUP_STA_DT").val("");
            			$("#POPUP_END_DT").val("");
            		}else{
            			$("input:radio[name=POPUP_YN][value=Y]").prop("checked", true);
            		}
            	}
            });
            $("input[name=MNDT_CHK_YN]").click(function(){
            	if( "Y" == $(this).getValue() ){
            		$("input:radio[name=POPUP_YN][value=Y]").prop("checked", true);
            		$("#POPUP_STA_DT").setEnabled(true);
            		$("#POPUP_END_DT").setEnabled(true);
            		$("#POPUP_STA_DT").val(getCurrdate());
        			$("#POPUP_END_DT").val(getAddDate(getCurrdate(),3));
            	}
            });
            $("#RCV_TYP_CD").change(function(){
            	var oResult = new Object();
            	if("01" == $(this).val()){
            		oResult = [{AUTH_GRP_ID : "99", AUTH_GRP_NM : "시스템관리자", AUTH_GRP_DESC : "DTOK사용자"},
            		             {AUTH_GRP_ID : "01", AUTH_GRP_NM : "(임직원) 현업관리자", AUTH_GRP_DESC : "DSM 센터 직원"},
            		             {AUTH_GRP_ID : "02", AUTH_GRP_NM : "(임직원) 정책관리", AUTH_GRP_DESC : "DSM 센터 직원"},
            		             {AUTH_GRP_ID : "03", AUTH_GRP_NM : "(임직원) 영업관리", AUTH_GRP_DESC : "DSM 센터 직원"},            		             
            		             {AUTH_GRP_ID : "12", AUTH_GRP_NM : "(에이전트) 국장", AUTH_GRP_DESC : "영업국 조직 관리자 (수석/책임/선임)"}, 
            		             {AUTH_GRP_ID : "13", AUTH_GRP_NM : "(에이전트) 팀장", AUTH_GRP_DESC : "영업팀 조직 관리자 (SM/CM/FM)"}, 
            		             {AUTH_GRP_ID : "14", AUTH_GRP_NM : "(에이전트) MA", AUTH_GRP_DESC : "판매자 (MA/S-MA)"}, 
            		             {AUTH_GRP_ID : "15", AUTH_GRP_NM : "(에이전트) 관리총무", AUTH_GRP_DESC : "영업국 업무지원"}, 
            		             {AUTH_GRP_ID : "16", AUTH_GRP_NM : "(에이전트) 총무", AUTH_GRP_DESC : "국장 보좌, S-MA 업무지원"}];
            	}else if("02" == $(this).val()){
            		oResult = [{AUTH_GRP_ID : "99", AUTH_GRP_NM : "시스템관리자", AUTH_GRP_DESC : "DTOK사용자"},
          		                 {AUTH_GRP_ID : "01", AUTH_GRP_NM : "(임직원) 현업관리자", AUTH_GRP_DESC : "DSM 센터 직원"},
            		             {AUTH_GRP_ID : "02", AUTH_GRP_NM : "(임직원) 정책관리", AUTH_GRP_DESC : "DSM 센터 직원"},
            		        	 {AUTH_GRP_ID : "03", AUTH_GRP_NM : "(임직원) 영업관리", AUTH_GRP_DESC : "DSM 센터 직원"},
            		             {AUTH_GRP_ID : "12", AUTH_GRP_NM : "(에이전트) 국장", AUTH_GRP_DESC : "영업국 조직 관리자 (수석/책임/선임)"}, 
            		             {AUTH_GRP_ID : "13", AUTH_GRP_NM : "(에이전트) 팀장", AUTH_GRP_DESC : "영업팀 조직 관리자 (SM/CM/FM)"}];
            	}else if("03" == $(this).val()){
            		oResult = [{AUTH_GRP_ID : "99", AUTH_GRP_NM : "시스템관리자", AUTH_GRP_DESC : "DTOK사용자"},
          		                 {AUTH_GRP_ID : "01", AUTH_GRP_NM : "(임직원) 현업관리자", AUTH_GRP_DESC : "DSM 센터 직원"},
            		             {AUTH_GRP_ID : "02", AUTH_GRP_NM : "(임직원) 정책관리", AUTH_GRP_DESC : "DSM 센터 직원"},
            		             {AUTH_GRP_ID : "03", AUTH_GRP_NM : "(임직원) 영업관리", AUTH_GRP_DESC : "DSM 센터 직원"},            		                   		                 
            		             {AUTH_GRP_ID : "12", AUTH_GRP_NM : "(에이전트) 국장", AUTH_GRP_DESC : "영업국 조직 관리자 (수석/책임/선임)"}];
            	}else{
            		oResult = [{AUTH_GRP_ID : "99", AUTH_GRP_NM : "시스템관리자", AUTH_GRP_DESC : "DTOK사용자"}];
            	}
            	
//            	var curResult = $("#gridauthgrp").alopexGrid("dataGet");
            	$("#gridauthgrp").alopexGrid("dataEmpty");
            	
				for(var i=0 ; i<oResult.length ; i++) {
// 					var flag = false;
// 					for(var j=0 ; j<curResult.length ; j++) {
// 						if(oResult[i].AUTH_GRP_ID == curResult[j].AUTH_GRP_ID){
// 							flag = true;
// 							break;
// 						}
// 					}
// 					if(flag == false){
						$("#gridauthgrp").alopexGrid("dataAdd", oResult[i]);
//					}
				}
            });
        },
        setGridauthgrp : function () {
        	$("#gridauthgrp").alopexGrid({
                pager : false,
                height : "200px",
                columnMapping : [
                    { columnIndex : 0, selectorColumn : true, width : "30px" },
                    { columnIndex : 1, key : "AUTH_GRP_ID",     title : "권한그룹ID",	align : "center", width : "60px" },
                    { columnIndex : 2, key : "AUTH_GRP_NM",     title : "권한그룹명",		align : "left", width : "100px" },
                    { columnIndex : 3, key : "AUTH_GRP_DESC",   title : "권한그룹설명",	align : "left", width : "100px" }
                ]
            });
        },
        setGridauthorg : function () {
			$("#gridauthorg").alopexGrid({
                pager : false,
                height : "200px",
                columnMapping : [
                    { columnIndex : 0, selectorColumn : true, width : "30px" },
                    { columnIndex : 1, key : "HDQT_PART_ORG_ID",     title : "본사파트ID",	align : "center", width : "100px" },
                    { columnIndex : 2, key : "HDQT_PART_ORG_NM",     title : "본사파트명",	align : "center", width : "100px" }
                ]
            });          	
		},
        setViewData : function() {
        	var id = _param.data != null ? _param.data.ANNCE_ID : "";
        	
        	if($.PSNMUtils.isEmpty(id)){
        		$("#btnCancel").hide();
        	}
        	
        	$.alopex.request("com.ANNCEMGMT@PANNCEMGMT001_pDetailAnnce", {
        		data: {dataSet: {fields: {ANNCE_ID : id}}},
                success:["#form",  function(res) {
                	
                	$("#ANNCE_CTT").ckeditor();
                	
                	var gridList = res.dataSet.recordSets;
					
                    $.each(gridList, function(key, data) {
                    	$("#"+key).alopexGrid("dataSet", data.nc_list);
                    });
                    
                    if($.PSNMUtils.isNotEmpty(id)){
                		if("N" == $("#POPUP_YN").getValue()){
                			$("#POPUP_STA_DT").setEnabled(false);
                    		$("#POPUP_END_DT").setEnabled(false);
                    	}
                	}else{
                		if("Y" == $("#POPUP_YN").getValue()){
                    		$("#POPUP_STA_DT").val(getCurrdate());
                			$("#POPUP_END_DT").val(getAddDate(getCurrdate(),3));
                    	}
                		
                		$("#RGSTR_NM").val($.PSNM.getSession("USER_NM"));
                		$("#RGSTR_DT").val(getCurrdate());
                	}
                }]
            });
        },
        setCodeData : function() {
        	$.PSNMUtils.setCodeData([
				{ t:'code', 'elemid' : 'RCV_TYP_CD', 'codeid' : 'DSM_RCV_TYP_CD', 'header' : '-선택-' },
				{ t:'code', 'elemid' : 'DEL_CYCL_CD', 'codeid' : 'DSM_BLT_DEL_CYCL_CD', 'header' : '-선택-'}
            ]);
        },
        setFileUpload : function () {
        	$.PSNMUtils.setFileUploadAndGrid("ANN", "#fileupload", "#gridfile");
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
            <span class="txt6_img"><b>공지사항관리</b><span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif"> 
            <span class="a2">본사업무</span> <span class="a3"> > </span><b>커뮤니티관리</b></span></span> 
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
    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>공지사항관리</b></div>

    <!--view_table area -->
    <div class="view_list">

        <form id="form" onsubmit="return false;">
        	<input type="hidden" id="ANNCE_ID" name="ANNCE_ID" data-bind="value:ANNCE_ID"/>
        	
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
	                    <input id="ANNCE_TITL_NM" name="ANNCE_TITL_NM" data-bind="value:ANNCE_TITL_NM" data-type="textinput" 
	                           data-validation-rule="{required:true}" 
	                           data-validation-message="{required:$.PSNM.msg('E012', ['제목'])}" style="width:95%">
	                </td>
	            </tr>
	            <tr>
	                <th scope="col">팝업여부</th>
	                <td class="tleft">
	                    <input id="POPUP_YN" name="POPUP_YN" type="radio" data-type="radio" data-bind="checked:POPUP_YN" value="Y" checked="checked"/>
	                    <label for="radioId">Y</label>
	                    <input id="POPUP_YN" name="POPUP_YN" type="radio" data-type="radio" data-bind="checked:POPUP_YN" value="N" />
	                    <label for="radioId2">N</label><br/>
	                </td>
	                <th scope="col">팝업기간</th>
	                <td class="tleft time">
						<input id="POPUP_STA_DT" name="POPUP_STA_DT" data-type="dateinput" data-bind="value:POPUP_STA_DT" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png" style="width:100px;"/>
						~ <input id="POPUP_END_DT" name="POPUP_END_DT" data-type="dateinput" data-bind="value:POPUP_END_DT" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png" style="width:100px;"/>
					</td>
	            </tr>
	            <tr>
	                <th scope="col" class="fontred">공지대상</th>
	                <td class="tleft">
	                    <select id="RCV_TYP_CD" data-bind="options: options_RCV_TYP_CD, selectedOptions: RCV_TYP_CD" data-type="select" 
	                    	   	data-validation-rule="{required:true}" 
	                           	data-validation-message="{required:$.PSNM.msg('E012', ['공지대상'])}"></select>
	                </td>
	                <th scope="col">필수확인여부</th>
	                <td class="tleft">
	                    <input id="MNDT_CHK_YN" name="MNDT_CHK_YN" type="radio" data-type="radio" data-bind="checked:MNDT_CHK_YN" value="Y"/>
	                    <label for="mndtChk">Y</label>
	                    <input id="MNDT_CHK_YN" name="MNDT_CHK_YN" type="radio" data-type="radio" data-bind="checked:MNDT_CHK_YN" value="N" checked="checked"/>
	                    <label for="mndtChk2">N</label><br/>
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
	                    <input id="RGSTR_NM" name="RGSTR_NM" data-type="textinput" data-bind="value:RGSTR_NM" style="width:120px" data-disabled="true"/>
	                </td>
	                <th scope="col">작성일자</th>
	                <td class="tleft time">
	                    <input id="RGSTR_DT" name="RGSTR_DT" data-type="dateinput" data-bind="value:RGSTR_DT" data-disabled="true" style="width:100px;"/>
	                </td>
	            </tr>
	            <tr>
	                <td colspan="4" class="tleft">
	                    <textarea id="ANNCE_CTT" name="ANNCE_CTT" data-type="textarea" data-bind="value:ANNCE_CTT" rows="10" cols="80" 
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
        </form>
    </div>
</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>