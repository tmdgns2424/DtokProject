
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <jsp:include page="/view/layouts/default_head.jsp" flush="false" />
    <script type="text/javascript">
    var _param;
    $.alopex.page({
        init : function(id, param) { 
            $.PSNM.initialize(id, param); //PSNM공통 초기화함수 호출
            
            _param = param;
            $a.page.setEventListener();
            $a.page.setGrid();
                                                                                        // 전체 본사팀 셋팅
            $a.page.setTeamCd();
                                                                                        // 공통 메세지 구분 셋팅
            $a.page.setCodeData();
            $a.page.setValidators();
            dutySearch();
        },
        setEventListener : function() {
            $("#btnSearch").click( $a.page.searchList );                                // 조회
            $("#btnFindUser").click( popFindSMember );                                  // 찾기버튼
            $("#AGNT_NM").keyup( $.PSNMAction.findSmember );                            // 이름 검색
            $("#HDQT_TEAM_CD" ).bind("change",partSearch);                              // 본사팀의 결과에 따른 본사파트 셋팅

            $("#btnSave").click(function(){                                             // 저장
                var validator = $("#form").validator();
                    if ( !validator.validate() ) {                                      // 값 검증 
                        var errormessages = validator.getErrorMessage();
                        for(var name in errormessages) {
                            for(var i=0; i < errormessages[name].length; i++) {
                                $.PSNM.alert(errormessages[name][i]);
                                $("#form").find("#" + name).focus();
                                return false;                                           // 여기서 반환
                            }
                        }
                    } 
                if( $.PSNM.confirm("I004", ["저장"] ) ){                                 // 저장여부
                    var requestData = $.PSNMUtils.getRequestData("form");
                        $.alopex.request("biz.SMSMGMT@PSMSMGMT001_pSaveSmsSnd", {
                            data: requestData, 
                            success: function(res) {
                            if(res.dataSet.fields.count != 0){                          // 중복처리
                                $.PSNM.alert("이미 등록된 회원ID 입니다.");
                                return;
                            }
                            $.PSNM.alert("등록이 정상 처리 되었습니다.");                         // 등록완료 
                            $a.page.searchList(_param); 
                            }
                    });
                    }
                });
            $("#btnNew").click(function(){                                              // 등록시 detail에 모든정보 리셋
                var data = {"AGNT_NM":"","AGNT_ID":"","PART_NM":"","DUTY_NM":"","HDQT_TEAM_CD":"","HDQT_PART_CD":"","STRD_CL_VAL_CD":""}
                $("#form").setData(data);
                $("#detail").show(); 
            });
            
            $("#btnDel").click(function(){                                              // 삭제시
                                                                                        // 선택된 데이터를 찾고
                var oRecord = $("#grid").alopexGrid( "dataGet" , { _state : { selected : true } } );
                                                                                        // 데이터가없으면 넘겨줌
                if (oRecord.length == 0) {
                    $.PSNM.alert("E021", ["삭제할 행을"]);
                    return;
                }
                                                                                        // 데이터가 존재하면 FALG값을 D로 바꿔주고 삭제 
                $("#grid").alopexGrid( "dataEdit", {"FLAG":"D"}, { _state: { selected : true } } );
                if( $.PSNM.confirm("I004", ["삭제"] ) ){
                    var requestData = $.PSNMUtils.getRequestData("grid");
                    $.alopex.request("biz.SMSMGMT@PSMSMGMT001_pDeleteSmsSnd", {
                        data: requestData,
                        success : function(res) {
                            $a.page.searchList(_param);
                        }
                    });
                }
            });
        },
                                                                                        // 그리드셋팅
        setGrid : function() {
            $("#grid").alopexGrid({
                pager: false,
                rowSingleSelect : false,
                rowClickSelect : true,
                rowInlineEdit : true,
                height : "400px",
                columnMapping : [
                    { columnIndex : 0, selectorColumn : true,   width : "20px" },
                    { columnIndex : 1, key :  "TRAN_TYP_NM",    title : "메세지구분",   align : "center",   width : "60px"  },
                    { columnIndex : 2, key :  "ORG_NM",         title : "본사팀",       align : "center",   width : "40px"  },
                    { columnIndex : 3, key :  "OUT_ORG_NM",     title : "본사파트",     align : "center",   width : "40px"  },
                    { columnIndex : 4, key :  "USER_ID",        title : "사용자ID",     align : "center",   width : "40px"  },
                    { columnIndex : 5, key :  "DUTY_NM",    	title : "직무명",       align : "center",   width : "50px"  },
                    { columnIndex : 6, key :  "USER_NM",        title : "임직원명",     align : "center",   width : "40px"  },
                    { columnIndex : 7, key :  "MENU_NM",        title : "관련메뉴",     align : "center",   width : "60px"  },
                    { columnIndex : 8, key :  "TRAN_MSG",       title : "메시지",       align : "left",     width : "180px" },
                    { columnIndex : 9, key :  "H_USER_ID",      hidden: true},
                    { columnIndex : 10,key :  "TRAN_TYP_CD",    hidden: true},
                    { columnIndex : 11,	key : "FLAG", 		hidden:true 
                        , value : function(value, data) {
                            if ( "I" == value || "D" == value ) { return value; } //추가|삭제는 그냥둠
                            return ( (data._state.edited) ? 'U' : '' ); 
                        }   
                    },
                    ],
                on : {
                }
            });
        },
        setCodeData : function() {
                                                                                        // 메세지구분 셋팅
            $.PSNMUtils.setCodeData([
             { "elemid" : "STRD_CL_VAL_CD", "codeid" : "DSM_STRD_CL_VAL_CD", "header" : "-선택-", "ADD_INFO_01":"SMS" } 
            ]);
                                                                                        // 위에서 받아온 Option을 DETAIL에 동일하게 셋팅
            var s2 = $("#STRD_CL_VAL_CD").html();
            $("#STRD_CL_VAL_ID").html(s2);
        },
        setTeamCd : function() {
                                                                                        // 본사팀 셋팅
            $.alopex.request("biz.SMSMGMT@PSMSMGMT001_pSearchHTeam", {
                data: ["#form", function() {
                }],
                success: function(res) {
                    var codeList = res.dataSet.recordSets.resultList.nc_list;
                    var codeOptions = [];
                        codeOptions.push({ value: "", text: "-선택-"});
                    $.each(codeList, function (index, codeinfo) {
                        var codeOpt = new Object();
                        codeOpt["value"] = codeinfo.HDQT_TEAM_ORG_ID;
                        codeOpt["text"]  = codeinfo.HDQT_TEAM_ORG_NM;
                        codeOptions.push(codeOpt);
                    });
                    var optData = new Object();
                        optData["options_HDQT_TEAM_CD"] = codeOptions;
                    $("#HDQT_TEAM_CD").setData(optData);
                }
            });
        },
                                                                                        // 조회
        searchList: function(param) {
            $("#detail").hide();

            var data = {"AGNT_NM":"","AGNT_ID":"","PART_NM":"","DUTY_NM":"","HDQT_TEAM_CD":"","HDQT_PART_CD":"","STRD_CL_VAL_CD":"","FLAG":""}
            $("#form").setData(data);

            if ( !$.PSNM.isValid("#searchTable") ) {
                return false;
            }
            var requestData = $.PSNMUtils.getRequestData("searchForm");
            $.alopex.request("biz.SMSMGMT@PSMSMGMT001_pSearchSmsMgmt", {
                data: requestData,
                success: "#grid"
            });
        },
                                                                                        // SEARCH FORM 값 검증
        setValidators : function() {
            $('#HDQT_TEAM_ORG_ID').validator({
                rule : { required: true },
                message: {
                    required: $.PSNM.msg('E012', ["본사팀"])                            // {0} 항목은 필수값입니다!
                }
            });
            $('#HDQT_PART_ORG_ID').validator({
                rule : { required: true },
                message: {
                    required: $.PSNM.msg('E012', ["본사파트"])                          // {0} 항목은 필수값입니다!
                }
            });
            $('#STRD_CL_VAL_CD').validator({
                rule : { required: true },
                message: {
                    required: $.PSNM.msg('E012', ["메세지구분"])                        // {0} 항목은 필수값입니다!
                }
            });
        }
        
    });
    
    function popFindSMember() {                                                         // 임직원 찾기팝업-데이터 전송 및 반환
        _debug("<popFindSMember> 현재 alopex세션값 : \n###### " + JSON.stringify( $a.session("alopex_parameters") ));
        var oParam = new Object();
            oParam.USER_NM   = $('#form').getData().AGNT_NM;
            if(oParam.USER_NM.length<2){
                alert("직원명을 2자이상 입력하십시오. ");
                $("#form").find("#AGNT_NM").focus();
                return false;
            }  
        _debug("<popFindSMember> 팝업으로 전달하려는 값 : \n###### " + JSON.stringify(oParam));

        $.PSNMAction.popFindSmember(oParam, function(oResult) {
            if ( null!=oResult && typeof oResult == "object" ) {
                $("#AGNT_NM").val( oResult["USER_NM"] );
                $("#AGNT_ID").val( oResult["USER_ID"] );
                $("#PART_NM").val( oResult["HDQT_PART_ORG_NM"] );
                $("#DUTY_NM").val( oResult["DUTY_NM"] );
            }
        });
    }
    function TeamSearch(e) {                                                            // 대상 본사팀 찾기가져오기 
        $.alopex.request("biz.SMSMGMT@PSMSMGMT001_pSearchHTeam", {
            data: ["#form", function() {
             }],
            success: function(res) {
                var codeList = res.dataSet.recordSets.resultList.nc_list;

                var codeOptions = [];
                    codeOptions.push({ value: "", text: "-선택-"});
                $.each(codeList, function (index, codeinfo) {
                    var codeOpt = new Object();
                    codeOpt["value"] = codeinfo.HDQT_PART_ORG_ID;
                    codeOpt["text"]  = codeinfo.HDQT_PART_ORG_NM;
                    codeOptions.push(codeOpt);
                });
                var optData = new Object();
                    optData["options_HDQT_TEAM_CD"] = codeOptions;
                $("#HDQT_TEAM_CD").setData(optData);
            }
        });
    }
    function partSearch(e) {                                                            // 대상 본사파트 찾기가져오기 
        $.alopex.request("biz.SMSMGMT@PSMSMGMT001_pSearchHPart", {
            data: ["#form", function() {
             }],
            success: function(res) {
                var codeList = res.dataSet.recordSets.resultList.nc_list;

                var codeOptions = [];
                    codeOptions.push({ value: "", text: "-선택-"});
                $.each(codeList, function (index, codeinfo) {
                    var codeOpt = new Object();
                    codeOpt["value"] = codeinfo.HDQT_PART_ORG_ID;
                    codeOpt["text"]  = codeinfo.HDQT_PART_ORG_NM;
                    codeOptions.push(codeOpt);
                });
                var optData = new Object();
                    optData["options_HDQT_PART_CD"] = codeOptions;
                $("#HDQT_PART_CD").setData(optData);
            }
        });
    }
    function dutySearch(e) {

    	
        var requestData = $.PSNMUtils.getRequestData("searchForm");
        
        $.alopex.request("biz.SMSMGMT@PSMSMGMT001_pSearchDutySMgtm", {

            data: requestData,
            success: function(res) {
            	var codeList = res.dataSet.recordSets.resultList.nc_list;
                var codeOptions = [];
                    codeOptions.push({ value: "00", text: "-전체-"});
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

    <!-- sub title area -->
	<div class="content_title">
    	<div class="ub_txt6">
        	<span class="txt6_img"><b id="sub-title">메뉴제목</b>
        	<span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif"> 
        	<span class="a2">대메뉴명</span> <span class="a3"> > </span> <span class="a4"><b>중메뉴명</b> </span></span></span>
       	</div>
    </div>


    <!-- find condition area -->
    <div id="searchDiv" class="textAR">
          <form id="searchForm" onsubmit="return false;">
		        <table id="searchTable" class="board02" style="width:92%;">
		        <colgroup>
		            <col style="width:12%"/>
		            <col style="width:21%"/>
		            <col style="width:12%"/>
		            <col style="width:21%"/>
		            <col style="width:12%"/>
		            <col style="width:*"/>
		        </colgroup>
		       	<tbody>
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
                <th style="width:100px;" class="psnm-required">메세지구분</th>
                <td class="tleft">
                    <select id="STRD_CL_VAL_CD" name="STRD_CL_VAL_CD" data-type="select" data-bind="options: options_STRD_CL_VAL_CD, selectedOptions:STRD_CL_VAL_CD" data-wrap="false" style="width:185px!important">
                        <option value="">-선택-</option>
                    </select>
                </td>
        </tr>
        <tr>
           	<th style="width:100px;">직무명</th>
           	<td class="tleft">
           		<select id="DUTY_TYP_DT" name="DUTY_TYP_DT" data-bind="options:options_DUTY_TYP_DT, selectedOptions:DUTY_TYP_DT"  data-type="select" data-wrap="false" style="width:150px">
            		<option value="00">-전체-</option>
                </select>
           	</td>
           	<th>임직원명</th>
           	<td colspan="3" class="tleft">
                <input id="USER_NM" name="USER_NM" data-bind="value:USER_NM" data-type="textinput" style="width:100px;" />
           	</td>
        </tr>
            </tbody>
        </table>
        <div class="ab_pos5">
            <button id="btnSearch" type="button" data-type="button" data-theme="af-psnm" data-authtype="R"></button>
        </div>
        </form>
    </div>
    <div class="floatL4">
        <div class="ab_pos2">
            <button id="btnNew"  type="button" data-type="button" data-theme="af-btn2"  data-altname="신규" data-authtype="W"></button>
            <button id="btnDel"  type="button" data-type="button" data-theme="af-btn13" data-altname="삭제" data-authtype="W"></button>
            <button id="btnSave" type="button" data-type="button" data-theme="af-btn4"  data-altname="저장" data-authtype="W"></button>
        </div>
        <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>업무 유형별 수신 대상자</b>
    </div>

    <!-- main grid -->
    <div id="grid" data-bind="grid:grid"></div>
    
    <div id="detail" style="display: none;">
        <div class="floatL4">
            <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"/><b>대상자 선택</b>
        </div>
        <form id="form" onsubmit="return false;">
        <input id="FLAG" name="FLAG" type="hidden" data-bind="value:FLAG"/>
        <table class="board02" style="width:100%;">
        	<colgroup>
	            <col style="width:15%"/>
	            <col style="width:35%"/>
	            <col style="width:15%"/>
	            <col style="width:*"/>
            </colgroup>
            <tr>
                <th scope="col" class="fontred">임직원명</th>
                <td class="tleft">
                <input id="AGNT_NM" name="AGNT_NM" data-bind="value:AGNT_NM" data-type="textinput" data-agentid="AGNT_ID" data-dutynm="DUTY_NM" data-partnm="PART_NM"  maxlength="10" 
                data-validation-rule="{required:true}" data-validation-message="{required:$.PSNM.msg('E012', ['대상 회원ID'])}" />
                    <img id="btnFindUser" src="<c:out value='${pageContext.request.contextPath}'/>/image/btn_c9.gif"/>
                <input id="AGNT_ID" name="AGNT_ID" data-bind="value:AGNT_ID" data-type="textinput" data-disabled="true" disabled  />

        </td>
                <th scope="col">소속 본사파트/ 직무명</th>
                <td class="tleft">
                    <input id="PART_NM" name="PART_NM" data-bind="value:PART_NM" data-type="textinput" data-disabled="true" disabled  />
                    <input id="DUTY_NM" name="DUTY_NM" data-bind="value:DUTY_NM" data-type="textinput" data-disabled="true" disabled  />
                </td> 
            </tr>
            <tr>
                <th scope="col" class="fontred">대상 본사팀</th>
                <td class="tleft">
                    <select id="HDQT_TEAM_CD" name="HDQT_TEAM_CD" data-bind="options:options_HDQT_TEAM_CD, selectedOptions:HDQT_TEAM_CD"  data-type="select" data-wrap="false"
                            data-validation-rule="{required:true}"   
                            data-validation-message="{required:$.PSNM.msg('E012', ['대상 본사팀'])}" >
                            <option value="">-선택-</option>
                    </select>
                </td>
                <th scope="col" class="fontred">대상 본사파트</th>
                <td class="tleft">
                    <select id="HDQT_PART_CD" data-bind="options:options_HDQT_PART_CD, selectedOptions:HDQT_PART_CD"  data-type="select" 
                            data-validation-rule="{required:true}" 
                            data-validation-message="{required:$.PSNM.msg('E012', ['대상 본사파트'])}" style="width:150px;">
                            <option value="">-선택-</option>
                    </select>
                </td>
            </tr>
            <tr>
                <th scope="col" class="fontred">대상 메세지구분</th>
                <td class="tleft" colspan="3"> 
                    <select id="STRD_CL_VAL_ID"  data-bind="options: options_STRD_CL_VAL_CD, selectedOptions:STRD_CL_VAL_CD" data-type="select"
                        data-validation-rule="{required:true}"
                        data-validation-message="{required:$.PSNM.msg('E012', ['대상 메세지구분'])}">
                        <option value="">-선택-</option>
                    </select>
                </td>
            </tr>
        </table>
        </form>
    </div>     

</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>