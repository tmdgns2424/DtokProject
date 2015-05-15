<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>회원 찾기 - PS&Marketing</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />

    <script type="text/javascript">
    var _initParam = null;
    var _exclude_user_list = null;

    $a.page({
        init : function(id, param) { //
            _initParam = param;
            _debug('<findDeptUserPop> $.alopex.page.init (param) : \n###### ' + JSON.stringify(param));

            var arrSaleDept = param["_pop_list_sale_dept"];
            _exclude_user_list = param["_pop_list_userid_applied"];

            $.PSNM.setOrgSelectBox(); //본사팀, 본사파트, 영업국 select 객체 초기화
            $a.page.setEventListener();
            $a.page.setGrid();
            $a.page.setValidators();

            if ( $.PSNMUtils.isNotEmpty(arrSaleDept) && jQuery.isArray(arrSaleDept) ) {
                var codeOptions = [];
                    codeOptions.push({ value: "", text: "-전체-"});

                for(var i=0, size=arrSaleDept.length; i<size; i++) {
                    var oOpt = new Object();
                        oOpt["value"] = arrSaleDept[i].SALE_DEPT_ORG_ID;
                        oOpt["text"]  = arrSaleDept[i].SALE_DEPT_ORG_NM;
                    codeOptions.push(oOpt);
                }
                $("#SALE_DEPT_ORG_ID").setData({ "options_SALE_DEPT_ORG_ID": codeOptions});
            }
            else {
                //$a.page.setCodeData(); //본사팀코드를 조회
            }

            $('#sform').setData(param);
            $("#SALE_DEPT_ORG_ID").focus();
            //pSearchDeptUser(); //조회
        },
        setEventListener : function() {
            $("#btnSearch").click( pSearchDeptUser ); //조회
            $("#btnSelectUser").click( selectUser );
            $("#btnDeselectUser").click( deselectUser );

            $("#btnConfirm").click( closeConfirm );
            $("#btnCancel").click( closeWithout );
            $("#iconCancel").click( closeWithout );
            $("#USER_ID_NM").keyup(function(e) {
                if (13==e.which) {
                    pSearchDeptUser(); //조회
                }
            });
        },
        setGrid : function() {
            var oDeptUserGridOption = {
                pager:false,
                height: 200,
                columnMapping : [
                    { columnIndex : 0, selectorColumn : true,    width : "30px" },
                    { columnIndex : 1, key : "SALE_DEPT_ORG_NM", title : "영업국",     align : "left",   width : "100px" },
                    { columnIndex : 2, key : "SALE_TEAM_ORG_NM", title : "영업팀",     align : "left",   width : "100px" },
                    { columnIndex : 3, key : "AGNT_NM",          title : "에이전트",   align : "center", width : "100px" },
                    { columnIndex : 4, key : "AGNT_ID",          title : "에이전트ID", align : "center", width : "90px" },
                    { columnIndex : 5, key : "USER_ID",          title : "회원ID",     align : "center", width : "90px" },
                    { columnIndex : 6, key : "USER_NM",          title : "회원명",     align : "center", width : "100px" },
                    { columnIndex : 7, key : "AUTH_GRP_NM",      title : "권한그룹명", align : "center", width : "100px" },
                    { columnIndex : 8, key : "DUTY_NM",          title : "직무",       align : "center", width : "150px" },
                    { columnIndex : 9, key : "DUTY_CD",          title : "직무코드",   hidden:true },
                    { columnIndex :10, key : "AUTH_GRP_ID",      title : "권한그룹ID", hidden:true }
                ]
                ,
                on : {
                    'cell' : {
                        "click" : function(data, eh, e) {
                            //
                        }
                    }
                }
            };

            $("#griduser").alopexGrid( oDeptUserGridOption );
            $("#gridusersel").alopexGrid( oDeptUserGridOption );

        },
        setCodeData : function() {
            $.PSNMUtils.setCodeData([
                { t:'org1',  'elemid' : 'HDQT_TEAM_ORG_ID', 'header' : '-전체-' } //[본사팀] 목록 조회
            ]);
        }
        ,
        setValidators : function() {
            $('#SALE_DEPT_ORG_ID').validator({
                rule : { required: true },
                message: {
                    required: $.PSNM.msg('E012', ["영업국"]) //{0} 항목은 필수값입니다!
                }
            });
        }
    });//end-of-$.alopex.page //-------------------------------------------------------------------------------------------------------//

    //조회 처리 : param은 페이지 이동시에만 값이 전달됨
    function pSearchDeptUser(param) {
        var _page_no = 1;
        if ( $.PSNMUtils.isNotEmpty(param) && $.PSNMUtils.isNotEmpty(param.page) ) {
            _page_no = param.page; //(설명) 페이지 이동할때만 페이지번호가 넘어옴.
        }
        var _per_page = $('#griduser').alopexGrid('pageInfo').perPage; // $("#grid .perPage").val();

        if ( !$.PSNM.isValid("sform") ) {
            return false;
        }

        $("#griduser").alopexGrid("dataEmpty");

        $.alopex.request('com.BLTNBRD@PBLTNBRDAUTHMGMT001_pSearchDeptUser', {
            data: ['#sform', function() {
                var p = this.data.dataSet.fields;
                this.data.dataSet.fields = $.PSNMUtils.removeParamArrays(p); //세션에 options_ 배열이 있는 경우 제거함(@since 2014-12-03)
                this.data.dataSet.fields.page      = _page_no;
                this.data.dataSet.fields.page_size = _per_page;

                var recordSetsData = {
                    "EXCLUDE_USER_LIST" : {
                        nc_list : _exclude_user_list
                    }
                };
                this.data.dataSet["recordSets"] = recordSetsData;
                _debug("<pSearchDeptUser> <request.data> 파라미터 (this.data.dataSet.fields) : " + JSON.stringify(this.data.dataSet.fields));
            }],
            success: ['#griduser', function(res) {
                //_debug("<pSearchDeptUser> <request.success> 결과데이터 : " + JSON.stringify(res));
            }]
        });
    } //end of pSearchDeptUser()

    //사용자 포함
    function selectUser() {
        var arrSelDept = $("#griduser").alopexGrid('dataGet', {_state:{selected:true}});
        if ( null==arrSelDept || arrSelDept.length<1 ) {
            $.PSNM.alert("E011", ["선택된"]);
            return false;
        }
        _debug("selectUser", JSON.stringify(arrSelDept) );
        var dataLen = $("#gridusersel").alopexGrid('dataGet').length;
        $("#griduser").alopexGrid("dataDelete", {_state:{selected:true}});
        $("#gridusersel").alopexGrid("dataAdd", arrSelDept, {_index:{data:dataLen}});
        $("#gridusersel").alopexGrid("dataScroll", dataLen); //스크롤
    }
    //사용자 제외
    function deselectUser(oData) {
        var arrSelDept = $("#gridusersel").alopexGrid('dataGet', {_state:{selected:true}});
        if ( null==arrSelDept || arrSelDept.length<1 ) {
            $.PSNM.alert("E011", ["선택된"]);
            return false;
        }
        _debug("deselectUser", JSON.stringify(arrSelDept) );
        var dataLen = $("#griduser").alopexGrid('dataGet').length;
        $("#gridusersel").alopexGrid("dataDelete", {_state:{selected:true}});
        $("#griduser").alopexGrid("dataAdd", arrSelDept, {_index:{data:dataLen}});
        $("#griduser").alopexGrid("dataScroll", dataLen); //스크롤
    }

    //현재창을 닫고 객체를 반환
    function closeWith(oData) {
        $a.close(oData);
    }

    function closeWithout() {
        $a.close([]);
    }

    function closeConfirm() {
        var arrAgents = $("#gridusersel").alopexGrid("dataGet"); // , { _state : { selected : true } } ); //선택된 데이터

        if (arrAgents.length<1) {
            alert("회원를 선택하십시오!");
            return;
        }
        closeWith( AlopexGrid.trimData(arrAgents) );
    }
    </script>
