<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>처리내용 - PS&Marketing</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />

    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/vendor/jquery.ui.widget.js"></script>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/jquery.iframe-transport.js"></script>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/jquery.fileupload.js"></script>

    <script type="text/javascript">
    var _param = null, _searchData = null;

    $a.page({
        init : function(id, param) {
            _param = param;

            $.PSNMUtils.setDefaultYmd("FNSH_DT");
            $("#FNSH_OPR_ID").val( $.PSNM.getSession("USER_ID") );
            $("#FNSH_OPR_NM").val( $.PSNM.getSession("USER_NM") );
            $a.page.setFileUpload();
            $a.page.setEventListener();
        },
        setEventListener : function() {
        	$("#FNSH_TM").change( function(){
        		if(this.value.length == 1){
        			this.value = "0"+this.value;
        		}
        	});  
        	$("#FNSH_MM").change( function(){
        		if(this.value.length == 1){
        			this.value = "0"+this.value;
        		}
        	});
            $("#btnFileDel").click(function(){
            	$.PSNMUtils.delFile();
            });
            $("#btnSave").click(function(){
				
        		if ( ! $.PSNM.isValid("#form") ) {
    			    return false;
    			}
        		if( !$.PSNM.confirm("I004", ["최종완료"] ) ){
        			return false;
        		}
        		
            	var requestData = $.PSNMUtils.getRequestData("form", "gridfile");
            	requestData = $.extend(true, {dataSet: {fields: {RCV_MGMT_NUM:_param.RCV_MGMT_NUM, DIV:"fnsh"}}}, requestData);
            	$.alopex.request("biz.SCRBCLM@PSCRBCLM001_pFnshOrRevokScrbClm", {
            		data: requestData,
                    success: function(res) {
                    	 if ( ! $.PSNM.success(res) ) { //서버측 FAIL응답
                    		 return false;
                    	 }
                    	$a.close("success");                     
                    }
                });
        	});
        },
        setFileUpload : function () {
        	$.PSNMUtils.setFileUploadAndGrid("SCR", "#fileupload", "#gridfile");
        }        
    });

    function closeWithout() {
        $a.close();
    }
    </script>
</head>

<body>

<div id="Wrap"> 
    <div class="pop_header" style="overflow-y: auto;">
    	<div class="btn_area">
	        <div class="ab_btn_right">
	            <button id="btnSave" type="button" data-type="button" data-theme="af-btn4"  style="z-index:1" data-altname="저장" data-authtype="W"></button>
	        </div>
    	</div>
    	<form id="form" onsubmit="return false;">
	    <div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>최종완료내용 등록</b></div>	    
	    <table class="board02">
        	<colgroup>
	            <col style="width:15%"/>
	            <col style="width:35%"/>
	            <col style="width:15%"/>
	            <col style="width:*"/>
            </colgroup>
	        <tr>
	            <th scope="col" class="fontred">처리완료일시</th>
	            <td class="tleft">
					<input id="FNSH_DT" name="FNSH_DT" data-bind="value:FNSH_DT" data-type="dateinput" style="width:70px;" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png"
				      		data-validation-rule="{required:true}" 
							data-validation-message="{required:$.PSNM.msg('E012', ['처리완료일시'])}">
					<input id="FNSH_TM" name="FNSH_TM" data-bind="value:FNSH_TM" data-type="textinput" size="2" data-keyfilter-rule="digits" maxlength="2"
				      		data-validation-rule="{required:true, min:0,max:24,range:[0,24]}" 
							data-validation-message="{required:$.PSNM.msg('E012', ['처리완료일시'])}"> 시
					<input id="FNSH_MM" name="FNSH_MM" data-bind="value:FNSH_MM" data-type="textinput" size="2" data-keyfilter-rule="digits" maxlength="2"
				      		data-validation-rule="{required:true, min:0,max:59,range:[0,59]}" 
							data-validation-message="{required:$.PSNM.msg('E012', ['처리완료일시'])}"> 분	
	            </td>
	            <th scope="col" class="fontred">처리완료 확인자</th>
	            <td class="tleft">
	                <input id="FNSH_OPR_NM" name="FNSH_OPR_NM" data-bind="value:FNSH_OPR_NM" data-type="textinput" data-disabled="true" style="width:130px;"> 
	                <input id="FNSH_OPR_ID" name="FNSH_OPR_ID" data-bind="value:FNSH_OPR_ID" data-type="textinput" data-disabled="true" style="width:130px;"
	                		data-validation-rule="{required:true}" 
							data-validation-message="{required:$.PSNM.msg('E012', ['처리 완료자'])}">
	            </td>            
	        </tr>
	        <tr>
	            <th scope="col">Penalty 내역</th>
	            <td class="tleft" colspan="3">
	                <span style="width:30%; display:inline-block">판매자 <input id="SELLER_PEN_AMT" name="SELLER_PEN_AMT" data-bind="value:SELLER_PEN_AMT" data-type="textinput" size="20" style="text-align:right"></span>
	                <span style="width:30%; display:inline-block">팀장 <input id="TEAM_LDR_PEN_AMT" name="TEAM_LDR_PEN_AMT" data-bind="value:TEAM_LDR_PEN_AMT" data-type="textinput" data-keyfilter-rule="digits" size="20" style="text-align:right"></span>
	                <span style="width:30%; display:inline-block">국장 <input id="DRTR_PEN_AMT" name="DRTR_PEN_AMT" data-bind="value:DRTR_PEN_AMT" data-type="textinput" data-keyfilter-rule="digits" size="20" style="text-align:right"></span>
	            </td>
	        </tr>        
	        <tr>
	            <th scope="col">비고</th>
	            <td class="tleft" colspan="3">
	                <input id="FNSH_MEMO" name="FNSH_MEMO" data-bind="value:FNSH_MEMO" data-type="textinput" style="width:97%;">
	            </td>         
	        </tr>             
			<tr>
	            <th scope="col">완료사항</th>
	            <td class="tleft" colspan="3">
		            <textarea id=FNSH_CTT name="FNSH_CTT" data-type="textarea" data-bind="value:FNSH_CTT" rows="5" 
		                   style='overflow: auto; width: 97%;'></textarea>
	            </td>       
	        </tr>
	    </table>

	     <!-- 첨부파일 area -->
	     <div class="floatL4" id="area-gridfile-head"> 
	         <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>첨부파일</b> <span id="gridfile-title-info"></span> : 하단 파일을 클릭하시면 저장 및 열기가 가능합니다.
		    	<div class="ab_pos1" style="float:right;">
		      		<div style="position:relative;">
						<span class="file-button type1"><input id="fileupload" type="file"></span>
						<button id="btnFileDel" data-type="button" class="af-n-btn5"></button>
		      		</div>
		    	</div>
	     </div>
	     <div id="gridfile" class="view_list" data-bind="grid:gridfile" data-ui="ds"></div>
	     </form>
     </div>
</div>

</body>
</html>