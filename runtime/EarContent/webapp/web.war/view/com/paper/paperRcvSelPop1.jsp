
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="nexcore.framework.core.Constants"%>
<%@ page import="nexcore.framework.core.code.ICode"%>
<%@ page import="nexcore.framework.core.data.user.IUserInfo"%>
<%@ page import="nexcore.framework.core.util.BaseUtils"%>
<%@ page import="nexcore.framework.online.channel.util.WebUtils"%>
<%
    IUserInfo userInfo = WebUtils.getSessionUserInfo(request);
%>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />
<script src="../../../script/jquery.cookie.js" type="text/javascript"></script>
<script src="../../../script/jquery.treeview.js" type="text/javascript"></script>
    <script type="text/javascript">
    
    var _TX_SEARCH1     =           "com.PAPER@PPAPERMGMT001_pSearchSaleTeam";         
    var _TX_SEARCH2     =           "com.PAPER@PPAPERMGMT001_pAgntList";
    var arr             =           new Array();
    var authgrp = ($.PSNM.getSession("DUTY"));
	var admin ;
    $.alopex.page({

        init : function(id, param) { 
            //$.PSNM.initialize(id, param); //팝업에서는 initialize() 사용치 않음!
            $.PSNM.setOrgSelectBox(); //팝업에서 조직 선택상자를 초기화 할 때 사용
            
            $a.page.setGrid(); //그리드
            $a.page.setaddgrid();

            $a.page.setEventListener(); //버튼이 눌렸을때 실행할 이벤트리스너 
        },
        setGrid : function() {
            $("#grid").alopexGrid({
                pager :false,
                height:200,
                virtualScroll:true,
                rowClickSelect : false,
                rowInlineEdit : false,
                columnMapping : [   //컬럼맵핑     
                                    {
             	                        columnIndex : 0, width : "7%",
             	                        selectorColumn : true
             	                    },
             	                    {
             	                        columnIndex : 1, key : "HDQT_PART_ORG_NM", title : "본사파트", align: "center", width: "16%"
             	                    },
             	                    {
             	                        columnIndex : 2, key : "SALE_DEPT_ORG_NM", title : "영업국명", align: "center", width: "16%"
             	                    },
             	                    {
             	                        columnIndex : 3, key : "SALE_TEAM_ORG_NM", title : "영업팀명",  align: "center", width: "16%"
             	                    },
             	                    {
             	                        columnIndex : 4, key : "AGNT_ID",  title : "에이전트코드" , align: "center", width: "15%"  
             	                    },
             	                    {
             	                        columnIndex : 5, key : "RPSTY_NM", title : "직책명", align: "center", width: "15%"
             	                    },
             	                    {
             	                        columnIndex : 6, key : "USER_NM", title : "에이전트명", align: "center", width: "15%"
             	                    },
             	                    {
             	                        columnIndex : 7, key : "FLAG", hidden:true
             	                    },
            	                    {
            	                        columnIndex : 8, key : "USER_ID", hidden : true
            	                    },
                ],
                on : {
                    perPageChange : function(arg1) {
                        _debug("<annceList> <grid.on.perPageChange> 페이지당개수 변경 : arg1 = " + arg1);//만약에 마지막 페이지가 7개면 7개만 들어감. 
                    }
                }
            });
        },    
        setaddgrid : function() {
            $("#addgrid").alopexGrid({
                pager: false,
                rowSingleSelect : false,
                rowClickSelect : false,
                height : 200,
                columnMapping : [
                                {
         	                        columnIndex : 0, width : "7%",
         	                        selectorColumn : true
         	                    },
         	                    {
         	                        columnIndex : 1, key : "HDQT_PART_ORG_NM", title : "본사파트", align: "center", width: "16%"
         	                    },
         	                    {
         	                        columnIndex : 2, key : "SALE_DEPT_ORG_NM", title : "영업국명", align: "center", width: "16%"
         	                    },
         	                    {
         	                        columnIndex : 3, key : "SALE_TEAM_ORG_NM", title : "영업팀명",  align: "center", width: "16%"
         	                    },
         	                    {
         	                        columnIndex : 4, key : "AGNT_ID",  title : "에이전트코드" , align: "center", width: "15%" 
         	                    },
         	                    {
         	                        columnIndex : 5, key : "RPSTY_NM", title : "직책명", align: "center", width: "15%"
         	                    },
         	                    {
         	                        columnIndex : 6, key : "USER_NM", title : "에이전트명", align: "center", width: "15%"
         	                    },
         	                    {
         	                        columnIndex : 7, key : "FLAG", hidden:true
         	                    },
        	                    {
        	                        columnIndex : 8, key : "USER_ID", hidden : true
        	                    },
                ],
                on : {

                },
            });
        }, 
        searchList: function(param) {
            if ( !$.PSNM.isValid("#searchTable") ) {
                return false;
            }
            $.alopex.request("com.PAPER@PPAPERMGMT001_pSearchUserPop", {
                data: "#searchForm",
                success: "#grid"
            });
        },
        setEventListener : function() {
            $("#btnSearch").click( $a.page.searchList );                                                            // 조회
            $("#DUTY_TYP_ID" ).bind("change",dutySearch);                                                           // 직무 조회

            $("#include").click(function(){
                var oResult = $("#grid").alopexGrid("dataGet", {_state:{selected:true}});
                
                var curResult = $("#addgrid").alopexGrid("dataGet");
            	//회원중복체크
				for(var i=0 ; i<oResult.length ; i++) {
					var flag = false;
					for(var j=0 ; j<curResult.length ; j++) {
						if(oResult[i].USER_ID == curResult[j].USER_ID){
							flag = true;
							break;
						}	
					}	
					if(flag == false){
						$("#addgrid").alopexGrid("dataAdd", oResult[i], {_index : { data : 0 }});
						$("#addgrid").alopexGrid( "dataEdit", {"FLAG":"I"}, {_index : { data : 0 }});                      //체크되어있는 사람 FLAG 값을 I로 바꿈  

					}						
				}
                
                $("#grid").alopexGrid("dataDelete", {_state:{selected:true}});
            });
            $("#exclude").click(function(){
				var oResult = $("#addgrid").alopexGrid("dataGet", {_state:{selected:true}});
                
                var curResult = $("#grid").alopexGrid("dataGet");
            	//회원중복체크
				for(var i=0 ; i<oResult.length ; i++) {
					var flag = false;
					for(var j=0 ; j<curResult.length ; j++) {
						if(oResult[i].USER_ID == curResult[j].USER_ID){
							flag = true;
							break;
						}	
					}	
					if(flag == false){
						$("#grid").alopexGrid("dataAdd", oResult[i], {_index : { data : 0 }});
		                $("#grid").alopexGrid( "dataEdit", {"FLAG":""}, {_index : { data : 0 }});                                                   						
					}						
				}
                
				$("#addgrid").alopexGrid("dataDelete", {_state:{selected:true}});
            });

            $("#btnCancel").click(function(){
                $a.close();
            });
            
            $("#btnConfirm").click(function(){
                var oRecord = $("#addgrid").alopexGrid( "dataGet", {"FLAG":"I"});                                                   

                if (oRecord.length == 0) {
                    alert("회원정보를 선택하십시오!");
                    return;
                }
                var state  = $.PSNMUtils.getRequestData("addgrid");
                var state2 = state.dataSet.recordSets;
                var list   = eval(state2.addgrid.nc_list);
			    var count  = 0;
                
                for(var i = 0; i<list.length;i++){
                    if(list[i].FLAG==="I"){
                    	RgstSet(list[i].HDQT_PART_ORG_NM,list[i].SALE_DEPT_ORG_NM,list[i].SALE_TEAM_ORG_NM,list[i].USER_ID,list[i].RPSTY_NM,list[i].USER_NM,list[i].AGNT_ID,count);                        
                    	count ++;
                        
                    }
                }
                $a.close(arr);
            });
        }
    });
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
    function RgstSet(HDQT_PART_ORG_NM,SALE_DEPT_ORG_NM,SALE_TEAM_ORG_NM,USER_ID,RPSTY_NM,USER_NM,AGNT_ID,count){
    	arr[count]={"HDQT_PART_ORG_NM":HDQT_PART_ORG_NM,"SALE_DEPT_ORG_NM":SALE_DEPT_ORG_NM,"SALE_TEAM_ORG_NM":SALE_TEAM_ORG_NM,"USER_ID":USER_ID,"RPSTY_NM":RPSTY_NM,"USER_NM":USER_NM,"AGNT_ID":AGNT_ID};
    }
    </script>
