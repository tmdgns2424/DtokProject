
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
    <jsp:include page="/view/layouts/default_head.jsp" flush="false" />
    <script type="text/javascript">
    var _param;
    var count = 0;
    var seq = 0;
    $.alopex.page({

        init : function(id, param) { 
            $.PSNM.initialize(id, param);                                                                           // PSNM공통 초기화함수 호출
            _param = param;
            
            $a.page.setCodeData();
            $a.page.setEventListener();
            $a.page.setGrid();
            $a.page.setsndgrid();
            
        },
        setCodeData : function() {

            $a.page.phonSet();
                                                                                                                                // 카운트 셋팅
            $("#count").append(count);
                                                                                                                    // 메세지 카운트 셋팅
            $("#tcount").append("0");
                                                                                                                    // 이동전화 앞자리 3자리 셋팅
            $.PSNMUtils.setCodeData([
                { t:'code', 'elemid' : 'MBL_PHON_NUM1', 'codeid' : 'HP_FRST_NO', 'header' : '-선택-' },              // 이동전화
            ]);    
        },
        phonSet : function() {
            var phon= $.PSNM.getSession("MBL_PHON");
            var phon1 = phon.substr(0,3);
            var phon2 = phon.substr(3,4);
            var phon3 = phon.substr(7,4);

            phon = phon1+"-"+phon2+"-"+phon3;
            $("#my_phon").val(phon);

        },
        setEventListener : function() {
            $("#DUTY_TYP_ID" ).bind("change",dutySearch);                                                           // 직무 조회
            $("#my_phon" ).keyup(function(){                                                                        // 전화번호가 바뀌면
            	if (13!=event.keyCode) {
                    return;
                }
           		var phon_num = $.PSNMUtils.getRequestData("phoneForm").dataSet.fields.my_phon;
           		phon_num = phon_num.replace(/\-/g,'');
           		           		
                if(phon_num.length<11){
                	alert("전화번호를 확인해 주세요");
                	return;
                }else{
                    var phon1 = phon_num.substr(0,3);
                    var phon2 = phon_num.substr(3,4);
                    var phon3 = phon_num.substr(7,4);

                    phon_num = phon1+"-"+phon2+"-"+phon3;
                    $("#my_phon").val(phon_num);
                }
            });
            
            $("#btnSearch").click( $a.page.searchList );                                                            // 조회
            $("#btnAddG").click( $a.page.AddGridUser );                                                             // 그리드에서 전달
            $("#btnAddF").click( $a.page.AddFormUser );                                                             // 폼에서 전달
            $("#btnSnd").click( $a.page.messageSnd );                                                               // 전송시
            $("#btnDel").click(function(){                                                                          // 삭제시
                var edit = $("#sndgrid").alopexGrid( "dataGet" , { _state : { selected : true } } );                // 체크된인원 파악
                $("#sndgrid").alopexGrid("dataDelete", {_state:{selected:true}});                                   // 체크된인원 그리드에서 지움
                count -= edit.length;
                $("#count").empty();
                $("#count").append(count);
            });
            $("#message").bind("keyup change input", function() {
                var requestData = $.PSNMUtils.getRequestData("msForm");
                var str = requestData.dataSet.fields.message;
                var _byte = 0;
                    if(str.length != 0)
                    {
                        for (var i=0; i < str.length; i++) 
                        {
                            var str2 = str.charAt(i);
                            if(escape(str2).length > 4)                                                     // 아스키코드 인코딩
                            {
                                _byte += 2;
                            }
                            else 
                            {
                                _byte++;
                            }
                        }
                    }
                    if(_byte<81){
                        $("#mark").empty();
                        $("#mark").append("SMS &nbsp;");                    	
                    }else{
                        $("#mark").empty();
                        $("#mark").append("LMS &nbsp;");                    	
                    }
                    $("#tcount").empty();
                    $("#tcount").append(_byte);
            });
        },
       
        setGrid : function() {
            $("#userListgrid").alopexGrid({
                pager: false,
                rowSingleSelect : false,
                rowClickSelect : true,
                rowInlineEdit : true,
                height : 400,
                columnMapping : [
                                 {	columnIndex : 0, width : "8px",				selectorColumn : true									},
                                 {	columnIndex : 1, width : "12px",			title : "번호",		numberingColumn : true				},
                                 {	columnIndex : 2, key : "HDQT_PART_ORG_NM",	title : "본사파트",	align: "center",	width: "30px"	},
                                 {	columnIndex : 3, key : "SALE_DEPT_ORG_NM", 	title : "영업국명",  	align: "center", 	width: "30px"	},
                                 {	columnIndex : 4, key : "SALE_TEAM_ORG_NM",	title : "영업팀명",  	align: "center",	width: "30px"	},
                                 {	columnIndex : 5, key : "DUTY_NM", 			title : "직무",		align: "center", 	width: "30px"	},
                                 {	columnIndex : 6, key : "USER_ID2", 			title : "거래처코드",	align: "center", 	width: "30px"	},
                                 {	columnIndex : 7, key : "USER_NM", 			title : "거래처명", 	align: "center",	width: "30px"	},
                                 {	columnIndex : 8, key : "PHON_NUM", 			title : "전화번호", 	align: "center", 	width: "30px"	},
                                 {	columnIndex : 9, key : "MBL_PHON_NUM1", 	hidden:true	},
                                 {	columnIndex : 10, key : "MBL_PHON_NUM2", 	hidden:true	},
                                 {	columnIndex : 11, key : "MBL_PHON_NUM3", 	hidden:true	},
                                 {	columnIndex : 12, key : "USER_ID",  		hidden:true	},
                                 {	columnIndex : 13, key : "FLAG", 			hidden:true	},
            ],
            on : {
            },
          });
        },  
        setsndgrid : function() {
                                                                                                                    // 전달받은 그리드
            $("#sndgrid").alopexGrid({
                pager: false,
                rowSingleSelect : false,
                rowClickSelect : true,
                height : 100,
                columnMapping : [
                                 {	columnIndex : 0, key : "FLAG", 				hidden:true	},
                                 {	columnIndex : 1, numberingColumn : true,	title : "번호",							width: "8px"	},
                                 {	columnIndex : 2, key : "USER_NM", 			title : "거래처명",	align: "center", 	width: "25px"	},
                                 {	columnIndex : 3, key : "PHON_NUM", 			title : "전화번호",	align: "center", 	width: "27px"	},
                                 {	columnIndex : 4, key : "RCV_PHN_ID",		hidden:true	},
                                 {	columnIndex : 5, key : "USER_ID", 			hidden:true	},
                                 

                ],
                on : {
                    data : {                                                                                        // 100건 제한
                        "add" : function(data, query) {
                            var edit_cnt = $(this).alopexGrid("dataGet", {_state:{edited:true}}, {_state:{added:true}}, {_state:{deleted:true}}).length;
                            var add_len = $.isArray(data) ? data.length : 1;
                            if(edit_cnt+add_len>100) {
                                alert('100건 이상의 데이터를 넣을 수 없습니다.');
                                return false;
                            }
                        },
                        changed : function(type) {                                                                  // 5개가 넘어가면 크기고정 그전에는 크기 미정
                            var len = $("#sndgrid").alopexGrid('pageInfo').dataLength || 0;
                            if(len >= 5 && $("#sndgrid").alopexGrid('readOption').height !== 440) {
                                $("#sndgrid").alopexGrid('updateOption', {height:200});
                            } else if(len < 5) {
                                $("#sndgrid").alopexGrid('updateOption', {height:null});                            // 자동높이기능
                            }
                        },
                    }
                },
            });
        }, 
        searchList: function(param) {
            if ( !$.PSNM.isValid("#searchTable") ) {
                return false;
            }
            $.alopex.request("biz.SMSMGMT@PSMSMGMT001_pSearchUser", {
                data: "#searchForm",
                success: "#userListgrid"
            });
        },
        messageSnd: function(param) {
                                                                                                                    // sndgrid에 모든 값은 FLAG:I sndgrid에 모든값을 가져옴 
            var IRecord = $("#sndgrid").alopexGrid( "dataGet" , {"FLAG":"I"} ); 
                                                                                                                    // 메세지
            var message =  $.PSNMUtils.getRequestData("msForm").dataSet.fields.message;
                                                                                                                    // 수신자 존재 여부
            var phon    =  $.PSNMUtils.getRequestData("phoneForm").dataSet.fields.my_phon;                          // 발신번호
        	    phon = phon.replace(/\-/g,'');
       		                                                                                                                 
            if (IRecord.length == 0) {
                alert("전송할 전화번호가 존재하지 않습니다.");
                return;
            }
                                                                                                                    // 메세지 존재여부
            if (message.length == 0) {
                alert("전송할 내용이 내용이 없습니다.");
            return;
            }
                                                                                                                    
            if (phon.length <11 ){
            	alert("발신번호가 올바르지 않습니다.");
                return;
            }
                                                                                                                    // 전송
            if( $.PSNM.confirm("I004", ["전송"] ) ){
                var requestData = $.PSNMUtils.getRequestData("sndgrid");
                
                requestData.dataSet.fields.SND_MSG         = message;
                requestData.dataSet.fields.SND_PHN_ID      = $.PSNM.getSession("MBL_PHON");
                requestData.dataSet.fields.TRAN_SYS        = "";

                $.alopex.request("biz.SMSMGMT@PSMSMGMT001_pSndMessage", {
                       data : requestData,  
                    success : function(res) {
                    alert("전송이 완료되었습니다.");

                    $a.navigate("smsSnd.jsp", _param)
                    }
                });
            }
        },
                                                                                                                    // 그리드에서 데이터 추가 클릭시 실행되는 함수
        AddGridUser : function(param) {
                                                                                                                    // 선택된 데이터 유무 확인
            var oResult = $("#userListgrid").alopexGrid( "dataGet" , { _state : { selected : true } } );
			var curResult = $("#sndgrid").alopexGrid( "dataGet" );
			
			//전화번호 중복체크 
			for(var i=0 ; i<oResult.length ; i++) {
					var flag = false;
					for(var j=0 ; j<curResult.length ; j++) {
						if(oResult[i].PHON_NUM == curResult[j].PHON_NUM){
						flag = true;
							break;
						}	
					}	
					if(flag == false){
						   $("#sndgrid").alopexGrid("dataAdd",{
			                    "FLAG" : "I",
			                    "NUM" : seq,
			                    "USER_NM" : oResult[i].USER_NM,
			                    "PHON_NUM" : oResult[i].PHON_NUM,
			                    "USER_ID" : oResult[i].USER_ID,
			                    "RCV_PHN_ID" : oResult[i].MBL_PHON_NUM1+oResult[i].MBL_PHON_NUM2+oResult[i].MBL_PHON_NUM3,
			                });
			                if(99<count){
			                    return false;
			                }
			                count ++;
			                seq++;
			                $("#count").empty();
			                $("#count").append(count);                      //체크되어있는 사람 FLAG 값을 I로 바꿈  
					}						
				}
                                                                                                                    
                                                                                
			   $("#userListgrid").alopexGrid("dataDelete", {_state:{selected:true}});                                                                                          
        },                                                                                                                    // 추가된 그리드 윗부분에서 데이터 추가 하는 함수(전화번호 입력)
        AddFormUser : function(param) {
                                                                                                                    // 폼에서 데이터 넘긴뒤
            var requestData = $.PSNMUtils.getRequestData("sendForm");
                                                                                                                    // 데이터 값 검증
            if ( !$.PSNM.isValid("sendForm") ) {
                return false;
            }
                                                                                                                    // 전화번호 데이터 추출
            var MBL_PHON_NUM1 = requestData.dataSet.fields.MBL_PHON_NUM1;
            var MBL_PHON_NUM2 = requestData.dataSet.fields.MBL_PHON_NUM2;
            var MBL_PHON_NUM3 = requestData.dataSet.fields.MBL_PHON_NUM3;
            var PHON_NUM = MBL_PHON_NUM1+"-"+MBL_PHON_NUM2+"-"+MBL_PHON_NUM3;
            var RCV_PHN_ID = MBL_PHON_NUM1+MBL_PHON_NUM2+MBL_PHON_NUM3;
                                                                                                                    // 추출한 데이터 값 검증
            if(MBL_PHON_NUM2.length<3){
                alert("가운데 전화번호는  3자리 이상입니다.");
                return false;
            }if(MBL_PHON_NUM3.length<4){
                alert("전화번호 마지막번호는  4자리 입니다.");
                return false;
            }
                                                                                                                    // 데이터중복확인
            var addr = $("#sndgrid").getData().sndgrid.list;
            for( var a=0; a<addr.length; a++ ){
                if( addr[a].PHON_NUM == PHON_NUM){
                    alert("이미 추가된 전화번호 입니다.");
                    return false;
                }
            }
                                                                                                                    // 데이터 추가
            $("#sndgrid").alopexGrid("dataAdd", {
                "FLAG" : "I",
                "NUM" : seq,
                "USER_NM" : "",
                "PHON_NUM" : PHON_NUM,
                "RCV_PHN_ID" : RCV_PHN_ID,
            });
                                                                                                                    // 전화번호 FORM 초기화
            $("#sendForm").setData({MBL_PHON_NUM1:""});
            $("#MBL_PHON_NUM2").val("");
            $("#MBL_PHON_NUM3").val("");
                                                                                                                    // 100명까지만 추가
            if(99<count){
                return false;
            }
                                                                                                                    // 카운트 셋팅
            seq ++;
            count ++;
            $("#count").empty();
            $("#count").append(count);
        },
    });
                                                                                                                    // 직무찾기
    function dutySearch(e) {
        var data = {"DUTY_TYP_DT":""};
        $("#searchForm").setData(data);
        $.alopex.request("biz.SMSMGMT@PSMSMGMT001_pSearchDuty", {

            data: ["#searchForm", function() {
            }],
            success: function(res) {
                var codeList = res.dataSet.recordSets.resultList.nc_list;
    
                var codeOptions = [];
                    codeOptions.push({ value: "", text: "-전체-"});
                $.each(codeList, function (index, codeinfo) {
                    var codeOpt = new Object();
                    codeOpt["value"] = codeinfo.DUTY_CD;
                    codeOpt["text"]  = codeinfo.DUTY_NM;
                    codeOptions.push(codeOpt);
                });
                var optData = new Object();
                optData["options_DUTY_TYP_DT"] = codeOptions;
                $("#DUTY_TYP_DT").setData(optData);
           }
        });
    }
    </script>
