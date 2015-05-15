<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<jsp:include page="/view/layouts/default_head.jsp" flush="false" />
<!-- *.js 파일들가져옴.. -->
<script type="text/javascript">
    
    var _TX_SEARCH  = "com.PHRS@PPHRS001_pSearchPhrs";
    var _TX_SAVE    = "com.PHRS@PPHRS001_pSavePhrs";
   
    $.alopex.page({
        init : function(id, param) { 
            _debug("phrsList", "init()", JSON.stringify(param));

            $.PSNM.initialize(id, param); //PSNM공통 초기화함수 호출(서브 페이지에서는 필수 호출)

            $a.page.setEventListener();
            $a.page.setGrid();

            pSearchPhrs(); //조회
        }
        ,
        setEventListener : function() {
            $("#btnSave").click( savePhrs )
        }
        ,
        setGrid : function() {
            $("#gridphrs").alopexGrid({
            pager : false,
            rowSingleSelect: true,
            rowInlineEdit  : true, 
                columnMapping : [
                    { columnIndex : 0, key : "FLAG",        title : "F",        align : "center", width : "10px", refreshBy:true, 
                        value : function(value, data) {
                            return ( (data._state.edited) ? 'U' : '' ); 
                        }
                    },            
                    { columnIndex : 1, key : "NUM", title : "월", align : "center", width : "30px" 
                    },
                    { columnIndex : 2, key : "PHRS", title : "명언", align : "left", width : "250px" 
                        ,editable : { type : "text" }
                    },
                    { columnIndex : 3, key : "ATHR", title : "인물/출처", align : "left", width : "80px" 
                        ,editable : { type : "text" }
                    },
                    { columnIndex : 4, key : "UPDR_ID", title : "처리자ID", align : "center", width : "40px"
                    },
                    { columnIndex : 5, key : "UPD_DTM", title : "처리일", align : "center", width : "70px" }
                ],
                on : {
                'cell' : {

                    "dblclick" : function(data, eh, e) {
                        var rowIndex = data._index.row;
                        $("#gridphrs").alopexGrid("endEdit");
                        var selectedData = $("#gridphrs").alopexGrid("dataGet", data._index); //$("#gridphrs").alopexGrid("dataGet",{_state:{selected:true}});
                        _debug("gridphrs.cell.dblclick", "selectedData", JSON.stringify(selectedData) );
                        $("#gridphrs").alopexGrid("dataEdit", {_state:{editing:true}}, selectedData);
                        _debug("gridphrs.cell.dblclick", "rowIndex = " + rowIndex + "\n\n" + JSON.stringify(data) );
                        }
                    }
                }
            });
        }
    });//알로펙스 끝
    
    function pSearchPhrs() {
        $.alopex.request(_TX_SEARCH, {
            data: function() {
                //_debug("<pSearchMenu> <request.data> 파라미터 (this.data.dataSet.fields) : " + JSON.stringify(this.data.dataSet.fields));
            },
            success: ['#gridphrs', function(res) {
                _debug("<pSearchMenu> <request.success> 결과데이터 : " + JSON.stringify(res));
            }]
        });
    }function savePhrs(e) {
        _debug("saveMenu", e.target.id);
        $("#gridphrs").alopexGrid("endEdit");
        
        var updatedDataListRaw = $("#gridphrs").alopexGrid("dataGet", {_state:{edited:true}});
        var updatedDataList = AlopexGrid.trimData( updatedDataListRaw );
        var updatedDataCount = updatedDataList.length;
        if ( updatedDataCount<1 ) {
            var r = $.PSNM.alert("E011", ["변경된"], false); //alert("변경된 데이터가 없습니다."); return false;
            return r;
        }
        _debug("saveMenu", "갱신된 건수", updatedDataCount);

        for(var i=0; i<updatedDataCount; i++) {
            var menuData = updatedDataListRaw[i];
            _debug("saveMenu", "갱신된 메뉴레코드", JSON.stringify(menuData));
            var r = true;
            
            if ( $.PSNMUtils.isEmpty(menuData["PHRS"]) ) {
                r = $.PSNM.alert("E012", ["명언"], false); //메뉴ID 항목은 필수값입니다!
            }
            if ( menuData["PHRS"].length < 4 ) {
                r = $.PSNM.alert("E013", ["명언", "4"], false); //{0} 항목은 {1}자 이상 입력하세요!
            }
            if ( $.PSNMUtils.isEmpty(menuData["ATHR"]) ) {
                r = $.PSNM.alert("E012", ["인물/출처"], false);
            } if (!r) {
                var oThatRow = {_index:{data:menuData._index.row}};
                $("#gridphrs").alopexGrid("dataEdit", {_state:{selected:true}}, oThatRow); //해당 행 선택
                $("#gridphrs").alopexGrid("startEdit", oThatRow); //편집 시작
                return r;
            }

        }
        var updatedDataSet = $.PSNMUtils.getRequestDataUpdated("gridphrs"); //변경된 데이터만 파라미터로 전달

        $.alopex.request(_TX_SAVE, {
            data: updatedDataSet,
            success: function(res) {
                $.PSNM.alert("I000"); //정상적으로 처리되었습니다.
                pSearchPhrs();
            }
        });
    }

 </script>
</head>
<body>
    <jsp:include page="/view/layouts/default_header.jsp" flush="false" />
    <div id="contents">
    
	<div class="content_title">
    	<div class="ub_txt6">
        	<span class="txt6_img"><b id="sub-title">메뉴제목</b>
        	<span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif"> 
        	<span class="a2">대메뉴명</span> <span class="a3"> > </span> <span class="a4"><b>중메뉴명</b> </span></span></span>
       	</div>
    </div>
        <!-- 1줄 find condition area -->
        <div class="floatL4">
            <p class="ab_pos5">
                <button id="btnSave" type="button" data-type="button"
                    data-theme="af-btn4" data-authtype="W" data-altname="저장"></button>
            </p>
        </div>
    <!-- main grid -->
    <div id="gridphrs" data-bind="grid:gridphrs" data-ui="ds"></div>
</div>
    <jsp:include page="/view/layouts/default_footer.jsp" flush="false" />
</body>
</html>