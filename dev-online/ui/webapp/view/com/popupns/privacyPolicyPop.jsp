<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>개인정보 취급방침 - PS&Marketing</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />


    <script type="text/javascript">
    $.alopex.page({
        init : function(id, param) {
            $a.page.setEventListener();
            $("#pp-area").css("height", "500px");
        },
        setEventListener : function() {
            //
        }
    });//end-of-$.alopex.page //-------------------------------------------------------------------------------------------------------//

    function closeWithout() {
        $a.close();
    }
    </script>
</head>

<body>

<div id="Wrap">

    <!-- title area -->
    <div class="pop_header">
        <!--
        <span class="title">에이전트 찾기</span>
        <a id="iconCancel" href="#" class="pop_close"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a9.gif" alt="팝업닫기" ></a> 
        -->

        <!--view_table area -->
        <div class="textAR">
            <jsp:include page="/view/com/popupns/privacyPolicyDiv.jsp" flush="false" />
        </div>

    </div>

</div>

</body>
</html>