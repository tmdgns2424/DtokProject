<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

    <jsp:include page="/view/layouts/default_head.jsp" flush="false" />

    <script type="text/javascript">

    $.alopex.page({

        init : function(id, param) { 
            $.PSNM.initialize(id, param); //PSNM공통 초기화함수 호출(서브 페이지에서는 필수 호출)
            $a.page.setEventListener();
            $a.page.setGrid();
            $('#searchTable').setData(param); //(설명) 상세페이지에서 돌아오는 경우, 이 값들이 세션스토리지에서 반환됨.
            
            if( Object.keys($("#searchTable").getData()).length > 0){
            	$a.page.searchList(param);
            }
        },
        setEventListener : function() {
            $("#btnSearch").click( $a.page.searchList );
         
        }, //end-of-setEventListener
        setGrid : function() {
            //그리드 초기화
            $("#grid").alopexGrid({
                columnMapping : [
                    { columnIndex : 0,  key : "OUT_ORG_NM",            title : "본사파트",       align : "center", 	width : "50px" },
                    { columnIndex : 1,  key : "SALE_DEPT_ORG_NM",      title : "영업국명",       align : "center", 	width : "50px" },
                    { columnIndex : 2,  key : "SALE_TEAM_ORG_NM",      title : "영업팀명", 		align : "center", 	width : "50px" },
                    { columnIndex : 3,  key : "AGNT_ID",      title : "에이전트코드",   align : "center", 	width : "50px" },
                    { columnIndex : 4,  key : "RPSTY_NM", 			   title : "직책명",         align : "center", 	width : "50px" },
                    { columnIndex : 5,  key : "AGNT_NM",      		   title : "에이전트명",     align : "center", 	width : "50px" },
                    { columnIndex : 6,  key : "MBL_PHON_NUM",          title : "전화번호",   	align : "left", 	width : "50px" },
                    { columnIndex : 7,  key : "FAX_NUM",      		   title : "팩스번호",   	align : "left", 	width : "50px" },
                    { columnIndex : 8,  key : "EMAIL",  			   title : "이메일", 		align : "left", 	width : "100px" },
                    { columnIndex : 9,  key : "ADDR",  				   title : "주소", 			align : "left", 	width : "300px" },
                    { columnIndex : 10, key : "USER_ID",  			   hidden: true },
                    { columnIndex : 11, key : "DUTY_CD",  			   hidden: true },
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
    			        			param["data"]      = data;
    								param["page"]      = $("#grid").alopexGrid("pageInfo").customPaging.current;
    				            	param["page_size"] = $("#grid").alopexGrid("pageInfo").perPage;
    				            $a.navigate("../../com/usermgmt/userInfoMgmtDtl.jsp", param);
    						}
    					}
                    	,
                    	"click" : function(data, eh, e) {    //표준 : 더블클릭시 상세페이지로 이동함.                            
                        	if ( $.PSNMUtils.isMobile() ) {
        						if(data._index.column != 0) {
	        						var param = $("#searchTable").getData({selectOptions:true});
	    			        			param["data"]      = data;
	    								param["page"]      = $("#grid").alopexGrid("pageInfo").customPaging.current;
	    				            	param["page_size"] = $("#grid").alopexGrid("pageInfo").perPage;
	    				            $a.navigate("../../com/usermgmt/userInfoMgmtDtl.jsp", param);
        						}
                        	}
                        },
    				}
                }
            });
        },
        searchList: function(param) {
            var _page_no = 1;
            if ( $.PSNMUtils.isNotEmpty(param) && $.PSNMUtils.isNotEmpty(param.page) ) {
                _page_no = param.page;
            }
            var _per_page = $("#grid").alopexGrid("pageInfo").perPage;
            
            $.alopex.request("agn.AGNTMGMT@PAGENTCNTRT001_pSearchAgentInfo", {
                data: ["#searchTable", function() {
                	this.data.dataSet.fields.page      = _page_no;
                    this.data.dataSet.fields.page_size = _per_page;
                }],
                success: ["#grid", function(res) {
                }]
            });
        }
    });//end-of-$.alopex.page //-------------------------------------------------------------------------------------------------------//

    </script>

