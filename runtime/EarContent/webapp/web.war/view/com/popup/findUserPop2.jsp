<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>회원정보조회</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />
    
    <script type="text/javascript">

    $.alopex.page({
        init : function(id, param) {
            
            $.PSNM.setOrgSelectBox(); //$.PSNM.initOrgSelectBox(); //본사팀, 본사파트, 영업국 select 객체 초기화
            
            $a.page.setEventListener();
            $a.page.setGrid1();
            $a.page.setGrid2();
            //$a.page.setCodeData();
        },
        setEventListener : function() {
            $("#btnSearch").click($a.page.searchList);
            $("#btnConfirm").click(function(){
                var oRecord = $("#grid2").alopexGrid( "dataGet" , { _state : { selected : true } } );
                if (oRecord.length == 0) {
                    alert("회원정보를 선택하십시오!");
                    return;
                }
                $a.close( oRecord );
            });
            $("#btnCancel").click(function(){
                $a.close();
            });
            $("#include").click(function(){
                var getData = $("#grid1").alopexGrid("dataGet", {_state:{selected:true}});
                $("#grid1").alopexGrid("dataDelete", {_state:{selected:true}});
                $("#grid2").alopexGrid("dataAdd", getData);
            });
            $("#exclude").click(function(){
                var getData = $("#grid2").alopexGrid("dataGet", {_state:{selected:true}});
                   $("#grid2").alopexGrid("dataDelete", {_state:{selected:true}});
                   $("#grid1").alopexGrid("dataAdd", getData);
            });
        },
        setGrid1 : function() {
            $("#grid1").alopexGrid({
                pager: false,
                height: "200px",
                columnMapping : [
                    { columnIndex : 0, selectorColumn : true, width : "20px" },
                    { columnIndex : 1, key : "HDQT_TEAM_ORG_NM",    title : "본사팀",        align : "center",  width : "80px" },
                    { columnIndex : 2, key : "HDQT_PART_ORG_NM",    title : "본사파트",      align : "center",  width : "80px" },
                    { columnIndex : 3, key : "SALE_DEPT_ORG_NM",    title : "영업국명",      align : "center",  width : "80px" },
                    { columnIndex : 4, key : "SALE_TEAM_ORG_NM",    title : "영업팀명",      align : "center",  width : "80px" },
                    { columnIndex : 5, key : "RPSTY_NM",            title : "직책명",        align : "center",  width : "80px" },
                    { columnIndex : 6, key : "USER_NM",             title : "에이전트명",    align : "center",  width : "80px" },
                    { columnIndex : 7, key : "SCRB_ST_NM",          title : "가입상태",      align : "center",  width : "80px" }
                ]
            });
        },
        setGrid2 : function() {
            $("#grid2").alopexGrid({
                pager: false,
                height: "200px",
                columnMapping : [
                    { columnIndex : 0, selectorColumn : true, width : "20px" },
                    { columnIndex : 1, key : "HDQT_TEAM_ORG_NM",    title : "본사팀",        align : "center",   width : "80px" },
                    { columnIndex : 2, key : "HDQT_PART_ORG_NM",    title : "본사파트",      align : "center",   width : "80px" },
                    { columnIndex : 3, key : "SALE_DEPT_ORG_NM",    title : "영업국명",      align : "center",   width : "80px" },
                    { columnIndex : 4, key : "SALE_TEAM_ORG_NM",    title : "영업팀명",      align : "center",   width : "80px" },
                    { columnIndex : 5, key : "RPSTY_NM",            title : "직책명",        align : "center",   width : "80px" },
                    { columnIndex : 6, key : "USER_NM",             title : "에이전트명",    align : "center",   width : "80px" },
                    { columnIndex : 7, key : "SCRB_ST_NM",          title : "가입상태",      align : "center",   width : "80px" }
                ]
            });
        },
        searchList : function() {
        	
        	// 필수체크
            if ( !$.PSNM.isValid("searchForm") ) {
                return false;
            }
        	
            $.alopex.request("com.CODE@PBASE_pSearchAllUserPop", {
                data: "#searchTable",
                success: ["#grid1", function(res) {
                }]
            });
        },
        setCodeData : function() {
            $.PSNMUtils.setCodeData([
                { t:'org1',  'elemid' : 'HDQT_TEAM_ORG_ID', 'header' : '-전체-' } //[본사팀] 목록 조회
            ]);
        }
    });

    </script>
