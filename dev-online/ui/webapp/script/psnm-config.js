/*
 * Copyright (c) 2015 PS&Marketing. All rights reserved.
 */

/*
 * PSNM  전역변수 : 밑줄문자(_)로 시작하면 대문자로 작성 
 */
var _CTX_PATH          = "/";

var _LOGIN_URL         = _CTX_PATH + "index.jsp";
var _MAINPAGE_URL      = _CTX_PATH + "view/main.jsp";
var _NAMECHECK_URL     = _CTX_PATH + "view/realname.jsp";
var _EMP_REG_URL       = _CTX_PATH + "view/empreg.jsp";
var _FILE_HANDLER_URL  = _CTX_PATH + "filehandler.jsp";
var _EXCEL_IMPORT_URL  = _CTX_PATH + "psnmExcelImport.jsp";
var _DEFAULT_REQ_URL   = _CTX_PATH + "psnm.jmd";
var _NOSESSION_REQ_URL = _CTX_PATH + "psnmnosess.jmd";
var _LOG_LEVEL         = 0; //0=debug, 1=info, 2=error
var _COOKEY_INDEX_ID_SAVE        = "PSNM_IDSAVE";
var _COOKEY_MAIN_ANNCE_TODAY_KEY = "PSNM_MAIN_ANNCE_POP";
var _COOKEY_MAIN_ANNCE_PIC_KEY   = "PSNM_MAIN_ANNCE_PIC_POP";

