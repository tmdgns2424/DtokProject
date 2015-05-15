<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>권한그룹 찾기 - PS&Marketing</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />

    <script type="text/javascript">
    var _initParam = null;
    var _TX_SEARCH = 'com.CODE@PBASE_pSearchAuthGrp';

    $a.page({
        init : function(id, param) { //
            _initParam = param;
            _debug('<findAuthGrpPop> $.alopex.page.init (param) : ' + JSON.stringify(param));

            $a.page.setEventListener();
            $a.page.setGrid();
            $a.page.setValidators();

            //$('#sform').setData(param);
            pSearchAuthGrp();
        },
        setEventListener : function() {
            $("#btnSearch").click( pSearchAuthGrp ); //조회

            $("#btnConfirm").click( closeConfirm );
            $("#btnCancel").click( closeWithout );
        },
        setGrid : function() {
            $("#gridauthgrp").alopexGrid({
                pager:false,
                height: 300,
                columnMapping : [
                    { columnIndex : 0, selectorColumn : true,    width : "30px" },
                    { columnIndex : 1, key : "AUTH_GRP_NM",   title : "권한그룹명",   align : "left", width : "150px" },
                    { columnIndex : 2, key : "AUTH_GRP_DESC", title : "권한그룹설명", align : "left", width : "300px" },
                    { columnIndex : 3, key : "AUTH_GRP_ID",   title : "권한그룹ID",   align : "center", width : "0px", hidden:true }
                ]
                ,
                on : {
                    'cell' : {
                        "click" : function(data, eh, e) {
                            //
                        }
                    }
                }
            });
        },
        setCodeData : function() {
        }
        ,
        setValidators : function() {
        }
    });//end-of-$.alopex.page //-------------------------------------------------------------------------------------------------------//

    //조회
    function pSearchAuthGrp(param) {
        if ( !$.PSNM.isValid("sform") ) {
            return false;
        }

        $("#gridauthgrp").alopexGrid("dataEmpty");

        $.alopex.request(_TX_SEARCH, {
            data: function() {
                _debug("<pSearchAuthGrp> <request.data> 파라미터 (this.data.dataSet.fields) : " + JSON.stringify(this.data.dataSet.fields));
            },
            success: ['#gridauthgrp', function(res) {
            	
            	var gridList = res.dataSet.recordSets.gridauthgrp.nc_list;
            	
            	$.each(gridList, function(idx, val){
            		if("01" == val.AUTH_GRP_ID || "02" == val.AUTH_GRP_ID 
            			|| "03" == val.AUTH_GRP_ID || "12" == val.AUTH_GRP_ID || "99" == val.AUTH_GRP_ID){
            			$("#gridauthgrp").alopexGrid("dataEdit", {_state:{selected:true}}, {_index:{data:idx}});
            		}
            	});
            	
                //_debug("<pSearchAuthGrp> <request.success> 결과데이터 : " + JSON.stringify(res));
            }]
        });
    } //end of pSearchAuthGrp()

    //현재창을 닫고 객체를 반환
    function closeWith(oData) {
        $a.close(oData);
    }

    function closeWithout() {
        $a.close([]);
    }

    function closeConfirm() {
        var data = $("#gridauthgrp").alopexGrid("dataGet", { _state : {selected:true} } ); //선택된 데이터

        if (data.length<1) {
            alert("권한그룹을 선택하십시오!");
            return;
        }
        closeWith( AlopexGrid.trimData(data) );
    }
    </script>
</head>

<body style="height: 100%;">

<div id="Wrap">

    <!-- title area -->
    <div class="pop_header" style="min-width: 600px;">
        <!-- <span class="title">권한그룹 찾기</span> -->

        <!-- view_table area -->
        <div class="textAR1" style="min-height:200px;">
            <div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>권한그룹 목록</b>
                <p class="ab_pos2">
                    <!-- <button id="btnInit" data-type="button" data-theme="af-psnm0">초기화</button> -->
                </p>
            </div>

            <!-- main grid -->
            <div id="gridauthgrp" data-bind="grid:gridauthgrp" data-ui="ds"></div>
        </div>

        <!-- button area -->
        <div class="textAR" style="min-height:30px;">
            <p class="floatL2">
                <input id="btnConfirm" type="button" value="" data-type="button" data-theme="af-btn8">
                <input id="btnCancel"  type="button" value="" data-type="button" data-theme="af-btn10">
            </p>
        </div>
    </div>

</div>

</body>
</html>