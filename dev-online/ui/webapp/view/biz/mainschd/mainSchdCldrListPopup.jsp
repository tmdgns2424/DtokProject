<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE HTML>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>주요일정상세</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/jquery.fileupload.js"></script>
   
    <script type="text/javascript">
    _LOG_LEVEL = 0; //로그레벨 :: 0=debug, 1=info, 2=error

    var _TX_SEARCH        = "biz.MAINSCHD@PSCHMGMT001_pSearchPopSchMgmtBrws";
    var _param;
    $.alopex.page({
        init : function(id, param) { 
			$.PSNM.initialize(id, param); //PSNM공통 초기화함수 호출
			_param = param;
			$a.page.setEventListener(); //버튼 초기화
			$a.page.setGrid(); //그리드 초기화
			$("#searchForm").setData(param);
			$("#SEARCH_DT").val(_param.SCH_DT);
			$a.page.searchList(param);
        },
        setEventListener : function() {
            $("#btnSearch").click($a.page.searchList);//조회
                       
        }, 
        setGrid : function() {
            $("#grid").alopexGrid({
                rowClickSelect : false,
                rowInlineEdit : true,
                columnMapping : [

                    { columnIndex : 0, key  : "SCH_DT",			title : "일정",			align : "center", 	width : "200px" },
                    { columnIndex : 1, key  : "SCH_TITL_NM",	title : "제목",			align : "left",		width : "450px" },
                    { columnIndex : 2, key  : "VIEW_CNT",		title : "조회수",		align : "center",	width : "100px" },
                    { columnIndex : 3, key  : "BLTNR_NM",		title : "게시자",		align : "center",	width : "100px" },
                    { columnIndex : 4, key  : "BLTN_DT",		title : "게시일",		align : "center",	width : "150px" }
                    
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
    					"click" : function(data, eh, e) {
    						if(data._index.column == 1) {
    							var param = $("#searchForm").getData({});
								param["popli"]		 = true;
								param["SCH_ID"]      = data.SCH_ID;
								param["page"]        = $("#grid").alopexGrid("pageInfo").customPaging.current; //
								param["page_size"]   = $("#grid").alopexGrid("pageInfo").perPage;
    			            	$a.navigate("mainSchdCldrDtl.jsp", param);
    						}
    					}
    				}
                }
            });
        },
        searchList : function(param){
          	var _page_no = 1;
            if ( $.PSNMUtils.isNotEmpty(param) && $.PSNMUtils.isNotEmpty(param.page) ) {
				page_no = param.page; //(설명) 페이지 이동할때만 페이지번호가 넘어옴.
            }
            var _per_page = $('#grid').alopexGrid('pageInfo').perPage;
            $.alopex.request(_TX_SEARCH, {
      			data : ["#searchForm", function(){
					this.data.dataSet.fields.SEARCH_DT	= $.PSNMUtils.getDateInput("SEARCH_DT");
					this.data.dataSet.fields.page		= _page_no;
					this.data.dataSet.fields.page_size	= _per_page;
      			}],
                success: ["#grid", function(res) {
             	}]
            });
        }
    });
    </script>
</head>
<body>

<div id="contents">

    <!-- title area -->
	<div class="pop_header">
		<div class="textAR"> 
			<form id="searchForm">
				<table class="board02" style="width:90%">
					<colgroup>
						<col style="width:10%" />
						<col style="*" />
					</colgroup>
					<tr>
						<th scope="col" class="fontred">대상월</th>
						<td class="tleft">
							<input id="SEARCH_DT" name="SEARCH_DT" data-type="dateinput" data-bind="value:SEARCH_DT" placeholder="yyyy-MM-dd" style="width:80px;" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png"/>
						</td>
					</tr>
				</table>
      <!-- btn area -->
				<div class="ab_pos5">
				<input id="btnSearch" type="button" value="" data-type="button" data-theme="af-psnm" data-authtype="R">
				</div>
			</form>
		</div>
	<!--view_list area -->
		<div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>주요일정 목록</b></div>
	<!-- main grid -->
		<div id="grid" data-bind="grid:grid" data-ui="ds"></div>
	</div>
</div>

</body>
</html>