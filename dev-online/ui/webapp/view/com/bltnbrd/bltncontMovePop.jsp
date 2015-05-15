<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>게시글 이동</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />

    <script type="text/javascript">
    var _param ;

    $a.page({
        init : function(id, param) {
        	$.PSNM.initialize(id, param); 
            _param = param; 
            $a.page.setEventListener();
            $a.page.setViewData();
            $a.page.setGrid();
        },
        setEventListener : function() {
        	//대그룹 변경시
        	$("#LVL1_ID").change(function(){
        		var lvl1_id = $(this).getValues();
        		$("#IN_LVL1_ID").val(lvl1_id);
        		
        		$("#LVL2_ID").clear();
        		$("#IN_LVL2_ID").val("");
        		
        		$("#LVL3_ID").clear();
        		$("#IN_LVL3_ID").val("");
        		$("#LVL3_ID").append("<option selected>-선택-</option>");
        		
        		if(lvl1_id == '') return;
        		
        		 $.alopex.request("com.BLTNBRD@PBLTNBRD001_pSearchBltnBrdGrp", {
                	data: {dataSet: {fields: {LVL1_ID : lvl1_id}}},
                       success:["#LVL1_ID",  function(res) {                	
                    	   var mdlComboList = res.dataSet.recordSets.mdlComboList.nc_list ;
                    	   var htm = "" ;
                    	   htm += "<option selected>-선택-</option>";
                    	   for( var i = 0 ; i<mdlComboList.length ; i++){
                    		   htm += "<option value='" + mdlComboList[i].LVL2_ID + "'>" + mdlComboList[i].LVL2_NM + "</option>" ;
                    	   }
                    	   $("#LVL2_ID").append(htm);                       	                            
                       }]
                });         	
            }); 
        	
        	//중그룹 변경시
        	$("#LVL2_ID").change(function(){
        		var lvl1_id = $("#IN_LVL1_ID").val();
        		var lvl2_id = $(this).getValues();        		
        		
        		$("#IN_LVL2_ID").val(lvl2_id);
        		
        		$("#LVL3_ID").clear();
        		$("#IN_LVL3_ID").val("");
        		
        		if( lvl1_id == '' || lvl2_id == '' ) return;
        		
        		 $.alopex.request("com.BLTNBRD@PBLTNBRD001_pSearchBltnBrdGrp", {
                	data: {dataSet: {fields: {LVL1_ID : lvl1_id, LVL2_ID : lvl2_id}}},
                       success:["#LVL2_ID",  function(res) {                	
                    	   var brdComboList = res.dataSet.recordSets.brdComboList.nc_list ;
                    	   var htm = "" ;
                    	   htm += "<option selected>-선택-</option>";
                    	   for( var i = 0 ; i<brdComboList.length ; i++){
                    		   htm += "<option value='" + brdComboList[i].LVL3_ID + "'>" + brdComboList[i].LVL3_NM + "</option>" ;
                    	   }
                    	   $("#LVL3_ID").append(htm);                          
                       }]
                });        		 
        		
            }); 
        	
        	// 게시판 변경시
        	$("#LVL3_ID").change(function(){        		
        		$("#IN_LVL3_ID").val($(this).getValues());		 
            }); 
        	
        	$("#btnConfirm").click(function(){
        		
        		if($("#IN_LVL1_ID").val() == ""){
        			$.PSNM.alert("대그룹은 필수사항 입니다.");
        			$("#LVL1_ID").focus();
        			return;
        		}
        		
        		if($("#IN_LVL2_ID").val() == ""){
        			$.PSNM.alert("중그룹은 필수사항 입니다.");
        			$("#LVL2_ID").focus();
        			return;
        		}
        	
        		if($("#IN_LVL3_ID").val() == ""){
        			$.PSNM.alert("게시판은 필수사항 입니다.");
        			$("#LVL3_ID").focus();
        			return;
        		}
        	
        		if($("#C_IN_CURR_LVL1_ID").val() == $("#IN_LVL1_ID").val()){
        			if($("#C_IN_CURR_LVL2_ID").val() == $("#IN_LVL2_ID").val()){
        				if($("#C_IN_CURR_LVL3_ID").val() == $("#IN_LVL3_ID").val()){
        					$.PSNM.alert("이동될 게시판이 현재 게시판과 동일합니다.");
        					return;
        				}
        			}
        		}
        		
        		if( $.PSNM.confirm("I004", ["이동"] ) ){
        			var bltcont_id  = _param.data != null ? _param.data.BLTCONT_ID : "";
        			var lvl3_id = $("#IN_LVL3_ID").val();
                	$.alopex.request("com.BLTNBRD@PBLTNBRD001_pUpdateBltnBrdMove", {
                		data: {dataSet: {fields: {BLTCONT_ID : bltcont_id, LVL3_ID : lvl3_id, BLTN_BRD_ID : lvl3_id}}},
                        success: function(res) { 
                            $.PSNM.alert("게시물이 이동 되었습니다.");
                            $a.close();
                        	$a.navigate("bltnBrdList.jsp?FLAG="+_param.SUP_BLTN_BRD_ID, _param);
                        }
                    });
            	}
        		
        	});
        	
        	$("#btnCancel").click(function(){
            	$a.close();
            });
        }, 
        setGrid : function() {
            //그리드 초기화
            $("#gridList").alopexGrid({
            	rowSingleSelect : true,
                paging: {
                    perPage : 10,
                    pagerCount : 10
                },
                columnMapping : [
                    { columnIndex : 0, key : "BLTCONT_TITL_NM", title : "제목",       align : "left", 	 width : "200px" }, 
                    { columnIndex : 1, key : "READ_CNT", 		title : "조회수",     align : "center",  width : "30px" },
                    { columnIndex : 2, key : "NICK_NM", 		title : "닉네임",     align : "center",  width : "40px" },
                    { columnIndex : 4, key : "RGST_DT", 		title : "작성일",     align : "center",  width : "40px" },
                    { columnIndex : 5, key : "BLTCONT_ID", 		title : "작성ID",     align : "left",    width : "0px", hidden : true },
                    { columnIndex : 6, key : "ATCH_YN", 		title : "첨부파일",   align : "left",    width : "0px", hidden : true }
                ]            
            });            
        }, 
       	setViewData : function(){
       		var bltcont_id  = _param.data != null ? _param.data.BLTCONT_ID : "";
        	var bltn_brd_id = _param.data != null ? _param.data.BLTN_BRD_ID : "";
        	$.alopex.request("com.BLTNBRD@PBLTNBRD001_pSearchBltnBrdMoveInfo", {
        		data: {dataSet: {fields: {BLTCONT_ID : bltcont_id, BLTN_BRD_ID : bltn_brd_id }}},
                success:["#form", function(res){ 
                	var largeComboList 	= res.dataSet.recordSets.largeComboList.nc_list ;
                	var mdlComboList 	= res.dataSet.recordSets.mdlComboList.nc_list ;
                	var brdComboList 	= res.dataSet.recordSets.brdComboList.nc_list ;
                	var _data 			= res.dataSet.fields ;
                	var htm = "" ;
                	
                    for(var i=0 ; i<largeComboList.length ; i++){
                    	htm += "<option value='" + largeComboList[i].LVL1_ID + "'>" + largeComboList[i].LVL1_NM + "</option>" ;
                    }
                    $("#CURR_LVL1_ID").append(htm);
                    $("#LVL1_ID").append(htm);
                    $("#CURR_LVL1_ID, #LVL1_ID").val(_data.CURR_LVL1_ID).attr("selected", "selected"); 
                    
                    htm = "" ;
                    for(var i=0 ; i<mdlComboList.length ; i++){
                    	htm += "<option value='" + mdlComboList[i].LVL2_ID + "'>" + mdlComboList[i].LVL2_NM + "</option>" ;
                    }
                    $("#CURR_LVL2_ID").append(htm);
                    $("#LVL2_ID").append(htm);
                    $("#CURR_LVL2_ID, #LVL2_ID").val(_data.CURR_LVL2_ID).attr("selected", "selected");
                    
                    htm = "" ;
                    for(var i=0 ; i<brdComboList.length ; i++){
                    	htm += "<option value='" + brdComboList[i].LVL3_ID + "'>" + brdComboList[i].LVL3_NM + "</option>" ;
                    }
                    $("#CURR_LVL3_ID").append(htm);
                    $("#LVL3_ID").append(htm);
                    $("#CURR_LVL3_ID, #LVL3_ID").val(_data.CURR_LVL3_ID).attr("selected", "selected");
                    
                    $("#C_IN_CURR_LVL1_ID").val($("#CURR_LVL1_ID").val());
        			$("#IN_LVL1_ID").val($("#LVL1_ID").val());
        			
        			$("#C_IN_CURR_LVL2_ID").val($("#CURR_LVL2_ID").val());
        			$("#IN_LVL2_ID").val($("#LVL2_ID").val());
        			
        			$("#C_IN_CURR_LVL3_ID").val($("#CURR_LVL3_ID").val());
        			$("#IN_LVL3_ID").val($("#LVL3_ID").val()); 
        			
        			var gridList = res.dataSet.recordSets;
                   	
                    $.each(gridList, function(key, data) {
                    	$("#"+key).alopexGrid("dataSet", data.nc_list);
                    });  
                    
                }]
            });
       	},
       	changeLvl1 : function (){
       		
       	},
       	setSelctBox : function(elemId, dataList) {
       		var htm = "" ; 
       		if( dataList ){
       			for(var i=0 ; i<dataList.length ; i++){
                	htm += "<option value='" + dataList[i].LVL1_ID + "'>" + dataList[i].LVL1_NM + "</option>" ;
                }
                $("#"+elemId).html('');
               	$("#"+elemId).html(htm);
       		}
            
        }
    });//end-of-$.alopex.page //-------------------------------------------------------------------------------------------------------//
   
    </script>
