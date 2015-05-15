<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
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
	
	    _LOG_LEVEL = 0; //로그레벨 :: 0=debug, 1=info, 2=error
	
	    $.alopex.page({
	        init : function(id, param) { 
	            $.PSNM.initialize(id, param); //PSNM공통 초기화함수 호출
	            _param = param;
	        }
	    });
    </script>
</head>
<body>
<jsp:include page="/view/layouts/default_header.jsp" flush="false" />
	<!-- title area -->
<div id="contents">
	<div class="content_title">
		<div class="ub_txt6"> <span class="txt6_img"><b>개인정보 위탁</b> <span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif"> <span class="a2">나의  D-tok</span> <span class="a3"> > </span> <b>회원정보</b> </span> </span> </div>
	</div>
	<!-- find condition area -->
	<div class="textAR">
        <jsp:include page="/view/com/popupns/privacyTrustedDiv.jsp" flush="false" />
        <!--
    	<div class="box-type1 scroll-y" style="height:300px;">
			<br/>■ 개인정보의 위탁
			<br/>
			<br/>회사는 회원님에 대한 서비스의 유지 및 관리, 고객상담, 기타 서비스 안내를 위하여 전문용역 업체에 일부 업무를 위탁운영하고 있습니다. 
			<br/>위탁을 받은 업체는 위탁을 받은 목적을 벗어나서 개인정보를 이용할 수 없습니다. 
			<br/>또한 회사는 이러한 위탁업체에 대하여 해당 개인정보가 위법하게 이용되지 않도록 정기적인 감시와 감독을 실시합니다
		    <table data-type="table" >
		        <tr >
		            <th >
		                <b>취급위탁구분</b>
		            </th>
		            <th >
		                <b>수탁자</b>
		            </th>
		            <th >
		                <b>취급 위탁업무 내용</b>
		            </th>
		            <th >
		                <b>보유 및 이용기간</b>
		            </th>
		        </tr>
		        <tr >
		            <td >
		                필수 취급 위탁
		            </td>
		            <td >
		                SKC&C(주)
		            </td>
		            <td >
		                정보 전산 처리 및 유지/관리
		            </td>
		            <td>
		                위탁 계약 만료 시 까지
		            </td>
		        </tr>
		    </table>
    	</div>      
        -->
    </div>
	
</div>
<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />
</body>
</html>