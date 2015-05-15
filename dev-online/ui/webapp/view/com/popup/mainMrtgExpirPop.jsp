<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>담보 기간만료 예정 현황 - PS&Marketing</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />

    <script type="text/javascript">
    var _initParam = null;

    $a.page({
        init : function(id, param) {
            _initParam = param;

            $a.page.setEventListener();
            $a.page.setGrid();

            pSearchBestMrtgExpir(); //조회
        }
        ,
        setEventListener : function() {
            $("#btnClose").click( closeWithout );
        }
        ,
        setGrid : function() {
            $("#gridmrtgexpir").alopexGrid({
                rowSingleSelect : false,
                pager : false,
                height : 500,
                columnMapping : [
                    { columnIndex : 0, key : "RNK",              title : "No.",            align : "center",  width : "80px" },
                    { columnIndex : 1, key : "SALE_DEPT_ORG_NM", title : "영업국명",       align : "center",  width : "120px" },
                    { columnIndex : 2, key : "SALE_TEAM_ORG_NM", title : "영업팀명",       align : "center",  width : "120px" },
                    { columnIndex : 3, key : "RPSTY_NM",         title : "직책명",         align : "center",  width : "80px" },
                    { columnIndex : 4, key : "AGNT_NM",          title : "에이전트명",     align : "center",  width : "120px" },
                    { columnIndex : 5, key : "MRTG_AMT",         title : "담보설정금액",   align : "center",  width : "120px" },
                    { columnIndex : 6, key : "EFF_DT",           title : "만료예정일",     align : "center",  width : "100px",
                                       render : function (value, data, mapping) {
                                                    return $.PSNMUtils.getFormatedDate(value, "yyyy-mm-dd");
                                                }
                    },
                    { columnIndex : 7, key : "PRD",              title : "잔여일수",       align : "center",  width : "80px" }
                ]
            });
        }
    });

    //조회
    function pSearchBestMrtgExpir(param) {
        $.alopex.request('biz.SALEPRST@PSALEPRST002_pSearchMrtgExpir', {
            data: function() {
                _debug("<담보기간만료예정현황> <request.data> 파라미터 (this.data.dataSet.fields) : " + JSON.stringify(this.data.dataSet.fields));
            },
            success: ['#gridmrtgexpir', function(res) {
                //_debug("<담보기간만료예정현황> <request.success> 결과데이터 : " + JSON.stringify(res));
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
        <span class="title">담보 기간만료 예정 현황</span>
        <a id="iconCancel" href="#" class="pop_close"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a9.gif" alt="팝업닫기" ></a> 
        -->
        <div class="textAR">

            <div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>담보 기간만료 예정 현황</b>
                <p class="ab_pos1">
                    &nbsp;
                </p>
            </div>

            <div id="gridmrtgexpir" data-bind="grid:gridmrtgexpir" data-ui="ds"></div>

            <p class="floatL2">
                <input id="btnClose" type="button" value="" data-type="button" data-theme="af-n-btn23">
            </p>
        </div>

    </div>

</div>

</body>
</html>