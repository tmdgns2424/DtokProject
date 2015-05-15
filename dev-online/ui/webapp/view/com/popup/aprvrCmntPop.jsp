<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>승인자의견 - PS&Marketing</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />

    <script type="text/javascript">
    $a.page({
        init : function(id, param) {        	
        	$a.page.setEventListener();
        },
        setEventListener : function() {
            $("#btnConfirm").click( closeWithout );
        },

    });

    function closeWithout() {
        
    	$a.close( $('#form').getData() );
    }
    
    </script>
</head>

<body>

<div id="Wrap">

    <!-- title area -->
    <div class="pop_header">
        <form id="form" onsubmit="return false;">

	    <!-- 면접내용 area -->
        <textarea id="APRVR_CMNT" data-bind="value:APRVR_CMNT" style="width:96%; margin-bottom:10px; margin-top:10px;" cols="40" rows="5" data-type="textarea" data-disabled="false" ></textarea>
        
        </form>
   
    </div>
        
    <p class="floatL3">
        <button id="btnConfirm" type="button" data-type="button" data-theme="af-btn8" data-altname="확인"></button>
    </p>

</div>

</body>
</html>