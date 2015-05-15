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
            $.PSNMUtils.setDefaultYmd("#FROM_DT", "TO_DT");
            $a.page.setEventListener();
            $a.page.setGrid();
            $a.page.setCodeData();
            $("#searchTable").setData(param);  //(설명) 상세페이지에서 돌아오는 경우, 이 값들이 세션스토리지에서 반환됨.
        },
        setEventListener : function() {
        	$("#btnSearch").click($a.page.searchList);
        	$("#btnExcelPage").click(function(){
                var oExcelMetaInfo = {
                        filename  : "미인증회원.xls",
                        sheetname : "미인증회원",
                        gridname  : "gridUser" //그리드ID 
                    };
                $.PSNMUtils.downloadExcelPage("gridUser", oExcelMetaInfo);
            });
        	$("#AGNT_NM").keyup( $.PSNMAction.findAgent );
        },
        setGrid : function() {
            $("#gridUser").alopexGrid({
                rowClickSelect : false,
                rowInlineEdit : true,
                columnMapping : [
                    { columnIndex : 0, key : "USER_ID",             title : "회원ID",	     align : "center", 	width : "100px" },
                    { columnIndex : 1, key : "HDQT_PART_ORG_NM",    title : "본사파트",		 align : "center", 	width : "100px" },
                    { columnIndex : 2, key : "SALE_DEPT_ORG_NM", 	title : "영업국명",		 align : "center", 	width : "80px"	},
                    { columnIndex : 3, key : "SALE_TEAM_ORG_NM", 	title : "영업팀명",		 align : "center", 	width : "80px"	},
                    { columnIndex : 4, key : "RPSTY_NM",            title : "직책명",	     align : "center", 	width : "100px" },
                    { columnIndex : 5, key : "USER_NM", 	        title : "회원명",		 align : "center", 	width : "80px"	},
                    { columnIndex : 6, key : "RGST_DTM", 			title : "가입일",		 align : "center", 	width : "80px"	},
                    { columnIndex : 7, key : "PAST_DAY", 			title : "미인증 일수",	 align : "center", 	width : "80px"	},
                    { columnIndex : 8, key : "DIFF_DAY", 		    title : "잔여인증 일수",	 align : "center", 	width : "80px"	},
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
        },
        searchList: function(param) {
       		if ( ! $.PSNM.isValid("#searchForm") ) {
   			    return false; //값 검증
   			}
        	var _page_no = 1;
            if ( $.PSNMUtils.isNotEmpty(param) && $.PSNMUtils.isNotEmpty(param.page) ) {
                _page_no = param.page;
            }
            var _per_page = $("#gridUser").alopexGrid("pageInfo").perPage;
            
            $.alopex.request("com.USERMGMT@PUSERMGMT001_pSearchNonRealBizUser", {
                data: ["#searchTable", function() {
                    this.data.dataSet.fields.page      = _page_no;
                    this.data.dataSet.fields.page_size = _per_page;
					this.data.dataSet.fields.FROM_DT   = $.PSNMUtils.getDateInput("FROM_DT");
	            	this.data.dataSet.fields.TO_DT     = $.PSNMUtils.getDateInput("TO_DT");                    
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
	            <col style="width:10%"/>
	            <col style="width:30%"/>
	            <col style="width:10%"/>
	            <col style="width:20%"/>
	            <col style="width:10%"/>
	            <col style="width:*"/>
            </colgroup>
            <tr>
				<th class="fontred">본사팀</th>
				<td class="tleft">
                    <select id="HDQT_TEAM_ORG_ID" data-bind="options:options_HDQT_TEAM_ORG_ID, selectedOptions: HDQT_TEAM_ORG_ID" data-type="select" style="width:150px"
                    	data-validation-rule="{required:true}"
						data-validation-message="{required:$.PSNM.msg('E012', ['본사팀'])}">
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
			    <th scope="col">회원명</th>
			    <td class="tleft">
                    <input id="USER_NM" name="USER_NM" data-bind="value:USER_NM" data-type="textinput" style="width:70px;" maxlength="10" />			    
			    </td>
                <th>미인증여부</th>
				<td class="tleft">
					<input id="CERT_YN" type="checkbox" data-type="checkbox" data-bind="checked:CERT_YN" name="CERT_YN">
                </td>			    
            </tr>
            <tr>
                <th>미인증 일수</th>
				<td class="tleft" colspan="5">
                    <input id="PAST_DAY" data-bind="value:PAST_DAY" data-type="textinput" size="5" data-keyfilter-rule="digits">
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
        	<button id="btnExcelPage" type="button" data-type="button" data-theme="af-btn3" data-altname="엑셀다운" data-authtype="R"></button>
        </p>
    </div>

    <!-- main grid -->
    <div id="gridUser" data-bind="grid:gridUser"></div>

</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>