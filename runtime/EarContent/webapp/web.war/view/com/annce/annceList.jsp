<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
    String _ROOT = "";
    System.out.println("############## 공지사항 목록");
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
            _debug('<annceList> $.alopex.page.init (param) : ' + JSON.stringify(param));

            $.PSNM.initialize(id, param); //PSNM공통 초기화함수 호출(서브 페이지에서는 필수 호출)

            $a.page.setEventListener();
            $a.page.setGrid();
            $a.page.setCodeData();

            $('#searchTable').setData(param); //(설명) 상세페이지에서 돌아오는 경우, 이 값들이 세션스토리지에서 반환됨.
            //상세페이지에서 다시 목록으로 돌아온 경우 '검색'함
            if ( $.PSNMUtils.isNotEmpty( param["RCV_TYP_CD"] ) && $.PSNMUtils.isNotEmpty( param["HDQT_TEAM_ORG_ID"] ) ) {
                searchList(); //조회
            }
        },
        setEventListener : function() {
            $("#btnSearch").click( searchList );
            $("#btnInit").click( initCondition );
            $("#btnNew").click( gotoNew );
            $("#btnExcelPage").click( excelPage );
            $("#btnExcelAll").click( excelAll );
            $("#USER_NM").keyup(function(e) {
                if (13==e.which) {
                    searchList(); //조회
                }
            });
            $("#AGNT_NM").keyup( $.PSNMAction.findAgent );
            $("#btnFindAgent").click( popFindAgent2 );

        }, //end-of-setEventListener
        setGrid : function() {
            //그리드 초기화
            $("#grid").alopexGrid({
                columnMapping : [
                    //{ columnIndex : 0, selectorColumn : true, width : "20px" },
                    { columnIndex : 0, key : "RN",            title : "번호",       align : "center", width : "40px" },
                    { columnIndex : 1, key : "FLAG",          title : "F",          align : "center", width : "40px" },
                    { columnIndex : 2, key : "ANNCE_ID",      title : "공지사항ID", align : "center", width : "80px" },
                    { columnIndex : 3, key : "RCV_TYP_NM",    title : "공지대상",   align : "center", width : "80px" },
                    { columnIndex : 4, key : "ANNCE_TITL_NM", title : "제목",       resizing : true, /* sorting : true, align : "center", */ width : "350px" },
                    { columnIndex : 5, key : "VIEW_CNT",      title : "조회수",     align : "right", width : "50px" },
                    { columnIndex : 6, key : "ATCH_YN",       title : "첨부파일",   align : "center", width : "80px" },
                    { columnIndex : 7, key : "POPUP_YN",      title : "팝업여부",   align : "center", width : "80px" },
                    { columnIndex : 8, key : "POPUP_STA_DT",  title : "팝업시작일", align : "center", width : "100px" },
                    { columnIndex : 9, key : "POPUP_END_DT",  title : "팝업종료일", align : "center", width : "100px" },
                    { columnIndex :10, key : "BLTNR_NM",      title : "게시자",     align : "center", width : "100px" },
                    { columnIndex :11, key : "BLTN_DT",       title : "게시일",     align : "center", width : "100px" }
                ],

                on : {
                    perPageChange : function(arg1) {
                        _debug("<annceList> <grid.on.perPageChange> 페이지당개수 변경 : arg1 = " + arg1);
                    }
                    ,
                    pageSet : function(pageNoToGo) {
                        _debug("<annceList> <grid.on.perPageChange> 페이지번호 변경 : 변경할 페이지번호 = " + pageNoToGo);
                        var p = {};
                            p.page = pageNoToGo;
                        var param = JSON.parse($a.session('alopex_parameters'));
                        param.page = pageNoToGo;

                        $a.session('alopex_parameters', JSON.stringify(param));
                        searchList(p); //페이지 이동
                    }
                }
            });
            $("#grid").alopexGrid('updateOption', {
                on : {
                    'cell' : {
                        "dblclick" : function(data, eh, e) { //표준 : 더블클릭시 상세페이지로 이동함.
                            _debug("<grid.updateOption> 더블클릭된 데이터 : " + data.ANNCE_ID + "\n\n" + data["ANNCE_ID"] + "\n\n" + $.PSNMUtils.toString(data));
                            gotoGeta(data.ANNCE_ID);
                        }
                    }
                }
            });
        }, //end-of-setGrid
        setCodeData : function() {
            $.PSNMUtils.setCodeData([
                { t:'code',  'elemid' : 'RCV_TYP_CD', 'codeid' : 'DSM_RCV_TYP_CD', 'header' : '-선택-' } //전체, 선택 등이 넣으려면 설정
               //,{ t:'org1',  'elemid' : 'HDQT_TEAM_ORG_ID', 'header' : '-선택-' } //[본사팀] 목록 조회
                // (설명) 화면에서 공통코드를 가져와서 표시하는 선택상자가 2개 이상인 경우, 아래와 같이 추가함
                //, { "elemid" : "BO_CD", "codeid" : "DSM_ANNCE_TYP_CD", "dataKey" : "options_RCV_TYP_CD", "header" : "-전체-" }
            ], function(params, rsCodeList) {
                //alert("코드데이터 설정후 callback 함수! (참고) setCodeData()는 sync 이므로 호출뒤에 처리해되 됨!");

                var rcvTypCdData = rsCodeList["RCV_TYP_CD"].nc_list;

                //alert("코드데이터 설정후 callback 함수!\n\nparams --------\n\n" + JSON.stringify(params) + "\n\nRCV_TYP_CD --------\n\n" + JSON.stringify(rcvTypCdData));
            });
        }
    });//end-of-$.alopex.page //-------------------------------------------------------------------------------------------------------//

    //조회 처리 : param은 페이지 이동시에만 값이 전달됨
    function searchList(param) {
        // 폼 검증 1 : setValidators() 에서 지정된 것
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
            //showProgress: true,
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

    //검색조건을 초기화함
    function initCondition() {
        $.PSNM.resetCondition("#searchTable"); //지정된 폼의 모든 데이터를 초기화
        //TODO : 페이지별 추가 작업
    }

    //상세페이지로 이동
    function gotoGeta(annceId) {
        _debug("<gotoGeta> 공지사항ID = [" + annceId + "]");
        var param = $('#searchTable').getData({selectOptions:true}); //(설명) 알로펙스에서 data-bind 된 데이터들을 모두 가져올 수 있음
            param["ANNCE_ID"]  = annceId; //(설명) 추가적으로 데이터 조작
            param["page"]      = $("#grid").alopexGrid("pageInfo").customPaging.current; //
            param["page_size"] = $('#grid').alopexGrid('pageInfo').perPage; //$("#grid").alopexGrid("pageInfo").customPaging.perPage; //(참조) $("#grid .perPage").val()
        _debug("<gotoGeta> param : " + JSON.stringify(param));
        $a.navigate("annceEdit.jsp", param);
    }

    //신규페이지로 이동
    function gotoNew() {
        _debug("<gotoNew> 신규");
        var param = $('#searchTable').getData({selectOptions:true}); //(설명) 알로펙스에서 data-bind 된 데이터들을 모두 가져올 수 있음
            param["ANNCE_ID"]  = ""; //(설명) 추가적으로 데이터 조작
            param["page_size"] = $('#grid').alopexGrid('pageInfo').perPage; //(참조) $("#grid .perPage").val()
        try { 
            param["page"] = $("#grid").alopexGrid("pageInfo").customPaging.current; 
        } catch(E) {
            param["page"] = 1; //디폴트 1페이지
        }
        _debug("<gotoNew> param : " + JSON.stringify(param));
        $a.navigate("annceEdit.jsp", param);
    }

    function popFindAgent2() {
        _debug("<popFindAgent2> 현재 alopex세션값 : \n###### " + JSON.stringify( $a.session("alopex_parameters") ));

        var oParam = new Object();
            oParam = $('#searchForm').getData({selectOptions:true}); //본사팀, 본사파트, 영업국, 영업팀 조건을 넘겨주기 위함.
            oParam["FINDTYPE"] = "ALL"; //DEFAULT or ALL

        _debug("<popFindAgent2> 팝업으로 전달하려는 값 : \n###### " + JSON.stringify(oParam));

        $.PSNMAction.popFindAgent(oParam, function(oResult) {
            alert("콜백에 반환된값\n\n" + JSON.stringify(oResult));
            if ( null!=oResult && typeof oResult == "object" ) {
                $("#AGNT_NM2").val( oResult["USER_NM"] );
                $("#AGNT_ID2").val( oResult["USER_ID"] );
            }
        });
    }

    //
    function excelPage() {
        var oExcelMetaInfo = {
                filename  : "공지사항목록_페이지만.xls",
                sheetname : "공지사항목록_페이지만",
                gridname  : "grid" //그리드ID 
            };
        $.PSNMUtils.downloadExcelPage("grid", oExcelMetaInfo);
    }
    function excelAll() {
        var oExcelMetaInfo = {
                filename  : "공지사항목록전체.xls",
                sheetname : "공지사항목록전체",
                gridname  : "grid" //그리드ID 
            };
        var txid = "brd.BRDBAnnce@PBRD0001_pBRD01001";

        $.PSNMUtils.downloadExcelAll("searchForm", txid, "grid", oExcelMetaInfo, [1,7]);
    }
    
    function onAgentFound(returnVal) {
        alert( "onAgentFound\n\n" + JSON.stringify(returnVal));
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
                <th height="40" style="width:100px;" scope="col" class="psnm-required">공지대상</th>
                <td class="tleft"><!-- data-bind="option: {value: datakey, option2: datakey2}"  -->
                    <select id="RCV_TYP_CD" name="RCV_TYP_CD" data-bind="options: options_RCV_TYP_CD, selectedOptions: RCV_TYP_CD" data-type="select" data-wrap="false" 
                            data-validation-rule="{required:true}" 
                            data-validation-message="{required:$.PSNM.msg('E012', ['공지대상'])}" style="width:150px;">
                        <option value="">-전체-</option>
                    </select>
                </td>
                <th style="width:100px;" class="psnm-required">본사팀</th>
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
            <tr>
                <th>게시자</th>
                <td class="tleft">
                    <input id="USER_NM" name="USER_NM" data-bind="value: USER_NM" data-type="textinput" style="width:150px;" />
                </td>
                <th style="width:100px;">&nbsp;</th>
                <td class="tleft">
                    <input type="radio" data-type="radio" id="SEX1" name="SEX" value="1" data-bind="checked:SEX" data-theme="af-radio" class="spaceL"> 남성
                    <input type="radio" data-type="radio" id="SEX2" name="SEX" value="2" data-bind="checked:SEX" data-theme="af-radio" class="spaceL"> 여성
                </td>
                <th style="width:100px;">&nbsp;</th>
                <td class="tleft">
                    <input type="checkbox" data-type="checkbox" id="YN" name="YN" data-bind="checked:YN" data-theme="af-checkbox" class="spaceL"> 여부
                </td>
            </tr>
            <tr>
                <th height="40" style="width:100px;" scope="col">본사파트</th>
                <td class="tleft">
                    <select id="HDQT_PART_ORG_ID" data-bind="options:options_HDQT_PART_ORG_ID, selectedOptions: HDQT_PART_ORG_ID" data-type="select" data-wrap="false" style="width:150px;">
                        <option value="">-전체-</option>
                    </select>
                </td>
                <th style="width:100px;">영업국</th>
                <td class="tleft">
                    <select id="SALE_DEPT_ORG_ID" data-bind="options:options_SALE_DEPT_ORG_ID, selectedOptions: SALE_DEPT_ORG_ID" data-type="select" data-wrap="false" style="width:150px;">
                        <option value="">-전체-</option>
                    </select>
                </td>
                <th style="width:100px;">영업팀</th>
                <td class="tleft">
                    <select id="SALE_TEAM_ORG_ID" data-bind="options:options_SALE_TEAM_ORG_ID, selectedOptions: SALE_TEAM_ORG_ID" data-type="select" data-wrap="false" style="width:150px;">
                        <option value="">-전체-</option>
                    </select>
                </td>
            </tr>
            <tr>
                <th height="40" style="width:100px;" scope="col">에이전트명</th>
                <td class="tleft">
                    <input id="AGNT_NM" name="AGNT_NM" data-bind="value:AGNT_NM" data-type="textinput" data-agentid="AGNT_ID" data-callback="onAgentFound" data-findtype="DEFAULT" style="width:40%;" maxlength="10" />
                    <input id="AGNT_ID" name="AGNT_ID" data-bind="value:AGNT_ID" data-type="textinput" data-disabled="true" disabled style="width:40%;" />
                </td>
                <th style="width:100px;">예2</th>
                <td class="tleft">
                    <!-- (주의) 아래 에이전트ID/에이전트명 id는 위와 겹처서 2를 사용하지만 각 화면에서는 AGNT_ID/AGNT_NM 으로 사용 -->
                    <input id="AGNT_NM2"  data-type="textinput" data-bind="value:AGENT_NM" style="width:50px">
                    <img id="btnFindAgent" src="<c:out value='${pageContext.request.contextPath}'/>/image/btn_c9.gif"/>
                    <input id="AGNT_ID2"  data-type="textinput" data-bind="value:AGENT_CD" style="width:50px" data-theme="af-textinput" data-disabled=true>
                </td>
                <th class="psnm-required" style="width:100px;">필수항목</th>
                <td class="tleft">
                    class="psnm-required"
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
            <!-- <button id="btnInit"      data-type="button" data-theme="af-psnm0" data-authtype="R">초기화</button> -->
            <button id="btnNew"       data-type="button" data-theme="af-btn2"  data-authtype="W"></button>
            <button id="btnExcelPage" data-type="button" data-theme="af-btn3"  data-authtype="W"></button>
            <button id="btnExcelAll"  data-type="button" data-theme="af-n-btn27"  data-authtype="W"></button>
        </p>
    </div>

    <!-- main grid -->
    <div id="grid" data-bind="grid:grid" data-ui="ds"></div>

</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>
