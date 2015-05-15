<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>면접결과 - PS&Marketing</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />

    <script type="text/javascript">
    $a.page({
        init : function(id, param) {        	
        	$a.page.setEventListener();
            $a.page.setCodeData();
            $a.page.setViewData( param );
        },
        setEventListener : function() {
            $("#btnSave").click( saveConfirm );
            $("#btnList").click( closeWithout );
            //$("#INT_STA_H").change( changeIntStaTm );
            //$("#INT_END_H").change( changeIntEndTm );
        },
        setCodeData : function() {            
            $.PSNMUtils.setCodeData([
				{ t:'code', 'elemid' : 'INT_STA_H',   'codeid' : 'DSM_TM_CD', 'header' : ' '},
				{ t:'code', 'elemid' : 'INT_END_H',   'codeid' : 'DSM_TM_CD', 'header' : ' '},
				{ t:'code', 'elemid' : 'INT_SUIT_CD', 'codeid' : 'DSM_CNSL_SUIT_CD', 'header' : '-선택-' },//면담적합여부코드
            ]); 
            
        },
        setViewData : function( param ) {            
            
        	$("#CNTRT_MGMT_NUM").val(param.CNTRT_MGMT_NUM);
        	$("#APP_SALE_DEPT_ORG_ID").val(param.SALE_DEPT_ORG_ID);
        	$("#INT_CMNT").attr("readOnly", false);
        	
        	//신규입력시
        	if($.PSNMUtils.isEmpty(param.HST_SEQ)){
        		
        		$("#INT_DT").val(getCurrdate());
        		$("#INTR_NM").val( $.PSNM.getSession("USER_NM") );
        		$("#INTR_ID").val( $.PSNM.getSession("USER_ID") );  
        		$("#INT_SUIT_CD").val( "01" );
        		
        		
        		//국장
        		if( $.PSNM.getSession("DUTY")=='14' ) {
        			var textValue = "1. 지원동기\n\n\n2. 인성\n\n\n3. 경력관련 특이사항\n\n\n4. 영업형태 및 판매목표\n\n\n5. 발전가능성\n\n\n6. 기타\n\n\n";
        			var textLength = calculate_msglen(textValue);
        			$("#INT_CMNT").val(textValue);
        			$("#textlimit").text(textLength);
        			
        			//적합여부        			
        			$("#INT_SUIT_CD").setEnabled(false);
        			
        		}
        		//팀장
        		else if( $.PSNM.getSession("DUTY")=='16' || $.PSNM.getSession("DUTY")=='19' || $.PSNM.getSession("DUTY")=='20' ){
        			var textValue = "";
                    $("#INT_CMNT").val(textValue);
                    
                    //적합여부
                    $("#INT_SUIT_CD").setEnabled(false);
        		}
        		else{
        			var textValue = "1. DSM인지경위 / 지인과의 구체적 관계\n\n\n2. 팀장 / 국장 면접\n\n\n3. 고객민원발생시 대처 계획\n\n\n4. 휴대폰 판매경험\n\n\n5. 휴대폰 판매하는 주변 지인 존재 여부\n\n\n6. 향후 영업계획\n\n\n7. 기타\n\n\n";
        			var textLength = calculate_msglen(textValue);
        			
        			$("#INT_CMNT").val(textValue);
                    $("#textlimit").text(textLength);
        		}
        		
        	}
        	//기존수정시
        	else {
        		$("#INT_DT").setEnabled(false);
                $("#INT_STA_H").setEnabled(false);
                $("#INT_END_H").setEnabled(false);
                $("#INT_STA_M").setEnabled(false);
                $("#INT_END_M").setEnabled(false);
                
                $("#INT_PNT").setEnabled(false);
                $("#HST_SEQ").val(param.HST_SEQ);
                
                $("#btnSave").hide();                
                $("#INT_CMNT").attr("readOnly", true);
                
                //국장,팀장
                if( $.PSNM.getSession("DUTY")=='14' || $.PSNM.getSession("DUTY")=='16' || $.PSNM.getSession("DUTY")=='19' || $.PSNM.getSession("DUTY")=='20') {
                	
                	$("#INT_SUIT_CD").setEnabled(false);   //적합여부수정불가
                }
                else{
                	//임직원은, 적합여부만 수정가능
                	$("#INT_SUIT_CD").setEnabled(true);                    
                    $("#btnSave").show();
                }
                
                $.alopex.request('agn.AGNTMGMT@PAGENTCNTRT001_pDetailAgentIntHst', {

                    data: { dataSet : { fields : { CNTRT_MGMT_NUM : param.CNTRT_MGMT_NUM, HST_SEQ : param.HST_SEQ } } },
                    success : ["#form", function(res){
                        
                    	//자신것만 수정가능
                        if( $.PSNM.getSession("USER_ID") == res.dataSet.fields.INTR_ID ){

                            $("#INT_CMNT").attr("readOnly", false);
                            $("#btnSave").show();
                        } 
                    	
                    }]
                }); 

        	}            
        },
    });

    function closeWithout() {
        $a.close();        
    }
    
    //START시간
