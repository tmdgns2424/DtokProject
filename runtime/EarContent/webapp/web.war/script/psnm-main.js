/*
 * Copyright (c) 2014 PS&M. All rights reserved.
 */

var _TX_SEARCH_RCV_PAPER = "com.MAINLOGIN@PMAIN001_pSearchRcvPaperCnt"; //받은쪽지개수

//로그아웃 처리
function psnm_logout() {
    _debug("psnm_logout", "로그아웃 시작...");
    $.PSNM.logout(); //@see $.PSNM.logout();
}

//타이머
function psnm_top_timer() {
    var intervalTime = 1000 * 60 * 5; //5분
    var timer = $.timer(function() {
        _debug("psnm_top_timer", "PSNM 상단 timer 실행...");
        psnm_rcv_paper_cnt();
    });
    timer.set({ time : intervalTime, autostart : true });
}

//'비밀번호 변경' 팝업창을 오픈
function psnm_pop_passwd(yn, dataset) {
    var pParam = new Object();
    if ( $.PSNMUtils.isNotEmpty(yn) ) {
        pParam["NEED_TO_CHANGE_PWD"] = yn;
    }

    var popOption = {
        url: "com/popup/mainPasswdPop"
      , data: pParam
      , width: 550
      , height: 300
      , windowpopup: false
      , title: "비밀번호 변경"
    }

    if ( $.PSNMUtils.isNotEmpty(yn) ) {
        popOption["callback"] = function(data) {
            _debug("psnm_pop_passwd callbacked. data : " + JSON.stringify(data));
            if ( $.PSNMUtils.isNotEmpty(data) && "Y"==data["SUCCESS"] ) {
                psnm_main_post_process( dataset ); //메인 팝업등 처리
            }
            else {
                $.PSNM.logout();
            }
        };
    }
    $a.popup(popOption);
/*
    $a.popup({
        url: "com/popup/mainPasswdPop"
      , data: pParam
      , width: 550
      , height: 300
      , windowpopup: false
      , title: "비밀번호 변경"
      , callback : function(data) {
            _debug("psnm_pop_passwd callbacked. data : " + JSON.stringify(data));
            if ( $.PSNMUtils.isNotEmpty(data) && "Y"==data["SUCCESS"] ) {
                psnm_main_post_process( dataset ); //메인 팝업등 처리
            }
            else {
                $.PSNM.logout();
            }
      }
    });
*/
}

//'받은쪽지개수' 조회
function psnm_rcv_paper_cnt(sElemId) {
    $.alopex.request(_TX_SEARCH_RCV_PAPER, {
        showProgress:false,
        data: [function() {
        }],
        success: function(res) {
            _debug("받은쪽지개수", res.dataSet.fields["RCV_PAPER_CNT"]); //alert( "받은쪽지개수"+ res.dataSet.fields["RCV_PAPER_CNT"] );
            if ( $.PSNMUtils.isNotEmpty(sElemId) ) {
                $("#" + sElemId).text( res.dataSet.fields["RCV_PAPER_CNT"] );
            }
            else {
                $("#RCV_PAPER_CNT").text( res.dataSet.fields["RCV_PAPER_CNT"] );
            }
        }
    });
}

