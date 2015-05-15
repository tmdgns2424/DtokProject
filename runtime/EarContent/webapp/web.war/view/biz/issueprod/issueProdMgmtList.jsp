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

    var _TX_SEARCH        = "biz.ISSUEPROD@PISSUEPROD001_pSearchIssueProd";
    var _param;
    $.alopex.page({
        init : function(id, param) { 
        	
			$.PSNM.initialize(id, param); //PSNM공통 초기화함수 호출
			_param = param;
			$a.page.setEventListener(); //버튼 초기화
			$a.page.setGrid(); //그리드 초기화
			$("#searchForm").setData(param);    
			if(param.FROM_DT==null && param.TO_DT==null){
           		/* var today = new Date();
                var FROMDay = (today.getFullYear()-1)+"-"+((today.getMonth()+1)<10?"0"+(today.getMonth()+1):(today.getMonth()+1)); // 시작
                var TODay = today.getFullYear()+"-"+((today.getMonth()+1)<10?"0"+(today.getMonth()+1):(today.getMonth()+1)); //현재 년/월
               	$("#FROM_DT").val(FROMDay);
                $("#TO_DT").val(TODay); */
				$("#FROM_DT").val(getAddMonthDate(-11,'yyyymm'));
                $("#TO_DT").val(getCurrdate().substr(0,7));
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
            	$a.navigate("issueProdMgmtDtl.jsp", param);
            });
            $("#btnExcelAll").click(function(){//엑셀저장
            	var oExcelMetaInfo = {
					filename  : "이달의상품관리.xls",
					sheetname : "이달의상품관리",
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

                    { columnIndex : 0, key  : "APLY_YM",  	 	title : "적용년월",       	align : "center",	 width : "150px" },
                    { columnIndex : 1, key  : "ISS_TITL_NM",   	title : "제목",       	align : "left", 	 width : "550px" },
                    { columnIndex : 2, key  : "READ_CNT",   	title : "조회수",       	align : "center",    width : "50px"  },
                    { columnIndex : 3, key  : "RGSTR_NM",    	title : "게시자",         align : "center", 	 width : "100px" },
                    { columnIndex : 4, key  : "RGST_DTM",       title : "게시일", 			align : "center",	 width : "150px" }
                    
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
								param["ISS_ID"]    = data.ISS_ID;
								param["page"]      = $("#grid").alopexGrid("pageInfo").customPaging.current; //
								param["page_size"] = $("#grid").alopexGrid("pageInfo").perPage;
								$a.navigate("issueProdMgmtDtl.jsp", param);
    						}
    					}
    				}
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
					this.data.dataSet.fields.FROM_DT      =  $.PSNMUtils.getDateInput("FROM_DT");    
    				this.data.dataSet.fields.TO_DT      =  $.PSNMUtils.getDateInput("TO_DT");
					this.data.dataSet.fields.page 	   = _page_no;
					this.data.dataSet.fields.page_size = _per_page;
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
		<div class="ub_txt6"> <span class="txt6_img"><b>이달의 상품관리</b> <span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif"> <span class="a2">본사업무</span> <span class="a3"> > </span> <b>커뮤니티관리</b> </span> </span> </div>
	</div>
  <!-- find condition area -->
	<div class="textAR"> 
		<form id="searchForm">
			<table class="board02" style="width:92%">
	        	<colgroup>
		            <col style="width:10%"/>
		            <col style="width:20%"/>
		            <col style="width:10%"/>
		            <col style="width:*"/>
	            </colgroup>
				<tr>
					<th>검색어</th>
					<td class="tleft">
						<input id="SEARCH_NM" name="SEARCH_NM" data-bind="value:SEARCH_NM" data-type="textinput" data-agentid="SEARCH_NM" style="width:40%;" maxlength="10" />
					</td>
					<th>적용기간</th>
					<td class="tleft">
						<div data-type="daterange" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png"  data-pickertype="monthly" data-format="yyyy-MM">
							<input id="FROM_DT" name="FROM_DT" data-role="startdate" data-bind="value:FROM_DT" style="width:70px;"
							   data-validation-rule="{required:true}"
							   data-validation-message="{required:$.PSNM.msg('E012', ['적용기간FROM'])}"/> ~
							<input id="TO_DT" name="TO_DT" data-role="enddate" data-bind="value:TO_DT" style="width:70px;"
							   data-validation-rule="{required:true}"
							   data-validation-message="{required:$.PSNM.msg('E012', ['적용기간TO'])}"/>
						</div>
					</td>
				</tr>
			</table>
      <!-- btn area --> 
				<div class="ab_pos5">
					<input id="btnSearch" type="button" value="" data-type="button" data-theme="af-psnm" data-authtype="R">
				</div>
		</form>
	</div>
	<div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>이달의 상품 목록</b>
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