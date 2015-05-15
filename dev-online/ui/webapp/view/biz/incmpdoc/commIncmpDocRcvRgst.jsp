<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="nexcore.framework.core.data.user.IUserInfo"%>
<%@ page import="nexcore.framework.online.channel.util.WebUtils"%>
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
    var _data;
    
    $.alopex.page({

        init : function(id, param) { 
            $.PSNM.initialize(id, param); //PSNM공통 초기화함수 호출            
            _param = param; //이 페이지로 전달된 파라미터를 저장
            
            $a.page.setEventListener();
            $a.page.setFileUpload();           
            $a.page.setCodeData();
            $a.page.setViewData();
        },
        setEventListener : function() {
        	// 목록 버튼 클릭 시 
            $("#btnList").click(function(){	
            	$a.navigate("commIncmpDocRcvList.jsp", _param);
            });         	
         	// 판매자명 입력시 Agent 매핑
         	$("#AGNT_NM").keyup($.PSNMAction.findAgent);
        	// 저장 버튼 클릭 시 
            $("#btnSave").click(function(){
            	var id = _param.data != null ? _param.data.DSM_INCMP_DOC_ID : "";
            	// 폼 검증 1 : 속성으로 지정된 것
            	if ( !$.PSNM.isValid("#form") ) {
				    return false; //값 검증
				}
            	// 폼 검증 2 : 추가적인 검증이 필요하면 여기에 구현
            	
            	if( $.PSNMUtils.isNotEmpty(id) ){ //수정인경우
        			if( $.PSNM.getSession("USER_ID") != _data.RGSTR_ID) {
        				$.PSNM.alert("작성자만 수정할 수 있습니다.");
        				return;
        			}
        			
        			if( _data.PROC_ST_CD !== "01" ) {
        				$.PSNM.alert("이미 답변등록이 처리중이거나 처리되었습니다.");
        				return;
        			}
        		}
				    
            	if($("#RCV_OPEN_DT").val() == ""){
	            	$.PSNM.alert( $("#RCV_DT_LBL").text() + "을 선택하세요.");
					$("#RCV_OPEN_DT").focus();
					return;	
        		}
            	if( $("#AGNT_NM").val()=="" || $("#AGNT_ID").val()=="" ) {
            		$.PSNM.alert("판매자는 필수입력항목입니다. \n이름 또는 에이전트코드를 넣고 Enter를 치세요.");
        			return;
        		}
            	if(!$("input:checkbox[name^='DOC_TYP_CD']").is(":checked")){
            		$.PSNM.alert("첨부유형은 한 가지 이상 선택하세요.");
    				$("#DOC_TYP_CD1").focus();
    				return;	
            	}            	
            	if( $("#gridfile").find("tbody").find("input").length == 0 ){
            		$.PSNM.alert("파일 첨부가 안되었습니다. 첨부할 파일을 업로드하세요.");
            		$("#fileupload").focus();
            		return;
            	}            	
            	if( $.PSNM.confirm("I004", ["저장"] ) ){
            		var requestData = $.PSNMUtils.getRequestData("form", "gridfile");
                	
                	$.alopex.request("biz.INCMPDOC@PINCMPDOC001_pSaveIncmpDoc", {
                        data: requestData,
                        success: function(res) { 
                            alert("게시물이 등록 되었습니다.");
                        	$a.navigate("commIncmpDocRcvList.jsp", _param);
                        }
                    });
            	}
            });
        	// 도급결과 처리 버튼 클릭 시 
            $("#resultSave").click(function(){
            	// 폼 검증 1 : 속성으로 지정된 것
            	if ( ! $.PSNM.isValid("#procArea") ) {
				    return false; //값 검증
				}            	
            	if( $.PSNM.confirm("I004", ["저장"] ) ){
            		var requestData = $.PSNMUtils.getRequestData("procArea");
                	
                	$.alopex.request("biz.INCMPDOC@PINCMPDOC001_pSaveIncmpDocResult", {
                        data: requestData,
                        success: function(res) { 
                            alert("게시물이 등록 되었습니다.");
                        	$a.navigate("commIncmpDocRcvList.jsp", _param);
                        }
                    });
            	}
            });
        	//접슈유형 변경시
        	$("#RCV_TYP_CD").change(function(){        		
        		if("01" == $(this).val()){
        			//01 : 개통대기 , 02 : 개통완료 , 03 : 1차미비
    				$("#RCV_DT_LBL").text("접수일");
        		}else{
        			$("#RCV_DT_LBL").text("개통일");
        		}
        	}); 
            $("#btnFileDel").click(function(){
            	$.PSNMUtils.delFile();
            });           
        }, 
        setViewData : function() {
        	var id = _param.data != null ? _param.data.DSM_INCMP_DOC_ID : "";
        	       	
        	// 상세 정보 페이지로 들어온경우 데이터 바인딩
        	if($.PSNMUtils.isNotEmpty(id)){
        		$("input[name='DSM_INCMP_DOC_ID']").val(id);
            	$.alopex.request("biz.INCMPDOC@PINCMPDOC001_pDetailIncmpDoc", {
            		data: {dataSet: {fields: {DSM_INCMP_DOC_ID : id, DSM_BRD_FLAG : "W"}}},
                    success:["body",  function(res) {                	
                    	var gridList = res.dataSet.recordSets;
                    	_data = res.dataSet.fields ;
                    	//$("#MEMO").ckeditor();
                    	//$("#PROC_MEMO").ckeditor();
                        $.each(gridList, function(key, data) {
                        	$("#"+key).alopexGrid("dataSet", data.nc_list);
                        });  
                    }]
                });
        	}else{
        	// 신규등록으로 들오온 경우
        		//$("#MEMO").ckeditor();
            	//$("#PROC_MEMO").ckeditor();
        	}
        	$("#RCV_TYP_CD").change();        	
        	
        	if(PsnmUser.isMa()){
        		$("#btnSave").show();
        	}
        	//MA접수건에 대해서 처리하고자 할때.
        	$("#procArea").hide();
        	if( PsnmUser.isStaff() || ( $.PSNM.getSession('DUTY_USER_TYP')=='3' && $.PSNM.getSession('DUTY')!='14') ) {
        		$("#procArea").show();
        	}    		
        },
        setCodeData : function() {
            $.PSNMUtils.setCodeData([
				{ t:'code', 'elemid' : 'RCV_TYP_CD', 'codeid' : 'DSM_DOC_RCT_TYP_CD', 'header' : '-선택-' }
            ]);
            
            $.PSNMUtils.setCodeData([
                { t:'code', 'elemid' : 'PROC_ST_CD', 'codeid' : 'DSM_DOC_RCV_ST_CD', 'header' : '-전체-' }
            ]);
        },
        setFileUpload : function () {        	
        	$.PSNMUtils.setFileUploadAndGrid("INC", "#fileupload", "#gridfile"); 
        }
        
    });
    
    function onAgentFound(oAgent) {  
        var dept_nm = oAgent.SALE_DEPT_ORG_NM;       
    	$("#HEADADQ_NM").val( dept_nm );    
    }
       
    </script>

