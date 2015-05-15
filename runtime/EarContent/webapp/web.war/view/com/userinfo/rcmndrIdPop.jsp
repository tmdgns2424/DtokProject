<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <jsp:include page="/view/layouts/default_head.jsp" flush="false" />
    <script type="text/javascript">
    var _param;
    
    $.alopex.page({

        init : function(id, param) { 
            $.PSNM.initialize(id, param); //PSNM공통 초기화함수 호출
            $a.page.setCodeData(); //공통코드 호출
            $a.page.setGrid(); //그리드 초기화
            $a.page.setEventListener(); //버튼 초기화
     		_param = param;
          
            searchList(param);
        },
        setEventListener : function() {
            $("#btnSearch").click(searchList);//조회
            $("#btnDown").click('');//엑셀다운
            $("#btnNew").click($a.page.newPrz);//신규
            $("#btnCfm").click($a.page.setAgnInfo);
            $("#btnCls").click($a.close());
        },  
        closeCallback : function(){
        	$a.close();
        },
        setGrid : function() {
        
            $("#grid").alopexGrid({
            	rowSingleSelect : true,
                
                columnMapping : [
              
                    { columnIndex : 0, key : "USER_ID",     	 	title : "회원ID",       align : "center", width : "80px"  },
                    { columnIndex : 1, key : "USER_NM",    			title : "회원명",       align : "center", width : "80px"  },
                    { columnIndex : 2, key : "DUTY_NM",      		title : "직무",   		align : "center", width : "250px" },
                    { columnIndex : 3, key : "SALE_DEPT_ORG_NM",   	title : "영업국명",     align : "center", width : "170px" },
                    { columnIndex : 4, key : "SALE_TEAM_ORG_NM",    title : "영업팀명",   	align : "center", width : "200px" },
                    { columnIndex : 5, key : "AGENT_CD", 			title : "에이전트코드", align : "center", width : "80px"  },
                    { columnIndex : 6, key : "RPSTY_NM", 		title : "직책명", 		align : "center", width : "100px" },
                    { columnIndex : 7, key : "AGENT_NM",  			title : "에이전트명",   align : "center", width : "100px" }
           
                ],
                on : {
                    perPageChange : function(arg1) {
                       
                    }
                    ,
                    pageSet : function(pageNoToGo) {
                    	 var p = {};
                         p.page = pageNoToGo;
                    	 searchList(p); //페이지 이동
                    }
                }
            });
        },
        setCodeData : function() {
            $.PSNMUtils.setCodeData([ 
                                     { t:'org1',  'elemid' : 'HDQT_TEAM_ORG_ID', 'header' : '-전체-' }
                                    ,{ t:'org2',  'elemid' : 'HDQT_PART_ORG_ID', 'header' : '-전체-' }
                                    ,{ t:'org3',  'elemid' : 'SALE_DEPT_ORG_ID', 'header' : '-전체-' }
                                    ,{ t:'org4',  'elemid' : 'SALE_TEAM_ORG_ID', 'header' : '-전체-' }
          
            ], $a.page.setCode);
        },
        setCode : function(){
        	$("#searchForm").setData({
										HDQT_TEAM_ORG_ID : _param.HDQT_TEAM_ORG_ID,
									    HDQT_PART_ORG_ID : _param.HDQT_PART_ORG_ID,
									    SALE_DEPT_ORG_ID : _param.SALE_DEPT_ORG_ID,
									    SALE_TEAM_ORG_ID : _param.SALE_TEAM_ORG_ID
			});
        },
        setAgnInfo : function(){
        	$a.close(AlopexGrid.trimData($('#grid').alopexGrid('dataGet', {_state: {selected: true}})));
        }
    });
    
    function searchList(param){
    	
    	var _page_no = 1;
        if ( $.PSNMUtils.isNotEmpty(param) && $.PSNMUtils.isNotEmpty(param.page) ) {
            _page_no = param.page; //(설명) 페이지 이동할때만 페이지번호가 넘어옴.
        }
        var _per_page = $('#grid').alopexGrid('pageInfo').perPage; // $("#grid .perPage").val();
        
        $.alopex.request('com.USERINFO@PUSERSCRBREQ001_pSearchAgnt', {
           //data 형식 변경 필요
        	data : {dataSet :{ fields : {
        								 "HDQT_TEAM_ORG_ID":$.PSNMUtils.isNotEmpty(param.HDQT_TEAM_ORG_ID)? param.HDQT_TEAM_ORG_ID : $("#HDQT_TEAM_ORG_ID").val(),
        		                         "HDQT_PART_ORG_ID":$.PSNMUtils.isNotEmpty(param.HDQT_PART_ORG_ID)? param.HDQT_PART_ORG_ID : $("#HDQT_PART_ORG_ID").val(),
        		                         "SALE_DEPT_ORG_ID":$.PSNMUtils.isNotEmpty(param.SALE_DEPT_ORG_ID)? param.SALE_DEPT_ORG_ID : $("#SALE_DEPT_ORG_ID").val(),
        		                         "SALE_TEAM_ORG_ID":$.PSNMUtils.isNotEmpty(param.SALE_TEAM_ORG_ID)? param.SALE_TEAM_ORG_ID : $("#SALE_TEAM_ORG_ID").val(),
        		                         "page":_page_no,
        		                         "page_size":10
        								} 
            } },
            success: ["#grid", function(res) {
            }]
        });
    	
    }
    </script>
