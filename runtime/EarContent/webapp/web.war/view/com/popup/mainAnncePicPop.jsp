<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="nexcore.framework.core.Constants"%>
<%@ page import="nexcore.framework.core.code.ICode"%>
<%@ page import="nexcore.framework.core.data.user.IUserInfo"%>
<%@ page import="nexcore.framework.core.util.BaseUtils"%>
<%@ page import="nexcore.framework.online.channel.util.WebUtils"%>
<%
    //IUserInfo userInfo = WebUtils.getSessionUserInfo(request);
%>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>공지합니다 - PS&Marketing</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />

    <script type="text/javascript">

    var _TX_SEARCH     = "com.MAINLOGIN@PMAIN001_showAnncePic";

    var _initParam = null;

    $.alopex.page({
        init : function(id, param) {
            _initParam = param;
            $.PSNMPop.popinit(id, param); //팝업화면 초기화 공통처리
            $a.page.setEventListener();
            $a.page.setGrid();
            $a.page.setValidators();

            showAnncePic(param); //이미지 노출
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

    //공지이미지
    function showAnncePic(param) {
        var oPicFileInfo = param;
        _debug("공지이미지", JSON.stringify(oPicFileInfo));

        var imgFileUrl = $.PSNMUtils.getDownloadUrl(oPicFileInfo);
        _debug("displayMyPic", "imgFileUrl = " + imgFileUrl, "oPicFileInfo = ", JSON.stringify(oPicFileInfo));

        $("#imgAnncePic").attr("src", imgFileUrl).load(function(){
            //alert(this.width+' '+this.height);      
        });
        $("#imgAnncePic").css("display", "");
    }

    function closeWith() {
        var isChecked = $("#chkToday").prop("checked");

        if ( isChecked ) {

        }
        $a.close(isChecked);
    }

    //현재창을 닫고 객체를 반환
    function closeConfirm() {
        var oReturn = {};
        $a.close(oReturn);
    }
    </script>
</head>

<body>

<div id="Wrap"> 
    <div class="pop_header" style="overflow-y: auto;">

        <!-- 공지 -->
        <div class="floatL4"> 
            <img id="imgAnncePic" src="<c:out value='${pageContext.request.contextPath}'/>/image/adminbox-sample-img.gif">
        </div>

        <div class="pop-bchk">
            <p id="p-today-check" style="display:;">
                <input id="chkToday" name="chkToday" type="checkbox" data-type="checkbox"> 오늘 하루 창 열지 않기 
                <input id="btnClose" name="btnClose" type="button"   data-type="button" data-theme="af-n-btn23">
            </p>
        </div>

    </div>
</div>

</body>
</html>