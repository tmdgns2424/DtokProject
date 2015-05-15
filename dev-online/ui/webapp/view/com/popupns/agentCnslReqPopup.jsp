<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>지원상담요청</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />

    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/psnm-ns.js"></script>

    <script type="text/javascript">
    
    $a.page({
        init : function(id, param) {
            $a.page.setEventListener();
            $a.page.setCodeData();
            $a.page.setDetail( param );
        },
        setEventListener : function() {
            $("#btnConfirm").click( saveConfirm );  //확인 클릭
            $("#btnCancel").click( closeWithout ); //취소 클릭
            $("#btnDelete").click( deleteConfirm ); //삭제 클릭
        },      
        setCodeData : function() {
            
            $.PSNMUtils.setCodeData([
                { t:'code', 'elemid' : 'RETL_TYP_CD',   'codeid' : 'DSM_RETL_TYPE', 'header' : '-선택-', 'ADD_INFO_01' : 'Y' },   //판매형태
                { t:'code', 'elemid' : 'MBL_PHON_NUM1', 'codeid' : 'HP_FRST_NO', 'header' : '-선택-' },   //이동전화
            ]);            
        },
        setDetail : function(param){
            
            if($.PSNMUtils.isNotEmpty(param.APLCNSL_MGMT_NUM)){

            	$.alopex.request('agn.AGNTMGMT@PAGENTECCR001_pDetailAgentEccr', {               	

                	url: _NOSESSION_REQ_URL,
                	data: { dataSet : { fields : { APLCNSL_MGMT_NUM : param.APLCNSL_MGMT_NUM } } },
                    success : ["#form", function(res){
                        //$a.page.setViewBtn(res.dataSet.fields.CNTRT_ST_CD);
                    	setViewObject( param );
                    	
                    }]
                });
            }
        },

    });
    
    //현재창을 닫고 객체를 반환
    function closeWith() {
        $a.close( oRecord );         
    }
  
    function closeWithout() {
        $a.close();
    }
    
    function setViewObject( param ) {
    	$("#SCRT_NUM").val(param.SCRT_NUM);
        $("#SCRT_NUM").setEnabled(false);
        
        $("#btnDelete").show();
    }
    
    function saveConfirm(){
    	
    	//필수입력항목 체크
    	if(!$.PSNM.isValid("form")){
            return false;
        }
    	
    	if( $.PSNMUtils.isNotEmpty( $("#APL_ST_CD").val() ) ) {
            $.PSNM.alert('진행중이거나 종료된 건입니다.');
            return false;
        }
        
    	if( $("#MEMO").val().length < 20 ){
            $.PSNM.alert('문의사항은 20자 이상 입력해 주세요.');
            $("#MEMO").focus();
            return false;
        }
    	
    	if( $("#AGE").val().length < 2 ){
            $.PSNM.alert('나이는 2자 이상 입력해 주세요.');
            $("#MEMO").focus();
            return false;
        }
        
        //폼과 첨부파일 그리드 모두 합쳐 request 데이터를 생성함. 그리드가 1개이상 가능함.
        var requestData = $.PSNMUtils.getRequestData("form");
         
        $.alopex.request('agn.AGNTMGMT@PAGENTECCR001_pMergeAgentEccr', {

        	url: _NOSESSION_REQ_URL,
        	data: requestData,
            success: function(res) {
                
            	if ( !$.PSNM.success(res) ) { //서버측에서 오류시 
                    return false;
                }
                
                $a.close();  
            }
        });
    }
    
    function deleteConfirm(){
    	if( $.PSNMUtils.isNotEmpty( $("#APL_ST_CD").val() ) ) {
            $.PSNM.alert('진행중이거나 종료된 건입니다.');
            return false;
        }
    	
    	if( $.PSNMUtils.isNotEmpty( $("#APLCNSL_MGMT_NUM").val() ) ) {
    		
    		$.alopex.request('agn.AGNTMGMT@PAGENTECCR001_pDeleteAgentEccr', {

                url: _NOSESSION_REQ_URL,
                data: { dataSet : { fields : { APLCNSL_MGMT_NUM : $("#APLCNSL_MGMT_NUM").val() } } },
                success: function(res) {
                    
                    if ( !$.PSNM.success(res) ) { //서버측에서 오류시 
                        return false;
                    }
                    
                    $a.close();
                }
            });
    	}
    }
    
    function js_trim(obj){
    	
    	$("#" + obj.id).val( obj.value.replace(/\s+/gi,"") );
    }
    
    </script>
