<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div class="textAR">
	<div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a20.gif">
		<b>덧글(<label id="count"></label>개)</b>
		<span id="cmntImg" style="display:none;"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a21.gif"></span>
	</div>
	<div class="textAR">
		<div  id="cmnt" class="n_comment_wrap">
			<input id="CMNT_MGMT_ID" name="CMNT_MGMT_ID" type="hidden">
			<div class="f-left" style="width:90%;">
	  			<textarea id="CMNT_CTT" name="CMNT_CTT" cols="40" rows="4" style="width:92%" data-theme="af-textarea" data-bind="value:CMNT_CTT"></textarea>
	  		</div>
	  		<div class="f-right t-right" style="width:10%;">
	    		<input id="btnCmntSave" type="button" data-type="button" data-theme="af-btn38">
	  		</div>
	  		<c:choose>
    		<c:when test="${param.IS_MAINSCHD =='Y'}">
    			<select id="CMNT_OPEN_CL_CD" data-bind="selectedOptions: CMNT_OPEN_CL_CD" data-type="select" style="position:absolute;right:0;top:38px;">
		                 <option value="01">-비공개-</option>
		                 <option value="02">-전체공개-</option>
		                 <option value="03">-영업국공개-</option>
		        </select>
		        <input id="IS_MAINSCHD" name="IS_MAINSCHD" type="hidden">
    		</c:when>
    	</c:choose>
		</div>
	 	<div id="cmntList" data-bind="foreach: gridcmnt">
	  	<div class="mgt10" id="subList">
	  		<input id="CMNT_MGMT_ID" name="CMNT_MGMT_ID" type="hidden" data-bind="value: CMNT_MGMT_ID"/>
	  		<input id="CMNT_SEQ" name="CMNT_SEQ" type="hidden" data-bind="value: CMNT_SEQ"/>
	  		<input id="CMNT_CTT_VAL" name="CMNT_CTT_VAL" type="hidden" data-bind="value: CMNT_CTT"/>
	  		<input type="hidden" data-bind="value: RGSTR_ID"/>
	   		<div class="cb_info_area">
	   			<select id="CMNT_OPEN_CL_CD_VAL" data-bind="selectedOptions: CMNT_OPEN_CL_CD_VAL" data-type="select" style="margin-left:10px;display:none;">
			                 <option value="01">-비공개-</option>
			                 <option value="02">-전체공개-</option>
			                 <option value="03">-영업국공개-</option>
			    </select>
		      	<div class="cb_section">
		      		<b><label data-bind="text: RGSTR_NM"></label></b><span >| </span><label data-bind="text: RGST_DTM"></label> 
		      	</div>
		      	<div class="cb_section2">
		      		<span id="cmntModify" onclick="setCmntToggle(this,'modify', '${param.IS_HEAD}','${param.IS_MAINSCHD}');" style="cursor:pointer;">수정</span><span >| </span>
		      		<span id="cmntDelete" onclick="setCmntToggle(this,'delete', '${param.IS_HEAD}','${param.IS_MAINSCHD}');" style="cursor:pointer;">삭제</span>
		      		<span id="cmntCancel" onclick="setCmntToggle(this,'cancel', '${param.IS_HEAD}','${param.IS_MAINSCHD}');" style="cursor:pointer;display:none;">취소</span>
				</div>
	   		</div>
	   		<div id="cmntContent" class="cb_dsc_comment">
	     		<p class="cb_dsc"><span data-bind="text: CMNT_CTT"></span></p>
	     		<p class="line"></p>
	   		</div>
	  	</div>
	  </div>
  </div>
</div>