</head>

<body style="height: 100%;">

<div id="Wrap">

    <!-- title area -->
    <div class="pop_header">
        <div class="psnm-find-area" style="height:65px;">
            <div class="psnm-find-condarea">
                <form id="searchForm" onsubmit="return false;">
                <table class="board02" id="sform">
	        	<colgroup>
		            <col style="width:12%"/>
		            <col style="width:38%"/>
		            <col style="width:12%"/>
		            <col style="width:38%"/>
	            </colgroup>
                <tr>
                    <th scope="col" class="psnm-required">영업국</th>
                    <td class="tleft">
                        <select id="SALE_DEPT_ORG_ID" name="SALE_DEPT_ORG_ID" data-type="select" data-bind="options:options_SALE_DEPT_ORG_ID, selectedOptions:SALE_DEPT_ORG_ID" data-wrap="false" style="width:150px;">
                        </select>
                    </td>
                    <th>영업팀</th>
                    <td class="tleft">
                        <select id="SALE_TEAM_ORG_ID" name="SALE_TEAM_ORG_ID" data-type="select" data-bind="options:options_SALE_TEAM_ORG_ID, selectedOptions:SALE_TEAM_ORG_ID" data-wrap="false" style="width:150px;">
                        </select>
                    </td>
                </tr>
                <tr>
                    <th>에이전트</th>
                    <td class="tleft">
                        <select id="SALE_AGNT_ORG_ID" name="SALE_AGNT_ORG_ID" data-type="select" data-bind="options:options_SALE_AGNT_ORG_ID, selectedOptions:SALE_AGNT_ORG_ID" data-wrap="false" style="width:150px;">
                        </select>
                    </td>
                    <th>회원ID/회원명</th>
                    <td class="tleft">
                        <input id="USER_ID_NM" name="USER_ID_NM" data-type="textinput" data-bind="value:USER_ID_NM" style="width:150px;" maxlength="15">
                    </td>
                </tr>
                </table>
                </form>
            </div>
            <div class="psnm-find-btnarea">
                <input id="btnSearch" type="button" value="" data-type="button" data-theme="af-psnm">
            </div>
        </div>

        <!-- view_table area 1 -->
        <div class="textAR" style="min-height:200px;">
            <div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>회원 목록</b>
                <p class="ab_pos2">
                    <!-- <button id="btnInit" data-type="button" data-theme="af-psnm0">초기화</button> -->
                </p>
            </div>

            <!-- main grid 1 -->
            <div id="griduser" data-bind="grid:griduser" data-ui="ds"></div>
        </div>

        <!-- 이동버튼영역 -->
        <div class="textAR" style="min-height:30px;">
            <div align="center" class="psnm-mid-btns" >
                <button id="btnSelectUser" data-type="button" data-theme="af-btn-downicon" data-authtype="W" data-altname="포함"></button>
                &nbsp;&nbsp;
                <button id="btnDeselectUser" data-type="button" data-theme="af-btn-upicon" data-authtype="W" data-altname="제외"></button>
            </div>
        </div>

        <!-- view_table area 2 -->
        <div class="textAR" style="min-height:200px;">
            <div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>선택회원 목록</b>
                <p class="ab_pos2">
                    <!-- <button id="btnInit" data-type="button" data-theme="af-psnm0">초기화</button> -->
                </p>
            </div>

            <!-- main grid 2 -->
            <div id="gridusersel" data-bind="grid:griduser" data-ui="ds"></div>
        </div>

        <!-- view_table area -->
        <div class="textAR" style="min-height:30px;">
            <p class="floatL2">
                <input id="btnConfirm" type="button" value="" data-type="button" data-theme="af-btn8">
                <input id="btnCancel"  type="button" value="" data-type="button" data-theme="af-btn10">
            </p>
        </div>
    </div>

</div>

</body>
</html>