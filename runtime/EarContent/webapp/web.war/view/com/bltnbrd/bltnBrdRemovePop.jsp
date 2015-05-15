<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>회원 찾기 - PS&Marketing</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />

    <script type="text/javascript">

    $a.page({
        init : function(id, param) {
        	$a.page.setEventListener();
        	$("#BLTN_BRD_ID").val(param.BLTN_BRD_ID);

        },
        setEventListener : function() {

        	$("#btnConfirm").click( closeConfirm ); //확인
            $("#btnCancel").click( closeWithout );//닫기
        },
    });

    //현재창을 닫고 객체를 반환
    function closeWith(oData) {
        $a.close(oData);
    }

    function closeWithout() {
        $a.close({"result":""});
    }
    
    function closeConfirm() {
    	
    	//alert( $("#BLTN_BRD_ID").val() );
    	
    	//필수입력항목 체크
        if(!$.PSNM.isValid("searchForm")){
            return false;
        }
    	
        if( $("#FROM_DT").val()  > $("#TO_DT").val() ) {
            alert("시작일이 종료일보다 늦습니다.")
            return;
        }
        
        if( !confirm('해당 기간의 게시물을 모두 삭제하시겠습니까?') ) {
            return;
        }
        
        var requestData = $.PSNMUtils.getRequestData("searchForm");

        $.alopex.request("com.BLTNBRD@PBLTNBRD001_pDeleteBltnBrdSrchAll", {

        	data: requestData,
            success : function(res) {
                
                if ( ! $.PSNM.success(res) ) {
                    return;
                }
                
                $.PSNM.alert("I002", ["삭제"]); //"정상적으로 {0} 되었습니다."
                $a.close({"result":"success"});             
            }

        });
    }

    </script>
</head>

<body>

<div id="contents">

    <!-- title area -->
    <div class="pop_header">
    
        <!-- view_table area -->
        <div class="textAR">
            
        <form id="searchForm" onsubmit="return false;">
            <input id="BLTN_BRD_ID" type="hidden" data-type="hidden" data-bind="value:BLTN_BRD_ID" />
            
            <table class="board02">
                <colgroup>
                    <col style="width:20%">
                    <col style="width:*">
                </colgroup>
                <tbody>
                <tr>
                    <th height="40" scope="col" class="fontred">삭제기간</th>
                    <td class="tleft">
                        <div data-type="daterange" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png" >
                            <input id="FROM_DT" name="FROM_DT" data-role="startdate" data-bind="value:FROM_DT" data-keyfilter="-" data-keyfilter-rule="digits" style="width:80px;" 
                                   data-validation-rule="{required:true}" 
                                   data-validation-message="{required:$.PSNM.msg('E012', ['시작일'])}" /> 
                         ~  <input id="TO_DT" name="TO_DT" data-role="enddate" data-bind="value:TO_DT" data-keyfilter="-" data-keyfilter-rule="digits" style="width:80px;"
                                   data-validation-rule="{required:true}" 
                                   data-validation-message="{required:$.PSNM.msg('E012', ['종료일'])}" />
                        </div>
                    </td>
                </tr>

                </tbody>
            </table>
        </form>
        

        <p class="floatL2">
            <input id="btnConfirm" type="button" data-type="button" data-theme="af-btn8"  data-altname="확인">
            <input id="btnCancel"  type="button" data-type="button" data-theme="af-btn10" data-altname="닫기">
        </p>
        </div>

    </div>

</div>

</body>
</html>