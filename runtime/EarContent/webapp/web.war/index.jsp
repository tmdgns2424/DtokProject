<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="nexcore.framework.core.data.user.IUserInfo"%>
<%@ page import="nexcore.framework.online.channel.util.WebUtils"%>
<%
    String _ROOT = "";
    String ip0 = request.getHeader("X-Forwarded-For"); //X-Forwarded-For
    String ip1 = request.getHeader("HTTP_X_FORWARDED_FOR");
    String addr = request.getRemoteAddr();
    String _IP = (null==ip0 || "".equals(ip0) ? (null==ip1 || "".equals(ip1) ? addr : ip1) : ip0);

    IUserInfo userInfo = WebUtils.getSessionUserInfo(request);

    if ( null != userInfo ) {
        String loginId = userInfo.getLoginId();
        if ( null != loginId && !"".equals(loginId) && !"Anonymous".equals(loginId) ) {
            System.out.println("<index> 사용자(ID=" + loginId + ")는 이미 로그인되었음. 메인화면으로 이동!\n\n");
            response.sendRedirect("/view/main.jsp");
        }
    }
    
    String sysid   = nexcore.framework.core.util.AppUtils.getProperty("system.id");
    String runmode = nexcore.framework.core.util.AppUtils.getProperty("nexcore.runtime.mode." + sysid);
    if ( ! "R".equals(nexcore.framework.core.util.BaseUtils.getRuntimeMode()) ) {
        System.out.println("<index> ip() : [" + ip0 + "], IP : [" +  _IP + "]");
        System.out.println("<index> system.id = [" + sysid + "], runtime.mode = [" + runmode + "] RuntimeMode = " + nexcore.framework.core.util.BaseUtils.getRuntimeMode());
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

    <%--jsp:include page="/view/layouts/default_head.jsp" flush="false" /--%>

    <link rel="stylesheet" type="text/css" href="<c:out value='${pageContext.request.contextPath}'/>/css/psnm-login.css">
    <link rel="stylesheet" type="text/css" href="<c:out value='${pageContext.request.contextPath}'/>/css/psnm-default.css">
    <link rel="stylesheet" type="text/css" href="<c:out value='${pageContext.request.contextPath}'/>/css/psnm-alopex-ui.css">

    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/jquery-1.11.2.js"></script>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/alopex-ui.js"></script>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/alopex-grid.js"></script>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/alopex-grid-render.js"></script>

    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/psnm-config.js"></script>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/psnm-common.js"></script>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/psnm-utils.js"></script>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/psnm-webcube.js"></script>

    <script type="text/javascript">
    _LOG_LEVEL = 0;
    _RUNTIME_MODE = "<%=nexcore.framework.core.util.BaseUtils.getRuntimeMode()%>";

    $.alopex.page({
        init : function(id, param) { 
            $a.page.setCookieValue();
            $a.page.trimInputs();
            $a.page.setEventListener();
            $a.page.setFooterElements();
            if ( "R"!= _RUNTIME_MODE ) {
                $a.page.setTestEvent();
            }
        }
        ,
        setCookieValue : function() {
            if ( $.PSNMUtils.isNotEmpty( $a.cookie(_COOKEY_INDEX_ID_SAVE) ) ) { //'PSNM_IDSAVE'
                $("#CHK_IDSAVE").prop("checked", true);
                $("#USER_ID").val( $a.cookie(_COOKEY_INDEX_ID_SAVE) ); //'PSNM_IDSAVE'
                $("#PWD").focus();
            }
            else {
                $("#USER_ID").focus();
            }
        }
        ,
        setEventListener : function() {
            $("#btnLogin").click( doLogin );
            $("#USER_ID").keyup(function(e) {
                if (13==e.which) {
                    if ( $("#USER_ID").val().length>7 ) {
                        if ( $("#PWD").val().length>3 ) {
                            doLogin();
                        }
                        else {
                            $("#PWD").focus();
                        }
                    }
                }
            });
            $("#PWD").keyup(function(e) {
                if (13==e.which) {
                    if ( $("#PWD").val().length>3 ) {
                        if ( $("#USER_ID").val().length>7 ) {
                            doLogin();
                        }
                        else {
                            $("#USER_ID").focus();
                        }
                    }
                }
            });
            $("#btnMember").click( function() {
                openPopup("step1", {});
                //openPopup("step3", {RESULT:'Y'});
            });
        } //end-of-setEventListener
        ,
        setFooterElements : function() {
            $("#footer ul.sns img").hide();
            $("#footer #footer-link-02").hide(); //이용약관
            $("#footer #footer-link-03").hide(); //개인정보 수집이용안내
            $("#footer #footer-info-01").text("모집관련 문의처");
            $("#footer #footer-info-02").text("070-7470-3440");
            $("#footer #footer-info-03").text("상기 연락처 외에 회사 대표번호로 모집과 관련한 문의를 하지 않도록 주의바랍니다.");

            $("#footer #footer-link-01").click(function() {
                $a.popup({
                    url: "com/popupns/privacyPolicyPop"
                  , data: {}
                  , width: 1000
                  , height: 650
                  , windowpopup: false
                  , iframe: true
                  , title: "개인정보 취급방침"
                });
            });
            $("#footer #footer-link-04").click(function() {
                $a.popup({
                    url: "com/popupns/privacyTrustedPop"
                  , data: {}
                  , width: 1000
                  , height: 380
                  , windowpopup: false
                  , iframe: true
                  , title: "개인정보 위탁"
                });
            });
            
            $(".menu-link").click(function() {
                //var menuid = $(this).data("menuid");
                //$.PSNM.openMenuLink({"menuid":menuid});
            });
            $("#footer #footer-link-01 a").css("color", "red");
            $("#footer #footer-link-04 a").css("color", "red");
        }
        ,
        setTestEvent : function() {
            $("#test-div a.test-user").click(function() {
                $("#USER_ID").val( $(this).data("userid") );
                $("#PWD").val("1111");
                doLogin();
            });
            $("#test-div").show();
        }
        ,
        trimInputs : function() {
            var userid = $("#USER_ID").val();
            var passwd = $("#PWD").val();
            if ( userid.length < 1) {
                $("#USER_ID").removeClass('focusnot');
            }
            else {
                $("#USER_ID").addClass('focusnot');
            }
            if ( passwd.length < 1) {
                $("#PWD").removeClass('focusnot');
            }
            else {
                $("#PWD").addClass('focusnot');
            }
        }

    });

    function doLogin() {
        if ( !$.PSNM.isValid("#loginForm") ) {
            return false;
        }
        var formdata = $.PSNMUtils.getFormData("loginForm");

        $.alopex.request('com.MAINLOGIN@PLOGIN001_pSearchLogin', {
            url: _CTX_PATH + "login.jmd",
            data: {
                dataSet: {
                    fields: formdata,
                    recordSets: {}
                }
            },
            success: function(res) { 
                if ( ! $.PSNM.success(res) ) {
                    $("#PWD").focus();
                    return;
                }

                if ( $("#CHK_IDSAVE").prop("checked") ) {
                    $a.cookie(_COOKEY_INDEX_ID_SAVE, $("#USER_ID").val(), 10); //"PSNM_IDSAVE"
                }
                else {
                    $a.cookie(_COOKEY_INDEX_ID_SAVE, "");
                }

                if ( "N"==res.dataSet.fields["DSMUSER_YN"] ) { //@2015-04-07
                    $a.navigate( _EMP_REG_URL );
                    return;
                }

                var topmenu = res.dataSet.recordSets["top-menu"].nc_list;
                sessionStorage.setItem("top-menu", JSON.stringify(topmenu));
                console.log( "sessionStorage[top-menu]\n\n"+ sessionStorage.getItem("top-menu") );

                if ( "Y"==res.dataSet.fields["NEED_TO_CHECK_NAME"] ) {
                    $a.navigate( _NAMECHECK_URL );
                    return;
                }
                $a.navigate( _MAINPAGE_URL );
            }
        });
    }

    function popupIdSearch() {
        $a.popup({
            url: "com/popupns/idSearchPop"
          , data: {}
          , width: 600
          , height: 300
          , windowpopup: false
          , iframe: true
          , title: "아이디 찾기"
        });
    }
    function popupPwSearch() {
        $a.popup({
            url: "com/popupns/pwSearchPop"
          , data: {}
          , width: 600
          , height: 350
          , windowpopup: false
          , iframe: true
          , title: "비밀번호 찾기"
        });
    }

    function popupNsOrgSample() { //팝업 : NS조직예제
        $a.popup({
            url: "com/popupns/nsOrgSamplePop"
          , data: { }
          , width: 500
          , height: 300
          , windowpopup: true
          //, iframe: true
          , title: "NS조직예제"
        });
    }
    
    function openPopup( div, data ){
    	var url, title, width, height, iframe=false, windowpopup=true;
    	
    	switch ( div ){
    		case "step1":
    			url = "com/popupns/selfChkConfirmPopup";
    			title = "본인확인";
    			width = "500";
    			height = "280";
    		break;
    		case "step2":
    			url = "com/popupns/selfChkPopup";
    			title = "본인확인";
    			width = "500";
    			height = "600";
    		break;
    		case "step3":
    			url = "com/userinfo/userScrbReqRgstAgree";
    			title = "회원가입";
    			width = "830";
    			height = "700";
    		break;  
    		case "step4":
    			url = "com/userinfo/userScrbReqRgst";
    			title = "회원가입";
    			width = "980";
    			height = "750";
    		break;
    	}

        $a.popup({
            url: url,
            data: data,
            title : title,
            width: width,
            height: height,
            iframe: iframe,
            windowpopup: windowpopup,
            modal : false,
            callback : function( oResult ) {
                popupCallback( div, oResult );
            }
        });
    }
    
    function popupCallback( div, oResult ){
    	switch ( div ){
    		case "step1":
    			if( oResult.confirm == "Y"){
    				openPopup("step2", oResult);
    			}
    		break;
    		case "step2":
    			if( oResult.RESULT == "Y"){
    				openPopup("step3", oResult);
    			}
    		break;  
    		case "step3":
    			if( oResult.chk1 == "Y" && oResult.chk2 == "Y" && oResult.chk3 == "Y" && oResult.chk4 == "Y"){
    				openPopup("step4", oResult);
    			}
    		break;
    	}
    }
    
    //지원상담요청,지원서작성,진행상황 팝업으로 가기 위한 팝업
    function popupMASupport( div, data ) {
    	var url, title, width, height, iframe=true, windowpopup=false;
    	
        switch ( div ){
	        case "step0":
	            url = "com/popupns/agentCntrtPopup";
	            title = "MA 지원";
	            width = "600";
	            height = "250";
	        break;
	        case "step1":
                url = "com/popupns/agentCnslReqPopup";
                title = "지원상담요청";
                width = $.PSNM.popWidth(700);
                height = $.PSNM.popHeight(530);
            break;
	        case "step2":
                url = "com/popupns/agentCntrtReqPopup";
                title = "지원서작성";
                width = $.PSNM.popWidth(830);
                height = $.PSNM.popHeight(700);
            break;
	        case "step3":
                url = "com/popupns/agentCnslProcPopup";
                title = "진행현황";
                width = $.PSNM.popWidth(830); //"830";
                height = $.PSNM.popHeight(600); //"600";
            break;
            //개인정보취급동의서
	        case "step4":
                url = "com/popupns/privacyPolicyAgreePop";
                title = "개인정보 취급방침";
                width = $.PSNM.popWidth(830); //"830";
                height = $.PSNM.popHeight(700); //"600";
            break;
	    }
        
        
	    
	    $a.popup({
	        url: url,
	        data: data,
	        title: title,
	        width: width,
	        height: height,
	        iframe: iframe,
	        windowpopup: windowpopup,
	        callback : function( oResult ) {
	            popupCallback2( oResult );
	        }
	    });
    }
    
    function popupCallback2( oResult ){
    	
    	if( $.PSNMUtils.isEmpty( oResult ) ){
    		return;
    	}
    	
    	switch ( oResult.div ){
            case "step1":
                popupMASupport("step1", oResult);
                break;
            case "step2":
            	popupMASupport("step2", oResult);
                break;  
            case "step3":
            	popupMASupport("step3", oResult);
                break;
            case "step4":
                popupMASupport("step4", oResult);
                break;
        }
    }

    function checkBrowser() {
        var ie_version = gf_get_ie_version();
        _debug("ie_version(신) = " + ie_version);

        if ( !gf_is_mobile() ) {
            if ( ie_version > 0 ) {
                ie_check_webcube();
            }
            else {
                noie_check_webcube();
            }
        }
    }

    </script>
</head>

<body onload="javascript:checkBrowser();">

<div id="header">
    <div class="nhearder">
        <h1><img src="<c:out value='${pageContext.request.contextPath}'/>/image/logo.gif" ></h1>
    </div>
</div>

<div id="loginbox">
    <div id="login">
        <p class="keeping">
            <input id="CHK_IDSAVE" name="CHK_IDSAVE" type="checkbox" data-type="checkbox" data-theme="af-check" class="spaceL"/>
            <label for="check">아이디 저장</label>
        </p>
        <dl id="loginForm">
            <dt>
                <label for="uid">아이디</label>
            </dt>
            <dd class="uid">
                <input id="USER_IP"   name="USER_IP"   type="hidden" value="<%=_IP%>"/>
                <input id="IS_MOBILE" name="IS_MOBILE" type="hidden" value="N"/>
                <input id="USER_ID" name="USER_ID" type="text" data-type="textinput" 
                       data-validation-rule="{required:true, minlength:4}" 
                       data-validation-message="{required:'아이디를 입력하세요!', minlength:'4자리 이상 아이디를 입력하세요!'}" 
                       maxlength="15" value="" 
                       onfocus="this.className='psnm-login-userid input_text focus'" onblur="if (this.value.length==0) {this.className='psnm-login-userid input_text'}else {this.className='psnm-login-userid input_text focusnot'};" 
                       class="psnm-login-userid input_text">
            </dd>
            <dt>
                <label for="upw">비밀번호</label>
            </dt>
            <dd class="upw">
                <input id="PWD" name="PWD" type="password" data-type="textinput"
                       data-validation-rule="{required:true, minlength:4}" 
                       data-validation-message="{required:'비밀번호를 입력하세요!', minlength:'비밀번호는 4자 이상 입력하세요!'}" 
                       maxlength="20" value="" 
                       onfocus="this.className='psnm-login-passwd input_text focus';" onblur="if (this.value.length==0) {this.className='psnm-login-passwd input_text'}else {this.className='psnm-login-passwd input_text focusnot'};"
                       class="psnm-login-passwd input_text"/>
            </dd>
        </dl>
        <p class="login">
            <button id="btnLogin" data-type="button" data-theme="af-btnlogin" data-altname="로그인"></button>
            <span style="position:absolute;left:0; bottom:-25px">IE9이상, 크롬, 사파리에서만 정상 이용 가능</span>
        </p>
        <ul class="login_footer">
            <li><a target="_top" href="#" onclick="parent.clickcr(this,'log_off.searchpass','','',event);"></a></li>
            <li><a href="#" onclick="javascript:popupIdSearch();">아이디 찾기</a> <span class="vr">|</span> <a href="#" onclick="javascript:popupPwSearch();">비밀번호 찾기</a></li>
        </ul>
        <p class="member">
            <button id="btnMember" data-type="button"  data-altname="회원가입" style="border-radius:0;"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/btn_login_new.gif"></button>
        <p class="go" style="display:none;"><a href="#"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/btn_login_img.gif"></a></p>
    </div>
    <div id="banner">
        <table cellspacing="0" class="tbl_type">
            <colgroup>
                <col width="100%">
            </colgroup>
            <tbody>
            <tr>
                <td>
                    <div class="main_title">
                        <h2><img src="<c:out value='${pageContext.request.contextPath}'/>/image/login_bg_top1.gif"></h2>
                        <p class="subTxt"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/login_bg_top2.gif"></p>
                        <ul style="padding:70px 0 70px 18px;">
                          <li class="main_contList"><a href="#" onclick="javascript:popupMASupport('step0');"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/login_bg_btn1.gif" data-altname="MA지원상담요청"></a></li>
                          <li class="main_contList" style="margin-left:5px;"><a href="#" onclick="javascript:popupMASupport('step0');"><img src="<c:out value='${pageContext.request.contextPath}' />/image/login_bg_btn2.gif" data-altname="MA지원하기"></a></li>
                          <!-- <li class="main_contList" style="margin-left:7px; margin-top:7px; color:#888887; font-weight:bold;">문의처 : 070-7470-8400<br> -->
                          <li class="main_contList" style="margin-top:7px; color:#888887; width:600px; text-align:left;"> MA는 이동전화 및 각종 ICT 상품 판매/컨설팅을 통해 고객에게 편리한 Digital Life를 제공하는 직업입니다</li>
                        </ul>
                    </div>
                </td>
            </tr>
            </tbody>
        </table>
    </div>
</div>
<!--// 본문 -->
<div id="lay_out">
    <div id="ub_left">
        <div class="box">
            <h1><img src="<c:out value='${pageContext.request.contextPath}'/>/image/h3-bg-1.gif" ></h1>
            <ul>
                <li class="work">이동전화/ 유선상품 <br>
                  가입자 유치 및 ICT 상품 판매
                <li style="text-align:center"><span>거점 B2B특판 및 지인 판매</span> </li>
            </ul>
        </div>
    </div>
    <div id="ub_center">
        <div class="box">
            <h2><img src="<c:out value='${pageContext.request.contextPath}'/>/image/h3-bg-2.gif" ></h2>
            <ul>
                <li class="apply">나이:20세 이상<br>
                  학력:고졸 이상/전공 불문<br>
                  도전정신과 열정을 가진 성실하신 분</li>
                <li >* 프리랜서 계약직으로 에이전트 위촉계약을 <span style="padding-left:5px"> 체결하고 영업활동을 수행함</span><br>
                  * 조직 관리에 적합한 역량을 보일 경우 <br>
                  <span style="padding-left:5px"> 관리자 선임 후 차등 대우</span></li>
            </ul>
        </div>
    </div>
    <div id="ub_right">
        <div class="box">
            <h3><img src="<c:out value='${pageContext.request.contextPath}'/>/image/h3-bg-3.gif" ></h3>
            <ul>
                <li class="apply" style="text-align: center;">판매수수료<br/>+ 유치수수료 <br/>+ 별도 인센티브</li>
                <li>* 월 평균 수입 : 200~300만원<br>
                  * 보상 및 기타 처우는 피에스앤마케팅 <br>
                  <span style="padding-left:5px"> 홈페이지 상의 인사제도와는 별개임</span></li>
            </ul>
        </div>
    </div>
</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

<div id="test-div" style="position:absolute; float:left; top:100px; left:10px; width: 180px; height: 500px; display: none;">
    <span style="font-weight:bold;">[개발 로그인]</span><br /><br />
    <a class="test-user" data-userid="91204841">1. 91204841 (DSM운영자) </a><br />
    <a class="test-user" data-userid="93100012">2. 93100012 (서울1국/DSM국장)</a><br />
    <a class="test-user" data-userid="16115801">3. 16115801 (서울1국/DSM팀장)</a><br />
    <a class="test-user" data-userid="15698601">4. 15698601 (서울1국/DSM MA)</a><br />
    <a class="test-user" data-userid="D1476300">5. D1476300 (이건택/영업국X)</a><br />
    <a class="test-user" data-userid="B100366">6. B100366 (이은희/영업국X)</a><br />

    <hr /><br /><br /><br /><br />

    <span style="font-weight:bold;">[개발용 링크]</span><br /><br />
    <a href="#" onclick="javascript:popupNsOrgSample();">1. NS조직예제</a> <!-- <span class="vr">|</span> -->
</div>

<div id="webcubem"></div>

<script language="javascript">

if ( !gf_is_mobile() && gf_get_ie_version() > 0 ) { //모바일이 아니고, IE 이면
	var WebCubeVersion = "4,1,2,3";
	var clintInfoObj = window.clientInformation;
	var browser = clintInfoObj.platform;
	if((clintInfoObj.appVersion.toLowerCase().indexOf("x64") < 0) &&(clintInfoObj.appVersion.toLowerCase().indexOf("wow64") < 0))
	{
		//alert('32비트OS에 32비트Borwser');
		document.write('<object classid="CLSID:29BC57E0-018D-46D2-B233-338B779C169C" '+
		'width="0" height="0" id="Obj" codebase="WebCube/components/WebCube.cab#version='+WebCubeVersion+'" ' +
		'VIEWASTEXT onerror="NoneActiveX()" onreadystatechange="SetActiveXState()"></object>');
	}
	else
	{
		if(browser.toLowerCase() != "win64")
		{
			//alert('64비트OS에 32비트Borwser');
			document.write('<object classid="CLSID:29BC57E0-018D-46D2-B233-338B779C169C" '+
			'width="0" height="0" id="Obj" codebase="WebCube/components/WebCubewow.cab#version='+WebCubeVersion+'" ' +
			'VIEWASTEXT onerror="NoneActiveX()" onreadystatechange="SetActiveXState()"></object>');			
		}
		else
		{
			//alert('64비트OS에 64비트Borwser');
			document.write('<object classid="CLSID:29BC57E0-018D-46D2-B233-338B779C169C" '+
			'width="0" height="0" id="Obj" codebase="WebCube/components/WebCube64.cab#version='+WebCubeVersion+'" ' +
			'VIEWASTEXT onerror="NoneActiveX()" onreadystatechange="SetActiveXState()"></object>');
		}
	}
}
</script>

</body>
</html>