</head>
<body>
<div id="Wrap">

	<!-- title area -->
	<div class="pop_header" > 
	<form id="form" onsubmit="return false;">
	   
	   <input id="APLCNSL_MGMT_NUM" data-bind="value:APLCNSL_MGMT_NUM" type="hidden" data-type="hidden"/>	   
	   <input id="APL_ST_CD" data-bind="value:APL_ST_CD" type="hidden" data-type="hidden"/>
	   
		<div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>지원상담요청</b></div>
		<div class="info1">상담정보를 입력해 주시면, 담당 영업국 배정 후 지원자님께 3일 이내에 연락 드릴 예정입니다.</div>
		<div id="searchDiv" class="textAR">
		    <table id="searchTable" class="board02">
		        <colgroup>
	                <col style="width:16%">
	                <col style="width:30%">
	                <col style="width:16%">
	                <col style="width:*">
                </colgroup>
		        <tbody>
		        <tr>
		            <th height="40" scope="col" class="fontred">성명(한글)</th>
		            <td class="tleft">
		                <input id="NAME_KOR" data-bind="value:NAME_KOR" data-type="textinput" onBlur="js_trim(this);"
					           data-validation-rule="{required:true}" 
					           data-validation-message="{required:$.PSNM.msg('E012', ['성명(한글)'])}">
		            </td>
		            <th class="fontred">연락처</th>
                    <td class="tleft">

                        <select id="MBL_PHON_NUM1" name="MBL_PHON_NUM1" data-bind="options: options_MBL_PHON_NUM1, selectedOptions: MBL_PHON_NUM1" data-type="select" data-wrap="false" style="width:60px"
                                data-validation-rule="{required:true}" 
                                data-validation-message="{required:$.PSNM.msg('E012', ['연락처'])}">
                        </select>
                      - <input id="MBL_PHON_NUM2" data-bind="value:MBL_PHON_NUM2" type="text" data-type="textinput" data-keyfilter-rule="digits" size="4" maxlength="4"
                                data-validation-rule="{required:true}" 
                                data-validation-message="{required:$.PSNM.msg('E012', ['연락처'])}">
                      - <input id="MBL_PHON_NUM3" data-bind="value:MBL_PHON_NUM3" type="text" data-type="textinput" data-keyfilter-rule="digits" size="4" maxlength="4"
                                data-validation-rule="{required:true}" 
                                data-validation-message="{required:$.PSNM.msg('E012', ['연락처'])}">           
                    </td>
		        </tr>
		        <tr>
		            <th height="40" scope="col" class="fontred">나이</th>
		            <td class="tleft">
                        <input id="AGE" data-bind="value:AGE" data-type="textinput" maxlength="2" data-keyfilter-rule="digits"
                               data-validation-rule="{required:true}" 
                               data-validation-message="{required:$.PSNM.msg('E012', ['나이'])}">
		            </td>
		            <th class="fontred">성별</th>
		            <td class="tleft">
		                <input type="radio" name="SEX" data-type="radio" value="M" data-bind="checked:SEX" />남
				        <input type="radio" name="SEX" data-type="radio" value="W" data-bind="checked:SEX" checked="checked"/>여
		            </td>
		        </tr>
		        <tr>
		            <th height="40" scope="col" class="fontred">판매방식</th>
		            <td class="tleft">
                        <select id="RETL_TYP_CD" name="RETL_TYP_CD" data-bind="options: options_RETL_TYP_CD, selectedOptions: RETL_TYP_CD" data-type="select" data-disabled="false" data-wrap="false"
                                data-validation-rule="{required:true}" 
                                data-validation-message="{required:$.PSNM.msg('E012', ['판매방식'])}">
                        </select>
                    </td>
                    <th class="fontred">영업예정지역</th>
                    <td class="tleft">
                        <input id="ACT_ZONE" data-bind="value:ACT_ZONE" data-type="textinput" data-disabled="false"
                               data-validation-rule="{required:true}" 
                               data-validation-message="{required:$.PSNM.msg('E012', ['영업예정지역'])}">
                    </td>
		        </tr>
		        <tr>
                    <th height="40" scope="col" class="fontred">휴대폰 판매경력</th>
                    <td class="tleft">
                        <input id="SALES_HST" data-bind="value:SALES_HST" data-type="textinput" data-disabled="false"
                               data-validation-rule="{required:true}" 
                               data-validation-message="{required:$.PSNM.msg('E012', ['휴대폰 판매경력'])}">
                    </td>
                    <th height="40" scope="col" class="fontred">비밀번호</th>
                    <td class="tleft">
                        <input id="SCRT_NUM" type="password" data-type="textinput" data-disabled="false"
                               data-validation-rule="{required:true}" 
                               data-validation-message="{required:$.PSNM.msg('E012', ['비밀번호'])}">
                    </td>
                </tr>
                <tr>
                    <th height="40" scope="col">문의사항</th>
                    <td class="tleft" colspan="3">
                        <textarea id="MEMO" data-bind="value:MEMO" style="width:97%; margin-bottom:10px; margin-top:10px;" cols="40" rows="6" data-type="textarea" data-disabled="false" 
                                  onkeyup="updateChar(this);" onkeydown="updateChar(this);"></textarea>
                        <div class="t-right mgt10">(<span id="textlimit">0</span>/20)</div>
                    </td>
                </tr>
		        </tbody>
		    </table>
		</div>

		<div class="floatL2">
		  <button id="btnConfirm" type="button" value="" data-type="button" data-theme="af-btn8"  data-altname="확인"></button>
		  <button id="btnCancel"  type="button" value="" data-type="button" data-theme="af-btn10" data-altname="취소"></button>
		  <button id="btnDelete"  type="button" value="" data-type="button" data-theme="af-btn13" data-altname="삭제" style="display:none;"></button>
		</div>
	
	</form>
	</div>
	</div>
    
</body>
</html>
