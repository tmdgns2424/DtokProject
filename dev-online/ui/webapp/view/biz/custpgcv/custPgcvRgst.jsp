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
			
            $("#RCV_DT").val( dateFormat(null, 'isoDate') );
            $("#RCV_CTT").ckeditor();
            $a.page.setEventListener();
            $a.page.setCodeData();
            $a.page.setFileUpload();           
        },
        setEventListener : function() {
        	$("#RCV_TM").change( function(){
        		if(this.value.length == 1){
        			this.value = "0"+this.value;
        		}
        	});
        	$("#RCV_MM").change( function(){
        		if(this.value.length == 1){
        			this.value = "0"+this.value;
        		}
        	}); 
        	$("#OP_CLS_TM").change( function(){
        		if(this.value.length == 1){
        			this.value = "0"+this.value;
        		}
        	});
        	$("#OP_CLS_MM").change( function(){
        		if(this.value.length == 1){
        			this.value = "0"+this.value;
        		}
        	});            	
        	$("#AGNT_NM").keyup( $.PSNMAction.findAgent );
        	$("#btnSave").click(function(){
        		if ( ! $.PSNM.isValid("#form") ) {
    			    return false; //값 검증
    			}
        		/*
        		if( $.PSNMUtils.isEmpty($("#SALE_DTM").val()) ){
        			$.PSNM.alert("접수 매출번호가 올바르지 않습니다.");
        			return false;
        		}
        		*/
        		var rtnVal = isMa();

        		if( $.PSNMUtils.isEmpty( rtnVal ) ){
        			$.PSNM.alert("판매 당시 에이전트 소속정보가 없습니다.");
        			return false;
        		}
 
        		if( rtnVal=="1" && !$.PSNM.confirm("I004", ["저장"] ) ){
        			return false;
        		}
        		
        		if( rtnVal=="0" && !$.PSNM.confirm("I004", ["판매 당시 직책이 MA/ S-MA가 아닙니다. 그래도 저장"] ) ){
        			return false;
        		}        		
				
        		var requestData = $.PSNMUtils.getRequestData("form", "gridfile");
            	$.alopex.request("biz.CUSTPGCV@PCUSTPGCV001_pSaveCustPgcv", {
            		data: requestData,
                    success: function(res) {
                    	 if ( ! $.PSNM.success(res) ) { //서버측 FAIL응답
                    		 return false;
                    	 }
                    	$a.navigate("custPgcvList.jsp", _param);                     
                    }
                });
            	
        	});
        	$("#btnList").click(function(){
            	$a.back(_param);
        	});

        	$("#SALE_MGMT_NUM").keyup(function(){
        		if( event.which != 13 && $.PSNMUtils.isEmpty(this.value) ){
       		    	$("#SALE_DT").setEnabled(true);
    		    	$("#CUST_NM").setEnabled(true);
    		    	$("#SVC_NUM1").setEnabled(true);
    		    	$("#SVC_NUM2").setEnabled(true);
    		    	$("#SVC_NUM3").setEnabled(true);
    		    	$("#AGNT_NM").setEnabled(true);					
        		}
            	if ( event.which == 13 ) {
	           		if( $.PSNMUtils.isEmpty(this.value) ){
	           			 $.PSNM.alert("접수 매출번호를 입력하세요.");
	           			return false;
	           		}
	           		$.alopex.request("biz.CUSTPGCV@FPOPUPSALEINFO001_fSearchSaleInfo", {
	               		data: {dataSet: {fields: {"RCV_MGMT_NUM" : this.value, "page":"1", "page_size":"1"}}},
	                       success:["#form", function(res) {
	                       	 if ( ! $.PSNM.success(res) ) { //서버측 FAIL응답
	                       		 return false;
	                       	 }
	                       	 if( res.dataSet.recordSets.gridSale.nc_recordCount != 0){	                     		 
	                       		 $("#form").setData(res.dataSet.recordSets.gridSale.nc_list[0]);
	                       		 var reg = /(^\d{4})(\d{2})(\d{2})(.*)/;
	            				 $("#SALE_DT").val( res.dataSet.recordSets.gridSale.nc_list[0].SALE_DT.replace(reg, '$1' + '-' + '$2'+'-'+'$3'));
	            				 /*
	            				 reg = /(^\d{3})(\d{3,4})(\d{4})/;
	            				 $("#SVC_NUM").val( res.dataSet.recordSets.gridSale.nc_list[0].SVC_NUM.replace(reg, '$1' + '-' + '$2'+'-'+'$3') );
	            				 */	            					            				 
	            				 $("#AGNT_NM").val( res.dataSet.recordSets.gridSale.nc_list[0].AGNT_NM );
	            				 $("#CUST_NM").val( res.dataSet.recordSets.gridSale.nc_list[0].CUST_NM );
	            				 
            		    		 $("#SALE_DT").setEnabled(false);
            		    		 $("#CUST_NM").setEnabled(false);
            		    		 $("#SVC_NUM1").setEnabled(false);
            		    		 $("#SVC_NUM2").setEnabled(false);
            		    		 $("#SVC_NUM3").setEnabled(false);
            		    		 $("#AGNT_NM").setEnabled(false);    	            				 
	                       	 }else{
	                       		 $.PSNM.alert("접수 매출번호가 올바르지 않습니다.");
	                        	 $("#SALE_DT").val( "" );
	            				 $("#SVC_NUM1").val( "" );
	            				 $("#SVC_NUM2").val( "" );
	            				 $("#SVC_NUM3").val( "" );
	            				 $("#AGNT_NM").val( "" );
	            				 $("#AGNT_ID").val( "" );
	            				 $("#CUST_NM").val( "" );
	            				 $("#HDQT_TEAM_ORG_NM").val( "" );
	            				 $("#HDQT_PART_ORG_NM").val( "" );
	            				 $("#SALE_DEPT_ORG_NM").val( "" );
	            				 $("#SALE_DEPT_ORG_ID").val( "" );
	            				 $("#SALE_TEAM_ORG_NM").val( "" );
	            				 $("#SALE_TEAM_ORG_ID").val( "" );    
	                       	 }
	                       }]
	                });
            	}
            });        	
            $("#btnFileDel").click(function(){
            	$.PSNMUtils.delFile();
            });        	
        	$("#btnSaleMgmtNum").click( openPopup );
        },
        setCodeData : function() {
            $.PSNMUtils.setCodeData([
                { t:'code',  'elemid' : 'RCV_OWNR_CD', 'codeid' : 'DSM_RCV_OWNR_CD', 'header' : '-선택-' },
                { t:'code',  'elemid' : 'PGVC_TYP_CD', 'codeid' : 'DSM_PGVC_TYP_CD', 'header' : '-선택-' },
                { t:'code',  'elemid' : 'PROD_TYP_CD', 'codeid' : 'DSM_FAX_UNIT_TYP_CD', 'header' : '-선택-' }
            ]);
        },
        setFileUpload : function () {
        	$.PSNMUtils.setFileUploadAndGrid("CST", "#fileupload", "#gridfile");
        }        
    });
    
    function openPopup( event ){
    	var url, title, width, height, windowpopup=false, param=null;
    	
    	switch( event.target.id ){
		    case "btnSaleMgmtNum":   
				url = "com/popup/saleSelPopup";
				title = "매출선택";
				width = "1100";
				height = "750";
		    break;
    	}
    	
        $a.popup({
            url: url,
            title : title,
            data  : param,
            width : width,
            height: height,
            windowpopup: windowpopup,
            callback : function( oResult ) {
            	popupCallback( event.target.id, oResult);
            }
        });
    }
    
    function popupCallback( div, oResult ){    	
    	switch( div ){
		    case "btnSaleMgmtNum":   
				$("#form").setData( oResult )
				            
        		var reg = /(^\d{4})(\d{2})(\d{2})(.*)/;
				$("#SALE_DT").val( oResult.SALE_DTM.replace(reg, '$1' + '-' + '$2'+'-'+'$3'));
				/*
				reg = /(^\d{3})(\d{3,4})(\d{4})/;
				$("#SVC_NUM").val( oResult.SVC_NUM.replace(reg, '$1' + '-' + '$2'+'-'+'$3') );
				*/				
				
				$("#SALE_DT").setEnabled(false);
				$("#CUST_NM").setEnabled(false);
				$("#SVC_NUM1").setEnabled(false);
				$("#SVC_NUM2").setEnabled(false);
				$("#SVC_NUM3").setEnabled(false);
				$("#AGNT_NM").setEnabled(false); 
		    break;
		}
    }
    
    function onAgentFound(oResult) {
	    var data = { AGNT_NM : oResult["AGNT_NM"], AGNT_ID : oResult["AGNT_ID"] 
			 		 , HDQT_TEAM_ORG_NM : oResult["HDQT_TEAM_ORG_NM"]
			 		 , HDQT_PART_ORG_NM : oResult["HDQT_PART_ORG_NM"]
        			 , SALE_DEPT_ORG_ID : oResult["SALE_DEPT_ORG_ID"]			    
		    		 , SALE_DEPT_ORG_NM : oResult["SALE_DEPT_ORG_NM"]
	    			 , SALE_TEAM_ORG_ID : oResult["SALE_TEAM_ORG_ID"]
		    		 , SALE_TEAM_ORG_NM : oResult["SALE_TEAM_ORG_NM"]};

		$("#form").setData( data );
    }
    
    function isMa(){
    	var rtnVal;
		var requestData = $.PSNMUtils.getRequestData("form", "gridfile");
    	$.alopex.request("biz.CUSTPGCV@PCUSTPGCV001_pSearchIsMa", {
    		data: requestData,
    		async : false,
            success: function(res) {
            	 if ( ! $.PSNM.success(res) ) { //서버측 FAIL응답
            		 return false;
            	 }   
            	 rtnVal = res.dataSet.fields.IS_MA;
            }
        });
    	
    	return rtnVal;
    }
    </script>