var _PSNM_MESSAGE = [
    //[T] 테스트 메시지
    {"MESSAGE_ID":"PSNM-TEST", "MESSAGE_NAME":"테스트 메시지. 1번째=[{0}], 2번째=[{1}], 3번째=[{2}], 4번째=[{3}], 5번째=[{4}]", "MESSAGE_TYPE_XD":"I" } 
  , {"MESSAGE_ID":"PSNM-I999", "MESSAGE_NAME":"{0}", "MESSAGE_TYPE_XD":"I" } //메시지 전체를 파라미터로 입력
  , {"MESSAGE_ID":"PSNM-E999", "MESSAGE_NAME":"{0}", "MESSAGE_TYPE_XD":"E" } //메시지 전체를 파라미터로 입력

    //[I] 정보 메시지
  , {"MESSAGE_ID":"PSNM-I000", "MESSAGE_NAME":"정상적으로 처리되었습니다."          , "MESSAGE_TYPE_XD":"I" }
  , {"MESSAGE_ID":"PSNM-I001", "MESSAGE_NAME":"정상적으로 처리되었습니다. {0}"      , "MESSAGE_TYPE_XD":"I" }
  , {"MESSAGE_ID":"PSNM-I002", "MESSAGE_NAME":"정상적으로 {0} 되었습니다."          , "MESSAGE_TYPE_XD":"I" } //(예) 정상적으로 저장 ~, 수정 ~, 삭제 ~, 추가 ~
  , {"MESSAGE_ID":"PSNM-I003", "MESSAGE_NAME":"저장 하시겠습니까?"                  , "MESSAGE_TYPE_XD":"I" }
  , {"MESSAGE_ID":"PSNM-I004", "MESSAGE_NAME":"{0} 하시겠습니까?"                   , "MESSAGE_TYPE_XD":"I" } //(예) 등록 하시겠습니까?, 삭제 하시겠습니까?
  , {"MESSAGE_ID":"PSNM-I005", "MESSAGE_NAME":"{0}된 데이터가 있습니다. {1} 하시겠습니까?"      , "MESSAGE_TYPE_XD":"I" } //(예) 변경된 데이터가 있습니다. 조회 하시겠습니까?
  , {"MESSAGE_ID":"PSNM-I006", "MESSAGE_NAME":"조회조건 {0}(을)를 입력(선택)하세요."            , "MESSAGE_TYPE_XD":"I" }
  , {"MESSAGE_ID":"PSNM-I007", "MESSAGE_NAME":"비밀번호 찾기는 MA(모바일 에이전트)만 가능합니다", "MESSAGE_TYPE_XD":"I" }

    //[E] 에러메시지
  , {"MESSAGE_ID":"PSNM-E000", "MESSAGE_NAME":"처리중 오류가 발생하였습니다!"       , "MESSAGE_TYPE_XD":"E" }
  , {"MESSAGE_ID":"PSNM-E001", "MESSAGE_NAME":"처리중 오류가 발생하였습니다! {0}"   , "MESSAGE_TYPE_XD":"E" }
  , {"MESSAGE_ID":"PSNM-E002", "MESSAGE_NAME":"로그인하지 못하였습니다! {0}"        , "MESSAGE_TYPE_XD":"E" }
  , {"MESSAGE_ID":"PSNM-E003", "MESSAGE_NAME":"비밀번호를 변경할 수 없습니다. {0}"  , "MESSAGE_TYPE_XD":"E" }
  , {"MESSAGE_ID":"PSNM-E004", "MESSAGE_NAME":"중복된 아이디가 있습니다. 정보를 다시 입력해주세요.",     "MESSAGE_TYPE_XD":"E" }
  , {"MESSAGE_ID":"PSNM-E005", "MESSAGE_NAME":"에이전트 계약관련 절차가 완료 되지 않았습니다.\n영업국 담당자에게 문의해 주세요.", "MESSAGE_TYPE_XD":"E" }
  , {"MESSAGE_ID":"PSNM-E006", "MESSAGE_NAME":"동일 코드로 가입(또는 요청)한 회원이 존재합니다."           , "MESSAGE_TYPE_XD":"E" }
  , {"MESSAGE_ID":"PSNM-E007", "MESSAGE_NAME":"기존 비밀번호를 정확히 입력하세요."           , "MESSAGE_TYPE_XD":"E" }
  , {"MESSAGE_ID":"PSNM-E011", "MESSAGE_NAME":"{0} 데이터가 없습니다!"              , "MESSAGE_TYPE_XD":"E" } //(예) 조회된 ~, 변경된 ~, 삭제된 ~, 추가된 ~
  , {"MESSAGE_ID":"PSNM-E012", "MESSAGE_NAME":"{0} 항목은 필수값입니다!"            , "MESSAGE_TYPE_XD":"E" }
  , {"MESSAGE_ID":"PSNM-E013", "MESSAGE_NAME":"{0} 항목은 {1}자 이상 입력하세요!"   , "MESSAGE_TYPE_XD":"E" }
  , {"MESSAGE_ID":"PSNM-E014", "MESSAGE_NAME":"{0} 항목은 {1} 자리만 가능합니다!"   , "MESSAGE_TYPE_XD":"E" }
  , {"MESSAGE_ID":"PSNM-E015", "MESSAGE_NAME":"{0} 항목은 {1}자 이하 입력하세요!"   , "MESSAGE_TYPE_XD":"E" }
  , {"MESSAGE_ID":"PSNM-E016", "MESSAGE_NAME":"{0} 항목은 {1} ~ {2} 사이의 값을 입력하세요!", "MESSAGE_TYPE_XD":"E" }
  , {"MESSAGE_ID":"PSNM-E017", "MESSAGE_NAME":"{0} 항목은 숫자만 입력하세요!"        , "MESSAGE_TYPE_XD":"E" }
  , {"MESSAGE_ID":"PSNM-E018", "MESSAGE_NAME":"{0} 항목은 {1}자리 숫자만 입력하세요!", "MESSAGE_TYPE_XD":"E" }
  , {"MESSAGE_ID":"PSNM-E019", "MESSAGE_NAME":"{0} 데이터가 있습니다. {1} 할 수 없습니다!", "MESSAGE_TYPE_XD":"E" }
  , {"MESSAGE_ID":"PSNM-E020", "MESSAGE_NAME":"본인인증을 한 사용자 이름({0})과 에이전트 이름({1})이 다릅니다.", "MESSAGE_TYPE_XD":"E" }
  , {"MESSAGE_ID":"PSNM-E021", "MESSAGE_NAME":"{0} 선택해 주십시오."            , "MESSAGE_TYPE_XD":"E" }
  , {"MESSAGE_ID":"PSNM-E022", "MESSAGE_NAME":"본인인증을 한 사용자명({0})과 회원명({1})이 다릅니다.", "MESSAGE_TYPE_XD":"E" }
  , {"MESSAGE_ID":"PSNM-E023", "MESSAGE_NAME":"증명서발급은 {0}까지 가능합니다.", "MESSAGE_TYPE_XD":"E" }
  , {"MESSAGE_ID":"PSNM-E024", "MESSAGE_NAME":"최근 비밀번호로 변경할 수 없습니다.", "MESSAGE_TYPE_XD":"E" }


]; //end-of-_PSNM_MESSAGE