</head>
<body>

<div id="Wrap">

    <!-- title area -->
    <div class="pop_header">
    
        <div class="psnm-find-area" style="height:65px;">
            <div class="psnm-find-condarea">
                <form id="searchForm" onsubmit="return false;">
                <table id="searchTable" class="board02">
                <colgroup>
                    <col style=""/>
                    <col style="*"/>
                    <col style=""/>
                    <col style="*"/>
                    <col style=""/>
                    <col style="*"/>
                </colgroup>
                <tr>
                    <th class="fontred">본사팀</th>
                    <td class="tleft">
                        <select id="HDQT_TEAM_ORG_ID" data-bind="options:options_HDQT_TEAM_ORG_ID, selectedOptions: HDQT_TEAM_ORG_ID" data-type="select" 
                                data-validation-rule="{required:true}" 
                                data-validation-message="{required:$.PSNM.msg('E012', ['본사팀'])}">
                            <option value="">-선택-</option>
                        </select>
                    </td>
                    <th class="fontred">본사파트</th>
                    <td class="tleft">
                        <select id="HDQT_PART_ORG_ID" data-bind="options:options_HDQT_PART_ORG_ID, selectedOptions: HDQT_PART_ORG_ID" data-type="select" 
                                data-validation-rule="{required:true}" 
                                data-validation-message="{required:$.PSNM.msg('E012', ['본사파트'])}">
                            <option value="">-전체-</option>
                        </select>
                    </td>
                    <th>영업국명</th>
                    <td class="tleft">
                        <select id="SALE_DEPT_ORG_ID" data-bind="options:options_SALE_DEPT_ORG_ID, selectedOptions: SALE_DEPT_ORG_ID" data-dtokall="true" data-type="select" >
                            <option value="">-전체-</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th>영업팀명</th>
                    <td class="tleft">
                        <select id="SALE_TEAM_ORG_ID" data-bind="options:options_SALE_TEAM_ORG_ID, selectedOptions: SALE_TEAM_ORG_ID" data-type="select" >
                            <option value="">-전체-</option>
                        </select>
                    </td>
                    <th>회원ID/회원명</th>
                    <td class="tleft" colspan="3">
                        <input id="USER_ID_NM" name="USER_ID_NM" data-bind="value:USER_ID_NM" data-type="textinput" data-agentid="AGNT_ID" style="width:70px;" maxlength="10" />
                    </td>
                </tr>
                </table>
                </form>
            </div>
            <div class="psnm-find-btnarea">
                <input id="btnSearch" type="button" value="" data-type="button" data-theme="af-psnm">
            </div>
        </div>
      
        <!--view_table area -->
        <div class="textAR">
        
            <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>대상 회원 목록</b></div>
            <div id="grid1" data-bind="grid"></div>
            
            <div align="center" class="psnm-mid-btns">
                <button id="include" type="button" data-type="button" data-theme="af-btn-downicon" data-altname="아래로"></button>
                <button id="exclude" type="button" data-type="button" data-theme="af-btn-upicon" data-altname="위로"></button>
            </div>
            
            <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>선택 회원 목록</b></div>
            <div id="grid2"></div>

            <p class="floatL2">
                <button id="btnConfirm" type="button" data-type="button" data-theme="af-btn8" data-altname="확인"></button>
                <button id="btnCancel" type="button" data-type="button" data-theme="af-btn10" data-altname="취소"></button>
            </p>
        </div>
        
    </div>

</div>

</body>
</html>