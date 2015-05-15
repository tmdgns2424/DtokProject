<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
    String _ROOT = "";
    System.out.println("############## 조직 select 예제");
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
            _debug('<orgList> $.alopex.page.init (param) : ' + JSON.stringify(param));

            $.PSNM.initialize(id, param); //PSNM공통 초기화함수 호출(서브 페이지에서는 필수 호출)

            $a.page.setEventListener();
            //$a.page.setGrid();
            $a.page.setCodeData();
        },
        setEventListener : function() {
            //$("#AGNT_NM").keyup( $.PSNMAction.findAgent );
            $("#dtokall").change(function() {
                var val = $(this).val();
                if ( ""==val ) {
                    $("#SALE_DEPT_ORG_ID").data("dtokall", "");
                    alert("영업국목록조회시 DTOK_EFF_ORG_YN='Y' 조건넣고 조회(default)");
                }
                else {
                    $("#SALE_DEPT_ORG_ID").data("dtokall", val);
                    alert("영업국목록조회시 DTOK_EFF_ORG_YN='Y' 조건 없이 조회함\n\n(전화번호부화면에서) select 마크업의 속성에 data-dtokall='true' 을 표시할것! ");
                }
            });
        }, //end-of-setEventListener
        setGrid : function() {
            
        }, //end-of-setGrid
        setCodeData : function() {
            $.PSNMUtils.setCodeData([
                { t:'code',  'elemid' : 'RCV_TYP_CD', 'codeid' : 'DSM_RCV_TYP_CD', 'header' : '-전체-' } //전체, 선택 등이 넣으려면 설정
               ,{ t:'duty',  'elemid' : 'DUTY_CD',    'codeid' : '1', 'header' : '-전체-' } //[직무] 목록 조회 ::: 여기서 codeid 는 DUTY테이블.USER_TYP 값임
            ]);
        }
    });//end-of-$.alopex.page //-------------------------------------------------------------------------------------------------------//

    function popFindAgent2() {
        _debug("<popFindAgent2> 현재 alopex세션값 : \n###### " + JSON.stringify( $a.session("alopex_parameters") ));

        var oParam = new Object();
            oParam = $('#searchForm').getData({selectOptions:true}); //본사팀, 본사파트, 영업국, 영업팀 조건을 넘겨주기 위함.

        _debug("<popFindAgent2> 팝업으로 전달하려는 값 : \n###### " + JSON.stringify(oParam));

        $.PSNMAction.popFindAgent(oParam, function(oResult) {
            alert("콜백에 반환된값\n\n" + JSON.stringify(oResult));
            if ( null!=oResult && typeof oResult == "object" ) {
                $("#AGNT_NM2").val( oResult["USER_NM"] );
                $("#AGNT_ID2").val( oResult["USER_ID"] );
            }
        });
    }

    </script>

</head>

<body>

<jsp:include page="/view/layouts/default_header.jsp" flush="false" />

