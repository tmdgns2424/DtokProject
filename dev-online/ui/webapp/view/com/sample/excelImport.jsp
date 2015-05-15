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
            console.log('<annceList> $.alopex.page.init (param) : ' + JSON.stringify(param));

            $.PSNM.initialize(id, param); //PSNM공통 초기화함수 호출(서브 페이지에서는 필수 호출)

            $a.page.setGrid();
            $a.page.setEventListener();
        },
        setEventListener : function() {
            $("#btnExcelTemplate").click( downloadTemplate ); //엑셀다운로드 버튼 처리 예

            //##### 엑셀 IMPORT 처리 예 ###### excelImportPostHandler 참조
            //
            // 엑셀 템플릿파일에 채워진 엑셀 데이터파일을 업로드하고
            // 지정된 그리드에 엑셀 데이터를 채우며, 업무에서 추가작업을 위해 콜백함수를 호출함
            // (참고) 템플릿grid, 데이터grid 가 화면에 있으며 2개의 grid 스키마는 동일함(보통은 화면에서 보이지 않도록 함)
            //
            //@param  sFileInputId       파일입력요소ID
            //@param  sExcelImportGridId 엑셀import 시 필요한 grid의 요소ID(화면에서는 style='dispaly:none;' 으로 숨김)
            //@param  callback           콜백함수 지정. 엑셀파일을 업로드 완료후 각 업무에서 추가 작업하기 위한 콜백. arg1에 grid 데이터를 반환
            $.PSNMUtils.setExcelUploadImport("#excelupload", "#gridexcelimported", excelImportPostHandler);

        }, //end-of-setEventListener
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

    //엑셀 템플릿 다운로드 예
    function downloadTemplate() {
        var aSampleData = [
            { "RN" : 1, "ANNCE_ID" : "1234567890", "RCV_TYP_NM" : "전에이전트", "ANNCE_TITL_NM" : "공지사항제목입니다.", "VIEW_CNT" : 1, "BLTN_DT":"2014-12-04" }
        ];
        var oExcepMetaInfo = null; //(예) { filename  : "공지사항목록.xls", sheetname : "공지사항목록" }
            oExcepMetaInfo = { filename  : "공지사항목록.xls", sheetname : "공지사항목록" };

        // 
        // 엑셀템플릿파일을 다운로드 함
        // (참고) 관련된 GRID를 생성하며, 이 템플릿그리드의 스키마와 엑셀IMPORT 그리드의 스키마 동일하게 유지함.
        // (참고) 템플릿GRID, IMPORT그리드 2개를 유지함(같은 스키마라고 하더라도 1개를 같이쓰지않고 따로 두도록 함)
        //
        //@param  sExcelTelmplateGridId 엑셀import 시 필요한 grid의 요소ID(화면에서는 style='dispaly:none;' 으로 숨김)
        //@param  aExcelSampleData      엑셀템플릿grid에 설정할 데이터(보통 1개 레코드의 배열형)
        //@param  oExcepMetaInfo        (optional) 다운로드 엑셀의 메타정보(다운로드파일명, 시트명)
        //@since  2014-12-05
        $.PSNMUtils.downloadExcelTemplate("#gridexceltemplate", aSampleData, oExcepMetaInfo);
    }

    //엑셀 IMPORT 처리 예
    function excelImportPostHandler(arrDataList) {
        alert("업로드된 엑셀 데이터정보(콜백에서 찍음)\n\n"+JSON.stringify(arrDataList));

        var s = "엑셀정보를 저장하시겠습니까?";
            s+= "\n\n(설명) 파라미터로 반환된 데이터 참조.\n #gridexcelimported 데이터와 동일함.";
        if ( confirm(s) ) {
            //TODO : ...
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
            <span class="txt6_img"><b id="sub-title">엑셀 업로드 예제</b>
                <span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif">
                <span class="a2">공통</span> <span class="a3"> > </span> <span class="a4"><b>엑셀 업로드 예제</b></span> 
            </span>
        </div>
    </div>

    <!-- find condition area -->
    <div id="searchDiv" class="textAR"> 
        <!-- 1줄 find condition area -->
        <form id="result_area2" onsubmit="return false;">
            <table id="searchForm" class="board02" style="width:92%;">
            <tr>
                <th scope="col">공지대상</th>
                <td class="tleft">
                    <select id="RCV_TYP_CD" data-bind="options: options_RCV_TYP_CD, selectedOptions: RCV_TYP_CD" data-type="select" data-wrap="true" style=""><!-- data-placeholder="-전체-" -->
                        <option value="">-전체-</option>
                    </select>
                </td>
                <th >본사팀</th>
                <td class="tleft">
                    <select id="HDQT_TEAM_ORG_ID" data-bind="options:options_HDQT_TEAM_ORG_ID, selectedOptions:HDQT_TEAM_ORG_ID"  data-type="select" data-wrap="true">
                        <option value="">-전체-</option>
                    </select>
                </td>
                <th >권한그룹</th>
                <td class="tleft">
                    <select id="AUTH_GRP_ID" data-bind="selectedOptions: AUTH_GRP_ID" data-type="select" data-wrap="true" data-codeid="AUTH_GRP_ID" style="">
                        <option value="">-전체-</option>
                        <option value="01">(01) 관리자</option>
                        <option value="02">(02) 부문</option>
                        <option value="03">(03) 영업관리</option>
                    </select>
                </td>
            </tr>
            </table>
            <div class="ab_pos5"><!-- 1줄 class="ab_pos5"-->
                <button id="btnSearch" data-type="button" data-theme="af-psnm" style="padding-left:5px"></button><!-- 조회버튼 -->
            </div>
        </form>
    </div>

    <div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>각 업무 그리드 영역</b>
        <p class="ab_pos2">
            있다고 치고...
        </p>
    </div>

    <!-- main grid -->
    <div id="grid" data-bind="grid:grid" data-ui="ds"></div>


    <div class="floatL4">
        <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>엑셀 템플릿 그리드(다운로드용) :: 예제 화면이므로 표시함. 각 화면에서는 display:none으로 GRID를 숨김</b>
        <p class="ab_pos2">
            <button id="btnExcelTemplate" data-type="button" data-theme="af-psnm0">템플릿</button>
            <button id="btnExcelUpload"   data-type="button" data-theme="af-btn47" data-altname="엑셀업로드"></button>
            <div class="ab_pos1">
                <div style="width:111px; height: 33px; background:url('/web/image/btn_c47.gif') no-repeat; border:0px;">
                     <input id="excelupload" type="file" name="files[]" multiple style="width:111px; height:33px; filter:alpha(opacity=0); opacity: 0; cursor: pointer;" /> 
                </div>
            </div>
        </p>
    </div>
    <div id="gridexceltemplate" data-bind="grid:gridexceltemplate" data-ui="ds" style="display: ;"></div>
    
    <hr style="margin:10;"/>

    <div class="floatL4">
        <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>엑셀 IMPORT 그리드(업로드 IMPORT용) :: 예제 화면이므로 표시함. 각 화면에서는 GRID 숨김</b>
    </div>
    <div id="gridexcelimported" data-bind="grid:gridexcelimported" data-ui="ds" style="display: ;"></div>

    <hr style="margin:10;"/>
    
    <div class="floatL4">
         <b>(주의) setGrid() 후 $.PSNMUtils.setExcelUploadImport() </b>
    </div>


    <!-- <div id="gridexcelfile"     data-bind="grid:gridexcelfile"     data-ui="ds" class="view_list"></div> -->

</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>
