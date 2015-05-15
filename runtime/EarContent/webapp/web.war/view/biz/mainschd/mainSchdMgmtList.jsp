<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <jsp:include page="/view/layouts/default_head.jsp" flush="false" />
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/vendor/jquery.ui.widget.js"></script>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/jquery.iframe-transport.js"></script>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/jquery.fileupload.js"></script>
    <script type="text/javascript">
    _LOG_LEVEL = 0; //로그레벨 :: 0=debug, 1=info, 2=error
    var _TX_SEARCH        = "biz.MAINSCHD@PSCHMGMT001_pSearchSchMgmt";
    var _param;
    $.alopex.page({
        init : function(id, param) { 
            $.PSNM.initialize(id, param); //PSNM공통 초기화함수 호출
            _param = param;
            $a.page.setEventListener(); //버튼 초기화
            $a.page.setGrid(); //그리드 초기화
            $a.page.setCodeData();
            $a.page.setAuthGrp();
            $("#searchForm").setData(param);
            if(param.SEARCH_DT==null){
            	/* var today = new Date();
                var Day = today.getFullYear()+"-"+((today.getMonth()+1)<10?"0"+(today.getMonth()+1):(today.getMonth()+1)); //현재 년/월
           		$("#SEARCH_DT").val(Day); */
           		$("#SEARCH_DT").val(getCurrdate().substr(0,7));
           }
            $a.page.searchList(param);
        },
        setEventListener : function() {
            $("#btnSearch").click($a.page.searchList);//조회
            $("#btnNew").click(function(){//신규
			var param = $('#searchForm').getData();
			param["page_size"] = $('#grid').alopexGrid('pageInfo').perPage;
			try { 
				param["page"]  = $("#grid").alopexGrid("pageInfo").customPaging.current; 
			} catch(E) {
				param["page"]  = 1; //디폴트 1페이지
			}
			$a.navigate("mainSchdMgmtRgst.jsp", param);
            });
            $("#btnExcelAll").click(function(){//엑셀저장
            	var oExcelMetaInfo = {
                        filename  : "중요일정관리.xls",
                        sheetname : "중요일정관리",
                        gridname  : "grid" //그리드ID 
                    };
        		$.PSNMUtils.downloadExcelAll("searchForm", _TX_SEARCH, "grid", oExcelMetaInfo);
            });
        }, 
        setGrid : function() {
            $("#grid").alopexGrid({
                rowClickSelect : false,
                rowInlineEdit : true,
                columnMapping : [
                    { columnIndex : 0, key  : "SCH_DT",   			title : "일정",		align : "center", width : "200px"  },
                    { columnIndex : 1, key  : "SCH_TITL_NM",    	title : "제목",		align : "left",   width : "450px" },
                    { columnIndex : 2, key  : "VIEW_CNT",      		title : "조회수", 		align : "center", width : "100px" },
                    { columnIndex : 3, key  : "BLTNR_NM",       	title : "게시자", 		align : "center", width : "100px" },
                    { columnIndex : 4, key  : "BLTN_DT",       		title : "게시일", 		align : "center", width : "150px" }
                ],
                on : {
                    perPageChange : function(arg1) {
                    },
                    pageSet : function(pageNoToGo) {
                    	var p = {};
                        p.page = pageNoToGo;
                    	$a.page.searchList(p); //페이지 이동
                    },
                    "cell" : {
    					"dblclick" : function(data, eh, e) {
    						if(data._index.column == 1) {
								var param = $("#searchForm").getData({});
								param["SCH_ID"]		= 	data.SCH_ID;
								param["page"]		= 	$("#grid").alopexGrid("pageInfo").customPaging.current; 
								param["page_size"]	= 	$("#grid").alopexGrid("pageInfo").perPage;
								$a.navigate("mainSchdMgmtDtl.jsp", param);
    						}
    					}
    				}
                }
            });
        },
        setCodeData : function() {
            $.PSNMUtils.setCodeData([
				{ t:'code', 'elemid' : 'RCV_TYP_CD', 'codeid' : 'DSM_RCV_TYP_CD', 'header' : '-전체-' }
            ]);
        },
        setAuthGrp : function() {
        	$.alopex.request("biz.MAINSCHD@PSCHMGMT001_pSearchSchMgmtAuthGrp", {
	        	success: function(res) {
	                var codeList = res.dataSet.recordSets.resultList.nc_list;
	
	                var codeOptions = [];
	                    codeOptions.push({ value: "", text: "-전체-"});
	
	                $.each(codeList, function (index, codeinfo) {
	                    var codeOpt = new Object();
	                        codeOpt["value"] = codeinfo.AUTH_GRP_ID;
	                        codeOpt["text"]  = codeinfo.AUTH_GRP_NM;
	                    codeOptions.push(codeOpt);
	                });
	                var optData = new Object();
	                    optData["options_AUTH_GRP_ID"] = codeOptions;
	
	                $("#AUTH_GRP_ID").setData(optData);
	            }
            });
        },
        searchList : function(param){
          	var _page_no = 1;
			if ( $.PSNMUtils.isNotEmpty(param) && $.PSNMUtils.isNotEmpty(param.page) ) {
				_page_no = param.page; //(설명) 페이지 이동할때만 페이지번호가 넘어옴.
			}
            var _per_page = $('#grid').alopexGrid('pageInfo').perPage;
            $.alopex.request(_TX_SEARCH, {  
				data : ["#searchForm", function(){
					this.data.dataSet.fields.SEARCH_DT   = 	$.PSNMUtils.getDateInput("SEARCH_DT");
					this.data.dataSet.fields.page 	  	 = 	_page_no;
					this.data.dataSet.fields.page_size	 = 	_per_page;
				}],
				success: ["#grid", function(res) {
				}]
            });
        }
    });
    </script>
