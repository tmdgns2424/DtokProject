<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
    String _ROOT = "";
    //System.out.println("############## 공지사항 상세");
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<style>
</style>
    <jsp:include page="/view/layouts/default_head.jsp" flush="false" />

    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/vendor/jquery.ui.widget.js"></script>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/jquery.iframe-transport.js"></script>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/jquery.fileupload.js"></script>

    <script type="text/javascript">
    var _mode = "";
    var _param;

    $.alopex.page({
        init : function(id, param) { 
            $.PSNM.initialize(id, param); //PSNM공통 초기화함수 호출

            _param = param; //이 페이지로 전달된 파라미터를 저장
            _mode = "insert";

            $("#ANNCE_ID").val("");

            if ( $.PSNMUtils.isNotEmpty(param.ANNCE_ID) ) {
                _mode = "update";
                $("#ANNCE_ID").val(param.ANNCE_ID);
            }
            console.log("<annceEdit> <상세페이지> _mode = " + _mode + ", ANNCE_ID = " + param.ANNCE_ID + ", ANNCE_ID(hidden) = " + $("#ANNCE_ID").val());

            $a.page.setEventListener(); //페이지내 버튼에 이벤트 핸들러 매핑
            $a.page.setGrid(); //그리드정보 설정
            $a.page.setCodeData();
            $a.page.setValidators();
            console.log("<annceEdit> 알로펙스 세션값 : \n" + JSON.stringify($a.session('alopex_parameters')) );

            if (_mode === "update") {
                searchAnnce( param.ANNCE_ID ); //$a.page.searchAnnce( param.ANNCE_ID );
            }
            else {
                $("#ANNCE_CTT").ckeditor(); //CK에디터 설정
            }

            //파일 업로드 컴포넌트 및 첨부파일그리드 초기설정(@since 2014-11-28)
            $.PSNMUtils.setFileUploadAndGrid("ANN", "#fileupload", "#gridfile", "#form");
        },
        setEventListener : function() {
            $("#btnFileDel").click( delFile );
            $("#btnSave").click( saveAnnce );
            $("#btnList").click( gotoList );
            $("#btnTest").click( setTestData );
        }, //end-of-setEventListener
        setGrid : function() {
            //첨부파일 그리드 초기화 :: $.PSNMUtils.setFileUploadAndGrid() 함수에서 공통적으로 처리함.
            
        }, //end-of-setGrid
        setCodeData : function() {
            $.PSNMUtils.setCodeData([
                { "elemid" : "RCV_TYP_CD", "codeid" : "DSM_RCV_TYP_CD", "dataKey" : "selectOptionsData", "header" : "-선택-", "ADD_INFO_01":"" } //전체, 선택 등이 넣으려면 설정함.
               ,{ "elemid" : "STRD_CL_VAL_CD", "codeid" : "DSM_STRD_CL_VAL_CD", "header" : "-선택-", "ADD_INFO_01":"SMS" } //전체, 선택 등이 넣으려면 설정함.
            ]);
        }
        ,
        setValidators : function() {
            $('#ANNCE_TITL_NM').validator({
                rule : { required: true },
                message: {
                    required: $.PSNM.msg('E012', ["공지제목"]) //{0} 항목은 필수값입니다!
                }
            });
            $('#ANNCE_CTT').validator({
                rule : { required: true },
                message: {
                    required: $.PSNM.msg('E012', ["공지내용"]) //{0} 항목은 필수값입니다!
                }
            });
        }
    });

    function searchAnnce( annceId ) {
        console.log("공지사항1건 조회처리 시작 ... annceId = [%s]", annceId);

        $.alopex.request('brd.BRDBAnnce@PBRD0001_pSearchAnnce', {
            data: {
                dataSet: {
                    fields: {
                        ANNCE_ID : annceId
                    }
                }
            },
            success: ['#form', '#gridfile', function(res) { 
                $("#ANNCE_CTT").ckeditor();
                console.log("<annceEdit> <상세페이지> 조회성공 ANNCE_ID = " + $("#ANNCE_ID").val());
            }]
        });
    } //end of searchAnnce()

    function delFile() {
        console.log("파일삭제 시작 처리 시작 ...");
        /*
        var filesToDelete = $("#gridfile").alopexGrid( "dataGet" , { _state : { selected : true } } ); //선택된 데이터

        if (filesToDelete.length<1) {
            alert('선택된 첨부파일이 없습니다.');
            return;
        }

        var lenSelected = filesToDelete.length; alert( "lenSelected = " + lenSelected );

        //그리드에서 (선택된 행 & 플래그=I) 데이터를 삭제함
        //$("#gridfile").alopexGrid("dataSet", {_state:{selected:true}, "FLAG":"D"});
        $("#gridfile").alopexGrid( "dataEdit", {"FLAG":"D"}, {_state:{selected:true}} ); //선택된 파일의 FLAG 값을 'D'로 설정함
        $("#gridfile").alopexGrid( "dataEdit", {_state:{selected:false}}, {_state:{selected:true}} ); //체크 해제
        */
        $.PSNMUtils.delFile();
    }

    function saveAnnce() {
        console.log("<저장> 시작 ... _mode = %s", _mode);

        // 폼 검증 1 : setValidators() 에서 지정된 것
        if ( !$.PSNM.isValid("form") ) {
            return false;
        }
        // TODO : 검증 2 : 추가적인 검증이 필요하면 여기에 구현

        //폼과 첨부파일 그리드 모두 합쳐 request 데이터를 생성함. 그리드가 1개이상 가능함.
        var requestData = $.PSNMUtils.getRequestData("form", "gridfile");

        console.log("<저장> requestData --------------------\n\n" + JSON.stringify(requestData));
        $.alopex.request('brd.BRDBAnnce@PBRD0001_pSaveAnnce', {
            data: requestData,
            success: function(res) {
                if ( !$.PSNM.success(res) ) { //서버측에서 오류시 
                    return false;
                }
                console.log("<저장> 원래 전달되었던 파라미터 ---\n\n" + JSON.stringify(_param));
                $a.navigate("annceList.jsp", _param);
            }
        });
    } //end of saveAnnce()

    function gotoList(annceId) {
        console.log("<공지사항상세> <gotoList> 전달되었던 파라미터 ---\n" + JSON.stringify(_param));
        $a.back(_param);
    }

    function setTestData() {
        var today = new Date();
        var ymd    = today.format("yyyy-mm-dd");
        var ymdhms = today.format("yyyy-mm-dd HH:MM:ss");

        $("#ANNCE_TITL_NM").val("공지사항 테스트 제목임 - " + ymdhms);
        $("#ANNCE_CTT").val("<p>공지사항 테스트 내용입니다. " + ymdhms + "</p>");
        $("#POPUP_Y").attr("checked", "checked");
        //$("#POPUP_STA_DT").val(ymd);
        $.PSNMUtils.setDefaultYmd("#POPUP_STA_DT", "POPUP_END_DT");
    }
    
    </script>

