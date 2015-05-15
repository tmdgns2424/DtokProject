<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
    String _ROOT = "";
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

    <jsp:include page="/view/layouts/default_head.jsp" flush='N' />

    <script type="text/javascript">
    _LOG_LEVEL = 0; //로그레벨 :: 0=debug, 1=info, 2=error

    var _TX_SEARCH  = "com.BLTNBRD@PBLTNBRDAUTHMGMT001_pSearchAuthDeptUser";
    var _TX_SAVE    = "com.BLTNBRD@PBLTNBRDAUTHMGMT001_pSaveBrdAuth";
    var _TX_COPYAUTH = "com.BLTNBRD@PBLTNBRDAUTHMGMT001_pCopyBrdAuth";

    var _param;

    $.alopex.page({
        init : function(id, param) { 
            $.PSNM.initialize(id, param); //call common init function

            _param = param;

            $a.page.setCodeData();
            $a.page.setEventListener();
            $a.page.setGrid1();
            $a.page.setGrid2();
            $a.page.setGrid3();

            $('#dform').setData(param);

            pSearchAuthDeptUser();
        },
        setEventListener : function() {
            $("#btnList").click( gotoList );
            $("#btnSave").click( pSaveBrdAuth );
            $("#btnConfCopy").click( toCopyAuthConfig );

            $("#btnAddAuthGrp").click( addAuthGrp );
            $("#btnDelAuthGrp").click( delAuthGrp );

            $("#btnAddSaleDept").click( addSaleDept );
            $("#btnDelSaleDept").click( delSaleDept );

            $("#btnAddUser").click( addUser );
            $("#btnDelUser").click( delUser );
        },
        setGrid1 : function() {
            $("#gridauthgrp").alopexGrid({
                pager:false,
                rowClickSelect : false,
                rowInlineEdit : false,
                height : 400,
                headerGroup : [
                    //헤더를 index로 기준으로 하여 묶고 그 위에 타이틀을 표시할 수 있습니다.
                    { fromIndex:4, toIndex:4, title:"읽기" },
                    { fromIndex:5, toIndex:5, title:"쓰기" },
                    { fromIndex:6, toIndex:6, title:"삭제" },
                    { fromIndex:7, toIndex:7, title:"전체사용자" }
                ],
                columnMapping : [
                    { columnIndex : 0, key : "FLAG",        title : "F",           align : "center", width : "30px",   refreshBy:true, 
                                        refreshBy:true, 
                                        value : function(value, data) {
                                            if (data._state.added) return 'I';
                                            if (data._state.deleted) return 'D';
                                            if (data._state.edited) return 'U';
                                            return ''; 
                                        }
                    },
                    { columnIndex : 1, selectorColumn : true, width : "30px" },
                    { columnIndex : 2, key : "AUTH_GRP_ID", title : "권한그룹ID",  align : "center", width : "70px" },
                    { columnIndex : 3, key : "AUTH_GRP_NM", title : "권한그룹명",  align : "left", width : "110px" },
                    { columnIndex : 4, key : "R_AUTH",      align : "center", width : "60px",
                                        title : "<input type='checkbox' id='R_ALL' name='R_ALL' />",
                                        //editable : { type:"check", rule: [{value:'Y',check:true},{value:'N',check:false}] },
                                        render   : { type:"check", rule: [{value:'Y',check:true},{value:'N',check:false}] }
                    },
                    { columnIndex : 5, key : "W_AUTH",      align : "center", width : "60px",
                                        title : "<input type='checkbox' id='W_ALL' name='W_ALL' />",
                                        editable : { type:"check", rule: [{value:'Y',check:true},{value:'N',check:false}] },
                                        render   : { type:"check", rule: [{value:'Y',check:true},{value:'N',check:false}] }
                    },
                    { columnIndex : 6, key : "E_AUTH",      align : "center", width : "60px",
                                        title : "<input type='checkbox' id='E_ALL' name='E_ALL' />",
                                        editable : { type:"check", rule: [{value:'Y',check:true},{value:'N',check:false}] },
                                        render   : { type:"check", rule: [{value:'Y',check:true},{value:'N',check:false}] }
                    },
                    { columnIndex : 7, key : "ALL_USER_APLY_YN", align : "center", width : "80px",
                                        title : "<input type='checkbox' id='AUA_ALL' name='AUA_ALL' />",
                                        editable : { type:"check", rule: [{value:'Y',check:true},{value:'N',check:false}] },
                                        render   : { type:"check", rule: [{value:'Y',check:true},{value:'N',check:false}] }
                    }
                ]
                ,
                on : {
                    'cell' : {
                        "click" : function(data, eh, e) {
                            $('#gridauthgrp').alopexGrid('endEdit', {_index:{"data":data._index.data}}, true);
                            $("#gridauthgrp table.table tr").removeClass("editing");
                            //_debug("<grid.updateOption> 클릭된 데이터 : " + $.PSNMUtils.toString(data));
                            //$('#gridauthgrp').alopexGrid('startEdit', {_index:{"data":data._index.data}});
                        }
                    }
                    ,
                    data : {
                        "edit" : function(data, query) {
                            _debug("grid.on.data.edit", "data", JSON.stringify(data), "query", JSON.stringify(query));
                        }
                        ,
                        "changed" : function(type) {
                            //_debug("grid.on.data.changed", "type", type);
                            checkAllByData();
                        }
                    }
                }
            });
        },
        setGrid2 : function() {
            $("#gridauthorg").alopexGrid({
                pager:false,
                height: 400,
                //rowSingleSelect: false,
                columnMapping : [
                    { columnIndex : 0, key : "FLAG",        title : "F",           align : "center", width : "30px",   refreshBy:true, 
                                        refreshBy:true, 
                                        value : function(value, data) {
                                            if (data._state.added) return 'I';
                                            if (data._state.deleted) return 'D';
                                            //if (data._state.edited) return 'U';
                                            return ''; 
                                        }
                    },
                    { columnIndex : 1, selectorColumn : true,                            width : "30px" },
                    { columnIndex : 2, key : "HDQT_PART_ORG_NM", title : "본사파트",     align : "center", width : "120px"  },
                    { columnIndex : 3, key : "SALE_DEPT_ORG_ID", title : "영업국ID",     align : "center", width : "100px"  },
                    { columnIndex : 4, key : "SALE_DEPT_ORG_NM", title : "영업국명",     align : "center", width : "150px"  }
                ]
                ,
                on : {
                    'cell' : {
                        "click" : function(data, eh, e) {
                            //$('#gridauthorg').alopexGrid('endEdit', {_index:{"data":data._index.data}}, true);
                        }
                    }
                }
            });
        },
        setGrid3 : function() {
            $("#gridauthuser").alopexGrid({
                pager:false,
                height: 200,
                //rowSingleSelect: false,
                columnMapping : [
                    { columnIndex : 0, key : "FLAG",             title : "F",            align : "center", width : "30px", 
                                        refreshBy:true, 
                                        value : function(value, data) {
                                            if (data._state.added) return 'I';
                                            if (data._state.deleted) return 'D';
                                            //if (data._state.edited) return 'U';
                                            return ''; 
                                        }
                    },
                    { columnIndex : 1, selectorColumn : true,                            width : "30px" },
                    { columnIndex : 2, key : "SALE_DEPT_ORG_NM", title : "영업국명",     align : "center", width : "100px"  },
                    { columnIndex : 3, key : "SALE_TEAM_ORG_NM", title : "팀명",         align : "center", width : "100px"  },
                    { columnIndex : 4, key : "AGNT_NM",          title : "에이전트명",   align : "center", width : "100px"  },
                    { columnIndex : 5, key : "USER_ID_M",        title : "회원ID",       align : "center", width : "100px"  },
                    { columnIndex : 6, key : "USER_NM",          title : "회원명",       align : "center", width : "100px"  },
                    { columnIndex : 7, key : "AUTH_GRP_NM",      title : "권한그룹명",   align : "center", width : "100px"  },
                    { columnIndex : 8, key : "DUTY_NM",          title : "직무",         align : "center", width : "150px"  },
                    { columnIndex : 9, key : "SALE_DEPT_ORG_ID", title : "영업국ID",     hidden:true  },
                    { columnIndex :10, key : "SALE_TEAM_ORG_ID", title : "팀ID",         hidden:true  },
                    { columnIndex :11, key : "AGNT_ID",          title : "에이전트ID",   hidden:true  },
                    { columnIndex :12, key : "USER_ID",          title : "회원ID",       hidden:true  },
                    { columnIndex :13, key : "AUTH_GRP_ID",      title : "권한그룹ID",   hidden:true  },
                    { columnIndex :14, key : "DUTY_CD",          title : "직무코드",     hidden:true  }
                ]
                ,
                on : {
                    'cell' : {
                        "click" : function(data, eh, e) {
                            //
                        }
                    }
                }
            });
        },
        setCodeData : function() {
            //
        }
    });

    //게시판 권한정보 조회
    function pSearchAuthDeptUser() {
        if ( !$.PSNM.isValid('#dform') ) {
            return false;
        }

        $.alopex.request(_TX_SEARCH, {
            data: ['#dform', function() {
                //_debug("<pSearchAuthDeptUser> <request.data> 파라미터 (this.data.dataSet.fields) : " + JSON.stringify(this.data.dataSet.fields));
            }],
            success: ['#gridauthgrp', '#gridauthorg', '#gridauthuser', function(res) {
                //그리드가 다시 설정됨.
                $("#R_ALL").click( handleReadAuthAll );
                $("#W_ALL").click( handleWriteAuthAll );
                $("#E_ALL").click( handleEraseAuthAll );
                $("#AUA_ALL").click( handleAUAAll );

                $("#gridauthgrp").alopexGrid("startEdit");
                //$("#gridauthorg").alopexGrid("startEdit");
                removeEditStyle();
            }]
        });
    }

    function handleReadAuthAll(e) {
        if ( e.target.checked ) {
            $("#gridauthgrp").alopexGrid("dataEdit", {"R_AUTH":"Y"});
        }
        else {
            $("#gridauthgrp").alopexGrid("dataEdit", {"R_AUTH":"N"});
        }
        $("#gridauthgrp table.table tr").removeClass("editing");
    }
    function handleWriteAuthAll(e) {
        if ( e.target.checked ) {
            $("#gridauthgrp").alopexGrid("dataEdit", {"W_AUTH":"Y"});
        }
        else {
            $("#gridauthgrp").alopexGrid("dataEdit", {"W_AUTH":"N"});
            $("#gridauthgrp").alopexGrid("dataEdit", {"E_AUTH":"N"});
            $("#E_ALL").attr("checked", false);
        }
        $("#gridauthgrp table.table tr").removeClass("editing");
    }
    function handleEraseAuthAll(e) {
        if ( e.target.checked ) {
            $("#W_ALL").attr("checked", true);
            $("#gridauthgrp").alopexGrid("dataEdit", {"W_AUTH":"Y"});
            $("#gridauthgrp").alopexGrid("dataEdit", {"E_AUTH":"Y"});
        }
        else {
            $("#gridauthgrp").alopexGrid("dataEdit", {"E_AUTH":"N"});
        }
        $("#gridauthgrp table.table tr").removeClass("editing");
    }
    function handleAUAAll(e) {
        if ( e.target.checked ) {
            $("#gridauthgrp").alopexGrid("dataEdit", {"ALL_USER_APLY_YN":"Y"});
        }
        else {
            $("#gridauthgrp").alopexGrid("dataEdit", {"ALL_USER_APLY_YN":"N"});
        }
        $("#gridauthgrp table.table tr").removeClass("editing");
    }
    function checkAllByData() {
        var dataList  = $("#gridauthgrp").alopexGrid("dataGet");
        var dataCount = dataList.length;
        var _r_tocheck = true;
        var _w_tocheck = true;
        var _e_tocheck = true;
        var _aua_tocheck = true;
        for(var i=0; i<dataCount; i++) {
            _r_tocheck &= ("Y"==dataList[i].R_AUTH ? true : false);
            _w_tocheck &= ("Y"==dataList[i].W_AUTH ? true : false);
            _e_tocheck &= ("Y"==dataList[i].E_AUTH ? true : false);
            _aua_tocheck &= ("Y"==dataList[i].ALL_USER_APLY_YN ? true : false);
        }
        _debug("checkAllByData", "데이터건수="+dataCount, "최종_r_tocheck=" + _r_tocheck, "최종_w_tocheck=" + _w_tocheck, "최종_e_tocheck=" + _e_tocheck, "최종_aua_tocheck=" + _aua_tocheck);

        if (!_r_tocheck) {
            $("#R_ALL").removeAttr("checked");
        }
        else {
            $("#R_ALL").attr("checked", "checked");
            document.getElementById("R_ALL").checked = true;
        }
        if (!_w_tocheck) {
            $("#W_ALL").removeAttr("checked");
        }
        else {
            $("#W_ALL").attr("checked", "checked");
            document.getElementById("W_ALL").checked = true;
        }
        if (!_e_tocheck) {
            $("#E_ALL").removeAttr("checked");
        }
        else {
            $("#E_ALL").attr("checked", "checked");
            document.getElementById("E_ALL").checked = true;
        }
        if (!_aua_tocheck) {
            $("#AUA_ALL").removeAttr("checked");
        }
        else {
            $("#AUA_ALL").attr("checked", "checked");
            document.getElementById("AUA_ALL").checked = true;
        }
    }

    //게시판 권한정보 저장
    function pSaveBrdAuth() {
        var arrAuthGrpUpdated = $("#gridauthgrp").alopexGrid('dataGet', {_state:{edited:true}});
        var arrAuthGrpAdded   = $("#gridauthgrp").alopexGrid('dataGet', {_state:{added:true}});
        var arrAuthGrpDeleted = $("#gridauthgrp").alopexGrid('dataGet', {_state:{deleted:true}});
        var lenAuthGrp = arrAuthGrpUpdated.length + arrAuthGrpAdded.length + arrAuthGrpDeleted.length;

        var arrAuthOrgAdded = $("#gridauthorg").alopexGrid('dataGet', {_state:{added:true}});
        var arrAuthOrgDeled = $("#gridauthorg").alopexGrid('dataGet', {_state:{deleted:true}});
        var lenAuthOrg = arrAuthOrgAdded.length + arrAuthOrgDeled.length;

        var arrAuthUserAdded = $("#gridauthuser").alopexGrid('dataGet', {_state:{added:true}});
        var arrAuthUserDeled = $("#gridauthuser").alopexGrid('dataGet', {_state:{deleted:true}});
        var lenAuthUser = arrAuthUserAdded.length + arrAuthUserDeled.length;

        if ( lenAuthGrp + lenAuthOrg + lenAuthUser < 1 ) {
            $.PSNM.alert("E011", ["변경된"]);
            return false;
        }
        var arrAuthOrgNotDeled = $("#gridauthorg").alopexGrid('dataGet', {_state:{deleted:false}});
        if ( null==arrAuthOrgNotDeled || arrAuthOrgNotDeled.length<1 ) {
            $.PSNM.alert("적용된 영업국이 필요합니다.");
            return false;
        }

        var arrAuthGrpEdited = $.merge([], arrAuthGrpUpdated);
            arrAuthGrpEdited = $.merge(arrAuthGrpEdited, arrAuthGrpAdded);
        //alert( "arrAuthGrpEdited.length = " + arrAuthGrpEdited.length + "\n\n" + JSON.stringify(arrAuthGrpEdited));

        //저장전 체크
        for(var i=0, length=arrAuthGrpEdited.length; i<length; i++) {
            var sAuthGrpId = arrAuthGrpEdited[i].AUTH_GRP_ID;
            if ( '99'==sAuthGrpId ) {
                if ( 'N'==arrAuthGrpEdited[i].W_AUTH || 'N'==arrAuthGrpEdited[i].E_AUTH ) {
                    $.PSNM.alert("시스템관리자(99) 권한의 쓰기&삭제 권한을 체크해 주세요.");
                    return false;
                }
            }
            if ( 'N'==arrAuthGrpEdited[i].ALL_USER_APLY_YN ) {
                var arrAuthUserAll = $("#gridauthuser").alopexGrid('dataGet');
                var cnt2 = 0;
                for(var j=0, len2=arrAuthUserAll.length; j<len2; j++) {
                    if ( sAuthGrpId==arrAuthUserAll[j].AUTH_GRP_ID ) {
                        cnt2++;
                    }
                }
                if (cnt2<1) {
                    var msg = "권한그룹 ";
                        msg+= "'" + arrAuthGrpEdited[i].AUTH_GRP_NM + "'의 회원을 추가해야합니다.";
                    $.PSNM.alert(msg);
                    return false;
                }
            }
        }
        
        var cntOrgCheck = 0;
        var arrAuthOrg = $("#gridauthorg").alopexGrid('dataGet');
        for(var i=0, len3=arrAuthOrg.length; i<len3; i++) {
            //if ( "Y"==arrAuthOrg[i].AUTH_YN ) {
                cntOrgCheck++;
            //}
        }
        if ( cntOrgCheck<1 ) {
            $.PSNM.alert("적용된 영업국이 없습니다!");
            return false;
        }
        
        if ( ! $.PSNM.confirm("I004", ["저장"]) ) { //"{0} 하시겠습니까?"
            return false;
        }

        var reqData = $.PSNMUtils.getRequestDataUpdated('dform', 'gridauthgrp', 'gridauthorg', 'gridauthuser');
        _debug("pSaveBrdAuth", "getRequestDataUpdated", JSON.stringify(reqData));

        $.alopex.request(_TX_SAVE, {
            data: reqData,
            success: function(res) {
                //alert( "success\n\n" + JSON.stringify(res) );
                $.PSNM.alert( res.dataSet.message.messageName );
                pSearchAuthDeptUser();
            }
        });
    }

    //GRID 배경색 변경 원복함
    function removeEditStyle() {
        $("#gridauthgrp table.table tr").removeClass("editing");
        $("#gridauthgrp table.table tr").removeClass("deleted");
        $("#gridauthorg table.table tr").removeClass("editing"); //[적용된 권한] 테이블의 'editing' 클래스를 삭제(회색바탕)
        $("#gridauthorg table.table tr").removeClass("deleted");
        $("#gridauthuser table.table tr").removeClass("editing");
        $("#gridauthuser table.table tr").removeClass("deleted");
    }

    //권한그룹 추가
    function addAuthGrp() {
        $.PSNMAction.popFindAuthGrp(function(data) {
            _debug("권한그룹 찾기 팝업창에서 반환된 데이터\n\n" + JSON.stringify(data));
            if (null!=data && data.length>0) {
                for(var i=0; i<data.length; i++) {
                    var authGrpId = data[i]["AUTH_GRP_ID"];
                    var arr = $("#gridauthgrp").alopexGrid('dataGet', {AUTH_GRP_ID: authGrpId});
                    if (arr.length>0) {
                        $.PSNM.alert("[" + data[i]["AUTH_GRP_NM"] + "]은 이미 적용된 권한그룹입니다.");
                    }
                    else {
                        data[i]["FLAG"] = "I";
                        data[i]["R_AUTH"] = "Y";
                        data[i]["W_AUTH"] = "N";
                        data[i]["E_AUTH"] = "N";
                        data[i]["ALL_USER_APLY_YN"] = "Y";
                        $("#gridauthgrp").alopexGrid("dataAdd", data[i]);
                    }
                }
                $("#gridauthgrp").alopexGrid("startEdit");
                removeEditStyle();

                $("#R_ALL").unbind();
                $("#W_ALL").unbind();
                $("#E_ALL").unbind();
                $("#AUA_ALL").unbind();
                $("#R_ALL").click( handleReadAuthAll );
                $("#W_ALL").click( handleWriteAuthAll );
                $("#E_ALL").click( handleEraseAuthAll );
                $("#AUA_ALL").click( handleAUAAll );
            }
        });
    }
    //권한그룹 삭제
    function delAuthGrp() {
        var arrAuthGrp = $("#gridauthgrp").alopexGrid('dataGet', {_state:{selected:true}});
        if ( null==arrAuthGrp || arrAuthGrp.length<1 ) {
            $.PSNM.alert("E011", ["선택된"]);
            return false;
        }
        $("#gridauthgrp").alopexGrid("dataDelete", {_state:{selected:true}, "FLAG":"I"}); //추가된 데이터는 화면에서 삭제
        $("#gridauthgrp").alopexGrid("dataEdit", {_state:{deleted:true}}, {_state:{selected:true}});
        $("#gridauthgrp table.table tr").removeClass("editing");
        $("#gridauthgrp table.table tr").removeClass("deleted");
    }

    //영업국 추가
    function addSaleDept() {
        $.PSNMAction.popFindSaleDept(function(data) {
            _debug("영업국 찾기 팝업창에서 반환된 데이터\n\n" + JSON.stringify(data));
            if (null!=data && data.length>0) {
                for(var i=0; i<data.length; i++) {
                    var saleDeptOrgId = data[i]["SALE_DEPT_ORG_ID"];
                    var arr = $("#gridauthorg").alopexGrid('dataGet', {SALE_DEPT_ORG_ID: saleDeptOrgId});
                    if (arr.length>0) {
                        $.PSNM.alert("[" + data[i]["SALE_DEPT_ORG_NM"] + "]은 이미 적용된 영업국입니다.");
                    }
                    else {
                        data[i]["FLAG"] = "I";
                        $("#gridauthorg").alopexGrid("dataAdd", data[i]);
                        
                        $("#gridauthorg").alopexGrid("startEdit");
                        $("#gridauthorg").alopexGrid("endEdit");
                    }
                }
                removeEditStyle();
            }
            
        });
    }
    //영업국 삭제
    function delSaleDept() {
        var arrAuthGrp = $("#gridauthorg").alopexGrid('dataGet', {_state:{selected:true}});
        if ( null==arrAuthGrp || arrAuthGrp.length<1 ) {
            $.PSNM.alert("E011", ["선택된"]);
            return false;
        }
        $("#gridauthorg").alopexGrid("dataDelete", {_state:{selected:true}, "FLAG":"I"}); //추가된 데이터는 화면에서 삭제
        $("#gridauthorg").alopexGrid("dataEdit", {_state:{deleted:true}}, {_state:{selected:true}});
        $("#gridauthorg table.table tr").removeClass("editing");
        $("#gridauthorg table.table tr").removeClass("deleted");
    }

    //적용회원 추가
    function addUser() {
        var arrAuthOrgSel = $("#gridauthorg").alopexGrid('dataGet', {_state:{deleted:false}}); //$("#gridauthorg").alopexGrid('dataGet', {"AUTH_YN":"Y"});
        if ( null==arrAuthOrgSel || arrAuthOrgSel.length<1 ) {
            $.PSNM.alert("적용된 영업국이 필요합니다.");
            return false;
        }

        var arrAuthGrp = $("#gridauthgrp").alopexGrid('dataGet');
        var arrAuthOrg = $("#gridauthorg").alopexGrid('dataGet');
        var nLenAuthGrp = arrAuthGrp.length;
        var nLenAuthOrg = arrAuthOrg.length;
        var oParam = new Object();

        if (nLenAuthGrp>0) {
            var arrGrpUnchecked = AlopexGrid.trimData( $("#gridauthgrp").alopexGrid('dataGet', {"ALL_USER_APLY_YN":"N"}) );
            if (0==arrGrpUnchecked.length) {
                $.PSNM.alert("권한이 모두 [전체사용자]를 대상으로 설정되어 있습니다.");
                return false;
            }
            //var arrUserId = $.PSNMUtils.getGridColumnData("gridauthuser", "USER_ID"); //적용회원ID
            oParam["_pop_list_userid_applied"] = AlopexGrid.trimData( $("#gridauthuser").alopexGrid('dataGet') );
        }
        if (nLenAuthOrg>0) {
            var arrOrgChecked = AlopexGrid.trimData( $("#gridauthorg").alopexGrid('dataGet', {_state:{deleted:false}}) ); //$("#gridauthorg").alopexGrid('dataGet', {"AUTH_YN":"Y"})
            oParam["_pop_list_sale_dept"] = arrOrgChecked;
            //alert("arrOrgChecked \n\n" + JSON.stringify(arrOrgChecked));
        }
        _debug("addUser", "param", JSON.stringify(oParam) );

        var oOption = {
            url: "com/bltnbrd/findDeptUserPop"
           ,data: oParam
           ,width: $.PSNM.popWidth(1000)
           ,height: $.PSNM.popHeight(750)
           ,title: "회원찾기"
           ,callback: postFindDeptUser
        };
        $a.popup(oOption);
    }
    function postFindDeptUser(data) {
        if (null!=data && data.length>0) {
            for(var i=0; i<data.length; i++) {
                //data[i]["FLAG"] = "I";
            }
            //alert("선택된 데이터(popCallback)\n\n" + JSON.stringify(data));
            $("#gridauthuser").alopexGrid("dataAdd", data); //스크롤
            
            $("#gridauthuser").alopexGrid("startEdit");
            $("#gridauthuser").alopexGrid("endEdit");
        }
    }

    //적용회원 삭제
    function delUser() {
        var arrAuthOrg = $("#gridauthuser").alopexGrid('dataGet', {_state:{selected:true}});
        if ( null==arrAuthOrg || arrAuthOrg.length<1 ) {
            $.PSNM.alert("E011", ["선택된"]);
            return false;
        }
        $("#gridauthuser").alopexGrid("dataDelete", {_state:{selected:true}, "FLAG":"I"}); //추가된 데이터는 화면에서 삭제
        $("#gridauthuser").alopexGrid("dataEdit", {_state:{deleted:true}}, {_state:{selected:true}});
        $("#gridauthuser table.table tr").removeClass("editing");
        $("#gridauthuser table.table tr").removeClass("deleted");
    }

    //권한설정 복사
    function toCopyAuthConfig() {
        var oParam = new Object();
        $a.popup({
            url: "com/bltnbrd/bltnBrdSelPop"
           ,data: oParam
           ,width: 600
           ,height: 650
           ,title: "게시판찾기"
           ,movable: true
           ,callback: postSelBltnBrd
        });
    }
    function postSelBltnBrd(data) {
        if (null!=data) {
            _debug("선택된 데이터(popCallback)\n\n" + JSON.stringify(data));

            //$('#dform').setData(data);
            //pSearchAuthDeptUser();
            var m = "게시판 권한을 [" + data["BLTN_BRD_NM"] + "]의 권한으로 대체하시겠습니까?\n\n";
                m+= "(주의) 현재 설정된 권한정보가 삭제되고 해당 게시판의 권한으로 설정됩니다.";
            if ( !$.PSNM.confirm(m) ) {
                return;
            }
            pCopyAuthDeptUser(data);
        }
    }

    //게시판 권한설정 복사
    function pCopyAuthDeptUser(data) {
        if (null==data) {
            return false;
        }

        $.alopex.request(_TX_COPYAUTH, {
            data: ['#dform', function() {
                this.data.dataSet.fields["FROM_BLTN_BRD_ID"] = data["BLTN_BRD_ID"];
                //_debug("<pSearchAuthDeptUser> <request.data> 파라미터 (this.data.dataSet.fields) : " + JSON.stringify(this.data.dataSet.fields));
            }],
            success: ['#gridauthgrp', function(res) { //, '#gridauthorg', '#gridauthuser'
                //그리드가 다시 설정됨.
                //$("#R_ALL").click( handleReadAuthAll );
                //$("#W_ALL").click( handleWriteAuthAll );
                //$("#E_ALL").click( handleEraseAuthAll );
                //$("#AUA_ALL").click( handleAUAAll );

                $("#gridauthgrp").alopexGrid("startEdit");
                removeEditStyle();
            }]
        });
    }

    //목록
    function gotoList() {
        $a.back(_param);
    }
    </script>

