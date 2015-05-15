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
            $("#btnFindAgent").click( popFindAgent );
            $("#aSalePlcyStcPop").click( popSalePlcyStc );
            $("#btnMsg").click( msgTest );
            $("#btnFindUserPop").click( popFindUser );
        },
        setGrid : function() {
            //엑셀 템플릿 그리드 초기화
            var _excel_grid = {
                pager : false,
                columnMapping : [
                    { columnIndex : 0, key : "RN",            title : "번호",       align : "center", width : "40px"  },
                    { columnIndex : 1, key : "ANNCE_ID",      title : "공지사항ID", align : "center", width : "80px"  },
                    { columnIndex : 2, key : "RCV_TYP_NM",    title : "공지대상",   align : "center", width : "80px"  },
                    { columnIndex : 3, key : "ANNCE_TITL_NM", title : "제목",       align : "left",   width : "350px" },
                    { columnIndex : 4, key : "VIEW_CNT",      title : "조회수",     align : "right",  width : "50px"  },
                    { columnIndex : 5, key : "BLTN_DT",       title : "게시일",     align : "center", width : "100px" }
                ]
            }
            ;
            $("#gridexceltemplate").alopexGrid(_excel_grid);
            $("#gridexcelimported").alopexGrid(_excel_grid);
        }, //end-of-setGrid
        setCodeData : function() {
            //$.PSNMUtils.setCodeData([
            //    { t:'code',  'elemid' : 'RCV_TYP_CD', 'header' : '-전체-' } //전체, 선택 등이 넣으려면 설정
            //   ,{ t:'org1',  'elemid' : 'HDQT_TEAM_ORG_ID', 'header' : '-전체-' } //[본사팀] 목록 조회
            //]);
        }
    });//end-of-$.alopex.page //-------------------------------------------------------------------------------------------------------//

    function popFindAgent() {
        console.log("<popFindAgent> 현재 alopex세션값 : \n###### " + JSON.stringify( $a.session("alopex_parameters") ));

        var oParam = new Object();
            oParam = $('#aform').getData({selectOptions:true}); //본사팀, 본사파트, 영업국, 영업팀 조건을 넘겨주기 위함.
        console.log("<popFindAgent> 팝업으로 전달하려는 값 : \n###### " + JSON.stringify(oParam));
        console.log("<popFindAgent> alopex_parameters : " + $a.session('alopex_parameters')); //alert("세션값 = [" + $a.session('alopex_parameters') + "]");
        $a.session('alopex_parameters', '{}'); //alert("세션값 = [" + $a.session('alopex_parameters') + "]");

        $.PSNMAction.popFindAgent(oParam, function(oResult) {
            alert("<popFindAgent> 콜백에 반환된값\n\n" + JSON.stringify(oResult));
            if ( null!=oResult && typeof oResult == "object" ) {
                $("#AGNT_NM").val( oResult["USER_NM"] );
                $("#AGNT_ID").val( oResult["USER_ID"] );
            }
        });
    }

	function popSalePlcyStc() {
        console.log("<popSalePlcyStc> 현재 alopex세션값 : \n###### " + JSON.stringify( $a.session("alopex_parameters") ));

        var oParam = new Object();
            oParam = $('#aform').getData({selectOptions:false});
		var oOption = {
    	    url: "biz/saleplcy/salePlcyStcList"
    	    ,data: oParam
    	    ,width: 1000
    	    ,height: 500
			//,callback: popCallback
    	};

		oOption["title"]       = $("#pop_title").val();
		oOption["windowpopup"] = eval( $("#pop_windowpopup").val() ); //eval 을 안하면 값이 안먹힘????
		oOption["iframe"]      = eval( $("#pop_iframe").val() );
		console.log("<$a.popup options>\n\n" + JSON.stringify(oOption));
		alert("<$a.popup options>\n\n" + JSON.stringify(oOption));
        $a.popup(oOption);
    }
	function popCallback(arg1) {
		alert("<popCallback> arg1\n\n" + JSON.stringify(arg1));
	}
    
    function popFindUser() {
        var oParam = new Object();
        //TODO
        var oOption = {
            url: "com/popup/findUserPop"
           ,data: oParam
           ,width: 1000
           ,height: 600
           ,title:"회원찾기"
           ,callback: popFindUserCallback
        };
        $a.popup(oOption);
    }
    function popFindUserCallback(data) {
        alert("popFindUserCallback\n\n" + JSON.stringify(data));
    }

    function dialogSalePlcyStc() {
        var oParam = new Object();
            oParam = $('#aform').getData({selectOptions:false});
        $a.popup({
            url: "biz/saleplcy/salePlcyStcList",
            data: oParam,
            width: 1000,
            height: 500
        });
    }

    function msgTest() {
        var mid = $("#MID").val();
        var aMsgParam = [];
            aMsgParam.push( $("#ARG0").val() );
            aMsgParam.push( $("#ARG1").val() );
            aMsgParam.push( $("#ARG2").val() );
            aMsgParam.push( $("#ARG3").val() );
            aMsgParam.push( $("#ARG4").val() );
        var r = $.PSNM.alert(mid, aMsgParam, false);
        return r;
    }
    
    </script>