<div id="contents">

    <!-- sub title area -->
    <div id="lay_out">
        <div id="ub_txt6">
            <span class="txt6_img"><b id="sub-title">조직 select 예제</b>
                <span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif">
                <span class="a2">공통</span> <span class="a3"> > </span> <span class="a4"><b>예제</b></span> 
            </span>
        </div>
    </div>

    <!-- find condition area -->
    <div id="searchDiv" class="textAR">
        <form id="searchForm" onsubmit="return false;">
            <table id="searchTable" class="board02" style="width:92%;">
            <tr>
                <th height="40" style="width:100px;" scope="col">본사팀</th>
                <td class="tleft"><!-- data-bind="option: {value: datakey, option2: datakey2}"  -->
                    <select id="HDQT_TEAM_ORG_ID" data-bind="options:options_HDQT_TEAM_ORG_ID, selectedOptions:HDQT_TEAM_ORG_ID"  data-type="select" data-wrap="false">
                        <option value="">-전체-</option>
                    </select>
                </td>
                <th style="width:100px;">본사파트</th>
                <td class="tleft">
                    <select id="HDQT_PART_ORG_ID" data-bind="options:options_HDQT_PART_ORG_ID, selectedOptions: HDQT_PART_ORG_ID" data-type="select" data-wrap="false">
                        <option value="">-선택-</option>
                    </select>
                </td>
                <th style="width:100px;">영업국</th>
                <td class="tleft">
                    <select id="SALE_DEPT_ORG_ID" data-bind="options:options_SALE_DEPT_ORG_ID, selectedOptions: SALE_DEPT_ORG_ID" data-type="select" data-dtokall='true' data-wrap="false">
                        <option value="">-선택-</option>
                    </select>
                </td>
            </tr>
            <tr>
                <th height="40" style="width:100px;" scope="col">영업팀</th>
                <td class="tleft">
                    <select id="SALE_TEAM_ORG_ID" data-bind="options:options_SALE_TEAM_ORG_ID, selectedOptions: SALE_TEAM_ORG_ID" data-type="select" data-wrap="false">
                        <option value="">-선택-</option>
                    </select>
                </td>
                <th style="width:100px;">에이전트</th>
                <td class="tleft">
                    <select id="SALE_AGNT_ORG_ID" data-bind="options:options_SALE_AGNT_ORG_ID, selectedOptions: SALE_AGNT_ORG_ID" data-type="select" data-wrap="false">
                        <option value="">-선택-</option>
                    </select>
                </td>
                <th style="width:100px;">직무</th>
                <td class="tleft">
                    <select id="DUTY_CD" data-bind="options:options_DUTY_CD, selectedOptions: DUTY_CD" data-type="select" data-wrap="false">
                        <option value="">-선택-</option>
                    </select>
                </td>
            </tr>
            <tr>
                <th height="40" style="width:100px;" scope="col">영업국 조건</th>
                <td colspan="5" class="tleft">
                    <span style="color:red;">영업국목록조회시 기본적으로 DTOK_EFF_ORG_YN='Y' 조건이 포함됨</span> (@since 2015-01-29) &nbsp;&nbsp;&nbsp;&nbsp;
                    <select id="dtokall" data-type="select" data-wrap="false">
                        <option value="">기본(포함)</option>
                        <option value="true">제외하려할때</option>
                    </select>
                </td>
            </tr>
            </table>
        </form>
            <div class="ab_pos4">
                <button id="btnSearch" data-type="button" data-theme="af-psnm"></button><!-- 조회버튼 -->
            </div>
    </div>

    <div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>조직 select</b>
        <p class="ab_pos2">
            <button id="btnNew"       data-type="button" data-theme="af-btn2" data-altname="신규"></button>
            <button id="btnExcelPage" data-type="button" data-theme="af-btn3" data-altname="엑셀"></button>
        </p>
    </div>

    <!-- main grid -->
    <div id="grid">
        <p class="" style="font-size: 14px;">
            [[ 선택상자(SELECT) ]]
            <PRE style="font-size: 14px; font-family: 맑은 고딕;">
            - 본사팀   : 화면요소(element) ID : HDQT_TEAM_ORG_ID (필수 고정)
            - 본사파트 : 화면요소(element) ID : HDQT_PART_ORG_ID (필수 고정)
            - 영업국   : 화면요소(element) ID : SALE_DEPT_ORG_ID (필수 고정)
            - 영업팀   : 화면요소(element) ID : SALE_TEAM_ORG_ID (필수 고정)
            - 에이전트 : 화면요소(element) ID : SALE_AGNT_ORG_ID (필수 고정)
            </PRE>
        </p>
        <hr /><BR/> <BR/>
        <p class="" style="font-size: 14px;">
            [[ 직무코드 ]] <BR/> <BR/>  //[직무] 목록 조회 ::: 여기서 codeid 는 DUTY테이블.USER_TYP 값임
            - elemid : 화면요소(element) ID <BR/>
            - codeid : DUTY테이블.USER_TYP 값임(빈값 OR 1 OR 2 OR 3 가능) <BR/>
            - 다음은 직무코드를 조회하는 예(공통코드 조회와 동일) <BR/>
            
            <PRE>
            $.PSNMUtils.setCodeData([
                ...(생략)
               ,{ t:'duty',  'elemid' : 'DUTY_CD', 'codeid' : '1', 'header' : '-전체-' }
               ,...(생략)
            ]);
            </PRE>
        </p>
    </div>

</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>
