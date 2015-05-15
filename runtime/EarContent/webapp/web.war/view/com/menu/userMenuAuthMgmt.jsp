<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

    <jsp:include page="/view/layouts/default_head.jsp" flush="false" />

    <script type="text/javascript">
    var _TX_SEARCH_USER     = "com.USERMGMT@PUSERMGMT001_pSearchUser";
    var _TX_SEARCH          = "com.MENU@PUSERMENUAUTH001_pSearchUserMenuAuth";
    var _TX_SAVE            = "com.MENU@PUSERMENUAUTH001_pSaveUserMenuAuth";

    var _ADD_EXL_CL_DATA = [];
        _ADD_EXL_CL_DATA.push({"text":"추가","value":"A"});
        _ADD_EXL_CL_DATA.push({"text":"제외","value":"E"});

    $.alopex.page({

        init : function(id, param) {
            $.PSNM.initialize(id, param); //PSNM공통 초기화함수 호출

            $a.page.setEventListener();
            $a.page.setGrid();
            $a.page.setGrid2();
            $a.page.setGrid3();
            $a.page.setCodeData();
            $a.page.setValidators();
            //$("#searchTable").setData(param);

            if( $.PSNMUtils.isNotEmpty($("#HDQT_TEAM_ORG_ID").val()) ){
                pSearchUser(param);
            }
        },
        setEventListener : function() {
            $("#btnSearch").click( pSearchUser );
            $("#btnAddMenu").click( addMenu );
            $("#btnDelMenu").click( delMenu );
            $("#btnSave").click( pSaveUserMenuAuth );
            $("#btnExcelAll").click( downloadExcel );
            $("#AGNT_NM").keyup(function(e) {
                if (13==e.which) {
                    pSearchUser();
                }
            });
        },
        setGrid : function() {
            $("#gridUser").alopexGrid({
                rowClickSelect : true,
                rowSingleSelect : true,
                rowInlineEdit : false,
                height : 260,
                columnMapping : [
                    { columnIndex :  0, key : "USER_ID",           title : "회원ID",         align : "center", width : "100px" },
                    { columnIndex :  1, key : "USER_NM",           title : "회원명",         align : "center", width : "50px"  },
                    { columnIndex :  2, key : "DUTY_NM",           title : "직무",           align : "center", width : "100px" },
                    { columnIndex :  3, key : "HDQT_PART_ORG_NM",  title : "본사파트",       align : "center", width : "100px" },
                    { columnIndex :  4, key : "SALE_DEPT_ORG_NM",  title : "영업국명",       align : "center", width : "80px"  },
                    { columnIndex :  5, key : "SALE_AGNT_ORG_ID",  title : "에이전트 코드",  align : "center", width : "100px" },
                    { columnIndex :  6, key : "SALE_AGNT_ORG_NM",  title : "에이전트명",     align : "center", width : "80px",
                                        render : function ( value , data, mapping ) {
                                            return $.PSNMUtils.getMaskedName(value);
                                        }
                    },
                    { columnIndex :  7, key : "RGST_DTM",          hidden: true                                                },
                    { columnIndex :  8, key : "SALE_OCCR_DT",      hidden: true                                                },
                    { columnIndex :  9, key : "SCRB_ST_NM",        hidden: true                                                },
                    { columnIndex : 10, key : "DAYS",              hidden: true                                                },
                    { columnIndex : 11, key : "DUTY_CD",           hidden: true                                                },
                    { columnIndex : 12, key : "SCRB_ST_CD",        hidden: true                                                },
                    { columnIndex : 13, key : "ATTC_CAT",          hidden: true                                                }
                ],
                on : {
                    pageSet : function(pageNoToGo) {
                        var p = {};
                            p.page = pageNoToGo;
                            pSearchUser(p);
                    },
                    "cell" : {
                        "click" : function(data, eh, e) { //dblclick
                            pSearchUserMenuAuth(data);
                        }
                    }
                }
            });
        },
        setGrid2 : function() {
            $("#gridusermenu").alopexGrid({
                pager:false,
                rowSingleSelect: true,
                height : 600,
                columnMapping : [
                    { columnIndex : 0, key : "MENU_TYP_CD", title : "구분",     width : "70px",
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
                    { columnIndex : 1, key : "MENU_TYP_NM", title : "메뉴유형", align : "center", width : "70px"  },
                    { columnIndex : 2, key : "MENU_ID",     title : "메뉴ID",   align : "center", width : "70px"  },
                    { columnIndex : 3, key : "MENU_NM",     title : "메뉴명",   align : "left",   width : "140px" },
                    { columnIndex : 4, key : "BRWS_SEQ",    title : "순서",     align : "center", width : "50px"  },
                    { columnIndex : 5, key : "R_AUTH",      title : "읽기",     align : "center", width : "50px",
                                        render : { type : "check", rule: [{value:"1",check:true},{value:"0",check:false}] }
                    },
                    { columnIndex : 6, key : "W_AUTH",      title : "쓰기",     align : "center", width : "50px",
                                        render : { type : "check", rule: [{value:"1",check:true},{value:"0",check:false}] }
                    },
                    { columnIndex : 7, key : "AUTH_TYP_CD", title : "권한구분", align : "center", width : "80px", hidden: true  }
                ]
            });
        },
        setGrid3 : function() {
            $("#gridusermenuauth").alopexGrid({
                pager:false,
                rowClickSelect : false,
                rowInlineEdit : false,
                height : 600,
                columnMapping : [
                    { columnIndex : 0, key : "FLAG",        title : "F",           align : "center", width : "30px",   refreshBy:true, 
                                        //refreshBy:true, 
                                        refreshBy: function(previousData, changedData){
                                            if(previousData['ADD_EXL_CL'] !== changedData['ADD_EXL_CL'])
                                                return true;
                                            else
                                                return false;
                                        }, 
                                        render: function(value, data, mapping){
                                            if(data._state.editing && data._state.focused){
                                                return 'U';
                                            }else{
                                                return value;
                                            }
                                        },
                                        value : function(value, data) {
                                            if (data._state.added) return 'I';
                                            if (data._state.deleted) return 'D';
                                            if (data._state.edited) return 'U';
                                            return ''; 
                                        }
                    },
                    { columnIndex : 1, selectorColumn : true, width : "30px" },
                    { columnIndex : 2, key : "MENU_TYP_NM", title : "메뉴유형", align : "center", width : "80px"  },
                    { columnIndex : 3, key : "MENU_ID",     title : "메뉴ID",   align : "center", width : "70px"  },
                    { columnIndex : 4, key : "MENU_NM",     title : "메뉴명",   align : "left",   width : "120px" },
                    { columnIndex : 5, key : "ADD_EXL_CL",  title : "추가제외", align : "center", width : "80px",
                                        //render : function(value, data) {
                                        //    return ("A"==value ? "추가" : ("E"==value ? "제외" : ""));
                                        //},
                                        render   : { type : "select",  rule : function(value, data) { return _ADD_EXL_CL_DATA; } },
                                        editable : { type : "select",  rule : function(value, data) { return _ADD_EXL_CL_DATA; } } 
                    },
                    { columnIndex : 6, key : "R_AUTH",      title : "읽기",     align : "center", width : "50px",
                                        render   : { type : "check", rule: [{value:"1",check:true},{value:"0",check:false}] },
                                        editable : { type : "check", rule: [{value:"1",check:true},{value:"0",check:false}] }
                    },
                    { columnIndex : 7, key : "W_AUTH",      title : "쓰기",     align : "center", width : "50px",
                                        render   : { type : "check", rule: [{value:"1",check:true},{value:"0",check:false}] },
                                        editable : { type : "check", rule: [{value:"1",check:true},{value:"0",check:false}] }
                    },
                    { columnIndex : 8, key : "USER_ID",     title : "USER_ID",  hidden:true }
                ]
                ,
                on : {
                    'cell' : {
                        "click" : function(data, eh, e) {
                            //$('#gridusermenuauth').alopexGrid('endEdit', {_index:{"data":data._index.data}}, true);
                            $("#gridusermenuauth table.table tr").removeClass("editing");
                        }
                    }
                    ,
                    data : {
                        "edit" : function(data, query) {
                            _debug("grid.on.data.edit", "data", JSON.stringify(data), "query", JSON.stringify(query));
                        }
                        ,
                        "changed" : function(type) {
                            _debug("grid.on.data.changed", "type", type);
                            //checkAllByData();
                        }
                    }
                }
            });
        },
        setCodeData : function() {
            //$.PSNMUtils.setCodeData([
            //    { t:'duty',  'elemid' : 'DUTY_CD', 'codeid' : '', 'header' : '-전체-' }
            //]);
        },
        setValidators : function() {
            $('#HDQT_TEAM_ORG_ID').validator({
                rule : { required: true },
                message: {
                    required: $.PSNM.msg('E012', ["본사팀"]) //{0} 항목은 필수값입니다!
                }
            });
           //$('#SALE_DEPT_ORG_ID').validator({
           //    rule : { required: true },
           //    message: {
           //        required: $.PSNM.msg('E012', ["영업국"]) //{0} 항목은 필수값입니다!
           //    }
           //});
        }
    });

    function pSearchUser(param) {
        if ( !$.PSNM.isValid("#searchTable") ) {
            return;
        }

        var _page_no = 1;
        if ( $.PSNMUtils.isNotEmpty(param) && $.PSNMUtils.isNotEmpty(param.page) ) {
            _page_no = param.page;
        }
        var _per_page = $("#gridUser").alopexGrid("pageInfo").perPage;

        $("#gridusermenu").alopexGrid("dataEmpty");
        $("#gridusermenuauth").alopexGrid("dataEmpty");

        $("#btnAddMenu").hide();
        $("#btnDelMenu").hide();
        $("#USER_ID").val("");
        $("#USER_NM").text("사용자별");        

        $.alopex.request(_TX_SEARCH_USER, {
            data: ["#searchTable", function() {
                this.data.dataSet.fields.page      = _page_no;
                this.data.dataSet.fields.page_size = _per_page;
            }],
            success: ["#gridUser", function(res) {
            }]
        });
    }

    function pSearchUserMenuAuth(param) {
        $("#gridusermenu").alopexGrid("dataEmpty");
        $("#gridusermenuauth").alopexGrid("dataEmpty");

        $("#btnAddMenu").show();
        $("#btnDelMenu").show();
        $("#USER_ID").val( param["USER_ID"] );
        $("#USER_NM").text("사용자 [" + param["USER_NM"] + "] ");

        $.alopex.request(_TX_SEARCH, {
            showProgress: false,
            data: function() {
                this.data.dataSet.fields = AlopexGrid.trimData( param );
            },
            success: ["#gridusermenu", "#gridusermenuauth", function(res) {
                setEditing();
            }]
        });
    }

    function setEditing() {
        $("#gridusermenuauth").alopexGrid("startEdit"); //그리드 편집모드로 변경
        //아래는 강제로 해보려구.... 테스트중인것
        //var datalist = $("#gridusermenuauth").alopexGrid("dataGet");;
        //for(var i=0; i<datalist.length; i++) {
        //    //datalist[i]._state = {editing:true};
        //    $("#gridusermenuauth").alopexGrid("dataEdit", {_state:{editing:true}}, {_index:{data:i}});
        //}
        $("#gridusermenuauth table.table tr").removeClass("editing"); 
    }

    function addMenu() {
        var popparam = {};
            popparam["_popparam_usermenuauth"] = AlopexGrid.trimData( $("#gridusermenuauth").alopexGrid('dataGet') );

        $a.popup({
            url: "com/menu/findMenuPop"
          , data: popparam
          , width: $.PSNM.popWidth(800)
          , height: $.PSNM.popHeight(550)
          , title: "메뉴찾기"
          , callback: function(data) {
                _debug( "선택된 메뉴\n\n" + JSON.stringify(data) );
                $("#gridusermenuauth").alopexGrid('dataAdd', data);
                setEditing();
          }
        });
    }

    function delMenu() {
        var arrAuthGrp = $("#gridusermenuauth").alopexGrid('dataGet', {_state:{selected:true}});
        if ( null==arrAuthGrp || arrAuthGrp.length<1 ) {
            $.PSNM.alert("E011", ["선택된"]);
            return false;
        }
        if ( ! $.PSNM.confirm("I004", ["삭제"]) ) {
            return false;
        }
        $("#gridusermenuauth").alopexGrid("dataDelete", {_state:{selected:true}, "FLAG":"I"}); //추가된 데이터는 화면에서 삭제
        $("#gridusermenuauth").alopexGrid("dataEdit", {_state:{deleted:true}}, {_state:{selected:true}});
        $("#gridusermenuauth").alopexGrid("dataEdit", {_state:{selected:false}}, {_state:{selected:true}});
        $("#gridusermenuauth table.table tr").removeClass("editing");
        $("#gridusermenuauth table.table tr").removeClass("deleted");
    }

    function pSaveUserMenuAuth() {
        var userId = $("#USER_ID").val();

        if ( $.PSNMUtils.isEmpty(userId) ) {
            $.PSNM.alert("E011", ["선택된"]); //E011", "MESSAGE_NAME":"{0} 데이터가 없습니다!"  
            return false;
        }

        $("#gridusermenuauth").alopexGrid("endEdit", {_state:{editing:true}}, true);
        $("#gridusermenuauth table.table tr").removeClass("editing");

        var updatedDataList = $.PSNMUtils.getUpdatedGridArrData("gridusermenuauth", true); //그리드에서 수정된 데이터(트림) 
        var updatedDataCount = updatedDataList.length;
        if ( updatedDataCount<1 ) {
            var r = $.PSNM.alert("E011", ["변경된"], false); //alert("변경된 데이터가 없습니다."); return false;
            return r;
        }
        _debug("pSaveUserMenuAuth", "갱신된 건수", updatedDataCount);

        for(var i=0; i<updatedDataCount; i++) {
            var menuData = updatedDataList[i];
            _debug("pSaveUserMenuAuth", "갱신된 레코드", JSON.stringify(menuData));

            if ( $.PSNMUtils.isEmpty(menuData["ADD_EXL_CL"]) ) {
                r = $.PSNM.alert("E012", ["추가제외"], false); //메뉴ID 항목은 필수값입니다!
                return false;
            }
            if ( "A"==menuData["ADD_EXL_CL"] ) {
                if ( $.PSNMUtils.isEmpty(menuData["R_AUTH"]) || "0"==menuData["R_AUTH"] ) {
                    $.PSNM.alert("읽기 권한을 체크하십시오.");
                    return false;
                }
            }
        }
        var updatedDataSet = $.PSNMUtils.getRequestDataUpdated("gridusermenuauth"); //변경된 데이터만 파라미터로 전달
            updatedDataSet.dataSet.fields["USER_ID"] = userId;

        $.alopex.request(_TX_SAVE, {
            data: updatedDataSet,
            success: function(res) {
                if ( ! $.PSNM.success(res) ) {
                    return;
                }
                $.PSNM.alert("I000"); //정상적으로 처리되었습니다.

                var params = $("#gridUser").alopexGrid('dataGet', {_state:{selected:true}})
                pSearchUserMenuAuth(params[0]);
            }
        });
    }
    
    function downloadExcel() {
        var userId = $("#USER_ID").val();

        if ( $.PSNMUtils.isEmpty(userId) ) {
            $.PSNM.alert("사용자를 선택한후 다운로드하십시오.");
            return false;
        }

        var oExcelMetaInfo = {
                filename  : "회원메뉴정보.xls",
                sheetname : "회원메뉴정보",
                gridname  : "gridusermenu" 
            };
        $.PSNMUtils.downloadExcelAll("searchForm", _TX_SEARCH, "gridusermenu", oExcelMetaInfo, [0,5,6]);
    }

    </script>

</head>

<body>

<jsp:include page="/view/layouts/default_header.jsp" flush="false" />

<!-- contents area -->
<div id="contents">

    <!-- sub title area -->
    <div class="content_title">
        <div id="ub_txt6">
            <span class="txt6_img"><b id="sub-title">사용자별권한관리</b>
                <span class="notice-more"> 
                    <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif">
                    <span class="a2">본사업무</span> <span class="a3"> > </span> <span class="a4"><b>마스터관리</b></span> 
                </span>
            </span>
        </div>
    </div>

    <!-- find condition area -->
    <div id="searchDiv" class="textAR">
        <form id="searchForm" onsubmit="return false;">
            <input id="USER_ID" name="USER_ID" type="hidden" data-type="hidden" value="" />
            <table id="searchTable" class="board02" style="width:92%;">
        	<colgroup>
	            <col style="width:12%"/>
	            <col style="width:21%"/>
	            <col style="width:12%"/>
	            <col style="width:21%"/>
	            <col style="width:12%"/>
	            <col style="width:*"/>
            </colgroup>
            <tr>
                <th class="tleft psnm-required">본사팀</th>
                <td class="tleft">
                    <select id="HDQT_TEAM_ORG_ID" data-bind="options:options_HDQT_TEAM_ORG_ID, selectedOptions: HDQT_TEAM_ORG_ID" data-type="select" style="width:150px"
                            data-validation-rule="{required:true}" 
                            data-validation-message="{required:$.PSNM.msg('E012', ['본사팀'])}">
                        <option value="">-전체-</option>
                    </select>
                </td>
                <th>본사파트</th>
                <td class="tleft">
                    <select id="HDQT_PART_ORG_ID" data-bind="options:options_HDQT_PART_ORG_ID, selectedOptions: HDQT_PART_ORG_ID" data-type="select" style="width:150px">
                        <option value="">-전체-</option>
                    </select>
                </td>
                <th>영업국명</th>
                <td class="tleft">
                    <select id="SALE_DEPT_ORG_ID" data-bind="options:options_SALE_DEPT_ORG_ID, selectedOptions: SALE_DEPT_ORG_ID" data-type="select" style="width:150px">
                        <option value="">-전체-</option>
                    </select>
                </td>                
            </tr>
            <tr>
                <th>영업팀명</th>
                <td class="tleft">
                    <select id="SALE_TEAM_ORG_ID" data-bind="options:options_SALE_TEAM_ORG_ID, selectedOptions: SALE_TEAM_ORG_ID" data-type="select" style="width:150px">
                        <option value="">-전체-</option>
                    </select>
                </td>
                <th>에이전트명</th>
                <td colspan="3" class="tleft">
                    <input id="AGNT_NM" data-bind="value:AGNT_NM" data-type="textinput" style="width:150px">
                    <input id="SCRB_ST_CD" name="SCRB_ST_CD" type="hidden" value="02" /><!-- 가입승인 상태의 사용자-->
                </td>
            </tr>
            </table>
            <div class="ab_pos4">
                <button id="btnSearch" type="button" data-type="button" data-theme="af-psnm" data-authtype="R"></button>
            </div>
        </form>
    </div>

    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b> 회원목록</b>
        <p class="ab_pos2">
            <button id="btnSave"     type="button" data-type="button" data-theme="af-btn4"    data-authtype="W" data-altname="저장"></button>
            <button id="btnExcelAll" type="button" data-type="button" data-theme="af-n-btn27" data-authtype="W" data-altname="상세다운"></button>
        </p>
    </div>

    <!-- main grid -->
    <div id="gridUser" data-bind="grid:gridUser"></div>

    <div class="psnm-section">
        <div class="psnm-secleft">
            <div class="floatL4" style="clear:both;"> <img src="/image/blat_a7.gif"> <b><span id="USER_NM">사용자별</span> 권한별 메뉴 목록</b>
                <p class="ab_pos1">
                    &nbsp; <!-- 왼쪽 버튼 -->
                </p>
            </div>
            <!-- 왼쪽 그리드1 -->
            <div id="gridusermenu" data-bind="grid:gridusermenu" data-ui="ds"></div>
        </div>
        <div class="psnm-seccenter">
            <!-- 좌우 -->
            &nbsp;
            <!--
            <a href="#"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/icon_right.png"></a><br><br>
            <a href="#"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/icon_left.png"></a>
            -->
            <!-- //좌우 -->
        </div>
        <div class="psnm-secright">
            <div class="floatL4" style="clear:both;"> <img src="/image/blat_a7.gif"> <b>추가/제외 메뉴</b>
                <p class="ab_pos1">
                    <input id="btnAddMenu" type="button" data-type="button" class="psnm-sbtn-add" />
                    <input id="btnDelMenu" type="button" data-type="button" class="psnm-sbtn-del" />
                </p>
            </div>
            <!-- 오른쪽 그리드2 -->
            <div id="gridusermenuauth" data-bind="grid:gridusermenuauth" data-ui="ds"></div>
        </div>
    </div>
</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>