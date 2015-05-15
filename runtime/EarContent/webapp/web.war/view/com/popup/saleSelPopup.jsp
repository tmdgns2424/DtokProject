<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>에이전트 찾기 - PS&Marketing</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />


    <script type="text/javascript">
    var _initParam = null;

    $a.page({
        init : function(id, param) {
        	$.PSNM.initialize(id, param); //PSNM공통 초기화함수 호출
            _initParam = param;
			
            $a.page.setCodeData();
            $a.page.setEventListener();
            $a.page.setGrid();
            $.PSNMUtils.setDefaultYmd("#FROM_DT", "TO_DT");
        },
        setEventListener : function() {
            $("#btnSearch").click( $a.page.searchList );
            $("#btnConfirm").click( closeConfirm );
            $("#btnCancel").click( closeWithout );
        },
        setGrid : function() {
            $("#gridSale").alopexGrid({
            	rowSingleSelect : true,
                paging: {
                    perPage : 10,
                    pagerCount : 10
                },
                columnMapping : [
                    { columnIndex : 0, key : "SALE_MGMT_NUM",       title : "매출관리번호",      align : "center",   width : "80px" },
                    { columnIndex : 1, key : "SELL_CL_NM",          title : "판매구분",          align : "center",   width : "80px" },
                    { columnIndex : 2, key : "SALE_DT",             title : "개통일",           align : "center",   width : "80px" },
                    { columnIndex : 3, key : "HDQT_TEAM_ORG_NM",    title : "본사팀",           align : "center",   width : "100px" },
                    { columnIndex : 4, key : "AGN_NM" ,             title : "대리점",           align : "center",   width : "80px" },
                    { columnIndex : 5, key : "HDQT_PART_ORG_NM",    title : "본사파트",         align : "center",    width : "100px" },
                    { columnIndex : 6, key : "SALE_DEPT_ORG_NM",    title : "영업국명",         align : "center",   width : "100px" },
                    { columnIndex : 7, key : "SALE_TEAM_ORG_NM",    title : "영업팀명",         align : "center",   width : "100px" },
                    { columnIndex : 8, key : "AGNT_ID",            title : "에이전트코드",      align : "center",   width : "80px" },
                    { columnIndex : 9, key : "AGNT_NM2",            title : "에이전트명",        align : "center",   width : "80px" },
                    { columnIndex :10, key : "CUST_NM2",            title : "고객명",           align : "center",   width : "80px" },
                    { columnIndex :11, key : "SVC_NUM",             title : "개통번호",         align : "center",   width : "100px", 
                    						 render : function(value, data) { 
                    									reg = /(^\d{3})(\d{3,4})(\d{4})/;
                    									return value.replace(reg, '$1' + '-' + '$2'+'-'+'$3');
                    								  }
                    },
                    { columnIndex :12, key : "SALE_TYP_NM",         title : "판매유형",         align : "center",   width : "80px" },
                    { columnIndex :13, key : "SCRB_TYP_NM",         title : "가입유형",         align : "center",   width : "80px" },
                    { columnIndex :14, key : "PROD_NM",             title : "모델명",           align : "center",   width : "120px" },
                    { columnIndex :15, key : "SER_NUM",             title : "일련번호",         align : "center",   width : "120px" },
                    { columnIndex :16, key : "UPDR_NM",             title : "최종처리자",        align : "center",   width : "80px" },
                    { columnIndex :17, key : "UPD_DTM",             title : "최종처리일",        align : "center",   width : "110px" },
                    { columnIndex :18, key : "SALE_DEPT_ORG_ID",    hidden: true }
                ],
                on : {
                    pageSet : function(pageNoToGo) {
                    	var p = {};
                        p.page = pageNoToGo;
                        $a.page.searchList(p);
                    },
                    cell : {
                        "dblclick" : function(data, eh, e) {
                            closeWith( AlopexGrid.trimData(data) );
                        }
                    }
                }
            });
        },
        setCodeData : function() {
            $.PSNMUtils.setCodeData([		        
                { t:'code',  'elemid' : 'SVC_TYP_CD', 'codeid' : 'SVC_TYP_CD', 'header' : '-전체-' },
            ]);
        },
        searchList: function(param) {
       		if ( ! $.PSNM.isValid("#searchForm") ) {
   			    return false; //값 검증
   			}
        	var _page_no = 1;
            if ( $.PSNMUtils.isNotEmpty(param) && $.PSNMUtils.isNotEmpty(param.page) ) {
                _page_no = param.page;
            }
            var _per_page = $("#gridSale").alopexGrid("pageInfo").perPage;

            $.alopex.request("biz.CUSTPGCV@PPOPUPSALEINFO001_pSearchSaleInfo", {
                data: ["#searchForm", function() {
                	this.data.dataSet.fields.FROM_DT   = $.PSNMUtils.getDateInput("FROM_DT");
                	this.data.dataSet.fields.TO_DT     = $.PSNMUtils.getDateInput("TO_DT");
                    this.data.dataSet.fields.page      = _page_no;
                    this.data.dataSet.fields.page_size = _per_page;
                }],
                success: ["#gridSale", function(res) {
                }]
            }); 
        }
    });

    //현재창을 닫고 객체를 반환
    function closeWith(oRecord) {
        $a.close( oRecord );
    }

    function closeWithout() {
        $a.close();
    }

    function closeConfirm() {
        var arrAgents = $("#gridSale").alopexGrid( "dataGet" , { _state : { selected : true } } ); //선택된 데이터

        if (arrAgents.length<1) {
            alert("에이전트를 선택하십시오!");
            return;
        }

        closeWith(arrAgents[0]);
    }
    </script>
