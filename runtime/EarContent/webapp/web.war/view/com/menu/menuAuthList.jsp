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

    var _TX_SEARCH_AUTH_GRP  = "com.AUTH@PAUTHGRP_pSearchAuthGrp";         //
    var _TX_SEARCH_MENU      = "com.MENU@PMENU001_pSearchMenu";
    var _TX_SEARCH_BY_SUP    = "com.MENU@PMENU001_pSearchMenuBySup";
    var _TX_SEARCH_MENU_AUTH = "com.MENU@PMENUAUTH001_pSearchMenuAuth";
    var _TX_SAVE_MENU_AUTH   = "com.MENU@PMENUAUTH001_pSaveMenuAuth";
    
    var _isCheckAllHandler = false;

    $.alopex.page({

        init : function(id, param) { 
            _debug("menuList", "init()", JSON.stringify(param));

            $.PSNM.initialize(id, param); //PSNM공통 초기화함수 호출(서브 페이지에서는 필수 호출)

            $a.page.setEventListener();
            $a.page.setGrid();
            $a.page.setCodeData();
            $a.page.setValidators();

            $('#sform').setData(param); //(설명) 상세페이지에서 돌아오는 경우, 이 값들이 세션스토리지에서 반환됨.

            $("#AUTH_GRP_ID").focus(); //TOP_MENU_ID
        },
        setEventListener : function() {
            $("#btnSearch").click( pSearchMenuAuth );
            $("#btnSave").click( pSaveMenuAuth );
            //$("#R_ALL").change( handleReadAuthAll );
        },
        setGrid : function() {
            $("#gridmenuauth").alopexGrid({
                pager: false,
                rowClickSelect : false,
                rowInlineEdit : false,
                height : 600,
                headerGroup : [ //헤더를 index로 기준으로 하여 묶고 그 위에 타이틀을 표시
                    { fromIndex:7, toIndex:7, title:"읽기권한" },
                    { fromIndex:8, toIndex:8, title:"쓰기권한" }
                ],
                columnMapping : [
                    { columnIndex : 0, key : "FLAG",        title : "F",           align : "center", width : "30px",   refreshBy:true, 
                                        refreshBy:true, 
                                        value : function(value, data) {
                                            if (data._state.added) return 'I';
                                            if (data._state.deleted) return 'D';
                                            if (data._state.edited) return 'U';
                                            return ''; 
                                        }
                    },
                    { columnIndex : 1, key : "MENU_TYP_CD", title : "선택",     width : "80px",
                                        render : function(value, data) {
                                            if ( 1==value ) {
                                                return '<img src="${pageContext.request.contextPath}/image/blat_a15_a.gif">';
                                            } else if ( 2==value ) {
                                                return '　　<img src="${pageContext.request.contextPath}/image/blat_a15_b.gif">';
                                            } else if ( 3==value ) {
                                                return '　　　　<img src="${pageContext.request.contextPath}/image/blat_a25.gif">';
                                            }
                                        }
                    },
                    { columnIndex : 2, key : "MENU_TYP_NM", title : "메뉴유형", align : "center", width : "80px"  },
                    { columnIndex : 3, key : "MENU_ID",     title : "메뉴ID",   align : "center", width : "80px"  },
                    { columnIndex : 4, key : "MENU_NM",     title : "메뉴명",   align : "left",   width : "150px" },
                    { columnIndex : 5, key : "BRWS_SEQ",    title : "순서",     align : "center", width : "50px"  },
                    { columnIndex : 6, key : "USE_YN",      title : "사용여부", align : "center", width : "70px"  },
                    { columnIndex : 7, key : "R_AUTH",      align : "center", width : "100px",
                                        title : "<input type='checkbox' id='R_ALL' name='R_ALL' />",
                                        editable : { type : "check", rule: [{value:"1",check:true},{value:"0",check:false}] },
                                        render   : { type : "check", rule: [{value:"1",check:true},{value:"0",check:false}] }
                    },
                    { columnIndex : 8, key : "W_AUTH",      align : "center", width : "100px",
                                        title : "<input type='checkbox' id='W_ALL' name='W_ALL' />",
                                        render   : { type : "check", rule: [{value:"1",check:true},{value:"0",check:false}] },
                                        editable : { type : "check", rule: [{value:"1",check:true},{value:"0",check:false}] }
                    },
                    { columnIndex : 9, key : "AUTH_TYP_CD", title : "AUTH_TYP_CD", hidden:true }
                ]
                ,
                on : {
                    'cell' : {
                        "click" : function(data, eh, e) {
                            $('#gridmenuauth').alopexGrid('endEdit', {_index:{"data":data._index.data}}, true);
                            $("#gridmenuauth table.table tr").removeClass("editing");
                        }
                    }
                    ,
                    data : {
                        "edit" : function(data, query) {
                            _debug("grid.on.data.edit", "data", JSON.stringify(data), "query", JSON.stringify(query));
                        }
                        ,
                        "changed" : function(type) {
                            //_debug("grid.on.data.changed", "type", type);
                            checkAllByData();
                        }
                    }
                }
            });
        }
        ,
        setCodeData : function() {
            $.alopex.request(_TX_SEARCH_AUTH_GRP, {
                showProgress:false,
                async:false, //공통코드 조회는 sync로 조회함
                data: [function() {
                    //_debug("<pSearchAuthGrp> <request.data> 파라미터 (this.data.dataSet.fields) : " + JSON.stringify(this.data.dataSet.fields));
                }],
                success: function(res) {
                    var datalist = res.dataSet.recordSets["gridauthgrp"].nc_list;

                    var codeOptions = [];
                        codeOptions.push({ value: "", text: "-선택-"});

                    $.each(datalist, function (index, codeinfo) {
                        var codeOpt = new Object();
                            codeOpt["value"] = codeinfo["AUTH_GRP_ID"];
                            codeOpt["text"]  = codeinfo["AUTH_GRP_NM"];
                        codeOptions.push(codeOpt);
                    });
                    var optData = new Object();
                        optData["options_AUTH_GRP_ID"] = codeOptions;

                    $("#AUTH_GRP_ID").setData(optData);
                }
            });

            //대메뉴 목록을 조회하여 select 에 바인드
            $.alopex.request(_TX_SEARCH_BY_SUP, {
                showProgress:false,
                async:false, //공통코드 조회는 sync로 조회함
                data: {
                    dataSet: {}
                },
                success: function(res) {
                    var menuList = res.dataSet.recordSets["menubysup"].nc_list;

                    var codeOptions = [];
                        codeOptions.push({ value: "", text: "-전체-"});

                    $.each(menuList, function (index, codeinfo) {
                        var codeOpt = new Object();
                            codeOpt["value"] = codeinfo.MENU_ID;
                            codeOpt["text"]  = codeinfo.MENU_NM;
                        codeOptions.push(codeOpt);
                    });
                    var optData = new Object();
                        optData["options_TOP_MENU_ID"] = codeOptions;

                    $("#TOP_MENU_ID").setData(optData);
                }
            });
        }
        ,
        setValidators : function() {
            $('#AUTH_GRP_ID').validator({
                rule : { required: true },
                message: {
                    required: $.PSNM.msg('E012', ["권한그룹"]) //{0} 항목은 필수값입니다!
                }
            });
        }
    });
    //-------------------------------------------------------------------------------------------------------//

    //메뉴권한 조회
    function pSearchMenuAuth(bForceSearch) {
        if ( !$.PSNM.isValid("sform") ) {
            return false;
        }

        if ( $.PSNMUtils.isEmpty(bForceSearch) || false==bForceSearch ) {
            if ( isGridDataChanged("gridmenuauth")>0 ) {
                if ( !$.PSNM.confirm("I005", ["변경", "조회"]) ) { //변경된 데이터가 있습니다. 조회 하시겠습니까?
                    return false;
                }
            }
        }

        $("#gridmenuauth").alopexGrid("dataEmpty");

        $.alopex.request(_TX_SEARCH_MENU_AUTH, {
            data: ['#sform', function() {
                _debug("pSearchMenuAuth", "request.data", "파라미터 (this.data.dataSet.fields)", JSON.stringify(this.data.dataSet.fields));
            }],
            success: ['#gridmenuauth', function(res) {
                $("#gridmenuauth").alopexGrid("startEdit"); //, {_index:{data:0}}

                //그리드가 다시 설정됨.
                $("#R_ALL").click( handleReadAuthAll );
                $("#W_ALL").click( handleWriteAuthAll );
                $("#gridmenuauth table.table tr").removeClass("editing"); //메뉴권한조회 테이블의 'editing' 클래스를 삭제(회색바탕)
            }]
        });
    }

    function isGridDataChanged(sGridId) {
        var gridid = sGridId.replace(/#/, "");
        var list = $("#" + gridid).alopexGrid("dataGet", {_state:{edited:true}});
        var cnt = (null==list ? -1 : list.length);
        _debug("isGridDataChanged", "cnt", cnt);
        return cnt; //1이상=변경된 데이터 있음, 0=변경된 데이터 없음, -1=그리드없음
    }
    
    function handleReadAuthAll(e) {
        _debug("handleReadAuthAll", e.target.id, e.target.checked);
        if ( e.target.checked ) {
            $("#gridmenuauth").alopexGrid("dataEdit", {"R_AUTH":"1"});
        }
        else {
            $("#gridmenuauth").alopexGrid("dataEdit", {"R_AUTH":"0"});
            $("#gridmenuauth").alopexGrid("dataEdit", {"W_AUTH":"0"});
            $("#W_ALL").attr("checked", false);
        }
        $("#gridmenuauth table.table tr").removeClass("editing");
    }
    function handleWriteAuthAll(e) {
        _debug("handleWriteAuthAll", e.target.id, e.target.checked);
        if ( e.target.checked ) {
            $("#R_ALL").attr("checked", true);
            $("#gridmenuauth").alopexGrid("dataEdit", {"R_AUTH":"1"});
            $("#gridmenuauth").alopexGrid("dataEdit", {"W_AUTH":"1"});
        }
        else {
            $("#gridmenuauth").alopexGrid("dataEdit", {"W_AUTH":"0"});
        }
        $("#gridmenuauth table.table tr").removeClass("editing");
    }
    function checkAllByData() {
        var dataList  = $("#gridmenuauth").alopexGrid("dataGet");
        var dataCount = dataList.length;
        var _r_tocheck = true;
        var _w_tocheck = true;
        for(var i=0; i<dataCount; i++) {
            _r_tocheck &= ("1"==dataList[i].R_AUTH ? true : false);
            _w_tocheck &= ("1"==dataList[i].W_AUTH ? true : false);
        }
        _debug("checkAllByData", "데이터건수="+dataCount, "최종_r_tocheck=" + _r_tocheck, "최종_w_tocheck=" + _w_tocheck);

        if (!_r_tocheck) {
            $("#R_ALL").removeAttr("checked");
        }
        else {
            $("#R_ALL").attr("checked", "checked");
            document.getElementById("R_ALL").checked = true;
        }
        if (!_w_tocheck) {
            $("#W_ALL").removeAttr("checked");
        }
        else {
            $("#W_ALL").attr("checked", "checked");
            document.getElementById("W_ALL").checked = true;
        }
    }

    //메뉴권한 저장
    function pSaveMenuAuth(e) {
        var updatedDataListRaw = $("#gridmenuauth").alopexGrid("dataGet", {_state:{edited:true}});
        var updatedDataList = AlopexGrid.trimData( updatedDataListRaw );
        var updatedDataCount = updatedDataList.length;
        if ( updatedDataCount<1 ) {
            var r = $.PSNM.alert("E011", ["변경된"], false); //alert("변경된 데이터가 없습니다."); return false;
            return r;
        }
        _debug("pSaveMenuAuth", "갱신된 건수", updatedDataCount); //alert( JSON.stringify(updatedDataListRaw) );

        var updatedDataSet = $.PSNMUtils.getRequestDataUpdated("gridmenuauth"); //변경된 데이터만 파라미터로 전달
        _debug( JSON.stringify(updatedDataSet) );

        $.alopex.request(_TX_SAVE_MENU_AUTH, {
            data: updatedDataSet,
            success: function(res) {
                if ( ! $.PSNM.success(res) ) {
                    return;
                }
                $.PSNM.alert("I000"); //정상적으로 처리되었습니다.
                pSearchMenuAuth(true);
            }
        });
    }
    </script>

</head>

<body>

<jsp:include page="/view/layouts/default_header.jsp" flush="false" />

<!-- title area -->
<div id="contents">
    <div class="content_title">
        <div class="ub_txt6">
            <span class="txt6_img"><b id="sub-title">메뉴권한관리</b>
                <span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif">
                <span class="a2">본사업무</span> <span class="a3"> > </span> <span class="a4"><b>메뉴관리</b></span> 
            </span>
        </div>
    </div>

    <!-- 1줄 find condition area -->
    <div class="textAR">
      <form id="sform" onsubmit="return false;">
        <table class="board02" style="width:92%;">
       	<colgroup>
            <col style="width:15%"/>
            <col style="width:20%"/>
            <col style="width:15%"/>
            <col style="width:*"/>
        </colgroup>
        <tr>
            <th scope="col" class="psnm-required">권한그룹</th>
            <td class="tleft">
                <select id="AUTH_GRP_ID" name="AUTH_GRP_ID" data-bind="options:options_AUTH_GRP_ID, selectedOptions:AUTH_GRP_ID" data-type="select" data-wrap="false" style="width:150px;">
                    <option value="">-전체-</option>
                </select>
            </td>
            <th scope="col">대메뉴</th>
            <td class="tleft">
                <select id="TOP_MENU_ID" name="TOP_MENU_ID" data-bind="options:options_TOP_MENU_ID, selectedOptions:TOP_MENU_ID" data-type="select" data-wrap="false" style="width:150px;">
                    <option value="">-전체-</option>
                </select>
            </td>
        </tr>
        </table>
      </form>
        <div class="ab_pos5">
            <button type="button" id="btnSearch" data-type="button" data-theme="af-psnm" data-authtype="R" data-altname="조회"></button>
        </div>
    </div>

    <div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>메뉴권한</b>
        <p class="ab_pos2">
            <button id="btnSave" type="button" data-type="button" data-theme="af-btn4" data-authtype="W" data-altname="저장"></button>
        </p>
    </div>

    <!-- 메뉴권한 grid -->
    <div id="gridmenuauth" data-bind="grid:gridmenuauth" data-ui="ds"></div>

</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>
