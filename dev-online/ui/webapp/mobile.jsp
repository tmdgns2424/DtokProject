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
    System.out.println("<mobile> ip() : [" + ip0 + "], IP : [" +  _IP + "]");

    IUserInfo userInfo = WebUtils.getSessionUserInfo(request);

    if ( null != userInfo ) {
        String loginId = userInfo.getLoginId();
        if ( null != loginId && !"".equals(loginId) && !"Anonymous".equals(loginId) ) {
            System.out.println("<mobile> 사용자(ID=" + loginId + ")는 이미 로그인되었음. 메인화면으로 이동!\n\n");
            response.sendRedirect("/view/main.jsp");
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no"/>
    <title>D-tok 모바일 로그인</title>

    <link rel="stylesheet" type="text/css" href="<c:out value='${pageContext.request.contextPath}'/>/css/psnm-login.css">
    <link rel="stylesheet" type="text/css" href="<c:out value='${pageContext.request.contextPath}'/>/css/psnm-default.css">
    <link rel="stylesheet" type="text/css" href="<c:out value='${pageContext.request.contextPath}'/>/css/psnm-alopex-ui.css">

    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/jquery-1.10.1.js"></script>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/alopex-ui.js"></script>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/alopex-grid.js"></script>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/alopex-grid-render.js"></script>

    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/psnm-config.js"></script>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/psnm-common.js"></script>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/psnm-utils.js"></script>

    <script type="text/javascript">
    _LOG_LEVEL = 0;

    $.alopex.page({
        init : function(id, param) {
            if ( !$.PSNMUtils.isMobile() ) {
                location.href = "/";
                return;
            }
            $a.page.setCookieValue();
            $a.page.trimInputs();
            $a.page.setEventListener();
            $a.page.setFooterElements();
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
        }
        ,
        setFooterElements : function() {
            //$("#footer ul.sns img").hide();
            $(".footer_wrap #footer-link-02").hide(); //이용약관
            $(".footer_wrap #footer-link-03").hide(); //개인정보 수집이용안내

            $(".footer_wrap #footer-link-01").click(function() {
                var w = $( window ).width();
                var h = window.innerHeight - 50; //$( window ).height();
                $a.popup({
                    url: "com/popupns/privacyPolicyPop"
                  , data: {}
                  , width: w
                  , height: h
                  , windowpopup: false
                  , iframe: true
                  , title: "개인정보 취급방침"
                });
            });
            $(".footer_wrap #footer-link-04").click(function() {
                var w = $( window ).width();
                var h = window.innerHeight - 50; //$( window ).height();
                $a.popup({
                    url: "com/popupns/privacyTrustedPop"
                  , data: {}
                  , width: w
                  , height: h
                  , windowpopup: false
                  , iframe: true
                  , title: "개인정보 위탁"
                });
            });
            
            $(".menu-link").click(function() {
                //var menuid = $(this).data("menuid");
                //$.PSNM.openMenuLink({"menuid":menuid});
            });
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
                    $a.cookie(_COOKEY_INDEX_ID_SAVE, $("#USER_ID").val()); //"PSNM_IDSAVE"
                }
                else {
                    $a.cookie(_COOKEY_INDEX_ID_SAVE, ""); //"PSNM_IDSAVE"
                }

                var topmenu = res.dataSet.recordSets["top-menu"].nc_list;
                sessionStorage.setItem("top-menu", JSON.stringify(topmenu));
                console.log( "sessionStorage[top-menu]\n\n"+ sessionStorage.getItem("top-menu") );

                if ( "Y"==res.dataSet.fields["NEED_TO_CHECK_NAME"] ) {
                    $a.navigate( _NAMECHECK_URL );
                    return;
                }
                $a.navigate( _MAINPAGE_URL ); //goto main page
            }
        });
    }
    </script>
</head>

<body>

<div id="mobile_login">
    <h1>Dtok</h1>
    <div class="login_block">
        <p class="saveid">
            <input id="CHK_IDSAVE" name="CHK_IDSAVE" type="checkbox" data-type="checkbox" data-theme="af-check" class="spaceL"/>
            <label for="check">아이디 저장</label>
        </p>
        <div class="login_form" id="loginForm">
            <label for="uid">아이디</label>
            <input id="USER_ID" name="USER_ID" type="text" data-type="textinput" data-keyfilter-rule="digits|uppercase"
                       data-validation-rule="{required:true, minlength:4}" 
                       data-validation-message="{required:'아이디를 입력하세요!', minlength:'4자리 이상 아이디를 입력하세요!'}" 
                       maxlength="15" value="" 
                       onfocus="this.className='psnm-login-userid input_text focus'" onblur="if (this.value.length==0) {this.className='psnm-login-userid input_text'}else {this.className='psnm-login-userid input_text focusnot'};" 
                       class="psnm-login-userid input_text">
            <label for="upw">비밀번호</label>
            <input id="PWD" name="PWD" type="password" data-type="textinput"
                       data-validation-rule="{required:true, minlength:4}" 
                       data-validation-message="{required:'비밀번호를 입력하세요!', minlength:'비밀번호는 4자 이상 입력하세요!'}" 
                       maxlength="20" value="" 
                       onfocus="this.className='psnm-login-passwd input_text focus';" onblur="if (this.value.length==0) {this.className='psnm-login-passwd input_text'}else {this.className='psnm-login-passwd input_text focusnot'};"
                       class="psnm-login-passwd input_text"/>
            <input id="USER_IP"   name="USER_IP"   type="hidden" value="<%=_IP%>"/>
            <input id="IS_MOBILE" name="IS_MOBILE" type="hidden" value="Y"/>
        </div>
        <p class="login_btn">
            <button id="btnLogin" data-type="button" data-theme="af-btnlogin" data-converted="true">로그인</button>
        </p>
    </div>

    <div class="footer_wrap">
        <ul>
            <li id="footer-link-01" class="foot01"><a href="#" data-menuid="4104" class="menu-link">개인정보 취급방침</a></li>
            <!--
            <li id="footer-link-02" class="foot02"><a href="#" data-menuid="4103" class="menu-link">이용약관</a></li>
            <li id="footer-link-03" class="foot03"><a href="#" data-menuid="4107" class="menu-link">개인정보 수집이용안내</a></li>
            -->
            <li id="footer-link-04" class="foot04"><a href="#" data-menuid="4108" class="menu-link">개인정보 위탁</a></li>
        </ul>
        <address>
            서울특별시 성동구 아차산로 38 개풍빌딩 10층 상호:피에스앤마케팅(주)
            <p>대표이사: 조우현 / 사업자등록번호 : 104-86-20016</p>
            <p>COPYRIGHT 2015 BY PS&MARKETING CO,LTD. ALL RIGHTS RESERVED.</p>
        </address>
    </div>
</div>

</body>
</html>
