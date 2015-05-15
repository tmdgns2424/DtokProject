<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
    String _ROOT = "";
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

    <jsp:include page="/view/layouts/default_head.jsp" flush="false" />

    <link rel="stylesheet" type="text/css" href="<c:out value='${pageContext.request.contextPath}'/>/css/psnm-layout-additional.css" /><!-- 임시추가CSS -->

    <script type="text/javascript">
    _LOG_LEVEL = 0; //로그레벨 :: 0=debug, 1=info, 2=error

    var _TX_SEARCH        = "com.AUTH@PAUTHGRP_pSearchAuthGrp";         //
    var _TX_SEARCH2       = "com.AUTH@PAUTHGRP_pSearchAuthGrpAplyDuty"; //
    var _TX_SAVE          = "com.AUTH@PAUTHGRP_pSaveAuthGrpAplyDuty";   //권한그룹적용직무 저장
    var _TX_DELETE        = "com.AUTH@PAUTHGRP_pDeleteAuthGrp";         //선택된 권한그룹을 삭제함(1건)

    $.alopex.page({

        init : function(id, param) { 
            _debug("authGrpList", "init()", JSON.stringify(param));

            $.PSNM.initialize(id, param); //PSNM공통 초기화함수 호출(서브 페이지에서는 필수 호출)

            $a.page.setEventListener();
            $a.page.setGrid();
            $a.page.setGrid2();
            //$a.page.setCodeData();
            //$('#sform').setData(param); //(설명) 상세페이지에서 돌아오는 경우, 이 값들이 세션스토리지에서 반환됨.
            pSearchAuthGrp(); //조회
        },
        setEventListener : function() {
            $("#btnSearch").click( pSearchAuthGrp );
            $("#btnAdd").click( addAuthGrp );
            $("#btnDel").click( delAuthGrp );
            $("#btnSave").click( pSaveAuthGrpAplyDuty );
            $("#btnExcelAll").click( downloadExcel );
        },
        setGrid : function() {
            $("#gridauthgrp").alopexGrid({
                pager:false,
                height:250,
                rowSingleSelect: true,
                rowInlineEdit  : false, //더블클릭을 이용하여 행을 편집모드로 바꿀 수 있도록 해주는 옵션.
                columnMapping : [
                    { columnIndex : 0, key : "FLAG",        title : "F",        align : "center", width : "30px", refreshBy:true, 
                                        value : function(value, data) {
                                            if ( "I"==value || "D"==value ) { return value; } //추가|삭제는 그냥둠
                                            return ( (data._state.edited) ? 'U' : '' ); 
                                        }
                    },
                    { columnIndex : 1, key : "AUTH_GRP_ID",     title : "권한그룹ID",   align : "center", width : "100px" },
                    { columnIndex : 2, key : "AUTH_GRP_NM",     title : "권한그룹명",   align : "left",   width : "160px" },
                    { columnIndex : 3, key : "AUTH_GRP_DESC",   title : "권한그룹설명", align : "left",   width : "300px" },
                    { columnIndex : 4, key : "USE_YN",          title : "사용여부",     align : "center", width : "80px"  },
                    { columnIndex : 5, key : "AUTH_PRTY",   title : "우선순위", align : "center", width : "80px" },
                    { columnIndex : 6, key : "AUTH_TYP_ID", title : "AUTH_TYP_ID", hidden:true },
                    { columnIndex : 7, key : "AUTH_TYP_NM", title : "AUTH_TYP_NM", hidden:true }
                ]
                ,
                on : {
                    'cell' : {
                        "click" : function(data, eh, e) {
                            pSearchAuthGrpAplyDuty(data);
                        }
                        ,
                        "dblclick" : function(data, eh, e) {
                            updateAuthGrp(data);
                        }
                    }
                }
            });
        }, //end-of-setGrid
        setGrid2 : function() {
            var _grid_colmap = {
                pager:false,
                height:300,
                rowClickSelect : false,
                rowInlineEdit : false,
                columnMapping : [ //
                    { columnIndex : 0, key : "FLAG",        title : "F",           align : "center", refreshBy:true, 
                                        value : function(value, data) {
                                            return ( (data._state.edited) ? 'U' : '' ); 
                                        }, 
                                        width : "20px" //hidden:true
                    },
                    { columnIndex : 1, key : "IS_APPLIED",  title : "-",           align : "center", width : "30px",
                                        editable : { 
                                            type : "check", 
                                            rule: [{value:"1",check:true},{value:"0",check:false}]
                                        },
                                        render : { 
                                            type : "check", 
                                            rule: [{value:"1",check:true},{value:"0",check:false}]
                                        }
                    },
                    { columnIndex : 2, key : "DUTY_CD",     title : "직무코드",  align : "center", width : "80px" },
                    { columnIndex : 3, key : "DUTY_NM",     title : "직무명",    align : "left",   width : "120px" },
                    { columnIndex : 4, key : "USER_TYP_NM", title : "직무유형",  align : "center", width : "80px" },
                    { columnIndex : 5, key : "USER_TYP",    title : "USER_TYP",  hidden:true }
                ]
            };
            $("#gridauthgrpaplyduty1").alopexGrid(_grid_colmap);
            $("#gridauthgrpaplyduty3").alopexGrid(_grid_colmap);
            $("#gridauthgrpaplyduty4").alopexGrid(_grid_colmap);

            $("#gridauthgrpaplyduty1").alopexGrid('updateOption', {
                on : {
                    'cell' : {
                        "click" : function(data, eh, e) {
                            $('#gridauthgrpaplyduty1').alopexGrid('endEdit', {_index:{"data":data._index.data}}, true);
                            $("#gridauthgrpaplyduty1 table.table tr").removeClass("editing"); //'editing' 클래스 삭제
                        }
                    }
                }
            });
            $("#gridauthgrpaplyduty3").alopexGrid('updateOption', {
                on : {
                    'cell' : {
                        "click" : function(data, eh, e) {
                            $('#gridauthgrpaplyduty3').alopexGrid('endEdit', {_index:{"data":data._index.data}}, true);
                            $("#gridauthgrpaplyduty3 table.table tr").removeClass("editing"); //'editing' 클래스 삭제
                        }
                    }
                }
            });
            $("#gridauthgrpaplyduty4").alopexGrid('updateOption', {
                on : {
                    'cell' : {
                        "click" : function(data, eh, e) {
                            $('#gridauthgrpaplyduty4').alopexGrid('endEdit', {_index:{"data":data._index.data}}, true);
                            $("#gridauthgrpaplyduty4 table.table tr").removeClass("editing"); //'editing' 클래스 삭제
                        }
                    }
                }
            });
            
        }, //end-of-setGrid2
        setCodeData : function() {
            //$.PSNMUtils.setCodeData([
            //    { t:'code',  'elemid' : 'RCV_TYP_CD', 'header' : '-전체-' } //전체, 선택 등이 넣으려면 설정
            //]);
        }
    });//end-of-$.alopex.page //-------------------------------------------------------------------------------------------------------//

    //조회 처리 : param은 페이지 이동시에만 값이 전달됨
    function pSearchAuthGrp() {
        $("#gridauthgrpaplyduty1").alopexGrid("dataEmpty");
        $("#gridauthgrpaplyduty3").alopexGrid("dataEmpty");
        $("#gridauthgrpaplyduty4").alopexGrid("dataEmpty");

        $.alopex.request(_TX_SEARCH, {
            data: [function() {
                //_debug("<pSearchAuthGrp> <request.data> 파라미터 (this.data.dataSet.fields) : " + JSON.stringify(this.data.dataSet.fields));
            }],
            success: ['#gridauthgrp', function(res) {
                //_debug("<pSearchAuthGrp> <request.success> 결과데이터 : " + JSON.stringify(res));
            }]
        });
    } //end of pSearchAuthGrp()

    function addAuthGrp(e) {
        var gridauthgrp = $("#gridauthgrp").alopexGrid("dataGet");
            gridauthgrp = AlopexGrid.trimData(gridauthgrp);
        var popParam = {
            "mode" : "insert",
            "gridauthgrp" : gridauthgrp
        };
        $a.popup({
            url: "com/auth/authGrpRegPop"
          , data: popParam
          , width: 500
          , height: 430
          , title: "권한그룹정보"
          , callback : function(data) {
                _debug("addAuthGrp", "result of authGrpRegPop.jsp :", JSON.stringify(data)); //{"result":"success"}
                if ( "success"==data["result"] ) {
                    pSearchAuthGrp();
                }
            }
        });
    }
    function updateAuthGrp(data) {
        var popParam = {
            "mode" : "update",
            "authgrp" : data
        };
        $a.popup({
            url: "com/auth/authGrpRegPop"
          , data: popParam
          , width: 500
          , height: 430
          , title: "권한그룹정보"
          , callback : function(data) {
                _debug("updateAuthGrp", "result of authGrpRegPop.jsp :", JSON.stringify(data)); //{"result":"success"}
                if ( "success"==data["result"] ) {
                    pSearchAuthGrp();
                }
            }
        });
    }

    function delAuthGrp(e) {
        _debug("delAuthGrp", e.target.id);
        var arrSelAuthGrp = $("#gridauthgrp").alopexGrid("dataGet", {_state:{selected:true}}); //선택된 데이터
        if (arrSelAuthGrp.length<1) {
            alert("삭제할 권한그룹를 선택하십시오!");
            return;
        }

        var authgrpData = arrSelAuthGrp[0]; //1개만 있음

        var currRow  = authgrpData._index.data;
        var oCurrRowQuery = {_index:{data:authgrpData._index.data}};

        if ( !$.PSNM.confirm("I004", ["삭제"]) ) {
            return false;
        }
        $("#gridauthgrp").alopexGrid("dataEdit", {"FLAG":"D"}, oCurrRowQuery); //F를 'D'로 마크함

        var _d = $.PSNMUtils.getRequestDataUpdated("gridauthgrp");

        $.alopex.request(_TX_DELETE, {
            data: _d,
            success: function(res) { //success: ['#gridauthgrpaplyduty1', '#gridauthgrpaplyduty3', '#gridauthgrpaplyduty4',function(res) {
                pSearchAuthGrp();
            }
        });
        /*if ( "I"==authgrpData["FLAG"] ) {
            $("#gridauthgrp").alopexGrid("dataDelete", oCurrRowQuery);
            return;
        }
        else if ( "D"==authgrpData["FLAG"] ) {
            $("#gridauthgrp").alopexGrid("dataEdit", {"FLAG":""}, oCurrRowQuery);
        }
        else {
            $("#gridauthgrp").alopexGrid("dataEdit", {"FLAG":"D"}, oCurrRowQuery);
        }*/
    }

    //권한그룹적용직무 저장
    function pSaveAuthGrpAplyDuty(e) {
        //_debug("pSaveAuthGrpAplyDuty", e.target.id);
        var invalidData = $("#gridauthgrp").alopexGrid("dataInvalid");
        if ( null!=invalidData ) {
            _debug("pSaveAuthGrpAplyDuty", "오류데이터(첫번째항목)", JSON.stringify(invalidData));
            return $.PSNM.alert("E003", [""], false); //잘못된 데이터 항목이 있습니다! {0}
        }

        //변경된 데이터만 파라미터로 전달
        var _d = $.PSNMUtils.getRequestDataUpdated("gridauthgrpaplyduty1", "gridauthgrpaplyduty3", "gridauthgrpaplyduty4");
        //var _ag = _d.dataSet.recordSets["gridauthgrp"].nc_list;
        var _agad1 = _d.dataSet.recordSets["gridauthgrpaplyduty1"].nc_list;
        var _agad3 = _d.dataSet.recordSets["gridauthgrpaplyduty3"].nc_list;
        var _agad4 = _d.dataSet.recordSets["gridauthgrpaplyduty4"].nc_list;
        var cnt = _agad1.length + _agad3.length + _agad4.length; //_ag.length + 
        if ( cnt<1 ) {
            return $.PSNM.alert("E011", ["변경된 직무"], false); //{0} 데이터가 없습니다!
        }
        if ( !$.PSNM.confirm("I004", ["적용직무를 저장"]) ) { //{0} 하시겠습니까?
            return false;
        }

        var arrSelAuthGrp = $("#gridauthgrp").alopexGrid("dataGet", {_state:{selected:true}}); //선택된 권한그룹 데이터
        var authGrpId = arrSelAuthGrp[0]["AUTH_GRP_ID"];
        _d.dataSet.fields["AUTH_GRP_ID"] = authGrpId; //권한그룹ID

        $.alopex.request(_TX_SAVE, {
            data: _d,
            success: ['#gridauthgrpaplyduty1', '#gridauthgrpaplyduty3', '#gridauthgrpaplyduty4', function(res) {
                startEditDutyGrids();
                $.PSNM.alert("I000"); //정상적으로 처리되었습니다.
            }]
        });
    }

    //권한그룹적용직무 조회 : param은 페이지 이동시에만 값이 전달됨
    function pSearchAuthGrpAplyDuty(oAuthGrp) {
        var param = AlopexGrid.trimData(oAuthGrp);
        if ( "I"==param["FLAG"] ) {
            alert("추가된 권한그룹의 직무는 조회하지 않습니다!");
            return;
        }
        $.alopex.request(_TX_SEARCH2, {
            showProgress:false,
            data: [function() {
                this.data.dataSet.fields["AUTH_GRP_ID"] = param["AUTH_GRP_ID"];
                _debug("pSearchAuthGrpAplyDuty", "(this.data.dataSet.fields)", JSON.stringify(this.data.dataSet.fields));
            }],
            success: ['#gridauthgrpaplyduty1', '#gridauthgrpaplyduty3', '#gridauthgrpaplyduty4',function(res) {
                //_debug("<pSearchAuthGrpAplyDuty> <request.success> 결과데이터 : " + JSON.stringify(res));
                startEditDutyGrids();
            }]
        });
    } //end of pSearchAuthGrpAplyDuty()

    function downloadExcel() {
        var oExcelMetaInfo = {
            filename  : "권한그룹목록.xls",
            sheetname : "권한그룹목록",
            gridname  : "gridauthgrp" //그리드ID 
        };
        $.PSNMUtils.downloadExcelAll("sform", _TX_SEARCH, "gridauthgrp", oExcelMetaInfo, [0,6,7]);
    }

    function startEditDutyGrids() {
        $("#gridauthgrpaplyduty1").alopexGrid("startEdit"); //, {_index:{data:0}}
        $("#gridauthgrpaplyduty1 table.table tr").removeClass("editing"); //'editing' 클래스를 삭제(회색바탕)
        $("#gridauthgrpaplyduty3").alopexGrid("startEdit"); //, {_index:{data:0}}
        $("#gridauthgrpaplyduty3 table.table tr").removeClass("editing"); //'editing' 클래스를 삭제(회색바탕)
        $("#gridauthgrpaplyduty4").alopexGrid("startEdit"); //, {_index:{data:0}}
        $("#gridauthgrpaplyduty4 table.table tr").removeClass("editing"); //'editing' 클래스를 삭제(회색바탕)
    }
    </script>