</head>

<body>

<jsp:include page="/view/layouts/default_header.jsp" flush="false" />

<div id="contents">

    <!-- sub title area -->
    <div class="content_title">
        <div class="ub_txt6">
            <span class="txt6_img"><b id="sub-title">판매자 정보관리(통합)</b>
                <span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif">
                <span class="a2">대메뉴명</span> <span class="a3"> > </span> <span class="a4"><b>중메뉴명</b></span> 
            </span>
        </div>
    </div>

    <!-- find condition area -->
    <div id="searchDiv" class="textAR">
        <form id="searchForm" onsubmit="return false;">
            <table id="searchTable" class="board02" style="width:92%;">
	       	<colgroup>
	            <col style="width:10%"/>
	            <col style="width:18%"/>
	            <col style="width:15%"/>
	            <col style="width:27%"/>
	            <col style="width:10%"/>
	            <col style="width:*"/>
           </colgroup>
            <tr>
                <th>에이전트명</th>
                <td class="tleft">
                    <input id="AGNT_NM" name="AGNT_NM" data-bind="value: AGNT_NM" data-type="textinput" style="width:150px;" />
                </td>
                <th>전화번호</th>
                <td class="tleft">
                    <input id="MBL_PHON_NUM1" name="MBL_PHON_NUM1" data-bind="value: MBL_PHON_NUM1" data-type="textinput" style="width:60px;" /> - &nbsp;
                    <input id="MBL_PHON_NUM2" name="MBL_PHON_NUM2" data-bind="value: MBL_PHON_NUM2" data-type="textinput" style="width:60px;" /> - &nbsp;
                    <input id="MBL_PHON_NUM3" name="MBL_PHON_NUM3" data-bind="value: MBL_PHON_NUM3" data-type="textinput" style="width:60px;" />
                </td>
                <th>이메일</th>
                <td class="tleft">
                    <input id="EMAIL" name="EMAIL" data-bind="value: EMAIL" data-type="textinput" style="width:150px;" />
                </td>
            </tr>
            <tr>
                <th>주소</th>
                <td class="tleft">
                    <input id="ADDR" name="ADDR" data-bind="value: ADDR" data-type="textinput" style="width:150px;" />
                </td>
                <th>FAX번호</th>
                <td class="tleft">
                    <input id="FAX_NUM1" name="FAX_NUM1" data-bind="value: FAX_NUM1" data-type="textinput" style="width:60px;" /> - &nbsp;
                    <input id="FAX_NUM2" name="FAX_NUM2" data-bind="value: FAX_NUM2" data-type="textinput" style="width:60px;" /> - &nbsp;
                    <input id="FAX_NUM3" name="FAX_NUM3" data-bind="value: FAX_NUM3" data-type="textinput" style="width:60px;" />
                </td>
                <th>의견내용</th>
                <td class="tleft">
                    <input id="REPLY" name="REPLY" data-bind="value: REPLY" data-type="textinput" style="width:150px;" />
                </td>
            </tr>
            <tr>
                <th>면접결과내용</th>
                <td class="tleft">
                    <input id="INT_CMNT" name="INT_CMNT" data-bind="value: INT_CMNT" data-type="textinput" style="width:150px;" />
                </td>
                <th> 불편법/영업사례 작성내용</th>
                <td class="tleft" colspan="3">
                    <input id="UNLAW_SALE_EX_CTT" name="UNLAW_SALE_EX_CTT" data-bind="value: UNLAW_SALE_EX_CTT" data-type="textinput" style="width:150px;" />
                </td>                
            </tr>            
            </table>
        </form>
            <div class="ab_pos5">
                <button id="btnSearch" data-type="button" data-theme="af-psnm" data-authtype="R"></button><!-- 조회버튼 -->
            </div>
    </div>
	
	<div class="floatL4"> 
        <p class="ab_pos2">
        </p>
    </div>
    
    <!-- main grid -->
    <div id="grid" data-bind="grid:grid" data-ui="ds"></div>

</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>
