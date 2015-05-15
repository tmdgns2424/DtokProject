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

    <script type="text/javascript">
    _LOG_LEVEL = 0; //로그레벨 :: 0=debug, 1=info, 2=error
    
    var _ARRDATA_YESNO = [ {"text":"Y","value":"Y"}, {"text":"N","value":"N"} ];
    var _ARRDATA_RCRT  = [ {"text":"제한없음","value":"A"}, {"text":"제한","value":"Y"}, {"text":"미제한","value":"N"} ]; //사용제한구분(A:제한없음, Y:제한, N:미제한)

    var _TX_SEARCH        = "com.MENU@PMENU001_pSearchMenu";
    var _TX_SEARCH_BY_SUP = "com.MENU@PMENU001_pSearchMenuBySup";
    var _TX_SAVE          = "com.MENU@PMENU001_pSaveMenu";

    $.alopex.page({

        init : function(id, param) { 
            _debug("menuList", "init()", JSON.stringify(param));

            $.PSNM.initialize(id, param); //PSNM공통 초기화함수 호출

            $a.page.setEventListener();
            $a.page.setGrid();
            $a.page.setCodeData();

            $('#sform').setData(param);

            pSearchMenu(); //조회
        },
        setEventListener : function() {
            $("#btnSearch").click( pSearchMenu );
            $("#btnInit").click( initCondition );
            $("#btnAdd").click( addMenu );
            $("#btnDel").click( delMenu );
            $("#btnSave").click( saveMenu );
            $("#btnExcelAll").click( downloadExcel );
            $("#TOP_MENU_ID").change( pSearchMenu );
        },
        setGrid : function() {
            $("#gridmenu").alopexGrid({
                pager:false,
                rowSingleSelect: true,
                rowInlineEdit  : true,
                height: 500,
                columnMapping : [
                    { columnIndex : 0, key : "FLAG",        title : "F",        align : "center", width : "30px", refreshBy:true, 
                                        value : function(value, data) {
                                            //_debug("gridmenu.FLAG", JSON.stringify(value), JSON.stringify(data._state));
                                            if ( "I"==value || "D"==value ) { return value; } //추가|삭제는 그냥둠
                                            return ( (data._state.edited) ? 'U' : '' ); 
                                        }
                    },
                    { columnIndex : 1, key : "MENU_TYP_CD", title : "선택",     width : "80px",
                                        render : function(value, data) {
                                            //_debug("그리드렌더", value, JSON.stringify(data));
                                            if ( 1==value ) {
                                                return '<img src="${pageContext.request.contextPath}/image/blat_a15_a.gif">';
                                            } else if ( 2==value ) {
                                                return '　　<img src="${pageContext.request.contextPath}/image/blat_a15_b.gif">';
                                            } else if ( 3==value ) {
                                                return '　　　　<img src="${pageContext.request.contextPath}/image/blat_a25.gif">';
                                            }
                                        }
                    },
                    { columnIndex : 2, key : "MENU_TYP_NM", title : "메뉴유형", align : "center", width : "80px" },
                    { columnIndex : 3, key : "MENU_ID",     title : "메뉴ID",   align : "center", width : "80px" , editable : { type : "text" } },
                    { columnIndex : 4, key : "MENU_NM",     title : "메뉴명",   align : "left",   width : "160px", editable : { type : "text" } },
                    { columnIndex : 5, key : "MENU_URL",    title : "URL",      align : "left",   width : "230px", editable : { type : "text" } },
                    { columnIndex : 6, key : "BRWS_SEQ",    title : "순서",     align : "center", width : "70px" , editable : { type : "text" } },
                    { columnIndex : 7, key : "CS_YN",      title : "CS여부", align : "center", width : "80px" , 
                                        render : function(value, data) {
                                            return ("Y"==value ? "Y" : "N");
                                        },
                                        editable : {
                                            type : "select", 
                                            rule : _ARRDATA_YESNO
                                        } 
                    },
                    { columnIndex : 8, key : "RSTRCT_CL",      title : "제한구분", align : "center", width : "80px" , 
                                        render : function(value, data) {
                                            return ("A"==value ? "제한없음" : ("Y"==value ? "제한" : "미제한"));
                                        },
                                        editable : { 
                                            type : "select", 
                                            rule : _ARRDATA_RCRT
                                        } 
                    },
                    { columnIndex : 9, key : "USE_YN",      title : "사용여부", align : "center", width : "80px" , 
                                        render : function(value, data) {
                                            return ("Y"==value ? "사용" : "미사용");
                                        },
                                        editable : { 
                                            type : "select", 
                                            rule : _ARRDATA_YESNO
                                        }
                    },
                    { columnIndex :10, key : "AUTH_OBJ_YN", title : "인증대상", align : "center", width : "80px" , 
                                        render : function(value, data) {
                                            return ("Y"==value ? "대상" : "미대상");
                                        },
                                        editable : { 
                                            type : "select", 
                                            rule : _ARRDATA_YESNO
                                        }
                    },
                    { columnIndex :11, key : "UPD_YMD",     title : "처리일자", align : "center", width : "90px" },
                    { columnIndex :12, key : "SUB_MENU_CNT",title : "SUB_MENU_CNT", hidden:true },
                    { columnIndex :13, key : "SUP_MENU_ID", title : "SUP_MENU_ID",  hidden:true }
                ]
                ,
                on : {
                    'cell' : {
                        "click" : function(data, eh, e) {
                            //alert( JSON.stringify(data._key) + "\n\n" + JSON.stringify(data) );
                        }
                    }
                    ,
                    data : {
                        "changed" : function(type, arg2) {
                            _debug("gridmenu.data.changed", "change type", type);
                        }
                        ,
                        "edit" : function(data, query) {
                            _debug("gridmenu.data.edit", JSON.stringify(data), JSON.stringify(query));
                        }
                    }
                }
            });
        },
        setCodeData : function() {
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
    });//end-of-$.alopex.page //-------------------------------------------------------------------------------------------------------//

    //조회 처리 : param은 페이지 이동시에만 값이 전달됨
    function pSearchMenu() {
        $("#gridmenu").alopexGrid("dataEmpty");

        $.alopex.request(_TX_SEARCH, {
            data: ['#sform', function() {
                //_debug("<pSearchMenu> <request.data> 파라미터 (this.data.dataSet.fields) : " + JSON.stringify(this.data.dataSet.fields));
            }],
            success: ['#gridmenu', function(res) {
                //_debug("<pSearchMenu> <request.success> 결과데이터 : " + JSON.stringify(res));
            }]
        });
    } //end of pSearchMenu()

    //검색조건을 초기화함
    function initCondition() {
        $.PSNM.resetCondition("#sform"); //지정된 폼의 모든 데이터를 초기화
    }
    
    function addMenu(e) {
        _debug("addMenu", e.target.id);
        var arrSelMenu = $("#gridmenu").alopexGrid("dataGet", {_state:{selected:true}}); //선택된 데이터

        if (arrSelMenu.length<1) {
            if ( confirm('대메뉴로 추가하시겠습니까?') ) {
                var arrTopMenu = $("#gridmenu").alopexGrid("dataGet", {"MENU_TYP_CD":"1"});
                var maxBrwsSeq = 1;
                $.each(arrTopMenu, function(index, topMenu) {
                    var topMenuBrwsSeq = topMenu["BRWS_SEQ"];
                    if (maxBrwsSeq<parseInt(topMenuBrwsSeq)) {
                        maxBrwsSeq = parseInt(topMenuBrwsSeq);
                    }
                });

                $("#gridmenu").alopexGrid("dataAdd", {
                    "FLAG"        : "I",
                    "MENU_TYP_CD" : "1", //<img src='${pageContext.request.contextPath}/image/blat_a15_a.gif'>
                    "MENU_TYP_NM" : "대메뉴",
                    "BRWS_SEQ"    : "" + (1+maxBrwsSeq),
                    "USE_YN"      : "Y",
                    "UPDR_NM"     : $.PSNM.getSession("USER_NM"),
                    "UPD_YMD"     : "",
                    "SUB_MENU_CNT": "0",
                    "SUP_MENU_ID" : "0000"
                });
                var rowCount = $("#gridmenu").alopexGrid("dataGet").length;
                var rowIndex = rowCount-1;
                $("#gridmenu").alopexGrid("startEdit", {_index:{data:rowIndex}});

                $("#gridmenu").alopexGrid("dataEdit", {_state:{edited:true}}, {_index:{data:rowIndex}}); //edited:true
                $("#gridmenu").alopexGrid("startEdit", {_index:{data:rowIndex}});
                $("#gridmenu").alopexGrid("dataEdit", {_state:{selected:false}}, {_state:{selected:true}}); //체크 해제
                $("#gridmenu").alopexGrid("dataScroll", rowIndex); //스크롤
                //window.scrollTo(0, document.body.scrollHeight); //화면하단으로 스크롤
            }
            return;
        }
        else if (arrSelMenu.length==1) {
            var oSelMenu = arrSelMenu[0];
            var menuType = oSelMenu["MENU_TYP_CD"]; //1=대메뉴, 2=중메뉴, 3=화면 이 선택된 것
            var menuId   = oSelMenu["MENU_ID"]; //메뉴ID(현재 선택된)
            var currRow  = oSelMenu._index.data;
            var nextRow  = 1 + currRow;
            var oCurrRowQuery = {_index:{data:currRow}};
            var oNextRowQuery = {_index:{data:nextRow}};
            _debug("oSelMenu ::: " + JSON.stringify(oSelMenu));

            var newMenuType   = ("1"==menuType ? "2" : ("2"==menuType ? "3" : "3"));
            var newMenuTypeNm = ("1"==newMenuType ? "대메뉴" : ("2"==newMenuType ? "중메뉴" : "화면"));
            var supMenuId     = menuId;
            if ( "3"==menuType ) 
                supMenuId     = oSelMenu["SUP_MENU_ID"]; //상위메뉴ID 조정

            $("#gridmenu").alopexGrid("dataAdd", {
                "FLAG"        : "I",
                "MENU_TYP_CD" : newMenuType, //<img src='${pageContext.request.contextPath}/image/blat_a15_a.gif'>
                "MENU_TYP_NM" : newMenuTypeNm,
                "BRWS_SEQ"    : "",
                "USE_YN"      : "Y",
                "UPDR_NM"     : $.PSNM.getSession("USER_NM"),
                "UPD_YMD"     : "",
                "SUB_MENU_CNT": "0",
                "SUP_MENU_ID" : supMenuId
            }, oNextRowQuery);
            $("#gridmenu").alopexGrid("dataEdit", {_state:{edited:true}}, oNextRowQuery); //edited:true
            $("#gridmenu").alopexGrid("startEdit", oNextRowQuery);
            $("#gridmenu").alopexGrid("dataEdit", {_state:{selected:false}}, {_state:{selected:true}}); //체크 해제
            $("#gridmenu").alopexGrid("dataScroll", nextRow); //스크롤
        }
    }

    function delMenu(e) {
        _debug("delMenu", e.target.id);
        var arrSelMenu = $("#gridmenu").alopexGrid("dataGet", {_state:{selected:true}}); //선택된 데이터
        if (arrSelMenu.length<1) {
            alert("삭제할 메뉴를 선택하십시오!");
            return;
        }

            var menuData = arrSelMenu[0]; //1개만 있음

            var currRow  = menuData._index.data;
            var oCurrRowQuery = {_index:{data:menuData._index.data}};

            if ( "I"==menuData["FLAG"] ) {
                $("#gridmenu").alopexGrid("dataDelete", oCurrRowQuery);
                return;
            }
            else if ( "D"==menuData["FLAG"] ) {
                $("#gridmenu").alopexGrid("dataEdit", {"FLAG":""}, oCurrRowQuery);
            }
            else {
                $("#gridmenu").alopexGrid("dataEdit", {"FLAG":"D"}, oCurrRowQuery);
            }
    }

    //메뉴정보를 저장
    function saveMenu(e) {
        $("#gridmenu").alopexGrid("endEdit");

        var updatedDataListRaw = $("#gridmenu").alopexGrid("dataGet", {_state:{edited:true}});
        var updatedDataList = AlopexGrid.trimData( updatedDataListRaw );
        var updatedDataCount = updatedDataList.length;
        if ( updatedDataCount<1 ) {
            var r = $.PSNM.alert("E011", ["변경된"], false); //alert("변경된 데이터가 없습니다."); return false;
            return r;
        }
        _debug("saveMenu", "갱신된 건수", updatedDataCount);

        for(var i=0; i<updatedDataCount; i++) {
            var menuData = updatedDataListRaw[i];
            _debug("saveMenu", "갱신된 메뉴레코드", JSON.stringify(menuData));
            var r = true;

            if ( $.PSNMUtils.isEmpty(menuData["MENU_ID"]) ) {
                r = $.PSNM.alert("E012", ["메뉴ID"], false); //메뉴ID 항목은 필수값입니다!
            }
            if ( menuData["MENU_ID"].length !=4 ) {
                r = $.PSNM.alert("E013", ["메뉴ID", "4"], false); //{0} 항목은 {1}자 이상 입력하세요!
            }
            if ( $.PSNMUtils.isEmpty(menuData["MENU_NM"]) ) {
                r = $.PSNM.alert("E012", ["메뉴명"], false);
            }
            if ( $.PSNMUtils.isEmpty(menuData["MENU_URL"]) ) {
                r = $.PSNM.alert("E012", ["메뉴URL"], false);
            }
            if ( $.PSNMUtils.isEmpty(menuData["BRWS_SEQ"]) ) {
                r = $.PSNM.alert("E012", ["순서"], false);
            }
            if ( $.PSNMUtils.isEmpty(menuData["USE_YN"]) ) {
                r = $.PSNM.alert("E012", ["사용여부"], false);
            }
            if (!r) {
                var oThatRow = {_index:{data:menuData._index.row}};
                $("#gridmenu").alopexGrid("dataScroll", menuData._index.row); //스크롤
                $("#gridmenu").alopexGrid("dataEdit", {_state:{selected:false}}, {_state:{selected:true}}); //체크 해제
                $("#gridmenu").alopexGrid("dataEdit", {_state:{selected:true}}, oThatRow); //해당 행 선택
                $("#gridmenu").alopexGrid("startEdit", oThatRow); //편집 시작
                return r;
            }
        }
        var updatedDataSet = $.PSNMUtils.getRequestDataUpdated("gridmenu"); //변경된 데이터만 파라미터로 전달

        $.alopex.request(_TX_SAVE, {
            data: updatedDataSet,
            success: function(res) {
                if ( ! $.PSNM.success(res) ) {
                    return;
                }
                $.PSNM.alert("I000"); //정상적으로 처리되었습니다.
                pSearchMenu();
            }
        });
    }

    function downloadExcel() {
        var oExcelMetaInfo = {
            filename  : "메뉴목록.xls",
            sheetname : "메뉴목록",
            gridname  : "gridmenu" //그리드ID 
        };
        $.PSNMUtils.downloadExcelAll("sform", _TX_SEARCH, "gridmenu", oExcelMetaInfo, [0,1,12,13]);
    }
    </script>

</head>

<body>

<jsp:include page="/view/layouts/default_header.jsp" flush="false" />

<!-- title area -->
<div id="contents">
    <div class="content_title">
        <div class="ub_txt6">
            <span class="txt6_img"><b id="sub-title">메뉴관리</b>
                <span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif">
                <span class="a2">본사업무</span> <span class="a3"> > </span> <span class="a4"><b>메뉴관리</b></span> 
            </span>
        </div>
    </div>

    <!-- 1줄 find condition area -->
    <div class="textAR">
      <form id="sform">
        <table class="board02" style="width:92%;">
       	<colgroup>
            <col style="width:15%"/>
            <col style="width:*"/>
        </colgroup>
        <tr>
            <th scope="col" >대메뉴</th>
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

    
    <div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>메뉴</b>
        <p class="ab_pos2">
            <!-- <button id="btnInit"      type="button" data-type="button" data-theme="af-psnm0" data-authtype="R" >초기화</button> -->
            <button id="btnAdd"       type="button" data-type="button" data-theme="af-btn2"  data-authtype="W" data-altname="추가"></button>
            <button id="btnDel"       type="button" data-type="button" data-theme="af-btn13" data-authtype="W" data-altname="삭제"></button>
            <button id="btnSave"      type="button" data-type="button" data-theme="af-btn4"  data-authtype="W" data-altname="저장"></button>
            <button id="btnExcelAll"  type="button" data-type="button" data-theme="af-btn3"  data-authtype="W" data-altname="엑셀다운"></button>
        </p>
    </div>

    <!-- main grid -->
    <div id="gridmenu" data-bind="grid:gridmenu" data-ui="ds"></div>

</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>
