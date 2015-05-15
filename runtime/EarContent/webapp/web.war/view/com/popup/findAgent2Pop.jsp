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
        init : function(id, param) { //{"HDQT_TEAM_ORG_ID":"C21100","HDQT_PART_ORG_ID":"","SALE_DEPT_ORG_ID":"","SALE_TEAM_ORG_ID":"","AGNT_NM":"ab"} 
            _initParam = param;
            console.log('<findAgent2Pop> $.alopex.page.init (param) : \n###### ' + JSON.stringify(param));

            var arrHTeam = param["options_HDQT_TEAM_ORG_ID"];
            if ( $.PSNMUtils.isNotEmpty(arrHTeam) && jQuery.isArray(arrHTeam) ) {
                //$.PSNM.initOrgSelectBox(); //본사팀, 본사파트, 영업국 select 객체 초기화
            }
            else {
                //$a.page.setCodeData(); //본사팀코드를 조회
            }
            $.PSNM.setOrgSelectBox(); //$.PSNM.initOrgSelectBox(); //본사팀, 본사파트, 영업국 select 객체 초기화
            $a.page.setEventListener();
            $a.page.setGrid();

            $('#searchForm').setData(param);
            //pSearchAgnt(); //조회
        },
        setEventListener : function() {
            $("#btnSearch").click( pSearchAgnt ); //조회
            $("#btnConfirm").click( closeConfirm );
            $("#btnCancel").click( closeWithout );
            $("#iconCancel").click( closeWithout );

        }, //end-of-setEventListener
        setGrid : function() {
            //그리드 초기화
            $("#gridagnt").alopexGrid({
            	rowSingleSelect : true,
                paging: {
                    perPage : 10,
                    pagerCount : 10
                },
                columnMapping : [
                    { columnIndex : 0, key : "RN",               title : "번호",            align : "center", width : "40px" }, //{ columnIndex : 0, selectorColumn : true, width : "20px" },
                    { columnIndex : 1, key : "HDQT_TEAM_ORG_NM", title : "본사팀",          align : "left",   width : "80px" },
                    { columnIndex : 2, key : "HDQT_PART_ORG_NM", title : "본사파트",         align : "left",  width : "80px" },
                    { columnIndex : 3, key : "SALE_DEPT_ORG_NM", title : "영업국명",           align : "left",  width : "80px" },
                    { columnIndex : 4, key : "SALE_TEAM_ORG_NM", title : "영업팀명",           align : "left",  width : "80px" },
                    { columnIndex : 5, key : "AGNT_ID",          title : "에이전트 코드",     align : "left",  width : "80px" },
                    { columnIndex : 6, key : "RPSTY_NM",         title : "직책명",            align : "left", width : "50px"},
                    { columnIndex : 7, key : "AGNT_NM",          title : "에이전트명",        align : "left",  width : "50px" },
                    { columnIndex : 8, key : "HDQT_TEAM_ORG_ID", title : "HDQT_TEAM_ORG_ID", align : "left",   hidden:true },
                    { columnIndex : 9, key : "HDQT_PART_ORG_ID", title : "HDQT_PART_ORG_ID", align : "left",   hidden:true },
                    { columnIndex :10, key : "SALE_DEPT_ORG_ID", title : "SALE_DEPT_ORG_ID", align : "left",   hidden:true },
                    { columnIndex :11, key : "SALE_TEAM_ORG_ID", title : "SALE_TEAM_ORG_ID", align : "left",   hidden:true },
                    { columnIndex :12, key : "DUTY",             title : "DUTY",             align : "left",   hidden:true },
                    { columnIndex :13, key : "RPSTY",            title : "RPSTY",            align : "left",   hidden:true },
                    { columnIndex :14, key : "RPSTY",            title : "RPSTY",            align : "left",   hidden:true },
                    { columnIndex :15, key : "USER_ID",          title : "USER_ID",          align : "left",   hidden:true },
                    { columnIndex :16, key : "BIRTH_DT",         title : "BIRTH_DT",          align : "left",   hidden:true }
                ],
                on : {
                    perPageChange : function(arg1) {
                        console.log("<findAgent2Pop> <grid.on.perPageChange> 페이지당개수 변경 : arg1 = " + arg1);
                    }
                    ,
                    pageSet : function(pageNoToGo) {
                        console.log("<findAgent2Pop> <grid.on.perPageChange> 페이지번호 변경 : 변경할 페이지번호 = " + pageNoToGo);
                        var p = {};
                            p.page = pageNoToGo;
                        //var param = JSON.parse($a.session('alopex_parameters'));
                        //param.page = pageNoToGo;
                        //$a.session('alopex_parameters', JSON.stringify(param));
                        pSearchAgnt(p); //페이지 이동
                    }
                }
            });
            $("#gridagnt").alopexGrid('updateOption', {
                on : {
                    'cell' : {
                        "dblclick" : function(data, eh, e) {
                            console.log("<gridagnt.updateOption> 더블클릭된 데이터 : " + $.PSNMUtils.toString(data));
                            closeWith(data);
                        }
                    }
                }
            });
        }, //end-of-setGrid
        setCodeData : function() {
            $.PSNMUtils.setCodeData([
                { t:'org1',  'elemid' : 'HDQT_TEAM_ORG_ID', 'header' : '-전체-' } //[본사팀] 목록 조회
            ]);
        }
    });//end-of-$.alopex.page //-------------------------------------------------------------------------------------------------------//

    //조회 처리 : param은 페이지 이동시에만 값이 전달됨
    function pSearchAgnt(param) {
        var _page_no = 1;
        if ( $.PSNMUtils.isNotEmpty(param) && $.PSNMUtils.isNotEmpty(param.page) ) {
            _page_no = param.page; //(설명) 페이지 이동할때만 페이지번호가 넘어옴.
        }
        var _per_page = $('#gridagnt').alopexGrid('pageInfo').perPage; // $("#grid .perPage").val();

        $.alopex.request('com.USERINFO@PUSERSCRBREQ001_pSearchAgnt', {
            data: ['#searchForm', function() {
                var p = this.data.dataSet.fields;
                this.data.dataSet.fields = $.PSNMUtils.removeParamArrays(p); //세션에 options_ 배열이 있는 경우 제거함(@since 2014-12-03)
                this.data.dataSet.fields.page      = _page_no;
                this.data.dataSet.fields.page_size = _per_page;
                console.log("<pSearchAgnt> <request.data> 파라미터 (this.data.dataSet.fields) : " + JSON.stringify(this.data.dataSet.fields));
            }],
            success: ['#gridagnt', function(res) {
                //console.log("<pSearchAgnt> <request.success> 결과데이터 : " + JSON.stringify(res));
            }]
        });
    } //end of pSearchAgnt()

    //현재창을 닫고 객체를 반환
    function closeWith(oRecord) {
        //alert("<findAgent2Pop> 반환값 ----\n\n" + JSON.stringify(oRecord));
        $a.close( oRecord );
    }

    function closeWithout() {
        $a.close();
    }

    function closeConfirm() {
        var arrAgents = $("#gridagnt").alopexGrid( "dataGet" , { _state : { selected : true } } ); //선택된 데이터

        if (arrAgents.length<1) {
            alert("에이전트를 선택하십시오!");
            return;
        }
        else if (arrAgents.length>1) {
            alert("1개의 에이전트를 선택하십시오!");
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
    	<!-- 
        <span class="title">에이전트 찾기</span>
        <a id="iconCancel" href="#" class="pop_close"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a9.gif" alt="팝업닫기" ></a> 
		 -->
        <div class="psnm-find-area" style="height:65px;">
          <form id="searchForm" onsubmit="return false;">
            <div class="psnm-find-condarea">
                <table class="board02">
	        	<colgroup>
		            <col style="width:10%"/>
		            <col style="width:23%"/>
		            <col style="width:10%"/>
		            <col style="width:23%"/>
		            <col style="width:10%"/>
		            <col style="width:*"/>
	            </colgroup>
                <tr>
                    <th scope="col">본사팀</th>
                    <td class="tleft">
                        <select id="HDQT_TEAM_ORG_ID" data-bind="options:options_HDQT_TEAM_ORG_ID, selectedOptions:HDQT_TEAM_ORG_ID" data-type="select"  style="width:150px;">
                        </select>
                    </td>
                    <th>본사파트</th>
                    <td class="tleft">
                        <select id="HDQT_PART_ORG_ID" data-type="select" data-bind="options:options_HDQT_PART_ORG_ID, selectedOptions:HDQT_PART_ORG_ID"  style="width:150px;">
                        </select>
                    </td>
                    <th>영업국명</th>
                    <td class="tleft">
                        <select id="SALE_DEPT_ORG_ID" data-type="select" data-bind="options:options_SALE_DEPT_ORG_ID, selectedOptions:SALE_DEPT_ORG_ID"  style="width:150px;">
                        </select>
                    </td>
                </tr>
                <tr>
                    <th scope="col">영업팀명</th>
                    <td class="tleft">
                        <select id="SALE_TEAM_ORG_ID" data-type="select" data-bind="options:options_SALE_TEAM_ORG_ID, selectedOptions:SALE_TEAM_ORG_ID"  style="width:150px;">
                        </select>
                    </td>
                    <th >에이전트명</th>
                    <td colspan="3" class="tleft">
                        <input id="AGNT_NM" data-type="textinput" data-bind="value:AGNT_NM" style="width:150px;" maxlength="10">
                        <input id="FINDTYPE" name="FINDTYPE" type="hidden" data-bind="value:FINDTYPE" />
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
        <div class="textAR">

            <div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>에이전트 목록</b>
                <p class="ab_pos2">
                    <!-- <button id="btnInit"      data-type="button" data-theme="af-psnm0">초기화</button> -->
                </p>
            </div>

            <!-- main grid -->
            <div id="gridagnt" data-bind="grid:gridagnt" data-ui="ds"></div>

            <p class="floatL2">
                <input id="btnConfirm" type="button" value="" data-type="button" data-theme="af-btn8">
                <input id="btnCancel"  type="button" value="" data-type="button" data-theme="af-btn10">
            </p>
        </div>

    </div>

</div>

</body>
</html>