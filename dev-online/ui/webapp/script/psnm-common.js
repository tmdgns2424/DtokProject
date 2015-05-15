/*
 * Copyright (c) 2014 PS&M. All rights reserved.
 */

(function ($) {

    var _init_msg = ""; //initialize() 에서 사용하는 메시지 문자열 
    var _menuCsYn = "";

    $.PSNM = {

        SESSION_USER_KEY : "psnm_session_user"
        ,
        SESSION_PARAM_KEY : "psnm_params"
        ,
        SESSION_PAGEAUTH_KEY : "psnm_page_auth_is_done" //본인인증이 필요한 메뉴를 위해 사용자가 본인인증하였는지 여부 @since 20015-03-11
        ,
        COM_POP_URL_PREFIX : "/view/com/popup/"
        ,

        initialize: function(id, param) {
            _debug("PSNM.initialize", "param[0] (id) = " + id, "param[1] (param) = " + JSON.stringify(param));

            var sOpenMenuParam = sessionStorage.getItem($.PSNM.SESSION_PARAM_KEY); //
            var oOpenMenuParamAll = JSON.parse(sOpenMenuParam);
            var oOpenMenuParam = oOpenMenuParamAll["_menu"]; //메뉴가 클릭되면 세션에 메뉴정보가 저장되었음

            if ( "A"!=oOpenMenuParam["RSTRCT_CL"] && !this._check_menu(oOpenMenuParam) ) {
                $a.navigate( _MAINPAGE_URL ); //메뉴제한여부를 체크함.
            }
            this._log_menu(oOpenMenuParam); //시스템사용로그 등록

            _debug("PSNM.initialize", "SESSION_PARAM_KEY : " + $.PSNM.SESSION_PARAM_KEY);
            _debug("PSNM.initialize", "SESSION_PARAM_VAL[_menu] : " + JSON.stringify(oOpenMenuParam));
            

            if ( $.PSNMUtils.isNotEmpty(oOpenMenuParam) ) { //(예) {"MENU_ID":"4001","MENU_NM":"SAMPLE","MENU_URL":"com/annce/annceList","SUP_MENU_ID":"4100","SUP_MENU_NM":"회원정보","BRWS_SEQ":"1","MENU_TYP_CD":"3","BLTN_BRD_ID":"","AUTH_TYP_CD":"W","TOP_MENU_ID":4000,"TOP_MENU_NM":"나의 D-tok"}
                $(".txt6_img .a2").text( oOpenMenuParam["TOP_MENU_NM"] );
                $(".txt6_img .a4").html( "<b>" + oOpenMenuParam["SUP_MENU_NM"] + "</b>");
                var menuUrl = oOpenMenuParam["MENU_URL"];
                if ( id.indexOf(menuUrl)>=0 ) {
                    $(".txt6_img #sub-title").text( oOpenMenuParam["MENU_NM"] );
                }
                $.PSNM.setButtonsByAuth( oOpenMenuParam["AUTH_TYP_CD"] );
                
                _menuCsYn = oOpenMenuParam["CS_YN"];
            }

            _init_msg = "<PSNM.initialize> << PSNM initialize >>\n\n";
            //_init_msg+= "\tparam[0] : '" + id + "'\n";
            //_init_msg+= "\tparam[1] : " + JSON.stringify(param) + "\n";

            this.setOrgSelectBox(); //this.initOrgSelectBox();
            this.initLeftSubMenu();
            this.setEventTopMenu();

            $("#footer .menu-link").click(function() {
                var menuid = $(this).data("menuid");
                $.PSNM.openMenuLink({"menuid":menuid});
            });
            $("#quick-link-list .menu-link").click(function() {
                var menuid = $(this).data("menuid");
                $.PSNM.openMenuLink({"menuid":menuid});
            });

            _debug("PSNM.initialize", "initialized ---------------------------------------------------------");
            _init_msg = "";
        } //end of [initialize: function]
        ,
        initLeftSubMenu : function() {
            //좌측 메뉴 슬라이드 처리
            $("#left_bar_icon").click(function() {
                var options = {};
                $("#left_bar_load").show("slide", options, 200);
                $(this).hide();
            });
            $("#left_bar_icon2").click(function() {
                var options = {};
                $.PSNM.hideLeftMenuArea();
            });

            //현재 메뉴 정보를 세션스토리지 psnm_params._menu 에 저장되어있음(@see openMenuLink)
            var sPsnmParams = sessionStorage.getItem($.PSNM.SESSION_PARAM_KEY);

            if ( null==sPsnmParams || sPsnmParams.indexOf("_menu")<0 ) {
                _error("현재 메뉴정보를 참조할 수 없습니다!\n\n(주의) 좌측메뉴영역을 설정하지 못합니다!");
                return;
            }

            var oMenuInfo = JSON.parse(sPsnmParams)["_menu"]; //alert("oMenuInfo\n\n" + JSON.stringify(oMenuInfo));
            var currTopMenuId = oMenuInfo.TOP_MENU_ID;
            var currTopSubMenuTreeData = sessionStorage.getItem("top-menu-" + currTopMenuId);
                currTopSubMenuTreeData = JSON.parse(currTopSubMenuTreeData);
            _debug("<PSNM.initLeftSubMenu> 현TopMenuId = [" + currTopMenuId + "], 현TopSubMenuTreeData = " + (null==currTopSubMenuTreeData ? -1 : currTopSubMenuTreeData.length));

            if ( $.PSNMUtils.isNotEmpty(currTopMenuId) ) {
                $.PSNM.setTopMenuStyle(oMenuInfo);
                $.PSNM.setLeftSubMenu(oMenuInfo, currTopSubMenuTreeData);
            }
            //_debug("<PSNM.initLeftSubMenu> 메뉴 링크 설정함.");
        }
        ,
        openMenuLink : function(oLinkInfo, oParam) {
            if (null==oLinkInfo || undefined==oLinkInfo) {
                alert("(오류) 메뉴정보가 없습니다.");
                return;
            }
            if ( null==oParam || undefined==oParam ) {
                oParam = new Object();
            }

            var oMenuFound = null;
            var sMenuId = ''; //4001
            var sUrl    = '';

            if ( typeof oLinkInfo == "object" ) {
                sMenuId = oLinkInfo["menuid"];
                sUrl    = oLinkInfo["url"];
            }
            else if ( typeof oLinkInfo == "string" ) {
                if ( isNaN(parseInt(oLinkInfo)) ) {
                    sUrl    = oLinkInfo;
                }
                else {
                    sMenuId = oLinkInfo;
                }
            }
            _debug("<PSNM.openMenuLink> 1. 이동할 메뉴ID : [" + sMenuId + "], 메뉴URL = [" + sUrl + "]");

            var sTopMenu = sessionStorage.getItem("top-menu");
            var aTopMenu = JSON.parse(sTopMenu); //배열

            var cntTopMenu = $(".gnb ul li").length;
            if (cntTopMenu<1) {
                alert("(오류) 상단메뉴정보가 없습니다.");
                return;
            }
            _debug("<PSNM.openMenuLink> 2. 탑메뉴의 개수 = " + cntTopMenu);
            _debug("<PSNM.openMenuLink> 3. alopex_parameters : " + $a.session("alopex_parameters"));

            oMenuFound = $.PSNMUtils.isNotEmpty(sMenuId) ? this.getMenuInfoById(sMenuId) : this.getMenuInfoByUrl(sUrl); //메뉴ID 또는 메뉴URL로 메뉴정보 탐색!
            if ( null==oMenuFound ) {
                alert("메뉴에 대한 권한이 없습니다!"); //alert("메뉴정보를 찾을 수 없습니다!\n\n(참조) " + JSON.stringify(oLinkInfo));
                return;
                //oMenuFound = { "MENU_URL" : sUrl };
            }

            //본인인증이 필요한 메뉴인지 체크(since 20015-03-11) ---//
            if ( false == $.PSNM._checkPageAuth(oMenuFound) ) {
                $a.navigate(_CTX_PATH + "view/pageauth.jsp", oMenuFound);
                return;
            }
            // ----------------------------------------------------//

            {
                sUrl = oMenuFound["MENU_URL"];

                //현재 메뉴 정보를 세션스토리지 psnm_params._menu 에 저장해둠
                sessionStorage.setItem($.PSNM.SESSION_PARAM_KEY, JSON.stringify({ "_menu": oMenuFound}) ); //SESSION_PARAM_KEY : "psnm_params"
                //$a.session("alopex_parameters", ""); //메뉴이동시 세션의 파라미터는 모두 삭제함
            }

            _debug("<PSNM.openMenuLink> 4. 이동할 메뉴ID : [" + sMenuId + "], 메뉴URL = [" + sUrl + "], 메뉴이동 param : " + JSON.stringify(oParam));
            //alert("<PSNM.openMenuLink>\n\n- 메뉴ID = [" + sMenuId + "]\n- 메뉴URL = [" + sUrl + "]\n\n- param : " + JSON.stringify(oParam) + "");

            if ( sUrl.indexOf(_CTX_PATH + "view/") < 0 ) {
                sUrl = _CTX_PATH + "view/" + sUrl;
            }
            if ( 0>=sUrl.indexOf(".jsp") ) { //if ( !sUrl.endsWith(".jsp") ) {
                sUrl = sUrl + ".jsp";
            }
            $a.navigate(sUrl, oParam);
        }
        ,
        openLink : function(sLinkUrl, oParam, bAlopexSessionDataClear) {
            if ( $.PSNMUtils.isNotEmpty(bAlopexSessionDataClear) && true==bAlopexSessionDataClear ) {
                $a.session("alopex_parameters", ""); //메뉴이동시 세션의 파라미터는 모두 삭제함
            }
            $a.navigate(sLinkUrl, oParam);
        }
        ,
        _checkPageAuth : function(oMenu) { //본인인증이 필요한 메뉴인지 체크(since 20015-03-11)
            if (null==oMenu) return true;
            var authObjYn = oMenu["AUTH_OBJ_YN"];

            if (null!=authObjYn && "Y"!=authObjYn) {
                return true;
            }

            var isAuthed = sessionStorage.getItem($.PSNM.SESSION_PAGEAUTH_KEY); //='psnm_page_auth_is_done'
            if (null!=isAuthed && "Y"==isAuthed) {
                return true;
            }
            return false; //본인인증을 해야함!
        }
        ,
        hideLeftMenuArea : function() {
            $("#left_bar_load").hide();
            $("#left_bar_icon").show();
        }
        ,
        setEventTopMenu : function() {
            //탑메뉴클릭 처리
            $(".gnb a.topmenu").click(function() { //click | mouseover
                var menuid = $(this).data("menuid");
                _debug ("<PSNM.setEventTopMenu> 탑 menuid = " + menuid);

                var subMenuTreeData = sessionStorage.getItem("top-menu-" + menuid);
                _debug ("<PSNM.setEventTopMenu> 탑메뉴ID = " + menuid + ", 하위메뉴TREE데이터(session) : " + subMenuTreeData + "");

                if ( $.PSNMUtils.isEmpty(subMenuTreeData) && "9999"!=menuid ) {
                    $.alopex.request('com.MAINLOGIN@PLOGIN001_pSearchMenuTree', {
                        showProgress:false,
                        data: {
                            dataSet: {
                                fields: {
                                    SUP_MENU_ID : menuid /*탑메뉴ID*/
                                }
                            }
                        },
                        success: function(res) {
                            var rsMenuList = res.dataSet.recordSets["gridmenu"].nc_list;
                            sessionStorage.setItem("top-menu-" + menuid, JSON.stringify(rsMenuList));
                            $.PSNM.displayTopSubMenu(menuid, rsMenuList);
                        }
                    });
                }
                else {
                    $.PSNM.displayTopSubMenu(menuid, JSON.parse(subMenuTreeData));
                }
            });

            $("body").click(function(e) {
                if ( "A" == e.target.nodeName && $(e.target).parents().hasClass("gnb") ) {
                    ;
                }
                else {
                    $("#sub-menu-div > ul").hide(); //gnb 하위메뉴 영역을 감춤
                    $("#quick-link-list").hide();
                }
            });
            $("#top-menu-9999").click(function(e) {
                $("#sub-menu-div > ul").hide(); //[바로가기] 클릭시, gnb 하위메뉴 영역을 감춤
                if ( $("#quick-link-list").is(":visible") )
                    $("#quick-link-list").hide();
                else
                    $("#quick-link-list").show();
            });
        }
        ,
        displayTopSubMenu : function(topMenuId, arrSubMenuData) {
            if ( $.PSNMUtils.isEmpty(arrSubMenuData) ) {
                return;
            }
            $("#quick-link-list").hide();
            _debug("<PSNM.displayTopSubMenu> 메뉴ID = [" + topMenuId + "], 하위메뉴데이터수 : " + arrSubMenuData.length);
            _debug("<PSNM.displayTopSubMenu> #sub-menu-dropdown-" + topMenuId + ".length : " + $("#sub-menu-div #sub-menu-dropdown-" + topMenuId).length);

            $.PSNM.hideLeftMenuArea(); //좌측메뉴영역은 무조건 감춤

            if ( $("#sub-menu-div #sub-menu-dropdown-" + topMenuId).length < 1 ) {
                var sSubMenuUl = '<ul id="sub-menu-dropdown-' + topMenuId + '" '; //data-type="dropdown" data-converted="true"
                    sSubMenuUl+= ' class="af-dropdown af-default" style="display:none !important;position: absolute; top:-10px; display: block;width:100%;">\n';
                var countSecondLevelMenu = 0;
            
                $.each(arrSubMenuData, function(key, menuData) {
                    var _type    = menuData["MENU_TYP_CD"]; //메뉴타입코드 : 2, 3
                    var _menuid  = menuData["MENU_ID"];
                    var _menunm  = menuData["MENU_NM"];
                    var _menuurl = menuData["MENU_URL"];

                    if ( "2"==_type ) {
                        if (countSecondLevelMenu>0) {
                            sSubMenuUl += '    </ul>\n';
                            sSubMenuUl += '</li>\n';
                        }
                        sSubMenuUl += '<li class="gnb-sub"><strong>' + _menunm + '</strong>\n'; //<li class="gnb-sub"><strong>회원관리</strong>
                        sSubMenuUl += '    <ul>\n';
                        countSecondLevelMenu ++;
                    }
                    else if ( "3"==_type ) {
                        var lnk3 = '        <li><a onclick="javascript:$.PSNM.openMenuLink(\'' + _menuid + '\');">&bull; ' + _menunm + '</a></li>\n';
                        sSubMenuUl += lnk3;
                    }
                });
                if (countSecondLevelMenu>0) {
                    sSubMenuUl += '    </ul>\n';
                    sSubMenuUl += '</li>\n';
                }
                //_debug(sSubMenuUl);
                $("#sub-menu-div").append(sSubMenuUl);
            }

            if ( $("#sub-menu-div #sub-menu-dropdown-" + topMenuId).is(":visible") ) {
                $("#sub-menu-div > ul").hide();
                $("#sub-menu-div #sub-menu-dropdown-" + topMenuId).hide();
            }
            else {
                $("#sub-menu-div > ul").hide();
                $("#sub-menu-div #sub-menu-dropdown-" + topMenuId).show();
            }
        }
        ,
        displayTopSubMenuOLD : function(topMenuId, arrSubMenuData) {
            if ( $.PSNMUtils.isEmpty(arrSubMenuData) ) {
                return;
            }
            _debug("<PSNM.displayTopSubMenu> 메뉴ID = [" + topMenuId + "], 하위메뉴데이터 : \n" + JSON.stringify(arrSubMenuData));
            _debug("<PSNM.displayTopSubMenu> 하위메뉴개수 = " + arrSubMenuData.length);
            _debug("<PSNM.displayTopSubMenu> #sub-menu-dropdown-" + topMenuId + ".length : " + $("#sub-menu-div #sub-menu-dropdown-" + topMenuId).length);

            if ( $("#sub-menu-div #sub-menu-dropdown-" + topMenuId).length < 1 ) {
                //$("#sub-menu-div").append('<ul id="sub-menu-dropdown-' + topMenuId + '" data-type="dropdown" data-base="#top-menu-' + topMenuId + '"></ul>');
                var sSubMenuUl = '<ul id="sub-menu-dropdown-' + topMenuId + '" data-type="dropdown" data-base="#top-menu-' + topMenuId + '">';
                var countSecondLevelMenu = 0;

                $.each(arrSubMenuData, function(key, menuData) {
                    //_debug("- 메뉴정보 : " +  JSON.stringify(menuData));
                    var _type    = menuData["MENU_TYP_CD"]; //메뉴타입코드 : 2, 3
                    var _menuid  = menuData["MENU_ID"];
                    var _menunm  = menuData["MENU_NM"];
                    var _menuurl = menuData["MENU_URL"];

                    if ( "2"==_type ) {
                        if (countSecondLevelMenu>0) {
                            sSubMenuUl += '<li class="af-group-header"><hr></li>';
                        }
                        sSubMenuUl += '<li class="af-group-header"><a>' + _menunm + '</a></li>';
                        countSecondLevelMenu ++;
                    }
                    else if ( "3"==_type ) {
                        var lnk3 = '<li><a onclick="javascript:$.PSNM.openMenuLink(\'' + _menuid + '\');">' + _menunm + '</a></li>';
                        //_debug("---- 메뉴정보3 : " +  lnk3);
                        sSubMenuUl += lnk3;
                    }
                });
                $("#sub-menu-div").append(sSubMenuUl);

                $("#sub-menu-div #sub-menu-dropdown-" + topMenuId).open(); //탑메뉴의 dropdown 메뉴를 생성한후 오픈
            }
            $.PSNM.hideLeftMenuArea();
        }
        ,
        setTopMenuStyle : function(oMenuInfo) {
            var topMenuId = oMenuInfo.TOP_MENU_ID;
            if ( $.PSNMUtils.isEmpty(topMenuId) ) {
                return;
            }
            $(".gnb a.topmenu").removeClass("on");
            $(".gnb a#top-menu-" + topMenuId).addClass("on");
        }
        ,
        setLeftSubMenu : function(oMenuInfo, arrSubMenuData) {
            var topMenuId = oMenuInfo.TOP_MENU_ID;
            if ( $.PSNMUtils.isEmpty(topMenuId) ) {
                _error("PSNM.setLeftSubMenu", "메뉴정보", JSON.stringify(oMenuInfo));
                return;
            }
            var topMenuNm = oMenuInfo.TOP_MENU_NM; //$(".gnb ul li a[data-menuid='" + topMenuId + "']").text();
            var supMenuId = oMenuInfo.SUP_MENU_ID;
            var supMenuCount = 0; //중메뉴 개수
            var supMenuIndex = -1; //중메뉴index

            $("#psnmnav-topmenu-name").text(topMenuNm);
            $("#psnmnav-topmenu-name").data("menuid", topMenuId);
            $("#psnmnav-accordion").remove();

            {
                var sSubMenuUl = '';
                    sSubMenuUl += '<ul id="psnmnav-accordion" data-type="accordion">';
                var countSecondLevelMenu = 0;

                $.each( jQuery.isArray(arrSubMenuData) ? arrSubMenuData : JSON.parse(arrSubMenuData)
                      , function(key, menuData) {
                    var _type    = menuData["MENU_TYP_CD"]; //메뉴타입코드 : 2(중메뉴), 3(화면)
                    var _menuid  = menuData["MENU_ID"];
                    var _menunm  = menuData["MENU_NM"];
                    var _menuurl = menuData["MENU_URL"];

                    if ( "2"==_type ) {
                        if (countSecondLevelMenu>0) {
                            sSubMenuUl += '</ul></li>';
                        }
                        sSubMenuUl += '\n<li><a>' + _menunm + '</a><ul>';
                        countSecondLevelMenu ++;
                        if ( _menuid == supMenuId ) {
                            supMenuIndex = supMenuCount;
                        }
                        supMenuCount++;
                    }
                    else if ( "3"==_type ) {
                        //sSubMenuUl += '<li><a onclick="javascript:$.PSNM.openMenuLink(\'' + _menuurl + '\');">' + _menunm + '</a></li>\n';
                        sSubMenuUl += '<li><a onclick="javascript:$.PSNM.openMenuLink(\'' + _menuurl + '\');">';
                        if (_menuid == oMenuInfo.MENU_ID ) {
                            sSubMenuUl += '<b>' + _menunm + '</b></a></li>\n';
                        }
                        else {
                            sSubMenuUl += '' + _menunm + '</a></li>\n';
                        }
                    }
                });
                sSubMenuUl += '</ul></li>';
                sSubMenuUl += '</ul>';
                $("#psnmnav-area").append( $.trim(sSubMenuUl) );
            }
            $("#psnmnav-accordion").data("type", "accordion");
            $("#psnmnav-accordion").collapseAll(); // expandAll();
            if ( supMenuIndex>=0 ) {
                $("#psnmnav-accordion").expand(supMenuIndex);
                $("#psnmnav-accordion > li:eq(" + supMenuIndex + ")").addClass("af-accordion-expand");
            }
        }
        ,
        initOrgSelectBox : function() {
            // select 객체중 본사팀, 본사파트, 영업국은 _onchange_... 이벤트 핸들러를 지정함
            $("body select").each(
                function(index) {
                    var selElemId = $(this).attr("id");
                    if ( "HDQT_TEAM_ORG_ID"==selElemId || "HDQT_PART_ORG_ID"==selElemId || "SALE_DEPT_ORG_ID"==selElemId || "SALE_TEAM_ORG_ID"==selElemId ) {
                        $(this).change( eval("_onchange_" + selElemId + "") ); //(예) _onchange_HDQT_PART_ORG_ID
                        //_debug("<PSNM.initOrgSelectBox> index=", index, "ID=" + $(this).attr("id"));
                    }
                }
            );
        }
        ,
        setButtonsByAuth: function(sAuthTypCd) {
            _debug("$.PSNM.setButtonsByAuth", sAuthTypCd);
            if ( $.PSNMUtils.isEmpty(sAuthTypCd) ) { //"AUTH_TYP_CD":"W"
                return;
            }

            if ( "R"==sAuthTypCd ) {
                $('[data-authtype="R"]').filter(function() {
                    var element = $(this);
                    if (element.css('display') == 'none') {
                        return false;
                    }
                    return true;
                }).show(); //읽기권한
                $('[data-authtype="W"]').hide(); //쓰기권한
            }
            else if ( "W"==sAuthTypCd ) {
                $('[data-authtype="R"]').filter(function() {
                    var element = $(this);
                    if (element.css('display') == 'none') {
                        return false;
                    }
                    return true;
                }).show(); //읽기권한
                $('[data-authtype="W"]').filter(function() {
                    var element = $(this);
                    if (element.css('display') == 'none') {
                        return false;
                    }
                    return true;
                }).show(); //쓰기권한
            }
            else {
                _error("$.PSNM.setButtonsByAuth", sAuthTypCd, "잘못된 권한타입코드!");
            }
        }
        ,
        getSession : function(sessionKey) {
            var sessionUserInfo = sessionStorage.getItem($.PSNM.SESSION_USER_KEY);
            if ( null==sessionUserInfo ) {
                //_debug("<PSNM.getSession> no session user info. so find the data : sessionKey = [%s]", sessionKey);
                $.alopex.request('com.MAINLOGIN@PLOGIN001_pSessionUser', {
                    async: false,
                    data: { dataSet: { fields: {} } },
                    success: function(res) {
                        var ssUserInfo = res.dataSet.fields;
                        delete ssUserInfo['top-menu-rs'];
                        sessionStorage.setItem($.PSNM.SESSION_USER_KEY, JSON.stringify(ssUserInfo));
                        sessionUserInfo = sessionStorage.getItem($.PSNM.SESSION_USER_KEY);
                        //_debug("<PSNM.getSession> session user info(조회됨) : " + sessionUserInfo);
                    }
                });
            }

            var oUser = JSON.parse(sessionUserInfo);
            
            if ( $.PSNMUtils.isEmpty(sessionKey) ) {
                return oUser;
            }
            else {
                return oUser[""+sessionKey];
            }
        }
        ,
        message: function(type, msg) {
            if (!msg) {
                _debug('<PSNM.message> 메시지를 입력해주세요.');
                return;
            }
            var imagepath = "";
            //var icon;
            var markup = '<div data-type="dialog" class="messagebox container"><div class="grid16">' + 
                         '<div class="grid4 image"><img src="' + imagepath + type + '.png" class="' + type + '"/></div>' +
                         '<div class="grid12 text"><label id="text"></label></div></div>' +
                         '<div class="grid6 prefix5"><button data-type="button">' + 
                         '<span data-type="icon" data-addclass="chevron-right" data-position="right"></span>' + 
                         'OK</button></div>' +
                         '</div>';
            var $dialog = $(markup).appendTo(document.body).convert().open({
                modal : true
            });

            var $label = $dialog.find('#text');
                $label.html(msg.replace('\n', '<br>'));
                $label.css('margin-top', (($label.height()-10) * -1/2) + 'px');
            
            $dialog.find('button').on('tap', function(e){
                $dialog.close().remove();
            }).focus();
        }//end of [message: function]
        ,

        //
        // 메시지ID로 해당 메시지 문자열을 반환. 대체할 문자열 {0}, {1}, .. 이 있으면 대체후 반환
        //
        //@param    sMesgId     메시지ID (예) 'PSNM-I001' 또는 'I001'
        //@param    aMesgParam  메시지문자열에 대체할 텍스트 배열 (예) [ "매개변수1", "매개변수2" ]
        //@return   메시지 문자열과 입력된 매개변수의 문자열값을 대체하여 최종 메시지 문자열 반환
        //
        msg : function(sMesgId, aMesgParam) {
            //"MESSAGE_ID":"PSNM-E011", "MESSAGE_NAME":"{0} 데이터가 없습니다!"
            if ( $.PSNMUtils.isEmpty(sMesgId) ) { return ""; }

            var mid = "PSNM-" + sMesgId.replace(/PSNM-/, "");
            var mmm = "";
            var len = null==aMesgParam ? -1 : aMesgParam.length;

            for(var i=0; i<_PSNM_MESSAGE.length; i++) {
                var oMesg = _PSNM_MESSAGE[i];
                if ( mid == oMesg["MESSAGE_ID"] ) {
                    mmm = oMesg["MESSAGE_NAME"];
                    break;
                }
            }
            if ( $.PSNMUtils.isEmpty(mmm) ) { //메시지ID가 아닌경우 전달된 문자열을 그대로 반환
                _debug("msg", "메시지 없음", sMesgId, mid);

                var nnn = sMesgId;
                nnn = nnn.replace(/\{(\d+)\}/g, function(match, key, value) {
                    return aMesgParam[key];
                });
                return nnn;
            }
            if ( $.PSNMUtils.isEmpty(aMesgParam) ) { return mmm; }

            var pattern = /\{(\d+)\}/g; //var pattern = new RegExp(fromStr, "gi");
            mmm = mmm.replace(pattern, function(match, key, value) {
                return aMesgParam[key];
            });
            return mmm;
        }
        ,

        //
        // 메시지ID로 해당 메시지 문자열 찾아서 alert 표시함
        //
        //@param    sMesgId     메시지ID (예) 'PSNM-I001' 또는 'I001'
        //@param    aMesgParam  메시지문자열에 대체할 텍스트 배열 (예) [ "매개변수1", "매개변수2" ]
        //@param    returnValue 반환할 값
        //@return   메시지를 찾아서 alert 한 후 값을 반환.
        //
        alert : function(sMesgId, aMesgParam, returnValue) {
            var mmm = $.PSNM.msg(sMesgId, aMesgParam);
            _debug("PSNM.alert", "메시지", mmm, "입력값", sMesgId, JSON.stringify(aMesgParam));
            alert(mmm);
            if ( $.PSNMUtils.isEmpty(returnValue) ) return; //없으면 그냥 반환
            return returnValue;
        }
        ,

        //
        // 메시지ID로 해당 메시지 문자열 찾아서 confirm 표시 후 사용자의 선택값(true or false)을 반환.
        //
        //@param    sMesgId     메시지ID (예) 'PSNM-I001' 또는 'I001'
        //@param    aMesgParam  메시지문자열에 대체할 텍스트 배열 (예) [ "매개변수1", "매개변수2" ]
        //@return   메시지를 찾아서 confirm 한 후 사용자의 선택값(true or false)을 반환.
        //
        confirm : function(sMesgId, aMesgParam) {
            var mmm = $.PSNM.msg(sMesgId, aMesgParam);
            _debug("PSNM.confirm", "메시지", mmm, "입력값", sMesgId, JSON.stringify(aMesgParam));

            var returnValue = confirm(mmm);

            return returnValue;
        }
        ,

        //
        // $.alopex.request의 성공(success) 이더라도 서버측에서 fail 처리된 경우
        // alert 오류 메시지 한 후, false 값을 반환. 성공시 true 값 반환
        //
        //@param    res     서버측 응답
        //@return   서버측 오류이면 false를 반환. 성공이면 true 반환
        //
        success : function(res) {
            _debug("PSNM.success", "response.message", JSON.stringify(res.dataSet.message));
            if ( "FAIL" == res.dataSet.message.result ) {
                //$.PSNM.alert( res.dataSet.message.messageName ); //오류메시지 from 서버
                return false;
            }
            return true;
        }
        ,

        //로그아웃 처리
        logout: function() {
            _debug("<PSNM.logout> 시작 ... ");

            sessionStorage.removeItem($.PSNM.SESSION_USER_KEY);
            sessionStorage.removeItem($.PSNM.SESSION_PARAM_KEY);
            sessionStorage.removeItem($.PSNM.SESSION_PAGEAUTH_KEY);
            sessionStorage.removeItem("alopex_parameters");
            Object.keys(sessionStorage)
                .filter(function(k) { return /top-menu/.test(k); }) //sessionStorage.removeItem("top-menu-1000");
                .forEach(function(k) {
                    _debug("<PSNM.logout>", "remove [" + k + "]");
                    sessionStorage.removeItem(k);
                });
            Object.keys(sessionStorage)
                .filter(function(k) { return /psnm-code/.test(k); }) //sessionStorage.removeItem("psnm-code-DSM_RCY_TYP_CD");
                .forEach(function(k) {
                    _debug("<PSNM.logout>", "remove session data [" + k + "]");
                    sessionStorage.removeItem(k);
                });

            $.alopex.request('com.MAINLOGIN@PLOGIN001_pLogout', {
                url: _CTX_PATH + "logout.jmd",
                data: {
                    dataSet: {
                        fields: {},
                        recordSets: {}
                    }
                },
                success: function(res) { 
                    sessionStorage.removeItem("top-menu");
                    _debug("<PSNM.logout> after remove : sessionStorage[top-menu] : " + sessionStorage.getItem("top-menu") );
                    if ( $.PSNMUtils.isMobile() ) {
                        $a.navigate("/mobile.jsp");
                    }
                    else {
                        $a.navigate("/index.jsp");
                    }
                }
            });
        }
        ,
        resetCondition: function(sFormId, bDoClearAlopexParam) {
            sFormId = sFormId.replace(/^#/, "");
            $("#" + sFormId + " input").val("");
            $("#" + sFormId + " select").setSelected("");
            $("#" + sFormId + " input:radio").removeAttr("checked");
            $("#" + sFormId + " input:checkbox").removeAttr("checked");

            if ( null==bDoClearAlopexParam || undefined==bDoClearAlopexParam || bDoClearAlopexParam) {
                $a.session("alopex_parameters", "");
            }
            var oVal = $("#" + sFormId + "").getData({selectOptions:false})
            _debug("<PSNM.resetCondition> 초기화후 #" + sFormId + " 값들 : " + JSON.stringify(oVal));
        }
        ,
        //
        // 입력된 메뉴ID로 현재 [세션스토리지]에 저장되어 있는 메뉴정보를 탐색하여 객체로 반환. 없으면 null을 반환
        //
        //@param    sMenuId 찾으려는 메뉴ID
        //@return   현재 세션스토리지에 저장되어 있는 메뉴정보
        //@since    2014-12-05
        getMenuInfoById : function(sMenuId) {
            if ( null==sMenuId || undefined==sMenuId ) {
                alert("메뉴정보를 찾을 수 없습니다.\n\n(원인) NULL PARAMETER!");
                return null;
            }

            var oMenuFound = null;
            {
                //화면 상단(default_header)의 gnb 영역(탑메뉴영력)을 참조함.
                $(".gnb ul li a").each(function(index) {
                    var _topmenuid = $(this).data("menuid");
                    var _topmenunm = $(this).text();
                    var _submenudata = sessionStorage.getItem("top-menu-" + _topmenuid);

                    if ( $.PSNMUtils.isNotEmpty(_submenudata) ) {
                        //_debug("<PSNM.getMenuInfoById> 탑메뉴ID = " +_topmenuid + ", 하위메뉴(문자열길이) = " + _submenudata.length);

                        var aSubMenuList = JSON.parse(_submenudata);
                        for (var i=0; i<aSubMenuList.length; i++) {
                            var oSubMenu = aSubMenuList[i];
                            //_debug("<PSNM.getMenuInfoById> 메뉴데이터 : " + JSON.stringify(oSubMenu));
                            if ( sMenuId == oSubMenu["MENU_ID"] ) { //(탐색됨)
                                oMenuFound = aSubMenuList[i];
                                break;
                            }
                        }
                    }
                    if ( null!=oMenuFound ) {
                        oMenuFound["TOP_MENU_ID"] = _topmenuid;
                        oMenuFound["TOP_MENU_NM"] = _topmenunm;
                        //_debug("<PSNM.getMenuInfoById> 메뉴정보 = " + JSON.stringify(oMenuFound));
                        return false; //break;
                    }
                });
            }
            _debug("<PSNM.getMenuInfoById> 탐색된 메뉴정보 = " + JSON.stringify(oMenuFound));
            return oMenuFound;
        }
        ,
        //
        // 입력된 메뉴URL로 현재 [세션스토리지]에 저장되어 있는 메뉴정보를 탐색하여 객체로 반환. 없으면 null을 반환
        //
        //@param    sMenuUrl 찾으려는 메뉴URL
        //@return   현재 세션스토리지에 저장되어 있는 메뉴정보
        //@since    2014-12-05
        getMenuInfoByUrl : function(sMenuUrl) {
            if ( null==sMenuUrl || undefined==sMenuUrl ) {
                alert("메뉴정보를 찾을 수 없습니다.\n\n(원인) NULL PARAMETER!");
                return null;
            }

            var oMenuFound = null;
            {
                //화면 상단(default_header)의 gnb 영역(탑메뉴영력)을 참조함.
                $(".gnb ul li a").each(function(index) {
                    var _topmenuid = $(this).data("menuid");
                    var _topmenunm = $(this).text();
                    var _submenudata = sessionStorage.getItem("top-menu-" + _topmenuid);

                    if ( $.PSNMUtils.isNotEmpty(_submenudata) ) {
                        //_debug("<PSNM.getMenuInfoByUrl> 탑메뉴ID = " +_topmenuid + ", 하위메뉴(문자열길이) = " + _submenudata.length);

                        var aSubMenuList = JSON.parse(_submenudata);
                        for (var i=0; i<aSubMenuList.length; i++) {
                            var oSubMenu = aSubMenuList[i];
                            //_debug("<PSNM.getMenuInfoByUrl> 메뉴데이터 : " + JSON.stringify(oSubMenu));
                            if ( sMenuUrl == oSubMenu["MENU_URL"] ) { //(탐색됨)
                                oMenuFound = aSubMenuList[i];
                                break;
                            }
                        }
                    }
                    if ( null!=oMenuFound ) {
                        oMenuFound["TOP_MENU_ID"] = _topmenuid;
                        oMenuFound["TOP_MENU_NM"] = _topmenunm;
                        //_debug("<PSNM.getMenuInfoByUrl> 메뉴정보 = " + JSON.stringify(oMenuFound));
                        return false; //break;
                    }
                });
            }
            _debug("<PSNM.getMenuInfoByUrl> 탐색된 메뉴정보 = " + JSON.stringify(oMenuFound));
            return oMenuFound;
        }
        ,

        popSessionUser : function() {
            var sessionUserInfo = $.PSNM.getSession();
            //_debug("<popSessionUser> " + JSON.stringify(sessionUserInfo));
            var oParam = new Object();
            var oOption = {
                url: "com/popup/mainUserPop"
              , data: oParam
              , width: 800
              , height: 600
              , title: "회원정보(개발용)"
            };
            $a.popup(oOption);
        }
        ,

        //입력된 각 폼ID의 입력값을 검증하여 오류가 없으면 true를 반환
        isValid : function() {
            for(var i in arguments) {
                var sFormId = arguments[i];
                    sFormId = sFormId.replace(/#/, "");

                var validator = $("#" + sFormId).validator();
                if ( !validator.validate() ) {
                    var errormessages = validator.getErrorMessage();
                    for(var name in errormessages) {
                        for(var i=0; i < errormessages[name].length; i++) {
                            $.PSNM.alert(errormessages[name][i]);
                            $("#" + name).focus();
                            return false; //여기서 반환
                        }
                    }
                }
            }
            return true;
        }
        ,

        //입력된 각 INPUT ID의 입력값을 검증하여 오류가 없으면 true를 반환
        isValidInput : function() {
            for(var i in arguments) {
                var inputId = arguments[i];
                	inputId = inputId.replace(/#/, "");

                var validator = $("#" + inputId).validate();
                if ( !validator ) {
                    var errormessages = $("#" + inputId).getErrorMessage();
                    for(var name in errormessages) {
						$.PSNM.alert(errormessages[name]);
						$("#" + inputId).focus();
						return;
					}
                }
            }
            return true;
        }
        ,

        // 세션값중에서 { 'CPLAZA_ORG_CD', 'DUTY' } 를 참조하여,
        // 조직 select 상자를 설정할 레벨값을 구하여 반환
        // 0=설정안함, 1=본사팀설정, ..., 4=영업팀설정, 5=에이전트설정
        getOrgSetLevel : function() {
            var cplazaOrgCd  = $.PSNM.getSession("CPLAZA_ORG_CD"); //
            var duty         = $.PSNM.getSession("DUTY"); //직무코드
            var nLevelSetOrg = 0;

            if ( $.PSNMUtils.isNotEmpty(cplazaOrgCd) ) {
                if ( "18"==duty ) { //18==DSM_MA
                    nLevelSetOrg = 5; //에이전트까지 설정
                }
                else if ( "15"==duty || "16"==duty || "17"==duty || "19"==duty || "20"==duty ) { 
                    //15=DSM 관리총무, 16=DSM 팀장, 17=DSM 총무, 19=DSM 팀장(CS), 20=DSM 총무(CS)
                    nLevelSetOrg = 4; //영업팀까지 설정
                }
                else if ( "8"==duty || "9"==duty || "10"==duty || "11"==duty || "12"==duty || "13"==duty || "14"==duty ) { 
                    //8=DSM지원/TM(도급), 9=DSM정책/마감(도급), 10=DSM개통담당(도급), 11=DSM물류담당(도급), 12=DSM개통실관리(도급), 13=DSM물류센터관리(도급), 14=DSM국장
                    nLevelSetOrg = 3; //영업국까지 설정
                }
                else { 
                    //1 ~ 7 : 본사직원
                    nLevelSetOrg = 0;
                }
            }
            _debug("getOrgSetLevel", "cplazaOrgCd = " + cplazaOrgCd, "duty = " + duty, "nLevelSetOrg = " + nLevelSetOrg);
            return nLevelSetOrg;
        }
        ,

        //
        // 화면에서 조직코드 select box의 값을 초기화/설정함 (화면 initialize() 시 호출됨)
        // (주의) 화면초기화후 setCodeData()에서 이 조직코드 관련 조회는 하지 않도록 해야 함.
        //@since 2014-12-30
        setOrgSelectBox : function(oParam) {
            if ( $.PSNMUtils.isEmpty(oParam) ) {
                //return;
            }

            var nOrgSetLevel = $.PSNM.getOrgSetLevel();

            $("body select").each(
                function(index) {
                    var _sel_id = $(this).attr("id");

                    switch ( _sel_id ) {
                        case "HDQT_TEAM_ORG_ID" :
                            if (nOrgSetLevel>0) {
                                $(this).empty(); //options를 삭제
                                var aOptions = [];
                                    aOptions.push({
                                        "value":$.PSNM.getSession("HDQT_TEAM_ORG_ID"),
                                        "text":$.PSNM.getSession("HDQT_TEAM_ORG_NM")
                                    });
                                $(this).setData({options_HDQT_TEAM_ORG_ID : aOptions}).setSelected( $.PSNM.getSession("HDQT_TEAM_ORG_ID") );
                            }
                            var eventEnable = $(this).attr("onchange-enable");
                            if (eventEnable == undefined || eventEnable != "false") $(this).change( eval("_onchange_HDQT_TEAM_ORG_ID") );
                            $(this).addClass("psnm-org-id");
                            break;
                        case "HDQT_PART_ORG_ID" :
                            if (nOrgSetLevel>1) {
                                $(this).empty(); //options를 삭제
                                var aOptions = [];
                                    aOptions.push({
                                        "value":$.PSNM.getSession("HDQT_PART_ORG_ID"),
                                        "text":$.PSNM.getSession("HDQT_PART_ORG_NM")
                                    });
                                $(this).setData({options_HDQT_PART_ORG_ID : aOptions}).setSelected( $.PSNM.getSession("HDQT_PART_ORG_ID") );
                            }
                            var eventEnable = $(this).attr("onchange-enable");
                            if (eventEnable == undefined || eventEnable != "false") $(this).change( eval("_onchange_HDQT_PART_ORG_ID") );
                            $(this).addClass("psnm-org-id");
                            break;
                        case "SALE_DEPT_ORG_ID" :
                            if (nOrgSetLevel>2) {
                                $(this).empty(); //options를 삭제
                                var aOptions = [];
                                    aOptions.push({
                                        "value":$.PSNM.getSession("SALE_DEPT_ORG_ID"),
                                        "text":$.PSNM.getSession("SALE_DEPT_ORG_NM")
                                    });
                                $(this).setData({options_SALE_DEPT_ORG_ID : aOptions}).setSelected( $.PSNM.getSession("SALE_DEPT_ORG_ID") );
                            }
                            var eventEnable = $(this).attr("onchange-enable");
                            if (eventEnable == undefined || eventEnable != "false") $(this).change( eval("_onchange_SALE_DEPT_ORG_ID") );
                            $(this).addClass("psnm-org-id");
                            break;
                        case "SALE_TEAM_ORG_ID" :
                            if (nOrgSetLevel>3) {
                                $(this).empty(); //options를 삭제
                                var aOptions = [];
                                    aOptions.push({
                                        "value":$.PSNM.getSession("SALE_TEAM_ORG_ID"),
                                        "text":$.PSNM.getSession("SALE_TEAM_ORG_NM")
                                    });
                                $(this).setData({options_SALE_TEAM_ORG_ID : aOptions}).setSelected( $.PSNM.getSession("SALE_TEAM_ORG_ID") );
                            }
                            var eventEnable = $(this).attr("onchange-enable");
                            if (eventEnable == undefined || eventEnable != "false") $(this).change( eval("_onchange_SALE_TEAM_ORG_ID") );
                            $(this).addClass("psnm-org-id");
                            break;
                        case "SALE_AGNT_ORG_ID" :
                            if (nOrgSetLevel>4) {
                                $(this).empty(); //options를 삭제
                                var aOptions = [];
                                    aOptions.push({
                                        "value":$.PSNM.getSession("SALE_AGNT_ORG_ID"),
                                        "text":$.PSNM.getSession("SALE_AGNT_ORG_NM")
                                    });
                                $(this).setData({options_SALE_AGNT_ORG_ID : aOptions}).setSelected( $.PSNM.getSession("SALE_AGNT_ORG_ID") );
                            }
                            $(this).addClass("psnm-org-id");
                            break;
                        default :
                            break;
                    }
                }
            );

            if (nOrgSetLevel>=5) {
                return; //모두 설정됨
            }

            var t = 'org1';
            var elemid = '';
            var codeid = '';
            var header = '-선택-';

            switch ( nOrgSetLevel ) {
                case 0 : t = 'org1'; elemid = 'HDQT_TEAM_ORG_ID'; 
                         break;
                case 1 : t = 'org2'; elemid = 'HDQT_PART_ORG_ID'; codeid = $.PSNM.getSession("HDQT_TEAM_ORG_ID");
                         break;
                case 2 : t = 'org3'; elemid = 'SALE_DEPT_ORG_ID'; codeid = $.PSNM.getSession("HDQT_PART_ORG_ID");
                         break;
                case 3 : t = 'org4'; elemid = 'SALE_TEAM_ORG_ID'; codeid = $.PSNM.getSession("SALE_DEPT_ORG_ID");
                         break;
                case 4 : t = 'org5'; elemid = 'SALE_AGNT_ORG_ID'; codeid = $.PSNM.getSession("SALE_TEAM_ORG_ID");
                         break;
                default: break;
            }
            
            var csYn = $.PSNM.getSession("CS_YN");
            if (_menuCsYn == "Y" && csYn == "Y" && nOrgSetLevel == 4) { // CS메뉴면서 팀장이면서 CS(구장업무대행)여부가 'Y'면 국소속 팀 전체 - 2015.04.17 추가
            	t = 'org4'; elemid = 'SALE_TEAM_ORG_ID'; codeid = $.PSNM.getSession("SALE_DEPT_ORG_ID");
            }
            
            if ( $.PSNMUtils.isValueRequired(elemid) ) {
                header = '-선택-';
            }
            else {
                header = '-전체-';
            }

            $.alopex.request("com.CODE@PCODE_pSearchOrgBySup", {
                url: _NOSESSION_REQ_URL,
                showProgress:false,
                async:false, //공통코드 조회는 sync로 조회함
                data: {
                    dataSet: { fields : { "t":t, "elemid":elemid, "codeid":codeid, "header":header } }
                },
                success: function(res) {
                    var orgList = res.dataSet.recordSets[""+elemid].nc_list;
                    var codeOptions2 = $.PSNMUtils._getCodeDataForSelBox(t, header, orgList);
                        var optData = new Object();
                            optData["options_" + elemid] = codeOptions2;
                        $("#" + elemid).setData(optData);
                }
            });
        }
        ,

        //'전체메뉴' 팝업창을 오픈
        sitemap : function () {
            $a.popup({
                url: "com/popup/mainSitemap"
              , data: {}
              , width: 1020
              , height: 650
              , title: "SITE MAP"
            });
        }
        ,

        //'받은쪽지개수' 조회
        getRcvPaperCount : function (sElemId) {
            $.alopex.request("com.MAINLOGIN@PMAIN001_pSearchRcvPaperCnt", {
                showProgress: false,
                data: function() {
                },
                success: function(res) {
                    var cnt = res.dataSet.fields["RCV_PAPER_CNT"];
                    if ( $.PSNMUtils.isNotEmpty(sElemId) ) {
                        $("#" + sElemId).text(cnt);
                    }
                    else {
                        $("#RCV_PAPER_CNT").text(cnt);
                    }
                }
            });
        }
        ,

        //현재 메뉴정보를 검사
        _check_menu : function(oOpenMenuParam) {
            var _rstrctCl = "";
            var _currRstrctCl = "";
            $.alopex.request("com.MENU@PMENU001_pSearchMenuByPk", {
                async: false,
                showProgress: false,
                data: {
                    dataSet : { fields : oOpenMenuParam }
                },
                success: function(res) {
                    _rstrctCl = res.dataSet.fields["RSTRCT_CL"];
                    _currRstrctCl = res.dataSet.fields["CURR_RSTRCT_CL"];
                    _debug("<PSNM._check_menu> RSTRCT_CL = [" +  _rstrctCl + "], CURR_RSTRCT_CL = [" + _currRstrctCl + "]");
                }
            });
            if ( $.PSNMUtils.isEmpty(_rstrctCl) || "A"==_rstrctCl ) {
                return true; //제한없음
            }
            if ( _currRstrctCl != _rstrctCl ) {
                $.PSNM.alert("I999", ["제한된 화면(메뉴)입니다!"]);
                return false;
            }
            return true;
        }
        ,

        //현재 메뉴접근 내역을 등록
        _log_menu : function(oOpenMenuParam) {
            if ( $.PSNMUtils.isEmpty(oOpenMenuParam) || $.PSNMUtils.isEmpty(oOpenMenuParam.MENU_ID) ) {
                _error("<PSNM._log_menu> 시스템사용로그 등록 안함! 파리미터 정보 없음!" + JSON.stringify(oOpenMenuParam));
                return;
            }
            $.alopex.request("com.SYS@PSYSUSELOG001_pInsertSysUseLog", {
                showProgress: false,
                data: {
                    dataSet : { fields : oOpenMenuParam }
                },
                success: function(res) {
                    _debug("<PSNM._log_menu> 시스템사용로그 등록! " + JSON.stringify(res.dataSet.message));
                }
            });
        }
        ,

        //해당 메뉴ID가 존재하는지 여부 체크
        existMenu : function(sMenuId) {
            if ( $.PSNMUtils.isEmpty(sMenuId) ) {
                return false;
            }

            var sTopMenu = sessionStorage.getItem("top-menu");
            var arrTopMenu = JSON.parse(sTopMenu);
            if ( $.PSNMUtils.isEmpty(sTopMenu) || $.PSNMUtils.isEmpty(arrTopMenu) || arrTopMenu.length<1 ) {
                return false;
            }

            for(var i=0; i<arrTopMenu.length; i++) {
                var oTopMenu = arrTopMenu[i];
                if ( sMenuId==oTopMenu["MENU_ID"] ) {
                    return true;
                }
                
                var sSubMenuList = sessionStorage.getItem("top-menu-" + oTopMenu["MENU_ID"]);
                var arrSubMenuList = JSON.parse(sSubMenuList);

                for(var j=0; j<arrSubMenuList.length; j++) {
                    var oSubMenu = arrSubMenuList[j];
                    if ( sMenuId==oSubMenu["MENU_ID"] ) {
                        return true;
                    }
                }
            }
            return false;
        }
        ,

        //현재 브라우저 크기를 참조하여 팝업 높이를 반환
        popHeight : function(iDefaultHeight) {
            if (null==iDefaultHeight) {
                iDefaultHeight = 500;
            }
            if ( $(window).height() < iDefaultHeight )
                return $(window).height();
            return iDefaultHeight;
        }
        ,

        //현재 브라우저 크기를 참조하여 팝업 너비를 반환
        popWidth : function(iDefaultWidth) {
            if (null==iDefaultWidth) {
                iDefaultWidth = 700;
            }
            if ( $(window).width() < iDefaultWidth )
                return $(window).width();
            return iDefaultWidth;
        }

        //----------------------------------------------------------------------------------------------------------------------------//
    };
    //end of [$.PSNM]

})(jQuery);


    //[본사팀] 코드 변경시 처리
    function _onchange_HDQT_TEAM_ORG_ID(E) {
        var eTargetId = E.target.id;
        var sHdqtTeamOrgIdVal = $("#" + eTargetId + " option:selected").val(); //선택된 '본사팀ID' //HDQT_TEAM_ORG_ID
        var sHdqtPartOrgIdElemId = 'HDQT_PART_ORG_ID'; //'본사파트' element id(화면요소의 ID임)
        _debug("<PSNM._onchange..> <본사팀코드변경> 변경된 본사팀코드 = [" +  sHdqtTeamOrgIdVal + "], 이벤트발생요소ID = [" + eTargetId + "]");

        $.PSNMUtils.setSelectDefaultPlaceHolder("SALE_TEAM_ORG_ID");
        $.PSNMUtils.setSelectDefaultPlaceHolder("SALE_DEPT_ORG_ID");
        $.PSNMUtils.setSelectDefaultPlaceHolder("HDQT_PART_ORG_ID");

        var headerText = ($.PSNMUtils.isValueRequired(sHdqtPartOrgIdElemId) ? '-선택-' : '-전체-');

        if ( $.PSNMUtils.isNotEmpty(sHdqtTeamOrgIdVal) ) {
            $("#" + sHdqtPartOrgIdElemId + "").val("");
            $.PSNMUtils.setCodeData([
                { t:'org2', 'elemid' : sHdqtPartOrgIdElemId, 'codeid' : sHdqtTeamOrgIdVal, 'header' : headerText } //'-선택-'
            ], function(params) {
                _debug("<PSNM._onchange..> <본사파트 목록 조회 완료. 입력파라미터>\n\n" + JSON.stringify(params));
                $("#" + sHdqtPartOrgIdElemId + "").val("");
            });
        }
    }
    //[본사파트] 코드 변경시 처리
    function _onchange_HDQT_PART_ORG_ID(E) {
        var eTargetId = E.target.id;
        var sHdqtPartOrgIdVal = $("#" + eTargetId + " option:selected").val(); //선택된 '본사파트ID' //HDQT_PART_ORG_ID
        var sSaleDeptOrgIdElemId = 'SALE_DEPT_ORG_ID'; //'영업국' element id(화면요소의 ID임)
        _debug("<PSNM._onchange..> <본사파트코드변경> 변경된 본사파트코드 = [" +  sHdqtPartOrgIdVal + "], 이벤트발생요소ID = [" + eTargetId + "]");

        $.PSNMUtils.setSelectDefaultPlaceHolder("SALE_TEAM_ORG_ID");
        $.PSNMUtils.setSelectDefaultPlaceHolder("SALE_DEPT_ORG_ID");
        var headerText = ($.PSNMUtils.isValueRequired(sSaleDeptOrgIdElemId) ? '-선택-' : '-전체-');
        var bDtokall = $("#" + sSaleDeptOrgIdElemId).data("dtokall"); //영업국조회시 필요하면 'DTOK_EFF_ORG_YN'='Y' 조건을 제외함(@since 2015-01-29)

        if ( $.PSNMUtils.isNotEmpty(sHdqtPartOrgIdVal) ) {
            $.PSNMUtils.setCodeData([
                { t:'org3', 'elemid' : sSaleDeptOrgIdElemId, 'codeid' : sHdqtPartOrgIdVal, 'header' : headerText, 'dtokall' : bDtokall } //'-선택-'
            ], function(params) {
                _debug("<PSNM._onchange..> <영업국 목록 조회 완료. 입력파라미터>\n\n" + JSON.stringify(params) );
                $("#" + sSaleDeptOrgIdElemId + "").val("");
            });
        }
    }

    //[영업국] 코드 변경시 처리
    function _onchange_SALE_DEPT_ORG_ID(E) {
        var eTargetId = E.target.id;
        var sSaleDeptOrgIdVal = $("#" + eTargetId + " option:selected").val(); //선택된 '영업국ID' //SALE_DEPT_ORG_ID
        var sSaleTeamOrgIdElemId = 'SALE_TEAM_ORG_ID'; //'영업팀' element id(화면요소의 ID임)
        _debug("<PSNM._onchange..> <영업국코드변경> 변경된 영업국코드 = [" +  sSaleDeptOrgIdVal + "], 이벤트발생요소ID = [" + eTargetId + "]");

        $.PSNMUtils.setSelectDefaultPlaceHolder("SALE_TEAM_ORG_ID");
        var headerText = ($.PSNMUtils.isValueRequired(sSaleTeamOrgIdElemId) ? '-선택-' : '-전체-');

        if ( $.PSNMUtils.isNotEmpty(sSaleDeptOrgIdVal) ) {
            $.PSNMUtils.setCodeData([
                { t:'org4', 'elemid' : sSaleTeamOrgIdElemId, 'codeid' : sSaleDeptOrgIdVal, 'header' : headerText } //'-선택-'
            ], function(params) {
                _debug("<PSNM._onchange..> <영업팀 목록 조회 완료. 입력파라미터>\n\n" + JSON.stringify(params) );
                $("#" + sSaleTeamOrgIdElemId + "").val("");
            });
        }
    }

    //[영업팀] 코드 변경시 처리
    function _onchange_SALE_TEAM_ORG_ID(E) {
        var eTargetId = E.target.id;
        var sSaleTeamOrgIdVal = $("#" + eTargetId + " option:selected").val(); //선택된 '영업국ID' //SALE_DEPT_ORG_ID
        var sSaleAgentOrgIdElemId = 'SALE_AGNT_ORG_ID'; //'에이전트' select element id(화면요소의 ID임)

        if ( $('#SALE_AGNT_ORG_ID').length < 1){
            _debug("PSNM._onchange_SALE_TEAM_ORG_ID", "<영업팀코드변경> 에이전트 select box는 없음.");
            return;
        }
        _debug("<PSNM._onchange..> <영업팀코드변경> 변경된 영업팀코드 = [" +  sSaleTeamOrgIdVal + "], 이벤트발생요소ID = [" + eTargetId + "]");

        //var _default_options_ = [ { value: "", text: "-선택-"} ];
        //$('#SALE_AGNT_ORG_ID').setData({options_SALE_AGNT_ORG_ID : _default_options_}).setSelected("-선택-");
        $.PSNMUtils.setSelectDefaultPlaceHolder("SALE_AGNT_ORG_ID");
        var headerText = ($.PSNMUtils.isValueRequired(sSaleAgentOrgIdElemId) ? '-선택-' : '-전체-');

        if ( $.PSNMUtils.isNotEmpty(sSaleTeamOrgIdVal) ) {
            $.PSNMUtils.setCodeData([
                { t:'org5', 'elemid' : sSaleAgentOrgIdElemId, 'codeid' : sSaleTeamOrgIdVal, 'header' : headerText }
            ], function(params) {
                _debug("PSNM._onchange_SALE_TEAM_ORG_ID", "<에이전트 목록 조회 완료. 입력파라미터>\n\n" + JSON.stringify(params) );
                $("#" + sSaleAgentOrgIdElemId + "").val("");
            });
        }
    }
