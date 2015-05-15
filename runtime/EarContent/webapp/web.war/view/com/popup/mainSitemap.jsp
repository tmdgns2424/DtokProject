<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="nexcore.framework.core.Constants"%>
<%@ page import="nexcore.framework.core.code.ICode"%>
<%@ page import="nexcore.framework.core.data.user.IUserInfo"%>
<%@ page import="nexcore.framework.core.util.BaseUtils"%>
<%@ page import="nexcore.framework.online.channel.util.WebUtils"%>
<%
    IUserInfo userInfo = WebUtils.getSessionUserInfo(request);

%>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>사이트맵 - PS&Marketing</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />

    <script type="text/javascript">

    var _initParam = null;

    $.alopex.page({
        init : function(id, param) {
            _initParam = param;

            $a.page.setEventListener();
            $a.page.setGrid();
            $a.page.setValidators();

            renderSitemap(param); //조회
        },
        setEventListener : function() {
            $("#btnClose").click( closeWith );
        },
        setGrid : function() {
            ;
        },
        setValidators : function() {
            ;
        },
        setCodeData : function() {
            ;
        }
    });//end-of-$.alopex.page //-------------------------------------------------------------------------------------------------------//

    //사이트맵
    function renderSitemap(param) {
        var sTopMenus = sessionStorage.getItem("top-menu");
        var aTopMenus = JSON.parse(sTopMenus);
        var sHtml = "";

        for(var i=0, iTopMenuLen = aTopMenus.length; i<iTopMenuLen; i++) {
            var oTopMenu = aTopMenus[i];
            var sSubMenu = sessionStorage.getItem("top-menu-" + oTopMenu["MENU_ID"]);
            var aSubMenu = JSON.parse(sSubMenu);

            sHtml += "<li>"; //<li><h1>나의 D-TOK</h1>
            sHtml += "<h1>" + oTopMenu["MENU_NM"] + "</h1>\n";
            sHtml += "  <ul>\n";

            var oPrevMenu = null;

            for(var j=0, iSubMenuLen = aSubMenu.length; j<iSubMenuLen; j++) {
                var oSubMenu = aSubMenu[j];
                var menuType = oSubMenu["MENU_TYP_CD"]; //2=중메뉴, 3=화면
                
                if ("2"==menuType) { //중메뉴
                    if ( null!=oPrevMenu ) {
                        sHtml += "      </ul>\n";
                    }

                    sHtml += "    <li><h2>" + oSubMenu["MENU_NM"] + "</h2>\n";
                    sHtml += "      <ul>\n";
                }
                else { //화면
                    sHtml += "        <li><a href='#' class='menu-link' data=menuid='" + oSubMenu["MENU_ID"] + "'>ㆍ" + oSubMenu["MENU_NM"] + "</a></li>\n";
                }
                oPrevMenu = oSubMenu;
            }
            if ( null!=oPrevMenu ) {
                sHtml += "      </ul>\n";
            }

            sHtml += "  </ul>\n";
            sHtml += "</li>";
        }

        $("ul.site-warp").empty();
        $("ul.site-warp").append(sHtml);
    }

    function closeWith() {
        if ( isChecked ) {
            
        }
        $a.close(isChecked);
    }

    </script>
</head>

<body>

