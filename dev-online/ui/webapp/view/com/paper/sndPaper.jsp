<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<jsp:include page="/view/layouts/default_head.jsp" flush="false" />
<!-- *.js 파일들가져옴.. -->
<script type="text/javascript">
    
    var _TX_SEARCH  = "com.PAPER@PPAPERMGMT001_pSearchSndPaper";
    var _param;

    $.alopex.page({
        init : function(id, param) { 
            $.PSNM.initialize(id, param); //PSNM공통 초기화함수 호출(서브 페이지에서는 필수 호출)
            _param = param;
            $a.page.setEventListener(); //버튼이 눌렸을때 실행할 이벤트리스너 
            $("#TO_DT").val(getCurrdate());
   			$("#FROM_DT").val(getAddMonthDate());
            $("#searchForm").setData(param);

            $("#FROM_DT").update({
                mindate: new Date(getAddMonthDate()),
                maxdate: new Date(getAddMonthDate(1))
            });  
            $("#TO_DT").update({
            	mindate: new Date(getAddMonthDate()),
                maxdate: new Date(getAddMonthDate(1))
            });

            $a.page.setGrid(); //그리드
            pSearchPhrs( param ); //조회
            
        },
        setEventListener : function() { 
            $("#btnSearch").click( pSearchPhrs ); //해당버튼이 눌르면 실행되는 함수
            $("#btnDel").click(function(){
                var oRecord = $("#gridpaper").alopexGrid( "dataGet" , { _state : { selected : true } } );
                if (oRecord.length == 0) {
                    $.PSNM.alert("삭제할 행을 선택하십시오.");
                return;
                }
                $("#gridpaper").alopexGrid( "dataEdit", {"FLAG":"D"}, { _state: { selected : true } } );
                if( $.PSNM.confirm("I004", ["삭제"] ) ){
                    var requestData = $.PSNMUtils.getRequestData("gridpaper");
                    $.alopex.request("com.PAPER@PPAPERMGMT001_pDeleteSndPaper", {
                        data: requestData,
                        success : function(res) {
                            pSearchPhrs(_param);
                        }
                    });
                }
            }); 
        },
        setGrid : function() {
            $("#gridpaper").alopexGrid({
                rowClickSelect : false,
                rowInlineEdit : true,
                columnMapping : [   //컬럼맵핑     
                    {
                        columnIndex : 0, width : "5px",
                        selectorColumn : true, fixed : true 
                    },
                    { 
                        columnIndex : 1, key : "RN", title : "글번호", hidden:true 
                    },
                    { 
                        columnIndex : 2, key : "PAPER_ID", title : "쪽지id",   hidden:true 
                    },
                    { 
                        columnIndex : 3, key : "SND_USER_ID", title : "보낸사람 id",hidden:true 
                    },
                    { 
                        columnIndex : 4, key : "RCV_USER_ID", title : "받은사람 id", hidden:true
                    },
                    { 
                        columnIndex : 5, key : "RCV_USER_NM", title : "받는 사람", align: "center", width: "30px"
                    },
                    { 
                        columnIndex : 6, key : "TITLE", title : "제목", align : "left", width : "100px" 
                            , render : function(value, data) {
                                if(data["ATCH_FILE_YN"]=="첨부") {
                                    return value+'&nbsp;<img src="${pageContext.request.contextPath}/image/blat_adisk.gif">';
    
                                }
                                return value;
                            }// 조건문을 달아서 해당 사항이면 렌더링
                    },
                    { 
                        columnIndex : 7, key : "IS_OPEND", title : "열람 여부", align : "center", width : "30px" 
                    },
                    { 
                        columnIndex : 8, key : "RGST_DT", title : "보낸 날짜", align : "center", width : "30px" 
                    },
                    { 
                        columnIndex : 9, key : "FLAG", title : "수정여부확인", hidden:true 
                    }
                    
                ],
                on :{
        
                    perPageChange : function(arg1) {
                         _debug("<annceList> <grid.on.perPageChange> 페이지당개수 변경 : arg1 = " + arg1);//만약에 마지막 페이지가 7개면 7개만 들어감. 
                    }
                    ,
                    pageSet : function(pageNoToGo) {//페이지가변경되면 페이지 변경번호 
                        _debug("<annceList> <grid.on.perPageChange> 페이지번호 변경 : 변경할 페이지번호 = " + pageNoToGo);
                        var p = {};
                            p.page = pageNoToGo;
                        pSearchPhrs(p); //페이지 이동
                    },
                    'cell' : {
                        "dblclick" : function(data, eh, e) {
                            if(data._index.column != 0) {
                                var param = $("#searchTable").getData({selectOptions:true});
                                    param["ATCH_FILE_YN"]  = data.ATCH_FILE_YN;
                                    param["PAPER_ID"]      = data.PAPER_ID; // 다음페이지로 param 을 넘김 밑에 jsp 가 있음. 
                                    param["RCV_USER_NM"]      = data.RCV_USER_NM; // 다음페이지로 param 을 넘김 밑에 jsp 가 있음. 
                                    param["page"]      = $("#gridpaper").alopexGrid("pageInfo").customPaging.current;
                                    param["page_size"] = $("#gridpaper").alopexGrid("pageInfo").perPage;
                                $a.navigate("sndPaperDtl.jsp", param);
                            }
                        },
                        "click" : function(data, eh, e) {    //표준 : 더블클릭시 상세페이지로 이동함.
                        	if ( $.PSNMUtils.isMobile() ) {
	                            if(data._index.column != 0) {
	                                    var param = $("#searchTable").getData({selectOptions:true});
	                                        param["ATCH_FILE_YN"]  = data.ATCH_FILE_YN;
	                                        param["PAPER_ID"]      = data.PAPER_ID; // 다음페이지로 param 을 넘김 밑에 jsp 가 있음. 
	                                        param["RCV_USER_NM"]      = data.RCV_USER_NM; // 다음페이지로 param 을 넘김 밑에 jsp 가 있음. 
	                                        param["page"]      = $("#gridpaper").alopexGrid("pageInfo").customPaging.current;
	                                        param["page_size"] = $("#gridpaper").alopexGrid("pageInfo").perPage;
	                                    $a.navigate("sndPaperDtl.jsp", param);
	                            }
                        	}
                        },
                    }
                }
            });
        }
    });
    
    function pSearchPhrs(param) {
        var _page_no = 1;
        if ( $.PSNMUtils.isNotEmpty(param) && $.PSNMUtils.isNotEmpty(param.page) ) {
            _page_no = param.page; //(설명) 페이지 이동할때만 페이지번호가 넘어옴.
        }
        var _per_page = $('#gridpaper').alopexGrid('pageInfo').perPage; 
        
        $.alopex.request(_TX_SEARCH, { 
            data:["#searchForm", function(){
                this.data.dataSet.fields.page 	   = _page_no;
                this.data.dataSet.fields.page_size = _per_page;
            }],
            success: ['#gridpaper', function(res) {
                _debug("<pSearchMenu> <request.success> 결과데이터 : " + JSON.stringify(res));
            }]
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


        <!-- 1줄 find condition area -->
    <div id="searchDiv" class="textAR">
        <form id="searchForm" onsubmit="return false;">
            <table id="searchTable" class="board02" style="width:92%;">
	        	<colgroup>
		            <col style="width:10%"/>
		            <col style="width:15%"/>
		            <col style="width:10%"/>
		            <col style="width:20%"/>
		            <col style="width:10%"/>
		            <col style="width:*"/>
	            </colgroup>
                <tr>
                    <th style="width:100px;">검색조건</th>
                    <td class="tleft">
                        <select id="PAPER_COND_CD" data-bind="selectedOptions: PAPER_COND_CD" data-type="select" data-wrap="false" data-codeid="PAPER_COND_CD" style="width:120px;">
                            <option value="">-전체-</option>
                            <option value="01"> 받는사람 </option>
                            <option value="02"> 제목 </option>
                            <option value="03"> 내용 </option>
                        </select>
                    </td>
                    <th style="width: 100px;"> 검색어 </th>
                    <td class="tleft">
                        <input id="PAPER_COND_NM" name="PAPER_COND_NM" data-bind="value:PAPER_COND_NM" data-type="textinput" style="width:170px;" maxlength="10" />
                    </td>
                    <th>조회기간</th>
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
        </form>
        <p class="ab_pos5">
            <button type="button" id="btnSearch" data-type="button" data-theme="af-psnm" data-authtype="R" data-altname="조회"></button>
        </p>
    </div>
    <div class="floatL4">  <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>보낸쪽지</b>
    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<label><font color="red">보낸쪽지함에 있는 쪽지는 1달 이후 자동 삭제 됩니다.</font></label>
        <p class="ab_pos2">
            <button type="button" id="btnDel" data-type="button" data-theme="af-btn13" data-altname="삭제"></button>
        </p>
    </div>
    <!-- main grid -->
    <div id="gridpaper" data-bind="grid:gridpaper" data-ui="ds"></div>
</div>
    <jsp:include page="/view/layouts/default_footer.jsp" flush="false" />
</body>
</html>