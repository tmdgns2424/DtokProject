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
            _param = param;           	
          	$("#SUP_BLTN_BRD_ID").val(_param.SUP_BLTN_BRD_ID);
          	$("#BLTN_BRD_ID").val(_param.data.BLTN_BRD_ID);
          	$("#ORGL_BLTCONT_ID").val(_param.data.BLTCONT_ID);            
            
            $a.page.setEventListener();
            $a.page.setFileUpload();           
            $a.page.setViewData();
            //alert(_param.AUTH_TYP_CD);
            if (_param.AUTH_TYP_CD == "W" || _param.AUTH_TYP_CD == "E")	{
            	$("#btnSave").show();
            }else{
            	$("#btnSave").hide();	
            }
        },
        setEventListener : function() {
        	
            $("#btnList").click(function(){	
            	$a.navigate("bltnBrdList.jsp?FLAG=" + _param.SUP_BLTN_BRD_ID, _param);
            });         	
        	
            $("#btnSave").click(function(){
            	// 폼 검증 1 : 속성으로 지정된 것
            	if ( !$.PSNM.isValid("#form") ) {
				    return false; //값 검증
				}
            	// 폼 검증 2 : 추가적인 검증이 필요하면 여기에 구현            	
            	if(!$("input:radio[name='REJND_PERM_YN']").is(":checked")){
					$.PSNM.alert("답글허용은 필수사항 입니다.");
					$("#REJND_PERM_Y").focus();
					return;
				}
            	if(!$("input:radio[name='CMNT_PERM_YN']").is(":checked")){
					$.PSNM.alert("덧글허용은 필수사항 입니다.");
					$("#CMNT_PERM_Y").focus();
					return;
				}
            	if(!$("input:radio[name='SCRT_NUM_SET_YN']").is(":checked")){
					$.PSNM.alert("비밀번호 설정은 필수사항 입니다.");
					$("#SCRT_NUM_SET_Y").focus();
					return;
				}
            	       	
            	if( $.PSNM.confirm("I004", ["저장"] ) ){
            		var requestData = $.PSNMUtils.getRequestData("form", "gridfile");
                	
                	$.alopex.request("com.BLTNBRD@PBLTNBRD001_pInsetBltnBrdReply", {
                        data: requestData,
                        success: function(res) { 
                            $.PSNM.alert("게시물이 등록 되었습니다.");
                        	$a.navigate("bltnBrdList.jsp?FLAG="+_param.SUP_BLTN_BRD_ID, _param);
                        }
                    });
            	}
            });
        	        	 
            $("#btnFileDel").click(function(){
            	$.PSNMUtils.delFile();
            });           
        }, 
        setViewData : function() {
        	var bltcont_id  = _param.data != null ? _param.data.BLTCONT_ID : "";
        	var bltn_brd_id = _param.data != null ? _param.data.BLTN_BRD_ID : "";
        	var _config = { 
                	height : '300px'
            };       	
        	if(bltcont_id != ""){
        		
        		//비밀번호 설정가능 여부
            	$.alopex.request("com.BLTNBRD@PBLTNBRD001_pCheckBltnBrdScrtNum", {
            		data: {dataSet: {fields: {BLTN_BRD_ID : bltn_brd_id }}},
                    success:["#form",  function(res) {                	
                    	if(res.dataSet.fields.SCRT_NUM_SET_YN == "N"){
            				$("#SCRT_NUM_SET_N").attr("checked", true);
            				$("input[name^=SCRT_NUM_SET_]").attr("disabled", true);
            			} else {
            				$("#SCRT_NUM_SET_Y").attr("checked", true);
            			}  
                    }]
                });   			
        		
            	$.alopex.request("com.BLTNBRD@PBLTNBRD001_pDetailBltnBrd", {
            		data: {dataSet: {fields: {BLTCONT_ID : bltcont_id, BLTN_BRD_ID : bltn_brd_id, DSM_BRD_FLAG : "W" }}},
                    success:["#form1",  function(res) {                	
                    	var gridList = res.dataSet.recordSets;                    	
                    	// 초기값설정
                    	$("#NICK_NM").val($.PSNM.getSession("USER_NM"));
                    	$("#BLTCONT_CTT").ckeditor(_config);
                    	$("#ANNCE_N").attr("checked", true);
                    	$("input[name^=ANNCE_]").attr("disabled", true);
                    	$("#REJND_PERM_Y").attr("checked", true);
                    	$("#CMNT_PERM_Y").attr("checked", true);
                    	$("#RGST_DT").val(getCurrdate());
                    	$("#BLTCONT_TITL_NM").val("[답글] " + res.dataSet.fields.BLTCONT_TITL_NM );
                        /* 
                    	$.each(gridList, function(key, data) {
                        	$("#"+key).alopexGrid("dataSet", data.nc_list);
                        });   */
                    }]
                });
        	}      	  		
        },       
        setFileUpload : function () {  
        	// BRD? BLT? 확인 필요
        	$.PSNMUtils.setFileUploadAndGrid("BLT", "#fileupload", "#gridfile"); 
        }
        
    });    
    
    </script>

