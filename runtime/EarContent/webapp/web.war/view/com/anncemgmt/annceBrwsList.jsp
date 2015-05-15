<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

    <jsp:include page="/view/layouts/default_head.jsp" flush="false" />

    <script type="text/javascript">
    $.alopex.page({

        init : function(id, param) { 
            $.PSNM.initialize(id, param); //PSNM공통 초기화함수 호출
            
            $("#FROM_DT").val(getAddMonthDate(-2,'yyyymmdd'));
            $("#TO_DT").val(getCurrdate());
            
            $a.page.setEventListener();
            $a.page.setGrid(); 
            $a.page.setCodeData();
            $("#searchTable").setData(param);  //(설명) 상세페이지에서 돌아오는 경우, 이 값들이 세션스토리지에서 반환됨.
			$a.page.searchList(param);
        },
        setEventListener : function() {
        	$("#btnSearch").click($a.page.searchList);
        },
        setGrid : function() {
        	$("#grid").alopexGrid({
                rowClickSelect : false,
                rowInlineEdit : true,
                columnMapping : [
                    { columnIndex : 0, key : "RCV_TYP_NM",      title : "공지대상",	 	align : "center", 	width : "100px" },
                    { columnIndex : 1, key : "ANNCE_TITL_NM",  	title : "제목",			align : "left", 	width : "300px"
                    	, render : function(value, data) {
                    		var notice = data["ANNCE_YN"]=="Y" ? '<img src="${pageContext.request.contextPath}/image/blat_a10.gif">&nbsp;' : '';
                    		var file = data["ATCH_YN"]=="Y" ? '&nbsp;&nbsp;<img src="${pageContext.request.contextPath}/image/blat_adisk.gif">' : '';
        					return notice + value + file;
                    	}                    
                    },
                    { columnIndex : 2, key : "RGSTR_DT", 		title : "게시일",		align : "center", 	width : "80px"	}                   
                ],
                on : {
                	pageSet : function(pageNoToGo) {
                        var p = {};
                            p.page = pageNoToGo;
                            $a.page.searchList(p);
                    },
                    "cell" : {
    					"click" : function(data, eh, e) {
    						if(data._index.column != 0) {
    							
    							var param = $("#searchTable").getData({selectOptions:true});
    							param["data"] 		= data;
    							param["page"]      	= $("#grid").alopexGrid("pageInfo").customPaging.current;
    							param["page_size"] 	= $("#grid").alopexGrid("pageInfo").perPage;
   			            		$a.navigate("annceBrwsDtl.jsp", param);
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
        searchList: function(param) {
        	var _page_no = 1;
            if ( $.PSNMUtils.isNotEmpty(param) && $.PSNMUtils.isNotEmpty(param.page) ) {
                _page_no = param.page;
            }
            var _per_page = $("#grid").alopexGrid("pageInfo").perPage;
            
            $.alopex.request("com.ANNCEMGMT@PANNCEMGMT001_pSearchAnnceBrws", {
                data: ["#searchTable", function() {
                	this.data.dataSet.fields.FROM_DT   = $.PSNMUtils.getDateInput("FROM_DT");
                	this.data.dataSet.fields.TO_DT     = $.PSNMUtils.getDateInput("TO_DT");
                    this.data.dataSet.fields.page      = _page_no;
                    this.data.dataSet.fields.page_size = _per_page;
                }],
                success: "#grid"
            });
        }
    });
    
    </script>
    
</head>

<body>

<jsp:include page="/view/layouts/default_header.jsp" flush="false" />

<div id="contents">

    <!-- sub title area -->
    <div class="content_title">
        <div id="ub_txt6">
            <span class="txt6_img"><b id="sub-title">공지사항</b>
                <span class="notice-more"> 
                	<img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif">
                	<span class="a2">커뮤니티</span> <span class="a3"> > </span> <span class="a4"><b>Main화면 알림</b></span> 
                </span>
            </span>
        </div>
    </div>

    <!-- find condition area -->
    <div id="searchDiv" class="textAR">
		<form id="searchForm">
        	<table id="searchTable" class="board02" style="width:92%;">
        	<colgroup>
	            <col style="width:10%;"/>
	            <col style="width:35%;"/>
	            <col style="width:10%;"/>
	            <col style="width:15%;"/>
	            <col style="width:10%;"/>
	            <col style="width:*;"/>
            </colgroup>
        	<tbody>
        	<tr>
        		<th scope="col" class="fontred">조회기간</th>
                <td class="tleft">
                	<div data-type="daterange" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png" >
						<input id="FROM_DT" name="FROM_DT" data-role="startdate" data-bind="value:FROM_DT" style="width:100px;"/>
						~ <input id="TO_DT" name="TO_DT" data-role="enddate" data-bind="value:TO_DT" style="width:100px;"/>
					</div>
				</td>
                <th scope="col">공지대상</th>
				<td class="tleft">
                    <select id="RCV_TYP_CD" data-bind="options:options_RCV_TYP_CD, selectedOptions:RCV_TYP_CD" data-type="select"></select>
                </td>
            	<th scope="col">검색어</th>
				<td class="tleft">
                    <input id="ANNCE_CTT" name="ANNCE_CTT" data-bind="value:ANNCE_CTT" data-type="textinput" />
                </td>
            </tr>
        	</tbody>
            </table>
        </form>
		<div class="ab_pos5">
			<button id="btnSearch" data-type="button" data-theme="af-psnm" data-authtype="R"></button>
		</div>
    </div>

    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>공지사항</b></div>
    <!-- main grid -->
    <div id="grid" data-bind="grid:grid"></div>

</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>