/*
 * alopex 주요 컴포넌트 setup 
 */
            $.alopex.setup('grid', {
                rowClickSelect: true,
                //leaveDeleted : true, 
                virtualScroll: true,
                pager: true,
                paging: {
                    //pagerSelect : [ '15', '30', '50' ],
                    //pagerTotal : true,
                    perPage : 15,
                    pagerCount : 10
                },
                message : {
                    nodata : "<p style='text-align:center;'>조회된 데이터가 없습니다!</p>",
                    pagerTotal : function(pageinfo) {
                        console.log("pagerTotal message : pageinfo ::= " + $.PSNMUtils.toString(pageinfo));
                        //{"left":false,"right":false,"pagerSelect":["10","20","50"],"pagerTotal":true,"perPage":10,"pagerCount":10,
                        //"dataLength":0,"total":0,"enabled":true,"pageDataLength":0,"current":0}
                        return "전체 : " + pageinfo.dataLength;
                    }
                },
                on : {
                   data : {
                      "add" : function(data, query) {
                         // var $grid = '#'+this.attr('id');
                         var edit_cnt = $(this).alopexGrid("dataGet", {_state:{edited:true}}, {_state:{added:true}}, {_state:{deleted:true}}).length;
                         var add_len = $.isArray(data) ? data.length : 1;
                         if(edit_cnt+add_len>50) {
                            alert('50건 이상의 데이터를 넣을 수 없습니다.');
                            return false;
                         }
                       },
                       "delete" : function(data, query) {
                         var $grid = '#'+this.attr('id');
                         var edit_cnt = $(this).alopexGrid("dataGet", {_state:{edited:true}}, {_state:{added:true}}, {_state:{deleted:true}}).length;
                         var selection = $(this).alopexGrid('dataGet', {_state:{selected:true,deleted:false}});

                         if (selection.length != 0) {
                             if(selection[0]._state.added===true) {
                                 edit_cnt--;
                             } else  {
                                 edit_cnt++;
                             }
                         }
                         if(edit_cnt.length>50) {
                            $.alopex.info('50건 이상의 데이터를 넣을 수 없습니다.');
                            return false;
                         }
                       },
                       "edit" : function(data, query) {
                         var $grid = '#'+this.attr('id');
                         var edit_cnt = $(this).alopexGrid("dataGet", {_state:{edited:true}}, {_state:{added:true}}, {_state:{deleted:true}}).length;
                         var selection = $(this).alopexGrid('dataGet', {_state:{selected:true}});

                         if (selection.length != 0) {
                             if(selection[0]._state.added===false && selection[0]._state.edited===false) {
                                 edit_cnt++;
                             }
                         }
                         if(edit_cnt.length>=50) {
                            alert('50건 이상의 데이터를 넣을 수 없습니다.');
                            return false;
                         }
                       }
                   }
                }
            });


            //---------------------------------------------------------------------------------------------------------------//
            $.alopex.request.setup({
                platform: 'NEXCORE.J2EE',
                url: function(args1, args2) {
                    var reqUrl = args2.url;
                    if (args2.url) {
                        return args2.url;
                    }
                    return _DEFAULT_REQ_URL;
                },
                method : "POST",
                dataType: 'json',
                timeout: 100000,
                before : function(id, option) {
                    this.requestHeaders["Content-Type"] ="application/json; charset=UTF-8";
                    if ( null != option ) {
                        if ( null==option["showProgress"] || true==option["showProgress"] ) {
                            //$('body').progress();
                        }
                    }
                },
                after : function(res) {
                    var overlay = $('body').data('alopexOverlay');
                    if ( null!=overlay && null!=overlay.progress) {
                        //$('body').progress().remove();
                    }
                },
                success : function(res) {
                    if ( "FAIL" == res.dataSet.message.result ) {
                        var msgId = res.dataSet.message.messageId;
                        var msgNm = res.dataSet.message.messageName;
                        if ( msgNm.indexOf(msgId)>=0 ) {
                            var arrMsgNm = msgNm.split( msgId + ":" );
                            msgNm = arrMsgNm[1];
                        }
                        $.PSNM.alert(msgNm.replace(/\\n/gi, "\n")); //
                    }
                },
                fail : function(res) {
                    //$('body').progress().remove();
                    if ( undefined==res ) {
                        if ( confirm("연결이 끊어졌습니다. 로그인 화면으로 이동하시겠습니까?") ) {
                            window.location.href = _LOGIN_URL;
                        }
                    }
                    else {
                        alert(res.dataSet.message.messageName);
                    }
                },
                error : function() {
                    //$('body').progress().remove();
                    alert('<<ERROR>> errorcode = ' + this.status + ' message = ' + this.statusText);
                }
            });

            //---------------------------------------------------------------------------------------------------------------//
            $.alopex.setup('datepicker', {
                selectyear: true,
                selecmonth: true,
                showothermonth: true,
                showbottom: true
            });

            $a.setup('dateinput', {
                placeholder: false
            });
 
            $a.setup('daterange', {
                placeholder: false
            });

            //---------------------------------------------------------------------------------------------------------------//
            $.alopex.setup('dialog', {
                modal: true,
                movable: true,
                modalscrollhidden: false
            });

            //---------------------------------------------------------------------------------------------------------------//

            $a.popup.setup({
                //width: 1000,
                //height: 500,
                center: true,
                modal: true,
                movable: true,
                windowpopup: false,
                iframe: true,
                url:function(sUrl) {
                    if ( sUrl.indexOf(_CTX_PATH + "view/") === 0 )
                        return sUrl;
                    return _CTX_PATH + "view/" + sUrl + ".jsp";
                }
            });
            