</head>

<body>

<jsp:include page="/view/layouts/default_header.jsp" flush="false" />

<div id="contents">

    <!-- title area -->
    <div class="content_title">
        <div class="ub_txt6">
            <span class="txt6_img">
            	<b>미비서류접수</b><span class="notice-more"> 
            	<img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif"> 
            	<span class="a2">커뮤니티</span> <span class="a3"> > </span><b>Main화면 알림</b></span>
            </span> 
        </div>
    </div>

    <!-- btn area -->
    <div class="btn_area">
        <div class="ab_btn_right">
            <!-- <button id="btnInit" type="button" data-type="button" data-theme="af-btn14" data-altname="초기화"></button> -->
            <button id="btnSave" type="button" data-type="button" data-theme="af-btn4" data-altname="저장"></button>
            <button id="btnList" type="button" data-type="button" data-theme="af-btn14" data-altname="목록"></button>
        </div>
    </div>
    <!-- btn area end--> 

    <!--view_list area -->
    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>미비접수 요청내역</b></div>

    <!--view_table area -->
    <div class="view_list">

        <form id="form" onsubmit="return false;">
        	<input type="hidden" id="DSM_INCMP_DOC_ID" name="DSM_INCMP_DOC_ID" data-bind="value:DSM_INCMP_DOC_ID"/>
            <table class="board02" style="width:100%;">
            <colgroup>
	            <col style="width:15%"/>
	            <col style="width:35%"/>
	            <col style="width:15%"/>
	            <col style="width:*"/>
            </colgroup>
            <tbody>
            <tr>
                <th scope="col" class="psnm-required">접수유형</th>
                <td class="tleft">
                	<select id="RCV_TYP_CD" name="RCV_TYP_CD" data-bind="options: options_RCV_TYP_CD, selectedOptions: RCV_TYP_CD" data-type="select" 
                			data-validation-rule="{required:true}" 
	                        data-validation-message="{required:$.PSNM.msg('E012', ['접수유형'])}">
	                </select>
                </td>
                <th scope="col" class="psnm-required" id="RCV_DT_LBL"></th>
                <td class="tleft">
                	<input id="RCV_OPEN_DT" name="RCV_OPEN_DT" data-type="dateinput" data-bind="value:RCV_OPEN_DT" data-format="yyyy-MM-dd" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png"/>
                </td>
            </tr>
            <tr>
                <th scope="col" class="psnm-required">가입자명</th>
                <td class="tleft time">
                	<input id="CUST_NM" name="CUST_NM" data-type="textinput" data-bind="value:CUST_NM" 
                		   data-validation-rule="{required:true}" 
	                       data-validation-message="{required:$.PSNM.msg('E012', ['가입자명'])}"/>
                </td>
                <th scope="col" class="psnm-required">개통번호</th>
                <td class="tleft">
                	<input id="SVC_NUM" name="SVC_NUM" data-type="textinput" data-bind="value:SVC_NUM"
                		   data-validation-rule="{required:true}" 
	                       data-validation-message="{required:$.PSNM.msg('E012', ['개통번호'])}"/>
                </td>
            </tr>
            <tr>
            	<th scope="col">영업국명</th>
                <td class="tleft"><input id="HEADADQ_NM" name="HEADADQ_NM" data-type="textinput" data-bind="value:HEADADQ_NM" data-theme="af-textinput" data-disabled="true" /></td>
                <th scope="col" class="psnm-required">판매자</th>
                <td class="tleft time">
                	<input id="AGNT_NM" name="AGNT_NM" data-type="textinput" data-bind="value:AGNT_NM" data-agentid="AGNT_ID" data-callback="onAgentFound"/>
                	<input id="AGNT_ID" name="AGNT_ID" data-type="textinput" data-bind="value:AGNT_ID" data-theme="af-textinput" data-disabled=true>
                </td>
            </tr>
            <tr>
                <th scope="col" class="psnm-required">첨부유형</th>
                <td colspan="3" class="tleft">
                	<input id="DOC_TYP_CD1" type="checkbox" data-type="checkbox" name="DOC_TYP_CD1" data-bind="checked:DOC_TYP_CD1" value = "01"/><label for="checkbox1">가입자신분증</label>
					<input id="DOC_TYP_CD2" type="checkbox" data-type="checkbox" name="DOC_TYP_CD2" data-bind="checked:DOC_TYP_CD2" value = "02"/><label for="checkbox2">예금주신분증</label>
					<input id="DOC_TYP_CD3" type="checkbox" data-type="checkbox" name="DOC_TYP_CD3" data-bind="checked:DOC_TYP_CD3" value = "03"/><label for="checkbox3">법대신분증</label>
					<input id="DOC_TYP_CD4" type="checkbox" data-type="checkbox" name="DOC_TYP_CD4" data-bind="checked:DOC_TYP_CD4" value = "04"/><label for="checkbox2">등록(가족관계증명서)</label>
					<input id="DOC_TYP_CD5" type="checkbox" data-type="checkbox" name="DOC_TYP_CD5" data-bind="checked:DOC_TYP_CD5" value = "05"/><label for="checkbox3">기타서류</label>
				</td>
            </tr>
            <tr>
            	<th scope="col">비고</th>            	
                <td colspan="3" class="tleft">
                    <textarea id="MEMO" name="MEMO" data-type="textarea" data-bind="value:MEMO" rows="10" cols="80" style='overflow: auto; width: 98%;'></textarea>
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
    
    <form id="procArea" onsubmit="return false;">
    <input type="hidden" name="DSM_INCMP_DOC_ID" data-bind="value:DSM_INCMP_DOC_ID"/>
    <div class="content_title">
        <div class="ub_txt6"><span class="txt6_img"></span></div>
    </div>
    <!-- btn area -->
    <div class="btn_area">
        <div class="ab_btn_right">            
            <button id="resultSave" type="button" data-type="button" data-theme="af-btn4" data-altname="저장"></button>            
        </div>
    </div>
    <!-- btn area end-->    
    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>처리결과</b></div>
    <!--view_table area -->
    <div class="view_list">
    	<table class="board02" style="width:100%;">
        	<colgroup>
	            <col style="width:15%"/>
				<col style="width:*%"/>
            </colgroup>
            <tbody>            
            <tr>
            	<th scope="col">처리결과</th>
            	<td class="tleft">
            		<select id="PROC_ST_CD" name="PROC_ST_CD" data-bind="options: options_PROC_ST_CD, selectedOptions: PROC_ST_CD" data-type="select" 
            				data-validation-rule="{required:true}" 
	                        data-validation-message="{required:$.PSNM.msg('E012', ['처리결과'])}">
	               	</select>
				</td>
            </tr>
            <tr>
            	<th scope="col">처리내용</th>
            	<td>
            		<textarea id="PROC_MEMO" name="PROC_MEMO" data-type="textarea" data-bind="value:PROC_MEMO" rows="10" cols="80" style='overflow: auto; width: 98%;'></textarea>
            	</td>
            </tr>
            </tbody>
    	</table>       
    </div>
    </form>  
 
</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>