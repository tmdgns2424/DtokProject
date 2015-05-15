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
            $.PSNM.initialize(id, param); //PSNM공통 초기화함수 호출
            $a.page.setGrid();
            $a.page.setEventListener(); 
        },
        setEventListener : function() {
            $("#btnSearch").click($a.page.searchList);
        }, 
        setGrid : function() {
            $("#grid").alopexGrid({
                rowClickSelect : false,
                rowInlineEdit : false,
                columnMapping : [
                    { columnIndex : 0, key : "SALE_DEPT_ORG_NM",     title : "영업국명",       	align : "center", width : "80px"  },
                    { columnIndex : 1, key : "SALE_TEAM_ORG_NM",     title : "영업팀명",        align : "center", width : "80px"  },
                    { columnIndex : 2, key : "AGNT_ID",              title : "에이전트코드", 	align : "center", width : "80px"  },
                    { columnIndex : 3, key : "RPSTY_NM",        	 title : "직책명",   		align : "center", width : "70px"  },
                    { columnIndex : 4, key : "AGNT_NM", 		 	 title : "에이전트명",      align : "center", width : "80px"  },
                    { columnIndex : 5, key : "MBL_PHON_NUM",      	 title : "전화번호",        align : "center", width : "90px"  },
                    { columnIndex : 6, key : "FAX_NUM",        		 title : "팩스번호",   	    align : "center", width : "90px"  },
                    { columnIndex : 7, key : "EMAIL", 				 title : "이메일",   		align : "left",   width : "170px" },
                    { columnIndex : 8, key : "ADDR", 				 title : "주소", 			align : "left",   width : "350px" }
                ],
                on : {
                    perPageChange : function(arg1) { 
                    }
                    ,
                    pageSet : function(pageNoToGo) {
                    	var p = {};
                        p.page = pageNoToGo;
                   	 	$a.page.searchList(p); //페이지 이동
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
        	
            $.alopex.request('agn.AGNTMGMT@PAGENTCNTRT001_pSearchAgentInfo', {
                
    			data : ["#searchForm", function(){
    				this.data.dataSet.fields.page = _page_no;
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
<!--// left area -->
<div class="left_bar"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/left_bar.gif" width="22" height="106"></div>
<!-- title area -->
<div id="contents">
  <div class="content_title">
    <div class="ub_txt6"> <span class="txt6_img"><b>에이전트정보조회</b> <span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif"> <span class="a2">본사업무</span> <span class="a3"> > </span> <b>에이전트정보조회</b> </span> </span> </div>
  </div>
  <!-- find condition area -->
  <div class="textAR">
    <form id="searchForm">
      <table class="board02" style="width:92%;">
        <tr>
          <th height="40" scope="col">에이전트명</th>
          <td class="tleft">
		  <input id="AGNT_NM" data-type="textinput" data-bind="value:AGNT_NM" data-theme="af-textinput"/>
		  </td>
          <th>전화번호</th>
          <td class="tleft">
		  <input id="MBL_PHON_NUM1" data-type="textinput" data-bind="value:MBL_PHON_NUM1" data-theme="af-textinput" style="width:50px"/> -
		  <input id="MBL_PHON_NUM2" data-type="textinput" data-bind="value:MBL_PHON_NUM2" data-theme="af-textinput" style="width:50px"/> -
		  <input id="MBL_PHON_NUM3" data-type="textinput" data-bind="value:MBL_PHON_NUM3" data-theme="af-textinput" style="width:50px"/>
		  </td>
          <th>이메일</th>
          <td class="tleft">
          <input id="EMAIL" data-type="textinput" data-bind="value:EMAIL" data-theme="af-textinput"/>
          </td>
        </tr>
        <tr>
          <th>주소</th>
          <td class="tleft">
          <input id="ADDR" data-type="textinput" data-bind="value:ADDR" data-theme="af-textinput"/>
          </td>
          <th >FAX번호</th>
          <td colspan="3" class="tleft">
          <input id="FAX_NUM1" data-type="textinput" data-bind="value:FAX_NUM1" data-theme="af-textinput" style="width:50px"/> -
		  <input id="FAX_NUM2" data-type="textinput" data-bind="value:FAX_NUM2" data-theme="af-textinput" style="width:50px"/> -
		  <input id="FAX_NUM3" data-type="textinput" data-bind="value:FAX_NUM3" data-theme="af-textinput" style="width:50px"/> 
          </td>
        </tr>
      </table>
      <!-- btn area -->
      <div class="ab_pos4">
        <input id="btnSearch" type="button" value="" data-type="button" data-theme="af-psnm" >
      </div>
    </form>
  </div>
  <!--view_list area -->
  <div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>에이전트정보목록</b> </div>
  <div id="grid" data-bind="grid" data-ui="ds"> </div>
</div>
<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />
</body>
</html>
