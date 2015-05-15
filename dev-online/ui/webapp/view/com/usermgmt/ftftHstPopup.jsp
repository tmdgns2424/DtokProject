<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>활동경력 - PS&Marketing</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />


    <script type="text/javascript">
    var _initParam = null;

    $.alopex.page({
        init : function(id, param) { 
            _initParam = param;
            $a.page.setEventListener();
            $a.page.setGrid();

            searchList(); //조회
        },
        setEventListener : function() {
            $("#btnConfirm").click( closeWithout );
        }, //end-of-setEventListener
        setGrid : function() {
            //그리드 초기화
            $("#gridFtftHst").alopexGrid({
                pager: false,
                rowSingleSelect: true,
                height : "350px",
                columnMapping : [
                     { columnIndex : 0, key : "CNSL_DT",       title : "면담일자",                align : "center",   width : "80px" },
                     { columnIndex : 1, key : "CNSLR_ID",      title : "면담자ID",               align : "center",   width : "80px" },
                     { columnIndex : 2, key : "CNSLR_NM",      title : "면담자명",                align : "center",   width : "80px" },
                     { columnIndex : 3, key : "RPSTY_NM",      title : "면담자직책명",              align : "center",   width : "80px" },
                     { columnIndex : 4, key : "CNSL_RSN_CD",   title : "면담유형",               align : "center",   width : "80px"
                         , render : {
     				          type : "string",
        					      rule : function() {
   								            var oParam = { t:'code', 'codeid' : 'DSM_CNSL_RSN_CD' };	
   								        	return $.PSNMUtils.getCode(oParam);
                                        }
         			        }
                     },
                     { columnIndex : 5, key : "CNSL_CTT",      hidden: true }
                ]
	            ,on : {
	                "cell" : {
	    				"click" : function(data, eh, e) {
							$("#CNSL_CTT").setData( data );
	    				}
	    			}
	            },
            });
        },
        setCodeData : function() {
            //
        }
    });//end-of-$.alopex.page //-------------------------------------------------------------------------------------------------------//

    //조회 처리 : param은 페이지 이동시에만 값이 전달됨
    function searchList(param) {
        $.alopex.request('com.USERMGMT@PUSERMGMT001_pSearchFtftHst', {
            data: function() {
                var p = $.extend({}, this.data.dataSet.fields, _initParam);
                this.data.dataSet.fields = $.PSNMUtils.removeParamArrays(p);
            },
            success: ['#gridFtftHst', function(res) {
            }]
        });
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

            <!-- main grid -->
            <div class="psnm-section">
		        <div class="psnm-secleft">
		            <div class="floatL4" style="clear:both;"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>면담이력</b>
				    </div>
		            <div id="gridFtftHst" data-bind="grid:gridFtftHst"></div>
		        </div>
		        <div class="psnm-secright">
		            <div class="floatL4" style="clear:both;"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>면담내용</b>
				    </div>
				    <textarea id="CNSL_CTT" name="CNSL_CTT" data-type="textarea" data-bind="value:CNSL_CTT" data-disabled="true" style="position:absolute; top:42px; width:415px; height:330px" data-theme="af-textarea"></textarea>
		        </div>
		    </div>

            <p class="floatL2">
                <input id="btnConfirm" type="button" value="" data-type="button" data-theme="af-btn8">
            </p>

    </div>

</div>

</body>
</html>