<div id="Wrap"> 
    <div class="pop_header" style="width:960px; overflow-y: auto;">

    <div class="textAR">
        <ul class="site-warp">
            <li><h1>나의 D-TOK</h1>
                <ul>
                    <li>
                        <h2>회원정보</h2>
                        <ul>
                            <li><a href="#">ㆍMY정보</a></li>
                            <li><a href="#">ㆍ이용약관</a></li>
                            <li><a href="#">ㆍ개인정보취급방침</a></li>
                            <li><a href="#">ㆍ개인정보수집이용안내</a></li>
                            <li><a href="#">ㆍ개인정보위탁</a></li>
                        </ul>
                    </li>
                    <li>
                        <h2>소통의 장</h2>
                        <ul>
                            <li><a href="#">ㆍ무엇이든 물어보세요</a></li>
                            <li><a href="#">ㆍFAQ관리</a></li>
                            <li><a href="#">ㆍFAQ</a></li>
                        </ul>
                    </li>
                    <li>
                        <h2>업계소식</h2>
                        <ul>
                            <li><a href="#">ㆍ업계소식</a></li>
                        </ul>
                    </li>
                </ul>
            </li>
            <li><h1>Member</h1>
                <ul>
                    <li>
                        <h2>Membership</h2>
                        <ul>
                            <li><a href="#">ㆍ로그인</a></li>
                            <li><a href="#">ㆍ회원가입</a></li>
                            <li><a href="#">ㆍ아이디 찾기</a></li>
                            <li><a href="#">ㆍ비밀번호 찾기</a></li>
                        </ul>
                    </li>
                    <li>
                        <h2>MA지원상담</h2>
                        <ul>
                            <li><a href="#">ㆍ지원상담요청</a></li>
                            <li><a href="#">ㆍ진행현황</a></li>
                        </ul>
                    </li>
                    <li>
                        <h2>MA지원하기</h2>
                        <ul>
                            <li><a href="#">ㆍMA지원서 작성 방법</a></li>
                            <li><a href="#">ㆍMA지원서 작성</a></li>
                        </ul>
                    </li>
                    <li>
                        <h2>MA지원상담</h2>
                        <ul>
                            <li><a href="#">ㆍ지원상담요청</a></li>
                            <li><a href="#">ㆍ진행현황</a></li>
                        </ul>
                    </li>
                    <li>
                        <h2>MA지원하기</h2>
                        <ul>
                            <li><a href="#">ㆍMA지원서 작성 방법</a></li>
                            <li><a href="#">ㆍMA지원서 작성</a></li>
                        </ul>
                    </li>
                    <li>
                        <h2>MA지원상담</h2>
                        <ul>
                            <li><a href="#">ㆍ지원상담요청</a></li>
                            <li><a href="#">ㆍ진행현황</a></li>
                        </ul>
                    </li>
                    <li>
                        <h2>MA지원하기</h2>
                        <ul>
                            <li><a href="#">ㆍMA지원서 작성 방법</a></li>
                            <li><a href="#">ㆍMA지원서 작성</a></li>
                        </ul>
                    </li>
                </ul>
            </li>
            <li><h1>Member</h1>
                <ul>
                    <li>
                        <h2>Membership</h2>
                        <ul>
                            <li><a href="#">ㆍ로그인</a></li>
                            <li><a href="#">ㆍ회원가입</a></li>
                            <li><a href="#">ㆍ아이디 찾기</a></li>
                            <li><a href="#">ㆍ비밀번호 찾기</a></li>
                        </ul>
                    </li>
                    <li>
                        <h2>MA지원상담</h2>
                        <ul>
                            <li><a href="#">ㆍ지원상담요청</a></li>
                            <li><a href="#">ㆍ진행현황</a></li>
                        </ul>
                    </li>
                    <li>
                        <h2>MA지원하기</h2>
                        <ul>
                            <li><a href="#">ㆍMA지원서 작성 방법</a></li>
                            <li><a href="#">ㆍMA지원서 작성</a></li>
                        </ul>
                    </li>
                </ul>
            </li>
            <li><h1>Member</h1>
                <ul>
                    <li>
                        <h2>Membership</h2>
                        <ul>
                            <li><a href="#">ㆍ로그인</a></li>
                            <li><a href="#">ㆍ회원가입</a></li>
                            <li><a href="#">ㆍ아이디 찾기</a></li>
                            <li><a href="#">ㆍ비밀번호 찾기</a></li>
                        </ul>
                    </li>
                    <li>
                        <h2>MA지원상담</h2>
                        <ul>
                            <li><a href="#">ㆍ지원상담요청</a></li>
                            <li><a href="#">ㆍ진행현황</a></li>
                        </ul>
                    </li>
                    <li>
                        <h2>MA지원하기</h2>
                        <ul>
                            <li><a href="#">ㆍMA지원서 작성 방법</a></li>
                            <li><a href="#">ㆍMA지원서 작성</a></li>
                        </ul>
                    </li>
                </ul>
            </li>
            <li><h1>Member</h1>
                <ul>
                    <li>
                        <h2>Membership</h2>
                        <ul>
                            <li><a href="#">ㆍ로그인</a></li>
                            <li><a href="#">ㆍ회원가입</a></li>
                            <li><a href="#">ㆍ아이디 찾기</a></li>
                            <li><a href="#">ㆍ비밀번호 찾기</a></li>
                        </ul>
                    </li>
                    <li>
                        <h2>MA지원상담</h2>
                        <ul>
                            <li><a href="#">ㆍ지원상담요청</a></li>
                            <li><a href="#">ㆍ진행현황</a></li>
                        </ul>
                    </li>
                    <li>
                        <h2>MA지원하기</h2>
                        <ul>
                            <li><a href="#">ㆍMA지원서 작성 방법</a></li>
                            <li><a href="#">ㆍMA지원서 작성</a></li>
                        </ul>
                    </li>
                </ul>
            </li>
            <li><h1>Member</h1>
                <ul>
                    <li>
                        <h2>Membership</h2>
                        <ul>
                            <li><a href="#">ㆍ로그인</a></li>
                            <li><a href="#">ㆍ회원가입</a></li>
                            <li><a href="#">ㆍ아이디 찾기</a></li>
                            <li><a href="#">ㆍ비밀번호 찾기</a></li>
                        </ul>
                    </li>
                    <li>
                        <h2>MA지원상담</h2>
                        <ul>
                            <li><a href="#">ㆍ지원상담요청</a></li>
                            <li><a href="#">ㆍ진행현황</a></li>
                        </ul>
                    </li>
                    <li>
                        <h2>MA지원하기</h2>
                        <ul>
                            <li><a href="#">ㆍMA지원서 작성 방법</a></li>
                            <li><a href="#">ㆍMA지원서 작성</a></li>
                        </ul>
                    </li>
                </ul>
            </li>
        </ul>
    </div>


    </div>
</div>

</body>
</html>