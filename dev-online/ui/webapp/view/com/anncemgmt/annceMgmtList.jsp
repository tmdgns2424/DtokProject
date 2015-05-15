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
            $a.page.setAuthGrp();
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
            	$a.navigate("annceMgmtRgst.jsp", param);
            });
            $("#btnExcelAll").click(function(){
            	var oExcelMetaInfo = {
                        filename  : "공지사항.xls",
                        sheetname : "공지사항",
                        gridname  : "grid" //그리드ID 
                    };
        		var txid = "com.ANNCEMGMT@PANNCEMGMT001_pSearchAnnce";

        		$.PSNMUtils.downloadExcelAll("searchForm", txid, "grid", oExcelMetaInfo);
            });
            
        },
        setGrid : function() {
        	$("#grid").alopexGrid({
                rowClickSelect : false,
                rowInlineEdit : true,
                columnMapping : [
					{ columnIndex : 0, key : "ANNCE_ID",        title : "공지사항ID",	align : "center", 	width : "80px"  },
                    { columnIndex : 1, key : "RCV_TYP_NM",      title : "공지대상",	 	align : "center", 	width : "80px" },
                    { columnIndex : 2, key : "ANNCE_TITL_NM",  	title : "제목",			align : "left", 	width : "300px"
                    	, render : function(value, data) {
                    		var notice = data["ANNCE_YN"]=="Y" ? '<img src="${pageContext.request.contextPath}/image/blat_a10.gif">&nbsp;' : '';
                    		var file = data["ATCH_YN"]=="Y" ? '&nbsp;&nbsp;<img src="${pageContext.request.contextPath}/image/blat_adisk.gif">' : '';
        					return notice + value + file;
                    	}                    
                    },
                    { columnIndex : 3, key : "MNDT_CHK_YN",    	title : "필수확인",		align : "center", 	width : "60px"  },
                    { columnIndex : 4, key : "VIEW_CNT",    	title : "조회수",		align : "center", 	width : "60px"  },
                    { columnIndex : 5, key : "RGSTR_NM", 		title : "게시자",		align : "center", 	width : "80px"	},
                    { columnIndex : 6, key : "RGSTR_DT", 		title : "게시일",		align : "center", 	width : "80px"	}                   
                ],
                on : {
                	pageSet : function(pageNoToGo) {
                        var p = {};
                            p.page = pageNoToGo;
                            $a.page.searchList(p);
                    },
                    "cell" : {
    					"dblclick" : function(data, eh, e) {
    						if(data._index.column != 0) {
    							
    							var param = $("#searchTable").getData({selectOptions:true});
    							param["data"] 		= data;
    							param["page"]      	= $("#grid").alopexGrid("pageInfo").customPaging.current;
    							param["page_size"] 	= $("#grid").alopexGrid("pageInfo").perPage;
   			            		$a.navigate("annceMgmtDtl.jsp", param);
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
        	$.alopex.request("com.ANNCEMGMT@PANNCEMGMT001_pSearchAnnceAuthGrp", {
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
        searchList: function(param) {
        	var _page_no = 1;
            if ( $.PSNMUtils.isNotEmpty(param) && $.PSNMUtils.isNotEmpty(param.page) ) {
                _page_no = param.page;
            }
            var _per_page = $("#grid").alopexGrid("pageInfo").perPage;
            
            $.alopex.request("com.ANNCEMGMT@PANNCEMGMT001_pSearchAnnce", {
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
            <span class="txt6_img"><b id="sub-title">공지사항관리</b>
                <span class="notice-more"> 
                	<img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif">
                	<span class="a2">본사업무</span> <span class="a3"> > </span> <span class="a4"><b>커뮤니티관리</b></span> 
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
	            <col style="width:22%;"/>
	            <col style="width:10%;"/>
	            <col style="width:22%;"/>
	            <col style="width:10%;"/>
	            <col style="width:*;"/>
            </colgroup>
        	<tbody>
        	<tr>
                <th scope="col">공지대상</th>
				<td class="tleft">
                    <select id="RCV_TYP_CD" data-bind="options:options_RCV_TYP_CD, selectedOptions:RCV_TYP_CD" data-type="select"></select>
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
        </form>
		<div class="ab_pos5">
			<button id="btnSearch" data-type="button" data-theme="af-psnm" data-authtype="R"></button>
		</div>
    </div>

    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>공지사항관리</b>
        <p class="ab_pos2">
            <button id="btnNew" data-type="button" data-theme="af-btn2" data-altname="신규" data-authtype="W"></button>
        	<button id="btnExcelAll" data-type="button" data-theme="af-btn3" data-altname="엑셀다운" data-authtype="W"></button>
        </p>
    </div>

    <!-- main grid -->
    <div id="grid" data-bind="grid:grid"></div>

</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>