</head>

<body>

<jsp:include page="/view/layouts/default_header.jsp" flush="false" />

<!-- title area -->
<div id="contents">

    <div class="content_title">
        <div class="ub_txt6">
            <span class="txt6_img"><b id="sub-title">권한그룹관리</b>
                <span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif">
                <span class="a2">본사업무</span> <span class="a3"> > </span> <span class="a4"><b>권한그룹관리</b></span> 
            </span>
        </div>
    </div>

    <!-- 1줄 find condition area -->
    <div class="textAR">
      <form id="sform">
        <table class="board02" style="width:92%; border:0;">
        <tr>
            <!--
            <th style=" color:#ea002c;" scope="col" width="15%">대권한그룹</th>
            -->
            <td class="tleft" style="border:0;">
                &nbsp;
            </td>
        </tr>
        </table>
      </form>
        <div class="ab_pos5">
            <button type="button" id="btnSearch" data-type="button" data-theme="af-psnm" data-authtype="W" data-altname="조회"></button>
        </div>
    </div>

    <div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>권한그룹정보</b>
        <p class="ab_pos2">
            <button id="btnAdd"       type="button" data-type="button" data-theme="af-btn2"  data-authtype="W" data-altname="추가"></button>
            <button id="btnDel"       type="button" data-type="button" data-theme="af-btn13" data-authtype="W" data-altname="삭제"></button>
            <button id="btnSave"      type="button" data-type="button" data-theme="af-btn4"  data-authtype="W" data-altname="저장"></button>
            <button id="btnExcelAll"  type="button" data-type="button" data-theme="af-btn3"  data-authtype="W" data-altname="엑셀다운"></button>
        </p>
    </div>

    <!-- 권한그룹 grid -->
    <div id="gridauthgrp" data-bind="grid:gridauthgrp" data-ui="ds"></div>

    <div class="psnm-section">
        <div class="psnm-sec3left">
            <div class="psnm-secleft-head">
                <span class="psnm-section-title"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <span id="psnm-sec-title1">임직원</span></span>
                <span class="psnm-section-buttons">
                    &nbsp;
                </span>
            </div>
            <!-- 왼쪽 그리드1 -->
            <div id="gridauthgrpaplyduty1" data-bind="grid:gridauthgrpaplyduty1" data-ui="ds"></div>
        </div>
        <div class="psnm-sec3center">
            <div class="psnm-secleft-head">
                <span class="psnm-section-title"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <span id="psnm-sec-title3">도급직</span></span>
                <span class="psnm-section-buttons">
                    &nbsp;
                </span>
            </div>
            <!-- 왼쪽 그리드1 -->
            <div id="gridauthgrpaplyduty3" data-bind="grid:gridauthgrpaplyduty3" data-ui="ds"></div>
        </div>
        <div class="psnm-sec3right">
            <div class="psnm-secright-head">
                <span class="psnm-section-title"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <span id="psnm-sec-title4">에이전트</span></span>
                <span class="psnm-section-buttons">
                    &nbsp;
                </span>
            </div>
            <!-- 오른쪽 그리드2 -->
            <div id="gridauthgrpaplyduty4" data-bind="grid:gridauthgrpaplyduty4" data-ui="ds"></div>
        </div>
    </div>

</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>
