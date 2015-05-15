<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>영업국별 판매순위 - PS&Marketing</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />

    <script type="text/javascript">
    var _initParam = null;

    $a.page({
        init : function(id, param) {
            _initParam = param;

            $a.page.setEventListener();
            $a.page.setGrid();

            pSearchBestTeam(); //조회
        }
        ,
        setEventListener : function() {
            $("#btnClose").click( closeWithout );
        }
        ,
        setGrid : function() {
            $("#gridbestteam").alopexGrid({
                rowSingleSelect : false,
                pager : false,
                height : 500,
                columnMapping : [
                    { columnIndex : 0, key : "RNK",              title : "순위",           align : "center",  width : "80px" },
                    { columnIndex : 1, key : "SALE_DEPT_ORG_NM", title : "영업국명",       align : "center",  width : "120px" },
                    { columnIndex : 2, key : "AGNT_NM",          title : "국장명",         align : "center",  width : "150px" },
                    { columnIndex : 3, key : "SALE_QTY",         title : "이동전화판매량", align : "right",   width : "150px",	 render:{type:"string", rule:"comma"} }
                ]
            });
        }
    });

    //조회
    function pSearchBestTeam(param) {
        $.alopex.request('biz.SALEPRST@PSALEPRST002_pSearchHeadqSaleRnk', {
            data: function() {
                _debug("<영업국별 판매순위> <request.data> 파라미터 (this.data.dataSet.fields) : " + JSON.stringify(this.data.dataSet.fields));
            },
            success: ['#gridbestteam', function(res) {
                //_debug("<영업국별 판매순위> <request.success> 결과데이터 : " + JSON.stringify(res));
            }]
        });
    }

    //닫기
    function closeWithout() {
        $a.close();
    }

    </script>
</head>

<body>

<div id="contents">

    <div class="pop_header">
        <!-- 
        <span class="title">판매 우수 팀장 현황</span>
        <a id="iconCancel" href="#" class="pop_close"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a9.gif" alt="팝업닫기" ></a> 
        -->

        <div class="textAR">

            <div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>영업국별 판매순위</b>
                <p class="ab_pos1">
                    * 전일 월 누적 매출 기준/ 반품 미반영 
                </p>
            </div>

            <div id="gridbestteam" data-bind="grid:gridbestteam" data-ui="ds"></div>

            <p class="floatL2">
                <input id="btnClose" type="button" value="" data-type="button" data-theme="af-n-btn23">
            </p>
        </div>

    </div>

</div>

</body>
</html>