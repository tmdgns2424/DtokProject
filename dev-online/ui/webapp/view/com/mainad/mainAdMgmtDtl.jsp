<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
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

    var _TX_SEARCH      = "com.MAINAD@PMAINAD001_pSearchMainAdDtl";
    var _TX_SAVE        = "com.MAINAD@PMAINAD001_pSaveMainAd";
    var _TX_DELETE      = "com.MAINAD@PMAINAD001_pDeleteMainAd";
    var _param;
    $.alopex.page({
		init : function(id, param) { 
         	
			$.PSNM.initialize(id, param); //PSNM공통 초기화함수 호출
			_param = param;
            $a.page.setEventListener(); //버튼 초기화
			if(param.MAIN_AD_ID == null){
				$("#RGSTR_ID").setData({RGSTR_NM : $.PSNM.getSession("USER_ID")});
				$("#RGSTR_NM").setData({RGSTR_NM : $.PSNM.getSession("USER_NM")});
				
				$("#AD_STA_DT").val(getCurrdate());
    			$("#AD_END_DT").val(getAddDate(getCurrdate(),7));
    			$("#RGST_DTM").val(getCurrdate());
				
    			$("#LINK_URL").val("http://");
				
	            $("#btnDel").hide();
            }
            else{
				$a.page.searchDtl(param);
   			}
            $a.page.setImageFileUpload();
        },
        setEventListener : function() {
         	$("#btnList").click(function(){
			$a.back(_param);
            });

			$("#btnSave").click(function(){
	            $('#ATCH_FILE_ID').validator({
	                rule : { required: true },
	                message: {
	                    required: $.PSNM.msg('E012', ["광고 이미지"])                        // {0} 항목은 필수값입니다!
	                }
	            });
				if ( ! $.PSNM.isValid("#form") ) {
				    return false; //값 검증
				}
               	
               	if(  $.PSNM.confirm("I004", ["저장"] ) ){
               		var requestData = $.PSNMUtils.getRequestData("form");

						requestData.dataSet.fields.ORG_ID = $.PSNM.getSession("HDQT_TEAM_ORG_ID");
						requestData.dataSet.fields.ORG_NM = $.PSNM.getSession("HDQT_TEAM_ORG_NM");
    
               		$.alopex.request(_TX_SAVE, { 
											 data	: requestData,
											 success: function(res) { 
												$a.navigate("mainAdMgmtList.jsp", _param);
											 }
                	});
           		}
            });
			$("#btnDel").click(function(){
            	if(  $.PSNM.confirm("I004", ["삭제"] ) ){
            		var fileid = ($.PSNMUtils.getRequestData("form").dataSet.fields.AD_FILE_ID);
            		var id = _param.MAIN_AD_ID != null ? _param.MAIN_AD_ID : "";
                	$.alopex.request(_TX_DELETE, {
													data	: {dataSet: {fields: {MAIN_AD_ID : id ,ATCH_FILE_ID : fileid}}},
													success : function(res) {
														$a.navigate("mainAdMgmtList.jsp", _param);
													}
                    });
            	}
            });
        }, 
         
        searchDtl : function(param){
			var id = _param.MAIN_AD_ID != null ? _param.MAIN_AD_ID : "";
			$.alopex.request(_TX_SEARCH, {
											data	: {dataSet: {fields: {MAIN_AD_ID : id}}},
											success	: ["#form",  function(res) {
							                    var imgFileUrl = $.PSNMUtils.getDownloadUrl2("MAD", res.dataSet.fields.AD_FILE_ID, "", res.dataSet.fields.FILE_PATH);
							    				$("#ATCH_FILE_ID").val(res.dataSet.fields.AD_FILE_ID);
							                    $("#picture").attr("src", imgFileUrl); 
											} 
											
											
											]
			}
			
  
			);
        },
        setImageFileUpload : function() {
        	var oMyPicFileInfo = new Object();
        	$("#imgFileupload").fileupload({
                dataType: 'json',
                url : _FILE_HANDLER_URL + "?biz=mad",
                done: function (e, data) {
                    $.each(data.result, function (index, fileinfo) {
                    	var regex = /\.([j|J][p|P][g|G]|[j|J][p|P][e|E][g|G]|[g|G][i|I][f|F]|[p|P][n|N][g|G])$/; 
                    	if (!regex.test(fileinfo.name)) { 
	                    	alert("확장자가 jpg, jpeg, gif인 파일만 등록할 수 있습니다."); 
	                    	return false; 
                    	}
                    	
                    	oMyPicFileInfo["FILE_GRP_ID"] = fileinfo.group
                    	oMyPicFileInfo["FILE_PATH"] = fileinfo.dir
                    	oMyPicFileInfo["ATCH_FILE_ID"] = fileinfo.id
                    	oMyPicFileInfo["FILE_NM"] = fileinfo.name
                    	
                    	$("#ATCH_FILE_ID").val(fileinfo.id);
                    	$("#FILE_PATH").val(fileinfo.dir);
                    	$("#FILE_NM").val(fileinfo.name);
                    	$("#FILE_SIZE").val(fileinfo.size);
                    	
                    	var imgFileUrl = $.PSNMUtils.getDownloadUrl(oMyPicFileInfo); 
                    	$("#picture").attr("src", imgFileUrl);
                    });
                }
            });
        },
 	});
    
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
    <!-- btn area -->
	<div class="btn_area">
		<div class="ab_btn_right">
			<button id="btnDel"  type="button" data-type="button" data-theme="af-btn13" data-altname="삭제" data-authtype="W"></button>
			<button id="btnSave" type="button" data-type="button" data-theme="af-btn4"  data-altname="저장" data-authtype="W"></button>
			<button id="btnList" type="button" data-type="button" data-theme="af-btn14" data-altname="목록" data-authtype="R"></button>
        </div>
    </div>
    <!-- btn area end--> 
	<!-- btn area end--> 
	<div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>광고관리</b></div>
	<!--view_table area -->
    <div class="view_list"> 
		<form id="form">
			<input type="hidden" id="MAIN_AD_ID" name="MAIN_AD_ID"  data-bind="value:MAIN_AD_ID"/>
			<table class="board02">
	        	<colgroup>
		            <col style="width:12%"/>
		            <col style="width:30%"/>
		            <col style="width:10%"/>
		            <col style="width:20%"/>
		            <col style="width:10%"/>
		            <col style="width:*"/>
	            </colgroup>
				<tr>
					<th class="fontred">제목</th>
					<td class="tleft" colspan="3">
						<input id="MAIN_AD_NM" name="MAIN_AD_NM" data-bind="value:MAIN_AD_NM" data-type="textinput" data-validation-rule="{required:true}" data-validation-message="{required:$.PSNM.msg('E012', ['제목'])}" style="width:95%">
					</td>
					<th class="fontred">본사팀</th>
					<td class="tleft">
	                    <select id="HDQT_TEAM_ORG_ID" data-bind="options:options_HDQT_TEAM_ORG_ID, selectedOptions: HDQT_TEAM_ORG_ID" data-type="select" 
	                    	data-validation-rule="{required:true}"
							data-validation-message="{required:$.PSNM.msg('E012', ['본사팀'])}">
	                    	<option value="">-선택-</option>
	                    </select>
	                </td>
				</tr>
				<tr>
					<th>광고기간</th>
					<td class="tleft">
                		<div data-type="daterange" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png" >
						<input id="AD_STA_DT" name="AD_STA_DT" data-role="startdate" data-bind="value:AD_STA_DT" style="width:90px;"/>
						~ <input id="AD_END_DT" name="AD_END_DT" data-role="enddate" data-bind="value:AD_END_DT" style="width:90px;"/>
						</div>
					</td>
					<th>게시자</th>
					<td class="tleft"><label id="RGSTR_NM" data-bind="text:RGSTR_NM"></label></td>
					<th>게시일자</th>
					<td class="tleft">
						<input id="RGST_DTM" name="RGST_DTM" data-type="dateinput" data-bind="value:RGST_DTM" data-disabled="true" style="width:100px;"/>
					</td>

				</tr>
				<tr>
					<th class="fontred" style="text-align: center">
			        	<div style="position:relative; top:2px">
							<span class="file-button type3" style="display:block;float:none;margin:7px auto"><input type="file" id="imgFileupload" data-type="button"></span>
						</div>
						이미지 크기<br/> (703 X 217 픽셀)
					</th>
					<td class="tleft" colspan="5">
						<img id="picture" src="" alt="" width="703" height="217" onerror='this.src="<c:out value='${pageContext.request.contextPath}'/>/image/adminbox-sample-img.gif"'>
						<input id="AD_FILE_ID" data-type="hidden" data-bind="value:AD_FILE_ID" type="hidden"/>
						<input id="ATCH_FILE_ID" data-bind="value:ATCH_FILE_ID" type="hidden"/>
						<input id="FILE_PATH" data-type="hidden" data-bind="value:FILE_PATH" type="hidden"/>
						<input id="FILE_NM" data-type="hidden" data-bind="value:FILE_NM" type="hidden"/>
						<input id="FILE_SIZE" data-type="hidden" data-bind="value:FILE_SIZE" type="hidden"/>
					</td>
				</tr>
				<tr>
				<th class="fontred">연결 URL</th>
					<td class="tleft" colspan="5">
						<input id="LINK_URL" name="LINK_URL" data-bind="value:LINK_URL" data-type="textinput" data-validation-rule="{required:true}" data-validation-message="{required:$.PSNM.msg('E012', ['URL'])}" style="width:95%">
				</td>
			</table>
		</form>  
	</div>
</div>
<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />
</body>
</html>