</head>

<body>

<div id="contents">

    <!-- title area -->
    <div class="pop_header">
    	
        <div class="textAR">
        <div class="floatL4"> 
        	<img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>게시글 이동</b>                
        </div>
          <form id="searchForm">
            <div>
                <table class="board02">
                <colgroup>
					<col style="10%" />
					<col style="40%" />
					<col style="10%" />
					<col style="40%" />
				</colgroup>
                <tr>
                	<th scope="col" colspan="2">현재게시판</th>
                	<th scope="col" colspan="2">이동할 게시판</th>
                </tr>
                <tr>
                    <th scope="col">대그룹</th>
                    <td class="tleft">
                        <select id="CURR_LVL1_ID" data-bind="options:options_CURR_LVL1_ID, selectedOptions:CURR_LVL1_ID" data-type="select" data-disabled="true" style="width:170px;"></select>
                        <input id="C_IN_CURR_LVL1_ID" name="C_IN_CURR_LVL1_ID" data-type="textinput" data-bind="" data-disabled="true" style="width:35px;"/>
                    </td>
                    <th scope="col">대그룹</th>
                    <td class="tleft">
                        <select id="LVL1_ID" data-bind="options:options_LVL1_ID, selectedOptions:LVL1_ID" data-type="select" style="width:170px;"></select>
                        <input id="IN_LVL1_ID" name="IN_LVL1_ID" data-type="textinput" data-bind="" data-disabled="true" style="width:35px;"/>
                    </td>                                      
                </tr>
                <tr>
                    <th scope="col">중그룹</th>
                    <td class="tleft">
                        <select id="CURR_LVL2_ID" data-bind="options:options_CURR_LVL2_ID, selectedOptions:CURR_LVL2_ID" data-type="select" data-disabled="true" style="width:170px;"></select>
                        <input id="C_IN_CURR_LVL2_ID" name="C_IN_CURR_LVL2_ID" data-type="textinput" data-bind="" data-disabled="true" style="width:35px;"/>
                    </td>
                    <th scope="col">중그룹</th>
                    <td class="tleft">
                        <select id="LVL2_ID" data-bind="options:options_LVL2_ID, selectedOptions:LVL2_ID" data-type="select"  style="width:170px;"></select>
                        <input id="IN_LVL2_ID" name="IN_LVL2_ID" data-type="textinput" data-bind="" data-disabled="true" style="width:35px;"/>
                    </td>                    
                </tr>
                <tr>
                    <th scope="col">게시판</th>
                    <td class="tleft">
                        <select id="CURR_LVL3_ID" data-bind="options:options_CURR_LVL3_ID, selectedOptions:CURR_LVL3_ID" data-type="select" data-disabled="true" style="width:170px;"></select>
                        <input id="C_IN_CURR_LVL3_ID" name="C_IN_CURR_LVL3_ID" data-type="textinput" data-bind="" data-disabled="true" style="width:35px;"/>
                    </td>
                    <th scope="col">게시판</th>
                    <td class="tleft">
                        <select id="LVL3_ID" data-bind="options:options_LVL3_ID, selectedOptions:LVL3_ID" data-type="select"  style="width:170px;"></select>
                        <input id="IN_LVL3_ID" name="IN_LVL3_ID" data-type="textinput" data-bind="" data-disabled="true" style="width:35px;"/>
                    </td>                    
                </tr>
                </table>
            </div>
          </form>           
        </div>

        <!--view_table area -->
        <div class="textAR">

            <div class="floatL4"> 
            	<img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>답글 목록</b>               
            </div>

            <!-- main grid -->
            <div id="gridList" data-bind="grid:gridList" data-ui="ds"></div>
			<br>*게시글을 이동하면 답글도 함께 이동됩니다.
            <p class="floatL2">
                <input id="btnConfirm" type="button" value="" data-type="button" data-theme="af-btn8">
                <input id="btnCancel"  type="button" value="" data-type="button" data-theme="af-btn10">
            </p>
        </div>

    </div>

</div>

</body>
</html>