//조회된 전체 메뉴 목록을 처리
function psnm_process_menulist(arrMenuList) {
    _debug("psnm_process_menulist", "메뉴데이터개수", (null==arrMenuList ? -1 : arrMenuList.length)); //JSON.stringify(arrMenuList)

    var oTopMenu = null;
    var arrTopSubMenuList = null;

    $.each(arrMenuList, function(index, oMenu) {
        if ( "1"==oMenu["MENU_TYP_CD"] ) { //대메뉴는 포함하지 않음
            if (null!=oTopMenu) {
                sessionStorage.setItem("top-menu-" + oTopMenu["MENU_ID"], JSON.stringify(arrTopSubMenuList)); //세션스토리지에 탑메뉴ID로 해당 서브메뉴배열을 저장
                //_debug("- 탑메뉴 : top-menu-" + oTopMenu["MENU_ID"] + ", 하위메뉴개수 : " + arrTopSubMenuList.length); 
            }

            oTopMenu = oMenu;
            arrTopSubMenuList = new Array();
            return true; //for 문의 continue;
        }
        arrTopSubMenuList.push(oMenu);
    });

    if (null!=oTopMenu) {
        sessionStorage.setItem("top-menu-" + oTopMenu["MENU_ID"], JSON.stringify(arrTopSubMenuList)); //세션스토리지에 탑메뉴ID로 해당 서브메뉴배열을 저장
        //_debug("- 탑메뉴 : top-menu-" + oTopMenu["MENU_ID"] + ", 하위메뉴개수 : " + arrTopSubMenuList.length); 
    }
}

function psnm_main_post_process(dataSet) {
    var gridanncepic = dataSet.recordSets["gridanncepic"].nc_list;
    psnm_process_user_yn(dataSet.fields, gridanncepic, dataSet.recordSets["gridannce"].nc_list);

    if ( "Y"==dataSet.fields["MRTG_CHECK_YN"] ) {
        var gridmrtgexpir = dataSet.recordSets["gridmrtgexpir"].nc_list;
        var cnt = null==gridmrtgexpir ? 0 : gridmrtgexpir.length;

        if ( cnt>0 ) {
            var oMrtgInfo = gridmrtgexpir[0];
            var expirDt = oMrtgInfo["EXPIR_DT"]; //만료일자
            var daysBefore = oMrtgInfo["DAYS_BEFORE"]; //만료일 이전 몇일
            var histExpirDt = oMrtgInfo["MRTG_EXPIR_DT"]; //담보만료일자(이력)
            var histReCntrctYn = oMrtgInfo["MRTG_EXPIR_RE_CNTRCT_YN"]; //담보만료재계약여부(이력)
            var histSmsYn = oMrtgInfo["SMS_SND_YN"]; //SMS발송여부(이력)
            var overExpirDtCnt = oMrtgInfo["OVER_EXPIR_DT_CNT"];
            _debug("psnm_main_post_process", "담보만료일(남은일자수) : " + daysBefore, "담보만료일자(이력) : " + histExpirDt, "담보만료재계약여부(이력) : " + histReCntrctYn);

            if ( daysBefore<=30 ) {
                if ( $.PSNMUtils.isEmpty(histExpirDt) ) {
                    var timer = setInterval(function () {
                        psnm_main_pop_mrtg_info(oMrtgInfo); //담보만료 안내 팝업창 오픈
                        clearInterval(timer);
                    }, 1000);
                }
                else {
                    if ( overExpirDtCnt<1 ) { //현재담보만료일자이후의 데이터건수 @since 2015-04-02
                        var timer = setInterval(function () {
                            psnm_main_pop_mrtg_confirm(oMrtgInfo); //담보만료 '확인' 팝업창 오픈
                            clearInterval(timer);
                        }, 1000);
                    }
                    else {
                        _debug("psnm_main_post_process", "현재담보만료일자이후의 데이터건수 : " + overExpirDtCnt);
                    }
                }
            }
        }
    }
    /*
    else { //[TEST] 담보만료테스트로 팝업
        var timer = setInterval(function () { 
            psnm_main_pop_mrtg_info(oMrtgInfo);
            clearInterval(timer);
        }, 1000);
    }
    */
}

//담보만료 안내 팝업창 오픈
function psnm_main_pop_mrtg_info(oMrtgInfo) {
    var oPopupObject = $a.popup({
        url: "com/popup/mainMrtgInfoPop"
      , data: oMrtgInfo
      //, modal:  false
      //, windowpopup: true //DIV팝업 X
      , width: 400
      , height: 270
      , title: "담보만료안내"
      , callback : function(data) {
            _debug("psnm_main_pop_mrtg_info callbacked. data : " + JSON.stringify(data));
            if ( $.PSNMUtils.isNotEmpty(data) ) {
                psnm_main_pop_mrtg_confirm(data); //담보만료 '확인' 팝업창 오픈
            }
      }
    });
}

