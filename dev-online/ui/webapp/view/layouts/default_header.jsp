<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="nexcore.framework.core.Constants"%>
<%@ page import="nexcore.framework.core.code.ICode"%>
<%@ page import="nexcore.framework.core.data.IRecord"%>
<%@ page import="nexcore.framework.core.data.IRecordSet"%>
<%@ page import="nexcore.framework.core.data.user.IUserInfo"%>
<%@ page import="nexcore.framework.core.util.BaseUtils"%>
<%@ page import="nexcore.framework.online.channel.util.WebUtils"%>
<%
    IUserInfo userInfo = WebUtils.getSessionUserInfo(request);

    java.util.List topMenuList = null==userInfo ? null : (java.util.List)userInfo.get("psnm-topmenus"); //top-menu-rs
    int topMenuCount = null==topMenuList ? 0 : topMenuList.size();

%>
<!-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++ default_header ++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
<div id="header">
    <div class="nhearder">
        <h1><a href="#" onclick="javascript:$.PSNM.openLink('/view/main.jsp', null, true);"><img id="site-logo" src="<c:out value='${pageContext.request.contextPath}'/>/image/logo.gif" alt="로고" /></a></h1>
        <ul class="toptxt1" style="width: 395px;">
            <li class="ft01">
                <b>[<a id="topUserName"><%=userInfo.get("USER_NM")%></a>]
                    <a id="btnPaper" data-menuid="5501" class="menu-link" onclick='$.PSNM.openMenuLink({menuid:"5501"});'><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a1.gif" alt="받은쪽지개수" /></a>
                    <span id="RCV_PAPER_CNT" title="읽지 않은 받은쪽지 개수"><c:out value='${sessionScope.nc_user["RCV_PAPER_CNT"]}'/></span>통
                </b>
            </li>
            <li class="ft02"><a href="#" onclick="javascript:$.PSNM.openMenuLink({'menuid':'4102'});">마이페이지</a></li>
            <li class="ft03"><a href="#" onclick="javascript:$.PSNM.sitemap();">전체메뉴</a></li>
            <li class="ft04"><a href="#" onclick="javascript:$.PSNM.logout(); return false;"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/btn_a1.gif"></a></li>
        </ul>
    </div>
    <div class="gnb">
        <ul class="g_menu">
          <c:forEach var='tmenu' items='${sessionScope.nc_user["psnm-topmenus"]}' varStatus='status'>
            <!-- class="on" 활성화 -->
            <li><a data-menuid='<c:out value="${tmenu.MENU_ID}"/>' id='top-menu-<c:out value="${tmenu.MENU_ID}"/>' class='topmenu'><c:out value="${tmenu.MENU_NM}"/></a></li>
          </c:forEach>
        </ul>
        <p class="dimenu">
            <b><a data-menuid="9999" id="top-menu-9999">바로가기 +</a></b>
            <ul id="quick-link-list" class="dropdown_block" style="display: none;"> <!-- data-type="dropdown" data-base="#top-menu-9999" -->
                  <c:if test='${sessionScope.nc_user["ATTC_CAT"] == "1" || sessionScope.nc_user["ATTC_CAT"] == "2"}'>
                    <li><a data-menuid="4102" class="menu-link">• MY정보</a></li>                  
                    <li><a data-menuid="1302" class="menu-link">• 회원정보관리(본사)</a></li>
                    <li><a data-menuid="1303" class="menu-link">• 에이전트계약관리(본사)</a></li>
                    <li><a data-menuid="1701" class="menu-link">• 고객민원관리(본사)</a></li>
                    <li><a data-menuid="1703" class="menu-link">• 비정상영업소명관리(본사)</a></li>
                    <li><a data-menuid="1604" class="menu-link">• 면담현황(본사)</a></li>
                    <li><a data-menuid="1208" class="menu-link">• 문자발송(본사)</a></li>
                  </c:if>
                  <c:if test='${sessionScope.nc_user["ATTC_CAT"] == "3"}'>
                    <li><a data-menuid="4102" class="menu-link">• MY정보</a></li>                                   
                    <li><a data-menuid="1701" class="menu-link">• 고객민원관리(본사)</a></li>
                    <li><a data-menuid="1703" class="menu-link">• 비정상영업소명관리(본사)</a></li>
                  </c:if>
                  <c:if test='${sessionScope.nc_user["DUTY"] == "14"}'>
                    <li><a data-menuid="4102" class="menu-link">• MY정보</a></li>                                   
                    <li><a data-menuid="2203" class="menu-link">• 에이전트계약관리(영업국)</a></li>
                    <li><a data-menuid="6501" class="menu-link">• 고객민원관리(영업국)</a></li>
                    <li><a data-menuid="6502" class="menu-link">• 비정상영업소명관리(영업국)</a></li>
                    <li><a data-menuid="6404" class="menu-link">• 면담현황(영업국)</a></li>
                    <li><a data-menuid="2302" class="menu-link">• SMS발송(영업국)</a></li>
                  </c:if>
                  <c:if test='${sessionScope.nc_user["DUTY"] == "16"}'>
                    <li><a data-menuid="4102" class="menu-link">• MY정보</a></li>                                   
                    <li><a data-menuid="6701" class="menu-link">• 에이전트계약관리(영업팀)</a></li>
                    <li><a data-menuid="6905" class="menu-link">• SMS발송(영업팀)</a></li>
                  </c:if>
                    <li><a data-menuid="4204" class="menu-link">• FAQ</a></li>
            </ul>
        </p>
    </div>
