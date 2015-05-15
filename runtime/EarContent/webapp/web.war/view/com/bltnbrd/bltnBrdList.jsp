<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<% String FLAG = request.getParameter("FLAG"); %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

    <jsp:include page="/view/layouts/default_head.jsp" flush="false" />
    <script src="../../../script/jquery.cookie.js" type="text/javascript"></script>
	<script src="../../../script/jquery.treeview.js" type="text/javascript"></script>
    <script type="text/javascript">
    
    var _param;
    
    $.alopex.page({

        init : function(id, param) { 
        	_param = param; 					//이 페이지로 전달된 파라미터를 저장
            $.PSNM.initialize(id, param); 		//PSNM공통 초기화함수 호출 
            
            $a.page.setTree(param);
            $a.page.setEventListener();
            $a.page.setGrid();
            $a.page.setCodeData();
            $a.page.setTitle();
            $("#searchTable").setData(param);  //(설명) 상세페이지에서 돌아오는 경우, 이 값들이 세션스토리지에서 반환됨.
            if( _param.BLTN_BRD_ID ){ //상세페이지에서 들어온경우
               	getBrdList( _param.BLTN_BRD_TYP_CD, _param.BLTN_BRD_ID, _param.AUTH_TYP_CD, _param) ;
            }
        },
        setEventListener : function() {
        	$("#btnSearch").click($a.page.searchList);
            
            $("#btnNew").click(function(){
            	var param = $('#searchTable').getData();
                param["page_size"] 		 = $('#grid').alopexGrid('pageInfo').perPage;
                param["BLTN_BRD_ID"] 	 = $('#BLTN_BRD_ID').val();
                param["SUP_BLTN_BRD_ID"] = $('#SUP_BLTN_BRD_ID').val();
                param["SMS_RCV_YN"] 	 = $('#SMS_RCV_YN').val();
                param["BLTN_BRD_TYP_CD"] 	 = _param.BLTN_BRD_TYP_CD;
                param["AUTH_TYP_CD"] 	 = _param.AUTH_TYP_CD;
                
    	        try { 
    	            param["page"]  = $("#grid").alopexGrid("pageInfo").customPaging.current; 
    	        } catch(E) {
    	            param["page"]  = 1; //디폴트 1페이지
    	        }
            	$a.navigate("bltnBrdRgst.jsp", param);
            });
            
            $("#btnDel").click(function(){  //삭제버튼(일괄버튼)
            	var param = $('#searchTable').getData();
                param["BLTN_BRD_ID"]     = $('#BLTN_BRD_ID').val();

                $a.popup({
                    url: "com/bltnbrd/bltnBrdRemovePop"
                  , data: param
                  , width: 410
                  , height: 300
                  , windowpopup: false
                  , iframe: true
                  , title: "일괄삭제"
                  , callback : function( oResult ) {                      
                	  
                	  if ( $.PSNMUtils.isNotEmpty( oResult ) && "success"==oResult["result"] ) {
                		  $a.page.searchList();
                	  }                      
                  }
                });
            });
        },
        setGrid : function() {
            $("#grid").alopexGrid({
                rowClickSelect : false,
                rowInlineEdit : true,
                columnMapping : [
                                        
                    { columnIndex : 0,	key : "BLTCONT_ID",			title : "글번호",	align : "center",	width : "100px", hidden : true },
                    { columnIndex : 1,	key : "BLTCONT_TITL_NM",	title : "제목",		align : "left",		width : "300px",                    	   
	                    render : function(value, data) {
	                    	var ntImg = data["BLTCONT_ST"] == "NT" ? '<img src="${pageContext.request.contextPath}/image/blat_a10.gif">&nbsp;' : '';
	                		var nwImg = data["BLTCONT_ST"] == "NW" ? '&nbsp;<img src="${pageContext.request.contextPath}/image/blat_a11.gif">&nbsp;' : '';
	                		var disk  = data["ATCH_YN"] == 'Y' ? '&nbsp;<img src="${pageContext.request.contextPath}/image/blat_adisk.gif"/>' : '';
	                		var reple = data["BLTCONT_TYP_CD"] == "1" ? '&nbsp;&nbsp;&nbsp;&nbsp;<img src="${pageContext.request.contextPath}/image/blat_a25.gif"/>&nbsp;' : '';
	                		var scrtImg = data["SCRT_NUM_SET_YN"] == "Y" ? '<img src="${pageContext.request.contextPath}/image/ic_secure.gif"/>&nbsp;' : ''; //20150310 kbssun modify
	                		var cmnt  = data['CMNT_CNT'] > 0 ? '&nbsp;<font color="red">['+data['CMNT_CNT']+']</font>' : '';
	                	    
	                		//notice일 경우, 제목을 bold처리
	                		var valueBold = data["BLTCONT_ST"] == "NT" ? '<b>['+ value +']</b>' : value;
	                		
	                		return ntImg + reple + valueBold + cmnt + nwImg + scrtImg + disk;
						}
                    },                    
                    { columnIndex : 2,	key : "READ_CNT",			title : "조회수",	align : "center",	width : "30px" },
                    { columnIndex : 3,	key : "RGSTR_NM",			title : "작성자",	align : "center",	width : "50px" },
                    { columnIndex : 4,	key : "RGSTR_ID",			title : "",			align : "center",	width : "100px", hidden : true},
                    { columnIndex : 5,	key : "RGST_DT",			title : "작성일시",	align : "center",	width : "70px" },
                    { columnIndex : 6,	key : "BLTN_BRD_ID",		title : "",			align : "center",	width : "100px", hidden : true },
                    { columnIndex : 7,	key : "SCRT_NUM_SET_YN",	title : "",			align : "center",	width : "100px", hidden : true }
                    
                ],
                on : {
                	pageSet : function(pageNoToGo) {
                        var p = {};
                            p.page = pageNoToGo;
                            $a.page.searchList(p);
                    },
                    "cell" : {
    					"click" : function(data, eh, e) {
    						//if(data._index.column == 1) {
        				    if(data._index.column != 0) {
    							
        				    	if( data["SCRT_NUM_SET_YN"] == "Y" ) {
        				    		
        				    		//비밀글이면 권한을 취득
        				    		$.alopex.request("com.BLTNBRD@PBLTNBRD001_pCheckBltnBrd", {
        				    			data: {dataSet: {fields: {BLTN_BRD_ID : _param.BLTN_BRD_ID, BLTCONT_ID : data.BLTCONT_ID }}},
        				    			
        				    			success: function(res) {
        				    			    
        				    				//$.PSNM.alert( res.dataSet.fields["AUTH_TYP_CD"]); //E
        				    				//$.PSNM.alert( res.dataSet.fields["RGSTR_YN"]);    //N
        				    				
        				    				if( res.dataSet.fields["AUTH_TYP_CD"] == "E" || res.dataSet.fields["RGSTR_YN"] == "Y" ) {
        				    					//이전글, 다음글 조회를 위해 검색조건을 모두 파라메터로 넘긴다.
        				    					var param = $("#searchTable").getData({selectOptions:true});
        	                                    param["data"]            = data;
        	                                    param["page"]            = $("#grid").alopexGrid("pageInfo").customPaging.current;
        	                                    param["page_size"]       = $("#grid").alopexGrid("pageInfo").perPage;
        	                                    param["SUP_BLTN_BRD_ID"] = $("#SUP_BLTN_BRD_ID").val();
        	                                    param["BLTN_BRD_ID"]     = _param.BLTN_BRD_ID ;
        	                                    param["BLTN_BRD_TYP_CD"] = _param.BLTN_BRD_TYP_CD ;
        	                                    param["AUTH_TYP_CD"] 	 = _param.AUTH_TYP_CD;
        	                                    param["RGST_DTM_FROM"] = $("#RGST_DTM_FROM").val();
        	                                    param["RGST_DTM_TO"] = $("#RGST_DTM_TO").val();
        	                                    $a.navigate("bltnBrdDtl.jsp", param);	                                            
	                                        }else{
	                                            
	                                        	$.PSNM.alert('비밀글은 작성자 본인만 조회 가능합니다.');
	                                        }
        				    			}
        				    			
						            });
        				    		
        				    	}
        				    	else {
        				    		var param = $("#searchTable").getData({selectOptions:true});
                                    param["data"]            = data;
                                    param["page"]            = $("#grid").alopexGrid("pageInfo").customPaging.current;
                                    param["page_size"]       = $("#grid").alopexGrid("pageInfo").perPage;
                                    param["SUP_BLTN_BRD_ID"] = $("#SUP_BLTN_BRD_ID").val();
                                    param["BLTN_BRD_ID"]     = _param.BLTN_BRD_ID ;
                                    param["BLTN_BRD_TYP_CD"] = _param.BLTN_BRD_TYP_CD ;
                                    param["AUTH_TYP_CD"] 	 = _param.AUTH_TYP_CD;
                                    param["RGST_DTM_FROM"] = $("#RGST_DTM_FROM").val();
                                    param["RGST_DTM_TO"] = $("#RGST_DTM_TO").val();
                                    $a.navigate("bltnBrdDtl.jsp", param);
        				    	}
    						}
    					}
    				}
                }
            });
        },
        setCodeData : function() {
            $.PSNMUtils.setCodeData([
				{ t:'code', 'elemid' : 'DSM_BLTCONT_BRWS_COND_CD', 'codeid' : 'DSM_BLTCONT_BRWS_COND_CD', 'header' : '-전체-' }
            ]);
        },
        searchList: function(param) {        	
            var _page_no = 1;
            if ( $.PSNMUtils.isNotEmpty(param) && $.PSNMUtils.isNotEmpty(param.page) ) {
                _page_no = param.page;
            } 
            var _per_page = $("#grid").alopexGrid("pageInfo").perPage;            
            
            $.alopex.request("com.BLTNBRD@PBLTNBRD001_pSearchBltnBrdList", {
                data: ["#searchTable", function() {
                	this.data.dataSet.fields.FROM_DT     = $.PSNMUtils.getDateInput("FROM_DT");
                	this.data.dataSet.fields.TO_DT       = $.PSNMUtils.getDateInput("TO_DT");
                    this.data.dataSet.fields.page        = _page_no;
                    this.data.dataSet.fields.page_size 	 = _per_page; 
                  	this.data.dataSet.fields.BLTN_BRD_ID = _param.BLTN_BRD_ID ;                                     
                }],
                success: ["#grid", function(res) {                	
                }]
            });
        },
        setTitle : function(param) {
        	var _brd_id = "<%=FLAG%>";
        	var _sub_title;
        	if(_brd_id == "1000"){
        		_sub_title = "전체 영업국 공통";
        	}else if(_brd_id == "1001"){
        		_sub_title = "DSM 사무국";
        	}else if(_brd_id == "1002"){
        		_sub_title = "DSM서울";
        	}else if(_brd_id == "1003"){
        		_sub_title = "DSM대구";
        	}else if(_brd_id == "1004"){
        		_sub_title = "DSM부산";
        	}else if(_brd_id == "1005"){
        		_sub_title = "DSM중부";
        	}else if(_brd_id == "1006"){
        		_sub_title = "DSM서부";
        	}
        		$("#sub-title").text(_sub_title+" 게시판");
        	
        	
        },
        setTree : function(param) {        	
        	$.alopex.request("com.BLTNBRD@PBLTNBRD001_pSearchBltnBrdTree", {
        		data: {dataSet: {fields: {BLTN_BRD_ID : "<%=FLAG%>" }}},                
                success: ['#treeform', function(res) {
                	 $a.page.treeData(res.dataSet.recordSets.tree);
                }]
            });
        },
        treeData : function(param){
            
        	if( param.nc_recordCount == 0 ){
            	$.PSNM.alert("권한이 없습니다.");
            	
            	//버튼 비활성화
            	$("#btnSearch").setEnabled(false);
            	$("#btnNew").setEnabled(false);
            	$("#btnDel").setEnabled(false);
            	
            	return ;
            }
            
    		var data = param.nc_list ;
    		var sup_id = "" ;
	        var el ;
	        
            for( i=0 ; i<param.nc_recordCount ; i++){      	           	        
    	        if( data[i].BLTN_BRD_TYP_CD == "2" ){
    	            $("#tree").createNode("", {
      	        	      id 	  : data[i].BLTN_BRD_ID ,
      	        	      text	  : data[i].BLTN_BRD_NM,
      	        	      //linkUrl : "javascript:void(getBrdList(\'" + data[i].BLTN_BRD_TYP_CD + "\',\'" + data[i].BLTN_BRD_ID + "\'));"
      	        	    linkUrl : "javascript:void(getBrdList(\'" + data[i].BLTN_BRD_TYP_CD + "\',\'" + data[i].BLTN_BRD_ID + "\',\'" + data[i].AUTH_TYP_CD + "\',\'" + param + "\'));"
      	        	});    	           
    	            sup_id = data[i].BLTN_BRD_ID ;
    	        }else if( data[i].BLTN_BRD_TYP_CD == "3" ){
    	        	el = $("#tree").getNode(sup_id, "id");
    	            $("#tree").createNode(el, {
      	        	      id 	  : data[i].BLTN_BRD_ID ,    	        	    
      	        	      text	  : data[i].BLTN_BRD_NM,
      	        	      //linkUrl : "javascript:void(getBrdList(\'" + data[i].BLTN_BRD_TYP_CD + "\',\'" + data[i].BLTN_BRD_ID + "\'));"
      	        	    linkUrl : "javascript:void(getBrdList(\'" + data[i].BLTN_BRD_TYP_CD + "\',\'" + data[i].BLTN_BRD_ID + "\',\'" + data[i].AUTH_TYP_CD + "\',\'" + param + "\'));"
      	        	}); 
    	        } 
    	        $("#"+data[i].BLTN_BRD_ID).data("SUP_BLTN_BRD_ID", data[i].SUP_BLTN_BRD_ID);
    	        $("#"+data[i].BLTN_BRD_ID).data("BLTN_BRD_ID", data[i].BLTN_BRD_ID);	              
	            $("#"+data[i].BLTN_BRD_ID).data("BLTN_BRD_NM", data[i].BLTN_BRD_NM);
            }   
            $("#tree").treeview({
       			collapsed: true
            });
            $("#tree").expandAll();
            
             //트리 최초 생성시 값 설정
             if($.PSNMUtils.isNotEmpty(_param.BLTN_BRD_TYP_CD)){ //상세페이지에서 들어온 경우
             	if(_param.BLTN_BRD_TYP_CD == "2"){
                 	treePathNm = $("#"+_param.BLTN_BRD_ID).data("BLTN_BRD_NM");
                 }else{
                	 
                 	treePathNm = $("#"+$("#"+_param.BLTN_BRD_ID).data("SUP_BLTN_BRD_ID")).data("BLTN_BRD_NM") + " > " + $("#"+_param.BLTN_BRD_ID).data("BLTN_BRD_NM");
                 	$("#"+_param.BLTN_BRD_ID+" a").addClass("af-pressed"); //트리 클릭효과 class 추가
                 }
             	$("#titleNm").text(treePathNm);
             }else{
             	$("#titleNm").text(data[0].BLTN_BRD_NM);
             	$("#btnNew").hide();
             	$("#btnDel").hide();
     			$("#btnSearch").hide();	
             }            
        }
    });  
    function getBrdList( bltnTypCd, bltnBrdId, authTypCd, param ){

    	//alert("bltnTypCd : " + bltnTypCd +":"+"bltnBrdId : " +bltnBrdId+":"+"authTypCd : " +authTypCd);
    	
    	$("#BLTN_BRD_ID").val(bltnBrdId);
		_param["BLTN_BRD_ID"] = bltnBrdId ;
		_param["BLTN_BRD_TYP_CD"] = bltnTypCd ;
		_param["AUTH_TYP_CD"] = authTypCd ;
		
		var treePathNm = "" ; 
		
		if( bltnTypCd == "2" ){ //최상위 카테고리인 경우
			$("#btnNew").hide();
			$("#btnDel").hide(); 
			$("#btnSearch").hide();			 
			treePathNm = $("#"+bltnBrdId).data("BLTN_BRD_NM");
		}else{
			if( authTypCd == "W" || authTypCd == "E") {
				$("#btnNew").show();
			}else{
				$("#btnNew").hide();
			}
			$("#btnSearch").show();
			if( authTypCd == "E") {  //권한유형코드(E) 삭제버튼
				$("#btnDel").show();
			} else {
				$("#btnDel").hide();
			}
			
			treePathNm = $("#"+$("#"+bltnBrdId).data("SUP_BLTN_BRD_ID")).data("BLTN_BRD_NM") + " > " + $("#"+bltnBrdId).data("BLTN_BRD_NM");			
			//해당게시판 필요 정보조회
			$.alopex.request("com.BLTNBRD@PBLTNBRD001_pSearchBltnBrdInfo", {
    			data: {dataSet: {fields: {BLTN_BRD_ID : bltnBrdId }}},
                success: ["#searchTable", function(res) {
                	var srchPrdCd = res.dataSet.fields.SRCH_PRD_CD ;
                	var srchPrdChgYn = res.dataSet.fields.SRCH_PRD_CHG_YN ;
                	$("#BLT_DTM_YN").val(res.dataSet.fields.BLT_DTM_YN);
                	$("#SMS_RCV_YN").val(res.dataSet.fields.SMS_RCV_YN);
                	
        			switch( srchPrdCd ) {
        			case '01' :  //1달
        				$("#RGST_DTM_FROM").val(getAddMonthDate(0));
        				$("#RGST_DTM_TO").val(getCurrdate());
        				break;
        			case '02' :  //2달
        				$("#RGST_DTM_FROM").val(getAddMonthDate(-1));
        				$("#RGST_DTM_TO").val(getCurrdate());
        				break;
        			case '03' :  //3달
        				$("#RGST_DTM_FROM").val(getAddMonthDate(-2));
        				$("#RGST_DTM_TO").val(getCurrdate());
        				break;
        			case '04' :  //6달
        				$("#RGST_DTM_FROM").val(getAddMonthDate(-5));
        				$("#RGST_DTM_TO").val(getCurrdate());
        				break;
        			case '05' :  //1년
        				$("#RGST_DTM_FROM").val(getAddMonthDate(-11));
        				$("#RGST_DTM_TO").val(getCurrdate());
        				break;
        			case '06' :  //2년
        				$("#RGST_DTM_FROM").val(getAddMonthDate(-23));
        				$("#RGST_DTM_TO").val(getCurrdate());
        				break;
        			case '07' : 
        				$("#RGST_DTM_FROM").val('2013-01-01');
        				$("#RGST_DTM_TO").val(getCurrdate());
        				break;
        			default :
        				$("#RGST_DTM_FROM").val(getAddDate(getCurrdate(),-59));
        				$("#RGST_DTM_TO").val(getCurrdate());
        			}
        			
        			if( srchPrdChgYn == 'N') {
        				$("#dr").setEnabled(false);
        				//$("input[name^=RGST_DTM_]").attr("disabled", true);        				
        			} else {
        				$("#dr").setEnabled(true);
        				//$("input[name^=RGST_DTM_]").attr("disabled", false); 
        			}
                }]
            });
		}	
		$("#titleNm").text(treePathNm); //게시판 타이틀 변경
		$a.page.searchList(param);
    }
    </script>

