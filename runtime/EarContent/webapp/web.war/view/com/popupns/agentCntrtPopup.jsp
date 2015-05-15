<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>MA 지원</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />
    
    <script type="text/javascript">
    $a.page({
        init : function(id, param) {
            $a.page.setEventListener();
        },
        setEventListener : function() {
            
            $("#btnConsult").click( closeWith1 );
            $("#btnSupport").click( closeWith2 );
            $("#btnProcess").click( closeWith3 );
        }  //end-of-setEventListener
    });    
   
    function closeWith1() {
    	//$a.close({"div":"step1"});
    	$a.close({"div":"step4","div1":"step1"});
    }
    
    function closeWith2() {
        //$a.close({"div":"step2"});
    	$a.close({"div":"step4","div1":"step2"});
    }
    
    function closeWith3() {
        $a.close({"div":"step3"});
    }
    
    </script>
</head>
<body>
<div id="Wrap">
    
    <!-- title area -->
    <div class="pop_header"> 
       
        <!--view_table area --> 
        <ul class="txt-type1">
            <li>MA지원관련 상담을 원하시면 지원상담요청 버튼을, 기존 요청에 대한 진행사항 확인을 원하시면 진행현황 버튼을 클릭해 주세요. </li>
            <li class="fontred">지원서 작성은 영업국 사전 협의 후 진행해 주세요.</li>
            <li class="fontred">영업국 사전 협의 없이 MA모집 공고를 보고 지원하신 경우, MA지원상담 절차를 먼저 진행해 주세요.</li>
        </ul>

        <p class="floatL2">
            <button id="btnConsult" type="button" data-type="button" data-theme="af-n-btn6" data-altname="지원상담"></button>
            <button id="btnSupport" type="button" data-type="button" data-theme="af-n-btn8" data-altname="지원서작성"></button>
            <button id="btnProcess" type="button" data-type="button" data-theme="af-n-btn11" data-altname="진행현황"></button>
        </p>

    </div>

</div>
</body>
</html>