//담보만료 '확인' 팝업창 오픈
function psnm_main_pop_mrtg_confirm(oMrtgInfo) {
    var oPopupObject = $a.popup({
        url: "com/popup/mainMrtgConfirmPop"
      , data: oMrtgInfo
      //, modal:  false
      //, windowpopup: true //DIV팝업 X
      , width: 400
      , height: 250
      , title: "담보만료확인"
    });
}

//메인조회1 후 사용자별각종여부에 따른 팝업등 처리
//사용자별각종여부: CPLAZA_YN, DSMUSER_YN, CERT_YN, PWDUPD_YN, ANNCE_POP_YN
//이미지공지 : 없거나 1건 데이터 있을수 있음.
function psnm_process_user_yn(oUserYnData, gridanncepic, gridanncelist) {
    //_debug("psnm_process_user_yn :: oUserYnData  : " + JSON.stringify(oUserYnData));

    var mndtAnnceCnt = oUserYnData["ANNCE_MNDT_CNT"]; //필수확인공지 개수
    var isAnncePoped = false; //공지팝업 오픈여부

    //1. 필수확인 공지가 있으면, 각 공지사항 팝업창으로 오픈함
    if ( !isAnncePoped && mndtAnnceCnt>0 ) {
        isAnncePoped = true;
        $.alopex.request("com.MAINLOGIN@PMAIN001_pSearchAnnceMndtList", {
            showProgress: false,
            data: {},
            success: function(res) {
                var arrMndtAnnce = res.dataSet.recordSets["gridanncemndt"].nc_list;

                $.each(arrMndtAnnce, function(index, oAnnce) {
                    _debug("필수확인공지 : " + JSON.stringify(oAnnce));
                    var oPopupObject = $a.popup({
                        url: "com/popup/mainAnnceMndtPop"
                      , data: oAnnce
                      , modal:  false
                      , windowpopup: true //DIV팝업 X
                      , width: 830
                      , height: 660
                      , title: "공지사항 - 반드시 확인하세요."
                    });
                });
            }
        });
    }

    //공지사항 Pop-up 순서(유형 : 필수확인 공지, 일반공지, Image 공지) 
    //- 3가지 유형 : 모두 있을 경우 : 필수확인 공지만 가능 
    //- 일반공지, Image 공지 있을 경우 : 2가지 모두 보이게
    if ( true == isAnncePoped ) {
        return;
    }

    //2. '팝업공지'가 있으면 오픈함
    if ( 'Y'==oUserYnData["ANNCE_POP_YN"] ) {
        var today = new Date();
        var ymd   = today.format("yyyymmdd");
        if ( $a.cookie(_COOKEY_MAIN_ANNCE_TODAY_KEY) != ymd ) { //쿠키키="PSNM_MAIN_ANNCE_POP"
            var anncelistlen = null==gridanncelist ? 0 : gridanncelist.length;
            if (anncelistlen>0) {
                isAnncePoped = true;
                psnm_pop_anncepop(oUserYnData["ANNCE_POP_YN"], oUserYnData["ANNCE_MNDT_YN"]); //팝업+필수확인 공지목록 팝업
            }
        }
    }

    //3. 이미지공지가 있으면 오픈
    //if ( !isAnncePoped ) {
        if ( null!=gridanncepic && gridanncepic.length>0 ) { //이미지공지가 있는 경우
            var today = new Date();
            var ymd   = today.format("yyyymmdd");
            if ( $a.cookie(_COOKEY_MAIN_ANNCE_PIC_KEY) != ymd ) { //쿠키키="PSNM_MAIN_ANNCE_POP"
                psnm_pop_anncepic(gridanncepic[0]); //이미지공지
            }
        }
    //}
}

