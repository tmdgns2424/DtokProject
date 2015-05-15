/*
 * Copyright (c) 2014 PS&M. All rights reserved.
 */

(function ($) {

    $.PSNMAction = {

        // 
        // {본사팀, 에이전트명}으로 에이전트 목록을 찾아서,
        // 결과레코드가 1건이면 {에이전트명, 에이전트ID} 텍스트요소에 값을 설정하고,
        // 결과레코드가 2건 이상이면면 팝업창을 오픈
        //
        // @param    elemAgentNameInput  에이전트명 input 요소(객체)
        // @param    sFindForm           해당 폼ID
        //
        findAgent : function(event) {
            if (13!=event.which) {
                return;
            }
            var elemid  = $(event.target).attr("id");
            var elemval = $(event.target).val();
            var agentid = $(event.target).data("agentid");
            var postcallback = $(event.target).data("callback");
            var findtype = $(event.target).data("findtype"); //@since 2015-03-04
            var islogin  = $(event.target).data("islogin");  //@since 2015-03-05
            var formid   = $(event.target).closest("form").attr("id");
            
            console.log("<PSNMAction.findAgent> 요소ID = [" + elemid + "] 값 = [" + elemval + "] agentid = [" + agentid + "] callback = [" + postcallback + "] formid = [" + formid + "]");

            if ( $.PSNMUtils.isEmpty(elemval) ){
                $(event.target).val("");
                $("#" + agentid).val("");
                return;
            }

            if ( !$.PSNMUtils.isEmpty(elemval) && $.trim(elemval).length<2 ) {
                alert("에이전트명을 2자이상 입력하십시오.");
                $(elemAgentNameInput).focus();
                return;
            }
            //var org1 = $("#" + formid + " #HDQT_TEAM_ORG_ID").getValues()[0]; //alert("HDQT_TEAM_ORG_ID : " + JSON.stringify(org1));

            //if ( null==org1 || $.PSNMUtils.isEmpty(org1) ) {
            //    alert("본사팀을 선택하십시오.");
            //    $("#" + formid + " #HDQT_TEAM_ORG_ID").focus();
            //    return;
            //}
            var param = new Object();
                param["HDQT_TEAM_ORG_ID"] = $("#" + formid + " #HDQT_TEAM_ORG_ID").val();
                param["HDQT_PART_ORG_ID"] = $("#" + formid + " #HDQT_PART_ORG_ID").val();
                param["SALE_DEPT_ORG_ID"] = $("#" + formid + " #SALE_DEPT_ORG_ID").val();
                param["SALE_TEAM_ORG_ID"] = $("#" + formid + " #SALE_TEAM_ORG_ID").val();
                param["AGNT_NM"] = $.trim(elemval);
                param["FINDTYPE"] = $.trim(findtype); //@since 2015-03-04
                param["ISLOGIN"] = $.trim(islogin);
                
            console.log("<PSNMAction.findAgent> param : " + JSON.stringify(param));

            document.body.style.cursor = 'wait';
            
            var _txid = 'com.CODE@PBASE_pSearchAgent';
            if ( $.PSNMUtils.isNotEmpty(islogin) && false==islogin ) {
                _txid = 'com.CODE@PBASE_pSearchAgentNoMember'; //회원가입시 에이전트찾기(사용자정보 참조안함)
            }
            
            $.alopex.request(_txid, {
                url: _NOSESSION_REQ_URL,
                data: function() {
                    this.data.dataSet.fields = param;
                    console.log("<PSNMAction.findAgent> <request.data> 파라미터 (this.data.dataSet.fields) : " + JSON.stringify(this.data.dataSet.fields));
                },
                success: function(res) {
                    document.body.style.cursor = 'default';
                    var dataList = res.dataSet.recordSets.gridagent.nc_list;
                    console.log("<PSNMAction.findAgent> 조회된 에이전트 : " + JSON.stringify(dataList));
                    if (1==dataList.length) {
                    	
                        $(event.target).val( dataList[0]["AGNT_NM"] );
                        $("#" + agentid).val( dataList[0]["AGNT_ID"] );

                        if (null!=postcallback && ''!=postcallback) {
                            try {
                                eval(postcallback).call(undefined, dataList[0]);
                            }
                            catch(E) {
                                alert("에이전트 정보를 찾은 후 추가 처리중 오류가 발생하였습니다!\n\n(원인1) " + E.description);
                            }
                        }
                    }
                    else {
                        $("#" + agentid).val("");
                        $a.popup({
                            url: "com/popupns/findAgentPop",
                            data: param,
                            width: 900,
                            height: 630,
                            title: "에이전트 찾기",
                            callback : function(returnVal) {
                                console.log("<PSNMAction.findAgent> returnVal : " + $.PSNMUtils.toString(returnVal));
                                if ( null!=returnVal && typeof returnVal == "object" ) {
                                    $(event.target).val( returnVal["AGNT_NM"] );
                                    $("#" + agentid).val( returnVal["AGNT_ID"] );

                                    if (null!=postcallback && ''!=postcallback) {
                                        //window[postcallback].apply( window, returnVal );
                                        try {
                                            eval(postcallback).call(undefined, returnVal);
                                        }
                                        catch(E) {
                                            alert("에이전트 정보를 찾은 후 추가 처리중 오류가 발생하였습니다!\n\n(원인2) " + E.description);
                                        }
                                    }
                                }
                            }
                        });
                    }
                }
            });
        } //end-of findAgent()
        ,     
        findAgent2 : function(event) {
            if (13!=event.which) {
                return;
            }
            var elemid  = $(event.target).attr("id");
            var elemval = $(event.target).val();
            var agentid = $(event.target).data("agentid");
            var postcallback = $(event.target).data("callback");
            var findtype = $(event.target).data("findtype"); //@since 2015-03-04
            var islogin  = $(event.target).data("islogin");  //@since 2015-03-05
            var formid   = $(event.target).closest("form").attr("id");
            
            console.log("<PSNMAction.findAgent> 요소ID = [" + elemid + "] 값 = [" + elemval + "] agentid = [" + agentid + "] callback = [" + postcallback + "] formid = [" + formid + "]");

            if ( $.PSNMUtils.isEmpty(elemval) ){
                $(event.target).val("");
                $("#" + agentid).val("");
                return;
            }

            if ( !$.PSNMUtils.isEmpty(elemval) && $.trim(elemval).length<2 ) {
                alert("에이전트명을 2자이상 입력하십시오.");
                $(elemAgentNameInput).focus();
                return;
            }
            //var org1 = $("#" + formid + " #HDQT_TEAM_ORG_ID").getValues()[0]; //alert("HDQT_TEAM_ORG_ID : " + JSON.stringify(org1));

            //if ( null==org1 || $.PSNMUtils.isEmpty(org1) ) {
            //    alert("본사팀을 선택하십시오.");
            //    $("#" + formid + " #HDQT_TEAM_ORG_ID").focus();
            //    return;
            //}
            var param = new Object();
                param["HDQT_TEAM_ORG_ID"] = $("#" + formid + " #HDQT_TEAM_ORG_ID").val();
                param["HDQT_PART_ORG_ID"] = $("#" + formid + " #HDQT_PART_ORG_ID").val();
                param["SALE_DEPT_ORG_ID"] = $("#" + formid + " #SALE_DEPT_ORG_ID").val();
                param["SALE_TEAM_ORG_ID"] = $("#" + formid + " #SALE_TEAM_ORG_ID").val();
                param["AGNT_NM"] = $.trim(elemval);
                param["FINDTYPE"] = $.trim(findtype); //@since 2015-03-04
                param["ISLOGIN"] = $.trim(islogin);
                
                param["agentSearchCheck"] = $("#" + formid + " #agentSearchCheck").val();
                
            console.log("<PSNMAction.findAgent> param : " + JSON.stringify(param));

            document.body.style.cursor = 'wait';
            
            var _txid = 'com.CODE@PBASE_pSearchAgent';
            if ( $.PSNMUtils.isNotEmpty(islogin) && false==islogin ) {
                _txid = 'com.CODE@PBASE_pSearchAgentNoMember'; //회원가입시 에이전트찾기(사용자정보 참조안함)
            }
            if ( $.PSNMUtils.isNotEmpty(param["agentSearchCheck"]) && param["agentSearchCheck"]=="2" ) {
            	param["page"] = "1";
                param["page_size"] = "10";
            	var _txid = 'com.USERINFO@PUSERSCRBREQ001_pSearchAgnt';
            }
            
            $.alopex.request(_txid, {
                url: _NOSESSION_REQ_URL,
                data: function() {
                    this.data.dataSet.fields = param;
                    console.log("<PSNMAction.findAgent> <request.data> 파라미터 (this.data.dataSet.fields) : " + JSON.stringify(this.data.dataSet.fields));
                },
                success: function(res) {
                    document.body.style.cursor = 'default';
                    var dataList = res.dataSet.recordSets.gridagnt.nc_list;
                    console.log("<PSNMAction.findAgent> 조회된 에이전트 : " + JSON.stringify(dataList));
                    if (1==dataList.length) {
                    	
                        $(event.target).val( dataList[0]["AGNT_NM"] );
                        $("#" + agentid).val( dataList[0]["AGNT_ID"] );

                        if (null!=postcallback && ''!=postcallback) {
                            try {
                                eval(postcallback).call(undefined, dataList[0]);
                            }
                            catch(E) {
                                alert("에이전트 정보를 찾은 후 추가 처리중 오류가 발생하였습니다!\n\n(원인1) " + E.description);
                            }
                        }
                    }
                    else {
                        $("#" + agentid).val("");
                        $a.popup({
                            //url: "com/popupns/findAgentPop",
                        	url: "com/popup/findAgent3Pop",
                            data: param,
                            width: 900,
                            height: 630,
                            title: "에이전트 찾기",
                            callback : function(returnVal) {
                                console.log("<PSNMAction.findAgent> returnVal : " + $.PSNMUtils.toString(returnVal));
                                if ( null!=returnVal && typeof returnVal == "object" ) {
                                    $(event.target).val( returnVal["AGNT_NM"] );
                                    $("#" + agentid).val( returnVal["AGNT_ID"] );

                                    if (null!=postcallback && ''!=postcallback) {
                                        //window[postcallback].apply( window, returnVal );
                                        try {
                                            eval(postcallback).call(undefined, returnVal);
                                        }
                                        catch(E) {
                                            alert("에이전트 정보를 찾은 후 추가 처리중 오류가 발생하였습니다!\n\n(원인2) " + E.description);
                                        }
                                    }
                                }
                            }
                        });
                    }
                }
            });
        } //end-of findAgent()
        , 
        findSmember : function(event) {
            if (13!=event.which) {
                return;
            }
       
            var elemid  = $(event.target).attr("id");
            var elemval = $(event.target).val();
            var agentid = $(event.target).data("agentid");
            var partnm  = $(event.target).data("partnm");
            var dutynm = $(event.target).data("dutynm");
            var postcallback = $(event.target).data("callback");
            var formid  = $(event.target).closest("form").attr("id");
            
            console.log("<PSNMAction.findAgent> 요소ID = [" + elemid + "] 값 = [" + elemval + "] agentid = [" + agentid + "] callback = [" + postcallback + "] formid = [" + formid + "]");

            if ( $.PSNMUtils.isEmpty(elemval) ){
                $(event.target).val("");
                $("#" + agentid).val("");
                return;
            }

            if ( !$.PSNMUtils.isEmpty(elemval) && $.trim(elemval).length<2 ) {
                alert("직원명을 2자이상 입력하십시오.");
                $(elemAgentNameInput).focus();
                return;
            }

            var param = new Object();
                param["HDQT_TEAM_ORG_ID"] = $("#" + formid + " #HDQT_TEAM_ORG_ID").val();
                param["HDQT_PART_ORG_ID"] = $("#" + formid + " #HDQT_PART_ORG_ID").val();
                param["USER_NM"] = $.trim(elemval);
                param["page"] = "1";
                param["page_size"] = "10";
            console.log("<PSNMAction.findAgent> param : " + JSON.stringify(param));

            document.body.style.cursor = 'wait';
            
            $.alopex.request('com.USERINFO@PUSERSCRBREQ001_pSearchSmember', {
                url: _NOSESSION_REQ_URL,
                data: function() {
                    this.data.dataSet.fields = param;
                    console.log("<PSNMAction.findAgent> <request.data> 파라미터 (this.data.dataSet.fields) : " + JSON.stringify(this.data.dataSet.fields));
                },
                success: function(res) {
                    document.body.style.cursor = 'default';
                    
                    
                    var dataList = res.dataSet.recordSets.gridsmember.nc_list;
                    console.log("<PSNMAction.findAgent> 조회된 에이전트 : " + JSON.stringify(dataList));
                    if (1==dataList.length) {
                        $(event.target).val( dataList[0]["USER_NM"] );
                        $("#" + agentid).val( dataList[0]["USER_ID"] );
                        $("#" + dutynm).val( dataList[0]["DUTY_NM"] );
                        $("#" + partnm).val( dataList[0]["HDQT_PART_ORG_NM"] );
                        

                        if (null!=postcallback && ''!=postcallback) {
                            try {
                                eval(postcallback).call(undefined, dataList[0]);
                            }
                            catch(E) {
                                alert("임직원 정보를 찾은 후 추가 처리중 오류가 발생하였습니다!\n\n(원인1) " + E.description);
                            }
                        }
                    }
                    else {
                        $("#" + agentid).val("");
                        $a.popup({
                            url: "com/popup/findSMemberPop",
                            data: param,
                            width: 900,
                            height: 500,
                            title: "임직원찾기",
                            callback : function(returnVal) {
                                console.log("<PSNMAction.findAgent> returnVal : " + $.PSNMUtils.toString(returnVal));
                                if ( null!=returnVal && typeof returnVal == "object" ) {
                                    $(event.target).val( returnVal["USER_NM"] );
                                    $("#" + agentid).val( returnVal["USER_ID"] );
                                    $("#" + dutynm).val( returnVal["DUTY_NM"] );
                                    $("#" + partnm).val( returnVal["HDQT_PART_ORG_NM"] );

                                    if (null!=postcallback && ''!=postcallback) {
                                         try {
                                            eval(postcallback).call(undefined, returnVal);
                                        }
                                        catch(E) {
                                            alert("임직원 정보를 찾은 후 추가 처리중 오류가 발생하였습니다!\n\n(원인2) " + E.description);
                                        }
                                    }
                                }
                            }
                        });
                    }
                }
            });
        } //end-of findAgent()
        ,

        //
        // 에이전트 찾기 팝업창을 오픈
        //
        // @param    oParam      본사팀, 본사파트, 영업국, 영업팀 검색조건을 담은 객체.
        // @param    resultCallback 콜백함수
        //
        popFindAgent : function(oParam, resultCallback) {
            console.log("<PSNMAction.popFindAgent> param : " + JSON.stringify(oParam));
            if ( null==resultCallback || undefined==resultCallback ) {
                alert("에이전트 찾기 팝업창을 오픈할 수 없습니다!");
                return;
            }

            $a.popup({
                url: "" + $.PSNM.COM_POP_URL_PREFIX + "findAgent2Pop.jsp",
                data: oParam,
                width: 900,
                height: 700,
                title : "에이전트찾기",
                windowpopup: false,
				iframe: true,
                callback : function(returnVal) {
                    console.log("<PSNMAction.popFindAgent> returnVal : " + $.PSNMUtils.toString(returnVal));

                    if ( $.PSNMUtils.isNotEmpty(resultCallback) && typeof(resultCallback) == "function"  ) {
                        console.log("<PSNMAction.popFindAgent> callback function defined. 함수명 : " + resultCallback + "");
                        resultCallback.call(undefined, returnVal);
                        return;
                    }
                    //else {
                    //    if ( null!=returnVal && typeof returnVal == "object" ) {
                    //        $("#" + sAgentNmId).val( returnVal["AGNT_NM"] );
                    //        $("#" + sAgentIdId).val( returnVal["AGNT_ID"] );
                    //    }
                    //}
                    
                }
            });
        }
        ,
        
        //
        // 임직원 찾기 팝업창을 오픈
        //
        // @param    oParam      본사팀, 본사파트, 영업국, 영업팀 검색조건을 담은 객체.
        // @param    resultCallback 콜백함수
        //
        popFindSmember : function(oParam, resultCallback) {
            console.log("<PSNMAction.popFindAgent> param : " + JSON.stringify(oParam));
            if ( null==resultCallback || undefined==resultCallback ) {
                alert("임직원 찾기 팝업창을 오픈할 수 없습니다!");
                return;
            }

       
            $a.popup({
                url: "" + $.PSNM.COM_POP_URL_PREFIX + "findSMemberPop.jsp",
                data: oParam,
                width: 900,
                height: 700,
                title : "임직원찾기",
                windowpopup: false,
				iframe: true,
                callback : function(returnVal) {
                    console.log("<PSNMAction.popFindAgent> returnVal : " + $.PSNMUtils.toString(returnVal));

                    if ( $.PSNMUtils.isNotEmpty(resultCallback) && typeof(resultCallback) == "function"  ) {
                        console.log("<PSNMAction.popFindAgent> callback function defined. 함수명 : " + resultCallback + "");
                        resultCallback.call(undefined, returnVal);
                        return;
                    }
                    //else {
                    //    if ( null!=returnVal && typeof returnVal == "object" ) {
                    //        $("#" + sAgentNmId).val( returnVal["AGNT_NM"] );
                    //        $("#" + sAgentIdId).val( returnVal["AGNT_ID"] );
                    //    }
                    //}
                    
                }
            });
        }
        ,
        
        //
        // {성명}으로 "본사직원" 목록을 찾아서,
        // 결과레코드가 1건이면 {직원명, 직원ID} 텍스트요소에 값을 설정하고,
        // 결과레코드가 2건 이상이면 '직원찾기' 팝업창(findEmpPop)을 오픈
        //
        // (사용법) 
        // <input id="EMP_NM" name="EMP_NM" data-bind="value:EMP_NM" data-type="textinput" data-empid="EMP_ID" style="width:40%;" maxlength="10" />
        // <input id="EMP_ID" name="EMP_ID" data-bind="value:EMP_ID" data-type="textinput" data-disabled="true" disabled style="width:40%;" />
        //
        // @param    event  사용자명 텍스트입력(이벤트발생) 화면요소
        //
        findEmp : function(event) {
            if (13!=event.which) {
                return;
            }
            var elemid  = $(event.target).attr("id");
            var elemval = $(event.target).val();
            var empid   = $(event.target).data("empid"); //... data-empid="EMP_ID"
            var formid  = $(event.target).closest("form").attr("id");
            if ( $.PSNMUtils.isEmpty(empid) ) {
                $.PSNM.alert("E001", ["\n\n(원인) 직원정보를 설정할 화면요소 미지정!"]); //처리중 오류가 발생하였습니다! {0}
                $(event.target).focus();
                return false;
            }
            _debug("<PSNMAction.findEmp> 요소ID = [" + elemid + "] 값 = [" + elemval + "] empid = [" + empid + "] formid = [" + formid + "]");

            if ( $.PSNMUtils.isEmpty(elemval) ){
                $(event.target).val("");
                $("#" + empid).val("");
                return;
            }

            if ( !$.PSNMUtils.isEmpty(elemval) && $.trim(elemval).length<1 ) {
                alert("성명 항목은 1자 이상 입력하세요!"); //PSNM-E013 : {0} 항목은 {1}자 이상 입력하세요!
                $(event.target).focus();
                return;
            }

            var param = new Object();
                param["USER_NM"] = $.trim(elemval);
            //_debug("<PSNMAction.findEmp> param : " + JSON.stringify(param));

            document.body.style.cursor = 'wait';

            $.alopex.request('com.CODE@PBASE_pSearchEmpPop', {
                data: function() {
                    this.data.dataSet.fields = param;
                    //_debug("<PSNMAction.findEmp> <request.data> 파라미터 (this.data.dataSet.fields) : " + JSON.stringify(this.data.dataSet.fields));
                },
                success: function(res) {
                    document.body.style.cursor = 'default';

                    var dataList = res.dataSet.recordSets["gridemp"].nc_list; //결과레코드셋명
                    _debug("<PSNMAction.findEmp> 조회된 에이전트 : " + JSON.stringify(dataList));
                    if (1==dataList.length) {
                        $(event.target).val( dataList[0]["USER_NM"] );
                        $("#" + empid).val( dataList[0]["USER_ID"] );
                    }
                    else {
                        $("#" + empid).val("");
                        $a.popup({
                            url: "" + $.PSNM.COM_POP_URL_PREFIX + "findEmpPop.jsp",
                            data: param,
                            width: 900,
                            height: 500,
                            callback : function(returnVal) {
                                _debug("<PSNMAction.findEmp> returnVal : " + $.PSNMUtils.toString(returnVal));
                                if ( null!=returnVal && typeof returnVal == "object" ) {
                                    $(event.target).val( returnVal["USER_NM"] );
                                    $("#" + empid).val( returnVal["USER_ID"] );
                                }
                            }
                        });
                    }
                }
            });
        } //end-of findEmp()
        ,

        // 회원정보 찾기 팝업
        popFindUser : function(oParam, resultCallback) {

            $a.popup({
            	url: "" + $.PSNM.COM_POP_URL_PREFIX + "findUserPop.jsp",
                data: oParam,
				title : "회원정보찾기",
				width: $.PSNM.popWidth(800),
				height: $.PSNM.popHeight(800),
				windowpopup: false,
				iframe: true,
                callback : function(returnVal) {
                    if ( $.PSNMUtils.isNotEmpty(resultCallback) && typeof(resultCallback) == "function"  ) {
                        resultCallback.call(undefined, returnVal);
                        return;
                    }
                }
            });
        }
        ,
        // 회원정보 찾기 팝업 (임직원포함)
        popFindUser2 : function(oParam, resultCallback) {

            $a.popup({
            	url: "" + $.PSNM.COM_POP_URL_PREFIX + "findUserPop2.jsp",
                data: oParam,
				title : "회원정보찾기",
				width: 1000,
				height: 800,
				windowpopup: false,
				iframe: true,
                callback : function(returnVal) {
                    if ( $.PSNMUtils.isNotEmpty(resultCallback) && typeof(resultCallback) == "function"  ) {
                        resultCallback.call(undefined, returnVal);
                        return;
                    }
                }
            });
        }
        ,
        
        // 
        // '본사파트 찾기' 팝업창을 오픈하고, 선택된 데이터 처리 콜백함수 호출
        //
        // @param   funcCallback   콜백함수
        // @since   2015-01-12
        popFindHdqtPart : function(funcCallback) {
            var oOption = {
                url: "com/popup/findHdqtPartPop"
               ,data: {}
               ,width: 900
               ,height: 600
               ,title: "본사파트 찾기"
               ,callback: funcCallback
            };
            $a.popup(oOption);
        } //end-of popFindSaleDept()
        ,

        // 
        // '영업국 찾기' 팝업창을 오픈하고, 선택된 데이터 처리 콜백함수 호출
        //
        // @param   funcCallback   콜백함수
        // @since   2015-01-12
        popFindSaleDept : function(funcCallback) {
            var oOption = {
                url: "com/popup/findSaleDeptPop"
               ,data: {}
               ,width: 900
               ,height: 600
               ,title: "영업국 찾기"
               ,callback: funcCallback
            };
            $a.popup(oOption);
        } //end-of popFindSaleDept()
        ,

        // 
        // '권한그룹 찾기' 팝업창을 오픈하고, 선택된 데이터 처리 콜백함수 호출
        //
        // @param   funcCallback   콜백함수
        // @since   2015-01-12
        popFindAuthGrp : function(funcCallback) {
            var oOption = {
                url: "com/popup/findAuthGrpPop"
               ,data: {}
               ,width: 650
               ,height: 530
               ,title: "권한그룹 찾기"
               ,callback: funcCallback
            };
            $a.popup(oOption);
        } //end-of popFindAuthGrp()
        
        ,
        // 덧글을 조회 한다.
        setCmntData : function(CMNT_MGMT_ID, IS_HEAD, IS_MAINSCHD){
        	var id = CMNT_MGMT_ID != null ? CMNT_MGMT_ID : "";
        	var isHead = IS_HEAD != null ? IS_HEAD : ""; // 영업국업무의 회원정보페이지 호출 여부
        	var isMainSchd = IS_MAINSCHD != null ? IS_MAINSCHD : ""; // 주요일정 상세페이지 호출 여부
        	$.alopex.request("com.CMNT@PCMNT001_pSearchCmnt", {
        		data: {dataSet: {fields: {CMNT_MGMT_ID : id, IS_HEAD : isHead, IS_MAINSCHD : isMainSchd}}},
                success : function(res) {
                	var resultList = res.dataSet.recordSets.gridcmnt.nc_list;
                	$('#cmntList').setData({gridcmnt: resultList});
                	$("#count").html(res.dataSet.fields.count);
                	
                	if(res.dataSet.fields.count == 0) $("#cmntImg").hide();
                	
                	var date = new Date();
                	var today = (date).yyyymmdd();
                	
                	$.each(resultList, function(key, obj){
                	    $.each(obj, function(key, val){
                	    	if(key == "RGST_DTM"){
                	    		var rgstDtmArr = val.substr(0,10).split("-");
                	    		var rgstDtm = rgstDtmArr[0] + rgstDtmArr[1] + rgstDtmArr[2]; 
                	    		if((today - rgstDtm) <= 7){
                	    			$("#cmntImg").show();
                	    		}
                	    	}
                	    });
                	});
                }
            });
        }
        ,
        // 댓글을 저장한다.
        saveCmntData : function(CMNT_MGMT_ID, obj, IS_HEAD, IS_MAINSCHD){
        	if( getBytes($(obj).find("#CMNT_CTT").val()) == 0 ) {
    			alert("덧글을 입력해 주십시오.");
    			$(obj).find("#CMNT_CTT").focus();
    			return;
    		}
        	
        	if( getBytes($(obj).find("#CMNT_CTT").val()) > 2000 ) {
    			alert("덧글은 2000바이트(한글 1000글자) 이상 입력할 수 없습니다.");
    			$(obj).find("#CMNT_CTT").focus();
    			return;
    		}
    		
    		if( confirm("덧글을 등록하시겠습니까?") ){
    			$(obj).find("#CMNT_MGMT_ID").val(CMNT_MGMT_ID);
    			var requestData = $.PSNMUtils.getRequestData("cmnt");
            	
            	$.alopex.request("com.CMNT@PCMNT001_pInsertCmnt", {
                    data: requestData,
                    success: function(res) { 
                    	$(obj).find("#CMNT_CTT").val("");
                    	$.PSNMAction.setCmntData(CMNT_MGMT_ID, IS_HEAD, IS_MAINSCHD);
                    }
                });
    		}
        }
        ,
        // 댓글을 수정한다.
        updateCmntData : function(CMNT_MGMT_ID, obj, IS_HEAD, IS_MAINSCHD){
        	if( getBytes($(obj).find("#CMNT_CTT").val()) == 0 ) {
    			alert("덧글을 입력해 주십시오.");
    			$(obj).find("#CMNT_CTT").focus();
    			return;
    		}
        	
        	if( getBytes($(obj).find("#CMNT_CTT").val()) > 2000 ) {
    			alert("덧글은 2000바이트(한글 1000글자) 이상 입력할 수 없습니다.");
    			$(obj).find("#CMNT_CTT").focus();
    			return;
    		}
    		
    		if( confirm("덧글을 수정하시겠습니까?") ){
    			var data = $(obj).getData();
    			data["CMNT_CTT"] = $(obj).find("#CMNT_CTT").val();
    			if(IS_MAINSCHD == 'Y'){ /* 주요일정 덧글 */
    				data.IS_MAINSCHD = 'Y';
    				data.CMNT_OPEN_CL_CD = $(obj).find("#CMNT_OPEN_CL_CD_VAL").val()
    			}
            	$.alopex.request("com.CMNT@PCMNT001_pInsertCmnt", {
                    data: {dataSet: {fields: data}},
                    success: function(res) { 
                    	$.PSNMAction.setCmntData(CMNT_MGMT_ID, IS_HEAD, IS_MAINSCHD);
                    }
                });
    		}
        }
        ,
        // 댓글을 삭제한다.
        deleteCmntData : function(CMNT_MGMT_ID, obj, IS_HEAD){
    		if( confirm("덧글을 삭제하시겠습니까?") ){
    			var data = $(obj).getData();
    			
            	$.alopex.request("com.CMNT@PCMNT001_pDeleteCmnt", {
                    data: {dataSet: {fields: data}},
                    success: function(res) { 
                    	$.PSNMAction.setCmntData(CMNT_MGMT_ID, IS_HEAD);
                    }
                });
    		}
        }
    }
    ;
    //end of [$.PSNMAction = {]

})(jQuery);

