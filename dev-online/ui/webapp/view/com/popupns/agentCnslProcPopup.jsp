<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>진행현황</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />

    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/psnm-ns.js"></script>

    <script type="text/javascript">
    
    $a.page({
        init : function(id, param) {
            $a.page.setEventListener();
            $a.page.setCodeData();
            $a.page.setGrid();          //그리드 초기화
        },
        setEventListener : function() {
        	$("#btnSearch").click( searchList ); //조회
        },      
        setCodeData : function() {
            
            $.PSNMUtils.setCodeData([
                { t:'code', 'elemid' : 'MBL_PHON_NUM1', 'codeid' : 'HP_FRST_NO', 'header' : '-선택-' },   //이동전화
            ]);            
        },
        setGrid : function() {
            
            $("#grid").alopexGrid({
            	rowClickSelect : false,
                rowInlineEdit : true,
            	rowSingleSelect : true,
                columnMapping : [
              
                    { columnIndex : 0, key : "NAME_KOR",         title : "성명",           align : "center", width : "50px" },
                    { columnIndex : 1, key : "SEX",              title : "성별",           align : "center", width : "50px" },
                    { columnIndex : 2, key : "AGE",              title : "나이",           align : "center", width : "30px" },
                    { columnIndex : 3, key : "ACT_ZONE",         title : "영업예정지역",   align : "center", width : "100px" },
                    { columnIndex : 4, key : "HDQT_PART_ORG_NM", title : "담당영업팀",     align : "center", width : "120px", hidden : true},// 원래는 '담당본사파트'
                    { columnIndex : 5, key : "HDQT_PART_ORG_NM", title : "담당영업지역",   align : "center", width : "120px" },
                    { columnIndex : 6, key : "REQ_DSM_HEADQ_NM", title : "담당영업국",     align : "center", width : "120px" },
                    { columnIndex : 7, key : "RGST_DTM",         title : "접수일시",       align : "center", width : "100px" },
                    { columnIndex : 8, key : "APL_ST_NM",        title : "처리상태",       align : "center", width : "80px" },
                    { columnIndex : 9, key : "APLCNSL_MGMT_NUM", title : "지원상담번호",   align : "center", width : "80px" , hidden : true},
                    { columnIndex :10, key : "REQ_DSM_HEADQ_CD", title : "담당영업국코드", align : "center", width : "100px", hidden : true},
                    { columnIndex :11, key : "APL_ST_CD",        title : "처리상태코드",   align : "center", width : "100px", hidden : true}
                    
                ],
                on : {
                    perPageChange : function(arg1) {
                       
                    },
                    pageSet : function(pageNoToGo) {
                        var p = {};
                        p.page = pageNoToGo;
                        $a.page.searchList(p); //페이지 이동
                    },
                    cell : {
                        "dblclick" : function(data, eh, e) {
                        	var param = $("#searchTable").getData({selectOptions:true});
                        	param.APLCNSL_MGMT_NUM = data.APLCNSL_MGMT_NUM;
                        	
                        	agentCnslReqPopup( param );
                        	
                        	//closeWith( param );
                        	//$a.navigate("agentCnslReqPopup.jsp", param);
                        }
                    }
                }
            });
        }, 

    });
    
    //현재창을 닫고 객체를 반환
    function closeWith(oRecord) {
        $a.close( oRecord );
    }
  
    function closeWithout() {
        $a.close();
    }
    
    function searchList(param) {

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
            url: _NOSESSION_REQ_URL,
            data : ["#searchTable", function(){
                    this.data.dataSet.fields.page      = _page_no;
                    this.data.dataSet.fields.page_size = _per_page;
            }],
            success: ["#grid", function(res) {
                
            }]
        });
    }
    
    function agentCnslReqPopup( param ) {
        $a.popup({
            url: "com/popupns/agentCnslReqPopup"
          , data: param
          , width: 700
          , height: 510
          , windowpopup: false
          , iframe: true
          , title: "지원상담요청"
       	  , callback : function() {
                 //팝업종료시 화면 refresh
                 searchList(param);
             }
        });
    }
    
    </script>
</head>
<body>
<div id="Wrap">

<!-- title area -->
<div class="pop_header" > 

	<!-- title area -->
	<div class="textAR">
	   
		<div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>진행현황</b></div>
		<div id="searchDiv" class="textAR">
		    <form id="searchForm" onsubmit="return false;">
			    <table id="searchTable" class="board02" style="width:90%;">
			        <colgroup>
		                <col style="width:14%">
		                <col style="width:30%">
		                <col style="width:14%">
	                    <col style="width:*">
	                </colgroup>
			        <tbody>
			        <tr>
			            <th height="40" scope="col" class="fontred">상담 요청자명</th>
			            <td class="tleft">
			                <input id="NAME_KOR" data-bind="value:NAME_KOR" data-type="textinput"
						           data-validation-rule="{required:true}" 
						           data-validation-message="{required:$.PSNM.msg('E012', ['상담 요청자명'])}">
			            </td>		            
			            
			            <th scope="col" class="fontred">비밀번호</th>
	                    <td class="tleft">
	                        <input id="SCRT_NUM" data-bind="value:SCRT_NUM" type="password" data-type="textinput" data-disabled="false"
	                               data-validation-rule="{required:true}" 
	                               data-validation-message="{required:$.PSNM.msg('E012', ['비밀번호'])}">
	                    </td>
			        </tr>
			        <tr>
                        <th height="40" scope="col" class="fontred">연락처</th>
                        <td class="tleft" colspan="3">
    
                            <select id="MBL_PHON_NUM1" name="MBL_PHON_NUM1" data-bind="options: options_MBL_PHON_NUM1, selectedOptions: MBL_PHON_NUM1" data-type="select" data-wrap="false" style="width:60px"
                                    data-validation-rule="{required:true}" 
                                    data-validation-message="{required:$.PSNM.msg('E012', ['연락처'])}">
                            </select>
                          - <input id="MBL_PHON_NUM2" data-bind="value:MBL_PHON_NUM2" type="text" data-type="textinput" data-keyfilter-rule="digits" size="4" maxlength="4"
                                    data-validation-rule="{required:true}" 
                                    data-validation-message="{required:$.PSNM.msg('E012', ['연락처'])}">
                          - <input id="MBL_PHON_NUM3" data-bind="value:MBL_PHON_NUM3" type="text" data-type="textinput" data-keyfilter-rule="digits" size="4" maxlength="4"
                                    data-validation-rule="{required:true}" 
                                    data-validation-message="{required:$.PSNM.msg('E012', ['연락처'])}">           
                        </td>                    
                    </tr>
			        </tbody>
			    </table>	        
		    </form>
		    <!-- btn area -->
            <div class="ab_pos5">
                <button id="btnSearch" data-type="button" data-theme="af-psnm" data-authtype="R" class="af-button af-psnm" data-converted="true" data-altname="조회"></button>
            </div>		    
		</div>
	</div>
	
	<!--view_table area -->
    <div class="textAR">	
		<!--view_list area -->
	    <div class="floatL4">
	       <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>MA지원상담목록</b>
	    </div>
	    
	    <!-- main grid -->
	    <div id="grid" data-bind="grid:grid" data-ui="ds"></div>
	</div>
      	
</div>    
</div> 
</body>
</html>
