<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="nexcore.framework.core.Constants"%>
<%@ page import="nexcore.framework.core.code.ICode"%>
<%@ page import="nexcore.framework.core.data.user.IUserInfo"%>
<%@ page import="nexcore.framework.core.util.BaseUtils"%>
<%@ page import="nexcore.framework.online.channel.util.WebUtils"%>
<%
    //IUserInfo userInfo = WebUtils.getSessionUserInfo(request);
%>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>공지사항 - PS&Marketing</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />

    <script type="text/javascript">

    var _TX_SEARCH_1   = "com.MAINLOGIN@PMAIN001_pSearchAnnce";
    var _TX_SAVE_CHK   = "com.ANNCEMGMT@PANNCEMGMT001_pInsertAnnceMndtChk";

    var _initParam = null;

    $.alopex.page({
        init : function(id, param) {
            _initParam = param;
            $.PSNMPop.popinit(id, param); //팝업화면 초기화 공통처리
            $a.page.setEventListener();
            $a.page.setGrid();
            $a.page.setValidators();

            pSearchAnnce(param); //조회
        },
        setEventListener : function() {
            $("#btnConfirm").click( pSaveAnnceMndtChk );
            $("#iconCancel").click(function() { $a.close(); });
        },
        setGrid : function() {
            $.PSNMUtils.setFileGrid("gridfile", true); //첨부파일 그리드 초기화
        },
        setValidators : function() {
        },
        setCodeData : function() {
            //
        }
    });//end-of-$.alopex.page //-------------------------------------------------------------------------------------------------------//

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
                $("#chkMndt").prop("checked", false);
            }]
        });
    }

    //현재 공지사항 '확인하였음' 체크 저장
    function pSaveAnnceMndtChk() {
        if ( ! $("#chkMndt").prop("checked") ) {
            if ( $.PSNM.confirm("필수확인 공지사항 팝업창을 닫으시겠습니까?") ) {
                $a.close();
            }
            else {
                return false;
            }
        }
        else {
            $.alopex.request(_TX_SAVE_CHK, {
                data: {
                    dataSet: {
                        fields: {
                            ANNCE_ID : $("#ANNCE_ID").val()
                        }
                    }
                },
                success: function(res) {
                    $a.close();
                }
            });
        }
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
        <span class="title">공지사항 - 반드시 확인하세요.</span>
        <a id="iconCancel" href="#" class="pop_close"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a9.gif" alt="팝업닫기" ></a> 

        <!--
        <div class="floatL4"> 
            <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>공지사항</b>
        </div>
        -->

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
            <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>첨부파일</b> <span id="gridfile-title-info"></span> : 하단 파일을 클릭하시면 저장 및 열기가 가능합니다.
            <div class="ab_pos1" style="display:none;">
                <div style="width:95px; height: 24px; background:url('/web/image/btn_c16.gif') no-repeat; border:0px;">
                     <input id="fileupload" type="file" name="files[]" multiple style="width:44px; height:24px; filter:alpha(opacity=0); opacity: 0; cursor: pointer;" /> 
                     <input id="btnFileDel" data-type="button" class="inputButton">
                </div>
            </div>
        </div>
        <div id="gridfile" class="view_list" data-bind="grid:gridfile" data-ui="ds"></div>

        <div class="pop-bchk">
            <p id="p-mndt-check" style="display:;">
                <input id="chkMndt"    name="chkMndt"    type="checkbox" data-type="checkbox"> 확인 하였음 　　 　　
                <input id="btnConfirm" name="btnConfirm" type="button"   data-type="button" data-theme="af-n-btn24">
            </p>
        </div>

    </div>
</div>

</body>
</html>