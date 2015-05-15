<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
    String _ROOT = "";
    //System.out.println("############## excelImport");
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

    <jsp:include page="/view/layouts/default_head.jsp" flush="false" />

    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/vendor/jquery.ui.widget.js"></script>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/jquery.iframe-transport.js"></script>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/jquery.fileupload.js"></script>


    <script type="text/javascript">
    $.alopex.page({

        init : function(id, param) { 
            console.log('<popAndDialog> $.alopex.page.init (param) : ' + JSON.stringify(param));

            $.PSNM.initialize(id, param); //PSNM공통 초기화함수 호출(서브 페이지에서는 필수 호출)

            //$a.page.setGrid();
            $a.page.setEventListener();
        },
        setEventListener : function() {
            $("#btnMerge").click( mergeTest );
            $("#btnMerge2").click( mergeTest2 );
            $("#btnMerge3").click( mergeTest3 );
            $("#btnRep").click( replaceTags );
        }
    });

    function mergeTest() {
        var oData1 = JSON.parse( $("#MID1").val() );
        //var oData1 = {"KEY1":"val1","KEY2":"val2","KEY3":"val3"};
        alert( JSON.stringify(oData1) );

        var oData2 = JSON.parse( $("#MID2").val() );
        var oData3 = JSON.parse( $("#MID3").val() );

        var oMerged = $.PSNMUtils.mergeFormData(oData1, oData2);
            oMerged = $.PSNMUtils.mergeFormData(oMerged, oData3);
        
        alert( JSON.stringify(oMerged) );
    }
    function mergeTest2() {
        var oMerged = $.PSNMUtils.getRequestData2("aform", "bform");

        alert( JSON.stringify(oMerged) );
    }
    function mergeTest3() {
        var oMerged = $.PSNMUtils.getFormData2("cform");

        alert("$.PSNMUtils.getFormData2\n\n" + JSON.stringify(oMerged) );
    }

    function replaceTags() {
        var val = $("#TESTTEXT").val();
        var val2 = val.replace(/(<([^>]+)>)/ig,""); 

        alert("TESTTEXT = [" + JSON.stringify(val) + "]\n\nHTML제거 = [" + JSON.stringify(val2) + "]");
    }

    </script>

</head>

<body>

<jsp:include page="/view/layouts/default_header.jsp" flush="false" />

