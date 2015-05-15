<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<style>
	tr.row-style td {
		background-color : #FFFFCC!important;
	}
	</style>
	
    <jsp:include page="/view/layouts/default_head.jsp" flush="false" />

    <script type="text/javascript">
    $.alopex.page({

        init : function(id, param) { 
            $.PSNM.initialize(id, param); //PSNM공통 초기화함수 호출

            $("#FROM_DT").val(getCurrdate());
            $("#TO_DT").val(getCurrdate());
            $a.page.setEventListener();
            $a.page.setGrid();
            $a.page.setCodeData();
            
            if("MAIN" == param.PREV_PAGE){
            	$a.page.searchList();
            }
        },
        setEventListener : function() {
        	$("#btnSearch").click(function(){
        		if ( ! $.PSNM.isValid("#searchForm") ) {
    			    return false; //값 검증
    			}
        		$a.page.searchList();
        	});
			$("#btnRequest").click(function(){
        		
        		var data = $("#griddfaxrcv").alopexGrid("dataGet", {_state:{selected:true}});
        		if(data.length == 0){
        			$.PSNM.alert("E021", ["요청할 팩스접수번호를"]);
					return;
            	}
        		
        		var param = {};
        			param["data"] = data;
        			param["data"][0].BIZ_APRV_REQ_CL_CD = "03"; // 승인요청구분(국장)
        			
        		
       			if($.PSNMUtils.isNotEmpty(param["data"][0].BIZ_APRV_SUSP_HST_SEQ)){
           			$.PSNM.alert("해당 요청 건은 현재 승인을 통한 업무처리가 불가합니다.");
                       return false;
           		}	
        			
        		if($.PSNMUtils.isEmpty(param["data"][0].FAX_SCRB_TYP_YN)){
        			$.PSNM.alert("가입유형이 존재하지 않습니다.");
                    return false;
        		}
        		
        		if($.PSNMUtils.isNotEmpty(param["data"][0].BIZ_APRV_OP_ST_CD) && ("01" == param["data"][0].BIZ_APRV_OP_ST_CD || "03" == param["data"][0].BIZ_APRV_OP_ST_CD || "05" == param["data"][0].BIZ_APRV_OP_ST_CD)){
        			$.PSNM.alert("승인요청 전 또는 요청취소, 국장반려, 담당반려인 경우만 승인요청이 가능합니다.");
                    return false;
        		}
        		
        		if($.PSNMUtils.isNotEmpty(param["data"][0].BIZ_APRV_ST_CD) && "N" != param["data"][0].BIZ_APRV_ST_CD){
           			$.PSNM.alert("승인완료 건은 승인요청이 불가합니다.");
                       return false;
           		}
        		
        		$a.popup({
                    url: "biz/dfaxrcv/dFaxBizAprvReqPopup",
                    data: param,
                    width: 800,
                    height: 500,
                    title: "업무승인요청",
                    callback : function( oResult ) {
                    	if("success" == oResult) $a.page.searchList();
                    }
                });
        	});
        	$("#btnRequestCancel").click(function(){
        		
        		var data = $("#griddfaxrcv").alopexGrid("dataGet", {_state:{selected:true}});
        		if(data.length == 0){
        			$.PSNM.alert("E021", ["요청취소할 팩스접수번호를"]);
					return;
            	}
        		
        		var param = {};
    				param["data"] = data;
        		
        		if("01" != param["data"][0].BIZ_APRV_OP_ST_CD){
           			$.PSNM.alert("승인요청 상태만 요청취소가 가능합니다.");
                       return false;
           		}
        		
        		if(  $.PSNM.confirm("I004", ["요청취소"] ) ){
        			
        			var dataSet = {}, dataSetData = {};
                    dataSetData["fields"] = {
                    		FAX_RCV_NO : param["data"][0].FAX_RCV_NO
                    		, BIZ_APRV_OP_ST_CD : "02"
                    		, BIZ_APRV_REQ_CL_CD : param["data"][0].BIZ_APRV_REQ_CL_CD
                    };
                    dataSet["dataSet"] = dataSetData;
                    
                   	$.alopex.request("biz.DFAXRCV@PFAXRCV001_pSaveFaxRcvBizAprv", {
	                    data: dataSet,
	                    success: function(res) { 
	                    	$a.page.searchList();
	                    }
                	});
        		}
        	});
        	$("#btnApprove").click(function(){
        		var data = $("#griddfaxrcv").alopexGrid("dataGet", {_state:{selected:true}});
        		if(data.length == 0){
        			$.PSNM.alert("E021", ["승인할 팩스접수번호를"]);
					return;
            	}
        		
        		var param = {};
        			param["data"] = data;
        			
				if($.PSNMUtils.isNotEmpty(param["data"][0].BIZ_APRV_SUSP_HST_SEQ)){
					$.PSNM.alert("해당 요청 건은 현재 승인을 통한 업무처리가 불가합니다.");
					return false;
				}	
        			
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
				
        		$a.popup({
                    url: "biz/dfaxrcv/dFaxBizAprvAppPopup",
                    data: param,
                    width: 800,
                    height: 500,
                    title: "업무승인처리(승인/반려)",
                    callback : function( oResult ) {
                    	if("success" == oResult) $a.page.searchList();
                    }
                });
        	});
        	$("#btnReturn").click(function(){
        		var data = $("#griddfaxrcv").alopexGrid("dataGet", {_state:{selected:true}});
        		if(data.length == 0){
        			$.PSNM.alert("E021", ["반려할 팩스접수번호를"]);
					return;
            	}
        		
        		var param = {};
        			param["data"] = data;
        			
				if("01" != param["data"][0].BIZ_APRV_OP_ST_CD){
					$.PSNM.alert("승인상태가 승인요청인 건만 처리가 가능합니다.");
					return false;
				}
				
				param["data"][0].BIZ_APRV_YN = "N"; 
				param["data"][0].BIZ_APRV_OP_ST_CD = "04"; //국장반려
        		
        		$a.popup({
                    url: "biz/dfaxrcv/dFaxBizAprvAppPopup",
                    data: param,
                    width: 800,
                    height: 500,
                    title: "업무승인처리(승인/반려)",
                    callback : function( oResult ) {
                    	if("success" == oResult) $a.page.searchList();
                    }
                });
        	});
        	$("#btnExcelAll").click(function(){
            	var oExcelMetaInfo = {
                        filename  : "접수현황(D_FAX).xls",
                        sheetname : "접수현황(D_FAX)",
                        gridname  : "griddfaxrcv" //그리드ID 
                    };
        		var txid = "biz.DFAXRCV@PFAXRCV001_pSearchFaxRcv";

        		$.PSNMUtils.downloadExcelAll("searchForm", txid, "griddfaxrcv", oExcelMetaInfo);
            });
        	$("#AGNT_NM").keyup( $.PSNMAction.findAgent );
        },
        setGrid : function() {
            $("#griddfaxrcv").alopexGrid({
            	rowSingleSelect : true,
                columnMapping : [
					{ columnIndex : 0, selectorColumn : true, 		width : "30px" 	},
                    { columnIndex : 1, key : "FAX_RCV_NO", 			title : "팩스접수번호",	align : "center", 	width : "75px"	},
                    { columnIndex : 2, key : "RCV_DTM",            	title : "수신일시",		align : "center", 	width : "120px" },
                    { columnIndex : 3, key : "SND_FAX_NUM",  		title : "From",			align : "center", 	width : "75px"  },
                    { columnIndex : 4, key : "FAX_FILE_PG",    		title : "페이지수",		align : "center", 	width : "50px" 	},
                    { columnIndex : 5, key : "FAX_UNIT_TYP_NM",     title : "상품유형",		align : "center", 	width : "70px" 	},
                    { columnIndex : 6, key : "FAX_SCRB_TYP_NM", 	title : "가입유형",		align : "center", 	width : "60px"	},
                    { columnIndex : 7, key : "BF_COM_NM", 			title : "이전사업자",		align : "center", 	width : "80px"	},
                    { columnIndex : 8, key : "PROD_ABBR_NM", 		title : "상품약어명",		align : "center", 	width : "80px"	},
                    { columnIndex : 9, key : "CUST_NM", 			title : "고객명",		align : "center", 	width : "55px"	},
                    { columnIndex : 10, key : "HDQT_PART_ORG_NM", 	title : "본사파트",		align : "center", 	width : "80px"	},
                    { columnIndex : 11, key : "SALE_DEPT_ORG_NM", 	title : "영업국명",		align : "center", 	width : "80px"	},
                    { columnIndex : 12, key : "SALE_TEAM_ORG_NM", 	title : "영업팀명",		align : "center", 	width : "70px"	},
                    { columnIndex : 13, key : "AGNT_ID",			title : "에이전트코드",	align : "center", 	width : "75px"	},
                    { columnIndex : 14, key : "AGNT_NM", 			title : "에이전트명",		align : "center", 	width : "100px"	},
                    { columnIndex : 15, key : "OPR_NM", 			title : "담당자명",		align : "center", 	width : "55px"	},
                    { columnIndex : 16, key : "FAX_OP_ST_NM", 		title : "처리현황",		align : "center", 	width : "50px"	},
                    { columnIndex : 17, key : "BIZ_APRV_TPY_NM", 	title : "업무유형",		align : "center", 	width : "150px"	},
                    { columnIndex : 18, key : "BIZ_APRV_ST_NM", 	title : "승인상태",		align : "center", 	width : "50px"	},
                    { columnIndex : 19, key : "MEMO", 				title : "메모",			align : "left", 	width : "200px"	},
                    { columnIndex : 20, key : "CNSNT_MEMO", 		title : "동의",			align : "center", 	width : "90px"	}
                ],
                on : {
                    pageSet : function(pageNoToGo) {
                    	var p = {};
	                        p.page = pageNoToGo;
	                        $a.page.searchList(p);
                    }
                },
                rowOption : {
					styleclass : function(data, rowOption) {
                        if("02" == data["BIZ_APRV_TPY_CD"] && "05" != data["BIZ_APRV_OP_ST_CD"]) {
                            return "row-style";
                        }
                    }
                }
            });
        },
        setCodeData : function() {
            $.PSNMUtils.setCodeData([
                { t:'code',  'elemid' : 'FAX_OP_ST_CD', 'codeid' : 'DSM_FAX_OP_ST_CD', 'header' : '-전체-' },
                { t:'code',  'elemid' : 'BIZ_APRV_ST_CD', 'codeid' : 'DMS_BIZ_APRV_ST_CD', 'header' : '-전체-' }
            ]);
        },
        searchList: function(param) {
        	
        	//전월 이전 자료는 조회 불가
    		var strdDt = getAddMonthDate(0,'yyyymm')+'-'+'01';
    		if($("#FROM_DT").val() < strdDt){
    			$.PSNM.alert('전월 1일 이후만 조회 가능합니다.');
    			$("#FROM_DT").val(getCurrdate());
    			return;
    		}
        	
        	var _page_no = 1;
            if ( $.PSNMUtils.isNotEmpty(param) && $.PSNMUtils.isNotEmpty(param.page) ) {
                _page_no = param.page;
            }
            var _per_page = $("#griddfaxrcv").alopexGrid("pageInfo").perPage;
            
            $.alopex.request("biz.DFAXRCV@PFAXRCV001_pSearchFaxRcv", {
                data: ["#searchTable", function() {
                	this.data.dataSet.fields.FROM_DT   = $.PSNMUtils.getDateInput("FROM_DT");
                	this.data.dataSet.fields.TO_DT     = $.PSNMUtils.getDateInput("TO_DT");
                    this.data.dataSet.fields.page      = _page_no;
                    this.data.dataSet.fields.page_size = _per_page;
                    this.data.dataSet.fields.BIZ_REQ   = "HEAD";
                }],
                success: ["#griddfaxrcv", "#totcount"]
            });
        }
    });

    </script>