</head>

<body>


<jsp:include page="/view/layouts/default_header.jsp" flush="false" />

<!-- contents area -->
<div id="contents">

    <!-- title area -->
    <div class="content_title">
        <div class="ub_txt6">
            <span class="txt6_img"><b>고객민원관리</b><span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif">
            <span class="a2">본사업무</span> <span class="a3"> > <b>고객민원관리</b></span></span> 
        </div>
    </div>
    
    <!-- btn area -->
    <div class="btn_area">
        <div class="ab_btn_right">
            <button id="btnSave" type="button" data-type="button" data-theme="af-btn4"  data-altname="저장" data-authtype="W"></button>
            <button id="btnList" type="button" data-type="button" data-theme="af-btn14" data-altname="목록" data-authtype="R"></button>
        </div>
    </div>
    <!-- btn area end-->
    
	<!--view_table area -->
    <div class="view_list">
	
	    <form id="form" onsubmit="return false;">
	    
	    	<div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"/><b>접수정보</b></div>
	        <table class="board02" style="width:100%;">
	        	<colgroup>
		            <col style="width:15%"/>
		            <col style="width:35%"/>
		            <col style="width:15%"/>
		            <col style="width:*"/>
	            </colgroup>
	        	<tr>
	            	<th scope="col" class="fontred">접수일시</th>
					<td class="tleft">
						<input id="RCV_DT" name="RCV_DT" data-bind="value:RCV_DT" data-type="dateinput" style="width:70px;" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png"
					      		data-validation-rule="{required:true}" 
								data-validation-message="{required:$.PSNM.msg('E012', ['접수일시'])}">
						<input id="RCV_TM" name="RCV_TM" data-bind="value:RCV_TM" data-type="textinput" size="2" data-keyfilter-rule="digits" maxlength="2"
					      		data-validation-rule="{required:true, min:0,max:24,range:[0,24]}" 
								data-validation-message="{required:$.PSNM.msg('E012', ['접수일시'])}"> 시
						<input id="RCV_MM" name="RCV_MM" data-bind="value:RCV_MM" data-type="textinput" size="2" data-keyfilter-rule="digits" maxlength="2"
					      		data-validation-rule="{required:true, min:0,max:59,range:[0,59]}" 
								data-validation-message="{required:$.PSNM.msg('E012', ['접수일시'])}"> 분	
					</td>
					<th scope="col" class="fontred">접수주체</th>
					<td class="tleft">
						<select id="RCV_OWNR_CD" name="RCV_OWNR_CD" data-bind="options:options_RCV_OWNR_CD, selectedOptions: RCV_OWNR_CD" data-type="select" onchange="$('#RCV_OWNR_NM').val(this.value)"
								data-validation-rule="{required:true}" 
								data-validation-message="{required:$.PSNM.msg('E012', ['접수주체'])}">
                    		<option value="">-선택-</option>
                    	</select>
                    	<input id="RCV_OWNR_NM" data-bind="value:RCV_OWNR_CD" data-type="textinput" size="2" data-disabled="true" maxlength="2">
					</td>
	         	</tr>
	        	<tr>
	            	<th scope="col" class="fontred">상담사명</th>
					<td class="tleft">
						<input id="CNSLR_NM" name="CNSLR_NM" data-bind="value:CNSLR_NM" data-type="textinput" style="width:150px"
								data-validation-rule="{required:true}" 
								data-validation-message="{required:$.PSNM.msg('E012', ['상담사명'])}">
					</td>
					<th scope="col" class="fontred">상담자 연락처</th>
					<td class="tleft">
						<input id="CNSLR_TEL_NO1" name="CNSLR_TEL_NO1" data-bind="value:CNSLR_TEL_NO1" data-type="textinput" size="4" data-keyfilter-rule="digits" maxlength="4"
								data-validation-rule="{required:true}" 
								data-validation-message="{required:$.PSNM.msg('E012', ['상담사연락처'])}">
						-
						<input id="CNSLR_TEL_NUM2" name="CNSLR_TEL_NUM2" data-bind="value:CNSLR_TEL_NUM2" data-type="textinput" size="4" data-keyfilter-rule="digits" maxlength="4"
								data-validation-rule="{required:true}" 
								data-validation-message="{required:$.PSNM.msg('E012', ['상담사연락처'])}">
						-
						<input id="CNSLR_TEL_NUM3" name="CNSLR_TEL_NUM3" data-bind="value:CNSLR_TEL_NUM3" data-type="textinput" size="4" data-keyfilter-rule="digits" maxlength="4"
								data-validation-rule="{required:true}" 
								data-validation-message="{required:$.PSNM.msg('E012', ['상담사연락처'])}">
					</td>
	         	</tr>	
	         	<tr>
	            	<th scope="col" class="fontred">민원유형</th>
					<td class="tleft">
						<select id="PGVC_TYP_CD" name="PGVC_TYP_CD" data-bind="options:options_PGVC_TYP_CD, selectedOptions: PGVC_TYP_CD" data-type="select" onchange="$('#PGVC_TYP_NM').val(this.value)"
								data-validation-rule="{required:true}" 
								data-validation-message="{required:$.PSNM.msg('E012', ['민원유형'])}">
                    		<option value="">-선택-</option>
                    	</select>
                    	<input id="PGVC_TYP_NM" data-bind="value:PGVC_TYP_CD" data-type="textinput" size="2" data-disabled="true" maxlength="2">
					</td>
					<th scope="col" class="fontred">상품유형</th>
					<td class="tleft">
						<select id="PROD_TYP_CD" name="PROD_TYP_CD" data-bind="options:options_PROD_TYP_CD, selectedOptions: PROD_TYP_CD" data-type="select" onchange="$('#PROD_TYP_NM').val(this.value)"
								data-validation-rule="{required:true}" 
								data-validation-message="{required:$.PSNM.msg('E012', ['상품유형'])}">
                    		<option value="">-선택-</option>
                    	</select>
                    	<input id="PROD_TYP_NM" data-bind="value:PROD_TYP_CD" data-type="textinput" size="2" data-disabled="true" maxlength="2">
					</td>
	         	</tr>
	         	<tr>
	            	<th scope="col" class="fontred">처리시한</th>
					<td class="tleft" colspan="3">
						<input id="OP_CLS_DT" name="OP_CLS_DT" data-bind="value:OP_CLS_DT" data-type="dateinput" style="width:70px;" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png"
								data-validation-rule="{required:true}" 
								data-validation-message="{required:$.PSNM.msg('E012', ['처리시한'])}">
						<input id="OP_CLS_TM" name="OP_CLS_TM" data-bind="value:OP_CLS_TM" data-type="textinput" size="2" data-keyfilter-rule="digits" maxlength="2"
					      		data-validation-rule="{required:true, min:0,max:24,range:[0,24]}" 
								data-validation-message="{required:$.PSNM.msg('E012', ['처리시한'])}"> 시
						<input id="OP_CLS_MM" name="OP_CLS_MM" data-bind="value:OP_CLS_MM" data-type="textinput" size="2" data-keyfilter-rule="digits" maxlength="2"
					      		data-validation-rule="{required:true, min:0,max:59,range:[0,59]}" 
								data-validation-message="{required:$.PSNM.msg('E012', ['처리시한'])}"> 분	
					</td>
	         	</tr>	         		         	
	        </table>
	        
	    	<div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"/><b>접수내용</b></div>
	        <table class="board02" style="width:100%;">
	        	<colgroup>
		            <col style="width:15%"/>
		            <col style="width:35%"/>
		            <col style="width:15%"/>
		            <col style="width:*"/>
	            </colgroup>
	        	<tr>
	            	<th scope="col" class="fontred">판매일자</th>
					<td class="tleft">
						<input id="SALE_DT" name="SALE_DT" data-bind="value:SALE_DT" data-type="dateinput" style="width:70px;" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png"
							data-validation-rule="{required:true}" 
							data-validation-message="{required:$.PSNM.msg('E012', ['판매일자'])}" />
					</td>
					<th scope="col">접수 매출번호</th>
					<td class="tleft">
						<input id="SALE_MGMT_NUM" name="SALE_MGMT_NUM" data-bind="value:SALE_MGMT_NUM" data-type="textinput" style="width:150px;">
						<input id="btnSaleMgmtNum" type="button" data-type="button" data-theme="af-n-btn4">
					</td>
	         	</tr>
	        	<tr>
	            	<th scope="col" class="fontred">고객명</th>
					<td class="tleft">
						<input id="CUST_NM" name="CUST_NM" data-bind="value:CUST_NM2" data-type="textinput" style="width:130px;"
							data-validation-rule="{required:true}" 
							data-validation-message="{required:$.PSNM.msg('E012', ['고객명'])}" />
					</td>
					<th scope="col" class="fontred">개통번호</th>
					<td class="tleft">
						<input id="SVC_NUM1" name="SVC_NUM1" data-bind="value:SVC_NUM1" data-type="textinput" data-keyfilter-rule="digits" size="3" maxlength="3"
							data-validation-rule="{required:true, minlength:3, maxlength:3}" 
							data-validation-message="{required:$.PSNM.msg('E012', ['개통번호'])}" />
						- <input id="SVC_NUM2" name="SVC_NUM2" data-bind="value:SVC_NUM2" data-type="textinput" data-keyfilter-rule="digits" size="4" maxlength="4"
							data-validation-rule="{required:true, rangelength:[3,4]}" 
							data-validation-message="{required:$.PSNM.msg('E012', ['개통번호'])}" />
						- <input id="SVC_NUM3" name="SVC_NUM3" data-bind="value:SVC_NUM3" data-type="textinput" data-keyfilter-rule="digits" size="4" maxlength="4"
							data-validation-rule="{required:true, minlength:4, maxlength:4}" 
							data-validation-message="{required:$.PSNM.msg('E012', ['개통번호'])}" />
					</td>
	         	</tr>	
	         	<tr>
	            	<th scope="col">본사팀</th>
					<td class="tleft">
						<input id="HDQT_TEAM_ORG_NM" name="HDQT_TEAM_ORG_NM" data-bind="value:HDQT_TEAM_ORG_NM" data-type="textinput" data-disabled="true" style="width:130px;">
					</td>
					<th scope="col">본사파트</th>
					<td class="tleft">
						<input id="HDQT_PART_ORG_NM" name="HDQT_PART_ORG_NM" data-bind="value:HDQT_PART_ORG_NM" data-type="textinput" data-disabled="true" style="width:150px;"/>
					</td>
	         	</tr>
	        	<tr>
	            	<th scope="col">영업국명</th>
					<td class="tleft">
						<input id="SALE_DEPT_ORG_NM" name="SALE_DEPT_ORG_NM" data-bind="value:SALE_DEPT_ORG_NM" data-type="textinput" data-disabled="true" style="width:130px;">
						<input type="hidden" id="SALE_DEPT_ORG_ID" name="SALE_DEPT_ORG_ID" data-bind="value:SALE_DEPT_ORG_ID" data-type="textinput">
					</td>
					<th scope="col">영업팀명</th>
					<td class="tleft">
						<input id="SALE_TEAM_ORG_NM" name="SALE_TEAM_ORG_NM" data-bind="value:SALE_TEAM_ORG_NM" data-type="textinput" data-disabled="true" style="width:150px;"/>
						<input type="hidden" id="SALE_TEAM_ORG_ID" name="SALE_TEAM_ORG_ID" data-bind="value:SALE_TEAM_ORG_ID" data-type="textinput">
					</td>
	         	</tr>	
	         	<tr>
	            	<th scope="col" class="fontred">판매자 정보</th>
					<td class="tleft" colspan="3">
						<input id="AGNT_NM" name="AGNT_NM" data-bind="value:AGNT_NM" data-type="textinput" data-agentid="AGNT_ID"  data-callback="onAgentFound" size="15"/>
						<input id="AGNT_ID" name="AGNT_ID" data-bind="value:AGNT_ID" data-type="textinput" data-disabled="true" size="15"
								data-validation-rule="{required:true}" 
								data-validation-message="{required:$.PSNM.msg('E012', ['판매자 정보'])}"/>
					</td>
	         	</tr>
	        </table>
	        <div class="floatL4">
	            <textarea id="RCV_CTT" name="RCV_CTT" data-type="textarea" data-bind="value:RCV_CTT" rows="10" cols="80" 
	                   style='overflow: auto; width: 100%;'></textarea>
	        </div>
	        </form>
		    <div class="floatL4">
				<img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>첨부파일</b> : 하단 파일을 더블클릭하시면 저장 및 열기가 가능합니다.
		    	<div class="ab_pos1" style="float:right;">
		      		<div style="position:relative;">
						<span class="file-button type1"><input id="fileupload" type="file"></span>
						<button id="btnFileDel" data-type="button" class="af-n-btn5"></button>
		      		</div>
		    	</div>
		  	</div>
		  	<div id="gridfile" class="view_list" data-bind="grid:gridfile"></div>        	    	    
	</div>
</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>