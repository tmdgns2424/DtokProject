<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>우수 영업사례 - PS&Marketing</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />

    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/vendor/jquery.ui.widget.js"></script>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/jquery.iframe-transport.js"></script>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/jquery.fileupload.js"></script>
    
    <script type="text/javascript">
    var _initParam = null;

    $.alopex.page({
        init : function(id, param) { 
            _initParam = param;
            $a.page.setEventListener();
            $a.page.setGrid();
            $a.page.setFileUpload();

            search('list'); //조회
        },
        setEventListener : function() {
            $("#btnConfirm").click( closeWithout );
        }, //end-of-setEventListener
        setGrid : function() {
            //그리드 초기화
            $("#gridExcelSaleEx").alopexGrid({
                pager: false,
                rowSingleSelect: true,
                rowInlineEdit : true,
                columnMapping : [
                    { columnIndex : 0, key : "HDQT_PART_ORG_NM",      title : "본사파트",           align : "center",   width : "80px" },
                    { columnIndex : 1, key : "SALE_DEPT_ORG_NM",      title : "영업국명",           align : "center",   width : "80px" },
                    { columnIndex : 2, key : "SALE_TEAM_ORG_NM",      title : "영업팀명",           align : "center",   width : "80px" },
                    { columnIndex : 3, key : "AGNT_ID",               title : "에이전트코드",        align : "center",   width : "80px" },
                    { columnIndex : 4, key : "RPSTY_NM",              title : "직책명",             align : "center",   width : "80px" },
                    { columnIndex : 5, key : "AGNT_NM",               title : "에이전트명",          align : "center",   width : "80px" },
                    { columnIndex : 6, key : "DSM_FAX_UNIT_TYP_NM",   title : "상품유형",           align : "center",   width : "80px" },
                    { columnIndex : 7, key : "RGSTR_NM",              title : "작성자",             align : "center",   width : "80px" },
                    { columnIndex : 8, key : "RGST_DTM",              title : "작성일",             align : "center",   width : "80px" },
                ],
                on : {
                    "cell" : {
    					"click" : function(data, eh, e) {
							search("detail", data);
    					}
    				}
                }
            });
            $("#gridfile").alopexGrid({
                pager : false, //첨부파일 그리드는 페이징 처리하지 않음.
                columnMapping : [
                    { columnIndex : 0, key : "FILE_NM",      title : "파일명",       align : "left",   width : "600px" },
                    { columnIndex : 1, key : "FILE_SIZE",    title : "파일크기",     align : "center",  width : "100px" },
                    { columnIndex : 2, key : "ATCH_FILE_ID", title : "ATCH_FILE_ID", hidden : true },
                    { columnIndex : 3, key : "FILE_GRP_ID",  title : "FILE_GRP_ID",  hidden : true },
                    { columnIndex : 4, key : "FILE_PATH",    title : "FILE_PATH",    hidden : true }
                ],
                on : {
                    'cell' : {
                        "dblclick" : function(data, eh, e) {
                            console.log("<PSNMUtils.setFileUploadAndGrid> 더블클릭된 데이터 : " + data.ATCH_FILE_ID + "\n\n" + data["ATCH_SEQ"] + "\n\n" + $.PSNMUtils.toString(data));
                             $.PSNMUtils.download(data); //파일다운로드
                        }
                    }
                }
            });
        }, //end-of-setGrid
        setCodeData : function() {
            //
        },
        setFileUpload : function () {
        	//$.PSNMUtils.setFileUploadAndGrid("EXC", "", "#gridfile");
        }
    });//end-of-$.alopex.page //-------------------------------------------------------------------------------------------------------//

    function search(div, param) {
    	switch (div){
	    	case "list":
	            $.alopex.request('biz.SALEEX@PEXCELSALEEX001_pSearchExcelSaleEx', {
	                data: function() {
	                    var p = $.extend({}, this.data.dataSet.fields, _initParam);
	                    this.data.dataSet.fields = $.PSNMUtils.removeParamArrays(p);
	                    this.data.dataSet.fields.page      = "1";
	                    this.data.dataSet.fields.page_size = "100000";//모든데이타를 가져올수 있도록 충분한 수치를 기입
	                },
	                success: ['#gridExcelSaleEx', function(res) {
	                }]
	            });	    		
	    	break;
	    	case "detail":
	            $.alopex.request('biz.SALEEX@PEXCELSALEEX001_pDetailExcelSaleEx', {
	                data: function() {
	                    var p = $.extend({}, this.data.dataSet.fields, param);
	                    this.data.dataSet.fields = $.PSNMUtils.removeParamArrays(p);
	                },
	                success: function(res) {
	                	$("#EX_CTT").html(res.dataSet.fields.EXCEL_SALE_EX_CTT);
                    	var gridList = res.dataSet.recordSets;
    					
                        $.each(gridList, function(key, data) {
                        	$("#"+key).alopexGrid("dataSet", data.nc_list);
                        });
	                }
	            });	   	    		
	    	break;
    	}

    }

    function closeWithout() {
        $a.close();
    }
    </script>
</head>

<body>

<div id="Wrap">

    <!-- title area -->
    <div class="pop_header">
        <!--view_table area -->
        <div class="textAR">

            <div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>우수 엽업사례 내역</b>
                <p class="ab_pos2">
                </p>
            </div>

            <!-- main grid -->
            <div id="gridExcelSaleEx" data-bind="grid:grid"></div>
            
            <div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>상세내역</b>
                <p class="ab_pos2">
                </p>
            </div>
            <div class="textAR"> 
            	<div id="EX_CTT" name="EX_CTT" class="box-type01" style="height:150px; max-height:150px;"></div>
		  	</div>
            <div class="floatL4">
				<img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>첨부파일</b> : 하단 파일을 클릭하시면 저장 및 열기가 가능합니다.
		    	<div class="ab_pos1" style="float:right;">
		    	</div>
		  	</div>
			<div id="gridfile" class="view_list" data-bind="grid:gridfile"></div>
            <p class="floatL2">
                <input id="btnConfirm" type="button" value="" data-type="button" data-theme="af-btn8">
            </p>
        </div>

    </div>

</div>

</body>
</html>