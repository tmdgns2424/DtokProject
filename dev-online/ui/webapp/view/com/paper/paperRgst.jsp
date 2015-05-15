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
    var _mode = "";
    var _param;
    var add = "";
    
    $.alopex.page({
        init : function(id, param) { 
            $.PSNM.initialize(id, param); //PSNM공통 초기화함수 호출
            _param = null; //이 페이지로 전달된 파라미터를 저장

            $a.page.setEventListener(); //페이지내 버튼에 이벤트 핸들러 매핑
			$a.page.setGrid();
            $a.page.setFileUpload();
            $a.page.setValidators();
            if($.PSNMUtils.isNotEmpty(param.USER_ID)){
            	memberView(param);
            }
         },
        setEventListener : function() {
            $("#CONTENT").ckeditor();

            $("#btnSend").click( SendPaper );
            $("#btnChart").click( ChartView );
            $("#btnFileDel").click(function(){
            	$.PSNMUtils.delFile();
            });
            $("#btnDel").click(function(){                                                                          // 삭제시  
            	
            	var oRecord = $("#grid").alopexGrid( "dataGet" , { _state : { selected : true } } );
        		if (oRecord.length == 0) {
        			$.PSNM.alert("E021", ["삭제할 행을"]);
                    return;
                }
        		
        		
            	if( $.PSNM.confirm("I004", ["삭제"] ) ){
                    $("#grid").alopexGrid("dataDelete", {_state:{selected:true}});                                   // 체크된인원 그리드에서 지움
            	}
            });
        }, //end-of-setEventListener
        setGrid : function() {
            $("#grid").alopexGrid({
                        pager: false,
                        //rowSingleSelect : false,
                        rowClickSelect : false,
                        rowInlineEdit : true,
                        height : 100,
                        columnMapping : 
		         [   //컬럼맵핑     
	                    {
	                        columnIndex : 0, width : "4%",
	                        selectorColumn : true
	                    },
	                    {
	                        columnIndex : 1, key : "HDQT_PART_ORG_NM", title : "본사파트", align: "center", width: "16%"
	                    },
	                    {
	                        columnIndex : 2, key : "SALE_DEPT_ORG_NM", title : "영업국명", align: "center", width: "16%"
	                    },
	                    {
	                        columnIndex : 3, key : "SALE_TEAM_ORG_NM", title : "영업팀명",  align: "center", width: "16%"
	                    },
	                    {
	                        columnIndex : 4, key : "AGNT_ID", title : "에이전트코드" , align: "center", width: "16%" 
	                    },
	                    {
	                        columnIndex : 5, key : "RPSTY_NM", title : "직책명", align: "center", width: "16%"
	                    },
	                    {
	                        columnIndex : 6, key : "USER_NM", title : "에이전트명", align: "center", width: "16%"
	                    },
	                    {
	                        columnIndex : 7, key : "FLAG", hidden : true
	                    },
	                    {
	                        columnIndex : 8, key : "USER_ID", hidden : true
	                    },
                ],
                on : {
                    data : {
                        changed : function(type) {
                            var len = $("#grid").alopexGrid('pageInfo').dataLength;
                            if(len >= 5 ) {
                                $("#grid").alopexGrid('updateOption', {height:200});
                            } else {
                                $("#grid").alopexGrid('updateOption', {height:null});                        // 자동높이기능
                            }
                        }
                    }
                },
            });
        },   
        setFileUpload : function () {
            $.PSNMUtils.setFileUploadAndGrid("PAP", "#fileupload", "#gridfile");
        },
        setValidators : function() {
            $('#RCV_USER_ID').validator({
                rule : { required: true },
                message: {
                    required: $.PSNM.msg('E011', ["받는사람에 선택된"]) //{0} 데이터가 없습니다!
                }
            });

        }
        
        
        
    });

     function SendPaper() {
        if ( !$.PSNM.isValid("form") ) {
            return false;
        }
		var oRecord = $("#grid").alopexGrid( "dataGet" ,{"FLAG":"I"});
		if(oRecord.length<1){
			alert("받는사람이 존재하지 않습니다.");
			return false; 
		}
        //폼과 첨부파일 그리드 모두 합쳐 request 데이터를 생성함. 그리드가 1개이상 가능함.
        var requestData = $.PSNMUtils.getRequestData("form", "grid","gridfile");
        $.alopex.request('com.PAPER@PPAPERMGMT001_pInsertPaper', {
            data: requestData,
            success: function(res) { 
                $a.navigate("sndPaper.jsp", _param);
            }
        });
    }  
    
    function ChartView() {
		var duty =($.PSNM.getSession("DUTY")); 
	  	if(duty<14){
				$a.popup({
			            url: "/view/com/paper/paperRcvSelPop1.jsp"
			          , data: {}
					  , width: $.PSNM.popWidth(1000)
				      , height: $.PSNM.popHeight(800)
			          , windowpopup: false
			          , iframe: true
			          , title: "조직도"
			          , callback : function(data) {
			        	  memberView(data);
			                $("#TITLE").focus();
			          }
			        });
				 }
		  else{
				$a.popup({
			            url: "/view/com/paper/paperRcvSelPop2.jsp"
			          , data: {}
					  , width: $.PSNM.popWidth(900)
				      , height: $.PSNM.popHeight(700)
			          , windowpopup: false
			          , iframe: true
			          , title: "조직도"
			          , callback : function(data) {
			                memberView(data);
			                $("#TITLE").focus();
			          }
			        });
		  }

    }  
    function closeConfirm(oReturn) {
        $a.close(oReturn);
    }    
    function memberView(data){       
    	
    	var data;
    	
    	if(!$.isArray(data)) {
    		data = new Array(data);
    	}
 		   	
        if (null!=data && data.length>0) {
            for(var i=0; i<data.length; i++) {
                var userId = data[i]["USER_ID"];
                var arr = $("#grid").alopexGrid('dataGet', {USER_ID: userId});
                if (arr.length>0) {
                	$.PSNM.alert(data[i]["USER_NM"]+"님은 이미 추가 되었습니다.");
                }else {
                    data[i]["FLAG"] = "I";
                    $("#grid").alopexGrid("dataAdd", data[i]);
                    
                    $("#grid").alopexGrid("startEdit");
                    $("#grid").alopexGrid("endEdit");
                }
            }
        }
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
        </div>
    </div>
    <!-- btn area end--> 
    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>쪽지내용</b></div>

    <!--view_table area -->
    <div class="view_list">
        <form id="form">
            <table class="board02" style="table-layout:fixed;" >
            <colgroup>
	            <col style="width:10%"/>
	            <col style="width:*"/>
            </colgroup>
            <tr >
                <th scope="col">제목</th>
				<td class="tleft">
                    <input id="TITLE" name="TITLE" data-bind="value:TITLE" data-type="textinput" 
                           data-validation-rule="{required:true, minlength:5}" 
                           data-validation-message="{required:'제목을 반드시 입력하세요!', minlength:'제목을 5글자 이상 입력하세요!'}" style="width:95%" value="">
                </td>
            </tr>
            <tr>
                <th >받는사람</th>
                <td class="rr" >
                      <span class="fright aright" style="width:40%;" >
                        <button type="button" id="btnChart" data-type="button" data-theme="af-btn16" data-altname="추가"></button>
                        <button type="button" id="btnDel" data-type="button" data-theme="af-btn28" data-altname="삭제"></button>
                    </span>
<!--                       <div id="grid" data-bind="grid:grid" style="padding:10px"></div>
 -->                   <div id="grid" class="view_list" data-bind="grid:grid" data-ui="sndData"></div>
               
                </td>
            </tr> 
            <tr>
                            <td colspan="2">
                                <textarea id="CONTENT" name="CONTENT" data-type="textarea" data-bind="value:CONTENT" rows="10" cols="80" 
                                        data-validation-rule="{required:true}" 
                                        data-validation-message="{required:$.PSNM.msg('E012', ['내용'])}" 
                                        style='overflow: auto; width: 100%;'></textarea>
                            </td>
            </tr>
            </table>
        </form>
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
    <div id="gridfile" class="view_list" data-bind="grid:gridfile" data-ui="ds"></div>
     

</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>
