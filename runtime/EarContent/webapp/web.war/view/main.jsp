<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="nexcore.framework.core.data.user.IUserInfo"%>
<%@ page import="nexcore.framework.online.channel.util.WebUtils"%>
<%
    IUserInfo userInfo = WebUtils.getSessionUserInfo(request);
    if (userInfo == null) {
        System.err.println("<main> <ERROR> NOT LOGINED!");
    }

    java.util.List topMenuList = null==userInfo ? null : (java.util.List)userInfo.get("psnm-topmenus"); //top-menu-rs
    int topMenuCount = null==topMenuList ? 0 : topMenuList.size();

    System.out.println("<main> IS_MOBILE(모바일접속여부) = '" + userInfo.get("IS_MOBILE") + "'");
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

    <link rel="stylesheet" type="text/css" href="<c:out value='${pageContext.request.contextPath}'/>/css/psnm-alopex-ui.css" />
    <link rel="stylesheet" type="text/css" href="<c:out value='${pageContext.request.contextPath}'/>/css/psnm-alopex-grid.css" />
    <link rel="stylesheet" type="text/css" href="<c:out value='${pageContext.request.contextPath}'/>/css/psnm-default.css" />
    <link rel="stylesheet" type="text/css" href="<c:out value='${pageContext.request.contextPath}'/>/css/psnm-main.css" />

    <style>
        
    </style>

    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/jquery-1.11.2.js"></script>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/alopex-ui.js"></script>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/alopex-grid.js"></script>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/alopex-grid-render.js"></script>

    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/psnm-config.js"></script>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/psnm-common.js"></script>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/psnm-utils.js"></script>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/psnm-main.js"></script><!--메인-->
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/slides.min.jquery.js"></script><!--메인 비주얼-->

    <script type="text/javascript">
    //_LOG_LEVEL = 0;

    var _TX_SEARCH_MAIN1 = "com.MAINLOGIN@PMAIN001_pSearchMain1";

    var _CPLAZA_ORG_CD = "";  //CPLAZA_ORG_CD
    var _CERT_YN       = "Y"; //본인인증 여부
    var _bizBrdCnt = 0;

    var canUseSessionStorage = false;
    if (window.sessionStorage) {
        canUseSessionStorage = true;
    }

    $a.page({
        init : function(id, param) {
            $a.page.setEventListener();
            $.PSNM.setEventTopMenu();
            pSearchMain1(); //메인정보조회

            pnsm_showhide_mainbanners(); //하단 배너아이콘 표시여부
            _bizBrdCnt = $("#main-banner li:visible").length;
        },
        setEventListener : function() {
            $("#RCV_PAPER_CNT").tooltip({position:"bottom"});

            $("#toplinkMyPage").click(function() {
                $.PSNM.openMenuLink({menuid:"4102"});
            }); //마이페이지
            $("#toplinkMenuAll").click(function() {
                $.PSNM.sitemap();
            }); //전체메뉴
            $("#linkChangePasswd").click(function() {
            	if( $.PSNM.getSession("ATTC_CAT")=="1" || $.PSNM.getSession("ATTC_CAT")=="2" || $.PSNM.getSession("ATTC_CAT")=="3" ){
            		$.PSNM.alert("임직원은 비밀번호를 변경할 수 없습니다.");
            		return false;
            	}
                psnm_pop_passwd("");
            }); //비밀번호 변경
            $("#linkChangeMyInfo").click(function() {
                $.PSNM.openMenuLink({menuid:"4102"});
            }); //내정보 수정

            $('#btnScrollRight').click(function() {
                if ( _bizBrdCnt>4 ) {
                    $("#main-banner li:first").hide();
                }
            });
            $('#btnScrollLeft').click(function() {
                if ( _bizBrdCnt>4 ) {
                    $("#main-banner li:first").show();
                }
            });

            $(".menu-link").click(function() {
                var menuid = $(this).data("menuid");
                $.PSNM.openMenuLink({"menuid":menuid});
            });
            $("#birth-today").click(function() {
                popWhoBorn(0);
            });
            $("#birth-tomorrow").click(function() {
                popWhoBorn(1);
            });

            if ( "R" != $.PSNM.getSession("RUNTIME_MODE") ) {
                $("#topUserName").click(function() {
                    $.PSNM.popSessionUser();
                });
            }

            $('#test-btn-1').click(function() {
                //테스트용
            });
        }
    });

    //메인정보조회
    function pSearchMain1() {
        var oparam = $.PSNMUtils.getDefaultFromToYmd();

        $a.request(_TX_SEARCH_MAIN1, {
            showProgress: false,
            data: function() {
                this.data.dataSet.fields.FROM_DT = oparam.FROM_DT;
                this.data.dataSet.fields.TO_DT   = oparam.TO_DT;
            },
            success: function(res) {
                var totalMenuList = res.dataSet.recordSets["menulist"].nc_list; //#전체메뉴#

                displayCounts(res.dataSet.fields, totalMenuList); //건수 표시 : 받은쪽지개수, 회원가입요청건수, 에이전트계약요청건수, ...
                displayMyPic(res.dataSet.fields); //나의사진이미지 :: // res.dataSet.recordSets["gridpicfile"].nc_list 

                displayMainad( res.dataSet.recordSets["gridmainad"].nc_list ); //공지목록 
                displayAnnce( res.dataSet.recordSets["gridannce"].nc_list ); //공지목록 
                displaySch( res.dataSet.recordSets["gridsch"].nc_list ); //주요일정
                displayBirth( res.dataSet.recordSets["gridbirth"].nc_list ); //이달의생일자
                $("#PHRS").text( res.dataSet.fields["PHRS"] ); //명언
                $("#ATHR").text("-"+ res.dataSet.fields["ATHR"] +"-");

                psnm_process_menulist( res.dataSet.recordSets["menulist"].nc_list ); //#전체메뉴#

                if ( "Y" == res.dataSet.fields["NEED_TO_CHANGE_PWD"] ) {
                    psnm_pop_passwd("Y", res.dataSet);
                }
                else {
                    psnm_main_post_process( res.dataSet ); //메인 팝업등 처리
                }
                //psnm_top_timer();
            }
        });
    }

    function displayMainad(arrMainadList) {
        if ( null==arrMainadList || arrMainadList.length<1 ) {
            var shtml = "<li><a href=''><img src='<c:out value='${pageContext.request.contextPath}'/>/image/introduce_bg02.png' width='703' height='217' alt='메인광고'></a></li>";
            $("#mainad-list").append(shtml);
            return;
        }
        $("#mainad-list").empty();
        $.each(arrMainadList, function(index, oMainad) {
            var surl = oMainad["LINK_URL"];
                surl = $.trim(surl);

            var shtml = "<li>";
            if ( $.PSNMUtils.isNotEmpty(surl) && "http://"!=surl ) {
                shtml+= "<a href='" + surl + "' title='" + oMainad["MAIN_AD_NM"] + "' target='_blank'>";
            }
                shtml+= "<img src='" + $.PSNMUtils.getDownloadUrl(oMainad) + "' width='703' height='217'>";
            if ( $.PSNMUtils.isNotEmpty(surl) && "http://"!=surl ) {
                shtml+= "</a>";
            }
                shtml+= "</li>";
            $("#mainad-list").append(shtml); //(예) <li><a href="#"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_b2.gif"></a></li>
        });
        setSlidingBanner();
    }
    function displayAnnce(arrAnnceList) {
        $("#annce-list").empty();
        $.each(arrAnnceList, function(index, oAnnce) {
            var shtml = "<li class='cont03'>";
            if ( "Y"==oAnnce["POPUP_YN"] )
                shtml+= "<img src='<c:out value='${pageContext.request.contextPath}'/>/image/blat_a3.gif' class='b1'>";
            else
                shtml+= "<img src='<c:out value='${pageContext.request.contextPath}'/>/image/blat_a4.gif'>";
                shtml+= "<a href='#' onclick='javascript:popAnnceDet(\"" + oAnnce["ANNCE_ID"] + "\")' title='" + oAnnce["ANNCE_TITL_NM"] + "'>";
                shtml+= "" + oAnnce["ANNCE_TITL_NM"];
                shtml+= "</a>";
                shtml+= "<span class='view'> " + oAnnce["RGST_MD"] + "</span>";
            if ( "0"!=oAnnce["FILE_CNT"] )
                ;//shtml+= "<img class='b2' src='<c:out value='${pageContext.request.contextPath}'/>/image/blat_adisk.gif' />";
                shtml+= "</li>";
            $("#annce-list").append(shtml);
        }); //(예) <li class="cont03"><img src="/web/image/blat_a4.gif"><a href="#">정지기간 준수사항</a> <span class="view">09-11</span></li>
    }
    function popAnnceDet(sAnnceId) {
        $a.popup({
            url: "com/popup/mainAnnceDetPop"
          , data: { ANNCE_ID : sAnnceId }
          , width: $.PSNM.popWidth(830)
          , height: $.PSNM.popHeight(700)
          , title: "공지사항상세"
          , movable:true
        });
    }

    function popSchDet(sSchId) { //주요일정상세 팝업
        $a.popup({
            url : "biz/mainschd/mainSchdCldrDtl"
          , data : { SCH_ID : sSchId, popli : false }
          , width : $.PSNM.popWidth(900)
          , height : $.PSNM.popHeight(700)
          , title : "주요일정상세"
          , movable:true
        });
    }

    function popWhoBorn(dayOffset) { //생일자 팝업
        var t = "오늘의 생일자";
        if ('1'==dayOffset) t = "내일의 생일자";

        $a.popup({
            url : "com/popup/mainBirthPop"
          , data : { "DAY_OFFSET":dayOffset }
          , width : 650
          , height : 550
          , movable:true
          , title : t
          , callback  : function(oParam) {
                if ( $.PSNMUtils.isNotEmpty(oParam) && !jQuery.isEmptyObject(oParam) ) {
                    $.PSNM.openMenuLink({menuid:"5503"}, oParam); //쪽지쓰기
                }
          }
        });
    }

    function displaySch(arrSchList) {
        $("#sch-list").empty();
        $.each(arrSchList, function(index, oSch) {
            var shtml = "<li class='cont02'>";
            if ( "Y"==oSch["POPUP_YN"] )
                shtml+= "<img src='<c:out value='${pageContext.request.contextPath}'/>/image/blat_a3.gif' class='b1'>";
            else
                shtml+= "<img src='<c:out value='${pageContext.request.contextPath}'/>/image/blat_a4.gif'>";
                shtml+= "<a href='#' onclick='javascript:popSchDet(\"" + oSch["SCH_ID"] + "\")'>";
                shtml+= "" + oSch["SCH_DT"];
                shtml+= "<span class='view'> / </span>";
                shtml+= "" + oSch["SCH_TITL_NM"];
                shtml+= "</a>";
                shtml+= "</li>";
            $("#sch-list").append(shtml);
        }); //(예) <li class="cont02"><img src="/web/image/blat_a4.gif"><a href="#">09.11 ~ 09.22 <span class="view"> / </span> 14년 1월 정책설명회-1국/2국/3국</a></li>
    }

    function displayMyPic(oPicFile) {
        if ( $.PSNMUtils.isEmpty(oPicFile) ) {
            return;
        }
        var imgFileUrl = $.PSNMUtils.getDownloadUrl2("PIC", oPicFile.ATCH_FILE_ID, "", oPicFile.FILE_PATH); //$.PSNMUtils.getDownloadUrl(oPicFile);
        $("#myImg2").attr("src", imgFileUrl);
        $("#myImg2").css("display", "");

        //$("<img/>").attr("src", imgFileUrl).load(function() {
        //}
    }

    function displayBirth(arrBirthList) {
        $("#who-was-born").empty(); //김길수(강남대리점) 김길수(강북대리점)<br>
        var i = 0;
        var bHtml = "";
        $.each(arrBirthList, function(index, oBirth) {
            bHtml += "<li class='b1' style='display:";
            if (i>1) {
                bHtml += "none";
            }
            bHtml += ";'>";
            bHtml += oBirth["BIRTH_DAY"] + "(" + oBirth["WEEK_DY"] + ") "; //WEEK_DY=월
            bHtml += oBirth["SALE_DEPT_ORG_NM"] + " ";
            bHtml += oBirth["USER_NM_M"] + " " + oBirth["RPSTY_NM"]; //성명 + 직책명
            bHtml += "</li>";
            i++;
        });
        $("#who-was-born").html(bHtml);
        rollBirthList();
    }
    function rollBirthList() {
        var intervalTime = 1000 * 10; //10초
        var timer = $.timer(function() {
            var size = $("#who-was-born li").length;
            if ( size<=2 ) return;

            var lastIdx = 0;
            $("#who-was-born li").each(function(index) {
                if ( "none"!=$(this).css("display") ) {
                    lastIdx = index;
                }
            });
            if ( lastIdx>=(size-1) ) {
                lastIdx = -1;
            }

            $("#who-was-born li").filter(":visible").hide();

            $("#who-was-born li:eq(" + (1+lastIdx) + ")").show();
            if ( (2+lastIdx) <= (size-1) ) {
                $("#who-was-born li:eq(" + (2+lastIdx) + ")").show();
            }
        });
        timer.set({ time : intervalTime, autostart : true });
    }

    function displayCounts(resultFields, arrMenuList) {
        if ( $.PSNMUtils.isEmpty(resultFields) ) {
            return;
        }
        $("#USER_SCRB_REQ_CNT").text( resultFields["USER_SCRB_REQ_CNT"] ); //회원가입요청건수
        $("#AGENT_CNTRT_CNT").text( resultFields["AGENT_CNTRT_CNT"] ); //에이전트계약요청건수
        $("#RCV_PAPER_CNT").text( resultFields["RCV_PAPER_CNT"] ); //받은쪽지개수
        $("#DFAX_CNT").text( resultFields["DFAX_CNT"] ); //DFAX개수

        var oparam = $.PSNMUtils.getDefaultFromToYmd();

        if ( isFinite(resultFields["USER_SCRB_REQ_CNT"]) ) {
            var param1 = new Object();
                param1["PREV_PAGE"] = "MAIN";
                param1["SCRB_ST_CD"] = "01";
                param1["FROM_DT"] = oparam.FROM_DT;
                param1["TO_DT"] = oparam.TO_DT;
            $("#USER_SCRB_REQ_CNT").click(function() {
                $.PSNM.openMenuLink({menuid:"1301"}, param1); //회원가입요청관리
            });
        }
        else {
            $("#USER_SCRB_REQ_CNT").css("cursor", "default");
        }
        if ( isFinite(resultFields["AGENT_CNTRT_CNT"]) ) {
            var param2 = new Object();
                param2["PREV_PAGE"] = "MAIN";
                param2["CNTRT_ST_CD"] = resultFields["CNTRT_ST_CD"]; //"1";
                param2["FROM_DT"] = oparam.FROM_DT;
                param2["TO_DT"] = oparam.TO_DT;

            $("#AGENT_CNTRT_CNT").click(function() {
                var menuId2 = _get_menuid2(); //에이전트계약관리 메뉴ID조회
                if ( $.PSNMUtils.isNotEmpty(menuId2) ) {
                    $.PSNM.openMenuLink({menuid:menuId2}, param2); //에이전트계약관리
                }
            });
        }
        else {
            $("#AGENT_CNTRT_CNT").css("cursor", "default");
        }

        if ( isFinite(resultFields["DFAX_CNT"]) ) {
            if ( $.PSNMUtils.isMobile() ) {
                $("#DFAX_CNT").click(function() {
                    $a.navigate( _CTX_PATH + "view/biz/dfaxrcv/dFaxRcvPrstMobile.jsp" ); //DFAX 모바일 페이지로 이동
                });
            }
            else {
                var param3 = new Object();
                    param3["PREV_PAGE"] = "MAIN";
                    //param3["FROM_DT"] = oparam.TODAY_DT;
                    //param3["TO_DT"] = oparam.TODAY_DT;
                var _mid = ""; //1707 : 본사업무 - Fax현황/승인요청, 6506 : 영업국업무, 6304 : 영업팀업무, 3206 : MA업무

                for(var i=0; i<arrMenuList.length; i++) {
                    var oMenu = arrMenuList[i];
                    var oMid = oMenu["MENU_ID"];
                    if ( "1707"==oMid || "6506"==oMid || "6304"==oMid || "3206"==oMid ) {
                        _mid = oMid;
                        break;
                    }
                }
                
                if ( ""!=_mid ) {
                    $("#DFAX_CNT").click(function() {
                        $.PSNM.openMenuLink({menuid:_mid}, param3); //에이전트계약관리
                    });
                }
                else {
                    $("#DFAX_CNT").css("cursor", "default");
                }
            }
        }
        else {
            $("#DFAX_CNT").css("cursor", "default");
        }
    }
    
    function _get_menuid2() { //에이전트계약관리 메뉴ID 조회반환
        var menuId2 = "1303"; //에이전트계약관리(본사)
        if ( ! $.PSNM.existMenu(menuId2) ) {
            menuId2 = "2203"; //에이전트계약관리(영업국)
            if ( ! $.PSNM.existMenu(menuId2) ) {
                menuId2 = "6701"; //에이전트계약관리(영업팀)
                if ( ! $.PSNM.existMenu(menuId2) ) {
                    menuId2 = "";
                }
            }
        }
        return menuId2;
    }

    function setSlidingBanner() { //메인광고배너 슬라이드
        var startSlide = 1;
        $('#slides').slides({
            container: 'slide',
            pagination: true,
            generatePagination: true,
            paginationClass: 'page',
            start: 1,
            effect: 'slide',
            slideSpeed: 500,
            play: 9000,
            pause: 0,
            start: startSlide
        });
    }

    </script>

