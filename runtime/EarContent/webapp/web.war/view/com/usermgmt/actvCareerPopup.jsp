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
			
            if( $.PSNMUtils.isNotEmpty(param.IS_EXCEL) && param.IS_EXCEL == "Y" ){
            	$("#btnExcelPage").show();
            }else{
            	$("#btnExcelPage").hide();
            }
            searchList(); //조회
        },
        setEventListener : function() {
            $("#btnConfirm").click( closeWithout );
        	$("#btnExcelPage").click(function(){
                var oExcelMetaInfo = {
                        filename  : "활동경력.xls",
                        sheetname : "활동경력",
                        gridname  : "gridActvCareer" //그리드ID 
                    };
                $.PSNMUtils.downloadExcelPage("gridActvCareer", oExcelMetaInfo);
            });
        }, //end-of-setEventListener
        setGrid : function() {
            //그리드 초기화
            $("#gridActvCareer").alopexGrid({
                pager: false,
                columnMapping : [
                    { columnIndex : 0, key : "CONS_MTH", title : "활동기간",     align : "left",   width : "120px" },
                    { columnIndex : 1, key : "HDQT_PART_ORG_NM", title : "본사파트",   align : "center",   width : "70px" },
                    { columnIndex : 2, key : "SALE_DEPT_ORG_NM", title : "영업국",     align : "center",   width : "70px" },
                    { columnIndex : 3, key : "SALE_TEAM_ORG_NM", title : "영업팀",     align : "center",   width : "70px" },
                    { columnIndex : 4, key : "RPSTY_NM",         title : "직책명",     align : "center", width : "50px" }
                ]
            });
        }, //end-of-setGrid
        setCodeData : function() {
            //
        }
    });//end-of-$.alopex.page //-------------------------------------------------------------------------------------------------------//

    //조회 처리 : param은 페이지 이동시에만 값이 전달됨
    function searchList(param) {
        $.alopex.request('com.USERMGMT@PUSERMGMT001_pSearchActvCareer', {
            data: function() {
                var p = $.extend({}, this.data.dataSet.fields, _initParam);
                this.data.dataSet.fields = $.PSNMUtils.removeParamArrays(p);
            },
            success: ['#gridActvCareer', function(res) {
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

            <div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>활동경력</b>
                <p class="ab_pos2">
                	2012년 7월 이후 이력만 확인 가능합니다.&nbsp;&nbsp;
                	<button id="btnExcelPage" type="button" data-type="button" data-theme="af-btn3" data-altname="엑셀다운" data-authtype="R"></button> 
                </p>
            </div>
            <!-- main grid -->
            <div id="gridActvCareer" data-bind="grid:gridActvCareer"></div>

            <p class="floatL2">
                <input id="btnConfirm" type="button" value="" data-type="button" data-theme="af-btn8">
            </p>
        </div>

    </div>

</div>
<div id="footer-hidden-area" style="display:none;">
    <iframe id="footer-hidden-iframe" src="" width="90%;" height="50"></iframe>
</div>
</body>
</html>