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
        	
            $.PSNM.initialize(id, param);   //PSNM공통 초기화함수 호출            
            $.PSNMUtils.setDefaultYmd("#FROM_DT", "TO_DT"); //조회일자(임시)
            
            $a.page.setEventListener(); //버튼 초기화
            $a.page.setGrid();          //그리드 초기화
            $a.page.setCodeData();      //공통코드 호출            
            
            $('#searchTable').setData(param);    //(설명) 상세페이지에서 돌아오는 경우, 이 값들이 세션스토리지에서 반환됨.
            $a.page.searchList(param);
        },
        setEventListener : function() {

        	$("#btnSearch").click(function(param){
            	$a.page.searchList(param);
            });
        }, 
        setGrid : function() {
        
            $("#grid").alopexGrid({
                rowClickSelect : false,
                rowInlineEdit : true,
                columnMapping : [
              
                    { columnIndex : 0, key : "NAME_KOR",     	 title : "성명",       	   align : "center", width : "80px"  			   },
                    { columnIndex : 1, key : "SEX",          	 title : "성별",           align : "center", width : "80px"  			   },
                    { columnIndex : 2, key : "AGE",              title : "나이", 		   align : "center", width : "80px"  			   },
                    { columnIndex : 3, key : "ACT_ZONE",         title : "영업예정지역",   align : "center", width : "250px" 			   },
                    { columnIndex : 4, key : "HDQT_PART_ORG_NM", title : "담당본사파트",   align : "center", width : "130px"                },
                    { columnIndex : 5, key : "REQ_DSM_HEADQ_NM", title : "담당영업국명",     align : "center", width : "130px" 			   },
                    { columnIndex : 6, key : "RGST_DTM",      	 title : "접수일시",       align : "center", width : "170px" 			   },
                    { columnIndex : 7, key : "APL_ST_NM",        title : "처리상태",   	   align : "center", width : "200px" 			   },
                    { columnIndex : 8, key : "APLCNSL_MGMT_NUM", title : "지원상담번호",   align : "center", width : "80px" , hidden : true},
                    { columnIndex : 9, key : "REQ_DSM_HEADQ_CD", title : "담당영업국코드", align : "center", width : "100px", hidden : true},
                    { columnIndex :10, key : "APL_ST_CD",  		 title : "처리상태코드",   align : "center", width : "100px", hidden : true}
                    
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
            $("#grid").alopexGrid('updateOption', {
                on : {
                    'cell' : {
                        "dblclick" : function(data, eh, e) {    //표준 : 더블클릭시 상세페이지로 이동함.
                       
                        	var param     = $("#searchTable").getData({selectOptions:true});
                        	param.page    = $("#grid").alopexGrid("pageInfo").customPaging.current;
                        	param.perPage = $('#grid').alopexGrid('pageInfo').perPage;
                        	param.pName   = "new";
                        	param.APLCNSL_MGMT_NUM = data.APLCNSL_MGMT_NUM;
                        	
                        	$a.navigate("agentCnslMgmtDtl.jsp", param);
                        }
                    }
                }
            });
        }, 
        setCodeData : function() {
            $.PSNMUtils.setCodeData([
                { t:'org1',  'elemid' : 'HDQT_TEAM_ORG_ID', 'header' : '-전체-' }, //[본사팀] 목록 조회:전체, 선택 등이 넣으려면 설정
                //{ t:'org2',  'elemid' : 'HDQT_PART_ORG_ID', 'header' : '-전체-' }, //[본사파트] 목록 조회
                //{ t:'org3',  'elemid' : 'SALE_DEPT_ORG_ID', 'header' : '-전체-' }, //[영업국] 목록 조회
                { t:'code',  'elemid' : 'APL_ST_CD', 'codeid' : 'DSM_APL_ST_CD', 'header' : '-전체-' }    //[처리상태] 목록 조회
            ]);
        },
        searchList : function(param){
        	
        	// 필수체크
            if ( !$.PSNM.isValid("searchForm") ) {
                return false;
            }
        	
        	var _page_no = 1;
            if ( $.PSNMUtils.isNotEmpty(param) && $.PSNMUtils.isNotEmpty(param.page) ) {
                _page_no = param.page; //(설명) 페이지 이동할때만 페이지번호가 넘어옴.
            }
            var _per_page = $('#grid').alopexGrid('pageInfo').perPage; 
        	
            $.alopex.request('agn.AGNTMGMT@PAGENTECCR001_pSearchAgentEccr', {
    			data : ["#searchTable", function(){
    					this.data.dataSet.fields.page 	   = _page_no;
    					this.data.dataSet.fields.page_size = _per_page;
    					this.data.dataSet.fields.FROM_DT   = $.PSNMUtils.getDateInput("FROM_DT");
    	            	this.data.dataSet.fields.TO_DT     = $.PSNMUtils.getDateInput("TO_DT");
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

<div id="contents">

    <!-- sub title area -->
    <div class="content_title">
	   <div class="ub_txt6">
	      <span class="txt6_img"><b id="sub-title">메뉴제목</b>
	      <span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif"> 
	      <span class="a2">대메뉴명</span> <span class="a3"> > </span> <span class="a4"><b>중메뉴명</b> </span></span></span>
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
				<th scope="col" class="fontred">조회기간</th>
				<td class="tleft">
				    <div data-type="daterange" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png" >
                        <input id="FROM_DT" name="FROM_DT" data-role="startdate" data-bind="value:FROM_DT" style="width:70px;"
                               data-validation-rule="{required:true}"
                               data-validation-message="{required:$.PSNM.msg('E012', ['시작일자'])}" />
                        
                      ~ <input id="TO_DT" name="TO_DT" data-role="enddate" data-bind="value:TO_DT" style="width:70px;"
                               data-validation-rule="{required:true}"
                               data-validation-message="{required:$.PSNM.msg('E012', ['종료일자'])}" />    
                    </div>
                    
				</td>
				<th scope="col">본사팀</th>
                <td class="tleft">
                    <select id="HDQT_TEAM_ORG_ID" data-bind="options:options_HDQT_TEAM_ORG_ID, selectedOptions: HDQT_TEAM_ORG_ID" data-type="select" ></select>
                </td>
                <th scope="col">본사파트</th>
                <td class="tleft">
                    <select id="HDQT_PART_ORG_ID" data-bind="options:options_HDQT_PART_ORG_ID, selectedOptions: HDQT_PART_ORG_ID" data-type="select" data-wrap="false" style="width:150px;">
                        <option value="">-전체-</option>
                    </select>
                </td>
                
			</tr>
			<tr>
			    <th >영업국</th>
                <td class="tleft">
                    <select id="SALE_DEPT_ORG_ID" data-bind="options:options_SALE_DEPT_ORG_ID, selectedOptions:SALE_DEPT_ORG_ID" data-type="select" data-wrap="false">
                        <option value="">-전체-</option>
                    </select>                    
                </td>
			    <th >처리상태</th>
				<td class="tleft" colspan="3">
				    <select id="APL_ST_CD" data-type="select" data-bind="options:options_APL_ST_CD, selectedOptions:APL_ST_CD"></select>
				</td>
			</tr>
			</table>
		</form>
		
		<!-- btn area -->
        <div class="ab_pos5">
            <button id="btnSearch" data-type="button" data-theme="af-psnm" data-authtype="R" data-altname="조회"></button>
        </div>
    
    </div>
  
	<!--view_list area -->
	<div class="floatL4">
	   <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>MA지원상담목록</b>
	</div>
  
	<!-- main grid -->
	<div id="grid" data-bind="grid" data-ui="ds"></div>

</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>