<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />

    <script type="text/javascript">
    var _TX_SAVE    = "com.USERSTRCT@PUSERSTRCT001_pSaveUseRstrctMgmt";
    var arrs             =           new Array();
    $.alopex.page({
        init : function(id, param) { 
            //$.PSNM.initialize(id, param); //PSNM공통 초기화함수 호출
            
            $a.page.setEventListener();
            $a.page.setGrid(); 
            $a.page.setCode();
            $a.page.setDate();
            $a.page.setCodeData();
        },
        setEventListener : function() {
            $("#btnSearch").click($a.page.searchList);
            $("#btnSave").click( saveUseRstrctMgmt);
        },
        setGrid : function() {
            $("#grid").alopexGrid({
                rowClickSelect : false,
                rowInlineEdit : true,
                pager : false,

                columnMapping : [
                    { columnIndex : 0, key : "FLAG",                        title : "F",            align : "center",   width : "5px",
                        value : function(value, data) {
                            return ( (data._state.edited) ? 'U' : '' ); 
                        }
                    } ,
                    { columnIndex : 1, key : "DOW_NM",                      title : "요일",         align : "center",   width : "10px"  } ,
                    { columnIndex : 2, key : "HDQT_TEAM_ORG_NM",            title : "본사팀",       align : "center",   width : "25px"  } ,                    
                    { columnIndex : 3, key : "HDQT_PART_ORG_NM",            title : "본사파트",     align : "center",   width : "25px"  } ,
                    { columnIndex : 4, key : "APLY_YN",                     title : "적용여부",     align : "center",   width : "18px", 
                        render : function(value, data) {
                            return ("Y"==value ? "사용" : "미사용");
                        },
                        editable : { 
                            type : "select", 
                            rule : function(value, data) {
                                var ar = [];
                                ar.push({"text":"Y","value":"Y"});
                                ar.push({"text":"N","value":"N"});
                                return ar;
                            }
                        } 
                    } ,
                    { columnIndex : 5, key : "APLY_STA_H",                  title : "시작 시",         align : "center",   width : "10px",
                        editable : { 
                            type : "select", 
                            rule : function(value, data) {
                                var data = [];
                                $("#CNSL_STA_T option").each(function() {
                                    var oOption = new Object();
                                    oOption["value"] = $(this).val();
                                    oOption["text"] = $(this).text();
                                    data.push(oOption);
                                });
                                return data ;
                            }
                        }
                    } ,       
                    { columnIndex : 6, key : ":",            title : "",     align : "center",   width : "5px" ,
                    	 value : function(value, data) {
                             return ':'; 
                         }
                    } ,
                    { columnIndex : 7, key : "APLY_STA_M",                  title : "시작 분",         align : "center",   width : "10px" ,
                        editable : { 
                            type : "select", 
                            rule : function(value, data) {
                                var ar = [];
                                ar.push({"text":"00","value":"00"});
                                ar.push({"text":"10","value":"10"});
                                ar.push({"text":"20","value":"20"});
                                ar.push({"text":"30","value":"30"});
                                ar.push({"text":"40","value":"40"});
                                ar.push({"text":"50","value":"50"});
                                return ar;
                            }
                        }
                    } , 
                    { columnIndex : 8, key : "~",            title : "",     align : "center",   width : "5px" ,
                   	 value : function(value, data) {
                            return '~'; 
                        }
                   } ,
                    { columnIndex : 9, key : "APLY_END_H",                  title : "종료 시",         align : "center",   width : "10px",
                        editable : { 
                             type : "select", 
                             rule : function(value, data) {
                                var data = [];
                                $("#CNSL_END_T option").each(function() {
                                    var oOption = new Object();
                                    oOption["value"] = $(this).val();
                                    oOption["text"] = $(this).text();
                                    data.push(oOption);
                                });
                                return data ;
                             }
                         }
                    } ,
                    { columnIndex : 10, key : ":",            title : "",     align : "center",   width : "5px" ,
                   	 value : function(value, data) {
                            return ':'; 
                        }
                   } ,
                    { columnIndex : 11, key : "APLY_END_M",                  title : "종료 분",         align : "center",   width : "10px" ,
                        editable : { 
                            type : "select", 
                            rule : function(value, data) {
                                var ar = [];
                                ar.push({"text":"00","value":"00"});
                                ar.push({"text":"10","value":"10"});
                                ar.push({"text":"20","value":"20"});
                                ar.push({"text":"30","value":"30"});
                                ar.push({"text":"40","value":"40"});
                                ar.push({"text":"50","value":"50"});
                                return ar;
                            }
                        }
                    } ,
                ],
                on : {
                    data : {
                        "changed" : function(type, arg2) {
                            _debug("grid.data.changed", "change type", type);
                        }
                        ,
                        "edit" : function(data, query) {
                            _debug("grid.data.edit", JSON.stringify(data), JSON.stringify(query));
                        }
                    }
                }
            });
        },
        setCode : function() {
            $.alopex.request("com.USERSTRCT@PUSERSTRCT001_pSearchDay", {
                success : function(res) {

                var codeList = res.dataSet.recordSets.resultList.nc_list;
                    var codeOptions = [];
                    codeOptions.push({ value: "", text: "-선택-"});

                    $.each(codeList, function (index, codeinfo) {
                        var codeOpt = new Object();
                            codeOpt["value"] = codeinfo.DOW_CL;
                            codeOpt["text"]  = codeinfo.DOW_NM;
                            codeOptions.push(codeOpt);
                    });
                    var optData = new Object();
                        optData["options_DOW_CL"] = codeOptions;

                        $("#DOW_CL").setData(optData);
                }
            });
        },
        setDate : function() {
            $.alopex.request("com.USERSTRCT@PUSERSTRCT001_pSearchToDay", {
                success : function(res) {
                    var ToDay = res.dataSet.fields.DOW_CL;
                    $("#DOW_CL").val(ToDay);
                    $a.page.searchList();
                }
            });
        },
        searchList: function(param) {
        	
            $.alopex.request("com.USERSTRCT@PUSERSTRCT001_pSearchUseRstrctMgmt", {
                data: ["#searchTable",function (){
                }],
                success: "#grid"
            });
        },
        setCodeData : function() {
            $.PSNMUtils.setCodeData([
                    { t:'code', 'elemid' : 'CNSL_STA_T', 	'codeid' : 'DSM_TM_CD' },     			
                    { t:'code', 'elemid' : 'CNSL_END_T', 	'codeid' : 'DSM_TM_CD' },     			
            ]);
        },
    });  

    function saveUseRstrctMgmt(e) {
        $("#grid").alopexGrid("endEdit");
        
        var updatedDataListRaw = $("#grid").alopexGrid("dataGet", {_state:{edited:true}});
        var updatedDataList = AlopexGrid.trimData( updatedDataListRaw );
        var updatedDataCount = updatedDataList.length;

        if ( updatedDataCount<1 ) {
            var r = $.PSNM.alert("E011", ["변경된"], false); //alert("변경된 데이터가 없습니다."); return false;
            return r;
        }
        _debug("saveMenu", "갱신된 건수", updatedDataCount);
			
        for(var i=0; i<updatedDataCount; i++) {
            var menuData = updatedDataListRaw[i];
            _debug("saveMenu", "갱신된 메뉴레코드", JSON.stringify(menuData));
            var r = true;
            
            var sta = (menuData["APLY_STA_H"]+menuData["APLY_STA_M"]);
			var end = (menuData["APLY_END_H"]+menuData["APLY_END_M"]);
			
			if(sta>end){
				r = $.PSNM.alert("시작시간이 종료시간보다 클수 없습니다. \n 종료시간을 다시 입력해 주세요." ,false); 
			}
			if(sta==end){
				r = $.PSNM.alert("시작시간과 종료시간이 같을 수 없습니다. \n 종료시간을 다시 입력해 주세요." ,false); 
			}
 			if (!r) {
                var oThatRow = {_index:{data:menuData._index.row}};
                $("#grid").alopexGrid("dataEdit", {_state:{selected:true}}, oThatRow); //해당 행 선택
                $("#grid").alopexGrid("startEdit", oThatRow); //편집 시작
                return r;
            }
        }
        var updatedDataSet = $.PSNMUtils.getRequestDataUpdated("grid"); //변경된 데이터만 파라미터로 전달

        $.alopex.request(_TX_SAVE, {
            data: updatedDataSet,
            success: function(res) {
                $.PSNM.alert("I000"); //정상적으로 처리되었습니다.
                $a.page.searchList();
            }
        });
    }
    
    </script>
    
