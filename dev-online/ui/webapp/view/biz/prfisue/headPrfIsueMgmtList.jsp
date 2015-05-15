<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

    <jsp:include page="/view/layouts/default_head.jsp" flush="false" />

    <script type="text/javascript">
    var _param, _selectedIndex;
    
    $.alopex.page({

        init : function(id, param) { 
            $.PSNM.initialize(id, param); //PSNM공통 초기화함수 호출
            
            _param = param;
            
            $.PSNMUtils.setDefaultYmd("#FROM_DT", "TO_DT");
            $a.page.setEventListener();
            $a.page.setGrid();
            $a.page.setCodeData();
			//$a.page.searchList(param);
			$a.page.searchWebBasVal();
        },
        setEventListener : function() {
        	$("#AGNT_NM").keyup( $.PSNMAction.findAgent );
        	$("#AGNT_NM2").keyup( $.PSNMAction.findAgent );
        	$("#btnFindAgent").click( popFindAgent2 );
        	
			/* grid에 데이타 반영 */
        	$("#PRF_CL_CD").change( detailToGrid );
        	$("#PRF_USG_CD").change( detailToGrid );
        	$("#BIRTH_DT").change( detailToGrid );
        	$("#ISUE_QTY").keyup( detailToGrid );
        	$("#ISUE_RSN_CTT").keyup( detailToGrid );
        	
            $("#btnSearch").click($a.page.searchList);
            
            $("#btnReq").click(function(){
            	if( $.PSNMUtils.isEmpty($("#HDQT_TEAM_ORG_ID").val()) ){
            		$.PSNM.alert("E021", ["본사팀"]);
            		$("#HDQT_TEAM_ORG_ID").focus();
            		return false;
            	}    
            	$("#gridPrfIsue").alopexGrid( "rowSelect", { PRF_ISUE_ST_CD : "02"}, false);
            	$("#gridPrfIsue").alopexGrid( "rowSelect", { PRF_ISUE_ST_CD : "03"}, false);
            	$("#gridPrfIsue").alopexGrid( "rowSelect", { PRF_ISUE_ST_CD : "04"}, false);
            	$("#gridPrfIsue").alopexGrid( "rowSelect", { PRF_ISUE_ST_CD : "05"}, false);
            	$("#gridPrfIsue").alopexGrid( "rowSelect", { PRF_ISUE_ST_CD : "06"}, false);
            	
        		var oRecord = AlopexGrid.trimData( $("#gridPrfIsue").alopexGrid( "dataGet" , { _state : { selected : true } } ) );
            	
        		if (oRecord.length == 0) {
        			$.PSNM.alert("E021", ["발급의뢰할 행을"]);
                    return false;
                }
        		
            	if( !$.PSNM.confirm("I004", ["발급의뢰"] ) ){
            		return false;
            	}
        		
            	$("#gridPrfIsue").alopexGrid( "dataEdit", { FLAG : "02" }, { PRF_ISUE_ST_CD : "01", _state : { selected : true } } );            	
            	
            	var gridData = $("#gridPrfIsue").alopexGrid( "dataGet", { FLAG : "02" } );
            	
            	var dataSet = {}, dataSetData = {}, recordSetsData= {};
                dataSetData["fields"] = {};
                recordSetsData["gridPrfIsue"] = {nc_list: AlopexGrid.trimData( gridData ) };
                dataSetData["recordSets"] = recordSetsData;
                dataSet["dataSet"] = dataSetData;
                
               	$.alopex.request("biz.PRFISUE@PPRFISUEMGMT001_pSavePrfIsueStCd", {
                       data: dataSet,
                       success: function(res) { 
                      	 if ( ! $.PSNM.success(res) ) { //서버측 FAIL응답
                    		 return false;
                    	 }
                      	 $a.page.searchList(_param);
                      	 //AlopexGrid.trimData( $("#gridPrfIsue").alopexGrid( "dataEdit", { PRF_ISUE_ST_CD : "02"}, { FLAG : "02" } ) );                      	 
                       }
                });
               	
            });
            
            $("#btnCancelReq").click(function(){
            	$("#gridPrfIsue").alopexGrid( "rowSelect", { PRF_ISUE_ST_CD : "01"}, false);
            	$("#gridPrfIsue").alopexGrid( "rowSelect", { PRF_ISUE_ST_CD : "03"}, false);
            	$("#gridPrfIsue").alopexGrid( "rowSelect", { PRF_ISUE_ST_CD : "04"}, false);
            	$("#gridPrfIsue").alopexGrid( "rowSelect", { PRF_ISUE_ST_CD : "05"}, false);
            	$("#gridPrfIsue").alopexGrid( "rowSelect", { PRF_ISUE_ST_CD : "06"}, false);
            	
        		var oRecord = AlopexGrid.trimData( $("#gridPrfIsue").alopexGrid( "dataGet" , { _state : { selected : true } } ) );
            	
        		if (oRecord.length == 0) {
        			$.PSNM.alert("E021", ["의뢰취소할 행을"]);
                    return false;
                }
            	if( !$.PSNM.confirm("I004", ["의뢰취소"] ) ){
            		return false;
            	}
            	
            	$("#gridPrfIsue").alopexGrid( "dataEdit", { FLAG : "03" }, { PRF_ISUE_ST_CD : "02", _state : { selected : true } } );
            	
            	var gridData = $("#gridPrfIsue").alopexGrid( "dataGet", { FLAG : "03" } );
            	
            	var dataSet = {}, dataSetData = {}, recordSetsData= {};
                dataSetData["fields"] = {};
                recordSetsData["gridPrfIsue"] = {nc_list: AlopexGrid.trimData( gridData ) };
                dataSetData["recordSets"] = recordSetsData;
                dataSet["dataSet"] = dataSetData;
                
               	$.alopex.request("biz.PRFISUE@PPRFISUEMGMT001_pSavePrfIsueStCd", {
                       data: dataSet,
                       success: function(res) { 
                      	 if ( ! $.PSNM.success(res) ) { //서버측 FAIL응답
                    		 return false;
                    	 }
                      	 AlopexGrid.trimData( $("#gridPrfIsue").alopexGrid( "dataEdit", { PRF_ISUE_ST_CD : "03"}, { FLAG : "03" } ) );
                       }
                });
               	
            });
            
            $("#btnSave").click(function(){
            	if( $.PSNMUtils.isEmpty($("#HDQT_TEAM_ORG_ID").val()) ){
            		$.PSNM.alert("E021", ["본사팀"]);
            		$("#HDQT_TEAM_ORG_ID").focus();
            		return false;
            	}            	
				if ( $("#detail").css("display")!="none" && ! $.PSNM.isValid("#detail") ) {
				    return false; //값 검증
				}

            	$("#gridPrfIsue").alopexGrid( "rowSelect", { _state : { selected : true, added : false, edited:false } }, false);
            	
            	if( !$.PSNM.confirm("I004", ["저장"] ) ){
            		return false;
            	}
            	
            	var requestData = $.PSNMUtils.getRequestDataUpdated("gridPrfIsue");
            	
               	$.alopex.request("biz.PRFISUE@PPRFISUEMGMT001_pSavePrfIsue", {
                       data: requestData,
                       success: function(res) { 
                      	 if ( ! $.PSNM.success(res) ) { //서버측 FAIL응답
                    		 return false;
                    	 }
                      	 $a.page.searchList(_param);
                       }
                });
            });
            
            $("#btnDel").click(function(){
            	$("#gridPrfIsue").alopexGrid( "rowSelect", { _state : { selected : true }, PRF_ISUE_ST_CD : "02"}, false);
            	$("#gridPrfIsue").alopexGrid( "rowSelect", { _state : { selected : true }, PRF_ISUE_ST_CD : "04"}, false);
            	$("#gridPrfIsue").alopexGrid( "rowSelect", { _state : { selected : true }, PRF_ISUE_ST_CD : "05"}, false);
            	$("#gridPrfIsue").alopexGrid( "rowSelect", { _state : { selected : true }, PRF_ISUE_ST_CD : "06"}, false);
            	var addRowCnt = $("#gridPrfIsue").alopexGrid( "dataGet", { _state : { selected : true, added : true } } ).length;
            	$("#gridPrfIsue").alopexGrid( "dataDelete", { _state : { selected : true, added : true } } )
            	
            	var oRecord = $("#gridPrfIsue").alopexGrid( "dataGet" , { _state : { selected : true } } );
            	if( addRowCnt != 0 && oRecord.length == 0 ){
            		return false;
            	}
        		if( oRecord.length == 0) {
        			$.PSNM.alert("E021", ["삭제할 행"]);
                    return;
                }
        		
            	if( !$.PSNM.confirm("I004", ["삭제"] ) ){
            		return false;
            	}            	
            	
        		$("#gridPrfIsue").alopexGrid( "dataEdit", {"FLAG":"D"}, { _state: { selected : true } } );
           		var requestData = $.PSNMUtils.getRequestDataUpdated("gridPrfIsue");
               	$.alopex.request("biz.PRFISUE@PPRFISUEMGMT001_pSavePrfIsue", {
               		data: requestData,
                       success : function(res) {
                        	 if ( ! $.PSNM.success(res) ) { //서버측 FAIL응답
                        		 return false;
                        	 }
                        	                         	  
                        	 AlopexGrid.trimData( $("#gridPrfIsue").alopexGrid( "dataDelete", { _state : { selected : true } } ) );
                       }
                });
            });
            
            $("#btnNew").click(function(){
				if ( $("#detail").css("display")!="none" && ! $.PSNM.isValid("#detail") ) {
				    return false; //값 검증
				}
            	_selectedIndex = 0;            	
            	var addObj = $("#gridPrfIsue").alopexGrid( "dataAdd" , {}, { _index : { data : _selectedIndex } } );
            	$("#gridPrfIsue").alopexGrid( "rowSelect", { _index : { data : _selectedIndex } }, true);
            	//addObj.click();
				$("#AGNT_NM2").setEnabled(true);
				$("#btnFindAgent").setEnabled(true);
				$("#AGNT_ID2").setEnabled(true);
				$("#BIRTH_DT").setEnabled(true);
				$("#PRF_CL_CD").setEnabled(true);
				$("#PRF_USG_CD").setEnabled(true);
				$("#ISUE_QTY").setEnabled(true);
				$("#ISUE_RSN_CTT").setEnabled(true);
				
            	$("#detail label").text("");
            	$("#detail input").val("");
            	$("#detail select").val("");
            	$("#ISUE_QTY").val("1");
            	$("#PRF_ISUE_ST_CD").val("01");
            	$("#detail").show();

            	$("#form #HDQT_TEAM_ORG_ID").val( $("#searchForm #HDQT_TEAM_ORG_ID").val() );
            	$("#form #HDQT_PART_ORG_ID").val( $("#searchForm #HDQT_PART_ORG_ID").val() );
            	$("#form #SALE_DEPT_ORG_ID").val( $("#searchForm #SALE_DEPT_ORG_ID").val() );
            	
            	detailToGrid();
            });
            
            $("#btnIsue").click(function(){
            	if( $.PSNMUtils.isEmpty($("#HDQT_TEAM_ORG_ID").val()) ){
            		$.PSNM.alert("E021", ["본사팀"]);
            		$("#HDQT_TEAM_ORG_ID").focus();
            		return false;
            	}    
            	$("#gridPrfIsue").alopexGrid( "rowSelect", { PRF_ISUE_ST_CD : "01"}, false);
            	$("#gridPrfIsue").alopexGrid( "rowSelect", { PRF_ISUE_ST_CD : "02"}, false);
            	$("#gridPrfIsue").alopexGrid( "rowSelect", { PRF_ISUE_ST_CD : "03"}, false);
            	$("#gridPrfIsue").alopexGrid( "rowSelect", { PRF_ISUE_ST_CD : "05"}, false);
            	
            	var oRecord = AlopexGrid.trimData( $("#gridPrfIsue").alopexGrid( "dataGet" , { _state : { selected : true } } ) );
            	
        		if (oRecord.length == 0) {
        			$.PSNM.alert("E021", ["승인/발급완료 처리된 행을"]);
                    return false;
                }

        		if (oRecord.length > 1) {
        			$.PSNM.alert("증명서발급은 단건처리만 가능합니다.");
                    return false;
                }

        		if(oRecord[0].IS_PRINT !="Y"){
        			var reg = /(^\d{4})(\d{2})(\d{2})(.*)/;        		
        			$.PSNM.alert("E023", [oRecord[0].EXP_DATE.replace(reg, '$1' + '년 ' + '$2' + '월 '+ '$3' +'일')]);
                    return false;
        		}
	
        		if( !((navigator.appName == 'Microsoft Internet Explorer') 
        				|| ((navigator.appName == 'Netscape') 
        						&& (new RegExp("Trident/.*rv:([0-9]{1,}[\.0-9]{0,})").exec(navigator.userAgent) != null))) ){
        			$.PSNM.alert("증명서발급은 \"Microsoft Internet Explorer\" 를 사용하십시오.");
        			return false;
        		}
            	
        		$("#gridPrfIsue").alopexGrid( "dataEdit", { FLAG : "06" }, { _state : { selected : true } } );        		
        		var gridData = $("#gridPrfIsue").alopexGrid( "dataGet", { _state : { selected : true } } );

                
                
                if( gridData[0].PRF_ISUE_ST_CD != "06" ){
            		
                	var dataSet = {}, dataSetData = {}, recordSetsData= {};
                    dataSetData["fields"] = {};
                    recordSetsData["gridPrfIsue"] = {nc_list: gridData };
                    dataSetData["recordSets"] = recordSetsData;
                    dataSet["dataSet"] = dataSetData;

	               	$.alopex.request("biz.PRFISUE@PPRFISUEMGMT001_pSavePrfIsueStCd", {
	                       data: dataSet,
	                       success: function(res) { 
	                      	 if ( ! $.PSNM.success(res) ) { //서버측 FAIL응답
	                    		 return false;
	                    	 }
	                      	 //AlopexGrid.trimData( $("#gridPrfIsue").alopexGrid( "dataEdit", { PRF_ISUE_ST_CD : "03"}, { FLAG : "03" } ) );
	                      	$a.page.searchList(_param);
	                       }
	                });
                }

        		var data = { PRF_MGMT_NUM   : oRecord[0].PRF_MGMT_NUM
        				     , PRF_CL_CD    : oRecord[0].PRF_CL_CD
        				     , AGNT_ID      : oRecord[0].AGNT_ID
        				     , BIRTH_DT     : oRecord[0].BIRTH_DT
        				     , PRF_USG_CD   : oRecord[0].PRF_USG_CD
        				     , ISUE_QTY     : oRecord[0].ISUE_QTY 
        				     , USER_ID      : oRecord[0].USER_ID 
        				     , PRF_CL_CD_NM : oRecord[0].PRF_CL_CD_NM }

                $a.popup({
                    url: "biz/prfisue/prfisuePopup",
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
        },
        setGrid : function() {
            $("#gridPrfIsue").alopexGrid({
                pager: false,
                rowSingleSelect : false,
                rowClickSelect : false,
                rowInlineEdit : true,
                height : "400px",
                columnMapping : [
					{ columnIndex : 0, selectorColumn : true, 		width : "25px" },
					{ columnIndex : 1, key : "PRF_MGMT_NUM", 		hidden : true  },
                    { columnIndex : 2, key : "OUT_ORG_NM",			title : "본사파트",		align : "center", 	width : "80px"	},
                    { columnIndex : 3, key : "DSM_HEADQ_NM",		title : "영업국명",		align : "center", 	width : "100px"	},
                    { columnIndex : 4, key : "DSM_TEAM_NM",		    title : "영업팀명",		align : "center", 	width : "100px"	},
                    { columnIndex : 5, key : "AGNT_ID",			    title : "에이전트코드",	align : "center", 	width : "100px"	},
                    { columnIndex : 6, key : "RPSTY_NM",			title : "직책명",		align : "center", 	width : "80px"	},
                    { columnIndex : 7, key : "AGNT_NM",				title : "에이전트명",	    align : "center", 	width : "120px"	},
                    { columnIndex : 8, key : "PRF_CL_CD",			title : "증명서구분",	    align : "center", 	width : "120px"	
                       , render : {
            				          type : "string",
               					      rule : function() {
										            var oParam = { t:'code', 'codeid' : 'DSM_PRF_CL_CD', 'header' : ' ' };	
										        	return $.PSNMUtils.getCode(oParam);
                                               }
                			        }
                    },
                    { columnIndex : 9, key : "REQ_DTM",				title : "의뢰일시",	    align : "center", 	width : "120px"	},
                    { columnIndex : 10, key : "ISUE_QTY",			title : "매수",	    align : "center", 	width : "50px"	},
                    { columnIndex : 11, key : "PRF_ISUE_ST_CD",		title : "상태",	    align : "center", 	width : "120px"
                        , render : {
  				          type : "string",
     					      rule : function() {
								            var oParam = { t:'code', 'codeid' : 'DSM_PRF_ISUE_ST_CD', 'header' : ' ' };	
								        	return $.PSNMUtils.getCode(oParam);
                                     }
      			        }
                    },
                    { columnIndex : 12, key : "ISUE_DTM",			title : "발급일시",	        align : "center", 	width : "120px"	},                    
                    { columnIndex : 13, key : "ORG_ID",				title : "ORG_ID",	        align : "center", 	width : "120px", hidden : true	},
                    { columnIndex : 14, key : "OUT_ORG_ID",		    title : "OUT_ORG_ID",	    align : "center", 	width : "120px", hidden : true	},
                    { columnIndex : 15, key : "DSM_HEADQ_CD",		title : "DSM_HEADQ_CD",	    align : "center", 	width : "120px", hidden : true	},
                    { columnIndex : 16, key : "DSM_TEAM_CD",		title : "DSM_TEAM_CD",	    align : "center", 	width : "120px", hidden : true	},
                    { columnIndex : 17, key : "PRF_USG_CD",			title : "PRF_USG_CD",	    align : "center", 	width : "120px", hidden : true	},
                    { columnIndex : 18, key : "SCRB_ST_CD",			title : "SCRB_ST_CD",	    align : "center", 	width : "120px", hidden : true	},
                    { columnIndex : 19, key : "FLAG",			    title : "FLAG",             align : "center", 	width : "120px", hidden : true  },
                    { columnIndex : 20, key : "USER_ID",			title : "USER_ID",          align : "center", 	width : "120px", hidden : true  },
                    { columnIndex : 20, key : "ISUE_RSN_CTT",	    title : "ISUE_RSN_CTT",          align : "center", 	width : "120px", hidden : true  },
            	],
                on : {
                    "cell" : {
    					"click" : function(data, eh, e) {
    						if(data._index.column != 0) {
    							if ( $("#detail").css("display")!="none" && _selectedIndex != data._index.row && ! $.PSNM.isValid("#detail") ) {
    							    return false; //값 검증
    							}
    							_selectedIndex = data._index.row;
    							$("#form").setData(data);
    							if( data.PRF_ISUE_ST_CD == "04" || data.PRF_ISUE_ST_CD == "05" || data.PRF_ISUE_ST_CD == "06"){
    								$("#AGNT_NM2").setEnabled(false);
    								$("#btnFindAgent").setEnabled(false);
    								$("#AGNT_ID2").setEnabled(false);
    								$("#BIRTH_DT").setEnabled(false);
    								$("#PRF_CL_CD").setEnabled(false);
    								$("#PRF_USG_CD").setEnabled(false);
    								$("#ISUE_QTY").setEnabled(false);
    								$("#ISUE_RSN_CTT").setEnabled(false);
    							}else{
    								$("#AGNT_NM2").setEnabled(true);
    								$("#btnFindAgent").setEnabled(true);
    								$("#AGNT_ID2").setEnabled(true);
    								$("#BIRTH_DT").setEnabled(true);
    								$("#PRF_CL_CD").setEnabled(true);
    								$("#PRF_USG_CD").setEnabled(true);
    								$("#ISUE_QTY").setEnabled(true);
    								$("#ISUE_RSN_CTT").setEnabled(true);
    							}
    							if( data.SCRB_ST_CD == '04' ){
    								$("#PRF_CL_CD [value='02']").show();
    								$("#PRF_CL_CD [value='03']").show();
    							}else{
    								$("#PRF_CL_CD [value='02']").hide();
    								$("#PRF_CL_CD [value='03']").hide();
    							}
    							$("#detail").show();
    						}
    					}
    				}
                }
            });
        },
        setCodeData : function() {
            $.PSNMUtils.setCodeData([
				{ t:'code', 'elemid' : 'PRF_CL_CD', 'codeid' : 'DSM_PRF_CL_CD', 'header' : '-선택-' },
				{ t:'code', 'elemid' : 'PRF_USG_CD', 'codeid' : 'DSM_PRF_USG_CD', 'header' : '-선택-' },
				{ t:'code', 'elemid' : 'PRF_ISUE_ST_CD', 'codeid' : 'DSM_PRF_ISUE_ST_CD', 'header' : '-전체-' }
            ]);
        },
        searchList: function(param) {
        	$("#detail").hide();
        	if ( ! $.PSNM.isValid("#searchForm") ) {
    			return false; //값 검증
    		}
            $.alopex.request("biz.PRFISUE@PPRFISUEMGMT001_pSearchPrfIsue", {
                data: ["#searchTable", function(){
                	this.data.dataSet.fields.FROM_DT   = $.PSNMUtils.getDateInput("FROM_DT");
                	this.data.dataSet.fields.TO_DT     = $.PSNMUtils.getDateInput("TO_DT");
                }],
                success: "#gridPrfIsue"
            });
        },
        searchWebBasVal: function(){
            $.alopex.request("com.BASEVAL@PWEBBASVAL001_pSearchWebBasVal", {
        		data: {dataSet: {fields: {DSM_WEB_STRD_CD_VAL : "61"}}},
                success:function(res){
                	var isPsbDays = res.dataSet.recordSets.grid.nc_list[0].STRD_APLY_VAL;
                	var guidMsg = "<font color=\"red\">증명서 발급은 발급일 기준 (" + isPsbDays + ")일 이내 IE에서만 인쇄 가능합니다. (크롬, 사파리 불가)</font>";
                	$("#ISSUE_GUID").html(guidMsg);
                }
            });
        }
    });

    function onAgentFound(oResult) {
        var data = { AGNT_NM : oResult["AGNT_NM"], AGNT_ID : oResult["AGNT_ID"] 
       				 , ORG_ID : oResult["HDQT_TEAM_ORG_ID"]
					 , OUT_ORG_ID : oResult["HDQT_PART_ORG_ID"], OUT_ORG_NM : oResult["HDQT_PART_ORG_NM"]
        		     , DSM_HEADQ_CD : oResult["SALE_DEPT_ORG_ID"], DSM_HEADQ_NM : oResult["SALE_DEPT_ORG_NM"]
				     , DSM_TEAM_CD : oResult["SALE_TEAM_ORG_ID"], DSM_TEAM_NM : oResult["SALE_TEAM_ORG_NM"]
			         , BIRTH_DT : oResult["BIRTH_DT"] , RPSTY_NM : oResult["RPSTY_NM"]
        			 , SCRB_ST_CD : oResult["SCRB_ST_CD"] };

		$("#detail").setData( data );
		if( oResult["SCRB_ST_CD"] == '04' ){
			$("#PRF_CL_CD [value='02']").show();
			$("#PRF_CL_CD [value='03']").show();
		}else{
			$("#PRF_CL_CD [value='02']").hide();
			$("#PRF_CL_CD [value='03']").hide();
		}
		detailToGrid();
    }
    
    function popFindAgent2() {
        var oParam = new Object();
            oParam = $('#searchForm').getData({selectOptions:true}); //본사팀, 본사파트, 영업국, 영업팀 조건을 넘겨주기 위함.
            oParam["FINDTYPE"] = "ALL";
        $.PSNMAction.popFindAgent(oParam, function(oResult) {
            if ( null!=oResult && typeof oResult == "object" ) {
            	onAgentFound(oResult);
            }
        });
    }    

    function detailToGrid(){
    	$("#gridPrfIsue").alopexGrid( "dataEdit" , $("#detail").getData(), { _index : { data : _selectedIndex } } );
    	$("#gridPrfIsue").alopexGrid( "rowSelect", { _index : { data : _selectedIndex } }, true);
    }
    </script>

</head>

<body>

<jsp:include page="/view/layouts/default_header.jsp" flush="false" />

<div id="contents">

    <!-- sub title area -->
    <div class="content_title">
        <div id="ub_txt6">
            <span class="txt6_img"><b id="sub-title">증면서발급 관리</b>
                <span class="notice-more"> 
                	<img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif">
                	<span class="a2">영업국업무</span> <span class="a3"> > </span> <span class="a4"><b>증면서발급 관리</b></span> 
                </span>
            </span>
        </div>
    </div>

    <!-- find condition area -->
    <div id="searchDiv" class="textAR">
		<form id="searchForm" onsubmit="return false;">
        	<table id="searchTable" class="board02" style="width:92%;">
        	<colgroup>
	            <col style="width:11%"/>
	            <col style="width:25%"/>
	            <col style="width:11%"/>
	            <col style="width:13%"/>
	            <col style="width:11%"/>
	            <col style="width:*"/>
            </colgroup>
            <tr>
                <th scope="col" class="fontred">조회기간</th>
                <td class="tleft">
					<div data-type="daterange" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png" >
						<input id="FROM_DT" name="FROM_DT" data-role="startdate" data-bind="value:FROM_DT" style="width:70px;"
							data-validation-rule="{required:true}"
							data-validation-message="{required:$.PSNM.msg('E012', ['시작일자'])}">
						~ <input id="TO_DT" name="TO_DT" data-role="enddate" data-bind="value:TO_DT" style="width:70px;"
							data-validation-rule="{required:true}"
							data-validation-message="{required:$.PSNM.msg('E012', ['종료일자'])}">
					</div>
				</td>
				<th class="fontred">본사팀</th>
				<td class="tleft">
                    <select id="HDQT_TEAM_ORG_ID" data-bind="options:options_HDQT_TEAM_ORG_ID, selectedOptions: HDQT_TEAM_ORG_ID" data-type="select"
                    	data-validation-rule="{required:true}"
						data-validation-message="{required:$.PSNM.msg('E012', ['본사팀'])}">
                    	<option value="">-선택-</option>
                    </select>
                </td>
                <th>본사파트</th>
				<td class="tleft">
                    <select id="HDQT_PART_ORG_ID" data-bind="options:options_HDQT_PART_ORG_ID, selectedOptions: HDQT_PART_ORG_ID" data-type="select">
                    	<option value="">-선택-</option>
                    </select>
                </td>
            </tr>
            <tr>
                <th>영업국명</th>
				<td class="tleft">
                    <select id="SALE_DEPT_ORG_ID" data-bind="options:options_SALE_DEPT_ORG_ID, selectedOptions: SALE_DEPT_ORG_ID" data-type="select" style="width:150px">
                    	<option value="">-선택-</option>
                    </select>
                </td>
				<th>영업팀명</th>
				<td class="tleft">
                    <select id="SALE_TEAM_ORG_ID" data-bind="options:options_SALE_TEAM_ORG_ID, selectedOptions: SALE_TEAM_ORG_ID" data-type="select" style="width:150px">
                    	<option value="">-선택-</option>
                    </select>
                </td>
                <th>에이전트명</th>
				<td class="tleft">
					<input id="AGNT_NM" name="AGNT_NM" data-bind="value:AGNT_NM" data-type="textinput" data-agentid="AGNT_ID" data-findtype="ALL" data-callback="onAgentFound" size="15"/>
					<input id="AGNT_ID" name="AGNT_ID" data-bind="value:AGNT_ID" data-type="textinput" data-disabled="true" size="15"/>	
                </td>
            </tr>                      
            </table>
			<div class="ab_pos4">
				<button id="btnSearch" type="button" data-type="button" data-theme="af-psnm" data-authtype="R"></button>
			</div>
        </form>
    </div>
    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>증명서발급 목록</b>
    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<label id="ISSUE_GUID">증명서 발급은 발급일 기준 (7)일 이내 IE에서만 인쇄 가능합니다. (크롬, 사파리 불가)</label>
        <div class="ab_pos2">
        	<button id="btnReq" type="button" data-type="button" data-theme="af-btn52" data-altname="발급의뢰" data-authtype="W"></button>
        	<button id="btnCancelReq" type="button" data-type="button" data-theme="af-btn53" data-altname="의뢰취소" data-authtype="W"></button>
        	<button id="btnIsue" type="button" data-type="button" data-theme="af-btn54" data-altname="증명서발급" data-authtype="W"></button>
        	<button id="btnNew" type="button" data-type="button" data-theme="af-btn2" data-altname="신규" data-authtype="W"></button>
	        <button id="btnDel"  type="button" data-type="button" data-theme="af-btn13" data-altname="삭제" data-authtype="W"></button>
        	<button id="btnSave" type="button" data-type="button" data-theme="af-btn4" data-altname="저장" data-authtype="W"></button>
        </div>
    </div>

    <!-- main grid -->
    <div id="gridPrfIsue" data-bind="grid:gridPrfIsue"></div>
    
	<div id="detail" style="display: none;">
		<div class="floatL4">
			<img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"/> <b>증명서발급 상세</b>
		</div>
		<form id="form" onsubmit="return false;">
		
		<input id="ORG_ID" name="ORG_ID" type="hidden" data-bind="value:ORG_ID" data-type="textinput">
		<input id="OUT_ORG_ID" name="OUT_ORG_ID" type="hidden" data-bind="value:OUT_ORG_ID" data-type="textinput">
		<input id="DSM_HEADQ_CD" name="DSM_HEADQ_CD" type="hidden" data-bind="value:DSM_HEADQ_CD" data-type="textinput">
		<input id="DSM_TEAM_CD" name="DSM_TEAM_CD" type="hidden" data-bind="value:DSM_TEAM_CD" data-type="textinput">
		<input id="RPSTY_NM" name="RPSTY_NM" type="hidden" data-bind="value:RPSTY_NM" data-type="textinput">
		<input id="SCRB_ST_CD" name="SCRB_ST_CD" type="hidden" data-type="textinput" data-bind="value:SCRB_ST_CD" data-type="textinput">
		
		<!-- agent 검색용 조직정보 -->
		<input id="HDQT_TEAM_ORG_ID" name="HDQT_TEAM_ORG_ID" type="hidden" data-bind="value:HDQT_TEAM_ORG_ID" data-type="textinput">
		<input id="HDQT_PART_ORG_ID" name="HDQT_PART_ORG_ID" type="hidden" data-bind="value:HDQT_PART_ORG_ID" data-type="textinput">
		<input id="SALE_DEPT_ORG_ID" name="SALE_DEPT_ORG_ID" type="hidden" data-bind="value:SALE_DEPT_ORG_ID" data-type="textinput">
		
		<input id="FLAG" name="FLAG" type="hidden"/>
		<table class="board02" style="width:100%;">
			<colgroup>
	            <col style="width:9%"/>
	            <col style="width:25%"/>
	            <col style="width:9%"/>
	            <col style="width:15%"/>
	            <col style="width:9%"/>
	            <col style="width:13%"/>
	            <col style="width:9%"/>
	            <col style="width:*"/>
			</colgroup>
			<tr>
				<th scope="col" class="fontred">에이전트명</th>
				<td class="tleft">
					<input id="AGNT_NM2" name="AGNT_NM2" data-bind="value:AGNT_NM" data-findtype="ALL" data-type="textinput" data-agentid="AGNT_ID2" data-callback="onAgentFound" size="10"/>
					<input id="btnFindAgent" type="button" data-type="button" class="searchButton">
					<input id="AGNT_ID2" name="AGNT_ID2" data-bind="value:AGNT_ID" data-type="textinput" data-disabled="true" size="10"
						data-validation-rule="{required:true}"
						data-validation-message="{required:$.PSNM.msg('E012', ['에이전트명'])}"/>						
				</td>
				<th scope="col" class="fontred">생년월일</th>
				<td class="tleft">
					<input id="BIRTH_DT" data-bind="value:BIRTH_DT" data-type="dateinput" style="width:70px;" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png"
						data-validation-rule="{required:true}"
						data-validation-message="{required:$.PSNM.msg('E012', ['생년월일'])}"/>
				</td>
				<th scope="col" class="fontred">증명서구분</th>
				<td class="tleft">
					<select id="PRF_CL_CD" name="PRF_CL_CD" data-type="select" style="width:120px;"
						data-bind="options: options_PRF_CL_CD, selectedOptions: PRF_CL_CD"
						data-validation-rule="{required:true}"
						data-validation-message="{required:$.PSNM.msg('E012', ['증명서구분'])}"></select>
				</td>
				<th scope="col" class="fontred">용도</th>
				<td class="tleft">
					<select id="PRF_USG_CD" name="PRF_USG_CD" data-type="select" style="width:120px;" 
						data-bind="options: options_PRF_USG_CD, selectedOptions: PRF_USG_CD"
						data-validation-rule="{required:true}"
						data-validation-message="{required:$.PSNM.msg('E012', ['용도'])}"></select>
				</td>				
			</tr>
			<tr>
				<th scope="col">본사파트</th>
				<td class="tleft">
					<label id="OUT_ORG_NM" data-bind="text:OUT_ORG_NM"></label>
				</td>
				<th scope="col">영업국명</th>
				<td class="tleft">
					<label id="DSM_HEADQ_NM" data-bind="text:DSM_HEADQ_NM"></label>					
				</td>
				<th scope="col">영업팀명</th>
				<td class="tleft">
					<label id="DSM_TEAM_NM" data-bind="text:DSM_TEAM_NM"></label>					
				</td>
				<th scope="col">매수</th>
				<td class="tleft">
					<input id="ISUE_QTY" name="ISUE_QTY" data-bind="value:ISUE_QTY" data-type="textinput" value="1" data-keyfilter-rule="digits"/>
				</td>				
			</tr>
			<tr>
				<th scope="col">상태</th>
				<td class="tleft">
					<select id="PRF_ISUE_ST_CD" name="PRF_ISUE_ST_CD" data-type="select" style="width:120px;" data-disabled="true"
						data-bind="options: options_PRF_ISUE_ST_CD, selectedOptions: PRF_ISUE_ST_CD">
					</select>
				</td>
				<th scope="col">의뢰일자</th>
				<td class="tleft">
					<label id="REQ_DTM" data-bind="text:REQ_DTM"></label>
				</td>
				<th scope="col">발급일시</th>
				<td class="tleft" colspan="3">
					<label id="ISUE_DTM" data-bind="text:ISUE_DTM"></label>
				</td>				
			</tr>
			<tr>
				<th scope="col" class="fontred">요청사유</th>
				<td class="tleft" colspan="7">
					<input id="ISUE_RSN_CTT" name="ISUE_RSN_CTT" data-bind="value:ISUE_RSN_CTT" data-type="textinput" style="width:95%" 
						data-validation-rule="{required:true}"
						data-validation-message="{required:$.PSNM.msg('E012', ['요청사유'])}"/>
				</td>				
			</tr>			
			<tr>
				<th scope="col">반려사유</th>
				<td class="tleft" colspan="7">
					<label id="RJCT_RSN_CTT" data-bind="text:RJCT_RSN_CTT"></label>
				</td>				
			</tr>
		</table>
		</form>
	</div>    

</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>