</head>

<body>

<jsp:include page="/view/layouts/default_header.jsp" flush="false" />

<!-- contents area -->
<div id="contents">

	<!-- sub title area -->
    <div class="content_title">
        <div id="ub_txt6">
            <span class="txt6_img"><b id="sub-title">Fax현황/업무승인</b>
                <span class="notice-more"> 
                	<img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif">
                	<span class="a2">영업국업무</span> <span class="a3"> > </span> <span class="a4"><b>판매관리</b></span> 
                </span>
            </span>
        </div>
    </div>

    <!-- find condition area -->
    <div id="searchDiv" class="textAR">
		<form id="searchForm" onsubmit="return false;">
        	<table id="searchTable" class="board02" style="width:92%;">
        	<colgroup>
	            <col style="width:12%"/>
	            <col style="width:25%"/>
	            <col style="width:12%"/>
	            <col style="width:15%"/>
	            <col style="width:12%"/>
	            <col style="width:*"/>
            </colgroup>
            <tr>
                <th scope="col" class="fontred">조회기간</th>
                <td class="tleft">
                	<div data-type="daterange" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png" >
						<input id="FROM_DT" name="FROM_DT" data-role="startdate" data-bind="value:FROM_DT" style="width:70px;"/>
						~ <input id="TO_DT" name="TO_DT" data-role="enddate" data-bind="value:TO_DT" style="width:70px;"/>
					</div>
				</td>
				<th class="fontred">본사팀</th>
				<td class="tleft">
                    <select id="HDQT_TEAM_ORG_ID" data-bind="options:options_HDQT_TEAM_ORG_ID, selectedOptions: HDQT_TEAM_ORG_ID" data-type="select" 
                    	data-validation-rule="{required:true}"
						data-validation-message="{required:$.PSNM.msg('E012', ['본사팀'])}">
                    	<option value="">-선택-</option>
                    </select>
                </td>
                <th class="fontred">본사파트</th>
				<td class="tleft">
                    <select id="HDQT_PART_ORG_ID" data-bind="options:options_HDQT_PART_ORG_ID, selectedOptions: HDQT_PART_ORG_ID" data-type="select" 
                    	data-validation-rule="{required:true}"
						data-validation-message="{required:$.PSNM.msg('E012', ['본사파트'])}">
                    	<option value="">-선택-</option>
                    </select>
                </td>
            </tr>
            <tr>
                <th class="fontred">영업국명</th>
				<td class="tleft">
                    <select id="SALE_DEPT_ORG_ID" data-bind="options:options_SALE_DEPT_ORG_ID, selectedOptions: SALE_DEPT_ORG_ID" data-type="select" 
                    	data-validation-rule="{required:true}"
						data-validation-message="{required:$.PSNM.msg('E012', ['영업국명'])}">
                    	<option value="">-선택-</option>
                    </select>
                </td>
				<th>영업팀명</th>
				<td class="tleft">
                    <select id="SALE_TEAM_ORG_ID" data-bind="options:options_SALE_TEAM_ORG_ID, selectedOptions: SALE_TEAM_ORG_ID" data-type="select" >
                    	<option value="">-선택-</option>
                    </select>
                </td>
                <th>에이전트명</th>
				<td class="tleft">
                    <input id="AGNT_NM" name="AGNT_NM" data-bind="value:AGNT_NM" data-type="textinput" data-agentid="AGNT_ID" style="width:70px;" maxlength="10" />
                    <input id="AGNT_ID" name="AGNT_ID" data-bind="value:AGNT_ID" data-type="textinput" data-disabled="true" style="width:70px;" />
                </td>
            </tr>
            <tr>
                <th>처리현황</th>
				<td class="tleft">
                    <select id="FAX_OP_ST_CD" data-bind="options: options_FAX_OP_ST_CD, selectedOptions: FAX_OP_ST_CD" data-type="select" ></select>
                </td>
                <th>승인상태</th>
				<td class="tleft" colspan="3">
                    <select id="BIZ_APRV_ST_CD" data-bind="options: options_BIZ_APRV_ST_CD, selectedOptions: BIZ_APRV_ST_CD" data-type="select" ></select>
                </td>
            </tr>
            </table>
			<div class="ab_pos4">
				<button id="btnSearch" type="button" data-type="button" data-theme="af-psnm" data-authtype="R"></button>
			</div>
        </form>
    </div>

    <div id="totcount" class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>Fax현황/업무승인</b>
    	(<b>총 <label data-bind="text:TOT_CNT">0</label>건</b> : 접수 <label data-bind="text:CNT1">0</label>, 배정 <label data-bind="text:CNT2">0</label>, 보류 <label data-bind="text:CNT3">0</label>, 삭제 <label data-bind="text:CNT4">0</label>, 완료 <label data-bind="text:CNT5">0</label>)
        <p class="ab_pos2">
<!--         	<button id="btnRequest"       	type="button" data-type="button" data-theme="af-btn96"  data-altname="승인요청" data-authtype="W"></button>
            <button id="btnRequestCancel" 	type="button" data-type="button" data-theme="af-btn97" data-altname="요청취소" data-authtype="W"></button>
        	<button id="btnApprove"       	type="button" data-type="button" data-theme="af-btn5"  data-altname="승인" data-authtype="W"></button>
        	<button id="btnReturn"        	type="button" data-type="button" data-theme="af-btn6"  data-altname="반려" data-authtype="W"></button>  -->
        	<button id="btnExcelAll" 		type="button" data-type="button" data-theme="af-btn3" data-altname="엑셀다운" data-authtype="W"></button>
        </p>
    </div>

    <!-- main grid -->
    <div id="griddfaxrcv" data-bind="grid:griddfaxrcv"></div>

</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>