</div>
    <div id="sub-menu-div" style="display:; position:relative; z-index: 100002;width: 90%;min-width: 960px;margin: 0 auto;">
        <!-- 20150107 gnb_submenu -->
        <ul id="sub-menu-dropdown-sample" data-type="dropdown" class="af-dropdown af-default" data-converted="true" style="display:none !important;position: absolute; top:-10px; display: block;width:100%;">
        	<li class="gnb-sub"><strong>회원관리</strong>
        		<ul>
        			<li><a href="#">&bull; 회원가입요청관리</a></li>
        			<li><a href="#">&bull; 회원가입요청관리</a></li>
        			<li><a href="#">&bull; 회원가입요청관리</a></li>
        			<li><a href="#">&bull; 회원가입요청관리</a></li>
        		</ul>
        	</li>
        	<li class="gnb-sub"><strong>커뮤니티 관리</strong>
        		<ul>
        			<li><a href="#">&bull; 회원가입요청관리</a></li>
        			<li><a href="#">&bull; 회원가입요청관리</a></li>
        			<li><a href="#">&bull; 회원가입요청관리</a></li>
        			<li><a href="#">&bull; 회원가입요청관리</a></li>
        		</ul>
        	</li>
        	<li class="gnb-sub"><strong>커뮤니티 관리</strong>
        		<ul>
        			<li><a href="#">&bull; 회원가입요청관리</a></li>
        			<li><a href="#">&bull; 회원가입요청관리</a></li>
        			<li><a href="#">&bull; 회원가입요청관리</a></li>
        			<li><a href="#">&bull; 회원가입요청관리</a></li>
        		</ul>
        	</li>	
        </ul>
        <ul id="sub-menu-dropdown-sample2" data-type="dropdown" data-converted="true"  class="af-dropdown af-default" style="display:none !important;position: absolute; top:-10px; display: block;width:100%;">
        <li class="gnb-sub"><strong>회원정보</strong>
        <ul>
            <li><a onclick="javascript:$.PSNM.openMenuLink('4001');">&bull; SAMPLE</a></li>
            <li><a onclick="javascript:$.PSNM.openMenuLink('4102');">&bull; MY정보</a></li>
            <li><a onclick="javascript:$.PSNM.openMenuLink('4103');">&bull; 이용약관</a></li>
            <li><a onclick="javascript:$.PSNM.openMenuLink('4104');">&bull; 개인정보취급방침</a></li>
            <li><a onclick="javascript:$.PSNM.openMenuLink('4107');">&bull; 개인정보수집이용안내</a></li>
            <li><a onclick="javascript:$.PSNM.openMenuLink('4108');">&bull; 개인정보위탁</a></li>
        </ul>
        </li>
        <li class="gnb-sub"><strong>소통의 장</strong>
        <ul>
            <li><a onclick="javascript:$.PSNM.openMenuLink('4301');">&bull; 무엇이든물어보세요</a></li>
            <li><a onclick="javascript:$.PSNM.openMenuLink('4203');">&bull; FAQ관리</a></li>
            <li><a onclick="javascript:$.PSNM.openMenuLink('4204');">&bull; FAQ</a></li>
        </ul>
        </li>
        <li class="gnb-sub"><strong>업계소식</strong>
        <ul>
            <li><a onclick="javascript:$.PSNM.openMenuLink('5401');">&bull; 업계소식</a></li>
        </ul>
        </li>
        </ul>
        
        
        <!-- //20150107 gnb_submenu -->
    </div>
