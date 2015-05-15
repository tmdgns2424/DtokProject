<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="nexcore.framework.core.Constants"%>
<%@ page import="nexcore.framework.core.code.ICode"%>
<%@ page import="nexcore.framework.core.data.user.IUserInfo"%>
<%@ page import="nexcore.framework.core.util.BaseUtils"%>
<%@ page import="nexcore.framework.online.channel.util.WebUtils"%>
<%
    IUserInfo userInfo = WebUtils.getSessionUserInfo(request);
    if (userInfo != null) {
        System.out.println("<mainAnncePop.jsp> USER_ID : " + userInfo.getLoginId());
    }
%>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>공지사항 - PS&Marketing</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />

    <script type="text/javascript">

    var _TX_SEARCH     = "com.MAINLOGIN@PMAIN001_pSearchAnncePopList";
    var _TX_SEARCH_1   = "com.MAINLOGIN@PMAIN001_pSearchAnnce";
    var _TX_SAVE_CHK   = "com.MAINLOGIN@PMAIN001_pSearchAnnce";

    var _initParam = null;

    $.alopex.page({
        init : function(id, param) {
            _initParam = param;
            $.PSNMPop.popinit(id, param); //팝업화면 초기화 공통처리
            $a.page.setEventListener();
            $a.page.setGrid();
            $a.page.setValidators();

            pSearchAnncePopList(param); //조회
        },
        setEventListener : function() {
            //$("#btnConfirm").click( pSaveAnnceMndtChk );
            $("#btnClose").click( closeWith );
        },
        setGrid : function() {
            $.PSNMUtils.setFileGrid("gridfile", true); //첨부파일 그리드 초기화

            $("#gridanncepop").alopexGrid({
                pager : false,
                rowSingleSelect: true,
                columnMapping : [
                    { columnIndex : 0, numberingColumn : true, title : "번호",       align : "center", width : "30px" },
                    { columnIndex : 1, key : "RCV_TYP_NM",     title : "공지대상",   align : "center", width : "80px" },
                    { columnIndex : 2, key : "ANNCE_TITL_NM",  title : "제목",       align : "left",   width : "390px" },
                    { columnIndex : 3, key : "ANNCE_ID",       title : "ANNCE_ID",    hidden : true },
                    { columnIndex : 4, key : "POPUP_YN",       title : "POPUP_YN",    hidden : true },
                    { columnIndex : 5, key : "MNDT_CHK_YN",    title : "MNDT_CHK_YN", hidden : true },
                    { columnIndex : 6, key : "RGST_MD",        title : "RGST_MD",     hidden : true },
                    { columnIndex : 7, key : "USER_CHK_YN",    title : "USER_CHK_YN", hidden : true }
                ],
                on : {
                    'cell' : {
                        "click" : function(data, eh, e) {
                            pSearchAnnce(data);
                        }
                    }
                }
            });
        },
        setValidators : function() {
        },
        setCodeData : function() {
            //
        }
    });//end-of-$.alopex.page //-------------------------------------------------------------------------------------------------------//

    //팝업 공지목록 조회
    function pSearchAnncePopList(param) {
        $.alopex.request(_TX_SEARCH, {
            data: {},
            success: ['#gridanncepop', function(res) {
                $("#gridanncepop").alopexGrid("dataEdit", {_state:{selected:true}}, {_index:{data:0}});
                var firstAnnce = $("#gridanncepop").alopexGrid("dataGet", {_index:{data:0}});
                pSearchAnnce(  AlopexGrid.trimData(firstAnnce[0]) );
                if ( 1==$("#gridanncepop").alopexGrid("dataGet").length ) {
                    $("#gridanncepop").hide(); //공지목록이 1건이면 '그리드'를 감춤
                }
            }]
        });
    }

    //공지 조회
    function pSearchAnnce(param) {
        _debug( JSON.stringify(param) );
        $("#gridfile").alopexGrid('updateOption', {
            message : {
                nodata : ""
            }
        });

        $.alopex.request(_TX_SEARCH_1, {
            showProgress:false,
            data: {
                dataSet: {
                    fields: {
                        ANNCE_ID : param["ANNCE_ID"]
                    }
                }
            },
            success: ['#aform', '#gridfile', function(res) {
                $("#gridfile").alopexGrid('updateOption', {
                    message : {
                        nodata : "<p style='text-align:center;'>조회된 데이터가 없습니다!</p>"
                    }
                });

                $("#chkToday").prop("checked", false);
                $.PSNMAction.setCmntData(param["ANNCE_ID"]); //댓글조회
                //$("#chkMndt").prop("checked", false);

                //if ( 'Y' == res.dataSet.fields.MNDT_CHK_YN ) {
                //    $("#p-mndt-check").show();
                //}
                //else {
                //    $("#p-mndt-check").hide();
                //}
                
            }]
        });
    }

    //현재 공지사항 '확인하였음' 체크 저장
    function pSaveAnnceMndtChk() {
        //if ( ! $("#chkMndt").prop("checked") ) {
        //    $.PSNM.alert("'확인 하였음'을 체크하십시오.");
        //    return false;
        //}

        $.alopex.request(_TX_SAVE_CHK, {
            data: {
                dataSet: {
                    fields: {
                        ANNCE_ID : $("#ANNCE_ID").val()
                    }
                }
            },
            success: [function(res) {
                $("#gridanncepop").alopexGrid("dataEdit", {"USER_CHK_YN":"Y"}, {_state:{selected:true}}); //{_index:{data:0}}
                $("#p-mndt-check").hide();
            }]
        });
    }

    function closeWith() {
        var isChecked = $("#chkToday").prop("checked");

        if ( isChecked ) {
            var arrAnnce = $("#gridanncepop").alopexGrid("dataGet");
            var cntMndt = 0;

            for(var i=0, len=arrAnnce.length; i<len; i++) {
                if ( 'Y'==arrAnnce[i]['MNDT_CHK_YN'] && 'N'==arrAnnce[i]['USER_CHK_YN'] ) {
                    cntMndt++;
                }
            }
            if ( cntMndt>0 ) {
                if ( !$.PSNM.confirm("'필수확인' 공지가 남아있습니다.\n\n'오늘 하루 창 열지 않기' 선택은 적용되지 않습니다.\n\n현재 창을 닫으시겠습니까?") ) {
                    return false;
                }
                $a.close(false); //쿠키를 설정하지 않도록 함.
            }
        }
        $a.close(isChecked);
    }

    //현재창을 닫고 객체를 반환
    function closeConfirm() {
        var oReturn = {};
        $a.close(oReturn);
    }
    </script>