</head>
<body>
<jsp:include page="/view/layouts/default_header.jsp" flush="false" />
<!-- title area -->
<div id="contents">
	<div class="content_title">
		<div class="ub_txt6"> <span class="txt6_img"><b>주요일정관리</b> <span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif"> <span class="a2">본사업무</span> <span class="a3"> > </span> <b>커뮤니티관리</b> </span> </span> </div>
	</div>
	<!-- find condition area -->
    <div class="textAR"> 
		<form id="searchForm">
			<table id="searchTable" class="board02" style="width:92%;">
        	<colgroup>
	            <col style="width:10%;"/>
	            <col style="width:22%;"/>
	            <col style="width:10%;"/>
	            <col style="width:22%;"/>
	            <col style="width:10%;"/>
	            <col style="width:*;"/>
            </colgroup>
        	<tbody>
        	<tr>
        		<th scope="col">대상월</th>
					<td class="tleft">
						<input id="SEARCH_DT" name="SEARCH_DT" data-type="dateinput" data-pickertype="monthly" data-bind="value:SEARCH_DT" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png" style="width:70px"/>
					</td>
                <th scope="col">본사팀</th>
				<td class="tleft">
                    <select id="HDQT_TEAM_ORG_ID" data-bind="options:options_HDQT_TEAM_ORG_ID, selectedOptions: HDQT_TEAM_ORG_ID" data-type="select" >
                    	<option value="">-선택-</option>
                    </select>
                </td>
                <th scope="col">본사파트</th>
				<td class="tleft">
                    <select id="HDQT_PART_ORG_ID" data-bind="options:options_HDQT_PART_ORG_ID, selectedOptions: HDQT_PART_ORG_ID" data-type="select" >
                    	<option value="">-선택-</option>
                    </select>
                </td>
            </tr>
            <tr>
            	<th scope="col">권한그룹</th>
				<td class="tleft">
                    <select id="AUTH_GRP_ID" data-bind="options: options_AUTH_GRP_ID, selectedOptions: AUTH_GRP_ID" data-type="select"></select>
                </td>	
            	<th scope="col">게시자</th>
				<td class="tleft" colspan="3">
                    <input id="USER_NM" name="USER_NM" data-bind="value:USER_NM" data-type="textinput" />
                </td>
            </tr>
        	</tbody>
            </table>
	<!-- btn area -->
			<div class="ab_pos5">
				<input id="btnSearch" type="button" value="" data-type="button" data-theme="af-psnm" data-authtype="R">
			</div>
		</form>
	</div>
	<div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>주요일정 목록</b>
		<p class="ab_pos2">
			<button id="btnNew" type="button" data-type="button" data-theme="af-btn2" data-altname="신규" data-authtype="W"></button>
			<button id="btnExcelAll" type="button" data-type="button" data-theme="af-btn3" data-altname="엑셀다운" data-authtype="W"></button>
		</p>
	</div>

	<!-- main grid -->
	<div id="grid" data-bind="grid:grid" data-ui="ds"></div>
</div>
<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />
</body>
</html>