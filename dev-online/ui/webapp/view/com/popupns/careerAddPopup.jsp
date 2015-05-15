<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>경력 - PS&Marketing</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />

    <script type="text/javascript">
    $a.page({
        init : function(id, param) {
            $a.page.setEventListener();
            $a.page.setCodeData();
        },
        setEventListener : function() {
            $("#btnConfirm").click( closeConfirm );
            $("#btnCancel").click( closeWithout );
        },
        setCodeData : function() {            
            $.PSNMUtils.setCodeData([
                { t:'code', 'elemid' : 'CAREER_CL_CD', 'header' : '-선택-' },   /* 경력구분 */
                { t:'code', 'elemid' : 'POS_CD', 'header' : '-선택-' },   /* 직위구분 */
            ]);            
        },
    });

    function closeWithout() {
        $a.close();
    }

    function closeConfirm() {
    	
    	//필수입력항목 체크
        if(!$.PSNM.isValid("careerForm")){
            return false;
        }
    	
        if( getBytes($("#CAREER_CO_NM").val()) > 50 ){
            $.PSNM.alert('직장명은 50byte를 초과할 수 없습니다.');
            $("#CAREER_CO_NM").focus();
            return false;
        } 

        if( getBytes($("#CAREER_CHRG_OP").val()) > 100 ){
            $.PSNM.alert('담당업무는 100byte를 초과할 수 없습니다.');
            $("#CAREER_CHRG_OP").focus();
            return false;
        }
        
        $("#CAREER_CL_NM").val( $("#CAREER_CL_CD option:selected").text() );//경력구분명   
        $("#POS_NM").val( $("#POS_CD option:selected").text() );//직위명    
        
        //현재창을 닫고 객체를 반환
    	$a.close( $('#careerForm').getData() );

    }
    </script>
</head>

<body>

<div id="Wrap">

    <!-- title area -->
    <div class="pop_header">
    	<div id="searchDiv" class="textAR">
	        <form id="careerForm" onsubmit="return false;">
		        
		        <input id="CAREER_CL_NM" type="hidden" data-type="hidden" data-bind="value:CAREER_CL_NM" />
		        <input id="POS_NM" type="hidden" data-type="hidden" data-bind="value:POS_NM" />
		        
		        <table id="searchTable" class="board02">
		            <colgroup>
		                <col style="width:25%">
		                <col style="width:*">
		            </colgroup>
		            <tbody>
		            <tr>
		                <th height="40" scope="col" class="fontred">기간</th>
		                <td class="tleft">
		                    <div data-type="daterange" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png" >
		                        <input id="APLY_STA_DT" name="APLY_STA_DT" data-role="startdate" data-bind="value:APLY_STA_DT" data-keyfilter="-" data-keyfilter-rule="digits" style="width:80px;" 
				                       data-validation-rule="{required:true}" 
		                               data-validation-message="{required:$.PSNM.msg('E012', ['시작일'])}" /> 
		                     ~  <input id="APLY_END_DT" name="APLY_END_DT" data-role="enddate" data-bind="value:APLY_END_DT" data-keyfilter="-" data-keyfilter-rule="digits" style="width:80px;"
		                               data-validation-rule="{required:true}" 
                                       data-validation-message="{required:$.PSNM.msg('E012', ['종료일'])}" />
		                    </div>
		                    <ul class="info3">
                                <li>(직접입력가능 입력예 : 1980-01-01)</li>
                            </ul>
		                </td>
		            </tr>
		            <tr>
		                <th class="fontred">경력구분</th>
		                <td class="tleft">
		                    <select id="CAREER_CL_CD" name="CAREER_CL_CD" data-bind="options: options_CAREER_CL_CD, selectedOptions: CAREER_CL_CD" data-type="select" data-wrap="false" 
		                            data-validation-rule="{required:true}" 
                                    data-validation-message="{required:$.PSNM.msg('E012', ['경력구분'])}">
                            </select>
		                </td>
		            </tr>
		            <tr>
                        <th class="fontred">직장명</th>
                        <td class="tleft">
                            <input id="CAREER_CO_NM" data-bind="value:CAREER_CO_NM" data-type="textinput" style="width:100%;"
                               data-validation-rule="{required:true}" 
                               data-validation-message="{required:$.PSNM.msg('E012', ['직장명'])}">
                        </td>
                    </tr>
                    <tr>
                        <th class="fontred">담당업무</th>
                        <td class="tleft">
                            <input id="CAREER_CHRG_OP" data-bind="value:CAREER_CHRG_OP" data-type="textinput" style="width:100%;"
                               data-validation-rule="{required:true}" 
                               data-validation-message="{required:$.PSNM.msg('E012', ['담당업무'])}">
                        </td>
                    </tr>
                    <tr>
                        <th class="fontred">직위</th>
                        <td class="tleft">
                            <select id="POS_CD" name="POS_CD" data-bind="options: options_POS_CD, selectedOptions: POS_CD" data-type="select" data-wrap="false" 
                                    data-validation-rule="{required:true}" 
                                    data-validation-message="{required:$.PSNM.msg('E012', ['직위'])}">
                            </select>
                        </td>
                    </tr>
		            </tbody>
		        </table>
	        </form>
        </div>

        <!--view_table area -->
        <div class="textAR">

            <p class="floatL2">
                <input id="btnConfirm" type="button" value="" data-type="button" data-theme="af-btn8"  data-altname="확인">
                <input id="btnCancel"  type="button" value="" data-type="button" data-theme="af-btn10" data-altname="취소">
            </p>
        </div>

    </div>

</div>

</body>
</html>