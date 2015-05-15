
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
    $.alopex.page({

        init : function(id, param) { 
            //$.PSNM.initialize(id, param); //팝업에서는 initialize() 사용치 않음!
            $.PSNM.setOrgSelectBox(); //팝업에서 조직 선택상자를 초기화 할 때 사용
    		
            $a.page.setGrid(); //그리드
            $a.page.setaddgrid();
            $a.page.setEventListener(); //버튼이 눌렸을때 실행할 이벤트리스너 

            teamSearch();

        },
        setGrid : function() {
            $("#grid").alopexGrid({
                pager :false,
                height:200,
                virtualScroll:true,
                rowClickSelect : false,
                rowInlineEdit : true,
                columnMapping : [   //컬럼맵핑     
                    {
                        columnIndex : 0, width : "4%",
                        selectorColumn : true
                    },
                    {
                        columnIndex : 1, key : "HDQT_PART_ORG_NM", title : "본사파트", align: "center", width: "16%"
                    },
                    {
                        columnIndex : 2, key : "SALE_TEAM_ORG_NM", title : "영업팀명",  align: "center", width: "16%"
                    },
                    {
                        columnIndex : 3, key : "AGNT_ID", title : "에이전트코드",align: "center", width: "16%"
                    },
                    {
                        columnIndex : 4, key : "RPSTY_NM", title : "직책명", align: "center", width: "16%"
                    },
                    {
                        columnIndex : 5, key : "USER_NM", title : "에이전트명", align: "center", width: "16%"
                    },
                    { 
                    	columnIndex : 6, key : "LVL_CD", title : "LVL_CD", 		hidden:true 
                    },
                    {
                        columnIndex : 7, key : "USER_ID", hidden : true
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
                rowClickSelect : true,
                height : 200,
                columnMapping : [
                                 {
                                     columnIndex : 0, width : "4%",
                                     selectorColumn : true
                                 },
                                 {
                                     columnIndex : 1, key : "HDQT_PART_ORG_NM", title : "본사파트", align: "center", width: "16%"
                                 },
                                 {
                                     columnIndex : 2, key : "SALE_TEAM_ORG_NM", title : "영업팀명",  align: "center", width: "16%"
                                 },
                                 {
                                     columnIndex : 3, key : "AGNT_ID", title : "에이전트코드", align: "center", width: "16%"
                                 },
                                 {
                                     columnIndex : 4, key : "RPSTY_NM", title : "직책명", align: "center", width: "16%"
                                 },
                                 {
                                     columnIndex : 5, key : "USER_NM", title : "에이전트명", align: "center", width: "16%"
                                 },
                                 {
                                     columnIndex : 6, key : "FLAG", title : "확인" , hidden:true
                                 },
         	                     {
         	                         columnIndex : 7, key : "USER_ID", hidden : true
         	                     },
                ],
                on : {

                },
            });
        }, 
        setEventListener : function() {
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
    function teamSearch(e) {
       var val;
       
      $("#hTeamNM").empty();
        $("#sTeamNM").empty();
        $("#tree").empty();
        pSearchAuthGrp();
    }
    function pSearchAuthGrp() {
        if ( ! $.PSNM.isValid("#searchForm") ) return false; 

        $.alopex.request(_TX_SEARCH1, {
            data: ["#searchForm", function() {
            }],
            success: ['#teamSearch', function(res) {
                treeData(res.dataSet.recordSets.teamSearch);
            }]
        });
    }

    function treeData(param){
        var htm    ="";
        var data   ="";
        var dataNM ="";
            
        for(var i=0;i<param.nc_recordCount;i++){
        	if(param.nc_list[i].LVL_CD == '0'){ /* 본사팀 */
        		 $('#tree').createNode("", {
                    text	:	 param.nc_list[i].DSM_ORG_NM,
                    id 		:	 param.nc_list[i].DSM_ORG_CD
                }); 
        	}
        	else if(param.nc_list[i].LVL_CD == '1'){ /* 영업국 */
        			if(param.nc_list[i].HEDQ_YN == "Y"){ /* 사무국 */
        				 var node = $("#tree").getNode(param.nc_list[i].SUP_DSM_ORG_CD, "id");
     	                $("#tree").createNode(node, {
     	                    text	:	 param.nc_list[i].DSM_ORG_NM,
     	                    id 		:	 param.nc_list[i].DSM_ORG_CD,
     	                    linkUrl :    "javascript:void(TeamMember(\'" + param.nc_list[i].DSM_ORG_CD + "\'\,\'" + param.nc_list[i].LVL_CD + "\'));"
     	                }); 
        			}
        			else{
		                 var node = $("#tree").getNode(param.nc_list[i].SUP_DSM_ORG_CD, "id");
		                $("#tree").createNode(node, {
		                    text	:	 param.nc_list[i].DSM_ORG_NM,
		                    id 		:	 param.nc_list[i].DSM_ORG_CD
		                }); 
        			}
        		
        	}
        	else if(param.nc_list[i].LVL_CD == '2'){ /* 영업팀 */                
	       			var node = $("#tree").getNode(param.nc_list[i].SUP_DSM_ORG_CD, "id");
	                $("#tree").createNode(node, {
	                    text	:	 param.nc_list[i].DSM_ORG_NM,
	                    id 		:	 param.nc_list[i].DSM_ORG_CD,
	                    linkUrl :    "javascript:void(TeamMember(\'" + param.nc_list[i].DSM_ORG_CD + "\'\,\'" + param.nc_list[i].LVL_CD + "\'));"
	                }); 
        	}
        }
        $("#tree").treeview({
   			collapsed: true
        });
        $("#tree").expandAll();
    }
    function TeamMember(m_id ,m_lvl){
        $.alopex.request(_TX_SEARCH2, {
            data:{dataSet: {fields: {
            	SALE_TEAM_ORG_ID   :    m_id
            	,LVL_CD 		   : 	m_lvl	
            }}},
            success: ['#grid', function(res) {
            }]
        });
    }
    $(function() {
        $("#tree").treeview({
        });
    })
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
                            <th class="fontred">영업국명</th>
                            <td class="tleft">
                                <select id="SALE_DEPT_ORG_ID" data-bind="options:options_SALE_DEPT_ORG_ID, selectedOptions: SALE_DEPT_ORG_ID" data-type="select" 
                                        data-validation-rule="{required:true}" data-validation-message="{required:$.PSNM.msg('E012', ['영업국'])}">
                                    <option value="">-선택-</option>
                                </select>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </form>
            <div class="org_wrap">
					<form id="treeform">
					 <div class="org_tree">
	                       <ul id='tree' data-type="tree">
	                       </ul>
	                       </div>
	               	</form>
                <div class="org_result" style="width: 620px">
                    <div id="grid" data-bind="grid:grid" data-ui="ds"></div>
                <div align="center" class="psnm-mid-btns">
                <button id="include" type="button" data-type="button" data-theme="af-btn-downicon" data-altname="아래로"></button>
                <button id="exclude" type="button" data-type="button" data-theme="af-btn-upicon" data-altname="위로"></button>
            </div>
                   <div id="addgrid" data-bind="grid:addgrid" data-ui="ds"></div>
            <p class="floatL2">
                <button id="btnConfirm" type="button" data-type="button" data-theme="af-btn8" data-altname="확인"></button>
                <button id="btnCancel" type="button" data-type="button" data-theme="af-btn10" data-altname="취소"></button>
            </p>
                </div>
            </div>
        </div>
    </div>
</div>
</body>