// 댓글 수정/취소/삭제
function setCmntToggle(obj,str, IS_HEAD, IS_MAINSCHD){
	var subList 	= $(obj).parent().parent().parent();
	var content 	= subList.find("#cmntContent");
	var textArea 	= $("#CMNT_CTT").clone();
	var data 		= subList.getData();
	
	if($.PSNM.getSession("USER_ID") != data["RGSTR_ID"]){
		alert("본인 작성한 덧글만 수정,삭제 가능합니다.");
		return;
	}
	
	if(str == "modify"){
		subList.find("#cmntDelete").hide();
		subList.find("#cmntCancel").show()
		if(IS_MAINSCHD == "Y"){
			subList.find("#CMNT_OPEN_CL_CD_VAL").show();
		}
		var id = $(obj).attr("id");
		if(id == "cmntModify"){
			content.html(textArea);
			content.setData({CMNT_CTT:subList.find("#CMNT_CTT_VAL").val()});
			
			$(obj).attr("id","cmntSave");
		}else{
			$.PSNMAction.updateCmntData(data["CMNT_MGMT_ID"], subList, IS_HEAD, IS_MAINSCHD);
		}
	}else if(str == "cancel"){
		subList.find("#cmntDelete").show();
		subList.find("#cmntCancel").hide();
		if(IS_MAINSCHD == "Y"){
			subList.find("#CMNT_OPEN_CL_CD_VAL").hide();
		}
		content.html('<p class="cb_dsc"><span data-bind="text: CMNT_CTT"></span></p><p class="line"></p>');
		subList.setData({CMNT_CTT : data["CMNT_CTT"]});
		$(obj).prev().prev().prev().attr("id","cmntModify");
	}else{
		$.PSNMAction.deleteCmntData(data["CMNT_MGMT_ID"], subList, IS_HEAD);
	}
}
