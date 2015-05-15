<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

    <jsp:include page="/view/layouts/default_head.jsp" flush="false" />

    <script type="text/javascript">
    var _param;
    
    $.alopex.page({

        init : function(id, param) { 
            $.PSNM.initialize(id, param); //PSNM공통 초기화함수 호출
            
            _param = param;
            
            $a.page.setEventListener();
            $a.page.setGrid();
            $a.page.setCodeData();
			$a.page.searchList(param);
        },
        setEventListener : function() {
            $("#btnSearch").click($a.page.searchList);
            $("#btnSave").click(function(){
            	
            	$("#grid").alopexGrid("endEdit");
				
				var grid = $("#grid").alopexGrid('dataGet', {_state:{edited:true}});
            	if(grid.length == 0){
            		$.PSNM.alert("E011", ["변경된"]);
					return;
            	}
            	
            	if( $.PSNM.confirm("I004", ["저장"] ) ){
            		var requestData = $.PSNMUtils.getRequestData("grid");
                	
                	$.alopex.request("com.BASEVAL@PWEBBASVAL001_pSaveWebBasVal", {
                        data: requestData,
                        success: function(res) { 
                        	$a.page.searchList(_param);
                        }
                    });
            	}
            });
            $("#btnDel").click(function(){
            	var oRecord = $("#grid").alopexGrid( "dataGet" , { _state : { selected : true } } );
        		if (oRecord.length == 0) {
        			$.PSNM.alert("E021", ["삭제할 행을"]);
                    return;
                }
        		
        		$("#grid").alopexGrid( "dataEdit", {"FLAG":"D"}, { _state: { selected : true } } );
            	
            	if( $.PSNM.confirm("I004", ["삭제"] ) ){
            		var requestData = $.PSNMUtils.getRequestData("grid");
            		
                	$.alopex.request("com.BASEVAL@PWEBBASVAL001_pDeleteWebBasVal", {
                		data: requestData,
                        success : function(res) {
                        	$a.page.searchList(_param);
                        }
                    });
            	}
            });
            $("#btnPopImg").click(function(){
            	var param = $("#searchTable").getData({selectOptions:true});
				
				$a.popup({
					url: "com/baseval/basValImgPopup",
                   	data: param,
                   	title : "팝업이미지관리",
                   	width: 600,
                   	height: 600
				});
            });
        },
        setGrid : function() {
            $("#grid").alopexGrid({
                pager: false,
                rowClickSelect : false,
                rowInlineEdit : true,
                columnMapping : [
					{ columnIndex : 0, key : "FLAG", 				hidden : true  
						, value : function(value, data) {
                            if ( "I" == value || "D" == value ) { return value; } //추가|삭제는 그냥둠
                            return ( (data._state.edited) ? 'U' : '' ); 
                        }	
					},
                    { columnIndex : 1, key : "DSM_WEB_STRD_TYP_CD",	title : "대분류",	align : "left", 	width : "100px"	},
                    { columnIndex : 2, key : "DSM_WEB_STRD_NM_VAL",	title : "업무유형",	align : "left", 	width : "300px"	},
                    { columnIndex : 3, key : "STRD_APLY_VAL",		title : "적용값",	align : "center", 	width : "200px", editable : { type : "text" }}
                ]
            });
        },
        setCodeData : function() {
            $.PSNMUtils.setCodeData([
				{ t:'code', 'elemid' : 'MGMT_TYP_CD', 			'codeid' : 'DSM_WEB_STRD_TYP_CD', 'header' : '-전체-' },
				{ t:'code', 'elemid' : 'DSM_WEB_STRD_CD_VAL', 	'codeid' : 'DSM_WEB_STRD_CD_VAL', 'header' : '-전체-' }
            ]);
        },
        searchList: function(param) {
            $.alopex.request("com.BASEVAL@PWEBBASVAL001_pSearchWebBasVal", {
                data: "#searchTable",
                success: "#grid"
            });
        }
    });

    </script>

</head>

<body>

<jsp:include page="/view/layouts/default_header.jsp" flush="false" />

<div id="contents">

    <!-- sub title area -->
    <div class="content_title">
        <div id="ub_txt6">
            <span class="txt6_img"><b id="sub-title">기본값관리</b>
                <span class="notice-more"> 
                	<img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif">
                	<span class="a2">본사업무</span> <span class="a3"> > </span> <span class="a4"><b>공통관리</b></span> 
                </span>
            </span>
        </div>
    </div>

    <!-- find condition area -->
    <div id="searchDiv" class="textAR">
		<form id="searchForm" onsubmit="return false;">
        	<table id="searchTable" class="board02" style="width:92%;">
        	<colgroup>
	            <col style="width:15%"/>
	            <col style="width:20%"/>
	            <col style="width:15%"/>
	            <col style="width:*"/>
            </colgroup>
        	<tbody>
        	<tr>
                <th>분류</th>
				<td class="tleft">
                    <select id="MGMT_TYP_CD" data-bind="options: options_MGMT_TYP_CD, selectedOptions: MGMT_TYP_CD" data-type="select" ></select>
                </td>
				<th>업무유형</th>
				<td class="tleft">
                    <select id="DSM_WEB_STRD_CD_VAL" data-bind="options: options_DSM_WEB_STRD_CD_VAL, selectedOptions: DSM_WEB_STRD_CD_VAL" data-type="select" ></select>
                </td>
            </tr>
        	</tbody>
            </table>
        </form>
		<div class="ab_pos5">
			<button id="btnSearch" type="button" data-type="button" data-theme="af-psnm" data-authtype="R"></button>
		</div>
    </div>

    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>기본값관리</b>
        <p class="ab_pos2">
            <button id="btnPopImg" type="button" data-type="button" data-theme="af-btn40" data-altname="팝업이미지관리"></button>
            <button id="btnSave" type="button" data-type="button" data-theme="af-btn4" data-altname="저장" data-authtype="W"></button>
            <!-- 
            <button id="btnDel"  type="button" data-type="button" data-theme="af-btn13" data-altname="삭제"></button>
             -->
        </p>
    </div>

    <!-- main grid -->
    <div id="grid" data-bind="grid:grid"></div>

</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>