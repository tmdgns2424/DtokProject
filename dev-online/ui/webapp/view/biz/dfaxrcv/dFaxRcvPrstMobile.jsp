<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no"/>
    
    <jsp:include page="/view/layouts/default_head.jsp" flush="false" />
    
    <script type="text/javascript">
    var _param = null;
    
    $.alopex.page({

        init : function(id, param) { 
            $.PSNM.initialize(id, param); //PSNM공통 초기화함수 호출

            $("#FROM_DT").val(getCurrdate());
            $("#TO_DT").val(getCurrdate());
            $a.page.setEventListener();
            $a.page.searchList();
        },
        setEventListener : function() {
        	$("#btnSearch").click(function(){$a.page.searchList();});
        	$("#btnApprove").click(function(){
        		
        		var data = _param;
        		
        		if (data == null){
        			$.PSNM.alert("E021", ["승인할 팩스접수번호를"]);
					return;
        		}
        		
        		var param = {};
        			param["data"] = [data];
        		
				if($.PSNMUtils.isNotEmpty(param["data"][0].BIZ_APRV_SUSP_HST_SEQ)){
					$.PSNM.alert("해당 요청 건은 현재 승인을 통한 업무처리가 불가합니다.");
					return false;
				}	
				
				if($.PSNM.getSession("DUTY")=='14'){
					
					if("01" != param["data"][0].BIZ_APRV_OP_ST_CD){
						$.PSNM.alert("승인상태가 승인요청인 건만 처리가 가능합니다.");
						return false;
					}
					
					param["data"][0].BIZ_APRV_YN = "Y"; 
					
					if("Y" == param["data"][0].BIZ_APRV_TPY_YN){ //국장승인업무 구분 ADD_INFO_01
						param["data"][0].BIZ_APRV_OP_ST_CD = "05"; //승인완료
					}else{
						param["data"][0].BIZ_APRV_OP_ST_CD = "03"; //국장승인
					}
					
				}else{
					if("N" != param["data"][0].BIZ_APRV_TPY_YN || "03" != param["data"][0].BIZ_APRV_OP_ST_CD){
						$.PSNM.alert("담당승인 업무면서 승인상태가 국장승인 건만 처리가 가능합니다.");
						return false;
					}
					param["data"][0].BIZ_APRV_YN = "Y"; // 승인팝업여부
					param["data"][0].BIZ_APRV_REQ = "00"; // 담당M 팝업여부
					param["data"][0].BIZ_APRV_OP_ST_CD = "05"; //승인완료
				}
        		$a.popup({
                    url: "biz/dfaxrcv/dFaxBizAprvAppPopup",
                    data: param,
                    width: 300,
                    height: 450,
                    title: "업무승인처리(승인/반려)",
                    callback : function( oResult ) {
                    	 _param  = null;
                    	 $a.page.searchList();
                    }
                });
        	});
        	$("#btnReturn").click(function(){
        		
				var data = _param;
        		
				if (data == null){
        			$.PSNM.alert("E021", ["반려할 팩스접수번호를"]);
					return;
        		}
        		
        		var param = {};
        			param["data"] = [data];
        			
        		if($.PSNM.getSession("DUTY")=='14'){
        			
        			if("01" != param["data"][0].BIZ_APRV_OP_ST_CD){
    					$.PSNM.alert("승인상태가 승인요청인 건만 처리가 가능합니다.");
    					return false;
    				}
    				
    				param["data"][0].BIZ_APRV_YN = "N"; 
    				param["data"][0].BIZ_APRV_OP_ST_CD = "04"; //국장반려
    				
        		}else{
        			if("N" != param["data"][0].BIZ_APRV_TPY_YN || "03" != param["data"][0].BIZ_APRV_OP_ST_CD){
       					$.PSNM.alert("담당승인 업무면서 승인상태가 국장승인 건만 처리가 가능합니다.");
       					return false;
       				}
    				
    				param["data"][0].BIZ_APRV_YN = "N";  // 반려팝업여부
    				param["data"][0].BIZ_APRV_REQ = "00"; // 담당M 팝업여부
    				param["data"][0].BIZ_APRV_OP_ST_CD = "06"; //담당반려
        		}
        		
        		$a.popup({
                    url: "biz/dfaxrcv/dFaxBizAprvAppPopup",
                    data: param,
                    width: 300,
                    height: 450,
                    title: "업무승인처리(승인/반려)",
                    callback : function( oResult ) {
                    	_param  = null;
                   	 	$a.page.searchList();
                    }
                });
        	});
        },
        searchList: function(param) {
        	
        	//전월 이전 자료는 조회 불가
    		var strdDt = getAddMonthDate(0,'yyyymm')+'-'+'01';
    		if($("#FROM_DT").val() < strdDt){
    			$.PSNM.alert('전월 1일 이후만 조회 가능합니다.');
    			$("#FROM_DT").val(getCurrdate());
    			return;
    		}
        	
            $.alopex.request("biz.DFAXRCV@PFAXRCV001_pSearchFaxRcvMobile", {
                data: ["#searchTable", function() {
                	this.data.dataSet.fields.FROM_DT   = $.PSNMUtils.getDateInput("FROM_DT");
                	this.data.dataSet.fields.TO_DT     = $.PSNMUtils.getDateInput("TO_DT");
                }],
                success: function(res) {
					var list = res.dataSet.recordSets;
	             	
					$.each(list, function(key, data) {
						$("#list").setData({resultList: data.nc_list});
					});
                }
            });
        }
    });
    
    function fn_setData(obj){
    	$("li").removeClass("af-pressed");
    	$(obj).addClass("af-pressed");
    	_param = $(obj).getData();
    }

    </script>
    
