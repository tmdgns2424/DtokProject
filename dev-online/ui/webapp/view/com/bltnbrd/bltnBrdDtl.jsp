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
	<script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/jquery.cookie.js"></script>
	<script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/jquery.treeview.js"></script>
    
    <script type="text/javascript">
    
    var _param; //이 페이지로 전달된 파라미터를 저장
    var _data;  //상세 정보로 가져온 정보를 저장
    
    $.alopex.page({

        init : function(id, param) { 
            $.PSNM.initialize(id, param); //PSNM공통 초기화함수 호출            
            _param = param; 
            $a.page.setTree(param);
            $a.page.setEventListener();
            $a.page.setFileUpload();
            $a.page.setViewData();
            $.PSNMAction.setCmntData(param.data.BLTCONT_ID); // 댓글조회(이페이지로 전달된 아이디)
        },
        setEventListener : function() {
            $("#btnList").click(function(){            	
            	$a.navigate("bltnBrdList.jsp?FLAG=" + _param.SUP_BLTN_BRD_ID, _param);
            });
            $("#btnModi").click(function(){
            	$a.navigate("bltnBrdRgst.jsp", _param);
            });
            $("#btnPrev").click(function(){
            	_param.data.BLTCONT_ID = _param.PRE_BLTCONT_ID;
            	$a.navigate("bltnBrdDtl.jsp", _param);
            });
            $("#btnNext").click(function(){
            	_param.data.BLTCONT_ID = _param.NXT_BLTCONT_ID;
            	$a.navigate("bltnBrdDtl.jsp", _param);
            });
            $("#btnReply").click(function(){
            	$a.navigate("bltnBrdRejndRgst.jsp", _param);
            });
            $("#btnDelete").click(function(){
            	if( $.PSNM.confirm("I004", ["삭제"] ) ){
            		if(_data.REPLAY_CNT != "0"){
        				$.PSNM.alert("답글이 등록된 게시글은 삭제할 수 없습니다");
        				return;
        			}        			
        			if( _param.data.CMNT_CNT != "0"){
        				$.PSNM.alert("댓글이 등록된 게시글은 삭제할 수 없습니다");
        				return;
        			}
            		var bltcont_id  = _param.data != null ? _param.data.BLTCONT_ID : "";
                	var bltn_brd_id = _param.data != null ? _param.data.BLTN_BRD_ID : "";
                	$.alopex.request("com.BLTNBRD@PBLTNBRD001_pDeleteBltnBrd", {
                		data: {dataSet: {fields: {BLTCONT_ID : bltcont_id, BLTN_BRD_ID : bltn_brd_id}}},
                        success : function(res) {
                        	$a.navigate("bltnBrdList.jsp?FLAG=" + _param.SUP_BLTN_BRD_ID, _param);
                        }
                    });
            	}
            });
            $("#btnCmntSave").click(function(){
            	var id = _param.data.BLTCONT_ID; // 이페이지로 전달된 아이디
            	$.PSNMAction.saveCmntData(id, $("#cmnt")); // 댓글저장
            }); 
            $("#btnMove").click(function(){
            	$a.popup({
					url: "/view/com/bltnbrd/bltncontMovePop.jsp",
                   	data: _param,
                   	title : "게시글이동",
                   	width: $.PSNM.popWidth(800),
                   	height: $.PSNM.popHeight(600)
				});
            });
            $("#btnWeekRcmnd, #btnMthRcmnd").click(function(){            	
            	var type = $(this).data("rcmnd");
            	var typeNm = "" ;
            	if(type == "01"){
            		typeNm = "주간 추천" ;
            	}else{
            		typeNm = "월간 추천" ;
            	}
            	if( $.PSNM.confirm("I004", [typeNm] ) ){    		
            		$.alopex.request("com.BLTNBRD@PBLTNBRD001_pRcmndBltnBrd", {
                		data: {dataSet: {fields: { BLTCONT_ID : _param.data.BLTCONT_ID ,RCMND_TYP_CD : type }}},                
                        success: ['#treeform', function(res) {
                        	res.dataSet.fields.RCMND_PSBL_YN
                        	if(res.dataSet.fields.RCMND_PSBL_YN == "N"){
            					$.PSNM.alert("이미 다른 사용자에 의해 추천되었습니다.");
            				}else{
            					$.PSNM.alert("추천이 완료 되었습니다.");
            					$a.page.setViewData();
            				} 
                        }]
                    });
            	}		
            });
//             $("#btnPrint").click(function(){
//             	$.PSNMUtils.getPrint("print","cmntList");
// 			});
            $("#btnPrint").click(function(){
        		if( !((navigator.appName == 'Microsoft Internet Explorer') 
        				|| ((navigator.appName == 'Netscape') 
        						&& (new RegExp("Trident/.*rv:([0-9]{1,}[\.0-9]{0,})").exec(navigator.userAgent) != null))) ){
        			$.PSNM.alert("인쇄는 \"Microsoft Internet Explorer\" 를 사용하십시오.");
        			return false;
        		}

        		//alert("_param.data.BLTCONT_ID  => "+param.data.BLTCONT_ID);
        		var data = { BLTCONT_ID : _param.data.BLTCONT_ID
        				      , USER_ID : $.PSNM.getSession("USER_ID")}

                $a.popup({
                    url: "com/bltnbrd/bltnBrdPrtPopup",
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
        setViewData : function() { 
        	var bltcont_id  = _param.data != null ? _param.data.BLTCONT_ID : "";
        	var bltn_brd_id = _param.data != null ? _param.data.BLTN_BRD_ID : "";
        	var rgst_dtm_from = _param.data != null ? _param.RGST_DTM_FROM : "";
        	var rgst_dtm_to = _param.data != null ? _param.RGST_DTM_TO : "";
        	
        	$.alopex.request("com.BLTNBRD@PBLTNBRD001_pDetailBltnBrd", {
        		data: {dataSet: {fields: {BLTCONT_ID : bltcont_id, BLTN_BRD_ID : bltn_brd_id, DSM_BRD_FLAG : "R", RGST_DTM_FROM : rgst_dtm_from, RGST_DTM_TO : rgst_dtm_to }}},
                success:["#form", "#gridfile", function(res){ 
                	_data = res.dataSet.fields ;
                	if(_data.NXT_BLTCONT_ID){
                		_param.NXT_BLTCONT_ID=_data.NXT_BLTCONT_ID;                		
                	}else{
                		$("#btnNext").hide();
                	}
                	if(_data.PRE_BLTCONT_ID){
                    	_param.PRE_BLTCONT_ID=_data.PRE_BLTCONT_ID;                		
                   	}else{
                   		$("#btnPrev").hide();
                   	}
                	
                	$("#btnMove").hide();
                	$("#btnWeekRcmnd").hide();
                	$("#btnMthRcmnd").hide();
                	$("#btnModi").hide();
                	$("#btnDelete").hide();
                	$("#btnReply").hide();
                	
                	//작성자 본인수정 || 권한유형코드(E) 
                	var authTypCd = _param.AUTH_TYP_CD; // 게시판에 대한 권한(R:읽기, W:쓰기, E:삭제)
                	//alert(authTypCd);
        			if(_data.BLTCONT_TYP_CD=="0" && authTypCd=="E") { //권한유형코드(E) && 게시글유형코드 
        				$("#btnMove").show();
        			}
        			//추천기능사용일 경우
        			if(_data.RCMND_OBJ_YN=="Y"){
                        $("#rcmndChk1").show(); //주간 추천자, 주간 추천일
                        $("#rcmndChk2").show(); //월간 추천자, 월간 추천일
                    }
        			//주간추천버튼, 월간추천버튼
        			if(_data.WEEK_RCMND_PSBL_YN=="Y"){
        				$("#btnWeekRcmnd").show();
        			}
        			if(_data.MTH_RCMND_PSBL_YN=="Y"){
        				$("#btnMthRcmnd").show();
        			}          			
                	if (
                			( _data.RGSTR_ID == $.PSNM.getSession("USER_ID") && (authTypCd == "E" || authTypCd == "W"))
                			||
                			(authTypCd == "E") 
                	     ){ // 등록자면서 쓰기 권한이 있는 경우 수정 가능
                		$("#btnModi").show();
                	}
                	if (( _data.RGSTR_ID == $.PSNM.getSession("USER_ID") && authTypCd == "W") || authTypCd == "E"){ // 등록자면서 쓰기 권한이 있는 경우, 또는 삭제 권한이 있는 경우 삭제 가능
                		//삭제 버튼 비활성화 체크
        				if( _data.WEEK_RCMNDR_NM == "" && _data.WEEK_RCMND_DT == "" && _data.MTH_RCMNDR_NM == "" && _data.MTH_RCMND_DT == ""){
        					$("#btnDelete").show();    
        				}                		
                	}
                	//답글권한( 권한유형코드(W,E))
        			if( authTypCd=="W" || authTypCd=="E"){
        				//게시글유형코드 && REJND_PERM_YN 답글버튼 활성화
	        			if(_data.BLTCONT_TYP_CD=="0" && _data.REJND_PERM_YN=="Y"){ 
	        				$("#btnReply").show();
	        			}
        			}
        			
        			//댓글권한 ==> 수정 : 읽기 권한만 있으면 댓글 달 수 있도록
        			//if( page.getSession('AUTH_TYP_CD')=="W" || page.getSession('AUTH_TYP_CD')=="E"  || page.getSession('AUTH_TYP_CD')=="R"){        				
        			if(_data.CMNT_PERM_YN=="Y"){	
        				$("#cmntArea").show();        				
        			}else{
        				$("#cmntArea").hide(); 
        			}
        			/*}else{
        				regist.disable();
        			}*/
                }]
            });
        },
        setFileUpload : function () {
        	$.PSNMUtils.setFileUploadAndGrid("BLT", "#fileupload", "#gridfile");
        },
        setTree : function() {
        	var id = _param.data != null ? _param.SUP_BLTN_BRD_ID : "";         	
        	$.alopex.request("com.BLTNBRD@PBLTNBRD001_pSearchBltnBrdTree", {
        		data: {dataSet: {fields: {BLTN_BRD_ID : id }}},                
                success: ['#treeform', function(res) {
                	 $a.page.treeData(res.dataSet.recordSets.tree);
                }]
            });
        },
		treeData : function(param){
            
        	if( param.nc_recordCount == 0 ){
            	$.PSNM.alert("권한이 없습니다.");
            	return ;
            }
            
    		var data = param.nc_list ;
    		var sup_id = "" ;
	        var el ;
	        
            for( i=0 ; i<param.nc_recordCount ; i++){  	        
    	           	        
    	        if( data[i].BLTN_BRD_TYP_CD == "2" ){
    	            $("#tree").createNode("", {
    	            	id 	    : data[i].BLTN_BRD_ID ,
    	        	    text    : data[i].BLTN_BRD_NM,
    	        	    linkUrl : "javascript:void(getBrdList(\'" + data[i].BLTN_BRD_TYP_CD + "\',\'" + data[i].BLTN_BRD_ID + "\'));"        	   
      	        	});    	           
    	            sup_id = data[i].BLTN_BRD_ID ;
    	        }else if( data[i].BLTN_BRD_TYP_CD == "3" ){
    	        	el = $("#tree").getNode(sup_id, "id");
    	            $("#tree").createNode(el, {
    	            	id 	    : data[i].BLTN_BRD_ID ,
    	        	    text    : data[i].BLTN_BRD_NM,
    	        	    linkUrl : "javascript:void(getBrdList(\'" + data[i].BLTN_BRD_TYP_CD + "\',\'" + data[i].BLTN_BRD_ID + "\'));"        	     	        	   
      	        	}); 
    	        }  
    	        $("#"+data[i].BLTN_BRD_ID).data("SUP_BLTN_BRD_ID", data[i].SUP_BLTN_BRD_ID);
    	        $("#"+data[i].BLTN_BRD_ID).data("BLTN_BRD_ID", data[i].BLTN_BRD_ID);	              
	            $("#"+data[i].BLTN_BRD_ID).data("BLTN_BRD_NM", data[i].BLTN_BRD_NM);
            }   
            $("#tree").treeview({
       			collapsed: true
            });
            $("#tree").expandAll();
            $("#"+_param.BLTN_BRD_ID+" a").addClass("af-pressed"); //트리 클릭효과 class 추가
        }
    });
    
    function getBrdList( bltnTypCd, bltnBrdId ){
    	_param["BLTN_BRD_TYP_CD"] = bltnTypCd ;
    	_param["BLTN_BRD_ID"] 	  = bltnBrdId ;
    	$a.navigate("bltnBrdList.jsp?FLAG="+ _param.SUP_BLTN_BRD_ID, _param );
    }
    
    </script>

</head>

<body>

<jsp:include page="/view/layouts/default_header.jsp" flush="false" />

<div id="contents">

    <!-- title area -->
    <div class="content_title">
        <div class="ub_txt6">
            <span class="txt6_img"><b>게시판</b><span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif"> 
            <span class="a2">커뮤니티</span> <span class="a3"> > </span><b>게시판</b></span></span> 
        </div>
    </div>

	<div class="org_wrap">
		<form id="treeform">
		<input type="hidden" id="BLTN_BRD_ID" name="BLTN_BRD_ID"/>
			<div class="org_tree">
				<ul id="tree" data-type="tree"></ul>
			</div>
		</form>	
		<div class="org_result">
			
    	<!-- btn area -->
	    <div class="btn_area">
	    	<div class="ab_btn_left">
	            <button id="btnMove" 	  type="button" data-type="button" data-theme="af-n-btn18" data-altname="이동"     data-authtype="E"  style="display:none;"></button>
	            <button id="btnPrev" 	  type="button" data-type="button" data-theme="af-btn56" data-altname="이전"     data-authtype="E"></button>
	            <button id="btnNext" 	  type="button" data-type="button" data-theme="af-btn55" data-altname="다음"     data-authtype="E"></button>
	            <button id="btnWeekRcmnd" type="button" data-type="button" data-theme="af-n-btn19" data-altname="주간추천" data-rcmnd="01" style="display:none;"></button>
	            <button id="btnMthRcmnd"  type="button" data-type="button" data-theme="af-n-btn20" data-altname="월간추천" data-rcmnd="02" style="display:none;"></button>
	        </div>
	        <div class="ab_btn_right">
	        	<button id="btnPrint" type="button" data-type="button" data-theme="af-btn58" data-altname="인쇄" data-authtype="R"></button>
	            <button id="btnModi" 	type="button" data-type="button" data-theme="af-btn17" 	 data-altname="수정" data-authtype="W" style="display:none;"></button>
	            <button id="btnDelete" 	type="button" data-type="button" data-theme="af-btn13" 	 data-altname="삭제" data-authtype="E" style="display:none;"></button>
	            <button id="btnReply" 	type="button" data-type="button" data-theme="af-n-btn15" data-altname="답글" data-authtype="R" style="display:none;"></button>
	            <button id="btnList" 	type="button" data-type="button" data-theme="af-btn14" 	 data-altname="목록" data-authtype="R"></button>            
	        </div>
	    </div>
	    <!-- btn area end--> 
	    
	    <div class="floatL4">
        	<img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>게시글</b>       
    	</div>
	
	    <!--view_table area -->
	    <div id="print" class="view_list">
	
	        <form id="form" onsubmit="return false;">
	        <input type="hidden" id="BLTCONT_ID" name="BLTCONT_ID" data-bind="value:BLTCONT_ID"/>
	        
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
	                <td colspan="3" class="tleft"><label data-bind="text:BLTCONT_TITL_NM"></label></td>
	            </tr>
	            <tr>
	            	<th scope="col">작성자</th>
	                <td class="tleft"><label data-bind="text:NICK_NM"></label></td>
	                <th scope="col">작성일시</th>
	                <td class="tleft"><label data-bind="text:RGST_DT"></label></td>
	            </tr>
	            <tr id="rcmndChk1" style="display:none;">
	            	<th scope="col">주간 추천자</th>
	                <td class="tleft"><label data-bind="text:WEEK_RCMNDR_NM"></label></td>
	                <th scope="col">주간 추천일</th>
	                <td class="tleft"><label data-bind="text:WEEK_RCMND_DT"></label></td>
	            </tr>
	            <tr id="rcmndChk2" style="display:none;">
	            	<th scope="col">월간 추천자</th>
	                <td class="tleft"><label data-bind="text:MTH_RCMNDR_NM"></label></td>
	                <th scope="col">월간 추천일</th>
	                <td class="tleft"><label data-bind="text:MTH_RCMND_DT"></label></td>
	            </tr>
	            <tr>
	                <td colspan="4" class="cont"><label data-bind="html:BLTCONT_CTT"></label></td>
	            </tr>
	            
	            </tbody>
	            </table>
	            
	        </form>
	    </div>
	    
	
	    <!--view_list area -->
	    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>첨부파일</b> : 하단 파일을 클릭하시면 저장 및 열기가 가능합니다.</div>
	    <div id="gridfile" class="view_list" data-bind="grid:gridfile"></div>
	    
	    <!--view_댓글 area -->
	    <div id="cmntArea">
	  	<jsp:include page="/view/layouts/cmnt_comm.jsp" flush="false" />
  		</div>
  		</div>
	</div>
</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>