</head>

<body>

<jsp:include page="/view/layouts/default_header.jsp" flush='N' />

<!-- title area -->
<div id="contents">
    <div class="content_title">
        <div class="ub_txt6">
            <span class="txt6_img"><b id="sub-title">게시판권한관리</b>
                <span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif">
                <span class="a2">본사업무</span> <span class="a3"> > </span> <span class="a4"><b>공통관리</b></span> 
            </span>
        </div>
    </div>

    <!-- btn area -->
    <div class="btn_area">
        <div class="ab_btn_left">
            &nbsp;
        </div>
        <div class="ab_btn_right">
            <button id="btnConfCopy" data-type="button" data-theme="af-btn59"  data-authtype="W" data-altname="권한설정복사"></button>
            <button id="btnSave" data-type="button" data-theme="af-btn4"  data-authtype="W" data-altname="저장"></button>
            <button id="btnList" data-type="button" data-theme="af-btn14" data-authtype="R" data-altname="목록"></button>
        </div>
    </div>
    <!-- btn area end--> 

    <!--view_table area -->
    <div class="view_list" style="clear:both; margin-top: 10px;">
        <form id="dform">
            <table class="board02" width="100%" >
        	<colgroup>
	            <col style="width:12%"/>
	            <col style="width:21%"/>
	            <col style="width:12%"/>
	            <col style="width:21%"/>
	            <col style="width:12%"/>
	            <col style="width:*"/>
            </colgroup>
            <tr>
                <th scope="col">게시판유형</th>
                <td class="tleft">
                    <input id="BLTN_BRD_TYP_NM" name="BLTN_BRD_TYP_NM" type="text" data-type="textinput" data-bind="value:BLTN_BRD_TYP_NM" data-disabled='Y' />
                </td>
                <th scope="col">게시판ID</th>
                <td class="tleft time">
                    <input id="BLTN_BRD_ID" name="BLTN_BRD_ID" type="text" data-type="textinput" data-bind="value:BLTN_BRD_ID" data-disabled='Y' /> 
                </td>
                <th scope="col">게시판명</th>
                <td class="tleft time">
                    <input id="BLTN_BRD_NM" name="BLTN_BRD_NM" type="text" data-type="textinput" data-bind="value:BLTN_BRD_NM" data-disabled='Y' /> 
                </td>
            </tr>
            </table>
        </form>
    </div>

    <div class="psnm-section">
        <div class="psnm-secleft">
            <div class="floatL4" style="clear:both;"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>권한그룹 적용</b>
                <p class="ab_pos1">
                    <input id="btnAddAuthGrp" type="button" data-type="button" class="psnm-sbtn-add" />
                    <input id="btnDelAuthGrp" type="button" data-type="button" class="psnm-sbtn-del" />
                </p>
            </div>
            <!-- 왼쪽 그리드1 -->
            <div id="gridauthgrp" data-bind="grid:gridauthgrp" data-ui="ds"></div>
        </div>
        <div class="psnm-secright">
            <div class="floatL4" style="clear:both;"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>영업국 적용</b>
                <p class="ab_pos1">
                    <input id="btnAddSaleDept" type="button" data-type="button" class="psnm-sbtn-add" />
                    <input id="btnDelSaleDept" type="button" data-type="button" class="psnm-sbtn-del" />
                </p>
            </div>
            <!-- 오른쪽 그리드1 -->
            <div id="gridauthorg" data-bind="grid:gridauthorg" data-ui="ds"></div>
        </div>
    </div>

    <div class="floatL4" style="clear:both;"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>적용 회원</b>
        <p class="ab_pos1">
            <input id="btnAddUser" type="button" data-type="button" class="psnm-sbtn-add" />
            <input id="btnDelUser" type="button" data-type="button" class="psnm-sbtn-del" />
        </p>
    </div>
    <div id="gridauthuser" data-bind="grid:gridauthuser" data-ui="ds"></div>

</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush='N' />

</body>
</html>