</head>

<body>
<div id="Wrap">
    <div class="pop_header" >
        <div class="textAR">
            <form id="searchForm" onsubmit="return false;">
                <table id="searchTable" class="board02" >
                    <colgroup>
                            <col style="10%">
                            <col style="23%">
                            <col style="10%">
                            <col style="23%">
                            <col style="10%">
                            <col style="*">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th class="fontred">본사팀</th>
                            <td class="tleft">
                                <select id="HDQT_TEAM_ORG_ID" data-bind="options:options_HDQT_TEAM_ORG_ID, selectedOptions: HDQT_TEAM_ORG_ID" data-type="select" 
                                        data-validation-rule="{required:true}" data-validation-message="{required:$.PSNM.msg('E012', ['본사팀'])}">
                                    <option value="">-선택-</option>
                                </select>
                            </td>
                                
                            <th class="fontred">본사파트</th>
                            <td class="tleft">
                                <select id="HDQT_PART_ORG_ID" data-bind="options:options_HDQT_PART_ORG_ID, selectedOptions: HDQT_PART_ORG_ID" data-type="select"  
                                        data-validation-rule="{required:true}" data-validation-message="{required:$.PSNM.msg('E012', ['본사파트'])}">
                                    <option value="">-선택-</option>
                                </select>
                            </td>
                            <th >영업국명</th>
                            <td class="tleft">
                                <select id="SALE_DEPT_ORG_ID" data-bind="options:options_SALE_DEPT_ORG_ID, selectedOptions: SALE_DEPT_ORG_ID" data-type="select">
                                    <option value="">-전체-</option>
                                </select>
                            </td>
                        </tr>
						<tr> 
							<th >영업팀명</th>
							<td class="tleft">
                                <select id="SALE_TEAM_ORG_ID" data-bind="options:options_SALE_TEAM_ORG_ID, selectedOptions: SALE_TEAM_ORG_ID" data-type="select" data-wrap="false" >
                                    <option value="">-전체-</option>
                                </select>
                            </td>
                            <th >직무구분</th>
                            <td class="tleft">
                                <select id="DUTY_TYP_ID" data-bind="options:options_DUTY_TYP_ID, selectedOptions: DUTY_TYP_ID" data-type="select" style="width: 150px">
                                    <option value="00">-전체-</option>
                                    <option value="1">임직원</option>
                                    <option value="3">도급직</option>
                                    <option value="4">에이전트</option>
                                </select>
                            </td>
                            <th >직무</th>
                            <td class="tleft">
                                <select id="DUTY_TYP_DT" name="DUTY_TYP_DT" data-bind="options:options_DUTY_TYP_DT, selectedOptions:DUTY_TYP_DT"  data-type="select" data-wrap="false" style="width: 150px">
                                    <option value="">-전체-</option>
                                </select>
                            </td>
                        </tr>
                        <tr> 
                            <th>에이전트명</th>
                            <td colspan="5" class="tleft">

						    <input id="AGNT_NM" name="AGNT_NM" data-bind="value:AGNT_NM" data-type="textinput" 
                        	style="width:20%" value="">

                            </td>
                        </tr>
                    </tbody>
                </table>
            </form>
                <div style="text-align: right ;margin: 5px;">
                    <input id="btnSearch" type="button" value="" data-type="button" data-theme="af-psnm">
                </div>
            
        <div class="textAR">
        
            <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>대상 회원 목록</b></div>
	           <div id="grid" data-bind="grid:grid" data-ui="ds"></div>

            <div align="center" class="psnm-mid-btns">
                <button id="include" type="button" data-type="button" data-theme="af-btn-downicon" data-altname="아래로"></button>
                <button id="exclude" type="button" data-type="button" data-theme="af-btn-upicon" data-altname="위로"></button>
            </div>
            
            <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>선택 회원 목록</b></div>
                    <div id="addgrid" data-bind="grid:addgrid" data-ui="ds"></div>

            <p class="floatL2">
                <button id="btnConfirm" type="button" data-type="button" data-theme="af-btn8" data-altname="확인"></button>
                <button id="btnCancel" type="button" data-type="button" data-theme="af-btn10" data-altname="취소"></button>
            </p>
        </div>
                
                
        </div>
    </div>
</div>
</body>