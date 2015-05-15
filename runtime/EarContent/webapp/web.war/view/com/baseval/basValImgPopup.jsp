<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE HTML>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>영업국별/일별 접속현황</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />
    
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/vendor/jquery.ui.widget.js"></script>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/jquery.iframe-transport.js"></script>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/jquery.fileupload.js"></script>
    
    <script type="text/javascript">

    $.alopex.page({
        init : function(id, param) {
        	
        	$("#APLY_STA_DT").val(getCurrdate());
        	$("#APLY_END_DT").val(getCurrdate());
            $a.page.setEventListener();
            $a.page.setImageFileUpload();
            $a.page.setViewData();
        },
        setEventListener : function() {
            $("#btnSave").click(function(){
            	if( $.PSNM.confirm("I004", ["저장"] ) ){
            		var requestData = $.PSNMUtils.getRequestData("form");
                	
                	$.alopex.request("com.BASEVAL@PWEBBASVAL001_pUpdateWebBasValImg", {
                        data: requestData,
                        success: function(res) { 
                        	$a.close();
                        }
                    });
            	}
            });
        },
        setImageFileUpload : function() {
        	var oMyPicFileInfo = new Object();
        	$("#fileupload").fileupload({
                dataType: 'json',
                url : _FILE_HANDLER_URL + "?biz=dsm",
                done: function (e, data) {
                    $.each(data.result, function (index, fileinfo) {
                    	var regex = /\.([j|J][p|P][g|G]|[j|J][p|P][e|E][g|G]|[g|G][i|I][f|F]|[p|P][n|N][g|G])$/; 
                    	if (!regex.test(fileinfo.name)) { 
                    		$.PSNM.alert("확장자가 jpg, jpeg, gif인 파일만 등록할 수 있습니다."); 
	                    	return false; 
                    	}
                    	
                    	oMyPicFileInfo["FILE_GRP_ID"] = fileinfo.group
                    	oMyPicFileInfo["FILE_PATH"] = fileinfo.dir
                    	oMyPicFileInfo["ATCH_FILE_ID"] = fileinfo.id
                    	oMyPicFileInfo["FILE_NM"] = fileinfo.name
                    	$("#ATCH_FILE_ID").val(fileinfo.id); 
                    	$("#FILE_NM").val(fileinfo.name);
                    	$("#FILE_PATH").val(fileinfo.dir);
                    	$("#FILE_SIZE").val(fileinfo.size);
                    	
                    	var imgFileUrl = $.PSNMUtils.getDownloadUrl(oMyPicFileInfo); 
                    	$("#picture").attr("src", imgFileUrl);
                    });
                }
            });
        },
        setViewData : function() {
        	$.alopex.request("com.BASEVAL@PWEBBASVAL001_pSearchWebBasValPic", {
                success:["#form", function(res){
                	var imgFileUrl = $.PSNMUtils.getDownloadUrl2("PIC", res.dataSet.fields.ATCH_FILE_ID, "", res.dataSet.fields.FILE_PATH);
					$("#picture").attr("src", imgFileUrl);
                }]
            });
        }
    });

    </script>
</head>
<body>

<div id="contents">

    <!-- title area -->
    <div class="pop_header">
      
        <!--view_table area -->
        <div class="textAR">
        	<form id="form" onsubmit="return false;">
        	<input id="ATCH_FILE_ID" name="ATCH_FILE_ID" data-bind="value : STRD_APLY_VAL" type="hidden" />
			<input id="FILE_NM" name="FILE_NM" type="hidden" />
			<input id="FILE_PATH" name="FILE_PATH" type="hidden" />
			<input id="FILE_SIZE" name="FILE_SIZE" type="hidden" />
    		<table class="board02" style="width:100%;">
		  		<colgroup>
					<col style="width:20%;">
					<col style="*">
		 		 </colgroup>
		  		<tr>
	        		<th scope="col">적용이미지</th>
	        		<td class="tleft">
	        			<img id="picture" style="width:400px; height:290px"/>
	        		</td>
	      		</tr>
	      		<tr>
	        		<th scope="col">게시기간</th>
		        	<td class="tleft">
						<div data-type="daterange" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png">
							<input id="APLY_STA_DT" name="APLY_STA_DT" data-role="startdate" data-bind="value:APLY_STA_DT" style="width:70px;"/>
							~ <input id="APLY_END_DT" name="APLY_END_DT" data-role="enddate" data-bind="value:APLY_END_DT" style="width:70px;"/>
						</div>
					</td>
	      		</tr>
    		</table>
    		</form>
    		<div class="floatL1" style="padding-left:34%;">
		      	<div style="position:relative;">
					<span class="file-button type4"><input id="fileupload" type="file"></span>
			  	</div>&nbsp;
		      	<button id="btnSave" type="button" data-type="button" data-theme="af-btn4"  data-altname="저장" data-authtype="W"></button>
	    	</div>
  		</div>
        
    </div>

</div>

</body>
</html>