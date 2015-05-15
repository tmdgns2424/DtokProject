<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>회원가입요청등록-동의</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />
</head>
<script type="text/javascript">
var initParam = "";
$a.page({
        init : function(id, param) {
        	initParam = param;
            $a.page.setEventListener();
        },
        setEventListener : function() {
            $("#btnConfirm").click( closeWith );
            $("#btnCancel").click( closeWithout );
            $("#iconCancel").click( closeWithout );
        } //end-of-setEventListener
    });
    
function closeWith() {
	
	if( !$("#chk3").is(":checked") ) {
		alert( $.PSNM.msg('E012', ['개인정보 수집 및 이용에 대한 안내']) );
		$('#chk3').focus();
		return false;
	}
	
    //$a.close($.extend(false,{},initParam,$("#form").getData()));
	$a.close({"div": initParam.div1 });	
}

function closeWithout() {
    $a.close();
}    
</script>
<body>

<div id="Wrap">

<!-- title area -->
<div class="pop_header">
   	<!-- find condition area -->
   	<form id="form">
	<div class="textAR"> 
  		
	<div class="floatL5" style="color:#333333; font-size:14px; font-weight:bold;"><b>개인정보 수집 및 이용에 대한 안내</b>
      <div class="ab_pos4">개인정보 수집 및 이용에 동의 합니다.&nbsp;<input id="chk3" type="checkbox" data-type="checkbox" name="chk" data-bind="value:chk3"value="Y" /></div>
    </div>
    
    <div class="box-type1 scroll-y" style="height:500px;">
	    <b>■ 개인정보수집, 이용안내</b>
	    <br/>
	    <br/>D-tok은 회원 가입신청서, 전화, 온라인 전자서식 등 적법하고 공정한 수단에 의하여 회원님의 개인정보를 수집하고 있습니다.
	    <br/>
	    <br/><b>1.지원상담</b>
	
	    <table data-type="table">
			<colgroup>
				<col style="width:17%">
				<col style="width:*">
				<col style="width:27%">
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
					<td>www.d-tok.com</td>
					<td class="t-left">필수항목 : 성명 , 연락처 , 나이 , 성별</td>
					
					<td>상담에 적합한 영업조직 파악</td>
					<td>홈페이지</td>
				</tr>
			</tbody>
		</table>
		
		<b>2.에이전트지원</b>
    
        <table data-type="table">
            <colgroup>
                <col style="width:17%">
                <col style="width:*">
                <col style="width:27%">
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
                    <td class="t-left">필수항목 : 성명(한자), 생년월일, 결혼유무, 자택전화, <br/>이동전화, 현주소, 이메일, 사진</td>
                    
                    <td>본인확인 및 지원 심사 결과 통보</td>
                    <td rowspan="2">홈페이지</td>
                </tr>
                <tr>
                    <td class="t-left">선택항목 : 신장, 체중, 취미</td>
                    <td>영업 및 직무적성능력 판단</td>
                </tr>               
            </tbody>
        </table>

	    <b>[개인정보의 보유 및 이용기간]</b>
	    <br/>정보주체 개인정보는 d-tok 서비스 해지 시까지(회원탈퇴 포함)보관합니다. 
	    <br/>다만 법령에 특별한 규정이 있는 경우에는 법령에서 규정한 보존기간 동안 거래내역과 최소한의 기본정보를 보관합니다.
	    
    </div>

   	<!-- btn area -->
    <p class="floatL3">
      <input id="btnConfirm" type="button" value="" data-type="button" data-theme="af-btn8">
      <input id="btnCancel"  type="button" value="" data-type="button" data-theme="af-btn10">
    </p>
    </div>
    </form>
</div>
</div>

</body>
</html>