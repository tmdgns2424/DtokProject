<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

    <jsp:include page="/view/layouts/default_head.jsp" flush="false" />
    
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/vendor/jquery.ui.widget.js"></script>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/jquery.iframe-transport.js"></script>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/jquery.fileupload.js"></script>

    <script type="text/javascript">
    
    var _param;
    
    $.alopex.page({

        init : function(id, param) { 
            $.PSNM.initialize(id, param); //PSNM공통 초기화함수 호출
            
            _param = param; //이 페이지로 전달된 파라미터를 저장
            
            $a.page.setEventListener(param);
            $a.page.setFileUpload();
		   $("#form").setData(param);   
        
		pSearchSndPaperDtl(param);
        },
        setEventListener : function(param) {
            $("#btnList").click(function(){
                $a.back(_param); // param 값이 넘어가면서 back 해줌. 
            });
            $("#readPop").click(function(){
                sndReadrPop();
            });
            
            $("#btnDel").click(function(){
                if( $.PSNM.confirm("I004", ["삭제"] ) ){
                $.alopex.request("com.PAPER@PPAPERMGMT001_pDeletePaper", {
                    data:   {
                            dataSet: 
                                {fields: 
                                    {PAPER_ID :param.PAPER_ID}
                                }
                            },
                    success:[function(res) {
                        $a.navigate("sndPaper.jsp"); 
                    }]
                });
                }
            });
        },  
        setFileUpload : function () {
            $.PSNMUtils.setFileUploadAndGrid("PAP", "#fileupload", "#gridfile"); 
        }
    });

    function pSearchSndPaperDtl(param) {
        if (null==param || undefined==param) {
            return;
        }
        $.alopex.request("com.PAPER@PPAPERMGMT001_pSearchSndPaperDtl", {
            data:   {
                dataSet:{
                    fields: {
                            PAPER_ID :param.PAPER_ID , ATCH_FILE_YN :param.ATCH_FILE_YN
                            }
                        }
                    },
            success:["#form", "#gridfile",  function(res) {
            }]
        });
    }
        function sndReadrPop() {
            var requestData = $("#form").getData();

            $a.popup({
                url: "/view/com/paper/sndReadrPopup.jsp"
                , data: requestData
                , width: 850
                , height: 600
                , windowpopup: false
                , iframe: true
                , title: "쪽지열람확인"
            });
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
            <button type="button" id="btnDel" data-type="button" data-theme="af-btn13" data-authtype="R" data-altname="삭제"></button>
	         <button id="btnList" type="button" data-type="button" data-theme="af-btn14" data-altname="목록" data-authtype="R"></button>
        </div>
    </div>
    <!-- btn area end--> 

    <!--view_list area -->
    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>쪽지내용</b></div>

    <!--view_table area -->
    <div class="view_list">

        <form id="form" onsubmit="return false;">
            <table class="board02" style="width:100%;">
            <colgroup>
	            <col style="width:15%"/>
	            <col style="width:30%"/>
	            <col style="width:15%"/>
	            <col style="width:*"/>
            </colgroup>
            <tbody>
                <tr>
                    <th scope="col">제목</th>
                    <td colspan="3" class="tleft">
	                    <label data-bind="text:TITLE"></label>	
                    	<button id="readPop" type="button" data-type="button" data-theme="af-n-btn33"  data-authtype="R" data-altname="열람확인" class="af-button af-n-btn33" style="text-align: right" data-converted="true"></button>                        	
                    </td>
                </tr>
                <tr>
                    <th scope="col">받는 사람</th>
                    <td class="tleft time"><label data-bind="text:RCV_USER_NM"></label></td>
                    <th scope="col">보낸 시간</th>
                    <td class="tleft"><label data-bind="text:RGST_DT"></label></td>
                </tr>
                <tr>
                    <td colspan="4" class="tleft" style="word-break:break-all;"><label data-bind="html:CONTENT"></label></td>
                </tr>
            </tbody>
            </table>
        </form>
    </div>

    <!--view_list area -->
    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>첨부파일</b> : 하단 파일을 클릭하시면 저장 및 열기가 가능합니다.</div>
    <div id="gridfile" class="view_list" data-bind="grid:gridfile"></div><!--  이거는 파일처리 하는 공간 .. 다음주에 확인!  -->
</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>