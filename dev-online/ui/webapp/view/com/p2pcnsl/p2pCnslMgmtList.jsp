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
        	$("#btnNew").click(function(){
            	var param = $('#searchTable').getData({selectOptions:true});
                param["page_size"] = $('#grid').alopexGrid('pageInfo').perPage;
    	        try { 
    	            param["page"]  = $("#grid").alopexGrid("pageInfo").customPaging.current; 
    	        } catch(E) {
    	            param["page"]  = 1; //디폴트 1페이지
    	        }
            	$a.navigate("p2pCnslMgmtRgst.jsp", param);
            });
        },
        setGrid : function() {
        	$("#grid").alopexGrid({
                rowClickSelect : false,
                rowInlineEdit : true,
                columnMapping : [
                    { columnIndex : 0, key : "BLTCONT_ID",       title : "상담ID",	 	align : "center", 	width : "100px" },
                    { columnIndex : 1, key : "BLTCONT_TITL_NM",  title : "제목",			align : "left", 	width : "300px"
                    	, render : function(value, data) {
                    		
                    		var level = data["LV"];
                    		if(level != undefined){
                    			level = level.replace(/ /gi, "&nbsp;");
                    		}
                    		
                    		var nwImg = data["BLTCONT_ST"] == "NW" ? '<img src="${pageContext.request.contextPath}/image/blat_a11.gif">&nbsp;' : '';
                    		var disk  = data["ATCH_YN"] == 'Y' ? '&nbsp;<img src="${pageContext.request.contextPath}/image/blat_adisk.gif"/>' : '';
                    		var reple = data["BLTCONT_TYP_CD"] == "1" ? '<img src="${pageContext.request.contextPath}/image/blat_a25.gif"/>&nbsp;' : '';
                    		var cmnt  = data['CMNT_CNT'] > 0 ? '&nbsp;<font color="red">['+data['CMNT_CNT']+']</font>' : '';
                    	
                    		return level + nwImg + reple + value + cmnt + disk;
						}
                    },
                    { columnIndex : 2, key : "HDQT_PART_ORG_NM", title : "본사파트",		align : "center", 	width : "70px"  },
                    { columnIndex : 3, key : "SALE_DEPT_ORG_NM", title : "영업국명",		align : "center", 	width : "70px"  },
                    { columnIndex : 4, key : "RGSTR_NM", 		 title : "에이전트명",	align : "center", 	width : "70px"	},
                    { columnIndex : 5, key : "RGSTR_DT", 		 title : "등록일",		align : "center", 	width : "70px"	}
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
   			            		$a.navigate("p2pCnslMgmtDtl.jsp", param);
    						}
    					}
    				}
                }
            });
        },
        setCodeData : function() {
            $.PSNMUtils.setCodeData([
				 { t:'code', 'elemid' : 'DSM_BLTCONT_BRWS_COND_CD', 'codeid' : 'DSM_BLTCONT_BRWS_COND_CD', 'header' : '-전체-' }
            ]);
        },
        searchList: function(param) {
        	var _page_no = 1;
            if ( $.PSNMUtils.isNotEmpty(param) && $.PSNMUtils.isNotEmpty(param.page) ) {
                _page_no = param.page;
            }
            var _per_page = $("#grid").alopexGrid("pageInfo").perPage;
            
            $.alopex.request("com.PPCNSLMGMT@PP2PCNSLMGMT001_pSearchP2pCnsl", {
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
            <span class="txt6_img"><b id="sub-title">무엇이든 물어보세요</b>
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
	            <col style="width:15%"/>
	            <col style="width:*"/>
            </colgroup>
        	<tbody>
        	<tr>
                <th scope="col">조회조건</th>
				<td class="tleft">
                    <select id="DSM_BLTCONT_BRWS_COND_CD" data-bind="options:options_DSM_BLTCONT_BRWS_COND_CD, selectedOptions:DSM_BLTCONT_BRWS_COND_CD" data-type="select"></select>&nbsp;
                	<input id="DSM_BLTCONT_BRWS_COND_NM" name="DSM_BLTCONT_BRWS_COND_NM" data-type="textinput" data-bind="value:DSM_BLTCONT_BRWS_COND_NM" style="width:170px"/>
                </td>
            </tr>
        	</tbody>
            </table>
        </form>
		<div class="ab_pos5">
			<button id="btnSearch" data-type="button" data-theme="af-psnm" data-authtype="R"></button>
		</div>
    </div>
    
    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>무엇이든 물어보세요</b>(회사와 의견을 주고 받을 수 있는 공간입니다.)
        <p class="ab_pos2">
            <button id="btnNew" data-type="button" data-theme="af-btn2" data-altname="신규" data-authtype="W"></button>
        </p>
    </div>

    <!-- main grid -->
    <div id="grid" data-bind="grid:grid"></div>

</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>