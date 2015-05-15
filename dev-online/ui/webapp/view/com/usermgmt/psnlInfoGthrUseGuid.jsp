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
		<div class="ub_txt6"> <span class="txt6_img"><b>개인정보수집이용안내</b> <span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif"> <span class="a2">나의  D-tok</span> <span class="a3"> > </span> <b>회원정보</b> </span> </span> </div>
	</div>
	<!-- find condition area -->
	<div class="textAR">
    	<div class="box-type1 scroll-y" style="height:700px;">
			<b>■ 개인정보수집, 이용안내</b>
		    <br/>
		    <br/>D-tok은 회원 가입신청서, 전화, 온라인 전자서식 등 적법하고 공정한 수단에 의하여 회원님의 개인정보를 수집하고 있습니다.
		    <br/>
		    <br/><b>[개인정보의 수집 항목 및 이용 목적]</b>
		    <br/>회사는 기본적인 서비스 제공을 위한 필수 정보만을 수집하고 있으며 회원 각각의 기호와 필요에 맞는 서비스를 제공하기 위한 정보 수집 시 별도 동의를 득하고 수집하고 있습니다. 선택 정보를 입력하지 않은 경우에도 서비스 이용 제한은 없습니다
		
                <table data-type="table">
					<colgroup>
						<col style="width:15%">
						<col style="width:45%">
						<col style="width:30%">
						<col style="width:10%">
					</colgroup>
					<thead>
						<tr>
							<th>site</th>
							<th>수집항목</th>
							<th>이용목적</th>
							<th>수집방법</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td rowspan="2">www.d-tok.com</td>
							<td class="t-left">필수항목 : 회원명, 회원ID, 비밀번호, 현주소
	            				<br> 전화번호, 이동전화, 이메일, 사진
							</td>	
							<td class="t-left">
								회원관리
								<br/>업무 관련 정보 제공
								<br/>-	개통 진행 현항 
								<br/>-	고객민원 및 비정상영업소명 처리 현황
								<br/>-	면담 시행 결과 등록 여부
								<br/>-	개통업무 승인 요청/ 결과
								<br/>-	담보 만료현황
								<br/>회사 공지사항 전달
								<br/>문의 사항에 대한 답변 제공 　
							</td>
							<td rowspan="2">홈페이지</td>
						</tr>
						<tr>
							<td class="t-left">
							선택항목 : FAX번호, 생년월일, 결혼유무, 결혼기념일
							</td>
							<td class="t-left">
								Fax번호 활용 업무 요청자 자동식별 통한 실시간 접수 정보 제공 
								<br/>생년월일/ 결혼기념일 등록 회원 대상 선별적 혜택 제공
							</td>
						</tr>
					</tbody>
				</table>
		    <br/>
		    <b>[개인정보의 보유 및 이용기간]</b>
		    <br/>회사는 회원으로서 제공되는 서비스를 받는 동안 회원님의 개인정보를 보유 및 이용하게 됩니다. 
		    <br/>단, 회원탈퇴를 요청하거나 위에서 설명한 개인정보를 수집한 목적 등이 완료된 경우에는 수집된 개인정보가 열람 또는 이용될 수 없도록 처리됩니다. 
		    <br/>다만, 관계법령의 규정에 의하여 보존할 필요성이 있는 경우에는 관계법령에 따라 보존합니다. 
		    <br/>
		    <br/><b>가. 관련 법령에 의한 정보보유 사유</b>
		    <br/>  　<b>- 계약 또는 청약철회 등에 관한 기록</b> 
		    <br/> 　 보존 이유 : 전자상거래 등에서의 소비자보호에 관한 법률 
		    <br/>  　 보존 기간 : 5년  
		    <br/>
		    <br/>  　<b>- 대금결제 및 재화 등의 공급에 관한 기록</b> 
		    <br/> 　 보존 이유 : 전자상거래 등에서의 소비자보호에 관한 법률 
		    <br/>  　 보존 기간 : 5년 
		    <br/>
		    <br/>  　<b>- 웹사이트 방문기록</b>
		    <br/>  　 보존 이유 : 통신비밀보호법 
		    <br/>  　 보존 기간 : 3개월
    	</div>      
    </div>
	
</div>
<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />
</body>
</html>