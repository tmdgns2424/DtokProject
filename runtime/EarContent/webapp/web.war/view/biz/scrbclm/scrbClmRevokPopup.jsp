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
            $a.page.setEventListener();
        },
        setEventListener : function() {
            $("#btnConfirm").click(function(){
        		if( !$.PSNM.confirm("I004", ["완료취소"] ) ){
        			return false;
        		}
        		
            	var requestData = $.PSNMUtils.getRequestData("form", "gridfile");
            	requestData = $.extend(true, {dataSet: {fields: {RCV_MGMT_NUM:_param.RCV_MGMT_NUM, DIV:"rvk"}}}, requestData);
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
            $("#btnCancel").click( function() {$a.close();} );
        },      
    });
    </script>
</head>

<body>

<div id="Wrap"> 
    <div class="pop_header" style="overflow-y: auto;">
    	<form id="form" onsubmit="return false;">
	    <div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>완료취소</b></div>	    
	    <table class="board02">           
        	<colgroup>
	            <col style="width:30%"/>
	            <col style="width:*"/>
            </colgroup>
			<tr>
	            <th scope="col">완료취소 사유</th>
	            <td class="tleft" colspan="3">
		            <textarea id="RERCV_CTT" name="RERCV_CTT" data-type="textarea" data-bind="value:RERCV_CTT" rows="2" 
		                   style='overflow: auto; width: 93%;'></textarea>
	            </td>       
	        </tr>
	    </table>
	    </form>
	    <!-- btn area -->
	    <div class="btn_area" style="width:100%;">
	      <p class="floatL3">
	        <input id="btnConfirm" type="button" data-type="button" value="" data-theme="af-btn8">
	        <input id="btnCancel"  type="button" data-type="button" value="" data-theme="af-btn10">
	      </p>
	    </div>
     </div>
</div>

</body>
</html>