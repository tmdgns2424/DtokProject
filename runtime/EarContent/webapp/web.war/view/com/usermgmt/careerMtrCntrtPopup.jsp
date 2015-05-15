<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>활동경력 - PS&Marketing</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />


    <script type="text/javascript">
    var _initParam = null;

    $.alopex.page({
        init : function(id, param) { 
            _initParam = param;
            $a.page.setEventListener();
            $a.page.setGrid();

            searchList(); //조회
        },
        setEventListener : function() {
            $("#btnConfirm").click( closeWithout );
        }, //end-of-setEventListener
        setGrid : function() {
            //그리드 초기화
            $("#gridCareerMtrCntrt").alopexGrid({
                pager: false,
                columnMapping : [
                    { columnIndex : 0, key : "CONS_MTH",              title : "월",                align : "center",   width : "80px" },
                    { columnIndex : 1, key : "HDQT_PART_ORG_NM",      title : "본사파트",           align : "center",   width : "80px" },
                    { columnIndex : 2, key : "SALE_DEPT_ORG_NM",      title : "영업국명",           align : "center",   width : "80px" },
                    { columnIndex : 3, key : "SALE_TEAM_ORG_NM",      title : "영업팀명",           align : "center",   width : "80px" },
                    { columnIndex : 4, key : "SALE_AGNT_ORG_ID",      title : "에이전트코드",        align : "center",   width : "80px" },
                    { columnIndex : 5, key : "RPSTY_NM",              title : "직책명",             align : "center",   width : "80px" },
                    { columnIndex : 6, key : "SALE_AGNT_ORG_NM",      title : "에이전트명",         align : "center",   width : "80px" },
                ]
            });
        }, //end-of-setGrid
        setCodeData : function() {
            //
        }
    });//end-of-$.alopex.page //-------------------------------------------------------------------------------------------------------//

    //조회 처리 : param은 페이지 이동시에만 값이 전달됨
    function searchList(param) {
        $.alopex.request('com.USERMGMT@PUSERMGMT001_pSearchCareerMtrCntrt', {
            data: function() {
                var p = $.extend({}, this.data.dataSet.fields, _initParam);
                this.data.dataSet.fields = $.PSNMUtils.removeParamArrays(p);
            },
            success: ['#gridCareerMtrCntrt', function(res) {
            }]
        });
    }

    function closeWithout() {
        $a.close();
    }
    </script>
</head>

<body>

<div id="Wrap">

    <!-- title area -->
    <div class="pop_header">
        <!--view_table area -->
        <div class="textAR">

            <div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>경력사항(계약 후)</b>
                <p class="ab_pos2">
                </p>
            </div>

            <!-- main grid -->
            <div id="gridCareerMtrCntrt" data-bind="grid:gridCareerMtrCntrt"></div>

            <p class="floatL2">
                <input id="btnConfirm" type="button" value="" data-type="button" data-theme="af-btn8">
            </p>
        </div>

    </div>

</div>

</body>
</html>