/*     function changeIntStaTm() {
        
    	if($.PSNMUtils.isNotEmpty( $("#INT_END_H").val() )){    		
    	
	        if( $("#INT_STA_H").val() > $("#INT_END_H").val() ){
	            $.PSNM.alert('시간을 다시 입력해주세요.');
	            $("#INT_STA_H").val("");
	            return false;
	        }
    	}
    } */
    
    //END시간
    function changeIntEndTm() {
    	if( $("#INT_STA_H").val() + $("#INT_STA_M").val() >= $("#INT_END_H").val() + $("#INT_END_M").val() ){
    		$.PSNM.alert('면접종료일시가 면접시작일시보다 작거나 같을 수 없습니다..');
    		//$("#INT_END_H").val("");
            return false;
    	}
    	
    	return true;
    }

    //저장버튼
    function saveConfirm() {
    	
    	//필수입력항목 체크
    	if(!$.PSNM.isValid("form")){
            return false;
        }
    	
    	if (!changeIntEndTm()) return false;
    	
        if( $("#INT_CMNT").val().replace(/\r\n/g,'').replace(/^\s*|\s*$/g,'').length < 150 ){
            $.PSNM.alert('면접내용은 150자 이상 입력하세요.');
            $("#INT_CMNT").focus();
            return false;
        }
        
        //폼과 첨부파일 그리드 모두 합쳐 request 데이터를 생성함. 그리드가 1개이상 가능함.
        var requestData = $.PSNMUtils.getRequestData("form");

        $.alopex.request('agn.AGNTMGMT@PAGENTCNTRT001_pInsertAgentIntHst', {

            data: requestData,
            success: function(res) {
                
                if ( !$.PSNM.success(res) ) { //서버측에서 오류시 
                    return false;
                }
                
                if($.PSNMUtils.isEmpty( $("#HST_SEQ").val()) ){
                	$.PSNM.alert('게시물이 등록 되었습니다.');
                }
                else{
                	$.PSNM.alert('게시물이 수정 되었습니다.');
                }
                
                $a.close({"result":"success"});
            }
        });

    }
    </script>
</head>

<body>

