<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>메뉴 찾기 - PS&Marketing</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />

    <script type="text/javascript">
    _LOG_LEVEL = 0; //로그레벨 :: 0=debug, 1=info, 2=error

    var _TX_SEARCH        = "com.MENU@PMENU001_pSearchMenuPop";
    var _TX_SEARCH_BY_SUP = "com.MENU@PMENU001_pSearchMenuBySup";

    var _initParam = null;
    var _popparam_usermenuauth = null;

    $a.page({
        init : function(id, param) { //
            _initParam = param;
            _popparam_usermenuauth = param["_popparam_usermenuauth"]
            _debug('<findMenuPop> $.alopex.page.init (param) : \n' + JSON.stringify(_popparam_usermenuauth));

            $a.page.setEventListener();
            $a.page.setGrid();
            $a.page.setValidators();
            $a.page.setCodeData();
            //$('#sform').setData(param);
        },
        setEventListener : function() {
            $("#btnSearch").click( pSearchMenu );
            $("#btnConfirm").click( closeConfirm );
            $("#btnCancel").click( closeWithout );
            //$("#iconCancel").click( closeWithout );
            $("#TOP_MENU_ID").change(function(e) {
                var menuId = $(this).val();
                if (""==menuId) {
                }
                else {
                    pSearchMenuByType(menuId, "SECOND_MENU_ID", "-전체-");
                }
            });
            $("#MENU_NM").keyup(function(e) {
                if (13==e.which) {
                    pSearchMenu(); //조회
                }
            });
            
        },
        setGrid : function() {
            $("#gridmenu").alopexGrid({
                pager:false,
                //rowSingleSelect: true,
                rowInlineEdit  : false,
                //height: 500,
                columnMapping : [
                    { columnIndex : 0, key : "MENU_TYP_CD", title : "선택",     width : "80px",
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
                    { columnIndex : 1, key : "MENU_TYP_NM", title : "메뉴유형", align : "center", width : "80px"  },
                    { columnIndex : 2, key : "MENU_ID",     title : "메뉴ID",   align : "center", width : "80px"  },
                    { columnIndex : 3, key : "MENU_NM",     title : "메뉴명",   align : "left",   width : "160px" },
                    { columnIndex : 4, key : "BRWS_SEQ",    title : "순서",     align : "center", width : "80px"  },
                    { columnIndex : 5, key : "USE_YN",      title : "사용여부", align : "center", width : "80px" , 
                                        render : function(value, data) {
                                            return ("Y"==value ? "사용" : "미사용");
                                        }
                    }
                ]
                ,
                on : {
                    'cell' : {
                        "click" : function(data, eh, e) {
                            onSelectMenu(data);
                        }
                    }
                }
            });
        },
        setCodeData : function() {
            pSearchMenuByType("0000", "TOP_MENU_ID",  "-선택-");
            //$.alopex.request(_TX_SEARCH_BY_SUP, {
            //    showProgress:false,
            //    async:false, //공통코드 조회는 sync로 조회함
            //    data: {
            //        dataSet: {}
            //    },
            //    success: function(res) {
            //        var menuList = res.dataSet.recordSets["menubysup"].nc_list;
            //
            //        var codeOptions = [];
            //            codeOptions.push({ value: "", text: "-선택-"});
            //
            //        $.each(menuList, function (index, codeinfo) {
            //            var codeOpt = new Object();
            //                codeOpt["value"] = codeinfo.MENU_ID;
            //                codeOpt["text"]  = codeinfo.MENU_NM;
            //            codeOptions.push(codeOpt);
            //        });
            //        var optData = new Object();
            //            optData["options_TOP_MENU_ID"] = codeOptions;
            //
            //        $("#TOP_MENU_ID").setData(optData);
            //    }
            //});
        }
        ,
        setValidators : function() {
            $('#TOP_MENU_ID').validator({
                rule : { required: true },
                message: {
                    required: $.PSNM.msg('E012', ["대메뉴"]) //{0} 항목은 필수값입니다!
                }
            });
        }
    });//end-of-$.alopex.page //-------------------------------------------------------------------------------------------------------//

    function pSearchMenuByType(sSupMenuId, sElemId, sHeaderTxt) {
        var reqData = new Object();
        
        if ( $.PSNMUtils.isNotEmpty(sSupMenuId) ) {
            reqData["SUP_MENU_ID"] = sSupMenuId;
        }
    
            $.alopex.request(_TX_SEARCH_BY_SUP, {
                showProgress:false,
                async:false, //공통코드 조회는 sync로 조회함
                data: {
                    dataSet: {
                        fields : reqData
                    }
                },
                success: function(res) {
                    var menuList = res.dataSet.recordSets["menubysup"].nc_list;

                    var codeOptions = [];
                    if ( $.PSNMUtils.isNotEmpty(sHeaderTxt) ) {
                        codeOptions.push({ value: "", text: sHeaderTxt});
                    }

                    $.each(menuList, function (index, codeinfo) {
                        var codeOpt = new Object();
                            codeOpt["value"] = codeinfo.MENU_ID;
                            codeOpt["text"]  = codeinfo.MENU_NM;
                        codeOptions.push(codeOpt);
                    });
                    var optData = new Object();
                        optData["options_" + sElemId] = codeOptions;

                    $("#" + sElemId).setData(optData);
                }
            });
    }

    //조회
    function pSearchMenu() {
        if ( ! $.PSNM.isValid('#sform') ) {
            return false;
        }

        $("#gridmenu").alopexGrid("dataEmpty");

        $.alopex.request(_TX_SEARCH, {
            data: ['#sform', function() {
                //_debug("<pSearchMenu> <request.data> 파라미터 (this.data.dataSet.fields) : " + JSON.stringify(this.data.dataSet.fields));
            }],
            success: ['#gridmenu', function(res) {
                //_debug("<pSearchMenu> <request.success> 결과데이터 : " + JSON.stringify(res));
            }]
        });
    }

    //메뉴선택시 체크
    function onSelectMenu(oMenu) {
        for(var i=0, len=_popparam_usermenuauth.length; i<len; i++) {
            var oMenuSelected = _popparam_usermenuauth[i];
            if ( oMenu["MENU_ID"] == oMenuSelected["MENU_ID"] ) {
                $.PSNM.alert("PSNM-E019", ["선택된", "추가"]); //"PSNM-E019", "MESSAGE_NAME":"{0} 데이터가 있습니다. {1} 할 수 없습니다!"
                var rowIdx = oMenu._index.data;
                $("#gridmenu").alopexGrid("dataEdit", {_state:{selected:false}}, {_index:{data:rowIdx}});
                break;
            }
        }
    }

    //현재창을 닫고 객체를 반환
    function closeWith(oData) {
        $a.close(oData);
    }

    function closeWithout() {
        $a.close([]);
    }

    function closeConfirm() {
        var arrMenu = $("#gridmenu").alopexGrid("dataGet", { _state : {selected:true} });
        if (arrMenu.length<1) {
            $.PSNM.alert("메뉴를 선택하십시오!");
            return;
        }
        arrMenu = AlopexGrid.trimData(arrMenu); //데이터 트림

        for(var i=0, len=arrMenu.length; i<len; i++) {
            arrMenu[i]["ADD_EXL_CL"] = "A"; //추가
            arrMenu[i]["R_AUTH"] = "1"; //읽기권한
            arrMenu[i]["W_AUTH"] = "0";
        }
        $a.close(arrMenu);
    }
    </script>
</head>

<body style="height: 100%;">

<div id="Wrap">

    <!-- title area -->
    <div class="pop_header">
        <div class="psnm-find-area" style="height:65px;">
            <div class="psnm-find-condarea">
                <form id="searchForm" onsubmit="return false;">
                <table class="board02" id="sform">
	        	<colgroup>
		            <col style="width:15%"/>
		            <col style="width:35%"/>
		            <col style="width:15%"/>
		            <col style="width:*"/>
	            </colgroup>
                <tr>
                    <th scope="col" class="psnm-required" style="width:100px;">대메뉴</th>
                    <td class="tleft">
                        <select id="TOP_MENU_ID" name="TOP_MENU_ID" data-bind="options:options_TOP_MENU_ID, selectedOptions:TOP_MENU_ID" data-type="select" data-wrap="false" style="width:150px;">
                            <option value="">-선택-</option>
                        </select>
                    </td>
                    <th style="width:100px;">중메뉴</th>
                    <td class="tleft">
                        <select id="SECOND_MENU_ID" name="SECOND_MENU_ID" data-bind="options:options_SECOND_MENU_ID, selectedOptions:SECOND_MENU_ID" data-type="select" data-wrap="false" style="width:150px;">
                            <option value="">-전체-</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th>메뉴명</th>
                    <td colspan="3" class="tleft">
                        <input id="MENU_NM" name="MENU_NM" data-type="textinput" data-bind="value:MENU_NM" style="width:150px;" maxlength="15">
                    </td>
                </tr>
                </table>
                </form>
            </div>
            <div class="psnm-find-btnarea">
                <input id="btnSearch" type="button" value="" data-type="button" data-theme="af-psnm">
            </div>
        </div>

        <!-- view_table area 1 -->
        <div class="textAR" style="min-height:200px;">
            <div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>메뉴 목록</b>
                <p class="ab_pos2">
                    <!-- <button id="btnInit" data-type="button" data-theme="af-psnm0">초기화</button> -->
                </p>
            </div>

            <!-- main grid 1 -->
            <div id="gridmenu" data-bind="grid:gridmenu" data-ui="ds"></div>
        </div>

        <!-- view_table area -->
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