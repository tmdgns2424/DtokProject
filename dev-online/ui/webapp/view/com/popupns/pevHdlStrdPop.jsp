<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>에이전트 찾기 - PS&Marketing</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />


    <script type="text/javascript">
    var _initParam = null;
    var _txid = null;

    $.alopex.page({
        init : function(id, param) { //{"HDQT_TEAM_ORG_ID":"C21100","HDQT_PART_ORG_ID":"","SALE_DEPT_ORG_ID":"","SALE_TEAM_ORG_ID":"","AGNT_NM":"ab"} 
            _initParam = param;
            console.log('<findAgentPopup> $.alopex.page.init (param) : ' + JSON.stringify(param));
        },
        
    });//end-of-$.alopex.page //-------------------------------------------------------------------------------------------------------//

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
                <jsp:include page="/view/com/popupns/privacyPolicyDiv_2015_05_08.jsp" flush="false" />
        </div>
    </div>

</div>

</body>
</html>