<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

    <jsp:include page="/view/layouts/default_head.jsp" flush="false" />
    
    <script type="text/javascript">
    
    var _param, _searchData;
    
    $.alopex.page({

        init : function(id, param) {        	    
            $.PSNM.initialize(id, param); //PSNM공통 초기화함수 호출            
            _param = param; //이 페이지로 전달된 파라미터를 저장
			            
            $a.page.setData();
            $a.page.setGrid();
            $a.page.setEventListener();
            $a.page.setCodeData();
            $a.page.setFileUpload();
        },
        setData : function() {
        	var RCV_MGMT_NUM = $.PSNMUtils.isNotEmpty(_param.data)?_param.data.RCV_MGMT_NUM:"";
        	
        	$.alopex.request("biz.SCRBCLM@PSCRBCLM001_pSearchScrbClmDtl", {
        		data: {dataSet: {fields: {"RCV_MGMT_NUM" : RCV_MGMT_NUM}}},
                success:["#form", "#gridScrbClmOp", "#gridfile2", function(res) {
                	 $("#RCV_CTT").ckeditor();    
                	 if ( ! $.PSNM.success(res) ) { //서버측 FAIL응답
                		 return false;
                	 }
                	 var reg = /(^\d{4})(\d{2})(\d{2})(.*)/;
                	 $("#RCV_DT").val( res.dataSet.fields.RCV_DT.replace(reg, '$1' + '-' + '$2'+'-'+'$3'));
                	 $("#OP_CLS_DT").val( res.dataSet.fields.OP_CLS_DT.replace(reg, '$1' + '-' + '$2'+'-'+'$3'));
                	 $("#SALE_DT").val( res.dataSet.fields.SALE_DT.replace(reg, '$1' + '-' + '$2'+'-'+'$3'));
    				
    				 $("#RGSTR_NM").val(res.dataSet.fields.RGSTR_NM);
    				 $("#AGNT_NM").val(res.dataSet.fields.AGNT_NM);
    				 $("#CUST_NM").val(res.dataSet.fields.CUST_NM);
                	 _searchData = res.dataSet.fields //변경되기 전 데이타
                	
                	setVisible( res );
                }]
            });
        },
        setGrid : function() {
        	$("#gridScrbClmOp").alopexGrid({
                rowClickSelect : false,
                rowInlineEdit  : true,
                pager         : false,
                columnMapping  : [
                    { columnIndex : 0, key : "OP_DTM",                 title : "처리일시",		    align : "center", 	width : "100px" },
                    { columnIndex : 1, key : "OPR_NM",  		       title : "처리자",		        align : "center", 	width : "95px"  },
                    { columnIndex : 2, key : "DUTY_NM",        	       title : "처리자 직무",		    align : "center", 	width : "100px" },
                    { columnIndex : 3, key : "HDQT_TEAM_ORG_NM",       title : "본사팀",		        align : "center", 	width : "100px" },
                    { columnIndex : 4, key : "HDQT_PART_ORG_NM", 	   title : "본사파트",		    align : "center", 	width : "100px"	},
                    { columnIndex : 5, key : "SALE_DEPT_ORG_NM",       title : "영업국명",	        align : "center", 	width : "100px" },
                    { columnIndex : 6, key : "SALE_TEAM_ORG_NM", 	   title : "영업팀명",		    align : "center", 	width : "50px"	},
                    { columnIndex : 7, key : "RGSTR_NM", 	  		   title : "등록자",		        align : "center", 	width : "100px"	},
                    { columnIndex : 8, key : "RGST_DTM", 	           title : "등록일시",		    align : "center", 	width : "100px"	},
                    { columnIndex : 9, key : "OP_SEQ", 	               title : "처리순번",		    hidden: true},
                ],
                on : {
                    "cell" : {
    					"dblclick" : function(data, eh, e) {
    						if(data._index.column != 0) {
								var param = {};
			        			param["data"] = data;
    			                openPopup("op", param);
    						}
    					}
    				}
                }
            });
        },
        setEventListener : function() {        	        
        	$("#btnFinish").click( function(){ openPopup("finish", _param); });
        	$("#btnRevoke").click( function(){ openPopup("revoke", _param); });
        	$("#btnList").click(function(){
            	$a.back(_param);
        	});
        	$("#btnAddOp").click( function(){openPopup("op", _param);} );
        },
        setCodeData : function() {
            $.PSNMUtils.setCodeData([
                { t:'code',  'elemid' : 'RCV_OWNR_CD', 'codeid' : 'DSM_RCV_OWNR_CD', 'header' : '-전체-' },
                { t:'code',  'elemid' : 'CLM_TYP_CD', 'codeid' : 'DSM_SCRB_CLM_TYP_CD', 'header' : '-전체-' },
            ]);
        },
        setFileUpload : function () {
        	$.PSNMUtils.setFileGrid("gridfile2", true);
        }
    });
    
    function openPopup( div, param ){
    	var url, title, width, height, data=null, windowpopup=false, iframe=true;
    	switch( div ){
		    case "sale":   
				url = "com/popup/saleSelPopup";
				title = "매출선택";
				width = "1100";
				height = "750";
		    break;
		    case "op":   
				url = "biz/scrbclm/scrbClmOpPopup";
				title = "처리내용";
				width = "950";
				height = "800";
				data = { RCV_MGMT_NUM:param.data.RCV_MGMT_NUM, OP_SEQ:param.data.OP_SEQ, SCRB_CLM_ST_CD:_searchData.SCRB_CLM_ST_CD,
						AGNT_NM:_searchData.AGNT_NM, CUST_NM:_searchData.CUST_NM, SALE_DEPT_ORG_NM:_searchData.SALE_DEPT_ORG_NM, SALE_TEAM_ORG_NM:_searchData.SALE_TEAM_ORG_NM };
		    break;
		    case "finish":   
				url = "biz/scrbclm/scrbClmFnshPopup";
				title = "최종완료";
				width = "950";
				height = "800";
				data =   { RCV_MGMT_NUM:param.data.RCV_MGMT_NUM } ;
		    break;	
		    case "revoke":
		    	url = "biz/scrbclm/scrbClmRevokPopup";
				title = "완료취소";
				width = "500";
				height = "300";
				data =   { RCV_MGMT_NUM:param.data.RCV_MGMT_NUM } ;
    	}
    	
        $a.popup({
            url: url,
            title : title,
            data  : data,
            width : width,
            height: height,
            windowpopup: windowpopup,
            iframe : true,
            callback : function( oResult ) {
            	popupCallback( div, oResult);
            }
        });
    }
    
    function popupCallback( div, oResult ){    	
    	switch( div ){
		    case "sale":   
				$("#form").setData( oResult )
				            
        		var reg = /(^\d{4})(\d{2})(\d{2})(.*)/;
				$("#SALE_DT").val( oResult.SALE_DTM.replace(reg, '$1' + '-' + '$2'+'-'+'$3'));
				
				$("#AGNT_NM").val(oResult.AGNT_NM);
				$("#CUST_NM").val(oResult.CUST_NM);
		    break;
		    case "op": 
				if( oResult == "success"){
					$a.page.setData();	
				}
		    break;
		    case "finish":
				if( oResult == "success"){
					$("#SVC_NUM2").prop("type","password");
					$a.page.setData();
				}
			break;
		    case "revoke":
				if( oResult == "success"){
					$("#SVC_NUM2").prop("type","text");
					$a.page.setData();
				}
		    break;
		}    	
    }
    //처리상태에 따른 화면 컨트롤
    function setVisible( res ){
    	$("#RCV_OWNR_CD").setEnabled( false );
    	
    	var div = res.dataSet.fields.SCRB_CLM_ST_CD;
    	switch( div ){
    	    case "N":
    	    case "R":
    	    	$("#btnFinish").show(); 
    	    	$("#btnRevoke").hide();
    	    
    	    	$("#btnAddOp").setEnabled( true );
    	    	
    	    	$("[visibleGrp='fnsh']").hide();
 	    
    	    	if( res.dataSet.recordSets.gridScrbClmOp.nc_recordCount > 0 ){
    	    		$("#btnFinish").show();
    	    	}else{
    	    		$("#btnFinish").hide();
    	    	}

    		break;
    	    case "Y":
    	    	$("#btnFinish").hide();    	    	
    	    	$("#btnRevoke").show();    	    	
    	    	
    	    	$("#btnAddOp").setEnabled( false );
    	    	
    	    	$("[visibleGrp='fnsh']").show();
    	    	$("#SVC_NUM2").prop("type","password")
    	    break;
    	}
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
            <span class="txt6_img"><b>비정상영업소명 관리</b><span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif">
            <span class="a2">본사업무</span> <span class="a3"> > <b>비정상영업소명 관리</b></span></span>             
        </div>
    </div>
    
    <!-- btn area -->
    <div class="btn_area">
        <div class="ab_btn_left">
            <button id="btnFinish" type="button" data-type="button" data-theme="af-btn11"  data-altname="최종완료" data-authtype="W"></button>
            <button id="btnRevoke"  type="button" data-type="button" data-theme="af-btn12" data-altname="완료취소" data-authtype="W"></button>
        </div>    
        <div class="ab_btn_right">
            <button id="btnList" type="button" data-type="button" data-theme="af-btn14" data-altname="목록" data-authtype="R"></button>
        </div>
    </div>
    <!-- btn area end-->
    
	<!--view_table area -->
    <div class="view_list">
	
	    <form id="form" onsubmit="return false;">
	    
	    	<div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"/> <b>접수정보</b></div>
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
						<input id="RCV_DT" data-bind="value:RCV_DT" data-type="dateinput" style="width:70px;" data-disabled="true" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png"
					      		data-validation-rule="{required:true}" 
								data-validation-message="{required:$.PSNM.msg('E012', ['접수일시'])}">
						<input id="RCV_TM" data-bind="value:RCV_TM" data-type="textinput" size="2" data-disabled="true" data-keyfilter-rule="digits" maxlength="2"
					      		data-validation-rule="{required:true}" 
								data-validation-message="{required:$.PSNM.msg('E012', ['접수일시'])}"> 시
						<input id="RCV_MM" data-bind="value:RCV_MM" data-type="textinput" size="2" data-disabled="true" data-keyfilter-rule="digits" maxlength="2"
					      		data-validation-rule="{required:true}" 
								data-validation-message="{required:$.PSNM.msg('E012', ['접수일시'])}"> 분	
					</td>
					<th scope="col" class="fontred">접수주체</th>
					<td class="tleft">
						<select id="RCV_OWNR_CD" data-bind="options:options_RCV_OWNR_CD, selectedOptions: RCV_OWNR_CD" data-type="select" onchange="$('#RCV_OWNR_NM').val(this.value)"
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
						<input id="CNSLR_NM" data-bind="value:CNSLR_NM" data-type="textinput" style="width:150px" data-disabled="true"
								data-validation-rule="{required:true}" 
								data-validation-message="{required:$.PSNM.msg('E012', ['상담사명'])}">
					</td>
					<th scope="col" class="fontred">상담자 연락처</th>
					<td class="tleft">
						<input id="CNSLR_TEL_NO1" data-bind="value:CNSLR_TEL_NO1" data-type="textinput" size="4" data-disabled="true" data-keyfilter-rule="digits" maxlength="4"
								data-validation-rule="{required:true}" 
								data-validation-message="{required:$.PSNM.msg('E012', ['상담사연락처'])}">
						-
						<input id="CNSLR_TEL_NUM2" data-bind="value:CNSLR_TEL_NUM2" data-type="textinput" size="4" data-disabled="true" data-keyfilter-rule="digits" maxlength="4"
								data-validation-rule="{required:true}" 
								data-validation-message="{required:$.PSNM.msg('E012', ['상담사연락처'])}">
						-
						<input id="CNSLR_TEL_NUM3" data-bind="value:CNSLR_TEL_NUM3" data-type="textinput" size="4" data-disabled="true" data-keyfilter-rule="digits" maxlength="4"
								data-validation-rule="{required:true}" 
								data-validation-message="{required:$.PSNM.msg('E012', ['상담사연락처'])}">
					</td>
	         	</tr>	
	         	<tr>
	            	<th scope="col" class="fontred">민원유형</th>
					<td class="tleft">
						<select id="CLM_TYP_CD" data-bind="options:options_CLM_TYP_CD, selectedOptions: CLM_TYP_CD" data-type="select" data-disabled="true"								
								data-validation-rule="{required:true}" 
								data-validation-message="{required:$.PSNM.msg('E012', ['민원유형'])}">
                    		<option value="">-선택-</option>
                    	</select>
                    	<input id="CLM_TYP_NM" data-bind="value:CLM_TYP_CD" data-type="textinput" size="2" data-disabled="true" maxlength="2">
					</td>
					<th scope="col" class="fontred">처리시한</th>
					<td class="tleft" colspan="3">
						<input id="OP_CLS_DT" data-bind="value:OP_CLS_DT" data-type="dateinput" style="width:70px;" data-disabled="true" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png"
								data-validation-rule="{required:true}" 
								data-validation-message="{required:$.PSNM.msg('E012', ['처리시한'])}">
						<input id="OP_CLS_TM" data-bind="value:OP_CLS_TM" data-type="textinput" size="2" data-disabled="true" data-keyfilter-rule="digits" maxlength="2"
					      		data-validation-rule="{required:true}" 
								data-validation-message="{required:$.PSNM.msg('E012', ['처리시한'])}"> 시
						<input id="OP_CLS_MM" data-bind="value:OP_CLS_MM" data-type="textinput" size="2" data-disabled="true" data-keyfilter-rule="digits" maxlength="2"
					      		data-validation-rule="{required:true}" 
								data-validation-message="{required:$.PSNM.msg('E012', ['처리시한'])}"> 분	
					</td>
	         	</tr>
	         	<tr>
	            	<th scope="col">고액사용자</th>
					<td class="tleft" colspan="3">
						<input id="SCRB_LRG_SEQ" data-bind="value:SCRB_LRG_SEQ" data-type="textinput" data-disabled="true" data-keyfilter-rule="digits" style="width:150px">차
						<input id="SCRB_LRG_AMT" data-bind="value:SCRB_LRG_AMT" data-type="textinput" data-disabled="true" data-keyfilter-rule="digits" style="width:150px">원
					</td>
	         	</tr>	   
	         	<tr>
	            	<th scope="col">등록자</th>
					<td class="tleft">
						<input id="RGSTR_NM" data-bind="value:RGSTR_NM" data-type="textinput" data-disabled="true" style="width:150px">
					</td>
	            	<th scope="col">등록일시</th>
					<td class="tleft">
						<input id="RGST_DTM" data-bind="value:RGST_DTM" data-type="textinput" data-disabled="true" style="width:150px">
					</td>										
	         	</tr>		         	      		         	
	        </table>
	        
	    	<div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"/> <b>접수내용</b></div>
	        <table class="board02" style="width:100%;">
	        	<colgroup>
		            <col style="width:15%"/>
		            <col style="width:35%"/>
		            <col style="width:15%"/>
		            <col style="width:*"/>
	            </colgroup>
	        	<tr>
	            	<th scope="col">판매일자</th>
					<td class="tleft">
						<input id="SALE_DT" name="SALE_DT" data-bind="value:SALE_DT" data-type="textinput" data-disabled="true" style="width:130px;">
					</td>
					<th scope="col">접수 매출번호</th>
					<td class="tleft">
						<input id="SALE_MGMT_NUM" name="SALE_MGMT_NUM" data-bind="value:SALE_MGMT_NUM" data-type="textinput" style="width:150px;" data-disabled="true">
					</td>
	         	</tr>
	        	<tr>
	            	<th scope="col">고객명</th>
					<td class="tleft">
						<input id="CUST_NM" name="CUST_NM" data-bind="value:CUST_NM" data-type="textinput" data-disabled="true" style="width:130px;">
					</td>
					<th scope="col">개통번호</th>
					<td class="tleft">
						<input id="SVC_NUM1" name="SVC_NUM1" data-bind="value:SVC_NUM1" data-type="textinput" data-disabled="true" data-keyfilter-rule="digits" size="3"
							data-validation-rule="{required:true}" 
							data-validation-message="{required:$.PSNM.msg('E012', ['개통번호'])}" />
						- <input id="SVC_NUM2" name="SVC_NUM2" data-bind="value:SVC_NUM2" data-type="textinput" data-disabled="true" data-keyfilter-rule="digits" size="4"
							data-validation-rule="{required:true}" 
							data-validation-message="{required:$.PSNM.msg('E012', ['개통번호'])}" />
						- <input id="SVC_NUM3" name="SVC_NUM3" data-bind="value:SVC_NUM3" data-type="textinput" data-disabled="true" data-keyfilter-rule="digits" size="4"
							data-validation-rule="{required:true}" 
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
					</td>
					<th scope="col">영업팀명</th>
					<td class="tleft">
						<input id="SALE_TEAM_ORG_NM" name="SALE_TEAM_ORG_NM" data-bind="value:SALE_TEAM_ORG_NM" data-type="textinput" data-disabled="true" style="width:150px;"/>
					</td>
	         	</tr>	
	         	<tr>
	            	<th scope="col">판매자 정보</th>
					<td class="tleft" colspan="3">
						<input id="AGNT_NM" name="AGNT_NM" data-bind="value:AGNT_NM" data-type="textinput" data-disabled="true" style="width:130px;"/>
						<input id="AGNT_ID" name="AGNT_ID" data-bind="value:AGNT_ID" data-type="textinput" data-disabled="true" style="width:75px;"/>
					</td>
	         	</tr>
	        </table>
	        <div class="floatL4">
	            <textarea id="RCV_CTT" name="RCV_CTT" data-type="textarea" data-bind="value:RCV_CTT" rows="10" cols="80" data-disabled="true" 
	                   style='overflow: auto; width: 100%;'></textarea>
	        </div>		  	
		  	<div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>처리사항</b>
		        <p class="ab_pos2">
					<input id="btnAddOp" type="button" data-type="button" class="psnm-sbtn-add" />
		        </p>
		    </div>
		    <div id="gridScrbClmOp" class="view_list" data-bind="grid:gridScrbClmOp"></div>

			<div class="floatL4" visibleGrp="fnsh"><img src="<c:out value='${pageContext.request.contextPath}' />/image/blat_a7.gif"/> <b>최종완료내용</b></div>
	        <table class="board02" style="width:100%;" visibleGrp="fnsh">
	        	<colgroup>
		            <col style="width:15%"/>
		            <col style="width:35%"/>
		            <col style="width:15%"/>
		            <col style="width:*"/>
	            </colgroup>
	        	<tr>
	            	<th scope="col">처리완료 일시</th>
					<td class="tleft">
						<label data-bind="text:FNSH_DTM"></label>
					</td>
					<th scope="col">처리완료 확인자</th>
					<td class="tleft">
						<label data-bind="text:FNSH_OPR_NM"></label>
					</td>
	         	</tr>
	        	<tr>
	            	<th scope="col">Penalty내역</th>
					<td class="tleft" colspan="3">
						<span style="width:30%; display:inline-block">
							판매자 :
							<label data-bind="text:SELLER_PEN_AMT"></label>
						</span>
						<span style="width:30%; display:inline-block">
							팀장 :
							<label data-bind="text:TEAM_LDR_PEN_AMT"></label>
						</span>
						<span style="width:30%; display:inline-block">
							국장 :
							<label data-bind="text:DRTR_PEN_AMT"></label>
						</span>
					</td>
	         	</tr>	
	         	<tr>
	            	<th scope="col">비고</th>
					<td class="tleft" colspan="3">
						<label data-bind="text:FNSH_MEMO"></label>
					</td>
	         	</tr>
	         	<tr>
	            	<th scope="col">완료사항</th>
					<td class="tleft" colspan="3">
						<label data-bind="text:FNSH_CTT"></label>
					</td>
	         	</tr>	         	
	        	<tr>
	            	<th scope="col">등록자</th>
					<td class="tleft">
						<label data-bind="text:FNSH_RGSTR_NM"></label>
					</td>
					<th scope="col">등록일시</th>
					<td class="tleft">
						<label data-bind="text:FNSH_RGST_DTM"></label>
					</td>
	         	</tr>
	        </table>
	        <div class="floatL4" visibleGrp="fnsh">
				<img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>최종완료 첨부파일</b>
		  	</div>
		  	<div id="gridfile2" class="view_list" data-bind="grid:gridfile2" visibleGrp="fnsh"></div>		        
	    </form>	    
	</div>
</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>