</head>
<body>
<div id="contents">

    <!-- title area -->
    <div class="pop_header">
     <div class="psnm-find-area" style="height:40px;">
        <form id="searchForm">
          <div class="psnm-find-condarea">
            <table id="searchTable" class="board02" style="width:92%;">
            <colgroup>
                <col style=""/>
                <col style="*"/>
                <col style=""/>
                <col style="*"/>
            </colgroup>
            <tbody>
            <tr>
                <th scope="col"class="fontred" style="width:80px">요일</th>
                <td class="tleft">
                    <select id="DOW_CL" data-bind="options: options_DOW_CL, selectedOptions: DOW_CL" data-type="select"></select>
                </td>
                <td  style="display:none" >
                    <select id="CNSL_STA_T" name="CNSL_STA_T" data-type="select" style="width:50px;"
                        data-bind="options: options_CNSL_STA_T, selectedOptions: CNSL_STA_T">
                    </select>
                    <select id="CNSL_END_T" name="CNSL_END_T" data-type="select" style="width:50px;"
                        data-bind="options: options_CNSL_END_T, selectedOptions: CNSL_END_T">
                    </select>
                </td>
            </tr>
            </tbody>
            </table>
            </div>
        </form>
   	   
 	<div class="psnm-find-btnarea">
            <button id="btnSearch" data-type="button" data-theme="af-psnm" data-authtype="R"></button>
        </div>
       </div>
       <div class="textAR">
     <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>사용제한관리</b>
        <p class="ab_btn_right">
            <button id="btnSave" data-type="button" data-theme="af-btn4" data-altname="저장" data-authtype="R"></button>
        </p>
    </div>


    <!-- main grid -->

    	<div id="grid" data-bind="grid:grid"></div>
</div>
</div>
    </div>
</body>
</html>