</head>

<body>

<jsp:include page="/view/layouts/default_header.jsp" flush="false" />

<div id="contents">

    <!-- sub title area -->
    <div class="content_title">
        <div id="ub_txt6">
            <span class="txt6_img"><b id="sub-title"></b>
                <span class="notice-more"> 
                	<img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif">
                	<span class="a2">커뮤니티</span> <span class="a3"> > </span> <span class="a4"><b>게시판</b></span>
                </span>
            </span>
        </div>
    </div>

    <!-- find condition area -->
    <div class="org_wrap">
		<form id="treeform">
		<input type="hidden" id="BLTN_BRD_ID" 	  name="BLTN_BRD_ID"/>
		<input type="hidden" id="SUP_BLTN_BRD_ID" name="SUP_BLTN_BRD_ID" value="<%=FLAG%>"/>
		<input type="hidden" id="SMS_RCV_YN" 	  name="SMS_RCV_YN"/>
			<div class="org_tree">
				<ul id="tree" data-type="tree"></ul>
			</div>
		</form>
		<div class="org_result">
			<div id="searchDiv" class="textAR">
				<form id="searchForm" onsubmit="return false;">
		        	<table id="searchTable" class="board02" style="width:90%;">		        	
		        	<colgroup>
			            <col style="width:12%"/>
			            <col style="width:40%"/>
			            <col style="width:12%"/>
			            <col style="width:*"/>
		            </colgroup>
		        	<tbody>
		        	<tr>
		                <th scope="col" class="fontred">조회기간</th>
		                <td class="tleft">
		                	<div data-type="daterange" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png" id="dr" >
								<input id="RGST_DTM_FROM" name="RGST_DTM_FROM" data-role="startdate" data-bind="value:RGST_DTM_FROM" style="width:80px;"/>
								~ <input id="RGST_DTM_TO" name="RGST_DTM_TO" data-role="enddate" data-bind="value:RGST_DTM_TO" style="width:80px;"/>
							</div>
							<input type="hidden" id="BLT_DTM_YN" name="BLT_DTM_YN" data-bind="value:BLT_DTM_YN"/>
						</td>
						<th>조회조건</th>
						<td class="tleft">
		                    <select id=DSM_BLTCONT_BRWS_COND_CD name="DSM_BLTCONT_BRWS_COND_CD" data-type="select" data-bind="options: options_DSM_BLTCONT_BRWS_COND_CD, selectedOptions: DSM_BLTCONT_BRWS_COND_CD"></select>
		                    <input id="DSM_BLTCONT_BRWS_COND_NM" name="DSM_BLTCONT_BRWS_COND_NM" data-type="textinput" data-bind="value:DSM_BLTCONT_BRWS_COND_NM"/>
		                </td>
		            </tr>
		        	</tbody>
		            </table>
		        </form>
				<div class="ab_pos5">
					<!-- <button id="btnInit"   type="button" data-type="button" data-theme="af-psnm0" data-authtype="R">초기화</button> -->
					<button id="btnSearch" type="button" data-type="button" data-theme="af-psnm" data-authtype="R"></button>			
				</div>
		    </div>
	    	<div class="btn_right">   
	    		<button id="btnNew" data-type="button" data-theme="af-btn2" data-authtype="W" data-altname="신규"></button>  
	    		<button id="btnDel" data-type="button" data-theme="af-btn13" data-authtype="W" data-altname="삭제"></button>  		
	        </div>
		
		    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b> <span id="titleNm"></span></b>
		    </div>	
		    
		    	    
			<div id="grid" data-bind="grid:grid" data-ui="ds"></div>
			<p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p>
		</div>
	</div>

</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>