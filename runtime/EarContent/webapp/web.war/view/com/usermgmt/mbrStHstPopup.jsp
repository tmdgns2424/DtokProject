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
            $("#gridMbrStHst").alopexGrid({
                pager: false,
                columnMapping : [
                    { columnIndex : 0, key : "SCRB_ST_CHG_DTM", title : "일자",                align : "center",   width : "80px" },
                    { columnIndex : 1, key : "SCRB_ST_NM",      title : "항목",                align : "center",   width : "80px" },
                    { columnIndex : 2, key : "USER_NM",         title : "처리자",              align : "center",   width : "80px" },
                    { columnIndex : 3, key : "SCRB_ST_CHG_RSN", title : "회원상태 변경사유",     align : "center",   width : "80px" },
                ]
            });
        }, //end-of-setGrid
        setCodeData : function() {
            //
        }
    });//end-of-$.alopex.page //-------------------------------------------------------------------------------------------------------//

    //조회 처리 : param은 페이지 이동시에만 값이 전달됨
    function searchList(param) {
        $.alopex.request('com.USERMGMT@PUSERMGMT001_pSearchMbrStHst', {
            data: function() {
                var p = $.extend({}, this.data.dataSet.fields, _initParam);
                this.data.dataSet.fields = $.PSNMUtils.removeParamArrays(p);
            },
            success: ['#gridMbrStHst', function(res) {
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

            <div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>회원상태 이력</b>
                <p class="ab_pos2">
                </p>
            </div>

            <!-- main grid -->
            <div id="gridMbrStHst" data-bind="grid:gridMbrStHst"></div>

            <p class="floatL2">
                <input id="btnConfirm" type="button" value="" data-type="button" data-theme="af-btn8">
            </p>
        </div>

    </div>

</div>

</body>
</html>