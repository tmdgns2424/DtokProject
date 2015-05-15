<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>MA 지원서</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />
    
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/vendor/jquery.ui.widget.js"></script>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/jquery.iframe-transport.js"></script>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/jquery.fileupload.js"></script>

    <script type="text/javascript">
    
    var _param = null;
    $.alopex.page({
        init : function(id, param) {

        	_param = param;        	
        	
        	$.PSNM.setOrgSelectBox(); //본사팀, 본사파트, 영업국 select 객체 초기화
            $a.page.setEventListener(); //버튼 초기화
            
            $a.page.setCodeData();      //공통코드 호출
            $a.page.setImageFileUpload();
            $a.page.setDetail(param);
            $a.page.setGrid();          //그리드 초기화             

        },
        setEventListener : function() {        	
        	$("#btnList").click( gotoList );    // 목록버튼 클릭        	
        	$("#btnClose").click( gotoList ); //닫기버튼 클릭
    	
            $("#btnIntAdd").click(function(){  // 면담추가 클릭            	
            	intRsltPopup( _param);
            });
            $("#btnIntDel").click(function(){  // 면담삭제 클릭              
            	intRsltDelRow();
            });
            
        	//상태수정함수
            $("#btnReceipt").click(function(){  // 접수버튼 클릭     	
            	$a.page.updateByStaff("접수처리하시겠습니까?", "2", "12");
            });        	
            $("#btnReceiptCancel").click(function(){  // 접수취소버튼 클릭
                
            	$a.page.updateByStaff("접수취소할 경우 에이전트 계약 요청은 삭제됩니다.\n접수취소하시겠습니까?", "", "21");
            });            
            $("#btnApprove").click(function(){   // 승인버튼 클릭
            	
            	var apprMsg = "";
            	//면접완료(21)가 되지 않은 상태에서 승인클릭시 : 접수(2)상태에서 승인 클릭시
            	if( $("#CNTRT_ST_CD").val() == "2") {
            		
            		apprMsg = "면접등록이 완료되지 않았습니다.\n그래도 승인하시겠습니까?\n(국 직속 2회, 일반 3회 필수)";
            	}
            	else{
            		apprMsg = "승인하시겠습니까?";
            	}
            	
            	$a.page.updateByStaff(apprMsg, "3", "23");
            });
            $("#btnApproveCancel").click(function(){  // 승인취소버튼 클릭
            	$a.page.updateByStaff("승인취소할 경우 면접내용은 삭제됩니다.\n승인취소하시겠습니까?", "2", "32");
            });
            $("#btnReturn").click(function(){  // 반려버튼 클릭
                $a.page.updateByStaff("반려하시겠습니까?", "4", "24");
            });
            $("#btnReturnCancel").click(function(){  // 반려취소버튼 클릭-접수상태로 변경
                $a.page.updateByStaff("반려취소하시겠습니까?", "2", "42");
            });
            
            $("#btnSave").click(function(){  // 저장버튼 클릭
                
            	/*if( $.PSNM.getSession("DUTY")=='14' ) {
            		$.PSNM.alert('권한이 없습니다.');
                    return;
            	}*/
            
            	//승인(3)일 경우            
            	if( $("#CNTRT_ST_CD").val() == "3") {
            		
             		if($.PSNMUtils.isEmpty($("#AGNT_ID").val())){
                        $.PSNM.alert('에이전트를 선택하세요.');
                        $("#btnFindAgent").focus();
                        return;
                    }
            		$a.page.updateByStaff("에이전트 매핑하시겠습니까?", "3", "33");
            	}
            	//접수(2),면접완료(21)
            	else {
            		
            		//면접결과 삭제여부            			
           			var selCheck = $("#gridIntHst").alopexGrid('dataGet', {_state:{selected:true}});  //체크된 데이터
           			
           			if ( selCheck.length > 0 ) {
           				
           				/* 
           				for(var i=0; i<selCheck.length; i++) {
           					if(selCheck[i]["FLAG"] == "D") {           						
           						break;
           					}
           				} */
           				$("#gridIntHst").alopexGrid("dataDelete", {_state:{selected:true}, "FLAG":"I"}); //추가된 데이터는 화면에서 삭제
           		        $("#gridIntHst").alopexGrid("dataEdit", {_state:{deleted:true}}, {_state:{selected:true}});
           		        $("#gridIntHst table.table tr").removeClass("editing");
           		        $("#gridIntHst table.table tr").removeClass("deleted");
           		        
           				$a.page.updateByStaff("선택된 "+ selCheck.length + "개의 면접결과를 삭제하시겠습니까?", "2", "34");
                    }else{
                    	
                    	$a.page.updateByStaff("저장하시겠습니까?", "2", "12");//접수상태
                    }           		
           			
            	}
                
            });
            
            $("#btnFindAgent").click(function(){    //에이전트찾기 팝업
                
                $a.popup({
                    url: "com/popup/findAgent3Pop"
                  , width: 900
                  , height: 700
                  , windowpopup: false
                  , iframe: true
                  , title: "에이전트찾기"
                  , callback : function( oResult ) {
                      
                      if($.PSNMUtils.isNotEmpty( oResult ) ){
                    	  $("#AGNT_NM").val( oResult["AGNT_NM"] );
                          $("#AGNT_ID").val( oResult["AGNT_ID"] );
                          $("#AGNT_HDQT_PART_ORG_NM").val( oResult["HDQT_PART_ORG_NM"] );
                          $("#AGNT_SALE_DEPT_ORG_NM").val( oResult["SALE_DEPT_ORG_NM"] );
                          $("#AGNT_SALE_TEAM_ORG_NM").val( oResult["SALE_TEAM_ORG_NM"] );
                      }                          
                  }
                });
                
            });
            
            //$("#AGNT_ID").keyup( $.PSNMAction.findAgent );
            $("#AGNT_ID").keyup( $.PSNMAction.findAgent2 );

        },
        setCodeData : function() {

       		$.PSNMUtils.setCodeData([
                { t:'code',  'elemid' : 'DSM_RETL_TYPE', 'codeid' : 'DSM_RETL_TYPE', 'header' : '-선택-', 'ADD_INFO_01' : 'Y' },   //판매형태                
                { t:'org2',  'elemid' : 'HDQT_PART_ORG_ID', 'header' : '-전체-' },  //본사파트
                { t:'org3',  'elemid' : 'SALE_DEPT_ORG_ID', 'header' : '-전체-' },  //영업국
                { t:'org4',  'elemid' : 'SALE_TEAM_ORG_ID', 'header' : '-전체-' },  //영업팀
            ]);
        	
        },
        setImageFileUpload : function() {
            var oMyPicFileInfo = new Object();
            $("#fileupload").fileupload({
                dataType: 'json',
                url : _FILE_HANDLER_URL + "?biz=cnt",
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
                        $("#PIC_CHG_YN").val("Y");
                    });
                }
            });
        },
        setDetail : function(param){
        	
        	if($.PSNMUtils.isNotEmpty(param.CNTRT_MGMT_NUM)){
        		
        		$.alopex.request('agn.AGNTMGMT@PAGENTCNTRT001_pDetailAgentCntrt', {

        			data: { dataSet : { fields : { CNTRT_MGMT_NUM : param.CNTRT_MGMT_NUM } } },
            		
            		success : ["#detailForm", "#gridSchship", "#gridCareer", "#gridIntHst", function(res){
            			
            			var imgFileUrl = $.PSNMUtils.getDownloadUrl2("PIC", res.dataSet.fields.ATCH_FILE_ID, "", res.dataSet.fields.FILE_PATH);
                        $("#picture").attr("src", imgFileUrl);
                        
                        var CNTRT_ST_CD = null;
                        if( $.PSNMUtils.isNotEmpty(_param.cntrtStCd) && _param.cntrtStCd == "readOnly"){
                        	CNTRT_ST_CD = "readOnly";
                        }else{
                        	CNTRT_ST_CD = res.dataSet.fields.CNTRT_ST_CD
                        }
            			$a.page.setViewBtn( CNTRT_ST_CD );  //계약상태코드에 따른 버튼 활성화처리
            			
            			$("#CNTRT_MGMT_NUM").val(param.CNTRT_MGMT_NUM);
            			$("#CNTRT_ST_CD").val(res.dataSet.fields.CNTRT_ST_CD)
            			
            		}]
            	});
        	}
        },
        setGrid : function () {        	
        	$("#gridSchship").alopexGrid({   //학력사항
                pager : false,
                columnMapping : [
                    { columnIndex : 0, key : "HST_SEQ",       title : "NO.",        align : "center", width : "30px" },
                    { columnIndex : 1, key : "APLY_STA_DT",   title : "시작일",     align : "center", width : "80px" },
                    { columnIndex : 2, key : "APLY_END_DT",   title : "종료일",     align : "center", width : "80px" },
                    { columnIndex : 3, key : "SCHSHIP_CL_NM", title : "학력구분",   align : "center", width : "80px" },
                    { columnIndex : 4, key : "SCHSHIP_CL_CD", title : "학력코드",   align : "center", width : "60px", hidden:true },
                    { columnIndex : 5, key : "SCHL_NM",       title : "학교명",     align : "center", width : "80px" },
                    { columnIndex : 6, key : "SCHL_DEPT_NM",  title : "학과(전공)", align : "center", width : "80px" },
                    { columnIndex : 7, key : "SCHL_DR_NM",    title : "학위",       align : "center", width : "80px" },
                    { columnIndex : 8, key : "SCHL_DR_CD",    title : "학위코드",   align : "center", width : "60px", hidden:true }
                ]                                                                            
            });        	
        	$("#gridCareer").alopexGrid({  //경력사항
                pager : false,
                columnMapping : [
                    { columnIndex : 0, key : "HST_SEQ",        title : "NO.",        align : "center", width : "30px" },
                    { columnIndex : 1, key : "APLY_STA_DT",    title : "시작일",     align : "center", width : "80px" },
                    { columnIndex : 2, key : "APLY_END_DT",    title : "종료일",     align : "center", width : "80px" },
                    { columnIndex : 3, key : "CAREER_CL_NM",   title : "경력구분",   align : "center", width : "80px" },
                    { columnIndex : 4, key : "CAREER_CL_CD",   title : "경력코드",   align : "center", width : "60px", hidden:true },
                    { columnIndex : 5, key : "CAREER_CO_NM",   title : "직장명",     align : "center", width : "80px" },
                    { columnIndex : 6, key : "CAREER_CHRG_OP", title : "담당업무",   align : "center", width : "80px" },
                    { columnIndex : 7, key : "RPSTY_NM",       title : "직위",       align : "center", width : "80px" },
                    { columnIndex : 8, key : "RPSTY_CD",       title : "직위코드",   align : "center", width : "60px", hidden:true }
                ]                                                                            
            });
        	$("#gridIntHst").alopexGrid({  //면접결과
                pager : false,
                rowClickSelect : false,
                rowInlineEdit : true,
                columnMapping : [
					{ columnIndex : 0, key : "FLAG",        title : "F",           align : "center", width : "30px",   refreshBy:true, 
					    value : function(value, data) {
					        if (data._state.added) return 'I';
					        if (data._state.deleted) return 'D';
					        //if (data._state.edited) return 'U';
					        return ''; 
					    }
					},
					{ columnIndex : 1,  selectorColumn : true, width : "20px" },
                    { columnIndex : 2,  key : "HST_SEQ",         title : "NO",          align : "center", width : "30px", hidden:true },
                    { columnIndex : 3,  key : "INT_DT",          title : "면접일자",    align : "center", width : "80px"},
                    { columnIndex : 4,  key : "INT_STA_TM",      title : "시작시간",    align : "center", width : "80px", hidden:true },
                    { columnIndex : 5,  key : "INT_END_TM",      title : "종료시간",    align : "center", width : "80px", hidden:true },
                    { columnIndex : 6,  key : "INTR_ID",         title : "면접자ID",    align : "center", width : "60px", hidden:true },
                    { columnIndex : 7,  key : "INTR_NM",         title : "면접관명",    align : "center", width : "80px" },
                    { columnIndex : 8,  key : "RETL_CLASS_NM",   title : "면접관직책",  align : "center", width : "80px" },
                    { columnIndex : 9,  key : "HDQT_PART_ORG_ID",title : "본사파트코드",align : "center", width : "80px", hidden:true },                    
                    { columnIndex :10,  key : "HDQT_PART_ORG_NM",title : "본사파트",    align : "center", width : "60px" },                    
                    { columnIndex :11,  key : "SALE_DEPT_ORG_ID",title : "영업국코드",  align : "center", width : "80px", hidden:true },                    
                    { columnIndex :12,  key : "SALE_DEPT_ORG_NM",title : "영업국명",    align : "center", width : "60px" },                    
                    { columnIndex :13,  key : "SALE_TEAM_ORG_ID",title : "영업팀코드",  align : "center", width : "80px", hidden:true },                    
                    { columnIndex :14,  key : "SALE_TEAM_ORG_NM",title : "영업팀명",    align : "center", width : "60px" },                    
                    { columnIndex :15,  key : "RGSTR_ID",        title : "등록자ID",    align : "center", width : "80px", hidden:true },                    
                    { columnIndex :16,  key : "RGSTR_NM",        title : "등록자명",    align : "center", width : "60px", hidden:true },
                    { columnIndex :17,  key : "INT_SUIT_NM",     title : "적합여부",    align : "center", width : "80px"},
                    { columnIndex :18,  key : "RGST_DTM",        title : "등록일시",    align : "center", width : "80px"},                    
                    { columnIndex :19,  key : "INT_CMNT",        title : "면접내용",    align : "center", width : "60px", hidden:true },
                    { columnIndex :20,  key : "DUTY_NM",         title : "사용자권한",  align : "center", width : "60px", hidden:true },
                    { columnIndex :21,  key : "DUTY_CD",         title : "사용자권한코드",  align : "center", width : "60px", hidden:true }
                ],
	        	on : {
	                cell : {
	                    "click" : function(data, eh, e) {
	                    	
                        
	                        //alert($.PSNM.getSession("DUTY") +":"+data.DUTY_CD);	                            
	                        //임직원(임직원,국장,팀장조회), 국장(국장,팀장조회), 팀장(팀장조회)
 	                    	if( (!( $.PSNM.getSession("DUTY")=='14' || $.PSNM.getSession("DUTY")=='16' || $.PSNM.getSession("DUTY")=='19' || $.PSNM.getSession("DUTY")=='20')) || 
	                    		  ( $.PSNM.getSession("DUTY")=='14' && (data.DUTY_CD == "14" || data.DUTY_CD == "16" || data.DUTY_CD == "19" || data.DUTY_CD == "20") ) ||
	                    		  (($.PSNM.getSession("DUTY")=='16' || $.PSNM.getSession("DUTY")=='19' || $.PSNM.getSession("DUTY")=='20') && (data.DUTY_CD == "16" || data.DUTY_CD == "19" || data.DUTY_CD == "20") ) ) {
 	                    		
 	                    		var param = $("#gridIntHst").getData({selectOptions:true});
                                param.CNTRT_MGMT_NUM = data.CNTRT_MGMT_NUM;   
                                param.HST_SEQ = data.HST_SEQ;     
                                intRsltPopup( param );
	                    		
	                    	}

	                    }
	                }
	            }
            });
                                                                             
        },
        setViewBtn : function(cntrtStCd){

        	//배정정보설정
        	if($.PSNMUtils.isEmpty( $("#HDQT_PART_ORG_ID").val() )){        	
        		var _default_options_ = [ { value: "", text: "-선택-"} ]; //일단 화면에 있는 모든 옵션들을 초기화함.
        		$('#SALE_DEPT_ORG_ID').setData({options_SALE_DEPT_ORG_ID : _default_options_}).setSelected("-선택-");
        		$('#SALE_TEAM_ORG_ID').setData({options_SALE_TEAM_ORG_ID : _default_options_}).setSelected("-선택-");
        	}
        	
        	$("#pictureDiv").hide();       // 파일업로드버튼
        	
        	$("#btnReceipt").hide();        // 접수버튼
        	$("#btnReceiptCancel").hide();  // 접수취소버튼
            $("#btnApprove").hide();        // 승인버튼
            $("#btnApproveCancel").hide();  // 승인취소버튼
            $("#btnReturn").hide();         // 반려버튼            
            $("#btnReturnCancel").hide();   // 반려취소버튼
            $("#btnSave").hide();           // 저장   
            
            $("#btnIntAdd").hide();         // 면접결과 추가버튼
            $("#btnIntDel").hide();         // 면접결과 삭제버튼
            
            $("#btnFindAgent").hide();      // 에이전트찾기 버튼
            $("#AGNT_ID").setEnabled(false);//에이전트ID입력            
            
            //관리조직 활성화
            $("#HDQT_PART_ORG_ID").setEnabled(true);
            $("#SALE_DEPT_ORG_ID").setEnabled(true);
            $("#SALE_TEAM_ORG_ID").setEnabled(true);
            
            //DSM국장, DSM팀장
            if( $.PSNM.getSession("DUTY")=='14' || $.PSNM.getSession("DUTY")=='16' || $.PSNM.getSession("DUTY")=='19' || $.PSNM.getSession("DUTY")=='20' ) {
            	//관리조직 disable
            	$("#HDQT_PART_ORG_ID").setEnabled(false);
            	$("#SALE_DEPT_ORG_ID").setEnabled(false);
            	$("#SALE_TEAM_ORG_ID").setEnabled(false);
            	
            	//에이전트코드매핑영역
            	$("#agentDiv").hide();
            	
            	if( cntrtStCd == "2" || cntrtStCd == "21"){
            		$("#btnIntAdd").show();  //면접결과추가버튼
            		$("#btnIntDel").show();  //면접결과삭제버튼
            		$("#btnSave").show();           //저장
            	}
            	
            }
            
            //DSM국장, DSM팀장
            //if( $.PSNM.getSession("DUTY")=='14' || $.PSNM.getSession("DUTY")=='16' || $.PSNM.getSession("DUTY")=='19' || $.PSNM.getSession("DUTY")=='20' || $.PSNM.getSession("DUTY")=='15' || $.PSNM.getSession("DUTY")=='17' || $.PSNM.getSession("DUTY")=='18' || ) {
            	
            //}
            //임직원
            else {
       
          
	        	//요청(1),접수(2),면접완료(21),계약승인(3),코드발급완료(5),반려(4),회원가입완료(6)        	
	        	switch(cntrtStCd){
		        	//요청
		        	case "1"  : $("#btnReceipt").show();       //접수버튼        	
					        	$("#btnReceiptCancel").show(); //접수취소버튼
					        	
					        	$("#pictureDiv").show();   //파일업로드버튼
		        			    break;
		        	//접수
		        	case "2"  : $("#btnReceiptCancel").show(); //접수취소버튼
		                        $("#btnApprove").show();       //승인버튼
		                        $("#btnReturn").show();        //반려버튼
		                        $("#btnSave").show();          //저장
		                        
		                        $("#btnIntAdd").show();    //면접결과추가버튼
		                        $("#btnIntDel").show();  //면접결과삭제버튼
		                        
		                        $("#pictureDiv").show();   //파일업로드버튼
		                        
		        			    break;
		        	//면접완료
		            case "21" : $("#btnReceiptCancel").show();  //접수취소버튼
		                        $("#btnApprove").show();        //승인버튼
		                        $("#btnReturn").show();         //반려버튼
		                        $("#btnSave").show();           //저장
		                        
		                        $("#btnIntAdd").show();    //면접결과추가버튼
		                        $("#btnIntDel").show();  //면접결과삭제버튼
		                        
		                        $("#pictureDiv").show();   //파일업로드버튼
		                        break;            
		    		//승인
		        	case "3" : $("#btnApproveCancel").show();  //승인취소버튼
		        	           $("#btnSave").show();           //저장
		        	           
		        	           $("#btnFindAgent").show();      //에이전트찾기버튼
		        	           $("#AGNT_ID").setEnabled(true); //에이전트ID입력
		        	           
		            	       break;
		            //반려
		            case "4" : $("#btnReturnCancel").show();    //반려취소버튼
		            
					           //관리조직 disable
			                   $("#HDQT_PART_ORG_ID").setEnabled(false);
			                   $("#SALE_DEPT_ORG_ID").setEnabled(false);
			                   $("#SALE_TEAM_ORG_ID").setEnabled(false);
		                       break;
		            
		            case "readOnly" :	
		            	$(":button").hide();
		            	$(".file-button").hide();	            	
		            	$("[data-type='textinput']").setEnabled(false);
		            	$("[data-type='select']").setEnabled(false);
		            	$("[data-type='textarea']").setEnabled(false);
		            	$(":checkbox").hide();
		            break;
		        	default : 
			        		//관리조직 disable
			                $("#HDQT_PART_ORG_ID").setEnabled(false);
			                $("#SALE_DEPT_ORG_ID").setEnabled(false);
			                $("#SALE_TEAM_ORG_ID").setEnabled(false);
			              break; 
	        	}
        	
            }//end if
            
        	return true;

        },
        updateByStaff : function(msg, cntrtStsCd, cntrtChkCd){
        	
        	//필수입력항목 체크:접수,승인
        	if( cntrtStsCd == "2" || cntrtStsCd == "3" ) {
        		
        		if( cntrtChkCd != "42" ) {
        			
        			if(!$.PSNM.isValid("detailForm")){
                        return false;
                    }	
        		}
                        		
        	}
        	
        	if(!confirm(msg)){
        		return;  
        	}
        	
        	$("#CNTRT_ST_CD").val(cntrtStsCd);
            $("#CNTRT_ST_FLAG").val(cntrtChkCd);
        	
        	//승인자의견 입력팝업:승인(3),반려(4)일 경우 팝업호출
        	if( cntrtStsCd == "3" || cntrtStsCd == "4" ) {
        		
        		$a.popup({
                    url: "com/popup/aprvrCmntPop"
                  , width: 400
                  , height: 270
                  , windowpopup: false
                  , iframe: true
                  , title: "승인자의견"
                  , callback : function( oResult ) {
                	  
                	  if($.PSNMUtils.isNotEmpty( oResult ) ){
                		  $("#APRVR_CMNT").val( oResult.APRVR_CMNT );
                	  }
                	  	  
                	  updateAgentCntrt( cntrtStsCd );
                  }
                });
        		
        		
        	}else{
        		
        		updateAgentCntrt( cntrtStsCd );
        	}
        	

        	return true;
        }
    });
    
    function updateAgentCntrt( cntrtStsCd ){    	
    	
        
    	//폼과 첨부파일 그리드 모두 합쳐 request 데이터를 생성함. 그리드가 1개이상 가능함.
        var requestData = $.PSNMUtils.getRequestData("detailForm","gridIntHst");

        $.alopex.request('agn.AGNTMGMT@PAGENTCNTRT001_pUpdateAgentCntrt', {
                          
            data: requestData,

            success : function(res) {

                if ( ! $.PSNM.success(res) ) {
                	return;
                }
                
                $.PSNM.alert("I000"); //정상적으로 처리되었습니다.
                
                if( cntrtStsCd == "" ) {
                    
                	$a.close({"result":"success"}); //데이타 삭제로 리스트화면 이동:접수취소
                }else{
                    
                    $a.page.setDetail(_param);  
                }
                
             }
        });
    }
    
    function gotoList() {
        $a.close();
    }
    
    function intRsltPopup( param ) {
        
        param.SALE_DEPT_ORG_ID = $("#SALE_DEPT_ORG_ID").val();  
        
    	$a.popup({
            url: "com/popup/interviewResultPop"
          , data: param
          , width: 800
          , height: 570
          , windowpopup: false
          , iframe: true
          , title: "면접결과"
          , callback : function( oResult ) {
        	  //팝업종료시 화면 refresh
        	  if ( $.PSNMUtils.isNotEmpty( oResult ) && "success"==oResult["result"] ) {
        		  $a.page.setDetail(param);
        	  }
        	  
          }
        });
    }
    
    function intRsltDelRow() {
        var selCheck = $("#gridIntHst").alopexGrid('dataGet', {_state:{selected:true}});
        if ( null==selCheck || selCheck.length<1 ) {
             $.PSNM.alert("E011", ["선택된"]);
             return false;
        }
        /* 
        if ( ! $.PSNM.confirm("I004", ["삭제"]) ) {
            return false;
        } */
 
        $("#gridIntHst").alopexGrid("dataDelete", {_state:{selected:true}, "FLAG":"I"}); //추가된 데이터는 화면에서 삭제
        $("#gridIntHst").alopexGrid("dataEdit", {_state:{deleted:true}}, {_state:{selected:true}});
        $("#gridIntHst table.table tr").removeClass("editing");
        $("#gridIntHst table.table tr").removeClass("deleted");

    }
    
    function onAgentFound( oResult ){    

    	$("#AGNT_NM").val( oResult["AGNT_NM"] );
        $("#AGNT_ID").val( oResult["AGNT_ID"] );
        $("#AGNT_HDQT_PART_ORG_NM").val( oResult["HDQT_PART_ORG_NM"] );
        $("#AGNT_SALE_DEPT_ORG_NM").val( oResult["SALE_DEPT_ORG_NM"] );
        $("#AGNT_SALE_TEAM_ORG_NM").val( oResult["SALE_TEAM_ORG_NM"] );
    }
    
    </script>
