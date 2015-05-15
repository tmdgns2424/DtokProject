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
                    { columnIndex : 0, key : "FAQ_TYP_NM",      title : "FAQ 유형",	 	align : "center", 	width : "100px" },
                    { columnIndex : 1, key : "FAQ_TITL_NM",  	title : "제목",			align : "left", 	width : "300px"
                    	, render : function(value, data) {
                    		if(data["ATCH_YN"]=="Y") {
        						return value +'&nbsp;&nbsp;<img src="${pageContext.request.contextPath}/image/blat_adisk.gif">';
        					}
        					return value;
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
   			            		$a.navigate("faqBrwsDtl.jsp", param);
    						}
    					}
    				}
                }
            });
        },
        setCodeData : function() {
            $.PSNMUtils.setCodeData([
				 { t:'code', 'elemid' : 'FAQ_TYP_CD', 'codeid' : 'DSM_FAQ_TYP_CD', 'header' : '-전체-' }
            ]);
        },
        searchList: function(param) {
        	var _page_no = 1;
            if ( $.PSNMUtils.isNotEmpty(param) && $.PSNMUtils.isNotEmpty(param.page) ) {
                _page_no = param.page;
            }
            var _per_page = $("#grid").alopexGrid("pageInfo").perPage;
            
            $.alopex.request("com.FAQMGMT@PFAQMGMT001_pSearchFaq", {
                data: ["#searchTable", function() {
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
            <span class="txt6_img"><b id="sub-title">FAQ</b>
                <span class="notice-more"> 
                	<img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif">
                	<span class="a2">나의 D-tok</span> <span class="a3"> > </span> <span class="a4"><b>소통의장</b></span> 
                </span>
            </span>
        </div>
    </div>

    <!-- find condition area -->
    <div id="searchDiv" class="textAR">
		<form id="searchForm">
        	<table id="searchTable" class="board02" style="width:92%;">
        	<colgroup>
	            <col style="width:15%;"/>
	            <col style="width:20%;"/>
	            <col style="width:15%;"/>
	            <col style="width:*;"/>
            </colgroup>
        	<tbody>
        	<tr>
                <th scope="col">FAQ유형</th>
				<td class="tleft">
                    <select id="FAQ_TYP_CD" data-bind="options:options_FAQ_TYP_CD, selectedOptions:FAQ_TYP_CD" data-type="select"></select>
                </td>
				<th>검색어</th>
				<td class="tleft">
                    <input id="FAQ_CTT" name="FAQ_CTT" data-type="textinput" data-bind="value:FAQ_CTT" style="width:120px"/>
                </td>
            </tr>
        	</tbody>
            </table>
        </form>
        <div class="ab_pos5">
			<button id="btnSearch" data-type="button" data-theme="af-psnm" data-authtype="R"></button>
		</div>
    </div>

    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>FAQ</b></div>

    <!-- main grid -->
    <div id="grid" data-bind="grid:grid"></div>

</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>