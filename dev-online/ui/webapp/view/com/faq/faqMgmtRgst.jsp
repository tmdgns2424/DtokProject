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
            $.PSNM.initialize(id, param);
            
            _param = param;
            
            $a.page.setEventListener();
            $a.page.setCodeData();
            $a.page.setViewData();
            $a.page.setFileUpload();
        },
        setEventListener : function() {
            $("#btnSave").click(function(){
            	
            	if ( ! $.PSNM.isValid("#form") ) {
				    return false; //값 검증
				}
               	
               	if(  $.PSNM.confirm("I004", ["저장"] ) ){
					var requestData = $.PSNMUtils.getRequestData("form", "gridfile");
                   	$.alopex.request("com.FAQMGMT@PFAQMGMT001_pSaveFaq", {
	                    data: requestData,
	                    success: function(res) { 
	                        $a.navigate("faqMgmtList.jsp", _param);
	                    }
                	});
           		}
            });
            $("#btnList").click(function(){
            	$a.navigate("faqMgmtList.jsp", _param);
            });
            $("#btnCancel").click(function(){
            	$a.back(_param);
            });
            $("#btnFileDel").click(function(){
            	$.PSNMUtils.delFile();
            });
        },
        setViewData : function() {
        	var id = _param.data != null ? _param.data.FAQ_ID : "";
        	
        	if($.PSNMUtils.isNotEmpty(id)){
        		$.alopex.request("com.FAQMGMT@PFAQMGMT001_pDetailFaq", {
            		data: {dataSet: {fields: {FAQ_ID : id}}},
                    success:["#form", "#gridfile",  function(res) {
                    	$("#FAQ_CTT").ckeditor();
                    }]
                });
        	}else{
        		$("#FAQ_CTT").ckeditor();
        		$("#RGSTR_NM").val($.PSNM.getSession("USER_NM"));
        		$("#RGSTR_DT").val(getCurrdate());
        		$("#btnCancel").hide();
        	}
        },
        setCodeData : function() {
        	$.PSNMUtils.setCodeData([
				{ t:'code', 'elemid' : 'FAQ_TYP_CD', 'codeid' : 'DSM_FAQ_TYP_CD', 'header' : '-전체-' }
            ]);
        },
        setFileUpload : function () {
        	$.PSNMUtils.setFileUploadAndGrid("FAQ", "#fileupload", "#gridfile");
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
            <span class="txt6_img"><b>FAQ관리</b><span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif"> 
            <span class="a2">나의 D-tok</span> <span class="a3"> > </span><b>소통의장</b></span></span> 
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
    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>FAQ관리</b></div>

    <!--view_table area -->
    <div class="view_list">

        <form id="form" onsubmit="return false;">
        	<input id="FAQ_ID" name="FAQ_ID" type="hidden" data-bind="value:FAQ_ID" data-type="hidden" />
        	
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
		                <td class="tleft">
		                    <input id="FAQ_TITL_NM" name="FAQ_TITL_NM" data-bind="value:FAQ_TITL_NM" data-type="textinput" 
		                           data-validation-rule="{required:true}" 
		                           data-validation-message="{required:'제목을 입력해 주세요.'}" style="width:95%">
		                </td>
		                <th scope="col" class="fontred">FAQ유형</th>
		                <td class="tleft">
		                    <select id="FAQ_TYP_CD" data-bind="options: options_FAQ_TYP_CD, selectedOptions: FAQ_TYP_CD" data-type="select" 
		                    	   	data-validation-rule="{required:true}" 
		                           	data-validation-message="{required:'FAQ유형을 선택해 주세요.'}"></select>
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
		                    <textarea id="FAQ_CTT" name="FAQ_CTT" data-type="textarea" data-bind="value:FAQ_CTT" rows="10" cols="80" 
		                              data-validation-rule="{required:true}" 
		                              data-validation-message="{required:'내용을 입력해 주세요.'}" 
		                              style='overflow: auto; width: 100%;'></textarea>
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

</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>