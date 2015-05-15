/*
 * Copyright (c) 2014 PS&M. All rights reserved.
 */

(function ($) {

    $.PSNMNS = {
        setBasicOrgSelectBox : function() {
            var isExistHdqtTeam = false; //'본사팀'   선택상자 존재여부
            var isExistHdqtPart = false; //'본사파트' 선택상자 존재여부

            $("select").each(
                function(index) {
                    var _sel_id = $(this).attr("id");

                    if ( "HDQT_TEAM_ORG_ID"==_sel_id || "HDQT_PART_ORG_ID"==_sel_id || "SALE_DEPT_ORG_ID"==_sel_id || "SALE_TEAM_ORG_ID"==_sel_id ) {
                        $(this).change( eval("_onchange_NS_" + _sel_id + "") ); //(예) _onchange_HDQT_PART_ORG_ID
                    }
                    if ( "HDQT_TEAM_ORG_ID"==_sel_id ) isExistHdqtTeam = true; //본사팀 존재함
                    if ( "HDQT_PART_ORG_ID"==_sel_id ) isExistHdqtPart = true; //본사팀 존재함
                }
            );

            var type   = 'org1';
            var elemid = 'HDQT_TEAM_ORG_ID';
            var header = '-선택-'; //alert("_NOSESSION_REQ_URL : " + _NOSESSION_REQ_URL);
            var oParam = $.PSNMNS.getOrgSearchParam('org1', 'HDQT_TEAM_ORG_ID', '-선택-');
            if ( !isExistHdqtTeam && isExistHdqtPart ) {
                oParam = $.PSNMNS.getOrgSearchParam('org2', 'HDQT_PART_ORG_ID', '-선택-');
            }

            $.PSNMNS.setOrgOptionsByUpper(oParam);
        }
        ,
        getOrgSearchParam : function(type, elemid, header) {
            type = $.PSNMUtils.isEmpty(type) ? "org1" : type;

            var param = new Object();
                param["type"] = type;
                param["elemid"] = ( $.PSNMUtils.isEmpty(elemid) ? "HDQT_TEAM_ORG_ID" : elemid );
                param["header"] = ( $.PSNMUtils.isEmpty(header) ? "" : header );
                param["HDQT_TEAM_ORG_ID"] = "";
                param["HDQT_PART_ORG_ID"] = "";
                param["SALE_DEPT_ORG_ID"] = "";
                param["SALE_TEAM_ORG_ID"] = "";

            switch(type) {
                case "org5" : var org4 = $("#SALE_TEAM_ORG_ID option:selected").val();
                              param["SALE_TEAM_ORG_ID"] = ($.PSNMUtils.isEmpty(org4) ? "" : org4);
                case "org4" : var org3 = $("#SALE_DEPT_ORG_ID option:selected").val();
                              param["SALE_DEPT_ORG_ID"] = ($.PSNMUtils.isEmpty(org3) ? "" : org3);
                case "org3" : var org2 = $("#HDQT_PART_ORG_ID option:selected").val();
                              param["HDQT_PART_ORG_ID"] = ($.PSNMUtils.isEmpty(org2) ? "" : org2);
                case "org2" : var org1 = $("#HDQT_TEAM_ORG_ID option:selected").val();
                              param["HDQT_TEAM_ORG_ID"] = ($.PSNMUtils.isEmpty(org1) ? "" : org1);
                default : break;
            }
            _debug("getOrgSearchParam", "param", JSON.stringify(param));
            return param;
        }
        ,
        setOrgOptionsByUpper : function(oParam, callback) {
            var type   = oParam["type"];
            var elemid = oParam["elemid"];
            var header = oParam["header"];

            $.alopex.request("com.CODE@PCODE_pSearchOrgByUpper", {
                url: _CTX_PATH + "psnmnosess.jmd",
                showProgress:false,
                async:false, //공통코드 조회는 sync로 조회함
                data: {
                    dataSet: { fields : oParam } //{ "t":t, "elemid":elemid, "codeid":codeid, "header":header } }
                },
                success: function(res) {
                    var orgList = res.dataSet.recordSets[""+elemid].nc_list;
                    var codeOptions2 = $.PSNMUtils._getCodeDataForSelBox(type, header, orgList);
                        var optData = new Object();
                            optData["options_" + elemid] = codeOptions2;
                        $("#" + elemid).setData(optData);

                    if ( $.PSNMUtils.isNotEmpty(callback) && typeof(callback) == "function"  ) {
                        console.log("<doSearchOrgByUpper> callback function defined. 함수명 : " + callback + "");
                        callback.call(undefined, oParam);
                        return;
                    }
                }
            });
        }
    };
    //end of [$.PSNMNS]

})(jQuery);



    var _default_org_options_ = [ { value: "", text: "-선택-"} ]; //select 초기 옵션 데이터

    //[본사팀] 코드 변경시 처리
    function _onchange_NS_HDQT_TEAM_ORG_ID(E) {
        var eTargetId = E.target.id;
        var sHdqtTeamOrgIdVal = $("#" + eTargetId + " option:selected").val(); //선택된 '본사팀ID' //HDQT_TEAM_ORG_ID
        var sHdqtPartOrgIdElemId = 'HDQT_PART_ORG_ID'; //'본사파트' select
        _debug("<PSNMNS._onchange..> <본사팀코드변경> 변경된 본사팀코드 = [" +  sHdqtTeamOrgIdVal + "], 이벤트발생요소ID = [" + eTargetId + "]");

        $('#SALE_TEAM_ORG_ID').setData({options_SALE_TEAM_ORG_ID : _default_org_options_}).setSelected("-선택-");
        $('#SALE_DEPT_ORG_ID').setData({options_SALE_DEPT_ORG_ID : _default_org_options_}).setSelected("-선택-");
        $('#HDQT_PART_ORG_ID').setData({options_HDQT_PART_ORG_ID : _default_org_options_}).setSelected("-선택-");
        if ( $('#SALE_AGNT_ORG_ID').length >0 ) {
            $('#SALE_AGNT_ORG_ID').setData({options_SALE_AGNT_ORG_ID : _default_org_options_}).setSelected("-선택-");
        }

        if ( $.PSNMUtils.isNotEmpty(sHdqtTeamOrgIdVal) ) {
            $("#" + sHdqtPartOrgIdElemId + "").val("");
            var oParam = $.PSNMNS.getOrgSearchParam('org2', sHdqtPartOrgIdElemId, '-선택-');
            $.PSNMNS.setOrgOptionsByUpper(oParam);
        }
    }
    //[본사파트] 코드 변경시 처리
    function _onchange_NS_HDQT_PART_ORG_ID(E) {
        var eTargetId = E.target.id;
        var sHdqtPartOrgIdVal = $("#" + eTargetId + " option:selected").val(); //선택된 '본사파트ID' //HDQT_PART_ORG_ID
        var sSaleDeptOrgIdElemId = 'SALE_DEPT_ORG_ID'; //'영업국' select
        _debug("<PSNMNS._onchange..> <본사파트코드변경> 변경된 본사파트코드 = [" +  sHdqtPartOrgIdVal + "], 이벤트발생요소ID = [" + eTargetId + "]");

        $('#SALE_TEAM_ORG_ID').setData({options_SALE_TEAM_ORG_ID : _default_org_options_}).setSelected("-선택-");
        $('#SALE_DEPT_ORG_ID').setData({options_SALE_DEPT_ORG_ID : _default_org_options_}).setSelected("-선택-");

        if ( $.PSNMUtils.isNotEmpty(sHdqtPartOrgIdVal) ) {
            var oParam = $.PSNMNS.getOrgSearchParam('org3', sSaleDeptOrgIdElemId, '-선택-');
            $.PSNMNS.setOrgOptionsByUpper(oParam);
        }
    }

    //[영업국] 코드 변경시 처리
    function _onchange_NS_SALE_DEPT_ORG_ID(E) {
        var eTargetId = E.target.id;
        var sSaleDeptOrgIdVal = $("#" + eTargetId + " option:selected").val(); //선택된 '영업국ID' //SALE_DEPT_ORG_ID
        var sSaleTeamOrgIdElemId = 'SALE_TEAM_ORG_ID'; //'영업팀' select
        _debug("<PSNMNS._onchange..> <영업국코드변경> 변경된 영업국코드 = [" +  sSaleDeptOrgIdVal + "], 이벤트발생요소ID = [" + eTargetId + "]");

        $('#SALE_TEAM_ORG_ID').setData({options_SALE_TEAM_ORG_ID : _default_org_options_}).setSelected("-선택-");

        if ( $.PSNMUtils.isNotEmpty(sSaleDeptOrgIdVal) ) {
            var oParam = $.PSNMNS.getOrgSearchParam('org4', sSaleTeamOrgIdElemId, '-선택-');
            $.PSNMNS.setOrgOptionsByUpper(oParam);
        }
    }

    //[영업팀] 코드 변경시 처리
    function _onchange_NS_SALE_TEAM_ORG_ID(E) {
        var eTargetId = E.target.id;
        var sSaleTeamOrgIdVal = $("#" + eTargetId + " option:selected").val(); //선택된 '영업국ID' //SALE_DEPT_ORG_ID
        var sSaleAgentOrgIdElemId = 'SALE_AGNT_ORG_ID'; //'에이전트' select

        if ( $('#SALE_AGNT_ORG_ID').length < 1) { //화면요소 없음
            return;
        }

        $('#SALE_AGNT_ORG_ID').setData({options_SALE_AGNT_ORG_ID : _default_org_options_}).setSelected("-선택-");

        if ( $.PSNMUtils.isNotEmpty(sSaleTeamOrgIdVal) ) {
            var oParam = $.PSNMNS.getOrgSearchParam('org5', sSaleAgentOrgIdElemId, '-선택-');
            $.PSNMNS.setOrgOptionsByUpper(oParam);
        }
    }
