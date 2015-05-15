<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>주소찾기 - PS&Marketing</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />


    <script type="text/javascript">
    $a.page({
        init : function(id, param) {
            $a.page.setEventListener();
            $a.page.setGrid();
        },
        setEventListener : function() {
            $("#btnSearch").click( pSearchAddr ); //조회
            $("#btnConfirm").click( closeConfirm );
            $("#btnCancel").click( closeWithout );
            $("#ADDR").keypress( function(){
            	if ( event.which == 13 ) {
            		pSearchAddr();
            	}
            });
        }, //end-of-setEventListener
        setGrid : function() {
            //그리드 초기화
            $("#gridAddress").alopexGrid({
            	rowSingleSelect : true,
                columnMapping : [
                    { columnIndex : 0, key : "POST_NUM", title : "우편번호",     align : "center",   width : "20px" },
                    { columnIndex : 1, key : "ADDR_1", title : "주소",   align : "left",   width : "80px" }
                ],
                paging: {
                    perPage : 10,
                    pagerCount : 5
                },
                on : {
                    pageSet : function(pageNoToGo) {
                    	var p = {};
	                        p.page = pageNoToGo;
	                        pSearchAddr(p)
                    },
	                cell : {
	                    "dblclick" : function(data, eh, e) {
	                        closeWith(data);
	                    }
	                }
                },
            });
        }, //end-of-setGrid
    });//end-of-$.alopex.page //-------------------------------------------------------------------------------------------------------//

    function pSearchAddr(param) {
    	if(!$.PSNM.isValid("searchForm")){
    		return false;
    	}
    	
    	var _page_no = 1;
        if ( $.PSNMUtils.isNotEmpty(param) && $.PSNMUtils.isNotEmpty(param.page) ) {
            _page_no = param.page;
        }
        var _per_page = $("#gridAddress").alopexGrid("pageInfo").perPage;
       
        $.alopex.request('com.USERINFO@PUSERSCRBREQ001_pSearchAddr', {
        	url : _NOSESSION_REQ_URL,
        	data: ['#searchForm', function() {
                this.data.dataSet.fields.page      = _page_no;
                this.data.dataSet.fields.page_size = _per_page;
        	}],
            success: ['#gridAddress', function(res) {
            }]
        });
    }

    //현재창을 닫고 객체를 반환
    function closeWith(oRecord) {
        $a.close( oRecord );
    }

    function closeWithout() {
        $a.close();
    }

    function closeConfirm() {
        var arrAgents = $("#gridAddress").alopexGrid( "dataGet" , { _state : { selected : true } } ); //선택된 데이터

        if (arrAgents.length<1) {
            alert("주소를 선택하십시오!");
            return;
        }
        closeWith(arrAgents[0]);
    }
    </script>
</head>

<body>

<div id="Wrap">

    <!-- title area -->
    <div class="pop_header">
    	<div id="searchDiv" class="textAR">
	        <form id="searchForm" onsubmit="return false;">
	            <table class="board02" style="width:82%;">
	            <tr>
	                <th scope="col" style="width:20%;" class="psnm-required">도로명</th>
	                <td class="tleft">
	                    <select id="SI_DO" data-type="select" data-bind="value:SI_DO" data-placeholder="선택" style="width:80px;"
	                    	data-validation-rule="{required:true}" 
							data-validation-message="{required:$.PSNM.msg('E012', ['지역'])}">
	                    	<option value="서울특별시">서울</option>
	                    	<option value="부산광역시">부산</option>
	                    	<option value="인천광역시">인천</option>
	                    	<option value="광주광역시">광주</option>
	                    	<option value="대구광역시">대구</option>
	                    	<option value="대전광역시">대전</option>
	                    	<option value="울산광역시">울산</option>
	                    	<option value="경기도">경기</option>
	                    	<option value="세종특별자치시">세종</option>
	                    	<option value="전라남도">전남</option>
	                    	<option value="전라북도">전북</option>
	                    	<option value="경상남도">경남</option>
	                    	<option value="경상북도">경북</option>
	                    	<option value="충청남도">충남</option>
	                    	<option value="충청북도">충북</option>
	                    	<option value="강원도">강원</option>
	                    	<option value="제주특별자치도">제주</option>
	                    </select>                    
	                    <input id="ADDR" name="ADDR"  type="text" data-type="textinput"  data-bind="value:ADDR" style="width:160px"
	                    	data-validation-rule="{required:true}" 
							data-validation-message="{required:$.PSNM.msg('E012', ['도로명'])}"/>
	                </td>
	            </tr>
	            </table>
	        </form>
            <div class="ab_pos5">
                <input id="btnSearch" type="button" value="" data-type="button" data-theme="af-psnm" data-authtype="R">
            </div>
        </div>
        <!--view_table area -->
        <div class="textAR">

            <div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>주소목록</b>
                <p class="ab_pos2">
                    <!-- <button id="btnInit"      data-type="button" data-theme="af-psnm0">초기화</button> -->
                </p>
            </div>

            <!-- main grid -->
            <div id="gridAddress" data-bind="grid:gridAddress" data-ui="ds"></div>

            <p class="floatL2">
                <input id="btnConfirm" type="button" value="" data-type="button" data-theme="af-btn8">
                <input id="btnCancel"  type="button" value="" data-type="button" data-theme="af-btn10">
            </p>
        </div>

    </div>

</div>

</body>
</html>