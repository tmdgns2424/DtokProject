<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE HTML>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>영업국별/일별 접속현황</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />
    
    <script type="text/javascript">
    
    var _param;
    
    $.alopex.page({
        init : function(id, param) {
        	_param = param; //이 페이지로 전달된 파라미터를 저장
			
            $a.page.setEventListener();
            $a.page.setGrid();
            $a.page.setGridMapping(param);
        },
        setEventListener : function() {
        	$("#btnExcelPage").click(function(){
            	var oExcelMetaInfo = {
                        filename  : "영업국별일별접속현황.xls",
                        sheetname : "영업국별일별접속현황",
                        gridname  : "grid" //그리드ID 
                    };
            	
            	$.PSNMUtils.downloadExcelPage("grid", oExcelMetaInfo);
            });
            $("#btnConfirm").click(function(){
            	$a.close();
            });
        },
        setGrid : function() {
            $("#grid").alopexGrid({
                pager: false,
                rowSingleSelect : true,
                columnMapping : [
					{ columnIndex : 0, key : "", 		title : "",   		align : "center",   width : "100px" }
                ],
                on : {
                    "cell" : {
    					"click" : function(data, eh, e) {
    						
    						if( data._key == "YMD" ) { return; }
    						
    						data["DSM_SALES_PLCY_ID"] 	= _param.data.DSM_SALES_PLCY_ID;
    						data["SALE_DEPT_ORG_ID"] 	= data["ID"+data._index.column];
    						
    						$a.popup({
    		                    url: "biz/saleplcy/salePlcyContact",
    		                    data: data,
    		                    title : "영업정책 접속현황",
    		                    width: $.PSNM.popWidth(800),
    		                    height: $.PSNM.popHeight(400)
    		                });
    					}
    				}
                }
            });
        },
        setGridMapping : function(param) {
        	var hdqtPartOrgId = param.data != null ? param.data.RGST_OUT_ORG_ID : "";
        	var aplyStaDt = param.data != null ? param.data.APLY_STA_DT : "";
        	var columnArr = new Array();
        	$.alopex.request("biz.SALEPLCY@PSALESPLCY001_pSearchSalesPlcyStcDept", {
        		data: {dataSet: {fields: {HDQT_PART_ORG_ID : hdqtPartOrgId, APLY_STA_DT:aplyStaDt}}},
                success:  function(res) {
                	var colList = res.dataSet.recordSets.resultList.nc_list;

                	var saleOrgDeptIdArr = new Array();
                	var saleOrgDeptId = new Object();
                	
               		var col0 = new Object();
               		col0["columnIndex"] = 0;
               		col0["key"] = "YMD";
               		col0["title"] = "접속일";
               		col0["align"] = "center";
               		columnArr.push(col0);
               		var col1 = new Object();
               		col1["columnIndex"] = 1;
               		col1["key"] = "TOTAL";
               		col1["title"] = "합계";
               		col1["align"] = "center";
               		columnArr.push(col1);
                	$.each(colList, function (index, val) {
                		var obj = new Object();
                		obj["columnIndex"] = index + 2;
                		obj["key"] = "CNT" + parseInt(index + 2);
                		obj["idKey"] = "ID" + parseInt(index + 2);
                		obj["id"] = val.SALE_DEPT_ORG_ID;
                		obj["title"] = val.SALE_DEPT_ORG_NM;
                		obj["align"] = "center";
                		columnArr.push(obj);
                		
                		saleOrgDeptId = new Object();
                		saleOrgDeptId["id"] = val.SALE_DEPT_ORG_ID;
                		saleOrgDeptId["agntCnt"] = parseInt(val.SALE_DEPT_ORG_MBR_CNT);
                		saleOrgDeptIdArr.push(saleOrgDeptId);
                		//alert(saleOrgDeptIdArr[index]["id"] + " :::: " + saleOrgDeptIdArr[index]["agntCnt"]);
	                });
                	
                	$("#grid").alopexGrid('updateOption', {
                    	columnMapping : columnArr
                    });
                	$a.page.setViewData(param, columnArr, hdqtPartOrgId, saleOrgDeptIdArr);
                }
            });
        },
        setViewData : function(param, columnArr, hdqtPartOrgId, saleOrgDeptIdArr) {
        	var id = param.data != null ? param.data.DSM_SALES_PLCY_ID : "";
        	$.alopex.request("biz.SALEPLCY@PSALESPLCY001_pSearchSalesPlcyStc", {
        		data: {dataSet: {fields: {DSM_SALES_PLCY_ID : id, HDQT_PART_ORG_ID : hdqtPartOrgId}}},
                success: function(res) {
                	var codeList = res.dataSet.recordSets.grid.nc_list;
                	var dataList = new Array();
               		var cnt = 0;
               		var total = 0;
               		var totalCnt = 0;
               		
               		$.each(codeList, function (index, val) {
               			var obj = new Object();
               			
               			var idArr = val.SALE_DEPT_ORG_ID.split(",");
               			
               			if(val.YMD == ""){
               				obj["YMD"] = "합계";
               			}else{
	               			obj["YMD"] = val.YMD;
               			}
               			
               			for(i = 2; i<columnArr.length; i++){
                       		var colinfo = $("#grid").alopexGrid("columnInfo", i);
                       		for(j=0; j<idArr.length; j++){
                       			if(colinfo.id == idArr[j]){
                       				cnt = cnt + 1;
                       			}
                       		}
                       		obj["ID"+i] = colinfo.id;
                       		if(val.YMD == ""){
                       			for (j=0; j<saleOrgDeptIdArr.length;j++){
                       				if (colinfo.id == saleOrgDeptIdArr[j]["id"]){
                       					obj["CNT"+i] = cnt + "/" + saleOrgDeptIdArr[j]["agntCnt"];
                      				}
                       			}
                       		} else {
                        			obj["CNT"+i] = cnt;	
                      		}
                       		
                       		total = total + cnt;
                       		cnt = 0;
               			}
               			
               			if(val.YMD == ""){
               				for (i=0; i<saleOrgDeptIdArr.length;i++){
               					totalCnt = totalCnt + saleOrgDeptIdArr[i]["agntCnt"];
               				}
               				
               				obj["TOTAL"] = total + "/" + totalCnt;
               			} else {
               				obj["TOTAL"] = total;
               			}
               			
               			//obj["TOTAL"] = total + "/" + totalCnt;
               			total = 0;
               			
               			obj["align"] = "center";
               			dataList.push(obj);
               		});
                	
                	$("#grid").alopexGrid("dataSet", dataList);
                }
            });
        }
    });

    </script>
</head>
<body>

<div id="contents">

    <!-- title area -->
    <div class="pop_header">
      
        <!--view_table area -->
        <div class="textAR">

            <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>영업국별/일별 접속현황</b>
                <p class="ab_pos2">
                	<button id="btnExcelPage" type="button" data-type="button" data-theme="af-btn3" data-altname="엑셀다운"></button>
                </p>
            </div>

            <!-- main grid -->
            <div id="grid" data-bind="grid:grid"></div>

            <p class="floatL2">
                <input id="btnConfirm" type="button" data-type="button" data-theme="af-btn8">
            </p>
        </div>
        
        <div id="footer-hidden-area" style="display:none;">
    		<iframe id="footer-hidden-iframe" src="" width="90%;" height="50"></iframe>
		</div>

    </div>

</div>

</body>
</html>