</head>

<body>

<div id="Wrap">
	
	<!-- title area -->
    <div class="pop_header">
    
	<!-- btn area -->
	<div class="btn_area">	
		<div class="ab_btn_left">
            <button id="btnReceipt"       type="button" data-type="button" data-theme="af-btn92" style="display:none;" data-altname="접수"></button>
            <button id="btnReceiptCancel" type="button" data-type="button" data-theme="af-btn7"  style="display:none;" data-altname="접수취소"></button>
            <button id="btnApprove"       type="button" data-type="button" data-theme="af-btn5"  style="display:none;" data-altname="승인"></button>
            <button id="btnApproveCancel" type="button" data-type="button" data-theme="af-btn93" style="display:none;" data-altname="승인취소"></button>
            <button id="btnReturn"        type="button" data-type="button" data-theme="af-btn6"  style="display:none;" data-altname="반려"></button>            
            <button id="btnReturnCancel"  type="button" data-type="button" data-theme="af-btn94" style="display:none;" data-altname="반려취소"></button>
        </div>        
		<div class="ab_btn_right">
			<button id="btnSave" type="button" data-type="button" data-theme="af-btn4"  style="z-index:1" data-altname="저장"></button>
            <button id="btnList" type="button" data-type="button" data-theme="af-btn14" style="z-index:1" data-altname="목록"></button>      
		</div>
	</div>
	
	<div class="view_list">
	
    <form id="detailForm" onsubmit="return false;">
		
		<input id="CNTRT_MGMT_NUM" type="hidden" data-type="hidden" />
		<input id="CNTRT_ST_CD" type="hidden" data-type="hidden" />
		<input id="CNTRT_ST_FLAG" type="hidden" data-type="hidden" />	
		<input id="agentSearchCheck" data-bind="value:agentSearchCheck" value="2" type="hidden" data-type="hidden" />	
		
		<div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>인적사항</b> </div>

        <div id="detailDiv" class="textAR">
            <table id="detailTable" class="board02">
                <colgroup>
                    <col style="width:18%">
                    <col style="width:12%">
                    <col style="width:30%">
                    <col style="width:12%">
                    <col style="width:*">
                </colgroup>
                <tbody>
                <tr>
                    <td rowspan="6">
                        <img id="picture" src="" alt="" width="114" height="154" onerror='this.src="<c:out value='${pageContext.request.contextPath}'/>/image/adminbox-sample-img.gif"'>
                        <br><br>                        
                        <div id="pictureDiv" style="position:relative; top:2px;left:35px;">
                            <span class="file-button type4"><input type="file" id="fileupload" data-type="button"></span>
                        </div>
                        <input id="ATCH_FILE_ID" name="ATCH_FILE_ID" data-bind="value:ATCH_FILE_ID" type="hidden" />
                        <input id="FILE_NM"   name="FILE_NM"   data-bind="value:FILE_NM" type="hidden" />
                        <input id="FILE_PATH" name="FILE_PATH" data-bind="value:FILE_PATH" type="hidden" />
                        <input id="FILE_SIZE" name="FILE_SIZE" data-bind="value:FILE_SIZE" type="hidden" />
                        <input id="PIC_CHG_YN" name="PIC_CHG_YN" data-bind="value:PIC_CHG_YN" type="hidden" />
                    </td>
                    <th height="40" scope="col"></th>
                    <td class="tleft">
                    </td>
                    <th scope="col">MA지원 요청일시</th>
                    <td class="tleft">
                        <label data-bind="text:RGST_DT"></label>
                    </td>
                </tr>
                <tr>
                    <th height="40" scope="col">성명(한글)</th>
                    <td class="tleft">
                        <label data-bind="text:NAME_KOR"></label>
                    </td>
                    <th scope="col">성명(한자)</th>
                    <td class="tleft">
                        <label data-bind="text:NAME_HAN"></label>
                    </td>
                </tr>
                <tr>
                    <th height="40" scope="col">생년월일</th>
                    <td class="tleft">
                        <label data-bind="text:BIRTH_DT"></label>
                    </td>
                    <th scope="col">결혼유무</th>
                    <td class="tleft">
                        <label data-bind="text:WEDD_YN"></label>
                    </td>
                </tr>
                <tr>
                    <th height="40" scope="col">자택전화</th>
                    <td class="tleft">
                        <label data-bind="text:PHON_NUM1"></label> - <label data-bind="text:PHON_NUM2"></label> - <label data-bind="text:PHON_NUM3"></label>
                    </td>
                    <th scope="col">이동전화</th>
                    <td class="tleft">
                        <label data-bind="text:MBL_PHON_NUM1"></label> - <label data-bind="text:MBL_PHON_NUM2"></label> - <label data-bind="text:MBL_PHON_NUM3"></label>
                    </td>
                </tr>
                <tr>
                    <th height="40" scope="col">현주소</th>
                    <td class="tleft" colspan="3">
                        <label data-bind="text:POST_NUM"></label>
		                <label data-bind="text:ADDR_1"></label>
		                <label data-bind="text:ADDR_2"></label>
                    </td>
                </tr>
                <tr>
                    <th height="40" scope="col">이메일</th>
                    <td class="tleft" colspan="3">
                        <label data-bind="text:EMAIL_ID"></label>@<label data-bind="text:EMAIL_DMN_NM"></label>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>

		<!-- 학력사항 area -->
		<div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>학력사항</b> </div>
		<div id="gridSchship" data-bind="gridSchship" data-ui="ds"></div>
		
		<!-- 경력사항 area -->
		<div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>경력사항</b> </div>
		<div id="gridCareer" data-bind="gridCareer" data-ui="ds"></div>
		
		<!-- 자기소개 area -->
		<div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>자기소개(성격 및 경력 중심)</b> </div>
		<textarea id="SELF_INTDC" data-bind="value:SELF_INTDC" cols="40" rows="6" data-type="textarea" data-disabled="false" ></textarea>
		
		<!-- 월별판매계획 area -->
		<div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>이동전화 년간 판매계획</b> </div>
        <div class="view_table">
            <table data-type="table">
                <colgroup>
                    <col style="width:13%;" />
                    <col style="width:12%;" />
                    <col style="width:13%;" />
                    <col style="width:12%;" />
                    <col style="width:13%;" />
                    <col style="width:12%;" />
                    <col style="width:13%;" />
                    <col style="width:12%;" />
                </colgroup>
                <thead>
                    <!-- <tr>
                      <th colspan="8">이동전화 년간 판매계획</th>
                    </tr> -->
                    <tr>
                      <th colspan="2">1~3차월</th>
                      <th colspan="2">4~6차월</th>
                      <th colspan="2">7~12차월</th>
                      <th colspan="2">1년 누계</th>
                    </tr>
                    <tr>
                      <th>월평균</th>
                      <th>계</th>
                      <th>월평균</th>
                      <th>계</th>
                      <th>월평균</th>
                      <th>계</th>
                      <th>월평균</th>
                      <th>계</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>
                            <input id="QUART1_MTH_AVG_QTY" data-bind="value:QUART1_MTH_AVG_QTY" data-type="textinput" data-disabled="true" style="width:90%;text-align:center">
                        </td>
                        <td>
                            <input id="QUART1_MTH_TOT_QTY" data-bind="value:QUART1_MTH_TOT_QTY" data-type="textinput" data-disabled="true" style="width:90%;text-align:center">
                        </td>
                        <td>
                            <input id="QUART2_MTH_AVG_QTY" data-bind="value:QUART2_MTH_AVG_QTY" data-type="textinput" data-disabled="true" style="width:90%;text-align:center">
                        </td>
                        <td>
                            <input id="QUART2_MTH_TOT_QTY" data-bind="value:QUART2_MTH_TOT_QTY" data-type="textinput" data-disabled="true" style="width:90%;text-align:center">
                        </td>
                        <td>
                            <input id="SHYR_MTH_AVG_QTY" data-bind="value:SHYR_MTH_AVG_QTY" data-type="textinput" data-disabled="true" style="width:90%;text-align:center">
                        </td>
                        <td>
                            <input id="SHYR_MTH_TOT_QTY" data-bind="value:SHYR_MTH_TOT_QTY" data-type="textinput" data-disabled="true" style="width:90%;text-align:center">
                        </td>
                        <td>
                            <input id="YR_MTH_AVG_QTY" data-bind="value:YR_MTH_AVG_QTY" data-type="textinput" data-disabled="true" style="width:90%;text-align:center">
                        </td>
                        <td>
                            <input id="YR_MTH_TOT_QTY" data-bind="value:YR_MTH_TOT_QTY" data-type="textinput" data-disabled="true" style="width:90%;text-align:center">
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        		
		<!-- 판매계획 area -->
		<div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>판매계획 (목표 공략 시장 및 판매 전략)</b> </div>
		<textarea id="SALE_PLAN" data-bind="value:SALE_PLAN" cols="40" rows="6" data-type="textarea" data-disabled="false" ></textarea>
                      
		<!-- 기타사항 area -->
		<div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>기타사항(선택)</b> </div>
        <div class="textAR">
            <table id="searchTable" class="board02">
                <colgroup>
                    <col style="width:13%">
                    <col style="width:30%">
                    <col style="width:10%">
                    <col style="width:*">
                    <col style="width:10%">
                    <col style="width:*">
                </colgroup>
                <tbody>
                <tr>
                    <th height="40" scope="col">생활신조</th>
                    <td class="tleft" colspan="5">
                        <label data-bind="text:GUIDE_PRCPL"></label>
                    </td>
                </tr>
                <tr>
                    <th height="40" scope="col">취미/특기</th>
                    <td class="tleft">
                        <label data-bind="text:HOBBY_SKILL"></label>
                    </td>
                    <th>신장</th>
                    <td class="tleft">
                        <label data-bind="text:HEIGHT"></label> cm
                    </td>
                    <th>체중</th>
                    <td class="tleft">
                        <label data-bind="text:WEIGHT"></label> kg
                    </td>
                </tr>
                <tr>
                    <th height="40" scope="col">주 활동지역</th>
                    <td class="tleft">
                        <label data-bind="text:MAIN_ACTV_AREA"></label>
                    </td>
                    <th>판매형태</th>
                    <td class="tleft" colspan="3">
                        <select id="DSM_RETL_TYPE" name="DSM_RETL_TYPE" data-bind="options: options_DSM_RETL_TYPE, selectedOptions: DSM_RETL_TYPE" data-type="select" data-disabled="true" data-wrap="false"></select>
                        <label data-bind="text:DSM_RETL_TYPE_RMK"></label>
                    </td>
                </tr>
                <tr>
                    <th height="40" scope="col">활동지인 이름</th>
                    <td class="tleft" colspan="5">
                        <label data-bind="text:ACTV_ACQN_NM"></label>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
        		
		<!-- 관리조직 area -->
		<div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>관리조직</b> </div>
		<div class="view_table">
		
			<table data-type="table">
		    <colgroup>
			    <col style="width:100px;"></col>
			    <col style="width:100px;"></col>
			    <col style="width:100px;"></col>
			    <col style="width:100px;"></col>
			    <col style="width:100px;"></col>
			    <col style="width:100px;"></col>
		    </colgroup>
			<thead class="table-body">
		    <tr >
		        <th >희망본사파트명</th>
		        <th >희망영업국</th>
		        <th >희망영업팀</th>
		        <th >지정본사파트명</th>
		        <th >지정영업국</th>
		        <th >지정영업팀</th>
		    </tr>
		    </thead>
		    <tbody class="table-body">
			<tr class="row-odd">
		        <td>
		            <input id="REQ_HDQT_PART_ORG_NM" data-bind="value:REQ_HDQT_PART_ORG_NM" data-type="textinput" data-disabled="true" style="width:95%;text-align:center">
		        </td>
		        <td>
		            <input id="REQ_SALE_DEPT_ORG_NM" data-bind="value:REQ_SALE_DEPT_ORG_NM" data-type="textinput" data-disabled="true" style="width:95%;text-align:center">
		        </td>
		        <td>
		            <input id="REQ_SALE_TEAM_ORG_NM" data-bind="value:REQ_SALE_TEAM_ORG_NM" data-type="textinput" data-disabled="true" style="width:95%;text-align:center">
		        </td>
		        <td>
		            <select id="HDQT_PART_ORG_ID" data-type="select" data-bind="options:options_HDQT_PART_ORG_ID, selectedOptions:HDQT_PART_ORG_ID" data-wrap="false" style="width:100%;"
		                    data-validation-rule="{required:true}"
                            data-validation-message="{required:$.PSNM.msg('E012', ['지정본사파트명'])}">
                       <option value="">-전체-</option>
                    </select>
		        </td>
		        <td>
		            <select id="SALE_DEPT_ORG_ID" data-type="select" data-bind="options:options_SALE_DEPT_ORG_ID, selectedOptions:SALE_DEPT_ORG_ID" data-wrap="false" style="width:100%;"
		                    data-validation-rule="{required:true}"
                            data-validation-message="{required:$.PSNM.msg('E012', ['지정영업국'])}">
                        <option value="">-전체-</option>
                    </select>
		        </td>
		        <td>
		            <select id="SALE_TEAM_ORG_ID" data-type="select" data-bind="options:options_SALE_TEAM_ORG_ID, selectedOptions:SALE_TEAM_ORG_ID" data-wrap="false" style="width:100%;"
		                    data-validation-rule="{required:true}"
                            data-validation-message="{required:$.PSNM.msg('E012', ['지정영업팀'])}">
                        <option value="">-전체-</option>
                    </select>
		        </td>
	        </tr>
		    </tbody>
	        </table>
	        
	    </div>
		
		<!-- 면접결과 area -->
		<div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>면접결과</b>
            <div class="ab_pos1">
                <button id="btnIntAdd" data-type="button" data-theme="af-btn16" data-altname="추가"></button>
                <button id="btnIntDel" data-type="button" data-theme="af-btn28" data-altname="삭제"></button>
                
            </div>
            <div id="gridIntHst" data-bind="gridIntHst" data-ui="ds"></div>
		</div>
		
		<!-- 최종 배치조직 area -->
		<div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>최종 배치조직</b> </div>
		<div class="view_table">
        
            <table data-type="table">
            <colgroup>
                <col style="width:120px;"></col>
                <col style="width:120px;"></col>
                <col style="width:120px;"></col>
                <col style="width:100px;"></col>
                <col style="width:100px;"></col>
                <col style="width:130px;"></col>
                <col style="width:*"></col>
            </colgroup>
            <thead class="table-body">
            <tr >
                <th >본사파트</th>
                <th >영업국명</th>
                <th >영업팀명</th>
                <th >처리상태</th>
                <th >승인자</th>
                <th >승인일</th>
                <th >승인자 의견</th>
            </tr>
            </thead>
            <tbody class="table-body">
            <tr class="row-odd">
                <td>
                    <input id="HDQT_PART_ORG_NM" data-bind="value:HDQT_PART_ORG_NM" data-type="textinput" data-disabled="true" style="width:95%;text-align:center">
                </td>
                <td>
                    <input id="SALE_DEPT_ORG_NM" data-bind="value:SALE_DEPT_ORG_NM" data-type="textinput" data-disabled="true" style="width:95%;text-align:center">
                </td>
                <td>
                    <input id="SALE_TEAM_ORG_NM" data-bind="value:SALE_TEAM_ORG_NM" data-type="textinput" data-disabled="true" style="width:95%;text-align:center">
                </td>
                <td>
                    <input id="CNTRT_ST_NM" data-bind="value:CNTRT_ST_NM" data-type="textinput" data-disabled="true" style="width:95%;text-align:center">
                </td>
                <td>
                    <input id="APRVR_NM" data-bind="value:APRVR_NM" data-type="textinput" data-disabled="true" style="width:95%;text-align:center">
                </td>
                <td>
                    <input id="APRV_DTM" data-bind="value:APRV_DTM" data-type="textinput" data-disabled="true" style="width:95%;text-align:center">
                </td>
                <td>
                    <input id="APRVR_CMNT" data-bind="value:APRVR_CMNT" data-type="textinput" data-disabled="true" style="width:95%"/>
                </td>
            </tr>
            </tbody>
            </table>
            
        </div>      
        
        
		<!-- 에이전트 코드 매핑 area -->
		<div id="agentDiv">
		
		<div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>에이전트 코드 매핑</b> </div>
		<div class="view_table">
        
            <table data-type="table">
            <colgroup>
                <col style="width:150px;"></col>
                <col style="width:120px;"></col>
                <col style="width:120px;"></col>
                <col style="width:100px;"></col>
                <col style="width:100px;"></col>
                <col style="width:100px;"></col>
                <col style="width:100px;"></col>
            </colgroup>
            <tr >
                <th >에이전트코드</th>
                <th >에이전트명</th>
                <th >본사파트</th>
                <th >영업국명</th>
                <th >영업팀명</th>
                <th >처리자</th>
                <th >처리일</th>
            </tr>
            <tr class="tleft">
                <td>
                    <input id="AGNT_ID" data-bind="value:AGNT_ID" data-type="textinput" data-disabled="true" data-callback="onAgentFound" style="width:70%;text-align:center">
                    <!-- <input id="btnFindAgent" type="button" data-type="button" class="searchButton"> -->
                    <input id="btnFindAgent" type="button" data-type="button" data-theme="af-n-btn4">
                </td>
                <td>
                    <input id="AGNT_NM" data-bind="value:AGNT_NM" data-type="textinput" data-disabled="true" style="width:95%;text-align:center">
                </td>
                <td>
                    <input id="AGNT_HDQT_PART_ORG_NM" data-bind="value:AGNT_HDQT_PART_ORG_NM" data-type="textinput" data-disabled="true" style="width:95%;text-align:center">
                </td>
                <td>
                    <input id="AGNT_SALE_DEPT_ORG_NM" data-bind="value:AGNT_SALE_DEPT_ORG_NM" data-type="textinput" data-disabled="true" style="width:95%;text-align:center">
                </td>
                <td>
                    <input id="AGNT_SALE_TEAM_ORG_NM" data-bind="value:AGNT_SALE_TEAM_ORG_NM" data-type="textinput" data-disabled="true" style="width:95%;text-align:center">
                </td>
                <td>
                    <input id="AGENT_OPR_NM" data-bind="value:AGENT_OPR_NM" data-type="textinput" data-disabled="true" style="width:95%;text-align:center;">
                </td>
                <td>
                    <input id="AGENT_OP_DTM" data-bind="value:AGENT_OP_DTM" data-type="textinput" data-disabled="true" style="width:95%;text-align:center;">
                </td>
            </tr>
            </table>

        </div>
        </div>
        
        <p class="floatL2">
            <input id="btnClose" name="btnClose" type="button"  data-type="button" data-theme="af-n-btn23" data-altname="닫기">
        </p>
        
	</form>
	</div>	
	</div>
  
</div>

</body>
</html>