</head>

<body>

<jsp:include page="/view/layouts/default_header.jsp" flush="false" />

<div id="contents">
    
    <!-- title area -->
    <div class="content_title">
        <div class="ub_txt6">
            <span class="txt6_img"><b id="sub-title">게시판</b>
                <span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif">
                <span class="a2">커뮤니티</span> <span class="a3"> > </span> <span class="a4"><b>게시판</b></span> 
            </span>
        </div>
    </div>

    <!-- btn area -->
    <div class="btn_area">       
        <div class="ab_btn_right">
            <button id="btnSave" data-type="button" data-theme="af-btn4"  data-authtype="W" data-altname="저장"></button>          
            <button id="btnList" data-type="button" data-theme="af-btn14" data-authtype="R" data-altname="목록"></button>
        </div>
    </div>
    <!-- btn area end--> 
    
    <!--view_list area -->
    <div class="floatL4">
        <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>답글</b>       
    </div>
    
    <!--view_table area -->
    <div class="view_list">

        <form id="form">
        <input id=ORGL_BLTCONT_ID name="ORGL_BLTCONT_ID" type="hidden" data-bind="value:BLTCONT_ID" data-type="hidden" /> 
        <input id=BLTN_BRD_ID name="BLTN_BRD_ID" type="hidden" data-bind="value:BLTN_BRD_ID" data-type="hidden" /> 
        <input id=SUP_BLTN_BRD_ID name="SUP_BLTN_BRD_ID" type="hidden" data-bind="value:SUP_BLTN_BRD_ID" data-type="hidden" />
            <table class="board02" width="100%" >
        	<colgroup>
	            <col style="width:15%"/>
	            <col style="width:30%"/>
	            <col style="width:15%"/>
	            <col style="width:*"/>
            </colgroup>
            <tr>
                <th scope="col" class="psnm-required" style="width:100px;">제목</th>
                <td colspan="3" class="tleft">
                    <input id="BLTCONT_ID" name="BLTCONT_ID" type="hidden" data-bind="value:BLTCONT_ID" data-type="hidden" /> 
                    <input id="BLTCONT_TITL_NM" name="BLTCONT_TITL_NM" data-bind="value:BLTCONT_TITL_NM" data-type="textinput" style="width:95%" value=""
                    	   data-validation-rule="{required:true}" 
	                       data-validation-message="{required:$.PSNM.msg('E012', ['제목'])}"/>
                </td>
            </tr>
            <tr>
                <th scope="col">공지여부</th>
                <td class="tleft">
                    <input id="ANNCE_Y" type="radio" data-type="radio" data-bind="checked:ANNCE_YN" name="ANNCE_YN" value="Y" />
                    <label for="radioId">Y</label>
                    <input id="ANNCE_N" type="radio" data-type="radio" data-bind="checked:ANNCE_YN" name="ANNCE_YN" value="N" />
                    <label for="radioId2">N</label><br/>
                </td>
                <th scope="col">공지기간</th>
                <td class="tleft time">                    
                    <div data-type="daterange">
						<input id="ANNCE_STA_DT" name="ANNCE_STA_DT" data-role="startdate" data-bind="value:ANNCE_STA_DT" style="width:100px;"/> ~ 
						<input id="ANNCE_END_DT" name="ANNCE_END_DT" data-role="enddate" data-bind="value:ANNCE_END_DT" style="width:100px;"/>
					</div>
                </td>                
            </tr>
            <tr>
                <th scope="col">작성자</th>
                <td class="tleft">
                    <input id="NICK_NM" name="NICK_NM" data-type="textinput" data-bind="value:NICK_NM" style="width:120px" data-disabled="true"/>
                </td>                
                <th scope="col">작성일자</th>
                <td class="tleft time">
                    <input id="RGST_DT" name="RGST_DT" data-type="dateinput" data-bind="value:RGST_DT" data-disabled="true"/>
                </td>
            </tr>
            <tr>
                <th scope="col">답글 허용</th>
                <td class="tleft">
                    <input id="REJND_PERM_Y" type="radio" data-type="radio" data-bind="checked:REJND_PERM_YN" name="REJND_PERM_YN" value="Y" />
                    <label for="radioId">Y</label>
                    <input id="REJND_PERM_N" type="radio" data-type="radio" data-bind="checked:REJND_PERM_YN" name="REJND_PERM_YN" value="N" />
                    <label for="radioId2">N</label><br/>
                </td>
                <th scope="col" >덧글 허용</th>
                <td class="tleft">
                    <input id="CMNT_PERM_Y" type="radio" data-type="radio" data-bind="checked:CMNT_PERM_YN" name="CMNT_PERM_YN" value="Y" />
                    <label for="radioId">Y</label>
                    <input id="CMNT_PERM_N" type="radio" data-type="radio" data-bind="checked:CMNT_PERM_YN" name="CMNT_PERM_YN" value="N" />
                    <label for="radioId2">N</label><br/>
                </td>                
            </tr>
            <tr>
                <th scope="col">비밀번호 설정</th>
                <td colspan="3" class="tleft">
                    <input id="SCRT_NUM_SET_Y" type="radio" data-type="radio" data-bind="checked:SCRT_NUM_SET_YN" name="SCRT_NUM_SET_YN" value="Y" />
                    <label for="radioId">Y</label>
                    <input id="SCRT_NUM_SET_N" type="radio" data-type="radio" data-bind="checked:SCRT_NUM_SET_YN" name="SCRT_NUM_SET_YN" value="N" />
                    <label for="radioId2">N</label><br/>
                </td>                             
            </tr>
            <tr>
                <td colspan="4" class="tleft">
                    <textarea id="BLTCONT_CTT" name="BLTCONT_CTT" data-type="textarea" data-bind="value:BLTCONT_CTT" rows="10" cols="80" 
                              style='overflow: auto; width: 100%;'
                              data-validation-rule="{required:true}" 
	                       	  data-validation-message="{required:$.PSNM.msg('E012', ['답변내용'])}"></textarea>
                </td>
            </tr>
            </table>
        </form>
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
    
    <div class="floatL4">
        <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>원게시글</b>       
    </div>
    <div class="view_list">
    
        <form id="form1">        
            <table class="board02" style="width:100%;" >
            <tr>
                <th scope="col" style="width:100px;">제목</th>
                <td colspan="5" class="tleft">                   
                    <label data-bind="text:BLTCONT_TITL_NM"></label>
                </td>
            </tr>
            <tr>
                <th scope="col" style="width:100px;">작성자</th>
                <td class="tleft" colspan="2">                   
                    <label data-bind="text:NICK_NM"></label>
                </td>
                <th scope="col" style="width:100px;">작성일자</th>
                <td class="tleft" colspan="2">                   
                    <label data-bind="text:RGST_DT"></label>
                </td>
            </tr>            
            <tr>
	            <td colspan="5" class="tleft"><label data-bind="html:BLTCONT_CTT"></label></td>
	        </tr>
            </table>
        </form>
    </div>

</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>