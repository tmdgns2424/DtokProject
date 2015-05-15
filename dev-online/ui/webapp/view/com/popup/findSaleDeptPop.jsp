<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>영업국 찾기 - PS&Marketing</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />

    <script type="text/javascript">
    var _initParam = null;
    var _TX_SEARCH = 'com.CODE@PCODE_pSelectSaleDept';

    $a.page({
        init : function(id, param) { //
            _initParam = param;
            _debug('<findSaleDeptPop> $.alopex.page.init (param) : ' + JSON.stringify(param));

            $.PSNM.setOrgSelectBox(); //본사팀, 본사파트, 영업국 select 객체 초기화
            $a.page.setEventListener();
            $a.page.setGrid();
            $a.page.setValidators();

//            $('#sform').setData(param);
            //$("#HDQT_TEAM_ORG_ID").focus();
        },
        setEventListener : function() {
            $("#btnSearch").click( pSearchSaleDept ); //조회

            $("#btnConfirm").click( closeConfirm );
            $("#btnCancel").click( closeWithout );
        },
        setGrid : function() {
            $("#griddept").alopexGrid({
                pager:false,
                height: 300,
                columnMapping : [
                    { columnIndex : 0, selectorColumn : true,    width : "20px" },
                    { columnIndex : 1, key : "HDQT_TEAM_ORG_NM", title : "본사팀",     align : "left",   width : "100px" },
                    { columnIndex : 2, key : "HDQT_PART_ORG_NM", title : "본사파트",   align : "left",   width : "100px" },
                    { columnIndex : 3, key : "SALE_DEPT_ORG_NM", title : "영업국명",   align : "left",   width : "100px" },
                    { columnIndex : 4, key : "HDQT_TEAM_ORG_ID", title : "본사팀ID",   hidden:true },
                    { columnIndex : 5, key : "HDQT_PART_ORG_ID", title : "본사파트ID", hidden:true },
                    { columnIndex : 6, key : "SALE_DEPT_ORG_ID", title : "영업국ID",   hidden:true }
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
            $.PSNMUtils.setCodeData([
                { t:'org1',  'elemid' : 'HDQT_TEAM_ORG_ID', 'header' : '-선택-' } //[본사팀] 목록 조회
            ]);
        }
        ,
        setValidators : function() {
            $('#HDQT_TEAM_ORG_ID').validator({
                rule : { required: true },
                message: {
                    required: $.PSNM.msg('E012', ["본사팀"]) //{0} 항목은 필수값입니다!
                }
            });
        }
    });//end-of-$.alopex.page //-------------------------------------------------------------------------------------------------------//

    //조회
    function pSearchSaleDept(param) {
        if ( !$.PSNM.isValid("sform") ) {
            return false;
        }

        $("#griddept").alopexGrid("dataEmpty");

        $.alopex.request(_TX_SEARCH, {
            data: ['#sform', function() {
                _debug("<pSearchSaleDept> <request.data> 파라미터 (this.data.dataSet.fields) : " + JSON.stringify(this.data.dataSet.fields));
            }],
            success: ['#griddept', function(res) {
                //_debug("<pSearchSaleDept> <request.success> 결과데이터 : " + JSON.stringify(res));
            }]
        });
    } //end of pSearchSaleDept()

    //현재창을 닫고 객체를 반환
    function closeWith(oData) {
        $a.close(oData);
    }

    function closeWithout() {
        $a.close([]);
    }

    function closeConfirm() {
        var arrDepts = $("#griddept").alopexGrid("dataGet", { _state : {selected:true} } ); //선택된 데이터

        if (arrDepts.length<1) {
            alert("영업국을 선택하십시오!");
            return;
        }
        closeWith( AlopexGrid.trimData(arrDepts) );
    }
    </script>
</head>

<body style="height: 100%;">

<div id="Wrap">

    <!-- title area -->
    <div class="pop_header" style="min-width: 600px;">
        <!-- <span class="title">영업국 찾기</span> -->

        <div class="textAR"><!-- style="height:65px;" -->
        	 <!-- <form id="sform"> -->
             <table class="board02" id="sform" style="width:90%;">
        	 <colgroup>
	            <col style="width:15%"/>
	            <col style="width:35%"/>
	            <col style="width:15%"/>
	            <col style="width:*"/>
             </colgroup>
             <tr>
                 <th scope="col" class="psnm-required">본사팀</th>
                 <td class="tleft">
                     <select id="HDQT_TEAM_ORG_ID" name="HDQT_TEAM_ORG_ID" data-type="select" data-bind="options:options_HDQT_TEAM_ORG_ID, selectedOptions:HDQT_TEAM_ORG_ID" data-wrap="false" style="width:150px;"
						data-validation-rule="{required:true}" data-validation-message="{required:$.PSNM.msg('E012', ['본사팀'])}">
                     	<option value="">-선택-</option>
                     </select>
                 </td>
                 <th>본사파트</th>
                 <td class="tleft">
                     <select id="HDQT_PART_ORG_ID" name="HDQT_PART_ORG_ID" data-type="select" data-bind="options:options_HDQT_PART_ORG_ID, selectedOptions:HDQT_PART_ORG_ID" data-wrap="false" style="width:150px;">
                     </select>
                 </td>
             </tr>
             </table>
           	<!-- </form> -->
            <div class="ab_pos5">
                <input id="btnSearch" type="button" value="" data-type="button" data-theme="af-psnm">
            </div>
        </div>

        <!-- view_table area -->
        <div class="textAR1" style="min-height:200px;">
            <div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>영업국 목록</b>
                <p class="ab_pos2">
                    <!-- <button id="btnInit" data-type="button" data-theme="af-psnm0">초기화</button> -->
                </p>
            </div>

            <!-- main grid -->
            <div id="griddept" data-bind="grid:griddept" data-ui="ds"></div>
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