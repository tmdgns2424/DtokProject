<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
    String _ROOT = "";
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

    <jsp:include page="/view/layouts/default_head.jsp" flush="false" />

    <script type="text/javascript">
    _LOG_LEVEL = 0; //로그레벨 :: 0=debug, 1=info, 2=error

    $.alopex.page({

        init : function(id, param) { 
            _debug('<griddyn> $.alopex.page.init (param) : ' + JSON.stringify(param));

            $.PSNM.initialize(id, param); //PSNM공통 초기화함수 호출(서브 페이지에서는 필수 호출)

            $a.page.setEventListener();
            $a.page.setGrid();
        },
        setEventListener : function() {
            $("#btnSearch").click( searchList );
            $("#btnNew").click( changeGrid );
            $("#btnNew2").click( getColumninfo );
        }, //end-of-setEventListener
        setGrid : function() {
            $("#griddyn").alopexGrid({
                columnMapping : [
                    //{ columnIndex : 0, selectorColumn : true, width : "20px" },
                    { columnIndex : 0, key : "RN",            title : "번호",       align : "center", width : "40px" },
                    { columnIndex : 1, key : "FLAG",          title : "F",          align : "center", width : "40px" },
                    { columnIndex : 2, key : "ANNCE_ID",      title : "공지사항ID", align : "center", width : "80px" },
                    { columnIndex : 3, key : "RCV_TYP_NM",    title : "공지대상",   align : "center", width : "80px" },
                    { columnIndex : 4, key : "ANNCE_TITL_NM", title : "제목",       resizing : true, /* sorting : true, align : "center", */ width : "350px" },
                    { columnIndex : 5, key : "VIEW_CNT",      title : "조회수",     align : "right", width : "50px" }
                ]
            });
        }, //end-of-setGrid
        setCodeData : function() {
            $.PSNMUtils.setCodeData([
                { t:'code',  'elemid' : 'RCV_TYP_CD', 'codeid' : 'DSM_RCV_TYP_CD', 'header' : '-전체-' } //전체, 선택 등이 넣으려면 설정
               ,{ t:'org1',  'elemid' : 'HDQT_TEAM_ORG_ID', 'header' : '-전체-' } //[본사팀] 목록 조회
                // (설명) 화면에서 공통코드를 가져와서 표시하는 선택상자가 2개 이상인 경우, 아래와 같이 추가함
                //, { "elemid" : "BO_CD", "codeid" : "DSM_ANNCE_TYP_CD", "dataKey" : "options_RCV_TYP_CD", "header" : "-전체-" }
            ]);
        }
    });//end-of-$.alopex.page //-------------------------------------------------------------------------------------------------------//

    //조회 처리 : param은 페이지 이동시에만 값이 전달됨
    function searchList(param) {
        //var validator = $("#searchForm").validator();
        //if ( !validator.validate() ) {
        //    //var errorstr = '',
        //    var errormessages = validator.getErrorMessage(); alert( JSON.stringify(validator.getErrorMessage()) );
        //    for(var name in errormessages) {
        //        for(var i=0; i < errormessages[name].length; i++) {
        //            $.PSNM.alert(errormessages[name][i]);
        //            $("#" + name).focus();
        //            return; //여기서 반환
        //        }
        //    }
        //}
        if ( !$.PSNM.isValid("searchForm") ) {
            return false;
        }

        var _page_no = 1;
        if ( $.PSNMUtils.isNotEmpty(param) && $.PSNMUtils.isNotEmpty(param.page) ) {
            _page_no = param.page; //(설명) 페이지 이동할때만 페이지번호가 넘어옴.
        }
        var _per_page = $('#grid').alopexGrid('pageInfo').perPage; // $("#grid .perPage").val();

        $.alopex.request('brd.BRDBAnnce@PBRD0001_pBRD01001', {
            //(설명) 폼 'searchTable' 자식 input 데이터들을 this.data.dataSet.fields 에 모두 수집하여 설정함.
            //      (11-25 현재 버그 : select의 options 배열이 들어감. 수정예정 by 이준석대리)
            data: ['#searchTable', function() {
                this.data.dataSet.fields.page      = _page_no;
                this.data.dataSet.fields.page_size = _per_page;

                _debug("<searchList> <request.data> 파라미터 (this.data.dataSet.fields) : " + JSON.stringify(this.data.dataSet.fields));
            }],

            // (설명) grid 에 데이터를 바인딩후 추가적인 작업은 함수에서 할 수 있음.
            success: ['#grid', function(res) {
                //_debug("<searchList> <request.success> 결과데이터 : " + JSON.stringify(res));
            }]
        });
    } //end of searchList()
    
    function changeGrid() {
            var arrGridTitle = new Array();
            for(var i=0; i<5; i++) {
                var aTitle = new Object();
                    aTitle["columnIndex"] = i;
                    aTitle["key"]   = "KEY" +i;
                    aTitle["title"] = "제목 " + i;
                    aTitle["align"] = "center";
                    aTitle["key"]   = "100px";
                arrGridTitle.push( aTitle );
            }
            
            $("#griddyn").alopexGrid('updateOption', {
                columnMapping : arrGridTitle,
                on : {
                    'cell' : {
                        "dblclick" : function(data, eh, e) {
                            _debug("<grid.updateOption> 더블클릭된 데이터 : " + data.ANNCE_ID + "\n\n" + data["ANNCE_ID"] + "\n\n" + $.PSNMUtils.toString(data));
                            gotoGeta(data.ANNCE_ID);
                        }
                    }
                }
            });
    }
    
    function getColumninfo() {
        var colinfo = $("#griddyn").alopexGrid('columnInfo', 1);
        alert(JSON.stringify(colinfo));
    }

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
                <span class="a2">대메뉴명</span> <span class="a3"> > </span> <span class="a4"><b>중메뉴명</b></span> 
            </span>
        </div>
    </div>

    <!-- find condition area -->
    <div id="searchDiv" class="textAR">
        <form id="searchForm" onsubmit="return false;">
            <table id="searchTable" class="board02" style="width:92%;">
            <tr>
                <th height="40" style="width:100px;" scope="col" class="fontred">공지대상</th>
                <td class="tleft"><!-- data-bind="option: {value: datakey, option2: datakey2}"  -->
                    <select id="RCV_TYP_CD" name="RCV_TYP_CD" data-bind="options: options_RCV_TYP_CD, selectedOptions: RCV_TYP_CD" data-type="select" data-wrap="false" 
                            data-validation-rule="{required:true}" 
                            data-validation-message="{required:$.PSNM.msg('E012', ['공지대상'])}" style="width:150px;">
                        <option value="">-전체-</option>
                    </select>
                </td>
                <th style="width:100px;" class="fontred">본사팀</th>
                <td class="tleft">
                    <select id="HDQT_TEAM_ORG_ID" name="HDQT_TEAM_ORG_ID" data-bind="options:options_HDQT_TEAM_ORG_ID, selectedOptions:HDQT_TEAM_ORG_ID"  data-type="select" data-wrap="false"
                            data-validation-rule="{required:true}" 
                            data-validation-message="{required:$.PSNM.msg('E012', ['본사팀'])}" style="width:150px;">
                        <option value="">-전체-</option>
                        <!-- <option value="324031">(324031) B2B사업팀</option> -->
                    </select>
                </td>
                <th style="width:100px;">권한그룹</th>
                <td class="tleft">
                    <select id="AUTH_GRP_ID" data-bind="selectedOptions: AUTH_GRP_ID" data-type="select" data-wrap="false" data-codeid="AUTH_GRP_ID" style="width:150px;">
                        <option value="">-전체-</option>
                        <option value="01">(01) 관리자</option>
                        <option value="02">(02) 부문</option>
                        <option value="03">(03) 영업관리</option>
                    </select>
                </td>
            </tr>
            </table>
        </form>
            <div class="ab_pos5">
                <button id="btnSearch" data-type="button" data-theme="af-psnm" data-authtype="R"></button><!-- 조회버튼 -->
            </div>
    </div>

    <div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>공지사항</b>
        <p class="ab_pos2">
            <button id="btnNew"       data-type="button" data-theme="af-btn2"  data-authtype="W"></button>
            <button id="btnNew2"       data-type="button" data-theme="af-btn2"  data-authtype="W"></button>
        </p>
    </div>

    <!-- main grid -->
    <div id="griddyn" data-bind="grid:griddyn" data-ui="ds"></div>

</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>
