<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="nexcore.framework.core.Constants"%>
<%@ page import="nexcore.framework.core.code.ICode"%>
<%@ page import="nexcore.framework.core.data.user.IUserInfo"%>
<%@ page import="nexcore.framework.core.util.BaseUtils"%>
<%@ page import="nexcore.framework.online.channel.util.WebUtils"%>
<%
    IUserInfo userInfo = WebUtils.getSessionUserInfo(request);
    if (userInfo != null) {
        System.out.println("<mainWhoBornPop.jsp> USER_ID : " + userInfo.getLoginId());
    }
%>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>생일자 - PS&Marketing</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />

    <script type="text/javascript">

    var _TX_SEARCH = "com.MAINLOGIN@PMAIN001_pSearchWhoBorn";

    var _initParam = null;

    $.alopex.page({
        init : function(id, param) {
            _initParam = param;
            _debug("생일자팝업", JSON.stringify(param));
            $.PSNMPop.popinit(id, param); //팝업화면 초기화 공통처리
            $a.page.setEventListener();
            $a.page.setGrid();

            pSearchWhoBorn({ "DAY_OFFSET": param.DAY_OFFSET }); //조회
        },
        setEventListener : function() {
            $("#btnClose").click( closeWith );
        },
        setGrid : function() {
            $("#gridborn").alopexGrid({
                pager : false,
                rowSingleSelect: true,
                columnMapping : [
                    { columnIndex : 0, numberingColumn : true,   title : "번호",     align : "center", width : "30px" },
                    { columnIndex : 1, key : "BIRTH_DAY",        title : "생일",     align : "center", width : "80px" },
                    { columnIndex : 2, key : "USER_NM_M",        title : "성명",     align : "center", width : "100px" },
                    { columnIndex : 3, key : "HDQT_TEAM_ORG_NM", title : "본사팀",   align : "center", width : "120px" },
                    { columnIndex : 4, key : "HDQT_PART_ORG_NM", title : "본사파트", align : "center", width : "120px" },
                    { columnIndex : 5, key : "SALE_DEPT_ORG_NM", title : "영업국명", align : "left",   width : "120px" },
                    { columnIndex : 6, key : "SALE_TEAM_ORG_NM", title : "영업팀명", align : "left",   width : "120px" },
                    { columnIndex : 7, key : "PIC_FILE_ID",      title : "PIC_FILE_ID", hidden : true }
                ]
            });
        }
    });

    //생일자 조회
    function pSearchWhoBorn(param) {
        _debug("생일자팝업", JSON.stringify(param));

        $.alopex.request(_TX_SEARCH, {
            showProgress:false,
            data: {
                dataSet: {
                    fields: param
                }
            },
            success: ['#gridborn', function(res) {
                var fields = res.dataSet.fields;
                var list = res.dataSet.recordSets.gridborn.nc_list;
                var cnt = list.length;
                var h = "";

                for(var i=0; i<cnt; i++) {
                    var who = list[i];
                    var imgUrl = _FILE_HANDLER_URL + "?cmd=download&biz=" + who.FILE_GRP_ID;
                        imgUrl+= "&dir=" + who.FILE_PATH;
                        imgUrl+= "&id=" + who.PIC_FILE_ID;
                        imgUrl+= "&name=" + encodeURIComponent(who.FILE_NM);

                    h += "<dl>";
                    h += "    <dt>";
                    h += "    <img src='" + imgUrl + "' alt='" + who.USER_NM_M + " " + who["RPSTY_NM"] + " 사진' onError='this.onerror=null;this.src=\"<c:out value='${pageContext.request.contextPath}'/>/image/adminbox-sample-img.gif\"'>"; //
                    h += "    </dt>";
                    h += "    <dd class='name'>" + who.USER_NM_M + " " + who["RPSTY_NM"] + "</dd>";
                    h += "    <dd>" + who.SALE_DEPT_ORG_NM + " " + who.SALE_TEAM_ORG_NM + "  " + who.HDQT_PART_ORG_NM + "</dd>";
                    h += "    <dd><a href='#' class='send-paper-link' data-userid='" + who.USER_ID + "' data-usernm='" + who.USER_NM_M + "' data-userht='" + who.HDQT_PART_ORG_NM + "' data-usersd='" + who.SALE_DEPT_ORG_NM + "' data-userst='" + who.SALE_TEAM_ORG_NM + "' data-agentid='" + who.SALE_AGNT_ORG_ID + "' data-userrn='" + who.RPSTY_NM +"'>";
                    h += "<img src='<c:out value='${pageContext.request.contextPath}'/>/image/blat_a1.gif' alt='쪽지보내기' /> 쪽지보내기</a></dd>";
                    h += "</dl>";
                }
                $("#who-born-list").html(h);

                $(".send-paper-link").click(function() {
                    var arr = {"USER_ID": $(this).data("userid"), "USER_NM": $(this).data("usernm"), "HDQT_PART_ORG_NM": $(this).data("userht") ,"SALE_DEPT_ORG_NM": $(this).data("usersd"), "SALE_TEAM_ORG_NM": $(this).data("userst"), "AGNT_ID": $(this).data("agentid"), "RPSTY_NM": $(this).data("userrn") };
                    $a.close(arr);
                });

                var dayOffset = param.DAY_OFFSET;
                var subtitle = "";
                var ymd = fields.TODAY;

                if ( '1'==dayOffset ) {
                    ymd= fields.TOMORROW;
                }
                var arrYmd = ymd.split("-");
                subtitle += "" + arrYmd[0] + "년 " + parseInt(arrYmd[1]) + "월 " + parseInt(arrYmd[2]) + "일";
                subtitle += "(음력 " + fields.LUNAR_YEAR + "년 " + fields.LUNAR_MONTH + "월 " + fields.LUNAR_DATE + "일)";

                subtitle += " 생일자 명단";
                $("#grid-title").html( subtitle );
            }]
        });
    }

    //현재창을 닫고 객체를 반환
    function closeWith() {
        var oReturn = {};
        $a.close(oReturn);
    }
    </script>
</head>

<body>

<div id="Wrap" style="width:640px;height:480px;border:1px solid #ddd">

        <!-- 제목 area -->
        <div class="floatL4"> 
            &nbsp;&nbsp;<img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b id="grid-title">&nbsp;</b>
        </div>

        <div id="who-born-list" class="birthdayMember">
            <!--
            <dl>
                <dt><img src="../image/dt_m01.gif" alt="sampleImg"></dt>
                <dd>2015-05-03</dd>
                <dd class="name">함길남 국장</dd>
                <dd>서울1국 국직속</dd>
            </dl>
            -->
        </div>
        
        <div id="gridborn" class="view_list" data-bind="grid:gridborn" data-ui="ds" style="display:none;"></div>
<!--
        <div class="pop-bchk">
            <p id="p-today-check" style="display:;">
                <input id="btnClose" name="btnClose" type="button" data-type="button" data-theme="af-n-btn23">
            </p>
        </div>
-->
</div>

</body>
</html>