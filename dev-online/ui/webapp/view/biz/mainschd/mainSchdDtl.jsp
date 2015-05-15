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
    _LOG_LEVEL = 0; //로그레벨 :: 0=debug, 1=info, 2=error

    var _TX_SEARCH      = "biz.MAINSCHD@PSCHMGMT001_pDetailSchMgmt";
    var _param;
    $.alopex.page({
    	init : function(id, param) { 
/*     		alert(JSON.stringify($.PSNM.getSession("USER_NM"));
    		document.write(JSON.stringify($.PSNM.getSession()); */
			$.PSNM.initialize(id, param); //PSNM공통 초기화함수 호출
			_param = param;
			$a.page.setEventListener(); //버튼 초기화
			$a.page.setFileUpload();
			$a.page.searchDtl(_param);
			$.PSNMAction.setCmntData(_param.SCH_ID,null,'Y'); // 댓글조회(이페이지로 전달된 아이디), IS_HEAD =null , IS_MAINSCHD=Y 주요일정인 댓글인 경우
        },
        setEventListener : function() {
			$("#btnList").click(function(){
				$a.back(_param);
			});
			$("#btnCmntSave").click(function(){
				var id = _param.SCH_ID; // 이페이지로 전달된 아이디
				$("#IS_MAINSCHD").val("Y");
				$.PSNMAction.saveCmntData(id, $("#cmnt"), null, "Y"); // 댓글저장
			});
// 			$("#btnPrint").click(function(){
//             	$.PSNMUtils.getPrint("print","cmntList");
// 			});
            $("#btnPrint").click(function(){
        		if( !((navigator.appName == 'Microsoft Internet Explorer') 
        				|| ((navigator.appName == 'Netscape') 
        						&& (new RegExp("Trident/.*rv:([0-9]{1,}[\.0-9]{0,})").exec(navigator.userAgent) != null))) ){
        			$.PSNM.alert("인쇄는 \"Microsoft Internet Explorer\" 를 사용하십시오.");
        			return false;
        		}

        		//alert("_param.SCH_ID  => "+_param.SCH_ID);
        		var data = { SCH_ID : _param.SCH_ID}

                $a.popup({
                    url: "biz/mainschd/mainSchdPrtPopup",
                    title : "",
                    data  : data,
                    width : "930",
                    height: "600",
                    modal : "false",
                    windowpopup: true,
                    callback : function( oResult ) {
                    	//popupCallback( event.target.id, oResult);
                    }
                });
            });
        }, 
        setFileUpload : function () {
			$.PSNMUtils.setFileUploadAndGrid("SCH", "#fileupload", "#gridfile");
        },
        searchDtl : function(_param){
			var id = _param.SCH_ID;
			$.alopex.request(_TX_SEARCH, {
				data: {dataSet: {fields: {SCH_ID : id, DSM_BRD_FLAG : "R"}}},
				success: ["#form", function(res) {
					
					var gridList = res.dataSet.recordSets;
					
					$.each(gridList, function(key, data) {
						$("#"+key).alopexGrid("dataSet", data.nc_list);
					});
				}]
			});
        }
    });
    </script>
</head>
<body>
<jsp:include page="/view/layouts/default_header.jsp" flush="false" />

<div id="contents">
	<!-- title area -->
	<div class="content_title">
		<div class="ub_txt6"> <span class="txt6_img"><b>주요일정</b> <span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif"> <span class="a2">본사업무</span> <span class="a3"> > </span> <b>커뮤니티관리</b> </span> </span> </div>
	</div>
    <!-- btn area -->
    <div class="btn_area">
		<div class="ab_btn_right">
			<button id="btnPrint" type="button" data-type="button" data-theme="af-btn58" data-altname="인쇄" data-authtype="R"></button>
			<button id="btnSave" type="button" data-type="button" data-theme="af-btn4"  data-altname="저장" data-authtype="W"></button>
			<button id="btnDel"  type="button" data-type="button" data-theme="af-btn13" data-altname="삭제" data-authtype="W"></button>
			<button id="btnList" type="button" data-type="button" data-theme="af-btn14" data-altname="목록" data-authtype="R"></button>
        </div>
    </div>
	<!-- btn area end--> 
	<div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>주요일정</b></div>
	<!--view_table area -->
	<div id="print" class="view_list"> 
		<form id="form">
			<input type="hidden" id="SCH_ID" name="SCH_ID"  data-bind="value:SCH_ID"/>
			<table class="board02">
	            <colgroup>
		            <col style="width:15%"/>
		            <col style="width:35%"/>
		            <col style="width:15%"/>
		            <col style="width:*"/>
	            </colgroup>
				<tr>
					<th scope="col">제목</th>
					<td class="tleft" colspan="3">
						<label id="SCH_TITL_NM" data-bind="text:SCH_TITL_NM"></label>
					</td>
				</tr>
				<tr>
					<th scope="col">일정</th>
					<td class="tleft time" colspan="3">
						<div data-type="daterange">
							<label id="SCH_STA_DT" data-bind="text:SCH_STA_DT"></label>
							~<label id="SCH_DT" data-bind="text:SCH_DT"></label>
						</div>
					</td>
				</tr>
				<tr>
					<th scope="col">게시자</th>
					<td class="tleft"><label id="RGSTR_NM" data-bind="text:RGSTR_NM"></label></td>
					<th scope="col">게시일자</th>
					<td class="tleft"><label id="RGST_DTM" data-bind="text:RGST_DTM"></label></td>
				</tr>
				<tr>
					<td class="cont" colspan="4">
						<label data-bind="html:SCH_CTT" ></label></td>
				</tr>
			</table>
		</form>  
	</div>
	
	<!--view_list area -->
		<div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>첨부파일</b> : 하단 파일을 클릭하시면 저장 및 열기가 가능합니다.</div>
		<div id="gridfile" class="view_list" data-bind="grid:gridfile"></div>
    <!--view_댓글 area -->
		<jsp:include page="/view/layouts/cmnt_comm.jsp" flush="false">
		  	<jsp:param name="IS_MAINSCHD" value="Y" />
		</jsp:include>
</div>
<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />
	
</body>
</html>