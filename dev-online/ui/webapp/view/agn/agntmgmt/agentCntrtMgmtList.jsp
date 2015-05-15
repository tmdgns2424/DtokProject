<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
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
        	
        	$.PSNM.initialize(id, param);  //PSNM공통 초기화함수 호출
        	_param = param;
        	
           	$.PSNMUtils.setDefaultYmd("#FROM_DT", "TO_DT"); //조회일자(임시)
           	
           	$a.page.setEventListener(); //버튼 초기화
            $a.page.setCodeData();  //공통코드 호출
            $a.page.setGrid();      //그리드 초기화            
            
            $("#searchTable").setData(param);
            $a.page.searchList(param);
            $a.page.setOrgSelectBoxApp();           
            
        },
        setEventListener : function() {

            $("#btnSearch").click(function(param){
                $a.page.searchList(param);
            });
            
            $("#btnExcelPage").click(function(){
            	var oExcelMetaInfo = {
                        filename  : "에이전트계약관리목록.xls",
                        sheetname : "에이전트계약관리목록",
                        gridname  : "grid" //그리드ID 
                    };
                $.PSNMUtils.downloadExcelPage("grid", oExcelMetaInfo, [3, 11, 12, 13]);
            });
            $("#btnPrint").click(function(){
        		if( !((navigator.appName == 'Microsoft Internet Explorer') 
        				|| ((navigator.appName == 'Netscape') 
        						&& (new RegExp("Trident/.*rv:([0-9]{1,}[\.0-9]{0,})").exec(navigator.userAgent) != null))) ){
        			$.PSNM.alert("MA지원서 인쇄는 \"Microsoft Internet Explorer\" 를 사용하십시오.");
        			return false;
        		}
            	
            	var oRecord = AlopexGrid.trimData( $("#grid").alopexGrid( "dataGet" , { _state : { selected : true } } ) );
            	
        		if (oRecord.length == 0) {
        			$.PSNM.alert("E021", ["인쇄 할 행을"]);
                    return false;
                }

        		var params =  "(";
				for (var i=0; i<oRecord.length; i++){
					//alert(oRecord[i].CNTRT_MGMT_NUM);
					if (i==0) params += "'";
					else params += ",'";
					params += oRecord[i].CNTRT_MGMT_NUM + "'";
				}
				params += ")";
        		//alert(params);
            	//return;

        		var data = { CNTRT_MGMT_NUM : params}

                $a.popup({
                    url: "agn/agntmgmt/agentCntrtPrtPopup",
                    title : "",
                    data  : data,
                    width : "930",
                    height: "600",
                    modal : "false",
                    windowpopup: true,
                    callback : function( oResult ) {
                    	//popupCallback( event.target.id, oResult);
                    }
                });

            });
            
            $("#AGNT_NM").keyup($.PSNMAction.findAgent);
        }, 
        setGrid : function() {
        
            $("#grid").alopexGrid({
                rowClickSelect : false,
                rowInlineEdit : true,
                columnMapping : [
					{ columnIndex : 0, selectorColumn : true, 		width : "30px" },
                    { columnIndex : 1, key  : "CNTRT_MGMT_NUM",     	title : "관리번호",     align : "center", width : "100px" },
                    { columnIndex : 2, key  : "RGST_DTM",    			title : "지원일자",     align : "center", width : "100px" },
                    { columnIndex : 3, key  : "NAME_KOR",       		title : "지원자명", 	align : "center", width : "80px"  },
                    { columnIndex : 4, key  : "CNTRT_ST_NM",      		title : "처리상태",   	align : "center", width : "100px" },
                    { columnIndex : 5, key  : "INT_HST_SEQ",      		title : "면접횟수",   	align : "center", width : "80px" },
                    { columnIndex : 6, key  : "INTR_NM",      			title : "면접관명",   	align : "center", width : "80px" },
                    { columnIndex : 7, key  : "REQ_SALE_DEPT_ORG_NM", 	title : "희망영업국명", align : "center", width : "140px" },
                    { columnIndex : 8, key  : "REQ_SALE_TEAM_ORG_NM",   title : "희망영업팀명", align : "center", width : "80px"  },
                    { columnIndex : 9, key  : "APP_SALE_DEPT_ORG_NM",   title : "지정영업국명", align : "center", width : "140px" },
                    { columnIndex : 10, key  : "APP_SALE_TEAM_ORG_NM", 	title : "지정영업팀명", align : "center", width : "80px"  },
                    { columnIndex : 11, key : "AGENT_OP_DTM", 			title : "최종처리일", 	align : "center", width : "150px" },
                    { columnIndex : 12, key : "CNTRT_ST_CD", 			title : "처리상태코드", align : "center", width : "60px", hidden:true },
                    { columnIndex : 13, key : "RETL_ORG_CD", 			title : "영업국명(최종배치)", align : "center", width : "100px", hidden:true },
                    { columnIndex : 14, key : "RETL_TEAM_CD", 			title : "영업팀명(최종배치)", align : "center", width : "100px", hidden:true }
                    
                ],
                on : {
                    perPageChange : function(arg1) {
                    }
                    ,
                    pageSet : function(pageNoToGo) {
                    	 var p = {};
                         p.page = pageNoToGo;
                    	 $a.page.searchList(p); //페이지 이동:화면로드될때 검색실행
                    }
                }
            });
            $("#grid").alopexGrid('updateOption', {
                on : {
                    'cell' : {

                        "dblclick" : function(data, eh, e) {    //표준 : 더블클릭시 상세페이지로 이동함.
                            
                        	if(data._index.column != 0) {
                        		
	                            var param     = $("#searchTable").getData({selectOptions:true});            
	                            param.page    = $("#grid").alopexGrid("pageInfo").customPaging.current;
	                            param.perPage = $('#grid').alopexGrid('pageInfo').perPage;
	                            //param.pName   = "new";                            
	                            param.CNTRT_MGMT_NUM = data.CNTRT_MGMT_NUM; //관리번호
	                            
	                            $a.popup({
	                                url: "com/popup/agentCntrtMgmtDtlPop"
	                              , data: param	                              
	                              , width: $.PSNM.popWidth(1000)
	                              , height: $.PSNM.popHeight(800)
	                              , modal: false
	                              , windowpopup: true
	                              , iframe: true
	                              , title: "면접결과"
	                           	  , callback : function( oResult ) {
	                           		  
		                           		  //팝업종료시 화면 refresh
		                                  if ( $.PSNMUtils.isNotEmpty( oResult ) && "success"==oResult["result"] ) {
						                      $a.page.searchList(param);
						                  }
		                              }
	                            });
                            
	                        }
                        },
                        
                        "click" : function(data, eh, e) {    //표준 : 더블클릭시 상세페이지로 이동함.
                        
                        	if ( $.PSNMUtils.isMobile() ) {
	                            if(data._index.column != 0) {
	                                
	                                var param     = $("#searchTable").getData({selectOptions:true});            
	                                param.page    = $("#grid").alopexGrid("pageInfo").customPaging.current;
	                                param.perPage = $('#grid').alopexGrid('pageInfo').perPage;
	                                //param.pName   = "new";                            
	                                param.CNTRT_MGMT_NUM = data.CNTRT_MGMT_NUM; //관리번호
	                                
	                                $a.popup({
	                                    url: "com/popup/agentCntrtMgmtDtlPop"
	                                  , data: param                               
	                                  , width: $.PSNM.popWidth(1000)
	                                  , height: $.PSNM.popHeight(800)
	                                  , modal: false
	                                  , windowpopup: true
	                                  , iframe: true
	                                  , title: "면접결과"
	                                  , callback : function( oResult ) {
	                                      
	                                          //팝업종료시 화면 refresh
	                                          if ( $.PSNMUtils.isNotEmpty( oResult ) && "success"==oResult["result"] ) {
	                                              $a.page.searchList(param);
	                                          }
	                                      }
	                                });
	                            
	                            }
                        	}
                        },
                    }
                }
            });
        },
        setCodeData : function() {
            $.PSNMUtils.setCodeData([ 
            	 { t:'code', 'elemid' : 'CNTRT_ST_CD', 'header' : '-전체-' },
            	 { t:'org1', 'elemid' : 'REQ_HDQT_TEAM_ORG_ID', 'header' : '-전체-' }
            	//,{ t:'org2', 'elemid' : 'REQ_HDQT_PART_ORG_ID', 'header' : '-전체-' }
            	//,{ t:'org3', 'elemid' : 'REQ_SALE_DEPT_ORG_ID', 'header' : '-전체-' }
            ]);
        },
        searchList : function(param){
        	// 필수체크
            if ( !$.PSNM.isValid("searchForm") ) {
                return false;
            }
            
            var _page_no = 1;
        	
            if ( $.PSNMUtils.isNotEmpty(param) && $.PSNMUtils.isNotEmpty(param.page) ) {
                _page_no = param.page; //(설명) 페이지 이동할때만 페이지번호가 넘어옴.
            }
            
            var _per_page = $('#grid').alopexGrid('pageInfo').perPage;
            
            $.alopex.request('agn.AGNTMGMT@PAGENTCNTRT001_pSearchAgentCntrt', {                
    			data : ["#searchTable", function(){
    					this.data.dataSet.fields.DIV 	   = "HDQT";
	    				this.data.dataSet.fields.page 	   = _page_no;
	    				this.data.dataSet.fields.page_size = _per_page;
	    				this.data.dataSet.fields.FROM_DT   = $.PSNMUtils.getDateInput("FROM_DT");
	                	this.data.dataSet.fields.TO_DT     = $.PSNMUtils.getDateInput("TO_DT");
    			}],
                success: ["#grid","#CNTRT_ST_CNT1","#CNTRT_ST_CNT2","#CNTRT_ST_CNT3","#CNTRT_ST_CNT4","#CNTRT_ST_CNT5","#CNTRT_ST_CNT6", function(res) {
                	
                }]
            });
        },
        // 화면에서 별도의 조직코드 select box의 값을 초기화/설정함(psnm-common.js함수를 copy하여 적용)
        setOrgSelectBoxApp : function(oParam) {
            if ( $.PSNMUtils.isEmpty(oParam) ) {
                //return;
            }

            var nOrgSetLevel = $.PSNM.getOrgSetLevel();

            $("body select").each(
                function(index) {
                    var _sel_id = $(this).attr("id");

                    switch ( _sel_id ) {
                        case "REQ_HDQT_TEAM_ORG_ID" :
                            if (nOrgSetLevel>0) {
                                $(this).empty(); //options를 삭제
                                var aOptions = [];
                                    aOptions.push({
                                        "value":$.PSNM.getSession("REQ_HDQT_TEAM_ORG_ID"),
                                        "text":$.PSNM.getSession("REQ_HDQT_TEAM_ORG_NM")
                                    });
                                $(this).setData({options_REQ_HDQT_TEAM_ORG_ID : aOptions}).setSelected( $.PSNM.getSession("REQ_HDQT_TEAM_ORG_ID") );
                            }
                            $(this).change( eval("_onchange_REQ_HDQT_TEAM_ORG_ID") );
                            $(this).addClass("psnm-org-id");
                            break;
                        case "REQ_HDQT_PART_ORG_ID" :
                            if (nOrgSetLevel>1) {
                                $(this).empty(); //options를 삭제
                                var aOptions = [];
                                    aOptions.push({
                                        "value":$.PSNM.getSession("REQ_HDQT_PART_ORG_ID"),
                                        "text":$.PSNM.getSession("REQ_HDQT_PART_ORG_NM")
                                    });
                                $(this).setData({options_REQ_HDQT_PART_ORG_ID : aOptions}).setSelected( $.PSNM.getSession("REQ_HDQT_PART_ORG_ID") );
                            }
                            $(this).change( eval("_onchange_REQ_HDQT_PART_ORG_ID") );
                            $(this).addClass("psnm-org-id");
                            break;
                        case "REQ_SALE_DEPT_ORG_ID" :
                            if (nOrgSetLevel>2) {
                                $(this).empty(); //options를 삭제
                                var aOptions = [];
                                    aOptions.push({
                                        "value":$.PSNM.getSession("REQ_SALE_DEPT_ORG_ID"),
                                        "text":$.PSNM.getSession("REQ_SALE_DEPT_ORG_NM")
                                    });
                                $(this).setData({options_REQ_SALE_DEPT_ORG_ID : aOptions}).setSelected( $.PSNM.getSession("REQ_SALE_DEPT_ORG_ID") );
                            }
                            //$(this).change( eval("_onchange_REQ_SALE_DEPT_ORG_ID") );
                            $(this).addClass("psnm-org-id");
                            break;
                        case "REQ_SALE_TEAM_ORG_ID" :
                            if (nOrgSetLevel>3) {
                                $(this).empty(); //options를 삭제
                                var aOptions = [];
                                    aOptions.push({
                                        "value":$.PSNM.getSession("REQ_SALE_TEAM_ORG_ID"),
                                        "text":$.PSNM.getSession("REQ_SALE_TEAM_ORG_NM")
                                    });
                                $(this).setData({options_REQ_SALE_TEAM_ORG_ID : aOptions}).setSelected( $.PSNM.getSession("REQ_SALE_TEAM_ORG_ID") );
                            }
                            $(this).change( eval("_onchange_REQ_SALE_TEAM_ORG_ID") );
                            $(this).addClass("psnm-org-id");
                            break;
                        case "REQ_SALE_AGNT_ORG_ID" :
                            if (nOrgSetLevel>4) {
                                $(this).empty(); //options를 삭제
                                var aOptions = [];
                                    aOptions.push({
                                        "value":$.PSNM.getSession("REQ_SALE_AGNT_ORG_ID"),
                                        "text":$.PSNM.getSession("REQ_SALE_AGNT_ORG_NM")
                                    });
                                $(this).setData({options_REQ_SALE_AGNT_ORG_ID : aOptions}).setSelected( $.PSNM.getSession("REQ_SALE_AGNT_ORG_ID") );
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
                case 0 : t = 'org1'; elemid = 'REQ_HDQT_TEAM_ORG_ID'; 
                         break;
                case 1 : t = 'org2'; elemid = 'REQ_HDQT_PART_ORG_ID'; codeid = $.PSNM.getSession("REQ_HDQT_TEAM_ORG_ID");
                         break;
                case 2 : t = 'org3'; elemid = 'REQ_SALE_DEPT_ORG_ID'; codeid = $.PSNM.getSession("REQ_HDQT_PART_ORG_ID");
                         break;
                case 3 : t = 'org4'; elemid = 'REQ_SALE_TEAM_ORG_ID'; codeid = $.PSNM.getSession("REQ_SALE_DEPT_ORG_ID");
                         break;
                case 4 : t = 'org5'; elemid = 'REQ_SALE_AGNT_ORG_ID'; codeid = $.PSNM.getSession("REQ_SALE_TEAM_ORG_ID");
                         break;
                default: break;
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
        //kbs end
    });    
    
    //[본사팀] 코드 변경시 처리
    function _onchange_REQ_HDQT_TEAM_ORG_ID(E) {
        var eTargetId = E.target.id;
        var sHdqtTeamOrgIdVal = $("#" + eTargetId + " option:selected").val(); //선택된 '본사팀ID' //HDQT_TEAM_ORG_ID
        var sHdqtPartOrgIdElemId = 'REQ_HDQT_PART_ORG_ID'; //'본사파트' element id(화면요소의 ID임)
        _debug("<PSNM._onchange..> <본사팀코드변경> 변경된 본사팀코드 = [" +  sHdqtTeamOrgIdVal + "], 이벤트발생요소ID = [" + eTargetId + "]");

        $.PSNMUtils.setSelectDefaultPlaceHolder("REQ_SALE_TEAM_ORG_ID");
        $.PSNMUtils.setSelectDefaultPlaceHolder("REQ_SALE_DEPT_ORG_ID");
        $.PSNMUtils.setSelectDefaultPlaceHolder("REQ_HDQT_PART_ORG_ID");
        //var _default_options_ = [ { value: "", text: "-선택-"} ]; //일단 화면에 있는 모든 옵션들을 초기화함.
        //$('#SALE_TEAM_ORG_ID').setData({options_SALE_TEAM_ORG_ID : _default_options_}).setSelected("-선택-");
        //$('#SALE_DEPT_ORG_ID').setData({options_SALE_DEPT_ORG_ID : _default_options_}).setSelected("-선택-");
        //$('#HDQT_PART_ORG_ID').setData({options_HDQT_PART_ORG_ID : _default_options_}).setSelected("-선택-");

        if ( $.PSNMUtils.isNotEmpty(sHdqtTeamOrgIdVal) ) {
            $("#" + sHdqtPartOrgIdElemId + "").val("");
            $.PSNMUtils.setCodeData([
                { t:'org2', 'elemid' : sHdqtPartOrgIdElemId, 'codeid' : sHdqtTeamOrgIdVal, 'header' : '-전체-' }
            ], function(params) {
                _debug("<PSNM._onchange..> <본사파트 목록 조회 완료. 입력파라미터>\n\n" + JSON.stringify(params));//alert( JSON.stringify(params) );
                $("#" + sHdqtPartOrgIdElemId + "").val("");
            });
        }
    }
    //[본사파트] 코드 변경시 처리
    function _onchange_REQ_HDQT_PART_ORG_ID(E) {
        var eTargetId = E.target.id;
        var sHdqtPartOrgIdVal = $("#" + eTargetId + " option:selected").val(); //선택된 '본사파트ID' //HDQT_PART_ORG_ID
        var sSaleDeptOrgIdElemId = 'REQ_SALE_DEPT_ORG_ID'; //'영업국' element id(화면요소의 ID임)
        _debug("<PSNM._onchange..> <본사파트코드변경> 변경된 본사파트코드 = [" +  sHdqtPartOrgIdVal + "], 이벤트발생요소ID = [" + eTargetId + "]");

        $.PSNMUtils.setSelectDefaultPlaceHolder("REQ_SALE_TEAM_ORG_ID");
        $.PSNMUtils.setSelectDefaultPlaceHolder("REQ_SALE_DEPT_ORG_ID");
        //var _default_options_ = [ { value: "", text: "-선택-"} ];
        //$('#SALE_TEAM_ORG_ID').setData({options_SALE_TEAM_ORG_ID : _default_options_}).setSelected("-선택-");
        //$('#SALE_DEPT_ORG_ID').setData({options_SALE_DEPT_ORG_ID : _default_options_}).setSelected("-선택-");
        var bDtokall = $("#" + sSaleDeptOrgIdElemId).data("dtokall"); //영업국조회시 필요하면 'DTOK_EFF_ORG_YN'='Y' 조건을 제외함(@since 2015-01-29)

        if ( $.PSNMUtils.isNotEmpty(sHdqtPartOrgIdVal) ) {
            $.PSNMUtils.setCodeData([
                { t:'org3', 'elemid' : sSaleDeptOrgIdElemId, 'codeid' : sHdqtPartOrgIdVal, 'header' : '-전체-', 'dtokall' : bDtokall }
            ], function(params) {
                _debug("<PSNM._onchange..> <영업국 목록 조회 완료. 입력파라미터>\n\n" + JSON.stringify(params) );
                $("#" + sSaleDeptOrgIdElemId + "").val("");
            });
        }
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
	<div class="textAR"> 
	
		<form id="searchForm" onsubmit="return false;">
			<table id="searchTable" class="board02" style="width:93%;">
        	<colgroup>
	            <col style="width:10%"/>
	            <col style="width:30%"/>
	            <col style="width:10%"/>
	            <col style="width:20%"/>
	            <col style="width:10%"/>
	            <col style="width:*"/>
            </colgroup>
			<tr>
				<th scope="col" class="psnm-required">지원일자</th>
				<td class="tleft">
					<div data-type="daterange" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png" >
	                    <input id="FROM_DT" name="FROM_DT" data-role="startdate" data-bind="value:FROM_DT" style="width:70px;"
	                           data-validation-rule="{required:true}"
                               data-validation-message="{required:$.PSNM.msg('E012', ['시작일자'])}" />
	                  ~ <input id="TO_DT" name="TO_DT" data-role="enddate" data-bind="value:TO_DT" style="width:70px;"
	                           data-validation-rule="{required:true}"
                               data-validation-message="{required:$.PSNM.msg('E012', ['종료일자'])}" />
	                </div>
				</td>
				<th>희망본사팀</th>
				<td class="tleft">
					<select id="REQ_HDQT_TEAM_ORG_ID" data-type="select" data-bind="options:options_REQ_HDQT_TEAM_ORG_ID, selectedOptions:REQ_HDQT_TEAM_ORG_ID" data-wrap="false" style="width:185px!important"></select>
				</td>
				<th >희망본사파트</th>
				<td class="tleft">
		            <select id="REQ_HDQT_PART_ORG_ID" data-type="select" data-bind="options:options_REQ_HDQT_PART_ORG_ID, selectedOptions:REQ_HDQT_PART_ORG_ID" data-wrap="false" style="width:185px!important">
		               <option value="">-전체-</option>
		            </select>
				</td>
			</tr>
			<tr>
				<th scope="col">희망영업국</th>
				<td class="tleft">
					<select id="REQ_SALE_DEPT_ORG_ID" data-type="select" data-bind="options:options_REQ_SALE_DEPT_ORG_ID, selectedOptions:REQ_SALE_DEPT_ORG_ID" data-wrap="false" style="width:185px!important">
					    <option value="">-전체-</option>
					</select>
			    </td>
			    <th>지정본사팀</th>
	            <td class="tleft">
	                <select id="HDQT_TEAM_ORG_ID" data-type="select" data-bind="options:options_HDQT_TEAM_ORG_ID, selectedOptions:HDQT_TEAM_ORG_ID" data-wrap="false" style="width:185px!important"></select>
	            </td>
	            <th >지정본사파트</th>
	            <td class="tleft">
	                <select id="HDQT_PART_ORG_ID" data-type="select" data-bind="options:options_HDQT_PART_ORG_ID, selectedOptions:HDQT_PART_ORG_ID" data-wrap="false" style="width:185px!important">
	                   <option value="">-전체-</option>
	                </select>
	            </td>
		    </tr>
		    <tr>
		        <th scope="col">지정영업국</th>
	            <td class="tleft">
	                <select id="SALE_DEPT_ORG_ID" data-type="select" data-bind="options:options_SALE_DEPT_ORG_ID, selectedOptions:SALE_DEPT_ORG_ID" data-wrap="false" style="width:185px!important">
	                    <option value="">-전체-</option>
	                </select>
	            </td>
	            <th >지원자명</th>
	            <td class="tleft">
	                <input id="AGNT_NM" data-type="textinput" data-bind="value:AGNT_NM" data-theme="af-textinput"/>
	            </td>
	            <th scope="col">처리상태</th>
	            <td class="tleft">
	                <select id="CNTRT_ST_CD" data-type="select" data-bind="options:options_CNTRT_ST_CD, selectedOptions:CNTRT_ST_CD" data-wrap="false" style="width:185px!important"></select>
	            </td>
		    </tr>	    
		    <tr>
				<th scope="col">면접관(마케터)</th>
	            <td class="tleft" colspan="5">
	                <input id="INTR_NM" data-type="textinput" data-bind="value:INTR_NM" data-theme="af-textinput"/>
	            </td>
		    </tr>
		    </table>
		</form>
		  
		<!-- btn area -->
		<div class="ab_pos5">
		  <button id="btnSearch" type="button" data-type="button" data-theme="af-psnm" data-authtype="R" data-altname="조회"></button>
		</div>
	  
	</div>
  
	<!--view_list area -->
	<div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>회원목록</b> 
	(<label id="CNTRT_ST_CNT1" data-bind="text:CNTRT_ST_CNT1">0</label>,
	 <label id="CNTRT_ST_CNT2" data-bind="text:CNTRT_ST_CNT2">0</label>,
	 <label id="CNTRT_ST_CNT3" data-bind="text:CNTRT_ST_CNT3">0</label>,
	 <label id="CNTRT_ST_CNT4" data-bind="text:CNTRT_ST_CNT4">0</label>,
	 <label id="CNTRT_ST_CNT5" data-bind="text:CNTRT_ST_CNT5">0</label>,
	 <label id="CNTRT_ST_CNT6" data-bind="text:CNTRT_ST_CNT6">0</label>	
	)
		<p class="ab_pos2">
			<button id="btnPrint" type="button" data-type="button" data-theme="af-btn58" data-altname="인쇄" data-authtype="R"></button>
		    <button id="btnExcelPage" type="button" data-type="button" data-theme="af-btn3" data-altname="엑셀"></button>
		</p>
	</div>
  
	<!-- main grid -->
	<div id="grid" data-bind="grid" data-ui="ds"></div>
	
</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>