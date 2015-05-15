<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

    <jsp:include page="/view/layouts/default_head.jsp" flush="false" />

    <script type="text/javascript">
    
    var _param;
    
    $.alopex.page({

        init : function(id, param) { 
            $.PSNM.initialize(id, param); //PSNM공통 초기화함수 호출
            
            _param = param; //이 페이지로 전달된 파라미터를 저장

            $a.page.setEventListener();
            $a.page.setViewData();
        },
        setEventListener : function() {
            $("#btnList").click(function(){
            	$a.back(_param);
            });
        },
        setViewData : function() {
        	var displNgmtNum 	= _param.data != null ? _param.data.DISPL_MGMT_NUM : "";
        	
        	$.alopex.request("biz.AGNTPRZ@PAGENTDSCPL001_pDetailAgentDscpl", {
        		data: {dataSet: {fields: {DISPL_MGMT_NUM : displNgmtNum}}},
                success : "#form"
            });
        }
    });
    </script>

</head>

<body>


<jsp:include page="/view/layouts/default_header.jsp" flush="false" />

<!-- contents area -->
<div id="contents">

    <!-- title area -->
    <div class="content_title">
        <div class="ub_txt6">
            <span class="txt6_img"><b>징계관리</b><span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif"> 
            <span class="a2">영업국업무</span> <span class="a3"> > </span><b>에이전트관리</b></span></span> 
        </div>
    </div>
    
    <!-- btn area -->
    <div class="btn_area">
        <div class="ab_btn_right">
            <button id="btnList" type="button" data-type="button" data-theme="af-btn14" data-altname="목록" data-authtype="R"></button>
        </div>
    </div>
    <!-- btn area end-->
    
	<!--view_table area -->
    <div class="view_list">
	
	    <form id="form" onsubmit="return false;">
	    	<input id="DISPL_MGMT_NUM" name="DISPL_MGMT_NUM" data-bind="value:DISPL_MGMT_NUM" type="hidden">
	    
	    	<div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"/><b>에이전트 정보</b></div>
	        <table class="board02" style="width:100%;">
	        	<colgroup>
		            <col style="width:15%"/>
		            <col style="width:35%"/>
		            <col style="width:15%"/>
		            <col style="width:*"/>
	            </colgroup>
	        	<tr>
	            	<th scope="col" class="fontred">에이전트명</th>
					<td class="tleft">
						<input id="AGNT_NM" name="AGNT_NM" data-bind="value:AGNT_NM" data-type="textinput" data-disabled="true" style="width:130px;"/>
						<input id="AGNT_ID" name="AGNT_ID" data-bind="value:AGNT_ID" data-type="textinput" data-disabled="true" style="width:75px;"/>
					</td>
					<th scope="col">직책명</th>
					<td class="tleft">
						<input id="RPSTY_NM" name="v" data-bind="value:RPSTY_NM" data-type="textinput" data-disabled="true" style="width:150px;"/>
						<input id="RPSTY" name="RPSTY" data-bind="value:RPSTY" data-type="textinput" data-disabled="true" style="width:75px;"/>
					</td>
	         	</tr>
	         	<tr>
					<th scope="col">본사팀</th>
					<td class="tleft">
						<input id="HDQT_TEAM_ORG_NM" name="HDQT_TEAM_ORG_NM" data-bind="value:HDQT_TEAM_ORG_NM" data-type="textinput" data-disabled="true" style="width:150px;"/>
						<input id="HDQT_TEAM_ORG_ID" name="HDQT_TEAM_ORG_ID" data-bind="value:HDQT_TEAM_ORG_ID" data-type="textinput" data-disabled="true" style="width:75px;"/>
					</td>
					<th scope="col">본사파트</th>
					<td class="tleft">
						<input id="HDQT_PART_ORG_NM" name="HDQT_PART_ORG_NM" data-bind="value:HDQT_PART_ORG_NM" data-type="textinput" data-disabled="true" style="width:150px;"/>
						<input id="HDQT_PART_ORG_ID" name="HDQT_PART_ORG_ID" data-bind="value:HDQT_PART_ORG_ID" data-type="textinput" data-disabled="true" style="width:75px;"/>
					</td>
				</tr>
				<tr>
					<th scope="col">영업국명</th>
					<td class="tleft">
						<input id="SALE_DEPT_ORG_NM" name="SALE_DEPT_ORG_NM" data-bind="value:SALE_DEPT_ORG_NM" data-type="textinput" data-disabled="true" style="width:150px;"/>
						<input id="SALE_DEPT_ORG_ID" name="SALE_DEPT_ORG_ID" data-bind="value:SALE_DEPT_ORG_ID" data-type="textinput" data-disabled="true" style="width:75px;"/>
					</td>	
					<th scope="col">영업팀명</th>
					<td class="tleft">
						<input id="SALE_TEAM_ORG_NM" name="SALE_TEAM_ORG_NM" data-bind="value:SALE_TEAM_ORG_NM" data-type="textinput" data-disabled="true" style="width:150px;"/>
						<input id="SALE_TEAM_ORG_ID" name="SALE_TEAM_ORG_ID" data-bind="value:SALE_TEAM_ORG_ID" data-type="textinput" data-disabled="true" style="width:75px;"/>
					</td>
				</tr>
	        </table>
	        
	        <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"/><b>징계정보</b></div>
	        <table class="board02" style="width:100%;">
	        	<colgroup>
		            <col style="width:15%"/>
		            <col style="width:35%"/>
		            <col style="width:15%"/>
		            <col style="width:*"/>
	            </colgroup>
	        	<tr>
					<th scope="col" class="fontred">징계일자</th>
					<td class="tleft">
						<input id="DISPL_DT" name="DISPL_DT" data-bind="value:DISPL_DT" data-type="dateinput" style="width:100px;" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png" data-disabled="true"/>
					</td>
					<th scope="col">징계사유</th>
					<td class="tleft">
						<input id="DISPL_RSN_NM" name="DISPL_RSN_NM" data-bind="value:DISPL_RSN_NM" data-type="textinput" data-disabled="true" style="width:150px;"/>
					</td>
				</tr>
				<tr>
					<th scope="col">PENALTY내용</th>
					<td class="tleft" colspan="3">
						<input id="DISPL_CTT" name="DISPL_CTT" data-bind="value:DISPL_CTT" data-type="textinput" data-disabled="true" style="width:800px;"/>
					</td>
				</tr>
				<tr>
					
				</tr>
	        </table>
	        
	    </form>
	    
	</div>
</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>