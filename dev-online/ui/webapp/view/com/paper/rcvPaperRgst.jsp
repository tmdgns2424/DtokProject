<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
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
    var _param;

    $.alopex.page({
        init : function(id, param) { 
            $.PSNM.initialize(id, param); 
    
            _param = param; 
            
            $("#form").setData(param);   
            $a.page.setEventListener(); 
            $a.page.setFileUpload();
        },
        setEventListener : function() {
            $("#CONTENT").ckeditor();

            $("#btnSend").click( sendPaper );
            $("#btnList").click( listPaper );
            $("#btnFileDel").click(function(){
            	$.PSNMUtils.delFile();
            });
        }, 
        setFileUpload : function () {
            $.PSNMUtils.setFileUploadAndGrid("PAP", "#fileupload", "#gridfile");
        }
    });

    function sendPaper() {
        if ( !$.PSNM.isValid("form") ) {
            return false;
        }

        var requestData = $.PSNMUtils.getRequestData("form", "gridfile");

        $.alopex.request('com.PAPER@PPAPERMGMT001_pInsertRePaper', {
        	
            data: requestData,
            success: function(res) { 
                $a.navigate("rcvPaper.jsp", _param);
            }
        });
    }
    function listPaper(){
        $a.navigate("rcvPaper.jsp"); 
    }
    </script>
</head>

<body>
    <jsp:include page="/view/layouts/default_header.jsp" flush="false" />

<div id="contents">
    <!-- title area -->
	<div class="content_title">
    	<div class="ub_txt6">
        	<span class="txt6_img"><b id="sub-title">메뉴제목</b>
        	<span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif"> 
        	<span class="a2">대메뉴명</span> <span class="a3"> > </span> <span class="a4"><b>중메뉴명</b> </span></span></span>
       	</div>
    </div>


    <!-- btn area -->
    <div class="btn_area">
        <div class="ab_btn_right">
            <button id="btnSend" type="button" data-type="button" data-theme="af-n-btn13" data-authtype="R" data-altname="보내기" class="af-button af-n-btn13" data-converted="true"></button>
            <button id="btnList" type="button" data-type="button" data-theme="af-btn14" data-altname="목록" data-authtype="R"></button>
        </div>
    </div>
    <!-- btn area end--> 
    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>쪽지내용</b></div>

    <!--view_table area -->
    <div class="view_list">
        <form id="form">
            <table class="board02" style="width:100%" >
	            <colgroup>
		            <col style="width:15%"/>
	            </colgroup>
                <tr>
                    <th scope="col">제목</th>
                    <td class="tleft">
                        <input id="TITLE" name="TITLE"  data-type="textinput" 
                            data-validation-rule="{required:true, minlength:5}" 
                            data-validation-message="{required:'제목을 반드시 입력하세요!', minlength:'제목을 5글자 이상 입력하세요!'}" style="width:95%" value="">
                    </td>
                </tr>
                <tr>
                    <th scope="col">받는사람</th>
                    <td class="tleft">
                        <label data-bind="text:SND_USER_NM"></label>
                        <input id="RCV_USER_ID" name="RCV_USER_ID" type="hidden" data-bind="value:RCV_USER_ID">
                    </td>
                </tr> 
                <tr>
                    <td colspan="2" class="tleft">
                                <textarea id="CONTENT" name="CONTENT" data-type="textarea" rows="10" cols="80" 
                                        data-validation-rule="{required:true}" 
                                        data-validation-message="{required:$.PSNM.msg('E012', ['내용'])}" 
                                        style='overflow: auto; width: 100%;'></textarea>
                            </td>
                </tr>
            </table>
        </form>
        <div class="file-controls" style="">
        </div>
    </div>
    <!--view_list area -->
    <div class="floatL4"> 
        <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>첨부파일</b> : 하단 파일을 클릭하시면 저장 및 열기가 가능합니다.
        <div class="ab_pos1">
            <div style="position:relative;">
                <span class="file-button type1"><input id="fileupload" type="file"></span>
                <button id="btnFileDel" data-type="button" class="af-n-btn5"></button>
            </div>
        </div>
    </div>
    <div id="gridfile" class="view_list" data-bind="grid:gridfile"></div>
</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>