//팝업공지목록 팝업창을 오픈(메인화면에서 자동 오픈)
function psnm_pop_anncepop(anncePopYn, annceMntdYn) {
    $a.popup({
        url: "com/popup/mainAnncePop"
      , data: {}
      , width: 830
      , height: 660
      , title: "공지사항"
      , callback: function(data) {
            _debug("psnm_pop_anncepop ischecked : " + data);
            if (true==data) {
                var today = new Date();
                var todayYmd = today.format("yyyymmdd");
                $a.cookie(_COOKEY_MAIN_ANNCE_TODAY_KEY, todayYmd, 1); //만료일을 하루 뒤로 지정 "PSNM_MAIN_ANNCE_POP"
            }
      }
    });
}

//이미지공지 팝업창을 오픈(메인화면에서 자동 오픈)
function psnm_pop_anncepic(oPicFileInfo) {
    var imgFileUrl = $.PSNMUtils.getDownloadUrl(oPicFileInfo);
    _debug("psnm_pop_anncepic", "imgFileUrl = " + imgFileUrl, "oPicFileInfo = ", JSON.stringify(oPicFileInfo));

    $("<img/>").attr("src", imgFileUrl).load(function() {
        var w = this.width;
        var h = this.height;

        if (w>0 && h>0) {
            var _w2 = 30 + w;
            var _h2 = 30 + h + 130;
                _w2 = $.PSNM.popWidth(_w2);
                _h2 = $.PSNM.popHeight(_h2);

            $("#sub-menu-div > ul").hide();
            $("#quick-link-list").hide();
            $a.popup({
                url: "com/popup/mainAnncePicPop"
              , data: oPicFileInfo
              , width: _w2  //30 + w
              , height: _h2  //30 + h + 130
              , title: "공지사항"
              , callback: function(data) {
                    //alert("psnm_pop_anncepic ischecked : " + data);
                    if (true==data) {
                        var today = new Date();
                        var todayYmd = today.format("yyyymmdd");
                        $a.cookie(_COOKEY_MAIN_ANNCE_PIC_KEY, todayYmd, 1); //만료일을 하루 뒤로 지정 "PSNM_MAIN_ANNCE_PIC_POP"
                    }
              }
            });
        }
    });
}

//이메일보내기
function psnm_mailto() {
    var email1 = $.PSNM.getSession("EMAIL_ID");
    var email2 = $.PSNM.getSession("EMAIL_DMN_NM"); //EMAIL_DMN_CD

    if ( $.PSNMUtils.isNotEmpty(email1) && $.PSNMUtils.isNotEmpty(email2) ) {
        document.location.href = "mailto:" + email1 + "@" + email2;
    }
    else {
        $.PSNM.alert("I999", ["이메일 주소가 없습니다."]);
    }
}

//영업목표/현황 이동
function pnsm_open_sale_stat() {
    var attcCat = $.PSNM.getSession("ATTC_CAT");
    if ( "3"==attcCat ) {
        $.PSNM.alert("PSNM-I999", ["협력직원은 조회할 수 없습니다."]);
        return;
    }

    $.PSNM.openMenuLink({"menuid":"4402"});
}

//판매 우수 MA 현황 팝업
function pnsm_pop_best_ma() {
    var attcCat = $.PSNM.getSession("ATTC_CAT");
    if ( "3"==attcCat ) {
        $.PSNM.alert("PSNM-I999", ["협력직원은 조회할 수 없습니다."]);
        return;
    }

    var oParam = {};
    $a.popup({
        url: "com/popup/mainBestMaPop",
        data: oParam,
        width: $.PSNM.popWidth(900),
        height: $.PSNM.popHeight(700),
        title : "판매 우수 MA 현황"
    });

}

