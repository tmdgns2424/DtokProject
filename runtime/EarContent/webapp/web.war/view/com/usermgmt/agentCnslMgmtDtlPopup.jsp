<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<title>MA지원상담조회 - PS&Marketing</title>
	
	<jsp:include page="/view/layouts/popup_head.jsp" flush="false" />
	
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/vendor/jquery.ui.widget.js"></script>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/jquery.iframe-transport.js"></script>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/jquery.fileupload.js"></script>
	
    <script type="text/javascript">
    var _param; 
    
    $.alopex.page({
        init : function(id, param) {
            _initParam = param;

            $a.page.setEventListener();
            $a.page.setDetail(param);
            $.PSNMAction.setCmntData(param.APLCNSL_MGMT_NUM);
        },
        setEventListener : function() {  
        	$("#btnConfirm").click( closeWithout );
        },

        setCodeData : function() {
        },
        setDetail : function(param){
        	if($.PSNMUtils.isNotEmpty(param.APLCNSL_MGMT_NUM)){
        		
        		$.alopex.request('agn.AGNTMGMT@PAGENTECCR001_pDetailAgentEccr', {
        			
            		data: { dataSet : { fields : { APLCNSL_MGMT_NUM : param.APLCNSL_MGMT_NUM } } },
            		
            		success : ["#detailTable", function(res){
            		}]
            	});
        	}
        }
    });
    
    function closeWithout() {
        $a.close();
    }
    </script>
</head>

<body>

<div id="Wrap">
    <!-- title area -->
    <div class="pop_header">
        <!--view_table area -->
        <div class="textAR">

            <div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>상담정보</b>
                <p class="ab_pos2">
                </p>
            </div>
		
			<table id="detailTable" class="board02" style="width:100%;">
			<tr>
			    <th scope="col" width="15%">성명(한글)</th>
			    <td width="35%" class="tleft  time">
			        <label data-bind="html:NAME_KOR" data-theme="af-textinput"></label></td>
			    <th width="13%" >연락처</th>
			    <td class="tleft"><span class="tleft  time"></span>
	                <label data-bind="html:MBL_PHON_NUM1" data-theme="af-textinput"></label> -
					<label data-bind="html:MBL_PHON_NUM2" data-theme="af-textinput"></label> -
					<label data-bind="html:MBL_PHON_NUM3" data-theme="af-textinput"></label>
			    </td>
			</tr>
			<tr>
				<th scope="col" width="15%">나이</th>
				<td width="35%" class="tleft  time">
					<label data-bind="html:AGE" data-theme="af-textinput"></label></td>
				<th width="13%" class="fontred">성별</th>
				<td class="tleft"><span class="tleft  time"></span>
					<input id="SEX_M" type="radio" data-bind="checked:SEX" value="M" name="SEX" data-type="radio"/>
					<label for="M">남</label>
					<input id="SEX_W" type="radio" data-bind="checked:SEX" value="W" name="SEX" data-type="radio" />
	                <label for="W">여</label></td>
			</tr>
			<tr>
				<th scope="col" width="15%">판매방식</th>
				<td width="35%" class="tleft  time">
					<label data-bind="html:RETL_TYP_NM" data-theme="af-textinput"></label>
					<!--  <select id="RETL_TYP_CD" data-type="select" data-bind="value:RETL_TYP_CD, options:selectOptionsData, selectedOptions:RETL_TYP_CD" data-wrap="true"></select>-->
				</td>
				<th width="13%" >휴대폰판매경력</th>
				<td class="tleft"><span class="tleft  time"></span>
					<label data-bind="html:SALES_HST" data-theme="af-textinput"></label>
					<!--  <input data-bind="value:SALES_HST" data-type="textinput" data-disabled="true" data-theme="af-textinput"/>-->
				</td>
			</tr>
			<tr>
				<th scope="col">영업예정지역</th>
				<td colspan="3" class="tleft time">
					<label data-bind="html:ACT_ZONE" data-theme="af-textinput"></label>
				</td>
			</tr>
			<tr>
				<th scope="col">문의사항</th>
				<td colspan="3" class="tleft time">
					<p class="cb_dsc"><span data-bind="text: MEMO"></span></p>
				</td>
			</tr>
			</table>
		
			<!--view_댓글 area -->
			<!-- jsp:include page="/view/layouts/cmnt_comm.jsp" flush="false" /> -->
			<div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a20.gif">
				<b>덧글(<label id="count"></label>개)</b>
				<span id="cmntImg" style="display:none;"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a21.gif"></span>
			</div>
			<div class="textAR">
			 	<div id="cmntList" data-bind="foreach: gridcmnt">
			  	<div id="subList">
			   		<div class="cb_info_area">
				      	<div class="cb_section">
				      		<b><label data-bind="text: RGSTR_NM"></label></b><span >| </span><label data-bind="text: RGST_DTM"></label> 
				      	</div>
			   		</div>
			   		<div id="cmntContent" class="cb_dsc_comment">
			     		<p class="cb_dsc"><span data-bind="text: CMNT_CTT"></span></p>
			     		<p class="line"></p>
			   		</div>
			  	</div>
			</div>
		  </div>
		  <p class="floatL2">
                <input id="btnConfirm" type="button" value="" data-type="button" data-theme="af-btn8">
          </p>
		</div>
  	</div>
</div>
</body>
</html>
