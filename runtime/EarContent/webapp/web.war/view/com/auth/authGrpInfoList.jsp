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

    var _TX_SEARCH1       = "com.AUTH@PAUTHGRP_pSearchAuthGrp";         //권한그룹 조회
    var _TX_SEARCH2       = "com.AUTH@PAUTHINFO_pSearchAuthMenu";       //적용메뉴 조회
    var _TX_SEARCH3       = "com.AUTH@PAUTHINFO_pSearchAuthUser";       //적용사용자 조회

    $.alopex.page({

        init : function(id, param) { 
            _debug("authGrpInfoList", "init()", JSON.stringify(param));
            $.PSNM.initialize(id, param); //PSNM공통 초기화함수 호출(서브 페이지에서는 필수 호출)

            $a.page.setEventListener();
            $a.page.setGrid();
            $a.page.setGrid2();
            $a.page.setGrid3();
            $a.page.setCodeData();
            
            $("#HDQT_TEAM_ORG_ID").focus();
        },
        setEventListener : function() {
            $("#btnSearch").click( pSearchAuthGrp );
        },
        setGrid : function() {
            $("#gridauthgrp").alopexGrid({
                pager:false,
                height:250,
                rowSingleSelect: true,
                rowInlineEdit  : false,
                columnMapping : [
                    { columnIndex : 0, key : "AUTH_GRP_ID",     title : "권한그룹ID",   align : "center", width : "100px" },
                    { columnIndex : 1, key : "AUTH_GRP_NM",     title : "권한그룹명",   align : "left",   width : "160px" },
                    { columnIndex : 2, key : "AUTH_GRP_DESC",   title : "권한그룹설명", align : "left",   width : "160px" },
                    { columnIndex : 3, key : "USE_YN",          title : "사용여부",     align : "center", width : "50px",
                                        render : function(value, data) {
                                            return ( 'Y'==value ? '사용' : '미사용' );
                                        }
                    }
                ]
                ,
                on : {
                    'cell' : {
                        "click" : function(data, eh, e) {
                            pSearchAuthMenu(data);
                        }
                    }
                }
            });
        }, //end-of-setGrid
        setGrid2 : function() {
            $("#gridmenu").alopexGrid({
                pager:false,
                height : 250,
                rowSingleSelect: true,
                rowInlineEdit  : false,
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
                    { columnIndex : 3, key : "MENU_NM",     title : "메뉴명",   align : "left",   width : "150px" },
                    { columnIndex : 4, key : "USE_YN",      title : "사용여부", align : "center", width : "70px",
                                        render : function(value, data) {
                                            return ( 'Y'==value ? '사용' : '미사용' );
                                        }
                    }
                ]
                ,
                on : {
                    'cell' : {
                        "click" : function(data, eh, e) {
                            pSearchMenuAuth(data);
                        }
                    }
                }
            });
            
        }, //end-of-setGrid2
        setGrid3 : function() {
            $("#griduser").alopexGrid({
                //pager:false,
                pager: true,
                paging: {
                    perPage : 10,
                    pagerCount : 10
                },
                height : 430,
                rowSingleSelect: true,
                rowInlineEdit  : false,
                columnMapping : [
                    { columnIndex : 0, key : "USER_ID",          title : "사용자ID",     align : "center", width : "100px" },
                    { columnIndex : 1, key : "USER_NM",          title : "사용자명",     align : "center", width : "100px" },
                    { columnIndex : 2, key : "DUTY_NM",          title : "직무",         align : "center", width : "100px" },
                    { columnIndex : 3, key : "HDQT_TEAM_ORG_NM", title : "본사팀",       align : "center", width : "150px" },
                    { columnIndex : 4, key : "SALE_DEPT_ORG_NM", title : "영업국",       align : "center", width : "150px" },
                    { columnIndex : 5, key : "SALE_TEAM_ORG_NM", title : "영업팀",       align : "center", width : "150px" },
                    { columnIndex : 6, key : "SALE_AGNT_ORG_NM", title : "에이전트",     align : "center", width : "150px" }
                ]
                ,
                on : {
                    'cell' : {
                        "click" : function(data, eh, e) {
                            pSearchMenuAuth(data);
                        }
                    }
                    ,
                    pageSet : function(pageNoToGo) {
                        _debug("<annceList> <grid.on.perPageChange> 페이지번호 변경 : 변경할 페이지번호 = " + pageNoToGo);
                        var p = {};
                            p.page = pageNoToGo;
                        var param = JSON.parse($a.session('alopex_parameters'));
                        param.page = pageNoToGo;

                        $a.session('alopex_parameters', JSON.stringify(param));
                        pSearchAuthUser(param); //페이지 이동
                    }
                }
            });
            
        }, //end-of-setGrid3
        setCodeData : function() {
            $.PSNMUtils.setCodeData([
                //{ t:'code',  'elemid' : 'RCV_TYP_CD', 'codeid' : 'DSM_RCV_TYP_CD', 'header' : '-전체-' } //전체, 선택 등이 넣으려면 설정
                { t:'org1',  'elemid' : 'HDQT_TEAM_ORG_ID', 'codeid' : '', 'header' : '-선택-' } //[본사팀] 목록 조회
            ]);
        }
    });//end-of-$.alopex.page //-------------------------------------------------------------------------------------------------------//

    //권한그룹 조회
    function pSearchAuthGrp() {
        if ( ! $.PSNM.isValid("#sform") ) return false; //값 검증

        $("#gridmenu").alopexGrid("dataEmpty");
        $("#griduser").alopexGrid("dataEmpty");

        $.alopex.request(_TX_SEARCH1, {
            data: ["#sform", function() {
                //alert("<pSearchAuthGrp> <request.data> 파라미터 (this.data.dataSet.fields) : \n" + JSON.stringify(this.data.dataSet.fields)); //_debug
            }],
            success: ["#gridauthgrp", function(res) {
                $("#gridauthgrp").alopexGrid("dataEdit", {_state:{selected:true}}, {_index:{data:0}});
                var aAuthGrp = $("#gridauthgrp").alopexGrid("dataGet", {_index:{data:0}});
                _debug("<pSearchAuthGrp> <request.success> oAuthGrp : " + JSON.stringify(AlopexGrid.trimData(aAuthGrp[0])));
                pSearchAuthMenu( AlopexGrid.trimData(aAuthGrp[0]) ); //적용메뉴 조회
                //pSearchAuthUser(1);
            }]
        });
    } //end of pSearchAuthGrp()

    //적용메뉴 조회
    function pSearchAuthMenu(oAuthGrp) {
        if ( ! $.PSNM.isValid("#sform") ) return false; //값 검증

        $("#gridmenu").alopexGrid("dataEmpty");

        $.alopex.request(_TX_SEARCH2, {
            showProgress:false,
            data: [function() {
                this.data.dataSet.fields = oAuthGrp;
                //_debug("<pSearchAuthGrp> <request.data> 파라미터 (this.data.dataSet.fields) : " + JSON.stringify(this.data.dataSet.fields));
            }],
            success: ["#gridmenu", function(res) {
                pSearchAuthUser(1);
            }]
        });
    } //end of pSearchAuthGrp()

    //적용사용자 조회
    function pSearchAuthUser(param) {
        if ( ! $.PSNM.isValid("#sform") ) return false; //

        var aAuthGrp = $("#gridauthgrp").alopexGrid("dataGet", {_state:{selected:true}});
        if (null==aAuthGrp || aAuthGrp.length<1) {
            $.PSNM.alert("E011", ["선택된"]); //{0} 데이터가 없습니다! 
            return false;
        }
        var oAuthGrp = AlopexGrid.trimData(aAuthGrp[0]); //적용사용자 조회
        _debug("<pSearchAuthUser> oAuthGrp : " + JSON.stringify(oAuthGrp));

        $("#griduser").alopexGrid("dataEmpty");

        var _page_no = 1;
        if ( $.PSNMUtils.isNotEmpty(param) && $.PSNMUtils.isNotEmpty(param.page) ) {
            _page_no = param.page;
        }
        var _per_page = $('#griduser').alopexGrid('pageInfo').perPage;

        $.alopex.request(_TX_SEARCH3, {
            showProgress:false,
            data: ["#sform", function() {
                this.data.dataSet.fields.AUTH_GRP_ID = oAuthGrp.AUTH_GRP_ID;
                this.data.dataSet.fields.page      = _page_no;
                this.data.dataSet.fields.page_size = _per_page;
                //_debug("<pSearchAuthGrp> <request.data> 파라미터 (this.data.dataSet.fields) : " + JSON.stringify(this.data.dataSet.fields));
            }],
            success: ["#griduser", function(res) {
                //_debug("<pSearchAuthGrp> <request.success> 결과데이터 : " + JSON.stringify(res));
            }]
        });
    } //end of pSearchAuthUser()

    </script>