<div id="Wrap">

    <!-- title area -->
    <div class="pop_header">
    	<div id="searchDiv" class="textAR">

            <!-- btn area -->
            <div class="floatL2">  
                <div class="ab_btn_right">
                    <button id="btnSave" type="button" data-type="button" data-theme="af-btn4"  data-altname="저장"></button>
                    <button id="btnList" type="button" data-type="button" data-theme="af-btn14" data-altname="목록"></button>            
                </div>
            </div>
            
            <div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>면접결과상세</b></div>
            
	        <form id="form" onsubmit="return false;">
	           
	           <input id="HST_SEQ" data-bind="value:HST_SEQ" type="hidden" data-type="hidden" />
	           <input id="CNTRT_MGMT_NUM" data-bind="value:CNTRT_MGMT_NUM" type="hidden" data-type="hidden" />
	           <input id="APP_SALE_DEPT_ORG_ID" data-bind="value:APP_SALE_DEPT_ORG_ID" type="hidden" data-type="hidden" />
                
		        <table id="intTable" class="board02">
		            <colgroup>
		                <col style="width:13%">
		                <col style="width:37%">
		                <col style="width:13%">
                        <col style="width:*">
		            </colgroup>
		            <tbody>
		            <tr>
		                <th height="40" scope="col" class="fontred">면접일시</th>
		                <td class="tleft" colspan="3">
	                       <input id="INT_DT" name="INT_DT" data-bind="value:INT_DT" data-type="dateinput" style="width:100px;" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png"/>
	                        <select id="INT_STA_H" name="INT_STA_H" data-type="select" style="width:50px;" data-bind="options: options_INT_STA_H, selectedOptions: INT_STA_H"
	                                data-validation-rule="{required:true}"
                                    data-validation-message="{required:$.PSNM.msg('E012', ['시작시간'])}">
                            </select> 시
	                        <select id="INT_STA_M" name="INT_STA_M" data-type="select" style="width:50px;" data-bind="options: options_INT_STA_M, selectedOptions: INT_STA_M"
                                    data-validation-rule="{required:true}"
                                    data-validation-message="{required:$.PSNM.msg('E012', ['시작분'])}">
                                <option value=""></option>
                                <option value="00">00</option>
                                <option value="05">05</option>
                                <option value="10">10</option>
                                <option value="15">15</option>
                                <option value="20">20</option>
                                <option value="25">25</option>
                                <option value="30">30</option>
                                <option value="35">35</option>
                                <option value="40">40</option>
                                <option value="45">45</option>
                                <option value="50">50</option>
                                <option value="55">55</option>                                
                            </select> 분 ~
	                   
	                        <select id="INT_END_H" name="INT_END_H" data-type="select" style="width:50px;" data-bind="options: options_INT_END_H, selectedOptions: INT_END_H"
	                                data-validation-rule="{required:true, min:$('INT_STA_H').val() }"
                                    data-validation-message="{required:$.PSNM.msg('E012', ['종료시간']), min:'종료시각을 다시 입력해주세요.'}">
	                        </select> 시
	                        <select id="INT_END_M" name="INT_END_M" data-type="select" style="width:50px;" data-bind="options: options_INT_END_M, selectedOptions: INT_END_M"
                                    data-validation-rule="{required:true}"
                                    data-validation-message="{required:$.PSNM.msg('E012', ['종료분'])}">
                                <option value=""></option>
                                <option value="00">00</option>
                                <option value="05">05</option>
                                <option value="10">10</option>
                                <option value="15">15</option>
                                <option value="20">20</option>
                                <option value="25">25</option>
                                <option value="30">30</option>
                                <option value="35">35</option>
                                <option value="40">40</option>
                                <option value="45">45</option>
                                <option value="50">50</option>
                                <option value="55">55</option>                                
                            </select> 분
	                   
		                </td>
		            </tr>
		            <tr>
		                <th>면접관</th>
		                <td class="tleft" class="fontred">
		                	<input id="INTR_NM" data-bind="value:INTR_NM" data-type="textinput" data-disabled="true"
                               data-validation-rule="{required:true}" 
                               data-validation-message="{required:$.PSNM.msg('E012', ['면접관'])}" style="width:150px!important">
                            <input id="INTR_ID" data-bind="value:INTR_ID" data-type="textinput" data-disabled="true" style="width:75px!important">	                    
		                </td>
		                <th>면접관 직책</th>
                        <td class="tleft">
                            <input id="RETL_CLASS_NM" data-bind="value:RETL_CLASS_NM" data-type="textinput" data-disabled="true">       
                        </td>
		            </tr>
		            <tr>
                        <th>본사팀</th>
                        <td class="tleft">
                            <input id="HDQT_TEAM_ORG_NM" data-bind="value:HDQT_TEAM_ORG_NM" data-type="textinput" data-disabled="true" style="width:150px!important"> 
                            <input id="HDQT_TEAM_ORG_ID" data-bind="value:HDQT_TEAM_ORG_ID" data-type="textinput" data-disabled="true" style="width:75px!important">
                        </td>
                        <th>본사파트</th>
                        <td class="tleft">
                            <input id="HDQT_PART_ORG_NM" data-bind="value:HDQT_PART_ORG_NM" data-type="textinput" data-disabled="true" style="width:150px!important"> 
                            <input id="HDQT_PART_ORG_ID" data-bind="value:HDQT_PART_ORG_ID" data-type="textinput" data-disabled="true" style="width:75px!important">
                        </td>
                    </tr>
                    <tr>
                        <th>영업국명</th>
                        <td class="tleft">
                            <input id="SALE_DEPT_ORG_NM" data-bind="value:SALE_DEPT_ORG_NM" data-type="textinput" data-disabled="true" style="width:150px!important"> 
                            <input id="SALE_DEPT_ORG_ID" data-bind="value:SALE_DEPT_ORG_ID" data-type="textinput" data-disabled="true" style="width:75px!important">               
                        </td>
                        <th>영업팀명</th>
                        <td class="tleft">
                            <input id="SALE_TEAM_ORG_NM" data-bind="value:SALE_TEAM_ORG_NM" data-type="textinput" data-disabled="true" style="width:150px!important"> 
                            <input id="SALE_TEAM_ORG_ID" data-bind="value:SALE_TEAM_ORG_ID" data-type="textinput" data-disabled="true" style="width:75px!important"> 
                        </td>
                    </tr>
                    <tr>
                        <th>등록자</th>
                        <td class="tleft">
                            <input id="RGSTR_NM" data-bind="value:RGSTR_NM" data-type="textinput" data-disabled="true" style="width:150px!important">
                            <input id="RGSTR_ID" data-bind="value:RGSTR_ID" data-type="textinput" data-disabled="true" style="width:75px!important">
                        </td>
                        <th>등록 일시</th>
                        <td class="tleft">
                            <input id="RGST_DTM" data-bind="value:RGST_DTM" data-type="textinput" data-disabled="true">   
                        </td>
                    </tr>
                    <tr>
                        <th class="fontred">평가</th>
                        <td class="tleft">
                            <select id="INT_PNT" name="INT_PNT" data-type="select" style="width:80px;" data-bind="options: options_INT_PNT, selectedOptions: INT_PNT"
                                    data-validation-rule="{required:true}"
                                    data-validation-message="{required:$.PSNM.msg('E012', ['평가'])}">
                                    <option value="">-선택-</option>
			                        <option value="S">S</option>
			                        <option value="A">A</option>
			                        <option value="B">B</option>
			                        <option value="C">C</option>
                            </select>
                        </td>
                        <th class="fontred">적합여부</th>
                        <td class="tleft">
                            <select id="INT_SUIT_CD" name="INT_SUIT_CD" data-type="select" style="width:80px;" data-bind="options: options_INT_SUIT_CD, selectedOptions: INT_SUIT_CD"
                                    data-validation-rule="{required:true}"
                                    data-validation-message="{required:$.PSNM.msg('E012', ['적합여부'])}">
                            </select>
                        </td>
                    </tr>
		            
		            </tbody>
		        </table>
		        
		        <!-- 면접내용 area -->
	            <textarea id="INT_CMNT" data-bind="value:INT_CMNT" style="width:97%; margin-bottom:10px; margin-top:10px;" cols="40" rows="10" data-type="textarea" 
		                      onkeyup="updateChar( this );" onkeydown="updateChar( this );" data-disabled="false"></textarea>
		        <span id="textlimit">0</span>/150 <font size="2" color="red">150자 이상 입력 필수.</font>
        
	        </form>
        </div>

    </div>

</div>

</body>
</html>