//판매 우수 팀장 현황 팝업
function pnsm_pop_best_team() {
    var attcCat = $.PSNM.getSession("ATTC_CAT");
    if ( "3"==attcCat ) {
        $.PSNM.alert("PSNM-I999", ["협력직원은 조회할 수 없습니다."]);
        return;
    }
    var dutyCd = $.PSNM.getSession("DUTY");
    if ( "18"==dutyCd ) { //DSM_MA
        $.PSNM.alert("PSNM-I999", ["MA 사용자는 조회할 수 없습니다."]);
        return;
    }

    var oParam = {};
    $a.popup({
        url: "com/popup/mainBestTeamPop",
        data: oParam,
        width: $.PSNM.popWidth(900),
        height: $.PSNM.popHeight(700),
        title : "판매 우수 팀장 현황"
    });

}

//담보 기간만료 예정 현황 팝업
function pnsm_pop_mrtg_expir() {
    var attcCat = $.PSNM.getSession("ATTC_CAT");
    if ( "3"==attcCat ) {
        $.PSNM.alert("PSNM-I999", ["협력직원은 조회할 수 없습니다."]);
        return;
    }
    var dutyCd = $.PSNM.getSession("DUTY");
    if ( "18"==dutyCd ) { //DSM_MA
        $.PSNM.alert("PSNM-I999", ["MA 사용자는 조회할 수 없습니다."]);
        return;
    }

    var oParam = {};
    $a.popup({
        url: "com/popup/mainMrtgExpirPop",
        data: oParam,
        width: $.PSNM.popWidth(900),
        height: $.PSNM.popHeight(700),
        title : "담보 기간만료 예정 현황"
    });

}

//영업국별 판매순위 조회 팝업
function pnsm_pop_headq_rnk() {
    var attcCat = $.PSNM.getSession("ATTC_CAT");
    if ( "1"!=attcCat && "2"!=attcCat) {
        $.PSNM.alert("PSNM-I999", ["임직원(계약직 포함)만  조회할 수 있습니다."]);
        return;
    }

    var oParam = {};
    $a.popup({
        url: "com/popup/mainHeadqRnkPop",
        data: oParam,
        width: $.PSNM.popWidth(900),
        height: $.PSNM.popHeight(700),
        title : "영업국별 판매순위"
    });
}
function pnsm_showhide_mainbanners() { //하단 배너아이콘 표시여부
    var attcCat = $.PSNM.getSession("ATTC_CAT");
    if ( "1"!=attcCat && "2"!=attcCat) {
        $("#main-banner #main-banner-05").addClass("disabled-by-user"); //remove(); //영업국별 판매순위
        $("#footer ul.sns #footer-use-rstrct").hide();
    }
    
    var sHHmm = $.PSNM.getSession("USE_RSTRCT_APLY_STA_HM");
    var eHHmm = $.PSNM.getSession("USE_RSTRCT_APLY_END_HM");
    if ( $.PSNMUtils.isNotEmpty(sHHmm) && $.PSNMUtils.isNotEmpty(eHHmm) ) {
        var now = new Date();
        //var svHHmm = $.PSNM.getSession("CURR_HMS"); //서버 로그인시각
        var jsHHmm = now.format("HHMM");
        var baseHHmm = jsHHmm;

        if ( parseInt(baseHHmm) >= parseInt(sHHmm) && parseInt(baseHHmm) <= parseInt(eHHmm) ) {
            $("#main-banner #main-banner-02").addClass("disabled-by-time"); //판매우수 MA
            $("#main-banner #main-banner-03").addClass("disabled-by-time"); //판매우수 팀장
        }
    }

    $("#main-banner #main-banner-01").show();
    $("#main-banner #main-banner-04").show();

    if ( !$("#main-banner #main-banner-02").hasClass("disabled-by-time") ) {
        $("#main-banner #main-banner-02").show();
        $("#main-banner #main-banner-03").show();
    }
    if ( !$("#main-banner #main-banner-05").hasClass("disabled-by-user") ) {
        $("#main-banner #main-banner-05").show();
    }
}


//분기별 본인인증
function psnm_check_realname() {
    psnm_popup_realname("step1", {});
}

