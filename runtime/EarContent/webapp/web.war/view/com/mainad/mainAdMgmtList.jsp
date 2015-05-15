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
    <script type="text/javascript">
    _LOG_LEVEL = 0; //로그레벨 :: 0=debug, 1=info, 2=error

    var _TX_SEARCH        = "com.MAINAD@PMAINAD001_pSearchMainAd";
    var _param;
    $.alopex.page({
        init : function(id, param) { 
        	
			$.PSNM.initialize(id, param); //PSNM공통 초기화함수 호출
			_param = param;
			$a.page.setEventListener(); //버튼 초기화
			$a.page.setGrid(); //그리드 초기화
			$("#searchForm").setData(param);    
			if(param.FROM_DT==null && param.TO_DT==null){

	            $("#FROM_DT").val(getCurrdate());
    			$("#TO_DT").val(getAddDate(getCurrdate(),3));

			}
			//alert($("#HDQT_TEAM_ORG_ID").val());
			if ($.PSNMUtils.isNotEmpty($("#HDQT_TEAM_ORG_ID").val())) {
				$a.page.searchList(param);	
			}
        },
        setEventListener : function() {
            $("#btnSearch").click($a.page.searchList);//조회
            $("#btnNew").click(function(){//신규
            	var param = $('#searchForm').getData();
                param["page_size"] = $('#grid').alopexGrid('pageInfo').perPage;
    	        try { 
					param["page"]  = $("#grid").alopexGrid("pageInfo").customPaging.current; 
    	        } catch(E) {
    	            param["page"]  = 1; //디폴트 1페이지
    	        }
            	$a.navigate("mainAdMgmtDtl.jsp", param);
            });
        }, 
        setGrid : function() {
        
            $("#grid").alopexGrid({
                rowClickSelect : false,
                rowInlineEdit : true,
                columnMapping : [
					{ columnIndex : 0, key  : "ORG_NM",  	 	    title : "본사팀",     	align : "center",		 width : "80px" },
                    { columnIndex : 1, key  : "MAIN_AD_NM",  	title : "제목",       	align : "left",		 width : "300px" },
                    { columnIndex : 2, key  : "LINK_URL",  	 		title : "URL",       	align : "left",		 width : "150px" },
                    { columnIndex : 3, key  : "AD_STA_DT", 		  	title : "광고시작",       	align : "center", 	 width : "60px"  },
                    { columnIndex : 4, key  : "AD_END_DT", 		title : "광고종료",       	align : "center", 	 width : "60px"  },
                    { columnIndex : 5, key  : "RGSTR_NM",   		title : "등록자",       	align : "center",    width : "60px"  },
                    { columnIndex : 6, key  : "RGST_DTM",    		title : "등록일",         align : "center", 	 width : "60px"  }, 
                    { columnIndex : 7, key  : "MAIN_AD_ID",    	title : "등록자ID",       hidden:true }, 
                    
                ],
                on : {
                    perPageChange : function(arg1) {
                    },
                    pageSet : function(pageNoToGo) {
                    	 var p = {};
                         p.page = pageNoToGo;
                    	 $a.page.searchList(p); //페이지 이동
                    },
                    "cell" : {
    					"dblclick" : function(data, eh, e) {  
    				
								var param = $("#searchForm").getData({});
								param["MAIN_AD_ID"]    = data.MAIN_AD_ID;
								param["page"]      = $("#grid").alopexGrid("pageInfo").customPaging.current; //
								param["page_size"] = $("#grid").alopexGrid("pageInfo").perPage;
								$a.navigate("mainAdMgmtDtl.jsp", param);
    						
    					}
    				}
                }
            });
        },
        searchList : function(param){
    		if ( ! $.PSNM.isValid("#searchForm") ) {
			    return false; //값 검증
			}

          	var _page_no = 1;
			if ( $.PSNMUtils.isNotEmpty(param) && $.PSNMUtils.isNotEmpty(param.page) ) {
				_page_no = param.page; //(설명) 페이지 이동할때만 페이지번호가 넘어옴.
            }
			var _per_page = $('#grid').alopexGrid('pageInfo').perPage; 
            $.alopex.request(_TX_SEARCH, {
				data : ["#searchForm", function(){
					this.data.dataSet.fields.FROM_DT      =  $.PSNMUtils.getDateInput("FROM_DT");    
    				this.data.dataSet.fields.TO_DT      =  $.PSNMUtils.getDateInput("TO_DT");
					this.data.dataSet.fields.page 	   = _page_no;
					this.data.dataSet.fields.page_size = _per_page;
      			}],
				success: ["#grid", function(res) {
				}]
            });
        }
	       
        
    });
    
    </script>
</head>
<body>
<jsp:include page="/view/layouts/default_header.jsp" flush="false" />
	<!-- title area -->
<div id="contents">
	<div class="content_title">
    	<div class="ub_txt6">
        	<span class="txt6_img"><b id="sub-title">메뉴제목</b>
        	<span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif"> 
        	<span class="a2">대메뉴명</span> <span class="a3"> > </span> <span class="a4"><b>중메뉴명</b> </span></span></span>
       	</div>
    </div>

  <!-- find condition area -->
	<div class="textAR"> 
		<form id="searchForm">
			<table class="board02" style="width:92%">
		      	<colgroup>
		            <col style="width:12%"/>
		            <col style="width:15%"/>
		            <col style="width:12%"/>
		            <col style="width:15%"/>
		            <col style="width:12%"/>
		            <col style="width:*"/>
		        </colgroup>
				<tr>
					<th class="fontred">본사팀</th>
					<td class="tleft">
	                    <select id="HDQT_TEAM_ORG_ID" data-bind="options:options_HDQT_TEAM_ORG_ID, selectedOptions: HDQT_TEAM_ORG_ID" data-type="select" 
	                    	data-validation-rule="{required:true}"
							data-validation-message="{required:$.PSNM.msg('E012', ['본사팀'])}">
	                    	<option value="">-선택-</option>
	                    </select>
	                </td>
					<th>제목</th>
					<td class="tleft">
						<input id="SEARCH_NM" name="SEARCH_NM" data-bind="value:SEARCH_NM" data-type="textinput" data-agentid="SEARCH_NM" style="width:90%;" maxlength="100" />
					</td>
					<th>광고적용기간</th>
					<td class="tleft">
						<div data-type="daterange" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png" >
						<input id="FROM_DT" name="FROM_DT" data-role="startdate" data-bind="value:FROM_DT" style="width:70px;"
						    data-validation-rule="{required:true}"
						    data-validation-message="{required:$.PSNM.msg('E012', ['적용기간FROM'])}"/
						/>
						~ <input id="TO_DT" name="TO_DT" data-role="enddate" data-bind="value:TO_DT" style="width:70px;"
							data-validation-rule="{required:true}"
						 	data-validation-message="{required:$.PSNM.msg('E012', ['적용기간TO'])}"/>
					</div>
					</td>
				</tr>
			</table>
				<div class="ab_pos5">
					<input id="btnSearch" type="button" value="" data-type="button" data-theme="af-psnm" data-authtype="R">
				</div>
		</form>
	</div>
	<div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>광고 목록</b>
		<p class="ab_pos2">
			<button id="btnNew" type="button" data-type="button" data-theme="af-btn2" data-altname="신규" data-authtype="W"></button>
		</p>
	</div>

	<!-- main grid -->
	<div id="grid" data-bind="grid:grid" data-ui="ds"></div>
 
</div>
<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />
</body>
</html>