<div id="contents">

    <!-- sub title area -->
    <div id="lay_out">
        <div id="ub_txt6">
            <span class="txt6_img"><b id="sub-title">$.PSNMUtils.getRequestData2("aform", "bform", ...) 예제</b>
                <span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif">
                <span class="a2">공통</span> <span class="a3"> > </span> <span class="a4"><b>팝업 예제</b></span> 
            </span>
        </div>
    </div>

    <div class="textAR">
      <form id="aform" onsubmit="return false;">
        <table class="board02" width="100%" >
        <tr>
            <th class=""  scope="col">폼데이터1(MID1)</th>
            <td class="tleft">
                <input id="MID1" name="MID1" data-type="textinput" style="width:60%" value='{"KEY1":"val1","KEY2":"val2","KEY3":"val3"}'>
            </td>
        </tr>
        <tr>
            <th class=""  scope="col">폼데이터2(MID2)</th>
            <td class="tleft">
                <input id="MID2" name="MID2" data-type="textinput" style="width:60%" value='{"KEY2":"val22","KEY3":"val33"}'>
            </td>
        </tr>
        <tr>
            <th class=""  scope="col">폼데이터3(MID3)</th>
            <td class="tleft">
                <input id="MID3" name="MID3" data-type="textinput" style="width:60%" value='{"KEY3":"값333","KEY4":"값4"}'>
            </td>
        </tr>
        <tr>
            <th class=""  scope="col">설명</th>
            <td class="tleft">
                <button id="btnMerge" type="button" data-type="button" data-theme="af-psnm"></button><!-- 조회버튼 --><br />
                위 폼데이터1~3의 문자열을 객체(Object)로 변환하여 merge 하여 출력<br />
                공통함수 $.PSNMUtils.mergeFormData(oData1, oData2) 사용<br />
            </td>
        </tr>
        </table>
      </form>

        <br>
        <br>
      <form id="bform" onsubmit="return false;">
        <table class="board02" width="100%" >
        <tr>
            <th class=""  scope="col">폼데이터1(MID1)</th>
            <td class="tleft">
                <input id="MID1b" name="MID1" data-type="textinput" style="width:60%" value='111111111111'>
            </td>
        </tr>
        <tr>
            <th class=""  scope="col">폼데이터2(MID2)</th>
            <td class="tleft">
                <input id="MID2b" name="MID2" data-type="textinput" style="width:60%" value='222222222222'>
            </td>
        </tr>
        <tr>
            <th class=""  scope="col">폼데이터5(MID5)</th>
            <td class="tleft">
                <input id="MID5b" name="MID5" data-type="textinput" style="width:60%" value='55555555555'>
            </td>
        </tr>
        <tr>
            <th class=""  scope="col">설명</th>
            <td class="tleft">
                <button id="btnMerge2" type="button" data-type="button" data-theme="af-psnm"></button><!-- 조회버튼 --><br />
                위 폼a와 폼b의 데이터를 merge하여 dataSet으로 변환하여 반환.<br />
                같은 이름(name)으로 폼a와 폼b의 데이터가 모두 존재하면 콤마(,)로 문자열을 연결하여 값을 구성<br />
                직관적인 테스트를 위해 위 폼a의 각 데이터를 111111, 22222, 33333 으로 변경하여 이 버튼을 클릭해봄<br />
                공통함수 $.PSNMUtils.getRequestData2("aform", "bform") 사용<br />
            </td>
        </tr>
        </table>
      </form>


        <br>
        <br>
      <form id="cform" onsubmit="return false;">
        <table class="board02" width="100%" >
        <tr>
            <th class=""  scope="col">폼데이터1(MID1)</th>
            <td class="tleft">
                <input id="MID1c" name="MID1" data-type="textinput" style="width:60%" value='111111111111'> name="MID1"
            </td>
        </tr>
        <tr>
            <th class=""  scope="col">폼데이터2(MID2)</th>
            <td class="tleft">
                <input id="MID2c" name="MID1" data-type="textinput" style="width:60%" value='222222222222'>
            </td>
        </tr>
        <tr>
            <th class=""  scope="col">폼데이터5(MID5)</th>
            <td class="tleft">
                <input id="MID5c" name="MID1" data-type="textinput" style="width:60%" value='55555555555'>
            </td>
        </tr>
        <tr>
            <th class=""  scope="col">설명</th>
            <td class="tleft">
                <button id="btnMerge3" type="button" data-type="button" data-theme="af-psnm"></button><!-- 조회버튼 --><br />
                위 폼c의 데이트는 name=MID1로 모두를 동일함.<br />
                폼데이터 수집시( $.PSNMUtils.getFormData ) 같은 이름(name)으로 데이터가 모두 존재하면 콤마(,)로 문자열을 연결하여 값을 구성<br />
                공통함수 $.PSNMUtils.getFormData("cform") 테스트<br />
            </td>
        </tr>
        </table>
      </form>


        <br>
        <br>
      <form id="dform" onsubmit="return false;">
        <table class="board02" width="100%" >
        <tr>
            <th class=""  scope="col">폼데이터4(TESTTEXT)</th>
            <td class="tleft">
                <input id="TESTTEXT" name="TESTTEXT" data-type="textinput" style="width:60%" value=''> 
            </td>
        </tr>
        <tr>
            <th class=""  scope="col">설명</th>
            <td class="tleft">
                <button id="btnRep" type="button" data-type="button" data-theme="af-psnm"></button><!-- 조회버튼 --><br />
            </td>
        </tr>
        </table>
      </form>
    </div>

</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>
