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

    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/vendor/jquery.ui.widget.js"></script>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/jquery.iframe-transport.js"></script>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/jquery.fileupload.js"></script>

    <script type="text/javascript">

    var _TX_SEARCH     = "com.MAINLOGIN@PMAIN001_pSearchAnnce";
    var _TX_SEARCHCMNT = "com.CMNT@PCMNT001_pSearchCmnt";
    var _TX_SAVECMNT   = "com.CMNT@PCMNT001_pInsertCmnt";
    var _TX_DELCMNT    = "com.CMNT@PCMNT001_pDeleteCmnt";
    var _initParam = null;

    $a.page({
        init : function(id, param) {
            _initParam = param;
            $.PSNMPop.popinit(id, param); //팝업화면 초기화 공통처리
            $a.page.setEventListener();
            $a.page.setGrid();
            $a.page.setValidators();

            $('#cform').setData(param);
            _debug("CMNT_MGMT_ID = " + $("#CMNT_MGMT_ID").val() + "\n\nANNCE_ID = " + $("#cform input[name='ANNCE_ID']").val());
            pSearchAnnce(param); //조회
            $.PSNMAction.setCmntData(param["ANNCE_ID"]); //댓글조회
        },
        setEventListener : function() {
            $("#btnConfirm").click( closeConfirm );
            $("#btnCmntSave").click(function(){
                $.PSNMAction.saveCmntData(_initParam["ANNCE_ID"], $("#cmnt")); //댓글저장
            });
            $("#btnMndt").click(function(){
                if (!$("#mndtChkYn").is(":checked")){
                    $.PSNM.alert("필수확인여부를 체크 하십시오.");
                    return;
                }
                if ( $.PSNM.confirm("I004", ["확인"] ) ){
                    var requestData = $.PSNMUtils.getRequestData("aform");
                    $.alopex.request("com.ANNCEMGMT@PANNCEMGMT001_pInsertAnnceMndtChk", {
                        data: requestData,
                        success: function(res) { 
                            $a.close(); //필수공지확인후 닫기
                        }
                    });
                }
            });
        },
        setGrid : function() {
            $.PSNMUtils.setFileGrid("gridfile", true); //첨부파일 그리드 초기화
        },
        setValidators : function() {
            ;
        },
        setCodeData : function() {
            ;
        }
    });//end-of-$.alopex.page //-------------------------------------------------------------------------------------------------------//

    function pSearchAnnce(param) {
        $.alopex.request(_TX_SEARCH, {
            data: {
                dataSet: {
                    fields: {
                        ANNCE_ID : param["ANNCE_ID"]
                    }
                }
            },
            success: ['#aform', '#gridfile', function(res) { //, '#gridcmnt'
                $("#BLTN_DT").html( res.dataSet.fields.BLTN_DT );
                $("#RCV_TYP_CD_NM").html( res.dataSet.fields.RCV_TYP_CD_NM );
                $("#ANNCE_TITL_NM").html( res.dataSet.fields.ANNCE_TITL_NM );
                $("#ANNCE_CTT").html( res.dataSet.fields.ANNCE_CTT );
                //gridfile-title-info
                if ( 0==res.dataSet.recordSets.gridfile.nc_recordCount ) {
                    $("#gridfile-title-info").text(": 첨부파일이 없습니다.");
                    $("#gridfile").hide();
                }
                var MNDT_CHK_YN = res.dataSet.fields.MNDT_CHK_YN;
                var USER_CHK_YN = res.dataSet.fields.USER_CHK_YN;
                if("Y"==MNDT_CHK_YN && "N"==USER_CHK_YN){
                    $("#mndtChk").show();
                }
            }]
        });
    } //end of pSearchAnnce()

    function closeWithout() {
        $a.close();
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

        <!--<div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>공지사항</b></div> -->
        <table id="aform" class="board02">
            <tr>
                <th scope="col" style="width:60px;">제목</th>
                <td class="tleft" style="width:350px;">
                    <input id="ANNCE_ID" name="ANNCE_ID" type="hidden" data-bind="value:ANNCE_ID" data-type="hidden" /> 
                    <span id="ANNCE_TITL_NM"></span>
                </td>
                <th scope="col" style="width:60px;">공지대상</th>
                <td class="tleft">
                    <span id="RCV_TYP_CD_NM"></span>
                </td>
                <th scope="col" style="width:60px;">게시일자</th>
                <td class="tleft">
                    <span id="BLTN_DT"></span>
                </td>
            </tr>
            <tr>
                <td colspan="6" class="tleft">
                    <div id="ANNCE_CTT" class="" style="padding: 10px; width: 99%; "><!-- height: 200px; overflow:auto; -->
                        &nbsp;
                    </div>
                </td>
            </tr>
            <tr id="mndtChk" style="display:none;">
                <th scope="col">필수확인</th>
                <td class="tleft" colspan="5">
                    <input id="mndtChkYn" name="mndtChkYn" type="checkbox" data-type="checkbox" value="Y"/>확인하였음.&nbsp;
                    <button id="btnMndt" type="button" data-type="button" data-theme="af-n-btn25" data-altname="확인"></button>
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

        
        <!--view_댓글 area -->
        <jsp:include page="/view/layouts/popup_cmnt_comm.jsp" flush="false" />

    </div>
</div>

</body>
</html>