</head>

<body>

<jsp:include page="/view/layouts/default_header.jsp" flush="false" />

<div id="contents">
    
    <!-- title area -->
    <div class="content_title">
        <div class="ub_txt6">
            <span class="txt6_img"><b id="sub-title">공지사항</b>
                <span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif">
                <span class="a2">대메뉴명</span> <span class="a3"> > </span> <span class="a4"><b>중메뉴명</b></span> 
            </span>
        </div>
    </div>

    <!-- btn area -->
    <div class="btn_area">
        <div class="ab_btn_left">
            <input type="button" value="" data-type="button" data-theme="af-btn18" data-authtype="W" >
            <input type="button" value="" data-type="button" data-theme="af-btn42" data-authtype="W" >
            <input type="button" value="" data-type="button" data-theme="af-btn19" data-authtype="W" >
            <input type="button" value="" data-type="button" data-theme="af-btn20" data-authtype="W" >
        </div>
        <div class="ab_btn_right">
            <button id="btnSave" data-type="button" data-theme="af-btn4"  data-authtype="W" data-altname="저장"></button>
            <button id="btnDel"  data-type="button" data-theme="af-btn13" data-authtype="W" data-altname="삭제"></button>
            <button id="btnTest" data-type="button" data-theme="af-btn5"  data-authtype="W" data-altname="테스트"></button>
            <button id="btnList" data-type="button" data-theme="af-btn14" data-authtype="R" data-altname="목록"></button>
        </div>
    </div>
    <!-- btn area end--> 


    <!--view_list area -->
    <div class="floatL4" > <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>공지사항 정보</b> 
        <!--우측 버튼
        <div class="ab_pos1">
            <button id="btnInit" data-type="button" data-theme="af-btn16"></button>
            <button id="btnInit" data-type="button" data-theme="af-btn28"></button>
        </div>
        -->
    </div>

    <!--view_table area -->
    <div class="view_list">

        <form id="form">
            <table class="board02" width="100%" >
            <tr>
                <th scope="col" class="psnm-required" style="width:100px;">제목</th>
                <td colspan="5" class="tleft">
                    <input id="ANNCE_ID" name="ANNCE_ID" type="hidden" data-bind="value:ANNCE_ID" data-type="hidden" /> 
                    <input id="ANNCE_TITL_NM" name="ANNCE_TITL_NM" data-bind="value:ANNCE_TITL_NM" data-type="textinput" style="width:95%" value="">
                </td>
            </tr>
            <tr>
                <th scope="col" style="width:100px;">팝업여부</th>
                <td class="tleft" style="">
                    <input id="POPUP_Y" type="radio" data-type="radio" data-bind="checked:POPUP_YN" name="POPUP_YN" value="Y" />
                    <label for="radioId">Y</label>
                    <input id="POPUP_N" type="radio" data-type="radio" data-bind="checked:POPUP_YN" name="POPUP_YN" value="N" />
                    <label for="radioId2">N</label><br/>
                </td>
                <th scope="col" style="width:100px;">팝업시작일</th>
                <td class="tleft time" style="width:220px;">
                    <input id="POPUP_STA_DT" name="POPUP_STA_DT" data-type="dateinput" data-bind="value:POPUP_STA_DT" data-image/>
                </td>
                <th scope="col" style="width:100px;">팝업종료일</th>
                <td class="tleft time" style="width:220px;">
                    <input id="POPUP_END_DT" name="POPUP_END_DT" data-type="dateinput" data-bind="value:POPUP_END_DT" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png"/>
                </td>
            </tr>
            <tr>
                <th scope="col" style="width:100px;">공지대상</th>
                <td class="tleft">
                    <select id="RCV_TYP_CD" name="RCV_TYP_CD" data-type="select" data-bind="options: selectOptionsData, selectedOptions:RCV_TYP_CD" data-wrap="false" style="width:185px!important">
                        <option value="">-선택-</option>
                    </select>
                </td>
                <th scope="col" style="width:100px;">작성자</th>
                <td class="tleft time">
                    <input id="BLTNR_NM" name="BLTNR_NM" data-type="textinput" data-bind="value:BLTNR_NM" style="width:120px" data-disabled="true"/>
                </td>
                <th scope="col" style="width:100px;">작성일자</th>
                <td class="tleft time">
                    <input id="BLTN_DT" name="BLTN_DT" data-type="dateinput" data-bind="value:BLTN_DT" data-disabled="true" /><!--data-image-->
                    <br/>
                    <select id="STRD_CL_VAL_CD" name="STRD_CL_VAL_CD" data-type="select" data-bind="options: options_STRD_CL_VAL_CD, selectedOptions:STRD_CL_VAL_CD" data-wrap="false" style="width:185px!important">
                        <option value="">-선택-</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td colspan="6" class="tleft">
                    <textarea id="ANNCE_CTT" data-type="textarea" data-bind="value:ANNCE_CTT" rows="10" cols="80" 
                              style='overflow: auto; width: 100%;/*  height: 350px; */'></textarea>
                </td>
            </tr>
            </table>
        </form>

        <div class="file-controls" style="">
                <!-- <input type="file" name="file" id="file" class="input-file" /> -->
        </div>
    </div>

    <!-- 첨부파일그리드영역 -->
    <div class="floatL4">
        <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>첨부파일</b> : 하단 파일을 클릭하시면 저장 및 열기가 가능합니다.
        <div class="ab_pos1" style="float:right;">
            <div style="position:relative;">
                <span class="file-button type1"><input id="fileupload" type="file"></span>
                <button id="btnFileDel" data-type="button" class="af-n-btn5"></button>
            </div>
        </div>
    </div>
    <div id="gridfile" class="view_list" data-bind="grid:gridfile" data-ui="ds"></div>

</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>