<!--// header end --> 

<script type="text/javascript">
    var canUseSessionStorage = false;
    if (window.sessionStorage) {
        canUseSessionStorage = true;
    }

</script>
<!-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++ default_header ++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->

<!-- left area -->
<div class="left_bar">
    <img id="left_bar_icon" src="<c:out value='${pageContext.request.contextPath}'/>/image/left_bar.gif" width="22" height="106" style="cursor:hand;">

    <div id="left_bar_load" style="display:none;">
        <div class="left_bar_title" id="psnmnav-topmenu-name" data-menuid="1000">본사업무</div>
        <span><img id="left_bar_icon2" src="<c:out value='${pageContext.request.contextPath}'/>/image/left_bar_off.gif" width="22" height="106"></span>
        <div id="psnmnav-area" style="z-index: 100001;">
            <ul id="psnmnav-accordion" data-type="accordion">
                <li>
                    <a>개발예제</a>
                    <ul>
                        <li><a href='#' onclick='javascript:$.PSNM.openMenuLink("/web/view/com/annce/annceList.jsp")'>공지목록예제</a></li>
                        <li><a href='https://docs.google.com/presentation/d/1lqj28Vo9xDNIHWcsYFmuYFZzUaEZvE6eIiBVFioOcGY/edit?usp=sharing' target='_blank'>javascript 개발공지</a></li>
                        <li><a href='https://docs.google.com/presentation/d/1MacjE7vlfp2XWEYBh2MDZpZyu9vFnc_qjT8axb73MfU/edit?usp=sharing' target='_blank'>java 개발공지</a></li>
                    </ul>
                </li>
                <li>
                    <a>회원관리</a>
                    <ul>
                        <li><a>회원가입요청관리</a></li>
                        <li><a>회원정보관리</a></li>
                        <li><a>회원정보관리</a></li>
                        <li><a>MA지원상담관리</a></li>
                        <li><a>에이전트 계약관리</a></li>
                        <li><a>에이전트 정보조회</a></li>
                        <li><a>전화번호부</a></li>
                        <li><a>커뮤니티관리</a></li>
                    </ul>
                </li>
                <li>
                    <a>커뮤니티관리</a>
                </li>
                <li>
                    <a>판매관리</a>
                </li>
                <li>
                    <a>에이전트관리</a>
                </li>
                <li>
                    <a>영업현황</a>
                </li>
                <li>
                    <a>공통관리</a>
                </li>
                <li>
                    <a>마스터관리</a>
                    <ul>
                        <li><a>회원가입요청관리</a></li>
                        <li><a>회원정보관리</a></li>
                        <li><a>회원정보관리</a></li>
                        <li><a>MA지원상담관리</a></li>
                        <li><a>에이전트 계약관리</a></li>
                        <li><a>에이전트 정보조회</a></li>
                        <li><a>전화번호부</a></li>
                        <li><a>커뮤니티관리</a></li>
                    </ul>
                </li>
            </ul>
        </div>
    </div>
</div>
<!--// left area -->