</head>

<body>

<div id="Wrap"> 
    <!-- header start -->
    <div id="header">
        <div class="nhearder">
            <h1><a href="#" onclick="javascript:$.PSNM.openLink('/view/main.jsp', null, true);"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/logo.gif"></a></h1>
            <ul class="toptxt1" style="width: 380px;">
                <li class="ft01">
                    <b>[<a id="topUserName"><%=userInfo.get("USER_NM")%></a>] 
                        <a id="btnPaper" data-menuid="5501" class="menu-link"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a1.gif" alt="받은쪽지개수" /></a>
                        <span id="RCV_PAPER_CNT" title="읽지 않은 받은쪽지 개수"><c:out value='${sessionScope.nc_user["RCV_PAPER_CNT"]}'/></span>통
                    </b><%-- 
                    <a href="#" onclick="javascript:$.PSNM.logout(); return false;"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/btn_a1.gif"></a> --%>
                </li>
                <li class="ft02"><a href="#" id="toplinkMyPage">마이페이지</a></li>
                <li class="ft03"><a href="#" id="toplinkMenuAll">전체메뉴</a>
                <li class="ft04"><a href="#" onclick="javascript:$.PSNM.logout(); return false;"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/btn_a1.gif"></a></li>
            </ul>
        </div>
        <div class="gnb">
            <ul class="g_menu">
              <c:forEach var='tmenu' items='${sessionScope.nc_user["psnm-topmenus"]}' varStatus='status'>
                <li><a data-menuid='<c:out value="${tmenu.MENU_ID}"/>' id='top-menu-<c:out value="${tmenu.MENU_ID}"/>' class='topmenu' style='color:white;'><c:out value="${tmenu.MENU_NM}"/></a></li>
              </c:forEach>
            </ul>
            <p class="dimenu">
                <b><a data-menuid="9999" id="top-menu-9999">바로가기 +</a></b>
                <ul id="quick-link-list"  class="dropdown_block" style="display: none;"> <!-- data-type="dropdown" data-base="#top-menu-9999" -->
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
    <div id="sub-menu-div" style="display:; position:relative; z-index: 100002;">
        
    </div>
    <!--// header end -->

    <!-- left start -->
    <div id="lay_out">
        <div id="ub_left">
            <div class="adminbox">
                <div class="adminbox-info">
                    <img id="myImg2" class="adminbox-img" src="<c:out value='${pageContext.request.contextPath}'/>/image/adminbox-sample-img.gif" style="width:93px; height:93px;"
                                                          onError="this.onerror=null;this.src='<c:out value='${pageContext.request.contextPath}'/>/image/adminbox-sample-img.gif';">
                    <ul>
                        <li class="textc2"><%=userInfo.get("USER_NM")%>(<%=userInfo.getLoginId()%>)</li> 
                        <li class="textc3"><%=userInfo.get("SALE_DEPT_ORG_NM")%> <%=userInfo.get("SALE_TEAM_ORG_NM")%></li>
                        <li class="textc3"><%=userInfo.get("DUTY_NM")%></li>
                        <li class="textc3"><a href="#" data-menuid="5503" class="menu-link"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/btn_b1_mail.gif" title="쪽지보내기"></a></li>
                    </ul>
                </div>
                <div class="adminbox-btn">
                    <a href="#" id="linkChangeMyInfo"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/adminbox-btn-textinfo.gif"></a>
                    <a href="#" id="linkChangePasswd"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/adminbox-btn-textpwd.gif"></a>
                </div>
                <ul class="adminbox-num">
                    <li><a id="USER_SCRB_REQ_CNT" href="#">-</a><span class="txt">회원승인</span></li>
                    <li><a id="AGENT_CNTRT_CNT" href="#">-</a><span class="txt">AG계약</span></li>
                    <li><a id="DFAX_CNT">-</a><span class="txt" id="DFAX_CNT_TITLE">업무승인</span></li>
                </ul>
            </div>

            <div class="plan"> <a href="#" class="menu-link" data-menuid="3204"> <span class="textc1"><b>영업 <span class="textc2">정책</span></b></span> <span class="textc3">판매 상품 정책 확인<br>
              </span> </a> </div>
            <div class="product"> <a href="#" class="menu-link" data-menuid="5403"> <span class="textc1"><b>이달의 <span class="textc2">상품</span></b></span> <span class="textc3">새로 출시된 상품 및 <br>
              요금제 관련 정보 확인</span> </a> </div>
            <div class="receive"> <a href="#" class="menu-link" data-menuid="3203"> <span class="textc1"><b>미비서류 <span class="textc2">접수</span></b></span> <span class="textc3">CIA 대상 누락 서류 <br>
              추가 등록 요청</span> </a> </div>
            <div class="news"> <a href="#" class="menu-link" data-menuid="5401"> <span class="textc1"><b>업계 <span class="textc2">소식</span></b></span> <span class="textc3">ICT 업계 일일동향 정보<br></span> </a> </div>
            <div class="what"> <a href="#" class="menu-link" data-menuid="4301"> <span class="textc1"><b>무엇이든 물어보세요</b></span> <span class="w1">영업정책, 상품, 운영규정, 건의사항등<br>
              궁금한 사항이 있으면 글을 남겨주세요.</span> </a> </div>
            <div id="birth-area" class="birth">
                <a id="birth-area-a" style="cursor:default;">
                    <span class="textc1">
                        <b>생일을 축하합니다</b>
                        <span class="date"><em id="birth-today" style="cursor:pointer;">오늘</em><em id="birth-tomorrow" style="cursor:pointer;">내일</em></span>
                    </span> 
                    <ul id="who-was-born">
                        <li class="b1"></li>
                    </ul>
                </a> 
            </div>
        </div>
        <!--// left end -->

        <div id="ub_right">
            <div id="ub_txt1">
                <!-- 메인광고배너 영역 -->
                <div id="slides" class="slides">
                    <ul class="slide" id="mainad-list">
                        <!--
                        <li><a href="#"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/introduce_bg02.png" width="703" height="217" alt="메인광고"></a></li>
                        -->
                    </ul>
                </div>
                <!-- //메인광고배너 영역 -->
            </div>
          <div id="ubWrap">
            <div id="ub_txt3"><span class="txt3_img"><b>공지사항</b></span><span class="notice-more menu-link" data-menuid="4202" style="cursor:pointer;"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/btn_a2.gif"></span>
              <ul id="annce-list" class="midcont-wrap">
                <!--
                <li class="cont03"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a4.gif"><a href="#">정지기간 준수사항</a> <span class="view">09-11</span></li>
                -->
              </ul>
            </div>
            <div id="ub_txt2"> <span class="txt3_img"><b>주요일정</b></span><span class="notice-more menu-link" data-menuid="4502" style="cursor:pointer;"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/btn_a2.gif"></span>
              <ul id="sch-list" class="midcont-wrap">
                <!--
                <li class="cont02"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a4.gif"><a href="#">09.11 ~ 09.22 <span class="view"> / </span> 14년 1월 정책설명회-1국/2국/3국</a></li>
                -->
              </ul>
            </div>
          </div>
          <div id="ub_txt4"><span class="txt4_img"><b>업무보드</b></span>
            <span class="prev" id="btnScrollLeft"><a href="#"><em>이전</em></a></span>
            <ul class="txt4_img1" id="main-banner"> 
              <li id="main-banner-01" style="display:none;"><a href="#" data-menuid="" class="txt4_roll01" onclick="javascript:pnsm_open_sale_stat();">영업목표/현황</a></li>
              <li id="main-banner-02" style="display:none;"><a href="#" data-menuid="" class="txt4_roll02" onclick="javascript:pnsm_pop_best_ma();">판매우수 MA</a></li>
              <li id="main-banner-03" style="display:none;"><a href="#" data-menuid="" class="txt4_roll03" onclick="javascript:pnsm_pop_best_team();">판매우수 팀장</a></li>
              <li id="main-banner-04" style="display:none;"><a href="#" data-menuid="" class="txt4_roll04" onclick="javascript:pnsm_pop_mrtg_expir();">담보기간만료 현황</a></li>
              <li id="main-banner-05" style="display:none;" class=""><a href="#" data-menuid="" class="txt4_roll05" onclick="javascript:pnsm_pop_headq_rnk();">영업국별 판매순위</a></li>
            </ul>
            <span class="next" id="btnScrollRight"><a href="#"><em>다음</em></a></span>
          </div>
          <div id="ub_txt5">
            <ul class="txt5_sq">
              <li class="txt5_01"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a2.gif" title="이달의 명언" /> </li>
              <li class="txt5_02"><span id="PHRS">독서할 때 당신은 항상 가장 좋은 친구와 함께 있다.</span> <span id="ATHR">-시드니 스미스-</span></li>
            </ul>
          </div>
        </div>
    </div>
</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

<div id="main-test-area" style="display:none;">
</div>

</body>
</html>