</head>

<body>

<jsp:include page="/view/layouts/default_header.jsp" flush="false" />

<!-- title area -->
<div id="contents">

    <div class="content_title">
        <div class="ub_txt6">
            <span class="txt6_img"><b id="sub-title">권한그룹조회</b>
                <span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif">
                <span class="a2">대메뉴명</span> <span class="a3"> > </span> <span class="a4"><b>중메뉴명</b></span> 
            </span>
        </div>
    </div>

    <!-- 1줄 find condition area -->
    <div class="textAR">
      <form id="sform">
        <table id="stable" class="board02" style="width:92%;">
       	<colgroup>
            <col style="width:15%"/>
            <col style="width:*"/>
        </colgroup>
        <tr>
            <th class="fontred">본사팀</th>
            <td class="tleft">
                <select id="HDQT_TEAM_ORG_ID" name="HDQT_TEAM_ORG_ID" data-bind="options:options_HDQT_TEAM_ORG_ID, selectedOptions:HDQT_TEAM_ORG_ID"  data-type="select" data-wrap="false"
                        data-validation-rule="{required:true}" 
                        data-validation-message="{required:$.PSNM.msg('E012', ['본사팀'])}">
                    <option value="">-선택-</option>
                </select>
            </td>
        </tr>
        </table>
      </form>
        <div class="ab_pos5">
            <button type="button" id="btnSearch" data-type="button" data-theme="af-psnm" data-authtype="W" data-altname="조회"></button>
        </div>
    </div>

    <div class="floatL4" style="clear: both; width: 100%;">
        <p class="ab_pos2">
            &nbsp;
        </p>
    </div>

    <div class="psnm-section">
        <div class="psnm-secleft">
            <div class="psnm-secleft-head">
                <span class="psnm-section-title"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>권한그룹</b></span>
                <span class="psnm-section-buttons">
                    &nbsp;
                </span>
            </div>
            <!-- 왼쪽 : 권한그룹 GRID -->
            <div id="gridauthgrp" data-bind="grid:gridauthgrp" data-ui="ds"></div>
            
        </div>
        <div class="psnm-secright">
            <div class="psnm-secright-head">
                <span class="psnm-section-title"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <span id="psnm-secright-title"> <b>적용 메뉴 목록</b></span></span>
                <span class="psnm-section-buttons">
                    &nbsp;
                </span>
            </div>
            <!-- 오른쪽 : 메뉴 GRID -->
            <div id="gridmenu" data-bind="grid:gridmenu" data-ui="ds"></div>
        </div>
    </div>

    <div class="floatL4" style="clear: both; width: 100%;"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>적용 사용자 목록</b>
        <p class="ab_pos2">
            &nbsp;
        </p>
    </div>

    <!-- 하단 : 사용자 GRID -->
    <div id="griduser" data-bind="grid:griduser" data-ui="ds"></div>

</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>
