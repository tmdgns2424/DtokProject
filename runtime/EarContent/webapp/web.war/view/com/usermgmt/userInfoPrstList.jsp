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
        	$("#btnExcelPage").click(function(){
                var oExcelMetaInfo = {
                        filename  : "회원정보관리.xls",
                        sheetname : "회원정보관리",
                        gridname  : "gridUser" //그리드ID 
                    };
                $.PSNMUtils.downloadExcelPage("gridUser", oExcelMetaInfo, [12,13]);
            });
        	$("#btnExcelAll").click(function(){
            	var oExcelMetaInfo = {
                        filename  : "회원정보관리.xls",
                        sheetname : "회원정보관리",
                        gridname  : "gridUser" 
                    };

        		$.PSNMUtils.downloadExcelAll("searchForm", "com.USERMGMT@PUSERMGMT001_pSearchUser", "gridUser", oExcelMetaInfo, [12,13]);
            });
        	$("#AGNT_NM").keyup( $.PSNMAction.findAgent );
        },
        setGrid : function() {
            $("#gridUser").alopexGrid({
                rowClickSelect : false,
                rowInlineEdit : true,
                columnMapping : [
                    { columnIndex : 0, key : "USER_ID",            	title : "회원ID",		 align : "center", 	width : "100px" },
                    { columnIndex : 1, key : "USER_NM",  		    title : "회원명",		 align : "center", 	width : "50px"  },
                    { columnIndex : 2, key : "DUTY_NM",             title : "직무",		     align : "center", 	width : "100px" },
                    { columnIndex : 3, key : "HDQT_PART_ORG_NM",    title : "본사파트",		 align : "center", 	width : "100px" },
                    { columnIndex : 4, key : "SALE_DEPT_ORG_NM", 	title : "영업국명",		 align : "center", 	width : "80px"	},
                    { columnIndex : 5, key : "SALE_AGNT_ORG_ID",    title : "에이전트 코드",	 align : "center", 	width : "100px" },
                    { columnIndex : 6, key : "SALE_AGNT_ORG_NM", 	title : "에이전트명",		 align : "center", 	width : "80px"	},
                    { columnIndex : 7, key : "RGST_DTM", 			title : "가입일",		 align : "center", 	width : "100px"	},
                    { columnIndex : 8, key : "SALE_OCCR_DT", 		title : "매출발생일",		 align : "center", 	width : "100px"	},
                    { columnIndex : 9, key : "DAYS", 		        title : "미로그인 일수",	 align : "center", 	width : "80px"	},
                    { columnIndex : 10, key : "SCRB_ST_NM", 		title : "상태",		     align : "center", 	width : "70px"	},
                    { columnIndex : 11, key : "USER_ST_NM", 		title : "퇴직구분",		 align : "center", 	width : "70px"	},
                    { columnIndex : 12, key : "SCRB_ST_CD",         hidden: true                                                },
                    { columnIndex : 13, key : "ATTC_CAT",           hidden: true                                             	}
                ],
                on : {
                    pageSet : function(pageNoToGo) {
                    	var p = {};
	                        p.page = pageNoToGo;
	                        $a.page.searchList(p);
                    },                 
                }
            });
        },
        setCodeData : function() {
            $.PSNMUtils.setCodeData([
				{ t:'duty',  'elemid' : 'DUTY_CD', 'codeid' : '', 'header' : '-전체-' },
                { t:'code',  'elemid' : 'SCRB_ST_CD', 'codeid' : 'DSM_SCRB_ST_CD', 'header' : '-전체-' },                                     
                { t:'code',  'elemid' : 'USER_ST', 'codeid' : 'USER_ST', 'header' : '-전체-' }
            ]);
        },
        searchList: function(param) {
        	var _page_no = 1;
            if ( $.PSNMUtils.isNotEmpty(param) && $.PSNMUtils.isNotEmpty(param.page) ) {
                _page_no = param.page;
            }
            var _per_page = $("#gridUser").alopexGrid("pageInfo").perPage;
            
            $.alopex.request("com.USERMGMT@PUSERMGMT001_pSearchUser", {
                data: ["#searchTable", function() {
                    this.data.dataSet.fields.page      = _page_no;
                    this.data.dataSet.fields.page_size = _per_page;
                }],
                success: ["#gridUser", function(res) {
                }]
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
            <span class="txt6_img"><b id="sub-title">회원정보관리</b>
                <span class="notice-more"> 
                	<img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif">
                	<span class="a2">본사업무</span> <span class="a3"> > </span> <span class="a4"><b>회원정보관리</b></span> 
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
	            <col style="width:22%"/>
	            <col style="width:12%"/>
	            <col style="width:22%"/>
	            <col style="width:12%"/>
	            <col style="width:*"/>
            </colgroup>
            <tr>
				<th class="tleft">본사팀</th>
				<td class="tleft">
                    <select id="HDQT_TEAM_ORG_ID" data-bind="options:options_HDQT_TEAM_ORG_ID, selectedOptions: HDQT_TEAM_ORG_ID" data-type="select" style="width:150px">
                    	<option value="">-전체-</option>
                    </select>
                </td>
                <th>본사파트</th>
				<td class="tleft">
                    <select id="HDQT_PART_ORG_ID" data-bind="options:options_HDQT_PART_ORG_ID, selectedOptions: HDQT_PART_ORG_ID" data-type="select" style="width:150px">
                    	<option value="">-전체-</option>
                    </select>
                </td>
                <th>영업국명</th>
				<td class="tleft">
                    <select id="SALE_DEPT_ORG_ID" data-bind="options:options_SALE_DEPT_ORG_ID, selectedOptions: SALE_DEPT_ORG_ID" data-type="select" style="width:150px">
                    	<option value="">-전체-</option>
                    </select>
                </td>                
            </tr>
            <tr>
				<th>영업팀명</th>
				<td class="tleft">
                    <select id="SALE_TEAM_ORG_ID" data-bind="options:options_SALE_TEAM_ORG_ID, selectedOptions: SALE_TEAM_ORG_ID" data-type="select" style="width:150px">
                    	<option value="">-전체-</option>
                    </select>
                </td>
			    <th scope="col">에이전트명</th>
			    <td class="tleft">
			      	<select id="SALE_AGNT_ORG_ID" data-type="select" data-bind="options:options_SALE_AGNT_ORG_ID, selectedOptions:SALE_AGNT_ORG_ID" style="width:150px;">
			      		<option value="">-전체-</option>
			      	</select>
			    </td>
			    <th scope="col">직무</th>
			    <td class="tleft">
      				<select name="DUTY_CD" id="DUTY_CD" data-bind="options:options_DUTY_CD, selectedOptions: DUTY_CD" data-type="select" style="width:150px">
      					<option value="">-전체-</option>
      				</select>
      			</td>
            </tr>
            <tr>
                <th>가입상태</th>
				<td class="tleft">
                    <select id="SCRB_ST_CD" data-bind="options: options_SCRB_ST_CD, selectedOptions: SCRB_ST_CD" data-type="select" style="width:150px"></select>
                </td>
                <th>회원ID</th>
				<td class="tleft">
                    <input id="USER_ID" data-bind="value:USER_ID" data-type="textinput" style="width:150px">
                </td>
                <th>에이전트명</th>
				<td class="tleft">
                    <input id="AGNT_NM" data-bind="value:AGNT_NM" data-type="textinput" style="width:150px">
                </td>
            </tr>
            <tr>
                <th>재직상태</th>
				<td class="tleft" colspan="5">
                    <select id="USER_ST" data-bind="options: options_USER_ST, selectedOptions: USER_ST" data-type="select" style="width:150px"></select>
                </td>
            </tr>            
            </table>
			<div class="ab_pos4">
				<button id="btnSearch" type="button" data-type="button" data-theme="af-psnm" data-authtype="R"></button>
			</div>
        </form>
    </div>

    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>회원목록</b>
        <p class="ab_pos2">
        	<button id="btnExcelAll" type="button" data-type="button" data-theme="af-n-btn27" data-altname="상세엑셀다운" data-authtype="R"></button>
        	<button id="btnExcelPage" type="button" data-type="button" data-theme="af-btn3" data-altname="엑셀다운" data-authtype="R"></button>
        </p>
    </div>

    <!-- main grid -->
    <div id="gridUser" data-bind="grid:gridUser"></div>

</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>