/*            $a.navigate.setup({
                url: function(url, param) {
                    return url; // + '.jsp';
                }
            });*/

            // alopex databind selectbox getData 수행시 options 데이터 넘기지 않도록 수정
            //@2015-03-10 : [$a.data.control('options'...] 부분 삭제 : alopex-ui 업그레이드됨

//-----------------------------------------------------------------------------------------------------------------------//

function _debug() {
    if (_LOG_LEVEL>0) { return; }
    var today = new Date();
    var sb = "[DEBUG] [" + today.format("mm-dd HH:MM:ss") + "] ";

    for(var i in arguments) {
        sb+= "<" + arguments[i] + ">";
    }
    console.log(sb);
}

function _info() {
    if (_LOG_LEVEL>1) { return; }
    var today = new Date();
    var sb = "[INFO!] [" + today.format("mm-dd HH:MM:ss") + "] ";

    for(var i in arguments) {
        sb+= "<" + arguments[i] + ">";
    }
    console.log(sb);
}

function _error() {
    var today = new Date();
    var sb = "[#ERROR#] [" + today.format("mm-dd HH:MM:ss") + "] ";

    for(var i in arguments) {
        sb+= "<" + arguments[i] + ">";
    }
    console.log(sb);
}


String.prototype.endsWith = function(pattern) {
    var d = this.length - pattern.length;
    return d >= 0 && this.lastIndexOf(pattern) === d;
};