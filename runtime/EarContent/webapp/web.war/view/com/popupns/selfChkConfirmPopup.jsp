<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>본인확인 - PS&Marketing</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />
	<script type="text/javascript">
    $a.page({
        init : function(id, param) {
            $a.page.setEventListener();
        },
        setEventListener : function() {
            $("#btnConfirm").click( closeWith );
            $("#btnCancel").click( closeWithout );
            $("#iconCancel").click( closeWithout );
        }, //end-of-setEventListener
    });
    
    //현재창을 닫고 객체를 반환
    function closeWith() {
        $a.close({"confirm":"Y"});
    }

    function closeWithout() {
        $a.close({"confirm":"N"});
    }
    </script>
</head>
<body>
<div id="Wrap">
	
    <!-- title area -->
    <div class="pop_header"> 
      	<div class="pop_title">
			<span class="title">회원가입</span> 
			<a id="iconCancel" href="#" class="pop_close"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a9.gif" alt="팝업닫기" ></a>
		</div>
        <!--view_table area --> 
        <div class="floatL2">
            <p class="floatL">
            D-tok은 휴대폰을 통해 본인 확인이 완료된 경우에 한하여 회원 가입이<br/>
			가능합니다.(본인 명의 휴대폰이 아닐 경우 회원가입이 불가함)<br/>
			아래 확인 버튼을 클릭하면 본인확인 절차가 진행됩니다.
            </p>
        </div>

        <p class="floatL2">
            <input id="btnConfirm" type="button" value="" data-type="button" data-theme="af-btn8">
            <input id="btnCancel"  type="button" value="" data-type="button" data-theme="af-btn10">
        </p>

    </div>

</div>
</body>
</html>
