<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <jsp:include page="/view/layouts/default_head.jsp" flush="false" />
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/vendor/jquery.ui.widget.js"></script>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/jquery.iframe-transport.js"></script>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/jquery.fileupload.js"></script>
    <script src="../../../script/jquery.cookie.js" type="text/javascript"></script>
	<script src="../../../script/jquery.treeview.js" type="text/javascript"></script>
    <script type="text/javascript">
    _LOG_LEVEL = 0; //로그레벨 :: 0=debug, 1=info, 2=error
    
    var _TX_SEARCH1     =           "biz.BIZMGMT@PPHONBK001_pSearchSaleTeam";         
    var _TX_SEARCH2     =           "biz.BIZMGMT@PPHONBK001_pSearchPhonBk";
    var _TX_SEARCH3     =           "biz.BIZMGMT@PPHONBK001_pDetailPhonBk";
    var _TX_SEARCH4     =           "biz.BIZMGMT@PPHONBK001_pSearchPhonBkCondi";
    var arr;
    
    var _param;
    var authgrp = ($.PSNM.getSession("DUTY"));
    $.alopex.page({

        init : function(id, param) { 
        	_param = param;
            $.PSNM.initialize(id, param); 
            $a.page.setGrid(); //그리드
            $a.page.setEventListener(); //버튼이 눌렸을때 실행할 이벤트리스너 
    		
            $( "#SALE_DEPT_ORG_ID" ).unbind();
            $( "#SALE_DEPT_ORG_ID" ).bind("change",teamSearch);
            
//             if(authgrp<4){
//             	$( "#SALE_DEPT_ORG_ID" ).bind("change",teamSearch);
//             }else {
//             	$( "#SALE_DEPT_ORG_ID" ).bind("click",teamSearch);
//             }
        },
        setGrid : function() {
            $("#grid").alopexGrid({
                pager :false,
                height:400,
                virtualScroll:true,
                rowClickSelect : false,
                rowInlineEdit : true,
                columnMapping : [   //컬럼맵핑     
                    {
                        columnIndex : 0, width : "10px",
                        selectorColumn : true
                    },
                    { columnIndex : 1, key : "HDQT_PART_ORG_NM", 	title : "본사파트",		align: "center", 	width: "30px" },
                    { columnIndex : 2, key : "SALE_DEPT_ORG_NM", 	title : "영업국명",		align: "center", 	width: "30px" },
                    { columnIndex : 3, key : "SALE_TEAM_ORG_NM",	title : "영업팀명",  		align: "center", 	width: "30px" },
                    { columnIndex : 4, key : "AGNT_ID", 			title : "에이전트코드",		align: "center", 	width: "30px" },
                    { columnIndex : 5, key : "RETL_CLASS_NM",		title : "직책명",			align: "center",	width: "30px" },
                    { columnIndex : 6, key : "USER_NM",				title : "에이전트명", 		align: "center",	width: "30px" },
                    { columnIndex : 7, key : "FLAG", 				title : "확인여부", 		hidden:true },
                    { columnIndex : 8, key : "LVL_CD", 				title : "LVL_CD", 		hidden:true },
                ],
                on : {
                    perPageChange : function(arg1) {
                        _debug("<phonbkList> <grid.on.perPageChange> 페이지당개수 변경 : arg1 = " + arg1);//만약에 마지막 페이지가 7개면 7개만 들어감. 
                    },
                    "cell" : {
    					"click" : function(data, eh, e) {
    							detailPhonBk(data);
    					}
    				}
                }
            });
        },setEventListener : function() {
			$("#sendmsg").click(function(){
				//alert(JSON.stringify(arr));
				if(arr != null){
            		$a.navigate("../../com/paper/paperRgst.jsp", arr); 
				}
				else{
					alert("회원정보가 없습니다.");
					return;
				}
				
				
            });
        	$("#btnSearch").click(function(){
        		if(checkValue()== false){
        			return;
        		}
        		 
        		 $.alopex.request(_TX_SEARCH4, {
        			 	data : ["#phoneform", function(){
							this.data.dataSet.fields.TYPE         = 	$.PSNMUtils.getDateInput("searchtype");
							this.data.dataSet.fields.TYPE_VALUE   = 	$.PSNMUtils.getDateInput("search_value");
						}],
        	            success: ['#grid', function(res) {
        	            }]
        	        });
        	});
        	 $("#search_value").keypress(function(event) {
         		if ( event.which == 13 ) {
         			if(checkValue()== false){
             			return;
             		}
         			 $.alopex.request(_TX_SEARCH4, {
         			 	data : ["#phoneform", function(){
 							this.data.dataSet.fields.TYPE         = 	$.PSNMUtils.getDateInput("searchtype");
 							this.data.dataSet.fields.TYPE_VALUE   = 	$.PSNMUtils.getDateInput("search_value");
 						}],
         	            success: ['#grid', function(res) {
         	            }]
         	        }); 
         		}
         	});  
            
        } 
    });
    function teamSearch(e) {
    	
        if ( !$("#" + e.target.id).val() ) return false; 
        
        var val = $("#" + e.target.id).val();
		
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
    function detailPhonBk(data){
	    $.alopex.request(_TX_SEARCH3, {
	    	data: {dataSet: {fields: {AGNT_ID 	: 	data.AGNT_ID, 
	    						      USER_ID 		: 	data.USER_ID,
	    						      LVL_CD 		:   data.LVL_CD}}},
	        success: ['#mem_info', function(res) {
	        	arr={"USER_ID": data.USER_ID, "USER_NM": data.USER_NM, "HDQT_PART_ORG_NM": data.HDQT_PART_ORG_NM ,"SALE_DEPT_ORG_NM": data.SALE_DEPT_ORG_NM, "SALE_TEAM_ORG_NM": data.SALE_TEAM_ORG_NM, "RPSTY_NM": data.RETL_CLASS_NM, "AGNT_ID": data.AGNT_ID }; //$a.navigate("com/paper/rcvPaperRgst", oParam);
	    /*     	_param.SND_USER_NM = data.USER_NM;
				_param.RCV_USER_ID = data.USER_ID; */
				var imgFileUrl = $.PSNMUtils.getDownloadUrl2("PIC",	res.dataSet.fields.USER_PHOTO,	"",	res.dataSet.fields.FILE_PATH);
				$("#picture").attr("src",	imgFileUrl); 
	       	 	
	        }]
	    });
    }
    function treeData(param){
        var htm    ="";
        var data   ="";
        var dataNM ="";
            
        for(var i=0;i<param.nc_recordCount;i++){
        	if(param.nc_list[i].LVL_CD == '0'){ /* 본사팀 */
               /*  htm ='<li><p>'+param.nc_list[i].DSM_ORG_NM+'</p><ul id="'+param.nc_list[i].DSM_ORG_CD+'"></ul></li>';	
                $("#tree").append(htm);
                htm=""; */
        		 $('#tree').createNode("", {
                    text	:	 param.nc_list[i].DSM_ORG_NM,
                    id 		:	 param.nc_list[i].DSM_ORG_CD
                }); 
        	}
        	else if(param.nc_list[i].LVL_CD == '1'){ /* 영업국 */
        			if(param.nc_list[i].HEDQ_YN == "Y"){ /* 사무국 */
        				/* htm +='<li><a href="javascript:void(TeamMember(\''+param.nc_list[i].DSM_ORG_CD+'\'));">'+param.nc_list[i].DSM_ORG_NM+'</a></li>';	
                        $("#"+param.nc_list[i].SUP_DSM_ORG_CD).append(htm);
                        htm=""; */
        				 var node = $("#tree").getNode(param.nc_list[i].SUP_DSM_ORG_CD, "id");
     	                $("#tree").createNode(node, {
     	                    text	:	 param.nc_list[i].DSM_ORG_NM,
     	                    id 		:	 param.nc_list[i].DSM_ORG_CD,
     	                    linkUrl :    "javascript:void(TeamMember(\'" + param.nc_list[i].DSM_ORG_CD + "\'\,\'" + param.nc_list[i].LVL_CD + "\'));"
     	                }); 
        			}
        			else{
        				/* htm ='<li><p>'+param.nc_list[i].DSM_ORG_NM+'</p><ul id="'+param.nc_list[i].DSM_ORG_CD+'"></ul></li>';	
                        $("#"+param.nc_list[i].SUP_DSM_ORG_CD).append(htm);
                        htm=""; */
		                 var node = $("#tree").getNode(param.nc_list[i].SUP_DSM_ORG_CD, "id");
		                $("#tree").createNode(node, {
		                    text	:	 param.nc_list[i].DSM_ORG_NM,
		                    id 		:	 param.nc_list[i].DSM_ORG_CD
		                }); 
        			}
        		
        	}
        	else if(param.nc_list[i].LVL_CD == '2'){ /* 영업팀 */
	        		/* htm +='<li><a href="javascript:void(TeamMember(\''+param.nc_list[i].DSM_ORG_CD+'\'));">'+param.nc_list[i].DSM_ORG_NM+'</a></li>';	
	                $("#"+param.nc_list[i].SUP_DSM_ORG_CD).append(htm);
	                htm=""; */
	                
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
    function TeamMember(m_id, m_lvl){
        $.alopex.request(_TX_SEARCH2, {
            data:{dataSet: {fields: {
            							SALE_TEAM_ORG_ID	:	m_id
            							,LVL_CD 			: 	m_lvl
        						    }
        }},
            success: ['#grid', function(res) {
            }]
        });
    }
     function checkValue(){
    	var search_value = document.getElementById("search_value");
    	if($("#searchtype").val()=="TYPE_MBL_PHON"){
    		 if(search_value.value.length < 1){
    			 alert("조회값을 입력하세요.");
    			 return false;
    		 }
    		 else if(isNaN(search_value.value)){
				 alert("숫자만 입력 가능합니다.");
				 search_value.focus();
				 return false;
			 }
		} else if($("#searchtype").val()=="TYPE_JOB"){
			if(search_value.value.length < 2){
				 alert("2글자 이상 입력해 주세요.");
				 search_value.focus();
				 return false;
			}
				
		} else if($("#searchtype").val()=="TYPE_USER_ID"){
			if(search_value.value.length < 4){
				 alert("4글자 이상 입력해 주세요.");
				 search_value.focus();
				 return false;
			}		
		} else if($("#searchtype").val()=="TYPE_AGNT_NM"){
			if(search_value.value.length < 2){
				 alert("2글자 이상 입력해 주세요.");
				 search_value.focus();
				 return false;
			}
    	} 
    }
    </script>
</head>
<body>
<jsp:include page="/view/layouts/default_header.jsp" flush="false" />
	<!-- title area -->
<div id="contents">
	<div class="content_title">
		<div class="ub_txt6"> <span class="txt6_img"><b>전화번호부</b> <span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif"> <span class="a2">본사업무</span> <span class="a3"> > </span> <b>회원관리</b> </span> </span> </div>
	</div>
	<!-- find condition area -->
	<div class="textAR">
            <div class="org_wrap">
            	
                <div class="org_tree">
                	<form id="searchForm" onsubmit="return false;">
		                <table id="searchTable" class="board02 mgb10" >
	                    	<colgroup>
								<col style="width:26%" />
								<col style="*" />
							</colgroup>
	                        <tr>
	                            <th scope="col" class="fontred">본사팀</th>
	                            <td class="tleft">
	                                <select id="HDQT_TEAM_ORG_ID" data-bind="options:options_HDQT_TEAM_ORG_ID, selectedOptions: HDQT_TEAM_ORG_ID"  data-type="select" 
                                        data-validation-rule="{required:true}" data-validation-message="{required:$.PSNM.msg('E012', ['본사팀'])}" >
	                                    <option value="">-선택-</option>
	                                </select>
	                            </td>
	                        </tr>
	                        <tr>         
	                            <th scope="col" class="fontred">본사파트</th>
	                            <td class="tleft">
	                                <select id="HDQT_PART_ORG_ID" data-bind="options:options_HDQT_PART_ORG_ID, selectedOptions: HDQT_PART_ORG_ID" data-type="select"  
                                        data-validation-rule="{required:true}" data-validation-message="{required:$.PSNM.msg('E012', ['본사파트'])}" >
	                                    <option value="">-선택-</option>
	                                </select>
	                            </td>
	                        </tr>
	                        <tr>
	                            <th scope="col" class="fontred">영업국명</th>
	                            <td class="tleft">
	                                <select id="SALE_DEPT_ORG_ID" data-bind="options:options_SALE_DEPT_ORG_ID, selectedOptions: SALE_DEPT_ORG_ID" data-dtokall="true" data-type="select" 
                                        data-validation-rule="{required:true}" data-validation-message="{required:$.PSNM.msg('E012', ['영업국'])}" >
	                                    <option value="">-선택-</option>
	                                </select>
	                            </td>
	                        </tr>
		                </table>
	            	</form>
					<form id="treeform">
	                       <ul id='tree' data-type="tree">
	                       </ul>
	               	</form>
                </div>
                <div class="org_result">
                	<div class="t-right">
                		<form id="phoneform" onsubmit="return false;">
            					<select id="searchtype" data-type="select">
	             					<option value="TYPE_AGNT_NM">에이전트명</option>
	             					<option value="TYPE_USER_ID">회원 ID</option>
	             					<option value="TYPE_MBL_PHON">이동전화</option>
	             					<option value="TYPE_JOB">JOB</option>
            					</select>
            					<input id="search_value" name="search_value" data-bind="value:search_value" data-type="textinput" data-agentid="search_value" />
								<input id="btnSearch" type="button" value="" data-type="button" data-theme="af-psnm" data-authtype="R">
	                	</form>
	             	</div>
                	<div class="floatL4"> 
						<img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>회원정보</b>
					</div>
                	<form id="mem_info">
                		<table id="mem_info_table" class="board02 last" width="100%">
							<colgroup>
								<col style="width:17%">
								<col style="width:17%">
								<col style="width:22%">
								<col style="width:17%">
								<col style="width:*">
							</colgroup>
							<tr>
								<td rowspan="5" class="first">
									<img id="picture" style="width:100px;height:140px;" src="" onerror='this.src="<c:out value='${pageContext.request.contextPath}'/>/image/adminbox-sample-img.gif"'><br><br>
									<button id="sendmsg" type="button" data-type="button" class="af-button af-n-btn30"></button>
								</td>
								<th class="first" scope="col">본사파트</th>
								<td class="tleft"><label data-bind="text:HDQT_PART_ORG_NM"></td>
								<th class="first" scope="col">영업국명</th>
								<td class="tleft"><label data-bind="text:SALE_DEPT_ORG_NM"></td>
							</tr>
							<tr>
								<th scope="col" class="first">영업팀명</th>
								<td class="tleft"><label data-bind="text:SALE_TEAM_ORG_NM"></td>
								<th scope="col">직책명</th>
								<td class="tleft"><label data-bind="text:RETL_CLASS_NM"></td>
							</tr>
							<tr>
								<th scope="col" class="first">에이전트명</th>
								<td class="tleft"><label data-bind="text:USER_NM"></td>
								<th scope="col">전화번호</th>
								<td class="tleft"><label data-bind="text:PHON_NUM"></td>
							</tr>
							<tr>
								<th scope="col" class="first">이동전화</th>
								<td class="tleft"><label data-bind="text:MBL_PHON_NUM"></td>
								<th scope="col">이메일</th>
								<td class="tleft" colspan="3"><label data-bind="text:EMAIL"></td>
							</tr>
							<tr>
								<th scope="col" class="first">JOB</th>
								<td class="tleft" colspan="3" colspan="3"><label data-bind="text:MAIN_JOB"></td>
							</tr>
						</table>
                	</form>
                	
                	<div class="floatL4"> 
						<img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>회원목록</b>
					</div>
                    <div id="grid" data-bind="grid:grid" data-ui="ds"></div>
                </div>
            </div>
        </div>
	
</div>
<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />
</body>
</html>