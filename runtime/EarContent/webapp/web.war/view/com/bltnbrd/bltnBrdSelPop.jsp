<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>게시판 찾기 - PS&amp;Marketing</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />

    <script type="text/javascript">
    var _initParam = null;

    var _TX_SEARCH_BY_TYP = "com.BLTNBRD@PBLTNBRDMGMT001_pSearchBltnBrdByType";
    var _TX_SEARCH        = "com.BLTNBRD@PBLTNBRDMGMT001_pSearchBltnBrd";

    $a.page({
        init : function(id, param) { //
            _initParam = param;
            _debug('<bltnBrdSelPop> $.alopex.page.init (param) : \n###### ' + JSON.stringify(param));

            $a.page.setCodeData();
            $a.page.setEventListener();
            $a.page.setGrid();

            $("#TOP_BLTN_BRD_ID").focus();
        },
        setEventListener : function() {
            $("#btnSearch").click( pSearchBltnBrd );
        },
        setGrid : function() {
            $("#gridbltnbrd").alopexGrid({
                pager:false,
                rowSingleSelect: true,
                height: 400,
                //rowInlineEdit  : true, //더블클릭을 이용하여 행을 편집모드로 바꿀 수 있도록 해주는 옵션.
                columnMapping : [
                    { columnIndex : 0, key : "BLTN_BRD_TYP_CD", title : "선택",     width : "80px",
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
                    { columnIndex : 1, key : "BLTN_BRD_TYP_NM", title : "게시판유형",       align : "center", width : "90px"  },
                    { columnIndex : 2, key : "BLTN_BRD_ID",     title : "게시판ID",         align : "center", width : "70px"  },
                    { columnIndex : 3, key : "BLTN_BRD_NM",     title : "게시판명",         align : "left",   width : "150px" }
                ]
                ,
                on : {
                    'cell' : {
                        "dblclick" : function(data, eh, e) {
                            closeWith( AlopexGrid.trimData(data) );
                        }
                    }
                }
            });

        },
        setCodeData : function() {
            $.alopex.request(_TX_SEARCH_BY_TYP, {
                showProgress:false,
                async:false, //공통코드 조회는 sync로 조회함
                data: {
                    dataSet: { fields : { "BLTN_BRD_TYP_CD" : "1" } } //대그룹 게시판유형 목록
                },
                success: function(res) {
                    var bltnBrdMgmtList = res.dataSet.recordSets["gridbltnbrdtype"].nc_list;

                    var codeOptions = [];
                        codeOptions.push({ value: "", text: "-선택-"});

                    $.each(bltnBrdMgmtList, function (index, codeinfo) {
                        var codeOpt = new Object();
                            codeOpt["value"] = codeinfo.BLTN_BRD_ID;
                            codeOpt["text"]  = codeinfo.BLTN_BRD_NM;
                        codeOptions.push(codeOpt);
                    });
                    var optData = new Object();
                        optData["options_TOP_BLTN_BRD_ID"] = codeOptions;

                    $("#TOP_BLTN_BRD_ID").setData(optData);
                }
            });
        }
        ,
        setValidators : function() {
            //
        }
    });

    //조회
    function pSearchBltnBrd() {
        if ( !$.PSNM.isValid('#sform') ) {
            return false;
        }

        $.alopex.request(_TX_SEARCH, {
            data: ['#sform', function() {
                //
            }],
            success: ['#gridbltnbrd', function(res) {
                //_debug("<pSearchBltnBrd> <request.success> 결과데이터 : " + JSON.stringify(res));
            }]
        });
    }

    //반환
    function closeWith(oData) {
        if ( null!=oData ) {
            if ( "3"!=oData["BLTN_BRD_TYP_CD"] ) {
                alert("그룹유형이 아닌 게시판을 선택하십시오!");
                return;
            }
        }
        $a.close(oData);
    }

    function closeWithout() {
        $a.close([]);
    }

    function closeConfirm() {
        var arr = $("#gridbltnbrd").alopexGrid("dataGet", { _state : { selected : true } } ); //선택된 데이터

        if (arr.length<1) {
            alert("게시판을 선택하십시오!");
            return;
        }
        closeWith( AlopexGrid.trimData(arr[0]) );
    }
    </script>
</head>

<body style="height: 100%;">

<div id="Wrap">

    <!-- title area -->
    <div class="pop_header">
        <div class="psnm-find-area" style="height:35px;">
            <div class="psnm-find-condarea" style="width:85%;">
                <form id="sform" onsubmit="return false;">
                <table class="board02" id="sform">
                <colgroup>
                    <col style="width:20%">
                    <col style="width:*">
                </colgroup>
                <tr>
                    <th scope="col" class="psnm-required" style="width:100px;">대그룹</th>
                    <td class="tleft">
                    <select id="TOP_BLTN_BRD_ID" name="TOP_BLTN_BRD_ID" data-bind="options:options_TOP_BLTN_BRD_ID, selectedOptions:TOP_BLTN_BRD_ID" data-type="select" 
                            data-validation-rule="{required:true}" 
                            data-validation-message="{required:$.PSNM.msg('E012', ['대그룹'])}">
                        <option value="">-선택-</option>
                    </select>
                    </td>
                </tr>
                </table>
                </form>
            </div>
            <div class="psnm-find-btnarea" style="width:15%;">
                <input id="btnSearch" type="button" value="" data-type="button" data-theme="af-psnm">
            </div>
        </div>

        <!-- view_table area 1 -->
        <div class="textAR" style="min-height:200px;">
            <div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>게시판 목록</b>
                <p class="ab_pos2">
                    <!-- <button id="btnInit" data-type="button" data-theme="af-psnm0">초기화</button> -->
                </p>
            </div>

            <!-- main grid 1 -->
            <div id="gridbltnbrd" data-bind="grid:gridbltnbrd" data-ui="ds"></div>
        </div>

        <!-- view_table area -->
        <!-- 
        <div class="textAR" style="min-height:30px;">
            <p class="floatL2">
                <input id="btnConfirm" type="button" value="" data-type="button" data-theme="af-btn8">
                <input id="btnCancel"  type="button" value="" data-type="button" data-theme="af-btn10">
            </p>
        </div>
        -->
    </div>

</div>

</body>
</html>