</head>

<body>

<jsp:include page="/view/layouts/default_header.jsp" flush="false" />

<div id="contents">

    <!-- sub title area -->
    <div id="lay_out">
        <div id="ub_txt6">
            <span class="txt6_img"><b id="sub-title">팝업 예제</b>
                <span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif">
                <span class="a2">공통</span> <span class="a3"> > </span> <span class="a4"><b>팝업 예제</b></span> 
            </span>
        </div>
    </div>

	<div class="textAR">
	  <form id="aform" onsubmit="return false;">
		<table class="board02" width="100%" >
		<tr>
			<th scope="col" class="fontred">에이전트</th>
			<td class="tleft">
				<input id="AGNT_NM"  data-type="textinput" data-bind="value:AGENT_NM" style="width:50px">
				<a id="btnFindAgent"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/btn_c9.gif" /></a>
				<input id="AGNT_ID"  data-type="textinput" data-bind="value:AGENT_CD" style="width:80px" data-theme="af-textinput" data-disabled=true>
			</td>
		</tr>
		<tr>
			<th scope="col">팝업1</th>
			<td class="tleft">
				<a id="aSalePlcyStcPop"><img src="${pageContext.request.contextPath}/image/blat_a12.gif" width="44" height="24"></a> 통계팝업하기 (윈도우팝업)
				<br/>
			</td>
		</tr>
		<tr>
			<th scope="col">팝업1 옵션 수정</th>
			<td class="tleft">
				title=<input id="pop_title" value="팝업 제목입니다. ㅎㅎㅎ" data-type="textinput" style="width:200px">
				/
				windowpopup=<select name="pop_windowpopup" id="pop_windowpopup" style="width:50px" data-type="select" data-wrap="false">
					<option value="true" selected="selected">true</option>
					<option value="false">false</option>
				</select>
				/
				iframe=<select name="pop_iframe" id="pop_iframe" style="width:50px" data-type="select" data-wrap="false">
					<option value="true">true</option>
					<option value="false" selected="selected">false</option>
				</select>
			</td>
		</tr>
		<tr>
			<th class="fontred" scope="col">다이얼로그</th>
			<td class="tleft">
				<!-- <a id="aSalePlcyStcDialog"><img src="${pageContext.request.contextPath}/image/blat_a12.gif" width="44" height="24"></a> 통계팝업하기 (DIV팝업) -->
				DIV팝업 즉 $a.dialog 는 사용하지 않음. $a.popup 에서 옵션 windowpopup=false, iframe=true 사용함.
			</td>
		</tr>
		<tr>
			<th class="fontred" scope="col">영업팀명</th>
			<td class="tleft"><select name="RCV_TYP_CD4" id="RCV_TYP_CD4" style="width:185px!important" data-type="select" data-wrap="false">
				<option value="">-전체-</option>
				<option value="01">전에이전트</option>
				<option value="02">관리자</option>
				<option value="03">국장</option>
			  </select>
			</td>
		</tr>
		<tr>
			<th scope="col">에이전트명</th>
			<td class="tleft">
			</td>
		</tr>
		<tr>
			<th class="fontred" scope="col">회원찾기</th>
			<td class="tleft">
				<input id="textId1" data-type="textinput" data-theme="af-textinput" />
				<a href='#' id='btnFindUserPop'><img src="<c:out value='${pageContext.request.contextPath}'/>/image/btn_c9.gif"></a>
			</td>
		</tr>
		<tr>
			<td colspan="2" class="tleft">
                <hr />
            </td>
		</tr>
		<tr>
			<th class=""  scope="col">메시지</th>
			<td class="tleft">
                <input id="MID" data-type="textinput" style="width:80px" value="PSNM-TEST">
                :
                <input id="ARG0" data-type="textinput" style="width:80px" value="파라미터1">,
                <input id="ARG1" data-type="textinput" style="width:80px" value="파라미터2">,
                <input id="ARG2" data-type="textinput" style="width:80px" value="파라미터3">,
                <input id="ARG3" data-type="textinput" style="width:80px" value="파라미터4">
                <input id="ARG4" data-type="textinput" style="width:80px" value="파라미터5">

                <button id="btnMsg" type="button" data-type="button" data-theme="af-psnm"></button><!-- 조회버튼 -->
            </td>
		</tr>
		</table>
	  </form>

		<br>
		<span style="color:#ff3d3d;">빨간색 항목은 필수입력 : th class="fontred"</span><br>
		입력된 정보를 바탕으로 공지사항 전달 및 각종 프로모션이 진행되오니 선택 사항을 포함하여 가급적 모든 정보를 정확히 입력해 주시기 바랍니다.(미입력시 적용 제외됨)
		
		<!--
		<p class="floatL3">
		  <input type="button" value="" data-type="button" data-theme="af-btn8">
		  <input type="button" value="" data-type="button" data-theme="af-btn10">
		</p>
		-->
	</div>

</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>
