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
            $("#btnModi").click(function(){
            	$a.navigate("commIncmpDocRcvRgst.jsp", _param);
            });                    
        }, 
        setViewData : function() {
        	var id = _param.data != null ? _param.data.DSM_INCMP_DOC_ID : "";        	       	
        	
        	$("input[name='DSM_INCMP_DOC_ID']").val(id);
            $.alopex.request("biz.INCMPDOC@PINCMPDOC001_pDetailIncmpDoc", {
            	data: {dataSet: {fields: {DSM_INCMP_DOC_ID : id, DSM_BRD_FLAG : "R"}}},
                   success:["body",  function(res) {                	
						var gridList = res.dataSet.recordSets;
						var gridFields = res.dataSet.fields;
						$.each(gridList, function(key, data) {
							$("#"+key).alopexGrid("dataSet", data.nc_list);
						});
						if(_param.data.PROC_ST_CD == '02'){
							$("#SVC_NUM").text(gridFields.F_SVC_NUM);                    	   
						}
						else{
							$("#SVC_NUM").text(gridFields.SVC_NUM);    
						} 
                   }]
            });
            
          	//접슈유형에 따라 문구변경        	       		
        	if("01" == $("#RCV_TYP_CD").val()){
        		//01 : 개통대기 , 02 : 개통완료 , 03 : 1차미비
    			$("#RCV_DT_LBL").text("접수일");
        	}else{
        		$("#RCV_DT_LBL").text("개통일");
        	}        	
        	
        	if(PsnmUser.isMa()){
        		$("#btnModi").show();
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
     
    </script>

</head>

<body>

<jsp:include page="/view/layouts/default_header.jsp" flush="false" />

<div id="contents">

    <!-- title area -->
    <div class="content_title">
        <div class="ub_txt6">
            <span class="txt6_img"><b>미비서류접수</b><span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif"> 
            <span class="a2">커뮤니티</span> <span class="a3"> > </span><b>Main화면 알림</b></span></span> 
        </div>
    </div>

    <!-- btn area -->
    <div class="btn_area">
        <div class="ab_btn_right">
            <!-- <button id="btnInit" type="button" data-type="button" data-theme="af-btn14" data-altname="초기화"></button> -->
            <button id="btnModi" type="button" data-type="button" data-theme="af-btn17" data-altname="수정"></button>
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
        	<input type="hidden" id="RCV_TYP_CD" name="RCV_TYP_CD" data-bind="value:RCV_TYP_CD"/>
            <table class="board02" style="width:100%;">
            <colgroup>
	            <col style="width:15%"/>
	            <col style="width:35%"/>
	            <col style="width:15%"/>
	            <col style="width:*"/>
            </colgroup>
            <tbody>
            <tr>
                <th scope="col">접수유형</th>
                <td class="tleft"><label data-bind="text:RCV_TYP_CD_NM"></label></td>                	
                <th scope="col" id="RCV_DT_LBL"></th>
                <td class="tleft time"><label data-bind="text:RCV_OPEN_DT"></label></td>                	
            </tr>
            <tr>
                <th scope="col">가입자명</th>
                <td class="tleft"><label data-bind="text:CUST_NM"></label></td>
                <th scope="col">개통번호</th>
                <td class="tleft"><label id="SVC_NUM"></label></td>               	
            </tr>
            <tr>
            	<th scope="col">영업국명</th>
                <td class="tleft"><label data-bind="text:HEADADQ_NM"></label></td>      
                <th scope="col" >판매자</th>
                <td class="tleft">
                	<label data-bind="text:AGNT_NM"></label>
                	( <label data-bind="text:AGNT_ID"></label> )
                </td>                
            </tr>
            <tr>
                <th scope="col">첨부유형</th>
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
                	<label data-bind="html:MEMO"></label>                    
                </td>            
            </tr>
            </tbody>
            </table>
        </form>
    </div>

    <div class="floatL4">
    	<img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>첨부파일</b> : 하단 파일을 클릭하시면 저장 및 열기가 가능합니다.
    </div>
    <div id="gridfile" class="view_list" data-bind="grid:gridfile"></div> 
    
    <form id="procArea" onsubmit="return false;">
    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>처리결과</b></div>

    <div class="view_list">
        <input type="hidden" name="DSM_INCMP_DOC_ID" data-bind="value:DSM_INCMP_DOC_ID"/>
            <table class="board02" style="width:100%;"><!-- (file) commIncmpDocRcvDtl #2 -->
            <colgroup>
                <col style="width:15%"/>
				<col style="width:*%"/>
            </colgroup>
            <tbody>            
            <tr>
            	<th scope="col">처리결과</th>
            	<td class="tleft"><label data-bind="html:PROC_ST_CD_NM"></label></td>
            </tr>
            <tr>
            	<th scope="col">처리내용</th>
            	<td class="tleft"><label data-bind="html:PROC_MEMO"></label></td>
            </tr>
            </tbody>
            </table>
    </div>  
 	</form>
</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>