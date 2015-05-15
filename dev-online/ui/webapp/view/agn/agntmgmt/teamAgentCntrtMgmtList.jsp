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
        	
        	$.PSNM.initialize(id, param);  //PSNM공통 초기화함수 호출
           	$.PSNMUtils.setDefaultYmd("#FROM_DT", "TO_DT"); //조회일자(임시)
           	
           	$a.page.setEventListener(); //버튼 초기화
            $a.page.setCodeData();  //공통코드 호출
            $a.page.setGrid();      //그리드 초기화            
            
            $("#searchTable").setData(param);
            $("#searchTable").setData({CNTRT_ST_CD:"2"});   //처리상태는 접수(2)상태로 고정
            $a.page.searchList(param);            

        },
        setEventListener : function() {

            $("#btnSearch").click(function(param){  //조회
            	
            	// 필수체크
                if ( !$.PSNM.isValid("searchForm") ) {
                    return false;
                }
            	$a.page.searchList(param);
            });
            
            $("#btnExcelPage").click(function(){
            	var oExcelMetaInfo = {
                        filename  : "에이전트계약관리목록.xls",
                        sheetname : "에이전트계약관리목록",
                        gridname  : "grid" //그리드ID 
                    };
                $.PSNMUtils.downloadExcelPage("grid", oExcelMetaInfo, [3, 11, 12, 13]);
            });
            $("#AGNT_NM").keyup($.PSNMAction.findAgent);
        }, 
        setGrid : function() {
        
            $("#grid").alopexGrid({
                rowClickSelect : false,
                rowInlineEdit : true,
                columnMapping : [
              
                    { columnIndex : 0, key  : "CNTRT_MGMT_NUM",     	title : "관리번호",     align : "center", width : "100px" },
                    { columnIndex : 1, key  : "RGST_DTM",    			title : "지원일자",     align : "center", width : "100px" },
                    { columnIndex : 2, key  : "NAME_KOR",       		title : "지원자명", 	align : "center", width : "80px"  },
                    { columnIndex : 3, key  : "CNTRT_ST_NM",      		title : "처리상태",   	align : "center", width : "100px" },
                    { columnIndex : 4, key  : "INT_HST_SEQ",      		title : "면접횟수",   	align : "center", width : "80px" },
                    { columnIndex : 5, key  : "INTR_NM",      			title : "면접관명",   	align : "center", width : "80px" },
                    { columnIndex : 6, key  : "REQ_SALE_DEPT_ORG_NM", 	title : "희망영업국",   align : "center", width : "140px" },
                    { columnIndex : 7, key  : "REQ_SALE_TEAM_ORG_NM",   title : "희망영업팀",   align : "center", width : "80px"  },
                    { columnIndex : 8, key  : "APP_SALE_DEPT_ORG_NM",   title : "지정영업국",   align : "center", width : "140px" },
                    { columnIndex : 9, key  : "APP_SALE_TEAM_ORG_NM", 	title : "지정영업팀", 	align : "center", width : "80px"  },
                    { columnIndex : 10, key : "AGENT_OP_DTM", 			title : "최종처리일", 	align : "center", width : "150px" },
                    { columnIndex : 11, key : "CNTRT_ST_CD", 			title : "처리상태코드", align : "center", width : "60px", hidden:true },
                    { columnIndex : 12, key : "RETL_ORG_CD", 			title : "영업국명(최종배치)", align : "center", width : "100px", hidden:true },
                    { columnIndex : 13, key : "RETL_TEAM_CD", 			title : "영업팀명(최종배치)", align : "center", width : "100px", hidden:true }
                    
                ],
                on : {
                    perPageChange : function(arg1) {
                    }
                    ,
                    pageSet : function(pageNoToGo) {
                    	 var p = {};
                         p.page = pageNoToGo;
                    	 $a.page.searchList(p); //페이지 이동:화면로드될때 검색실행
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
                            param.CNTRT_MGMT_NUM = data.CNTRT_MGMT_NUM; //관리번호
                            
                            //화면사이즈구하기
	                        var clientHeight = 800;
	                        if( document.body.clientHeight < 800 ){
	                         	clientHeight = 600;
	                        }
                            
                            $a.popup({
                                url: "com/popup/agentCntrtMgmtDtlPop"
                              , data: param
                              , width: 1000
                              , height: clientHeight
                              , modal: false
                              , windowpopup: true
                              , iframe: true
                              , title: "면접결과"
                           	  , callback : function( oResult ) {
                                     
                                     //팝업종료시 화면 refresh
                                     if ( $.PSNMUtils.isNotEmpty( oResult ) && "success"==oResult["result"] ) {
                                         $a.page.searchList(param);
                                     }
                                 }
                            });
                        }
                    }
                }
            });
        },
        setCodeData : function() {
            $.PSNMUtils.setCodeData([ 
            	 { t:'code', 'elemid' : 'CNTRT_ST_CD', 'header' : '-전체-' },
            	 { t:'org1', 'elemid' : 'APP_HDQT_TEAM_ORG_ID', 'header' : '-전체-' }
            	//,{ t:'org2', 'elemid' : 'APP_HDQT_PART_ORG_ID', 'header' : '-전체-' }
            	//,{ t:'org3', 'elemid' : 'APP_SALE_DEPT_ORG_ID', 'header' : '-전체-' }
            ]);
        },
        searchList : function(param){
            
            var _page_no = 1;
        	
            if ( $.PSNMUtils.isNotEmpty(param) && $.PSNMUtils.isNotEmpty(param.page) ) {
                _page_no = param.page; //(설명) 페이지 이동할때만 페이지번호가 넘어옴.
            }
            var _per_page = $('#grid').alopexGrid('pageInfo').perPage;
            
            $.alopex.request('agn.AGNTMGMT@PAGENTCNTRT001_pSearchAgentCntrt', {                
    			data : ["#searchTable", function(){
    					this.data.dataSet.fields.DIV 	   = "TEAM";
	    				this.data.dataSet.fields.page 	   = _page_no;
	    				this.data.dataSet.fields.page_size = _per_page;
	    				this.data.dataSet.fields.FROM_DT   = $.PSNMUtils.getDateInput("FROM_DT");
	                	this.data.dataSet.fields.TO_DT     = $.PSNMUtils.getDateInput("TO_DT");
    			}],
                success: ["#grid", "#CNTRT_ST_CNT", function(res) {
                	
                }]
            });
        },
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
	<div class="textAR"> 
	
		<form id="searchForm" onsubmit="return false;">
			<table id="searchTable" class="board02" style="width:93%;">
	            <col style="width:12%"/>
	            <col style="width:25%"/>
	            <col style="width:12%"/>
	            <col style="width:15%"/>
	            <col style="width:12%"/>
	            <col style="width:*"/>
			<tr>
				<th scope="col" class="psnm-required">지원일자</th>
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
				<th class="psnm-required">지정본사팀</th>
				<td class="tleft">
					<select id="HDQT_TEAM_ORG_ID" data-type="select" data-bind="options:options_HDQT_TEAM_ORG_ID, selectedOptions:HDQT_TEAM_ORG_ID" data-wrap="false" style="width:185px!important"
					        data-validation-rule="{required:true}"
                            data-validation-message="{required:$.PSNM.msg('E012', ['지정본사팀'])}" >
					</select>
				</td>
				<th class="psnm-required">지정본사파트</th>
				<td class="tleft">
		            <select id="HDQT_PART_ORG_ID" data-type="select" data-bind="options:options_HDQT_PART_ORG_ID, selectedOptions:HDQT_PART_ORG_ID" data-wrap="false" style="width:185px!important"
		                    data-validation-rule="{required:true}"
                            data-validation-message="{required:$.PSNM.msg('E012', ['지정본사파트'])}" >
		               <option value="">-선택-</option>
		            </select>
				</td>
			</tr>
			<tr>
				<th scope="col" class="psnm-required">지정영업국</th>
				<td class="tleft">
					<select id="SALE_DEPT_ORG_ID" data-type="select" data-bind="options:options_SALE_DEPT_ORG_ID, selectedOptions:SALE_DEPT_ORG_ID" data-wrap="false" style="width:185px!important"
					        data-validation-rule="{required:true}"
                            data-validation-message="{required:$.PSNM.msg('E012', ['지정영업국'])}" >
					    <option value="">-선택-</option>
					</select>
			    </td>
                <th scope="col" class="psnm-required">지정영업팀</th>
                <td class="tleft">
                    <select id="SALE_TEAM_ORG_ID" data-type="select" data-bind="options:options_SALE_TEAM_ORG_ID, selectedOptions:SALE_TEAM_ORG_ID" data-wrap="false" style="width:185px!important"
                            data-validation-rule="{required:true}"
                            data-validation-message="{required:$.PSNM.msg('E012', ['지정영업팀'])}" >
                        <option value="">-전체-</option>
                    </select>
                </td>
                <th >지원자명</th>
                <td class="tleft">
                    <input id="AGNT_NM" data-type="textinput" data-bind="value:AGNT_NM" data-theme="af-textinput"/>
                </td>
		    </tr>
		    <tr>
                <th scope="col">처리상태</th>
                <td class="tleft" colspan="5">
                    <select id="CNTRT_ST_CD" data-type="select" data-bind="options:options_CNTRT_ST_CD, selectedOptions:CNTRT_ST_CD" data-wrap="false" data-disabled="true" style="width:185px!important"></select>
                </td>
            </tr>
		    </table>
		</form>
		  
		<!-- btn area -->
		<div class="ab_pos5">
		  <button id="btnSearch" type="button" data-type="button" data-theme="af-psnm" data-authtype="R" data-altname="조회"></button>
		</div>
	  
	</div>
  
	<!--view_list area -->
	<div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>회원목록</b>
		<p class="ab_pos2">
		    <button id="btnExcelPage" type="button" data-type="button" data-theme="af-btn3" data-altname="엑셀"></button>
		</p>
	</div>
  
	<!-- main grid -->
	<div id="grid" data-bind="grid" data-ui="ds"></div>
	
</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>