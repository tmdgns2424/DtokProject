<%
	response.setHeader("Pragma","no-cache");			// HTTP1.0 캐쉬 방지
	response.setDateHeader("Expires",0);				// proxy 서버의 캐쉬 방지
	response.setHeader("Pragma", "no-store");			// HTTP1.1 캐쉬 방지
	if(request.getProtocol().equals("HTTP/1.1"))
	response.setHeader("Cache-Control", "no-cache");    // HTTP1.1 캐쉬 방지
%>
<%@ page contentType="text/html; charset=ksc5601" %>
<%@ page import = "java.util.*, java.text.SimpleDateFormat, nexcore.framework.core.util.BaseUtils, com.icert.comm.secu.IcertSecuManager"%> 
<%	//날짜 생성
	Calendar today = Calendar.getInstance();
	SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
	String day = sdf.format(today.getTime());

	java.util.Random ran = new Random();
	//랜덤 문자 길이
	int numLength = 6;
	String randomStr = "";
    
	for (int i = 0; i < numLength; i++) {
	    //0 ~ 9 랜덤 숫자 생성
	    randomStr += ran.nextInt(10);
	}	
	System.out.println("**********************************************************************************************");
    String tr_cert   = "";
    String cpId      = BaseUtils.getConfiguration("phone.certi.svc.id");            // 본인실명확인 회원사 아이디
    String urlCode   = BaseUtils.getConfiguration("phone.certi.svc.srvNo");         // 본인실명확인 urlCode
  	//reqNum은 최대 40byte 까지 사용 가능
    String certNum   = day + randomStr;                                     // 본인실명확인 요청번호
    String date  	 = day;                                                 // 본인실명확인 요청시간
    String certMet   = "M";                                                 // 본인인증방법
    String name          = "";        // 성명
    String phoneNo	     = "";	    // 휴대폰번호
    String phoneCorp     = "";   // 이동통신사
	String birthDay	     = "";	// 생년월일
	String gender	     = "";		// 성별
    String nation        = "";      // 내외국인 구분
	String plusInfo      = "";	// 추가DATA정보
    String extendVar = "0000000000000000";                                   // 복호화용 임시필드
    String tr_url    = BaseUtils.getConfiguration("dtok.domain") + request.getContextPath() + "/view/com/popupns/selfChkRtnPopup.jsp?certNum=" + certNum;  // 본인실명확인 결과수신 URL
    //String tr_url   = "32" + TrmsUtils.getPath( "/jsp/trms/pop/userCerticificaionResult.jsp" );  // 본인실명확인 결과수신 URL
	
	//String certGb	= "H";                                       // 본인실명확인 본인확인 인증수단:핸드폰
	//String addVar	= request.getParameter("addVar");                           // 본인실명확인 추가 파라메터

	/** certNum 주의사항 **************************************************************************************
	* 1. 본인인증 결과값 복호화를 위한 키로 활용되므로 중요함.
	* 2. 본인인증 요청시 중복되지 않게 생성해야함. (예-시퀀스번호)
	* 3. certNum값은 본인인증 결과값 수신 후 복호화키로 사용함.
	       tr_url값에 certNum값을 포함해서 전송하고, (tr_url = tr_url + "?certNum=" + certNum;)
		   tr_url에서 쿼리스트링 형태로 certNum값을 받으면 됨. (certNum = request.getParameter("certNum"); )
	*
	***********************************************************************************************************/
	
	//01. 한국모바일인증(주) 암호화 모듈 선언
	IcertSecuManager seed  = new IcertSecuManager();
	
	//02. 1차 암호화 (tr_cert 데이터변수 조합 후 암호화)
	String enc_tr_cert = "";
	tr_cert            = cpId +"/"+ urlCode +"/"+ certNum +"/"+ date +"/"+ certMet +"/"+ birthDay +"/"+ gender +"/"+ name +"/"+ phoneNo +"/"+ phoneCorp +"/"+ nation +"/"+ plusInfo +"/"+ extendVar;
	enc_tr_cert        = seed.getEnc(tr_cert, "");
	
	//03. 1차 암호화 데이터에 대한 위변조 검증값 생성 (HMAC)
	String hmacMsg = "";
	hmacMsg = seed.getMsg(enc_tr_cert);
	
	//04. 2차 암호화 (1차 암호화 데이터, HMAC 데이터, extendVar 조합 후 암호화)
	tr_cert  = seed.getEnc(enc_tr_cert + "/" + hmacMsg + "/" + extendVar, "");
	
	/*
	Cookie c = new Cookie("reqNum", reqNum);
	//c.setMaxAge(1800);  // <== 필요시 설정(초단위로 설정됩니다)
	response.addCookie(c);

    //01. 암호화 모듈 선언
	com.sci.v2.pcc.secu.SciSecuManager seed  = new com.sci.v2.pcc.secu.SciSecuManager();

	//02. 1차 암호화
	String encStr = "";
	String tr_cert      = id+"^"+srvNo+"^"+reqNum+"^"+certDate+"^"+certGb+"^"+addVar+"^"+exVar;  // 데이터 암호화
	encStr              = seed.getEncPublic(reqInfo);

	//03. 위변조 검증 값 생성
	com.sci.v2.pcc.secu.hmac.SciHmac hmac = new com.sci.v2.pcc.secu.hmac.SciHmac();
	String hmacMsg = hmac.HMacEncriptPublic(encStr);

	//03. 2차 암호화
	reqInfo  = seed.getEncPublic(encStr + "^" + hmacMsg + "^" + "0000000000000000");  //2차암호화
	*/
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

<script>
    <!--
    window.name = "본인인증";
	var KMCIS_window;
	
	function openKMCISWindow() {		
	   var UserAgent = navigator.userAgent;
	    /* 모바일 접근 체크*/
	    // 모바일일 경우 (변동사항 있을경우 추가 필요)
	    /*
	    if (UserAgent.match(/iPhone|iPod|Android|Windows CE|BlackBerry|Symbian|Windows Phone|webOS|Opera Mini|Opera Mobi|POLARIS|IEMobile|lgtelecom|nokia|SonyEricsson/i) != null || UserAgent.match(/LG|SAMSUNG|Samsung/) != null) {
	   		 document.reqKMCISForm.target = '';
		  } else { // 모바일이 아닐 경우
	   		KMCIS_window = window.open('', 'KMCISWindow', 'width=425, height=550, resizable=0, scrollbars=no, status=0, titlebar=0, toolbar=0, left=435, top=250' );

	   		if(KMCIS_window == null){
	  			alert(" ※ 윈도우 XP SP2 또는 인터넷 익스플로러 7 사용자일 경우에는 \n    화면 상단에 있는 팝업 차단 알림줄을 클릭하여 팝업을 허용해 주시기 바랍니다. \n\n※ MSN,야후,구글 팝업 차단 툴바가 설치된 경우 팝업허용을 해주시기 바랍니다.");
	        }
	   		
	   		document.reqKMCISForm.target = 'KMCISWindow';
		  }
		*/
		  document.reqKMCISForm.action = 'https://www.kmcert.com/kmcis/web/kmcisReq.jsp';
		  document.reqKMCISForm.submit();
	}
	//-->
</script>
</head>
<body onload="javascript:openKMCISWindow();">
<!-- 본인실명확인서비스 요청 form --------------------------->
<form name="reqKMCISForm" method="post" action = "">
    <input type="hidden" name="tr_cert"     value = "<%=tr_cert%>">
    <input type="hidden" name="tr_url"      value = "<%=tr_url%>">    
</form>

</body>
</html>