</head>

<body>

<div id="Wrap"> 
    <div class="pop_header" style="overflow-y: auto;">

        <!-- 공지목록 area -->
        <div class="floatL4"> 
            <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>공지사항</b>
        </div>
        <div id="gridanncepop" class="view_list" data-bind="grid:gridanncepop" data-ui="ds"></div>

        <table id="aform" class="board02" style="margin-top: 20px;">
            <tr>
                <th scope="col" style="width:60px;">제목</th>
                <td class="tleft" style="width:350px;">
                    <input id="ANNCE_ID" name="ANNCE_ID" type="hidden" data-bind="value:ANNCE_ID" data-type="hidden" /> 
                    <span id="ANNCE_TITL_NM" data-bind="text:ANNCE_TITL_NM"></span>
                </td>
                <th scope="col" style="width:60px;">공지대상</th>
                <td class="tleft">
                    <span id="RCV_TYP_CD_NM" data-bind="text:RCV_TYP_CD_NM"></span>
                </td>
                <th scope="col" style="width:60px;">게시일자</th>
                <td class="tleft">
                    <span id="BLTN_DT" data-bind="text:BLTN_DT"></span>
                </td>
            </tr>
            <tr>
                <td colspan="6" class="tleft">
                    <div id="ANNCE_CTT" data-bind="html:ANNCE_CTT" class="" style="padding: 10px; width: 99%; "><!-- height: 200px; overflow:auto; -->
                        &nbsp;
                    </div>
                </td>
            </tr>
        </table>

        <!-- 첨부파일 area -->
        <div class="floatL4" id="area-gridfile-head"> 
            <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>첨부파일</b> <span id="gridfile-title-info"></span>  : 하단 파일을 클릭하시면 저장 및 열기가 가능합니다.
            <div class="ab_pos1" style="display:none;">
                <div style="width:95px; height: 24px; background:url('/web/image/btn_c16.gif') no-repeat; border:0px;">
                     <input id="fileupload" type="file" name="files[]" multiple style="width:44px; height:24px; filter:alpha(opacity=0); opacity: 0; cursor: pointer;" /> 
                     <input id="btnFileDel" data-type="button" class="inputButton">
                </div>
            </div>
        </div>
        <div id="gridfile" class="view_list" data-bind="grid:gridfile" data-ui="ds"></div>

        <div class="pop-bchk">
            <p id="p-today-check" style="display:;">
                <input id="chkToday" name="chkToday" type="checkbox" data-type="checkbox"> 오늘 하루 창 열지 않기 
                <input id="btnClose" name="btnClose" type="button"   data-type="button" data-theme="af-n-btn23">
            </p>
            <!--
            <p id="p-mndt-check" style="display:;">
                <input id="chkMndt"    name="chkMndt"    type="checkbox" data-type="checkbox"> 확인 하였음 　　 　　
                <input id="btnConfirm" name="btnConfirm" type="button"   data-type="button" data-theme="af-n-btn24">
            </p>
            -->
        </div>

    </div>
</div>

</body>
</html>