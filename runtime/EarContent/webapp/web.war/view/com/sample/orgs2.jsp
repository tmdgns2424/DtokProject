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
            _debug('<orgs2> $.alopex.page.init (param) : ' + JSON.stringify(param));

            $.PSNM.initialize(id, param); //PSNM공통 초기화함수 호출(서브 페이지에서는 필수 호출)

            $a.page.setEventListener();
            //$a.page.setCodeData();
        },
        setEventListener : function() {
            //$("#btnNew").keyup( $.PSNMAction.findAgent );
            $("#btnNew").click( test1 );
        },
        setCodeData : function() {
        }
    });//end-of-$.alopex.page //-------------------------------------------------------------------------------------------------------//

    function test1() {
        var optHtml = $("#HDQT_TEAM_ORG_ID").html();

        alert("HDQT_TEAM_ORG_ID html \n\n" + optHtml);

        $("#HDQT_TEAM_ORG_ID2").html(optHtml);
        $("#HDQT_TEAM_ORG_ID2").unbind("change");
        $("#HDQT_TEAM_ORG_ID2").bind("change", _onchange_HDQT_TEAM_ORG_ID2);
        
    }
    //[본사팀] 코드 변경시 처리
    function _onchange_HDQT_TEAM_ORG_ID2(E) {
        var eTargetId = E.target.id;
        var sHdqtTeamOrgIdVal = $("#" + eTargetId + " option:selected").val(); //선택된 '본사팀ID' //HDQT_TEAM_ORG_ID
        var sHdqtPartOrgIdElemId = 'HDQT_PART_ORG_ID2'; //'본사파트' element id(화면요소의 ID임)
        _debug("<본사팀변경됨> <본사팀코드변경> 변경된 본사팀코드 = [" +  sHdqtTeamOrgIdVal + "], 이벤트발생요소ID = [" + eTargetId + "]");

        //$.PSNMUtils.setSelectDefaultPlaceHolder("SALE_TEAM_ORG_ID"); //이 화면에는 없으므로 제거
        //$.PSNMUtils.setSelectDefaultPlaceHolder("SALE_DEPT_ORG_ID"); //이 화면에는 없으므로 제거
        $.PSNMUtils.setSelectDefaultPlaceHolder("HDQT_PART_ORG_ID2");

        if ( $.PSNMUtils.isNotEmpty(sHdqtTeamOrgIdVal) ) {
            $("#" + sHdqtPartOrgIdElemId + "").val("");
            $.PSNMUtils.setCodeData([
                { t:'org2', 'elemid' : sHdqtPartOrgIdElemId, 'codeid' : sHdqtTeamOrgIdVal, 'header' : '-선택-' }
            ], function(params) {
                _debug("<본사팀변경됨> <본사파트 목록 조회 완료. 입력파라미터>\n\n" + JSON.stringify(params));//alert( JSON.stringify(params) );
                $("#" + sHdqtPartOrgIdElemId + "").val("");
            });
        }
    }
    </script>

</head>

<body>

<jsp:include page="/view/layouts/default_header.jsp" flush="false" />

<div id="contents">

    <!-- sub title area -->
    <div id="lay_out">
        <div id="ub_txt6">
            <span class="txt6_img"><b id="sub-title">조직 select 예제 3</b>
                <span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif">
                <span class="a2">공통</span> <span class="a3"> > </span> <span class="a4"><b>예제</b></span> 
            </span>
        </div>
    </div>

    <!-- find condition area -->
    <div id="searchDiv" class="textAR">
        <form id="aform" onsubmit="return false;">
            <table id="searchTable" class="board02" style="width:92%;">
            <tr>
                <th height="40" style="width:100px;" scope="col">본사팀</th>
                <td class="tleft"><!-- data-bind="option: {value: datakey, option2: datakey2}"  -->
                    <select id="HDQT_TEAM_ORG_ID" name="HDQT_TEAM_ORG_ID" data-bind="options:options_HDQT_TEAM_ORG_ID, selectedOptions:HDQT_TEAM_ORG_ID"  data-type="select" data-wrap="false">
                        <option value="">-선택-</option>
                    </select>
                </td>
                <th style="width:100px;">본사파트</th>
                <td class="tleft">
                    <select id="HDQT_PART_ORG_ID" name="HDQT_PART_ORG_ID" data-bind="options:options_HDQT_PART_ORG_ID, selectedOptions: HDQT_PART_ORG_ID" data-type="select" data-wrap="false">
                        <option value="">-선택-</option>
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
            <button id="btnNew" data-type="button" data-theme="af-btn3" data-altname="엑셀"></button>
        </p>
    </div>

    <div id="detailDiv" class="textAR">
        <form id="bform" onsubmit="return false;">
            <table id="detailTable" class="board02" style="width:92%;">
            <tr>
                <th height="40" style="width:100px;" scope="col">본사팀</th>
                <td class="tleft"><!-- data-bind="option: {value: datakey, option2: datakey2}"  -->
                    <select id="HDQT_TEAM_ORG_ID2" name="HDQT_TEAM_ORG_ID" data-bind="options:options_HDQT_TEAM_ORG_ID2, selectedOptions:HDQT_TEAM_ORG_ID2"  data-type="select" data-wrap="false">
                        <option value="">-선택1-</option>
                    </select>
                </td>
                <th style="width:100px;">본사파트</th>
                <td class="tleft">
                    <select id="HDQT_PART_ORG_ID2" name="HDQT_PART_ORG_ID" data-bind="options:options_HDQT_PART_ORG_ID2, selectedOptions: HDQT_PART_ORG_ID2" data-type="select" data-wrap="false">
                        <option value="">-선택-</option>
                    </select>
                </td>
            </tr>
            </table>
        </form>
            <div class="ab_pos4">
                <button id="btnSearch" data-type="button" data-theme="af-psnm"></button><!-- 조회버튼 -->
            </div>
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