</head>

<body style="background:none">
	<div id="mobile_wrap">
		<header>
			<h2><a href="#" onclick="javascript:$.PSNM.openLink('/view/main.jsp', null, true);"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/logo.gif"></a> Fax현황/승인요청</h2>
		</header>
		
		<section class="mobile_srch">
			<dl>
				<dt>조회기간</dt>
				<dd>
					<div data-type="daterange" >
						<input id="FROM_DT" name="FROM_DT" data-role="startdate" data-bind="value:FROM_DT" style="width:70px;"/>~
						<input id="TO_DT" name="TO_DT" data-role="enddate" data-bind="value:TO_DT" style="width:70px;"/>
					</div>
				</dd>
			</dl>
			<span class="btn_srch">
				<button id="btnSearch" data-type="button">조회</button>
			</span>
		</section>
		
		<section class="mobile_dfax">
		    <div class="btn_right">
				<button id="btnApprove" data-type="button" class="red">승인</button>
				<button id="btnReturn" data-type="button">반려</button>
			</div>
			<dl>
				<dt>
					<span>팩스접수번호</span>
					<span>수신일시</span>
					<span>고객명</span>
					<span>영업국명</span>
					<span>영업팀명</span>
					<span>에이전트코드</span>
					<span>에이전트명</span>
					<span>담당자명</span>
					<span>처리현황</span>
				</dt>
				<dd>
					<ul id="list" data-type="list" data-bind="foreach: resultList">
						<li onclick="javascript:fn_setData(this);">
							<span><label data-bind="text: FAX_RCV_NO"></label></span>
							<span><label data-bind="text: RCV_DTM"></label></span>
							<span><label data-bind="text: CUST_NM"></label></span>
							<span><label data-bind="text: SALE_DEPT_ORG_NM"></label></span>
							<span><label data-bind="text: SALE_TEAM_ORG_NM"></label></span>
							<span><label data-bind="text: AGNT_ID"></label></span>
							<span><label data-bind="text: AGNT_NM"></label></span>
							<span><label data-bind="text: OPR_NM"></label></span>
							<span class="result"><label data-bind="text: FAX_OP_ST_NM"></label></span>
							<input type="hidden" id="BIZ_APRV_SUSP_HST_SEQ" name="BIZ_APRV_SUSP_HST_SEQ" data-bind="value: BIZ_APRV_SUSP_HST_SEQ"/>
							<input type="hidden" id="BIZ_APRV_TPY_YN" name="BIZ_APRV_TPY_YN" data-bind="value: BIZ_APRV_TPY_YN"/>
							<input type="hidden" id="BIZ_APRV_TPY_CD" name="BIZ_APRV_TPY_CD" data-bind="value: BIZ_APRV_TPY_CD"/>
							<input type="hidden" id="BIZ_APRV_OP_ST_CD" name="BIZ_APRV_OP_ST_CD" data-bind="value: BIZ_APRV_OP_ST_CD"/>
							<input type="hidden" id="BIZ_APRV_REQ_CL_CD" name="BIZ_APRV_REQ_CL_CD" data-bind="value: BIZ_APRV_REQ_CL_CD"/>
							<input type="hidden" id="BIZ_APRV_REQ_CL_NM" name="BIZ_APRV_REQ_CL_NM" data-bind="value: BIZ_APRV_REQ_CL_NM"/>
							<input type="hidden" id="SALE_DEPT_ORG_ID" name="SALE_DEPT_ORG_ID" data-bind="value: SALE_DEPT_ORG_ID"/>
							<input type="hidden" id="SALE_DEPT_ORG_NM" name="SALE_DEPT_ORG_NM" data-bind="value: SALE_DEPT_ORG_NM"/>
							<input type="hidden" id="SALE_TEAM_ORG_NM" name="SALE_TEAM_ORG_NM" data-bind="value: SALE_TEAM_ORG_NM"/>
						</li>
					</ul>
				</dd>
			</dl>
		</section>
	</div>
</body>
</html>
