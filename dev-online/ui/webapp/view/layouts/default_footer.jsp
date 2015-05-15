<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="nexcore.framework.core.data.user.IUserInfo"%>
<%@ page import="nexcore.framework.online.channel.util.WebUtils"%>
<%
    //
%>
<!-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++ default_footer ++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->

<div id="footer-hidden-area" style="display:none;">
    <iframe id="footer-hidden-iframe" src="" width="90%;" height="50"></iframe>
</div>

<footer id="footer">
    <div class="footer">
        <div class="masterbotm">
            <p class="foot_logo"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_b1.gif"> </p>
            <ul class="footdept">
                  <li id="footer-link-01" class="foot01"><a href="#" data-menuid="4104" class="menu-link">개인정보 취급방침</a></li>
                  <li id="footer-link-02" class="foot02"><a href="#" data-menuid="4103" class="menu-link">이용약관</a></li>
                  <li id="footer-link-03" class="foot03"><a href="#" data-menuid="4107" class="menu-link">개인정보 수집이용안내</a></li>
                  <li id="footer-link-04" class="foot04"><a href="#" data-menuid="4108" class="menu-link">개인정보 위탁</a></li>
                </ul>
            <ul class="footbotm">
                  <li class="botm01">서울특별시 성동구 아차산로 38 개풍빌딩 10층 상호: 피에스앤마케팅(주)</li>
                </ul>
            <ul class="footaddr">
                  <li class="addr01">대표이사:조우현 / 사업자등록번호: 104-86-20016 </li>
                </ul>
            <p class="copyr">COPYRIGHT© 2015 PS&MARKETING CO,LTD. ALL RIGHTS RESERVED. </p>
            <ul class="sns">
                  <li id="footer-info-01" class="textc2">대표번호</li>
                  <li id="footer-info-02" class="textc3">070-7470-1000</li>
                  <li class="textc4">평일 9시 - 18시</li>
                  <li id="footer-info-03" class="textc5"></li><!-- [D] 로그인전 노출 -->
                  <li class="blue">
                    <a class="menu-link" data-menuid="4204"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/btn_a3.gif"></a>
                    <a class="menu-link" data-menuid="4301"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/btn_a4.gif"></a>
                  </li>
                  
            </ul>
            <p></p>
        </div>
    </div>
</footer>
<script type="text/javascript">
var surl = window.location.href;
if ( surl.indexOf("index.jsp") < 0 ) {
<%
    IUserInfo userInfo = WebUtils.getSessionUserInfo(request);

    if ( null != userInfo ) {
        String attcCat = (String)userInfo.get("ATTC_CAT");
        if ( !"1".equals(attcCat) && !"2".equals(attcCat) ) {
%>
            $("#footer ul.sns #footer-use-rstrct").hide();
<%
        }
    }
%>
    //var attcCat = $.PSNM.getSession("ATTC_CAT");
    //if ( "1"!=attcCat && "2"!=attcCat) {
    //    $("#footer ul.sns #footer-use-rstrct").hide();
    //}
}

function popupUseRstrct() {
}
</script>
<!-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++ default_footer ++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->