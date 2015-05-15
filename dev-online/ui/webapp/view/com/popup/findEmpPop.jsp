<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>본사직원 찾기 - PS&Marketing</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />

    <script type="text/javascript">
    var _initParam = null;

    $.alopex.page({
        init : function(id, param) { //{"USER_NM":"현주"} 
            _initParam = param;
            _debug('<findEmpPop> $.alopex.page.init (param) : ' + JSON.stringify(param));

            $a.page.setEventListener();
            $a.page.setGrid();

            pSearchEmp(); //조회
        },
        setEventListener : function() {
            $("#btnConfirm").click( closeConfirm );
            $("#btnCancel").click( closeWithout );
            $("#iconCancel").click( closeWithout );

        }, //end-of-setEventListener
        setGrid : function() {
            //그리드 초기화
            $("#gridemp").alopexGrid({
                pager: false,
                columnMapping : [
                    { columnIndex : 0, key : "RN",            title : "번호",         align : "center", width : "50px" }, //{ columnIndex : 0, selectorColumn : true, width : "20px" },
                    { columnIndex : 1, key : "USER_ID",       title : "직원ID",       align : "center", width : "120px" },
                    { columnIndex : 2, key : "USER_NM",       title : "직원명",       align : "center", width : "120px" },
                    { columnIndex : 3, key : "DUTY_NM",       title : "직무",         align : "center", width : "150px" },
                    { columnIndex : 4, key : "DUTY_USER_TYP", title : "직무유형코드", align : "center", width : "100px" },
                    { columnIndex : 5, key : "DUTY_CD",       title : "DUTY_CD",      align : "center", hidden:true }
                ]
                ,
                on : {
                    'cell' : {
                        "dblclick" : function(data, eh, e) {
                            _debug("<gridemp.on.cell.dblclick> 데이터 : " + $.PSNMUtils.toString(data));
                            closeWith(data);
                        }
                    }
                }
            });
        }, //end-of-setGrid
        setCodeData : function() {
            //
        }
    });//end-of-$.alopex.page //-------------------------------------------------------------------------------------------------------//

    //조회
    function pSearchEmp(param) {
        $.alopex.request('com.CODE@PBASE_pSearchEmpPop', {
            data: function() {
                var p = $.extend({}, this.data.dataSet.fields, _initParam);
                this.data.dataSet.fields = $.PSNMUtils.removeParamArrays(p); //세션에 options_ 배열이 있는 경우 제거함(@since 2014-12-03)
                _debug("<pSearchEmp> <request.data> 파라미터 (this.data.dataSet.fields) : " + JSON.stringify(this.data.dataSet.fields));
            },
            success: ['#gridemp', function(res) {
                //_debug("<pSearchEmp> <request.success> 결과데이터 : " + JSON.stringify(res));
            }]
        });
    } //end of pSearchEmp()

    //현재창을 닫고 객체를 반환
    function closeWith(oRecord) {
        $a.close( oRecord );
    }

    function closeWithout() {
        $a.close();
    }

    function closeConfirm() {
        var arrEmps = $("#gridemp").alopexGrid("dataGet", {_state:{selected:true}}); //선택된 데이터
        if (arrEmps.length != 1) {
            alert("본사직원을 선택하십시오!");
            return;
        }
        closeWith(arrEmps[0]);
    }
    </script>
</head>

<body>

<div id="Wrap">

    <!-- title area -->
    <div class="pop_header">
        <span class="title">본사직원 찾기</span>
        <a id="iconCancel" href="#" class="pop_close"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a9.gif" alt="팝업닫기" ></a> 
      
        <!--view_table area -->
        <div class="textAR">

            <div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>본사직원 목록</b>
                <p class="ab_pos2">
                    <!-- <button id="btnInit"      data-type="button" data-theme="af-psnm0">초기화</button> -->
                </p>
            </div>

            <!-- main grid -->
            <div id="gridemp" data-bind="grid:gridemp" data-ui="ds"></div>

            <p class="floatL2">
                <input id="btnConfirm" type="button" value="" data-type="button" data-theme="af-btn8">
                <input id="btnCancel"  type="button" value="" data-type="button" data-theme="af-btn10">
            </p>
        </div>

    </div>

</div>

</body>
</html>