</head>
<body>
<div id="Wrap"> 
  <!-- title area -->
  <div class="pop_header" ><span class="title">처리내용</span> <a href="#" class="pop_close" onclick="javascript:self.close();"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a9.gif" alt="팝업닫기" ></a> 
    <!--view_table area -->
    
    <form id="searchForm">
      <table class="board02" style="width:93%;">
	    <colgroup>
	    	<col style="width:12%">
	    	<col style="width:22%">
	    	<col style="width:12%">
	    	<col style="width:22%">
	    	<col style="width:12%">
	    	<col style="width:*">
	    </colgroup>
        <tr>
          <th scope="col">본사팀</th>
          <td class="tleft">
          <select id="HDQT_TEAM_ORG_ID" data-type="select" data-bind="options:options_HDQT_TEAM_ORG_ID, selectedOptions:HDQT_TEAM_ORG_ID" data-wrap="true" style="width:185px!important">
          </select>
          </td>
          <th >본사파트</th>
          <td class="tleft">
		  <select id="HDQT_PART_ORG_ID" data-type="select" data-bind="options:options_HDQT_PART_ORG_ID, selectedOptions:HDQT_PART_ORG_ID" data-wrap="true" style="width:185px!important">
          </select>
          </td>
          <th >영업국명</th>
          <td class="tleft">
		  <select id="SALE_DEPT_ORG_ID" data-type="select" data-bind="options:options_SALE_DEPT_ORG_ID, selectedOptions:SALE_DEPT_ORG_ID" data-wrap="true" style="width:185px!important">
          </select>
          </td>
        </tr>
        <tr>
          <th scope="col">영업팀명</th>
          <td class="tleft">
          <select id="SALE_TEAM_ORG_ID" data-type="select" data-bind="options:options_SALE_TEAM_ORG_ID, selectedOptions:SALE_TEAM_ORG_ID" data-wrap="true" style="width:185px!important">
          </select>
          </td>
          <th >에이전트명</th>
          <td colspan="3" class="tleft">
          <input id="AGENT_NM"  data-type="textinput" data-bind="value:AGENT_NM" style="width:100px">
		  </td>
        </tr>
      </table>
      <!-- btn area -->
      <div class="ab_pos5">
        <input id="btnSearch" type="button" value="" data-type="button" data-theme="af-psnm" >
      </div>
    </form>
  <!--view_list area -->
  <div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>목록</b></div>
  <!-- main grid -->
  <div id="grid" data-bind="grid" data-ui="ds"></div>
  <p class="floatL3">
    <input id="btnCfm" type="button" value="" data-type="button" data-theme="af-btn8">
    <input id="btnCls" type="button" value="" data-type="button" data-theme="af-btn10">
  </p>
  
</div>
</div>
</body>
</html>
