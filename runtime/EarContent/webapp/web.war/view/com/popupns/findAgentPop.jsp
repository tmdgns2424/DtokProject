<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>에이전트 찾기 - PS&Marketing</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />


    <script type="text/javascript">
    var _initParam = null;
    var _txid = null;

    $.alopex.page({
        init : function(id, param) { //{"HDQT_TEAM_ORG_ID":"C21100","HDQT_PART_ORG_ID":"","SALE_DEPT_ORG_ID":"","SALE_TEAM_ORG_ID":"","AGNT_NM":"ab"} 
            _initParam = param;
            console.log('<findAgentPopup> $.alopex.page.init (param) : ' + JSON.stringify(param));

            $a.page.setEventListener();
            $a.page.setGrid();

            if( $.PSNMUtils.isNotEmpty(param.ISLOGIN) && "false"==param.ISLOGIN ){
            	_txid = "com.CODE@PBASE_pSearchAgentNoMember";
            }else{
            	_txid = "com.CODE@PBASE_pSearchAgent";
            }
            pSearchAgent(); //조회
        },
        setEventListener : function() {
            $("#btnConfirm").click( closeConfirm );
            $("#btnCancel").click( closeWithout );
            $("#iconCancel").click( closeWithout );

        }, //end-of-setEventListener
        setGrid : function() {
            //그리드 초기화
            $("#gridagent").alopexGrid({
                pager: false,
                height: 430,
                columnMapping : [
                    { columnIndex : 0, key : "RN",               title : "번호",       align : "center", width : "40px" }, //{ columnIndex : 0, selectorColumn : true, width : "20px" },
                    { columnIndex : 1, key : "HDQT_TEAM_ORG_NM", title : "본사팀",     align : "left",   width : "80px" },
                    { columnIndex : 2, key : "HDQT_PART_ORG_NM", title : "본사파트",   align : "left",   width : "80px" },
                    { columnIndex : 3, key : "SALE_DEPT_ORG_NM", title : "영업국",     align : "left",   width : "80px" },
                    { columnIndex : 4, key : "SALE_TEAM_ORG_NM", title : "영업팀",     align : "left",   width : "80px" },
                    { columnIndex : 5, key : "AGNT_NM",          title : "에이전트명", align : "center", width : "50px" },
                    { columnIndex : 6, key : "HDQT_TEAM_ORG_ID", title : "HDQT_TEAM_ORG_ID", align : "left",   hidden:true },
                    { columnIndex : 7, key : "HDQT_PART_ORG_ID", title : "HDQT_PART_ORG_ID", align : "left",   hidden:true },
                    { columnIndex : 8, key : "SALE_DEPT_ORG_ID", title : "SALE_DEPT_ORG_ID", align : "left",   hidden:true },
                    { columnIndex : 9, key : "SALE_TEAM_ORG_ID", title : "SALE_TEAM_ORG_ID", align : "left",   hidden:true },
                    { columnIndex :10, key : "AGNT_ID",          title : "AGNT_ID",          align : "left",   hidden:true },
                    { columnIndex :11, key : "DUTY_CD",          title : "DUTY_CD",          align : "left",   hidden:true },
                    { columnIndex :12, key : "USER_ID",          title : "USER_ID",          align : "left",   hidden:true }
                ]
               //,on : { } //NO페이징
            });
            $("#gridagent").alopexGrid('updateOption', {
                on : {
                    'cell' : {
                        "dblclick" : function(data, eh, e) {
                            console.log("<gridagent.updateOption> 더블클릭된 데이터 : " + $.PSNMUtils.toString(data));
                            closeWith(data);
                        }
                    }
                }
            });
        }, //end-of-setGrid
        setCodeData : function() {
            //
        }
    });//end-of-$.alopex.page //-------------------------------------------------------------------------------------------------------//

    //조회 처리 : param은 페이지 이동시에만 값이 전달됨
    function pSearchAgent(param) {
        $.alopex.request(_txid, {
            url: _NOSESSION_REQ_URL,
            data: function() {
                var p = $.extend({}, this.data.dataSet.fields, _initParam);
                this.data.dataSet.fields = $.PSNMUtils.removeParamArrays(p); //세션에 options_ 배열이 있는 경우 제거함(@since 2014-12-03)
                console.log("<pSearchAgent> <request.data> 파라미터 (this.data.dataSet.fields) : " + JSON.stringify(this.data.dataSet.fields));
            },
            success: ['#gridagent', function(res) {
                //console.log("<pSearchAgent> <request.success> 결과데이터 : " + JSON.stringify(res));
            }]
        });
    } //end of pSearchAgent()

    //현재창을 닫고 객체를 반환
    function closeWith(oRecord) {
        $a.close( oRecord );
    }

    function closeWithout() {
        $a.close();
    }

    function closeConfirm() {
        var arrAgents = $("#gridagent").alopexGrid( "dataGet" , { _state : { selected : true } } ); //선택된 데이터

        if (arrAgents.length<1) {
            alert("에이전트를 선택하십시오!");
            return;
        }
        else if (arrAgents.length>1) {
            alert("1개의 에이전트를 선택하십시오!");
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
        <!--
        <span class="title">에이전트 찾기</span>
        <a id="iconCancel" href="#" class="pop_close"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a9.gif" alt="팝업닫기" ></a> 
        -->
      
        <!--view_table area -->
        <div class="textAR">

            <div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>에이전트 목록</b>
                <p class="ab_pos2">
                    <!-- <button id="btnInit"      data-type="button" data-theme="af-psnm0">초기화</button> -->
                </p>
            </div>

            <!-- main grid -->
            <div id="gridagent" data-bind="grid:gridagent" data-ui="ds"></div>

            <p class="floatL2">
                <input id="btnConfirm" type="button" value="" data-type="button" data-theme="af-btn8">
                <input id="btnCancel"  type="button" value="" data-type="button" data-theme="af-btn10">
            </p>
        </div>

    </div>

</div>

</body>
</html>