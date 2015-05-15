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

    var _TX_SEARCH	= "biz.MAINSCHD@PSCHMGMT001_pSearchSchMgmtBrws";
    var _param;
    
    $.alopex.page({
        init : function(id, param) { 
			$.PSNM.initialize(id, param); //PSNM공통 초기화함수 호출
			
			_param = param;
			
			$a.page.setEventListener(); //버튼 초기화
			$a.page.setGrid(); //그리드 초기화
			$("#searchForm").setData(param);
			
			if(param.SEARCH_DT==null){
            	/* var today = new Date();
                var Day = today.getFullYear()+"-"+((today.getMonth()+1)<10?"0"+(today.getMonth()+1):(today.getMonth()+1)); //현재 년/월
           		$("#SEARCH_DT").val(Day);
           		$("#FROM_DT").val(getAddMonthDate(-12,'yyyymm')); */
                $("#SEARCH_DT").val(getCurrdate().substr(0,7));
           }
			$a.page.searchList(param);
			
			if(_param.tabindex != null){
				$("#tabs").setTabIndex(_param.tabindex);	
			}
			
        },
        setEventListener : function() {
			$("#btnSearch").click($a.page.searchList);//조회
			$('#tabs').bind('tabchange', function(e, index){
			    if(index == 1){
			    	$a.page.setGrid();
			    }
			});
        }, 
        setGrid : function() {
            $("#grid").alopexGrid({
                rowClickSelect : false,
                //rowInlineEdit : true,
                columnMapping : [

                    { columnIndex : 0, key  : "SCH_DT",			title : "일정",			align : "center", 	width : "20%" },
                    { columnIndex : 1, key  : "SCH_TITL_NM",	title : "제목",			align : "left",  	width : "50%" },
                    { columnIndex : 2, key  : "VIEW_CNT",		title : "조회수",			align : "center",	hidden : true },
                    { columnIndex : 3, key  : "BLTNR_NM",		title : "게시자",			align : "center", 	width : "15%" },
                    { columnIndex : 4, key  : "BLTN_DT",		title : "게시일",			align : "center", 	width : "15%" }
                    
                ],
                on : {
                	pageSet : function(pageNoToGo) {
                        var p = {};
                            p.page = pageNoToGo;
                            $a.page.searchList(p);
                    },
                    "cell" : {
    					"click" : function(data, eh, e) {
    						if(data._index.column == 1) {	
	   							var param = $("#searchForm").getData({});
	   							param["tabindex"]	 =	$("#tabs").getCurrentTabIndex();
								param["SCH_ID"]      =	data.SCH_ID;
								param["page"]     	 =	$("#grid").alopexGrid("pageInfo").customPaging.current; //
								param["page_size"]	 =	$("#grid").alopexGrid("pageInfo").perPage;
	   			            	$a.navigate("mainSchdDtl.jsp", param);
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
            
            //$("#calendardata").empty();
            
            $.alopex.request(_TX_SEARCH, {
				data : ["#searchForm", function(){
					this.data.dataSet.fields.SEARCH_DT	=	$.PSNMUtils.getDateInput("SEARCH_DT");
					this.data.dataSet.fields.page		=	_page_no;
					this.data.dataSet.fields.page_size	=	_per_page;
				}],
				success: ["#grid", function(res) {
					
					var htm = "";
					var calendarList 		= res.dataSet.recordSets.calendarList;
					var calendarHdayList 	= res.dataSet.recordSets.calendarHdayList;
					var calendardata		= res.dataSet.recordSets.gridCal;
					
					//달력 그리기
					for( var i = 0 ; i < calendarList.nc_recordCount ; i++ ) {
						htm +=	"<tr><td class='sun' id='day"+calendarList.nc_list[i].SUN+"'><span class='t-right num' id='dayT"+calendarList.nc_list[i].SUN+"'>"+calendarList.nc_list[i].SUN+"</span><ul class='txt-type1' id='dayL"+calendarList.nc_list[i].SUN+"'></ul></td>"
								+"<td id='day"+calendarList.nc_list[i].MON+"'><span class='t-right num' id='dayT"+calendarList.nc_list[i].MON+"'>"+calendarList.nc_list[i].MON+"</span><ul class='txt-type1' id='dayL"+calendarList.nc_list[i].MON+"'></ul></td>"
								+"<td id='day"+calendarList.nc_list[i].TUE+"'><span class='t-right num' id='dayT"+calendarList.nc_list[i].TUE+"'>"+calendarList.nc_list[i].TUE+"</span><ul class='txt-type1' id='dayL"+calendarList.nc_list[i].TUE+"'></ul></td>"
								+"<td id='day"+calendarList.nc_list[i].WED+"'><span class='t-right num' id='dayT"+calendarList.nc_list[i].WED+"'>"+calendarList.nc_list[i].WED+"</span><ul class='txt-type1' id='dayL"+calendarList.nc_list[i].WED+"'></ul></td>"
								+"<td id='day"+calendarList.nc_list[i].THU+"'><span class='t-right num' id='dayT"+calendarList.nc_list[i].THU+"'>"+calendarList.nc_list[i].THU+"</span><ul class='txt-type1' id='dayL"+calendarList.nc_list[i].THU+"'></ul></td>"
								+"<td id='day"+calendarList.nc_list[i].FRI+"'><span class='t-right num' id='dayT"+calendarList.nc_list[i].FRI+"'>"+calendarList.nc_list[i].FRI+"</span><ul class='txt-type1' id='dayL"+calendarList.nc_list[i].FRI+"'></ul></td>"
								+"<td class='last sat' id='day"+calendarList.nc_list[i].SAT+"'><span class='t-right num' id='dayT"+calendarList.nc_list[i].SAT+"'>"+calendarList.nc_list[i].SAT+"</span><ul class='txt-type1' id='dayL"+calendarList.nc_list[i].SAT+"'></ul></td></tr>"
					}
					$("#calendardata").html(htm);
					//달력에 휴일 그리기
					for( var i = 0 ; i < calendarHdayList.nc_recordCount ; i++ ) {
						if(calendarHdayList.nc_list[i].HDAY_CL == '2'){
							document.getElementById("day"+calendarHdayList.nc_list[i].HDAY_DT).className = "sun"
						}
					}
					//달력에 정보 그리기
					var c = {};
					for( var i = 0 ; i < calendardata.nc_recordCount ; i++ ) {
						for( var j = 0 ; j< calendardata.nc_list[i].DCNT ; j ++){
							if(calendardata.nc_list[i].SCH_STA_DT*1+j <=31){
								var id= "dayL"+Number(calendardata.nc_list[i].SCH_STA_DT*1+j);
								if( !c[id] ) {
									c[id] = {};
									c[id].a = $('#' + id );
									c[id].cnt = 0;
								}
								if( c[id].cnt < 2) {
									c[id].a.append( "<li><a href='javascript:goDetail(\"" +  calendardata.nc_list[i].SCH_ID + "\");'>" +  calendardata.nc_list[i].SCH_TITL_NM + "</a></li>" );
									c[id].cnt++;	
								} else if( c[id].cnt == 2 ) {
									c[id].a.append( "<p class='t-right'><a href='javascript:goList(\"" + $.PSNMUtils.getDateInput("SEARCH_DT")+'-'
											+ (calendardata.nc_list[i].SCH_STA_DT*1+j<10?'0'+(calendardata.nc_list[i].SCH_STA_DT*1+j) : calendardata.nc_list[i].SCH_STA_DT*1+j )
											+ "\");'><img src='../../../image/btn_more.gif'/></a><p>" );
									c[id].cnt++;	
								}
							}
						}
					}
				} ]
            });
        }
    });
    function goDetail(param){
    	$a.popup({
			url				:	 "/view/biz/mainschd/mainSchdCldrDtl.jsp"
			, data			:	 { SCH_ID : param ,popli : false }
			, width			:	 900
			, height		:	 700
			, windowpopup	:	 false
			, iframe		:	 true
			, title			:	 "주요일정상세"
        });
    }
    function goList(param){
    	$a.popup({
			url				:	 "/view/biz/mainschd/mainSchdCldrListPopup.jsp"
			, data			: 	{ SCH_DT : param.slice(0, 4)+"-"+param.slice(4, 9) }
			, width			: 	900
			, height		: 	700
			, windowpopup	: 	false
			, iframe		: 	true
			, title			: 	"일정상세"
        });
    }
    </script>
</head>
<body>
<jsp:include page="/view/layouts/default_header.jsp" flush="false" />
	<!-- title area -->
<div id="contents">
	<div class="content_title">
		<div class="ub_txt6"> <span class="txt6_img"><b>주요일정</b> <span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif"> <span class="a2">커뮤니티</span> <span class="a3"> > </span> <b>Main화면 알림</b> </span> </span> </div>
	</div>
	<!-- find condition area -->
	<div class="textAR"> 
		<form id="searchForm">
			<table class="board02" style="width:92%">
			<colgroup>
				<col style="width:10%" />
				<col style="width:*" />
			</colgroup>
			<tr>
				<th scope="col">대상월</th>
				<td class="tleft">
					<input id="SEARCH_DT" name="SEARCH_DT" data-type="dateinput" data-pickertype="monthly" data-bind="value:SEARCH_DT" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png" style="width:70px"/>
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
	<div id="tabs" data-type="tabs">
		<ul>
			<li data-content="#tab1">달력</li>
			<li data-content="#tab2">목록</li>
		</ul>
		<div id="tab1">
		<!-- main calendar -->
			<table id="calendarList" class="tb-col calendar" style="width:100%;">
				<colgroup>
					<col style="width:14%">
					<col style="width:14%">
					<col style="width:14%">
					<col style="width:14%">
					<col style="width:14%">
					<col style="width:14%">
					<col style="*">
				</colgroup>
				<thead>
					<tr>
						<th scope="col" class="sun">일</th>
						<th scope="col">월</th>
						<th scope="col">화</th>
						<th scope="col">수</th>
						<th scope="col">목</th>
						<th scope="col">금</th>
						<th scope="col" class="last sat">토</th>
					</tr>
				</thead>
				<tbody id="calendardata">
				</tbody>
			</table>
   		</div>
   		
		<!-- main grid -->
		<div id="tab2">
			<div id="grid" data-bind="grid:grid"></div>
		</div>
	</div>
</div>
<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />
</body>
</html>