function psnm_popup_realname(step, param) {
    var oPopOption = { //step1 옵션
        url: "com/popup/mainVerifyRealnamePop", //"com/popupns/selfChkConfirmPopup", //"com/popupns/selfChkPopup"
        data: param,
        title : "본인확인",
        width: "400",
        height: "270",
        //, modal:  false
        //iframe: false,
        //windowpopup: true,
        callback : function(oResult) {
            //_popup_realname_callback(step, oResult);
            if ( "N" == oResult.confirm ) {
                $.PSNM.alert("본인확인하지 않으면 본 시스템을 사용할 수 없습니다!");
                $.PSNM.logout();
            }
            else {
                $( "#main-verifying-name" ).dialog( "open" );

                //$a.popup({
                //    url: "com/popupns/selfChkPopup",
                //    data: param,
                //    title : "본인확인",
                //    width: "500",
                //    height: "600",
                //    iframe: false,
                //    windowpopup: true
                //});
            }
        }
    };
    $a.popup(oPopOption);
}
    //본인인증의 최종결과를 처리하는 함수로 이 함수명은 "com/popupns/selfChkPopup"에서 참조하므로 명칭을 변경하면 안됨.(주의)
    function popupCallback(div, oResult) { //_popup_realname_callback
        switch (div) {
            case "step2":
                alert("본인인증 콜백\n\n" + JSON.stringify(oResult) );
                break;  
            default:
                alert("본인인증 콜백(default)\n\n" + div);
                break;  
        }
    }


/**
 * 타이머 라이브러리
 *
 * https://github.com/jchavannes/jquery-timer/blob/master/jquery.timer.js
 */
;(function($) {
	$.timer = function(func, time, autostart) {	
	 	this.set = function(func, time, autostart) {
	 		this.init = true;
	 	 	if(typeof func == 'object') {
		 	 	var paramList = ['autostart', 'time'];
	 	 	 	for(var arg in paramList) {if(func[paramList[arg]] != undefined) {eval(paramList[arg] + " = func[paramList[arg]]");}};
 	 			func = func.action;
	 	 	}
	 	 	if(typeof func == 'function') {this.action = func;}
		 	if(!isNaN(time)) {this.intervalTime = time;}
		 	if(autostart && !this.isActive) {
			 	this.isActive = true;
			 	this.setTimer();
		 	}
		 	return this;
	 	};
	 	this.once = function(time) {
			var timer = this;
	 	 	if(isNaN(time)) {time = 0;}
			window.setTimeout(function() {timer.action();}, time);
	 		return this;
	 	};
		this.play = function(reset) {
			if(!this.isActive) {
				if(reset) {this.setTimer();}
				else {this.setTimer(this.remaining);}
				this.isActive = true;
			}
			return this;
		};
		this.pause = function() {
			if(this.isActive) {
				this.isActive = false;
				this.remaining -= new Date() - this.last;
				this.clearTimer();
			}
			return this;
		};
		this.stop = function() {
			this.isActive = false;
			this.remaining = this.intervalTime;
			this.clearTimer();
			return this;
		};
		this.toggle = function(reset) {
			if(this.isActive) {this.pause();}
			else if(reset) {this.play(true);}
			else {this.play();}
			return this;
		};
		this.reset = function() {
			this.isActive = false;
			this.play(true);
			return this;
		};
		this.clearTimer = function() {
			window.clearTimeout(this.timeoutObject);
		};
	 	this.setTimer = function(time) {
			var timer = this;
	 	 	if(typeof this.action != 'function') {return;}
	 	 	if(isNaN(time)) {time = this.intervalTime;}
		 	this.remaining = time;
	 	 	this.last = new Date();
			this.clearTimer();
			this.timeoutObject = window.setTimeout(function() {timer.go();}, time);
		};
	 	this.go = function() {
	 		if(this.isActive) {
	 			this.action();
	 			this.setTimer();
	 		}
	 	};
	 	
	 	if(this.init) {
	 		return new $.timer(func, time, autostart);
	 	} else {
			this.set(func, time, autostart);
	 		return this;
	 	}
	};
})(jQuery);