</head>
<body>
<jsp:include page="/view/layouts/default_header.jsp" flush="false" />
<div id="contents">
	<div class="content_title">
    	<div class="ub_txt6">
        	<span class="txt6_img"><b id="sub-title">메뉴제목</b>
        	<span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif"> 
        	<span class="a2">대메뉴명</span> <span class="a3"> > </span> <span class="a4"><b>중메뉴명</b> </span></span></span>
       	</div>
    </div>

    <div class="sms_wrap">
        <!-- message start -->
        <div class="sms_section">
            <div class="floatL4"> 
                <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif">
                <b>메시지 발송</b>
            </div>
            <div class="textAR">
                <form id="msForm" onsubmit="false">
                    <textarea class="message" id="message"></textarea>
                </form>
               <p class="count"><b id="mark"></b><em id="tcount"></em> byte</p>
               <form id="sendForm" onsubmit="false" >
                <p class="textAR fclear">
                    <span class="fleft" style="width:60%;">
                        <select id="MBL_PHON_NUM1" name="MBL_PHON_NUM1" data-bind="options: options_MBL_PHON_NUM1, selectedOptions: MBL_PHON_NUM1" data-type="select" data-wrap="false" style="width:30%"
                                    data-validation-rule="{required:true}" 
                                    data-validation-message="{required:$.PSNM.msg('E012', ['연락처'])}"></select>-
                        <input id="MBL_PHON_NUM2" data-bind="value:MBL_PHON_NUM2" type="text" data-type="textinput" data-keyfilter-rule="digits" size="4" maxlength="4"style="width:20%;padding-top: 0px;"
                                    data-validation-rule="{required:true}" 
                                    data-validation-message="{required:$.PSNM.msg('E012', ['연락처'])}">- 
                        <input id="MBL_PHON_NUM3" data-bind="value:MBL_PHON_NUM3" type="text" data-type="textinput" data-keyfilter-rule="digits" size="4" maxlength="4"style="width:20%;width:20%;padding-top: 0px;"
                                    data-validation-rule="{required:true}" 
                                    data-validation-message="{required:$.PSNM.msg('E012', ['연락처'])}">           
                    </span>
                    <span class="fright aright" style="width:40%;">
                        <button type="button" id="btnAddF" data-type="button" data-theme="af-btn16" data-altname="추가"></button>
                        <button type="button" id="btnDel" data-type="button" data-theme="af-btn28" data-altname="삭제"></button>
                    </span>
                </p>
                </form>
            </div>
            <div id="sndgrid" data-bind="grid:sndgrid"></div>
            <div class="textAR fclear" >
                <form id="phoneForm" onsubmit="return false;">
                    <span class="fleft" style="width:80%;">
                        <strong style="padding: 10px;">발신번호</strong>
                        <input id="my_phon" data-bind="value:my_phon" data-type="textinput" style="width:50%; text-align: right; padding-right: 10px;"data-keyfilter-rule="digits" size="4" maxlength="11" class="af-textinput af-default" data-converted="true" >
                    </span>
                </form>
                <span class="fright" style="width:20%;"><p class="count" style="padding-right: 10px;"><em id="count"></em>/100 명</p></span>
            </div>
            <div class="btn_right">
                <input id="btnSnd" type="button" data-type="button" class="af-button af-n-btn13" />
            </div>
        </div><!-- //message end -->
        <!-- search start -->
        <div class="sms_section">
            <div class="floatL4"> 
                <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif">
                <b>발송 대상 조회</b>
            </div>
            <div id="searchDiv" class="textAR"> 
                <form id="searchForm">
                    <table id="searchTable" class="board02">
                        <colgroup>
                            <col style="width:15%"/>
                            <col style="width:35%"/>
                            <col style="width:15%"/>
                            <col style="width:35%"/>
                        </colgroup>
                        <tr>
                            <th style="width:100px;" class="psnm-required">본사팀</th>
                            <td class="tleft">
                                <select id="HDQT_TEAM_ORG_ID" name="HDQT_TEAM_ORG_ID" data-bind="options:options_HDQT_TEAM_ORG_ID, selectedOptions:HDQT_TEAM_ORG_ID"  data-type="select" data-wrap="false"
                                        data-validation-rule="{required:true}" 
                                        data-validation-message="{required:$.PSNM.msg('E012', ['본사팀'])}" style="width:150px;">
                                    <option value="">-선택-</option>
                                    <!-- <option value="324031">(324031) B2B사업팀</option> -->
                                </select>
                            </td>
                            <th style="width:100px;" class="psnm-required">본사파트</th>
                            <td class="tleft">
                                <select id="HDQT_PART_ORG_ID" name="HDQT_PART_ORG_ID" data-bind="options:options_HDQT_PART_ORG_ID, selectedOptions:HDQT_PART_ORG_ID"  data-type="select" data-wrap="false"
                                        data-validation-rule="{required:true}" 
                                        data-validation-message="{required:$.PSNM.msg('E012', ['본사파트'])}" style="width:150px;">
                                    <option value="">-선택-</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <th style="width:100px;">영업국명</th>
                            <td class="tleft">
                                <select id="SALE_DEPT_ORG_ID" data-bind="options:options_SALE_DEPT_ORG_ID, selectedOptions: SALE_DEPT_ORG_ID" data-dtokall="true" data-type="select" data-wrap="false" style="width:150px;">
                                    <option value="">-전체-</option>
                                </select>
                            </td>
                            <th style="width:100px;">영업팀명</th>
                            <td class="tleft">
                                <select id="SALE_TEAM_ORG_ID" data-bind="options:options_SALE_TEAM_ORG_ID, selectedOptions: SALE_TEAM_ORG_ID" data-type="select" data-wrap="false" style="width:150px;">
                                    <option value="">-전체-</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <th style="width:100px;">직무구분</th>
                            <td class="tleft">
                                <select id="DUTY_TYP_ID" data-bind="options:options_DUTY_TYP_ID, selectedOptions: DUTY_TYP_ID" data-type="select" style="width:150px">
                                    <option value="00">-전체-</option>
                                    <option value="1">임직원</option>
                                    <option value="3">도급직</option>
                                    <option value="4">에이전트</option>
                                </select>
                            </td>
                            <th style="width:100px;">거래처명</th>
                            <td class="tleft">
                                <input id="AGNT_NM" data-bind="value:AGNT_NM" data-type="textinput" style="width:150px">
                            </td>
                        </tr>
                        <tr>
                            <th style="width:100px;">직무</th>
                            <td class="tleft">
                                <select id="DUTY_TYP_DT" name="DUTY_TYP_DT" data-bind="options:options_DUTY_TYP_DT, selectedOptions:DUTY_TYP_DT"  data-type="select" data-wrap="false" style="width:150px">
                                    <option value="">-전체-</option>
                                </select>
                            </td>
                            <th scope="row">사무국여부<br/>(임직원,협력직원)</th>
                            <td colspan="3" class="tleft">
                                <input id="DSM_TYP_CD1" type="checkbox" data-type="checkbox" name="DSM_TYP_CD1" data-bind="checked:DSM_TYP_CD1" value="Y" checked="checked">
                                    <label for="checkbox1">사무국원</label>
                                <input id="DSM_TYP_CD2" type="checkbox" data-type="checkbox" name="DSM_TYP_CD2" data-bind="checked:DSM_TYP_CD2" value="Y">
                                <label for="checkbox2">비 사무국원</label>
                            </td>
                        </tr>
                    </table>
                    ※ 임직원/ 협력직원 문자 수신자 추가는 임직원로그인관리 화면에서 SMS수신여부가 Y인 경우만 가능
                </form>
                <div class="btn_right">
                    <input id="btnSearch" type="button" value="" data-type="button" data-theme="af-psnm">
                </div>
            </div>
            <div id="userListgrid" data-bind="grid:userListgrid"></div>
            <div class="btn_right">
                <input id="btnAddG" type="button" data-type="button" class="addButton">
            </div>
        </div><!-- //search end -->
    </div>
</div>
<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />
</body>
</html>