</head>

<body>

<div id="contents">

    <!-- title area -->
    <div class="pop_header">
        <div class="psnm-find-area" style="height:100px;">
          <form id="searchForm">
            <div class="psnm-find-condarea">
                <table class="board02">
	        	<colgroup>
		            <col style="width:10%"/>
		            <col style="width:30%"/>
		            <col style="width:10%"/>
		            <col style="width:20%"/>
		            <col style="width:10%"/>
		            <col style="*"/>
	            </colgroup>
                <tr>
	                <th scope="col" class="fontred">조회기간</th>
	                <td class="tleft">
						<div data-type="daterange" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png" >
							<input id="FROM_DT" name="FROM_DT" data-role="startdate" data-bind="value:FROM_DT" style="width:70px;"
								data-validation-rule="{required:true}"
								data-validation-message="{required:$.PSNM.msg('E012', ['시작일자'])}">
							~ <input id="TO_DT" name="TO_DT" data-role="enddate" data-bind="value:TO_DT" style="width:70px;"
								data-validation-rule="{required:true}"
								data-validation-message="{required:$.PSNM.msg('E012', ['종료일자'])}">
						</div>
					</td>                
                    <th scope="col" class="fontred">본사팀</th>
                    <td class="tleft">
                        <select id="HDQT_TEAM_ORG_ID" data-bind="options:options_HDQT_TEAM_ORG_ID, selectedOptions:HDQT_TEAM_ORG_ID" data-type="select"  style="width:150px;"
                        	data-validation-rule="{required:true}"
							data-validation-message="{required:$.PSNM.msg('E012', ['본사팀'])}">
                        </select>
                    </td>
                    <th scope="col" class="fontred">본사파트</th>
                    <td class="tleft">
                        <select id="HDQT_PART_ORG_ID" data-type="select" data-bind="options:options_HDQT_PART_ORG_ID, selectedOptions:HDQT_PART_ORG_ID"  style="width:150px;"
                        	data-validation-rule="{required:true}"
							data-validation-message="{required:$.PSNM.msg('E012', ['본사파트'])}">
                        </select>
                    </td>
                </tr>
                <tr>
                    <th scope="col" class="fontred">영업국명</th>
                    <td class="tleft">
                        <select id="SALE_DEPT_ORG_ID" data-type="select" data-bind="options:options_SALE_DEPT_ORG_ID, selectedOptions:SALE_DEPT_ORG_ID"  style="width:150px;"
                        	data-validation-rule="{required:true}"
							data-validation-message="{required:$.PSNM.msg('E012', ['영업국'])}">
                        </select>
                    </td>                
                    <th scope="col" class="fontred">영업팀명</th>
                    <td class="tleft">
                        <select id="SALE_TEAM_ORG_ID" data-type="select" data-bind="options:options_SALE_TEAM_ORG_ID, selectedOptions:SALE_TEAM_ORG_ID"  style="width:150px;"
                        	data-validation-rule="{required:true}"
							data-validation-message="{required:$.PSNM.msg('E012', ['영업팀'])}">
                        </select>
                    </td>
                    <th >에이전트 코드</th>
                    <td class="tleft">
                        <input id="AGNT_ID" data-type="textinput" data-bind="value:AGNT_ID" style="width:150px;">
                    </td>
                </tr>
                <tr>
                    <th >에이전트명</th>
                    <td class="tleft">
                        <input id="AGNT_NM" data-type="textinput" data-bind="value:AGNT_NM" style="width:150px;">
                    </td>                
                    <th scope="col">가입유형</th>
                    <td class="tleft">
                        <select id="SVC_TYP_CD" data-type="select" data-bind="options:options_SVC_TYP_CD, selectedOptions:SVC_TYP_CD"  style="width:150px;">
                        </select>
                    </td>                
                    <th scope="col">개통번호</th>
                    <td colspan="3" class="tleft">
                        <input id="SVC_NUM" data-type="textinput" data-bind="value:SVC_NUM" style="width:150px;" maxlength="11" data-keyfilter-rule="digits">
                    </td>
                </tr>                
                </table>
            </div>
          </form>
          <div class="psnm-find-btnarea">
              <input id="btnSearch" type="button" value="" data-type="button" data-theme="af-psnm">
          </div>
        </div>

        <!--view_table area -->
        <div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>매출관리번호 현황</b>
        </div>
        <!-- main grid -->
        <div id="gridSale" data-bind="grid:gridSale" data-ui="ds"></div>
        <p class="floatL2">
            <input id="btnConfirm" type="button" value="" data-type="button" data-theme="af-btn8">
            <input id="btnCancel"  type="button" value="" data-type="button" data-theme="af-btn10">
        </p>
    </div>
</div>
</body>
</html>