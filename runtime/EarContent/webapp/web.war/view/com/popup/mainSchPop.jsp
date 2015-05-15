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
        //System.out.println("<mainSchPop.jsp> USER_ID : " + userInfo.getLoginId());
    }
%>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>주요일정 - PS&Marketing</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />

    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/vendor/jquery.ui.widget.js"></script>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/jquery.iframe-transport.js"></script>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/jquery.fileupload.js"></script>

    <script type="text/javascript">

    var _TX_SEARCH     = "com.MAINLOGIN@PMAIN001_pSearchSch";
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
            _debug("CMNT_MGMT_ID = " + $("#CMNT_MGMT_ID").val() + "\n\nSCH_ID = " + $("#cform input[name='SCH_ID']").val());
            pSearchSch(param); //조회
        },
        setEventListener : function() {
            $("#btnConfirm").click( closeConfirm );
        },
        setGrid : function() {
            $.PSNMUtils.setFileGrid("gridfile", true); //첨부파일

            $("#gridcmnt").alopexGrid({ //댓글 그리드 초기화
                pager : false,
                rowSingleSelect: true,
                rowOption : {
                    multi : {
                        styleclass : function(data, multiMapping, multirowOption) {
                            var s = JSON.stringify(data) + "\n\n";
                                s+= multiMapping.key;
                                alert(s);
                            if (multiMapping.key === "CMNT_CTT") {
                                //columnMapping.multi에 의해 그려지는 행이 MULTI1 키값을 표현하는 행이라면 
                                //해당 tr태그에 double-height-row 클래스를 추가합니다.
                                return "double-height-row";
                            }
                        }
                    }
                },
                columnMapping : [
                    { columnIndex : 0, key : "RN",           title : "번호",         align : "center", width : "30px" },
                    { columnIndex : 1, key : "RGSTR_NM",     title : "작성자",       align : "center", width : "70px" },
                    { columnIndex : 2, key : "RGST_MDHM",    title : "작성일시",     align : "center", width : "100px" }, //RGST_DTM
                    { columnIndex : 3, key : "CMNT_CTT",     title : "댓글",         align : "left",   width : "390px" },
                    { columnIndex : 4, key : "CMNT_MGMT_ID", title : "CMNT_MGMT_ID", align : "center", hidden: true },
                    { columnIndex : 5, key : "CMNT_SEQ",     title : "CMNT_SEQ",     align : "left",   hidden: true },
                    { columnIndex : 6, key : "RGSTR_ID",     title : "삭제",         align : "center", width : "50px",
                                        render : function(value, data) {
                                            var str = '';
                                            if ('<%= userInfo.getLoginId() %>'==value)
                                                str += '<button class="edit">삭제</button>'; //disabled="disabled"
                                            return  str;
                                        }
                    }
                ],
                on : {
                    'cell' : {
                        "click" : function(data, eh, e) {
                            _debug("gridcmnt.on.cell.click", "" + $.PSNMUtils.toString(data));
                            if (data._key == "RGSTR_ID") { //삭제칼럼
                                pDeleteCmnt(data);
                            }
                        }
                    }
                }
            });
        }, //end-of-setGrid
        setValidators : function() {
            $('#CMNT_CTT').validator({
                rule : { required: true, maxlength: 500 },
                message: {
                    required: $.PSNM.msg('E012', ["댓글"]), //{0} 항목은 필수값입니다!
                    maxlength: $.PSNM.msg('E015', ["댓글", "500"]), //{0} 항목은 {1}자 이하 입력하세요!
                }
            });
        },
        setCodeData : function() {
            //
        }
    });//end-of-$.alopex.page //-------------------------------------------------------------------------------------------------------//

    function pSearchSch(param) {
        $.alopex.request(_TX_SEARCH, {
            data: {
                dataSet: {
                    fields: {
                        SCH_ID : param["SCH_ID"]
                    }
                }
            },
            success: ['#aform', '#gridfile', function(res) { //, '#gridcmnt'
                $("#BLTN_DT").html( res.dataSet.fields.BLTN_DT );
                $("#RCV_TYP_CD_NM").html( res.dataSet.fields.RCV_TYP_CD_NM );
                $("#SCH_TITL_NM").html( res.dataSet.fields.SCH_TITL_NM );
                $("#SCH_CTT").html( res.dataSet.fields.SCH_CTT );
                //gridfile-title-info
                if ( 0==res.dataSet.recordSets.gridfile.nc_recordCount ) {
                    $("#gridfile-title-info").text(": 첨부파일이 없습니다.");
                    $("#gridfile").hide();
                }
                pSearchCmnt();
            }]
        });
    } //end of pSearchSch()

    function pSearchCmnt() {
        $.alopex.request(_TX_SEARCHCMNT, {
            data: {
                dataSet: {
                    fields: {
                        CMNT_MGMT_ID : $('#SCH_ID').val()
                    }
                }
            },
            success: ['#gridcmnt', function(res) {
                $(".cell-wrapper").css("word-wrap", "break-word");
                $(".cell-wrapper").css("white-space", "pre");
            }]
        });
    }

    function pSaveCmnt() {
        if ( !$.PSNM.isValid("#cform") ) {
            return false;
        }
        var requestData = $.PSNMUtils.getRequestData("cform");
        $.alopex.request(_TX_SAVECMNT, {
            showProgress:false,
            data: requestData,
            success: [function(res) { //'#gridcmnt',
                $("#CMNT_CTT").val("");
                pSearchCmnt();
            }]
        });
    }

    function pDeleteCmnt(oParam) {
        var otParam = AlopexGrid.trimData(oParam);
        _debug("pDeleteCmnt = " + JSON.stringify(otParam));

        if ( ! $.PSNM.confirm("PSNM-I004", ["댓글을 삭제"]) ) { //"PSNM-I004", "MESSAGE_NAME":"{0} 하시겠습니까?"
            return false;
        }

        var requestData = $.PSNMUtils.getRequestData("cform");
            requestData.dataSet.fields["CMNT_SEQ"] = otParam.CMNT_SEQ;

        $.alopex.request(_TX_DELCMNT, {
            showProgress:false,
            data: requestData,
            success: function(res) {
                pSearchCmnt();
            }
        });
    }

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

    <!--<div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>주요일정</b></div> -->
    <table id="aform" class="board02">
        <tr>
            <th scope="col" style="width:60px;">제목</th>
            <td class="tleft" style="width:350px;">
                <input id="SCH_ID" name="SCH_ID" type="hidden" data-bind="value:SCH_ID" data-type="hidden" /> 
                <span id="SCH_TITL_NM"></span>
            </td>
            <th scope="col" style="width:60px;">일정</th>
            <td class="tleft">
                <span id="RCV_TYP_CD_NM"></span>
            </td>
            <th scope="col" style="width:60px;">게시자</th>
            <td class="tleft">
                <span id="BLTN_DT"></span>
            </td>
        </tr>
        <tr>
            <td colspan="6" class="tleft">
                <div id="SCH_CTT" class="" style="padding: 10px; width: 99%; "><!-- height: 200px; overflow:auto; -->
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

        <!-- 댓글등록 area -->
        <div class="floatL4" id="area-cmnt-head"> 
            <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>댓글등록</b>
            <p class="ab_pos1">
                <img src="<c:out value='${pageContext.request.contextPath}'/>/image/btn_c25.gif" style="cursor:pointer;" onclick="javascript:pSaveCmnt();" alt="댓글등록" />
            </p>
        </div>
        <table id="cform" class="board02">
            <tr>
                <td class="tleft">
                    <input name="SCH_ID" type="hidden" data-type="hidden" data-bind="value:SCH_ID" />
                    <input name="USER_ID"  type="hidden" data-type="hidden" data-bind="" value="<%= userInfo.getLoginId() %>"/>
                    <input id="CMNT_MGMT_ID" name="CMNT_MGMT_ID" type="hidden" data-bind="value:SCH_ID" data-type="hidden" />
                    <input id="CMNT_SEQ"    name="CMNT_SEQ"    type="hidden" data-bind="value:CMNT_SEQ" data-type="hidden" />
                    <textarea id="CMNT_CTT" data-type="textarea" data-bind="value:CMNT_CTT" rows="3" 
                              style='overflow: auto; width: 99%; height: 50px; margin: 1px; padding: 3px;'></textarea>
                </td>
            </tr>
        </table>
        <!--
        <div class="floatL4" id="area-cmnt-body"> 
        </div>
        -->

        <!-- 댓글목록 area -->
        <div class="floatL4" id="area-gridcmnt-head"> 
            <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>댓글목록</b>
            <div class="ab_pos1" style="display:none;">
                <div style="width:95px; height: 24px; background:url('/web/image/btn_c16.gif') no-repeat; border:0px;">
                     <input id="fileupload" type="file" name="files[]" multiple style="width:44px; height:24px; filter:alpha(opacity=0); opacity: 0; cursor: pointer;" /> 
                     <input id="btnFileDel" data-type="button" class="inputButton">
                </div>
            </div>
        </div>
        <div id="gridcmnt" class="view_list" data-bind="grid:gridcmnt" data-ui="ds"></div>

        <!--
        <div class="btn_area">
            <p class="floatL3">
                <input id="btnConfirm" type="button" data-type="button" value="확인" data-theme="af-btn8" >
            </p>
        </div>
        -->

    </div>
</div>

</body>
</html>