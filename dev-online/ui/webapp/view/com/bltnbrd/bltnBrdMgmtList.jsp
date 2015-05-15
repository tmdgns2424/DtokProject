<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
    String _ROOT = "";
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

    <jsp:include page="/view/layouts/default_head.jsp" flush="false" />

    <script type="text/javascript">
    _LOG_LEVEL = 0; //로그레벨 :: 0=debug, 1=info, 2=error

    var _TX_SEARCH_BY_TYP = "com.BLTNBRD@PBLTNBRDMGMT001_pSearchBltnBrdByType";
    var _TX_SEARCH_BY_SUP = "com.BLTNBRD@PBLTNBRDMGMT001_pSearchBltnBrdBySup";
    var _TX_SEARCH        = "com.BLTNBRD@PBLTNBRDMGMT001_pSearchBltnBrd";
    var _TX_SEARCH1       = "com.BLTNBRD@PBLTNBRDMGMT001_pSearchBltnBrdByPk";
    var _TX_SEARCH_CHRGR  = "com.BLTNBRD@PBLTNBRDMGMT001_pSearchBltnBrdChrgr";
    var _TX_SAVE          = "com.BLTNBRD@PBLTNBRDMGMT001_pSaveBltnBrd";

    var _is_bltnbrd_grid_row_selected = false; //게시판 그리드의 한 행이 '선택'되면 true, '선택해제' 되면 false
    var _idx_bltnbrd_grid_row_selected = -1; //현재 선택된 게시판 그리드의 행 index(없으면 -1)

    $.alopex.page({
        init : function(id, param) { 
            $.PSNM.initialize(id, param); //PSNM공통 초기화함수 호출(서브 페이지에서는 필수 호출)

            $a.page.setCodeData();
            $a.page.setEventListener();
            $a.page.setGrid();
            $a.page.setGrid2();

            $('#sform').setData(param); //(설명) 상세페이지에서 돌아오는 경우, 이 값들이 세션스토리지에서 반환됨.

            $("#TOP_BLTN_BRD_ID").focus();
            $('#divbltnbrd select').parent('div').css("width", "60px");
        },
        setEventListener : function() {
            $("#btnSearch").click( pSearchBltnBrd );
            $("#btnAdd").click( addBltnBrd );
            $("#btnDel").click( delBltnBrd );
            $("#btnAddChrgr").click( addBltnBrdChrgr );
            $("#btnDelChrgr").click( delBltnBrdChrgr );
            $("#btnSave").click( pSaveBltnBrd );
            $("#btnExcelAll").click( downloadExcel );
            $("#TOP_BLTN_BRD_ID").change( pSearchBltnBrdBySup );

            $("#divbltnbrd input").change( onchangeBltnBrdData );
            $("#divbltnbrd select").change( onchangeBltnBrdData );
        },
        setGrid : function() {
            $("#gridbltnbrd").alopexGrid({
                height: 400,
                pager:false,
                rowSingleSelect: true,
                //rowInlineEdit  : true, //더블클릭을 이용하여 행을 편집모드로 바꿀 수 있도록 해주는 옵션.
                columnMapping : [
                    { columnIndex : 0, key : "FLAG",        title : "F",        align : "center", width : "30px", refreshBy:true, 
                                        value : function(value, data) {
                                            _debug("gridbltnbrd.columnMapping.FLAG", "##value = " + value, "##data = " + data);
                                            if ( "I"==value || "D"==value ) { return value; } //추가|삭제는 그냥둠
                                            return ( (data._state.edited) ? 'U' : '' ); 
                                        }
                    },
                    { columnIndex : 1, selectorColumn : true,    width : "30px" },
                    { columnIndex : 2, key : "BLTN_BRD_TYP_CD", title : "구분",     width : "80px",
                                        render : function(value, data) {
                                            //_debug("그리드렌더", value, JSON.stringify(data));
                                            if ( 1==value ) {
                                                return '<img src="${pageContext.request.contextPath}/image/blat_a15_a.gif">';
                                            } else if ( 2==value ) {
                                                return '　　<img src="${pageContext.request.contextPath}/image/blat_a15_b.gif">';
                                            } else if ( 3==value ) {
                                                return '　　　　<img src="${pageContext.request.contextPath}/image/blat_a25.gif">';
                                            }
                                        }
                    },
                    { columnIndex : 3, key : "BLTN_BRD_TYP_NM", title : "게시판유형",       align : "center", width : "90px"  },
                    { columnIndex : 4, key : "BLTN_BRD_ID",     title : "게시판ID",         align : "center", width : "70px"  },
                    { columnIndex : 5, key : "BLTN_BRD_NM",     title : "게시판명",         align : "left",   width : "200px" },
                    { columnIndex : 6, key : "BRWS_SEQ",        title : "조회순서",         align : "center", width : "70px"  },
                    { columnIndex : 7, key : "USE_YN",          title : "사용여부",         align : "center", width : "70px"  },
                    { columnIndex : 8, key : "SCRT_NUM_SET_YN", title : "비밀번호설정",     align : "center", width : "90px"  },
                    { columnIndex : 9, key : "RCMND_OBJ_YN",    title : "추천기능사용",     align : "center", width : "90px"  },
                    { columnIndex :10, key : "ADD_FILE_YN",     title : "첨부파일",         align : "center", width : "70px"  },
                    { columnIndex :11, key : "SMS_RCV_YN",      title : "SMS수신",          align : "center", width : "70px"  },
                    { columnIndex :12, key : "ANM_TYP_NM",      title : "작성자유형",       align : "center", width : "80px"  },
                    { columnIndex :13, key : "SRCH_PRD_NM",     title : "조회기간",         align : "center", width : "70px"  },
                    { columnIndex :14, key : "SRCH_PRD_CHG_YN", title : "조회기간변경가능", align : "center", width : "120px" },
                    { columnIndex :15, key : "BLT_DTM_YN",      title : "게시일시",         align : "center", width : "70px"  },
                    { columnIndex :16, key : "AUTH_YN",         title : "권한설정",         align : "center", width : "70px"  },
                    { columnIndex :17, key : "UPDR_NM",         title : "최종수정자",       align : "center", width : "80px"  },
                    { columnIndex :18, key : "UPD_YMD",         title : "최종수정일",       align : "center", width : "80px"  },
                    { columnIndex :19, key : "SUP_BLTN_BRD_ID", title : "상위게시판ID",     hidden:true },
                    { columnIndex :20, key : "BLTCONT_CNT",     title : "BLTCONT_CNT",      hidden:true },
                    { columnIndex :21, key : "SUB_BLTN_BRD_CNT",title : "SUB_BLTN_BRD_CNT", hidden:true }
                ]
                ,
                on : {
                    'cell' : {
                        "click" : function(data, eh, e) {
                            //alert("\n\n- eh :" + eh + "\n\n- e :" + e + "\n\n- data :" + JSON.stringify(data));
                            if ( true === _is_bltnbrd_grid_row_selected ) { //게시판 그리드의 한 행이 '선택'되면 true, '선택해제' 되면 false
                                if ( isBbsDataChanged() ) {
                                    if ( $.PSNM.confirm("I005", ["변경", "먼저 저장"]) ) { //"{0}된 데이터가 있습니다. {1} 하시겠습니까?"
                                        pSaveBltnBrd();
                                        return;
                                    }
                                }
                            
                                _idx_bltnbrd_grid_row_selected = data._index.data;
                                pSearchBltnBrdByPk( AlopexGrid.trimData(data) );
                            }
                            else {
                                _idx_bltnbrd_grid_row_selected = -1;
                                $("#dform input").val('');
                                $("#dform select").val('');
                                $("#gridchrgr").alopexGrid('dataEmpty');
                            }
                        }
                    }
                    ,
                    data : {
                        "changed" : function(type, arg2) {
                            _debug("gridbltnbrd.data.changed", "change type", type);
                        }
                        ,
                        "edit" : function(data, query) {
                            _debug("gridbltnbrd.data.edit", JSON.stringify(data), JSON.stringify(query));
                        }
                        ,
                        "select" : function(data, selected) {
                            _is_bltnbrd_grid_row_selected = selected; //게시판 그리드의 한 행이 '선택'되면 true, '선택해제' 되면 false
                            //if ( $.PSNMUtils.isGridDataRowAdded('#gridchrgr') || $.PSNMUtils.isGridDataRowDeleted('#gridchrgr') ) {
                            //    var isConfirmed = $.PSNM.confirm("I005", ["변경 담당자목록", "게시판을 선택"]);
                            //    return isConfirmed;
                            //}
                            //return true;
                        }
                        //,
                        //"selected" : function(datalist, selected) {
                        //    pSearchBltnBrdByPk(datalist[0]);
                        //}
                    }
                }
            });
        },
        setGrid2 : function() {
            $("#gridchrgr").alopexGrid({
                height: 150,
                pager:false,
                //rowSingleSelect: true,
                //rowInlineEdit  : false,
                columnMapping : [ //
                    { columnIndex : 0, key : "FLAG",            title : "F",        align : "center", width : "30px",
                                        refreshBy:true, 
                                        value : function(value, data) {
                                            if (data._state.added) return 'I';
                                            if (data._state.deleted) return 'D';
                                            //if (data._state.edited) return 'U';
                                            return ''; 
                                        }
                    },
                    { columnIndex : 1, selectorColumn : true,    width : "30px" },
                    { columnIndex : 2, key : "HDQT_TEAM_ORG_NM", title : "본사팀",       align : "center", width : "150px" },
                    { columnIndex : 3, key : "HDQT_PART_ORG_NM", title : "본사파트",     align : "center", width : "150px" },
                    { columnIndex : 4, key : "SALE_DEPT_ORG_NM", title : "영업국명",       align : "left",   width : "150px" },
                    { columnIndex : 5, key : "SALE_TEAM_ORG_NM", title : "영업팀명",       align : "center", width : "150px" },
                    { columnIndex : 6, key : "CHRGR_ID",         title : "수신자코드",   align : "center", width : "150px" },
                    { columnIndex : 7, key : "RPSTY_NM",         title : "직책명",       align : "center", width : "150px" },
                    { columnIndex : 8, key : "USER_NM",          title : "수신자명",     align : "center", width : "150px" }
                ]
            });
        }
        ,
        setCodeData : function() {
            $.PSNMUtils.setCodeData([
                { t:'code', 'elemid' : 'ANM_TYP_CD',      'codeid' : 'DSM_ANM_TYP_CD',       'header' : '-선택-' } //DSM작성자유형코드
               ,{ t:'code', 'elemid' : 'BLTN_BRD_TYP_CD', 'codeid' : 'DSM_BLTN_BRD_TYP_CD',  'header' : '-선택-' } //DSM게시판유형코드
               ,{ t:'code', 'elemid' : 'SRCH_PRD_CD',     'codeid' : 'DSM_BLTN_BRWS_PRD_CD', 'header' : '-선택-' } //DSM게시판조회기간코드
            ]);
            pSearchBltnBrdBySup();

            /*$.alopex.request(_TX_SEARCH_BY_TYP, {
                showProgress:false,
                async:false, //공통코드 조회는 sync로 조회함
                data: {
                    dataSet: { fields : { "BLTN_BRD_TYP_CD" : "1" } } //대그룹 게시판유형 목록
                },
                success: function(res) {
                    var bltnBrdMgmtList = res.dataSet.recordSets["gridbltnbrdtype"].nc_list;

                    var codeOptions = [];
                        codeOptions.push({ value: "", text: "-선택-"});

                    $.each(bltnBrdMgmtList, function (index, codeinfo) {
                        var codeOpt = new Object();
                            codeOpt["value"] = codeinfo.BLTN_BRD_ID;
                            codeOpt["text"]  = codeinfo.BLTN_BRD_NM;
                        codeOptions.push(codeOpt);
                    });
                    var optData = new Object();
                        optData["options_TOP_BLTN_BRD_ID"] = codeOptions;

                    $("#TOP_BLTN_BRD_ID").setData(optData);
                }
            });
            */
        }
    });//end-of-$.alopex.page //-------------------------------------------------------------------------------------------------------//

    function pSearchBltnBrdBySup(e) {
        var supBltnBrdId = '0000';
        if ( null!=e && 'TOP_BLTN_BRD_ID'==e.target.id) {
            supBltnBrdId = $('#TOP_BLTN_BRD_ID').val();
            if ( $.PSNMUtils.isEmpty( supBltnBrdId ) ) {
                $('#MID_BLTN_BRD_ID').html('<option value="">-전체-</option>');
                return;
            }
        }
        
        $.alopex.request(_TX_SEARCH_BY_SUP, {
            showProgress:false,
            async:false,
            data: {
                dataSet: { fields : { "SUP_BLTN_BRD_ID" : supBltnBrdId } }
            },
            success: function(res) {
                var bltnBrdMgmtList = res.dataSet.recordSets["gridbltnbrdsup"].nc_list;

                var codeOptions = [];
                if ( '0000'==supBltnBrdId ) {
                    codeOptions.push({ value: "", text: "-선택-"});
                }
                else {
                    codeOptions.push({ value: "", text: "-전체-"});
                }

                $.each(bltnBrdMgmtList, function (index, codeinfo) {
                    var codeOpt = new Object();
                        codeOpt["value"] = codeinfo.BLTN_BRD_ID;
                        codeOpt["text"]  = codeinfo.BLTN_BRD_NM;
                    codeOptions.push(codeOpt);
                });
                var optData = new Object();
                
                if ( '0000'==supBltnBrdId ) {
                    optData["options_TOP_BLTN_BRD_ID"] = codeOptions;
                    $("#TOP_BLTN_BRD_ID").setData(optData);
                }
                else {
                    optData["options_MID_BLTN_BRD_ID"] = codeOptions;
                    $("#MID_BLTN_BRD_ID").setData(optData);
                }
            }
        });
    }

    //게시판목록조회(TREE)
    function pSearchBltnBrd(bForceSearch) {
        if ( !$.PSNM.isValid('#sform') ) {
            return false;
        }
        if ( $.PSNMUtils.isEmpty(bForceSearch) || true!==bForceSearch ) {
            if ( $.PSNMUtils.isGridDataChanged('#gridbltnbrd') && !$.PSNM.confirm("I005", ["변경", "조회"]) ) {
                return false;
            }
        }
        $('#divbltnbrd-title').hide();
        $('#divbltnbrd').hide();
        $('#divchrgr').hide();
        $('#gridchrgr').hide();
        $("#gridbltnbrd").alopexGrid('dataEmpty');
        $("#gridchrgr").alopexGrid('dataEmpty');

        $.alopex.request(_TX_SEARCH, {
            data: ['#sform', function() {
                //this.data.dataSet.fields["BLTN_BRD_ID"] = this.data.dataSet.fields.TOP_BLTN_BRD_ID;
                //_debug("<pSearchBltnBrd> <request.data> 파라미터 (this.data.dataSet.fields) : " + JSON.stringify(this.data.dataSet.fields));
            }],
            success: ['#gridbltnbrd', function(res) {
                //_debug("<pSearchBltnBrd> <request.success> 결과데이터 : " + JSON.stringify(res));
            }]
        });
    }
    function pSearchBltnBrdForcely() {
        if ( !$.PSNM.isValid('#sform') ) {
            return false;
        }
        $('#divbltnbrd-title').hide();
        $('#divbltnbrd').hide();
        $('#divchrgr').hide();
        $('#gridchrgr').hide();
        $("#gridbltnbrd").alopexGrid('dataEmpty');
        $("#gridchrgr").alopexGrid('dataEmpty');

        $.alopex.request(_TX_SEARCH, {
            data: '#sform',
            success: '#gridbltnbrd'
        });
    }

    //게시판1건조회
    function pSearchBltnBrdByPk(oData) {
        if (null!=oData) {
            oData = AlopexGrid.trimData( oData )
        }

        $('#divbltnbrd').setData(oData);
        $('#gridchrgr').alopexGrid('dataEmpty');

        $('#divbltnbrd-title').show();
        $('#divbltnbrd').show();
        $('#BLTN_BRD_TYP_CD').setEnabled(false);
        $('#BLTN_BRD_ID').setEnabled(false);

        var sBltnBrdTypCd = oData["BLTN_BRD_TYP_CD"];
        if ( "3"==sBltnBrdTypCd ) {
            $("#th_ADD_FILE_YN").addClass("psnm-required");
            $("#th_ANM_TYP_CD").addClass("psnm-required");
        }
        else {
            $("#th_ADD_FILE_YN").removeClass("psnm-required");
            $("#th_ANM_TYP_CD").removeClass("psnm-required");
        }
        
        $('#divchrgr').show();
        $('#gridchrgr').show();

        $.alopex.request(_TX_SEARCH_CHRGR, {
            showProgress: false,
            data: function() {
                this.data.dataSet.fields = oData;
            },
            success: ['#gridchrgr', function(res) {
                //alert( JSON.stringify(res.dataSet.recordSets.gridchrgr) );
            }]
        });
    }

    function addBltnBrd(e) {
        var arrSelBltnBrd = $("#gridbltnbrd").alopexGrid("dataGet", {_state:{selected:true}}); //선택된 데이터(배열구조)
        var oSelBltnBrd   = (arrSelBltnBrd.length<1 ? null : arrSelBltnBrd[0]); //선택된 게시판정보

        if ( null!=oSelBltnBrd && "3"==oSelBltnBrd["BLTN_BRD_TYP_CD"] ) { //1=대그룹, 2=중그룹, 3=게시판
            $.PSNM.alert("대그룹이나 중그룹을 선택하십시오.");
            return;
        }

        if (arrSelBltnBrd.length<1) {
            if ( confirm('대그룹으로 추가하시겠습니까?') ) {
                var arrTopBltnBrd = $("#gridbltnbrd").alopexGrid("dataGet", {"BLTN_BRD_TYP_CD":"1"});
                var maxBrwsSeq = 1;
                $.each(arrTopBltnBrd, function(index, topBltnBrd) {
                    var topBltnBrdBrwsSeq = topBltnBrd["BRWS_SEQ"];
                    if (maxBrwsSeq<parseInt(topBltnBrdBrwsSeq)) {
                        maxBrwsSeq = parseInt(topBltnBrdBrwsSeq);
                    }
                });

                var newData = {
                    "FLAG"            : "I",
                    "BLTN_BRD_TYP_CD" : "1", //<img src='${pageContext.request.contextPath}/image/blat_a15_a.gif'>
                    "BLTN_BRD_TYP_NM" : "대그룹",
                    "BRWS_SEQ"        : "" + (1+maxBrwsSeq),
                    "SUP_BLTN_BRD_ID" : "0000",
                    "USE_YN"          : "Y",
                    "UPDR_NM"         : $.PSNM.getSession("USER_NM"),
                    "UPD_YMD"         : ""
                };

                $("#gridbltnbrd").alopexGrid("dataAdd", newData);
                var rowCount = $("#gridbltnbrd").alopexGrid("dataGet").length;
                var rowIndex = rowCount-1;

                $("#gridbltnbrd").alopexGrid("dataEdit", {_state:{selected:true}}, {_index:{data:rowIndex}});
                $("#gridbltnbrd").alopexGrid("dataScroll", rowIndex); //스크롤
                setDetailFormData(newData); //행을 추가한후 dform의 데이터를 초기화해야 grid-data 가 꼬이지 않음
            }
        }
        else if (arrSelBltnBrd.length==1) {
            var bltnbrdType = oSelBltnBrd["BLTN_BRD_TYP_CD"]; //1=대그룹, 2=중그룹, 3=게시판
            var bltnbrdId   = oSelBltnBrd["BLTN_BRD_ID"]; //게시판ID
            var currRow  = oSelBltnBrd._index.data;
            var nextRow  = 1 + currRow;
            var oCurrRowQuery = {_index:{data:currRow}};
            var oNextRowQuery = {_index:{data:nextRow}};
            _debug("oSelBltnBrd ::: " + JSON.stringify(oSelBltnBrd));

            var newBltnBrdType   = ("1"==bltnbrdType ? "2" : ("2"==bltnbrdType ? "3" : "3"));
            var newBltnBrdTypeNm = ("1"==newBltnBrdType ? "대그룹" : ("2"==newBltnBrdType ? "중그룹" : "게시판"));
 
            var newData = {
                "FLAG"            : "I",
                "BLTN_BRD_TYP_CD" : newBltnBrdType, //<img src='${pageContext.request.contextPath}/image/blat_a15_a.gif'>
                "BLTN_BRD_TYP_NM" : newBltnBrdTypeNm,
                "BRWS_SEQ"        : "",
                "SUP_BLTN_BRD_ID" : bltnbrdId,
                "USE_YN"          : "Y",
                "UPDR_NM"         : $.PSNM.getSession("USER_NM"),
                "UPD_YMD"         : ""
            };

            $("#gridbltnbrd").alopexGrid("dataAdd", newData, oNextRowQuery);
            $("#gridbltnbrd").alopexGrid("dataEdit", {_state:{selected:false}}, {_state:{selected:true}}); //선택해제 == {_index:{data:currRow}}
            $("#gridbltnbrd").alopexGrid("dataEdit", {_state:{selected:true}},  {_index:{data:nextRow}});
            $("#gridbltnbrd").alopexGrid("dataScroll", nextRow); //스크롤
            setDetailFormData(newData);
        }
    }

    function delBltnBrd(e) {
        _debug("delBltnBrd", e.target.id);
        var arrSelBltnBrd = $("#gridbltnbrd").alopexGrid("dataGet", {_state:{selected:true}}); //선택된 데이터
        if (arrSelBltnBrd.length<1) {
            alert("삭제할 게시판을 선택하십시오!");
            return;
        }

        var oBltnBrd = arrSelBltnBrd[0]; //1개만 있음
        if ( oBltnBrd["BLTCONT_CNT"] > 0 ) {
            $.PSNM.alert("E019", ["등록된 게시글", "삭제"]); //"{0} 데이터가 있습니다. {1} 할 수 없습니다!"
            return false;
        }
        if ( oBltnBrd["SUB_BLTN_BRD_CNT"] > 0 ) {
            $.PSNM.alert("E019", ["하위 게시판", "삭제"]);
            return false;
        }

        var currRow = oBltnBrd._index.data;
        var oCurrRowQuery = {_index:{data:oBltnBrd._index.data}};

        if ( !$.PSNM.confirm("I004", ["삭제"]) ) {
            return false;
        }
        //$('#divbltnbrd-title').hide();
        //$('#divbltnbrd').hide();

        if ( "I"==oBltnBrd["FLAG"] ) {
            $("#gridbltnbrd").alopexGrid("dataDelete", oCurrRowQuery);
            return;
        }
        else if ( "D"==oBltnBrd["FLAG"] ) {
            $("#gridbltnbrd").alopexGrid("dataEdit", {"FLAG":""}, oCurrRowQuery);
        }
        else {
            $("#gridbltnbrd").alopexGrid("dataEdit", {"FLAG":"D"}, oCurrRowQuery);
        }
    }

    //담당자목록 '추가'
    function addBltnBrdChrgr(e) {
        var oParam = new Object();
        $.PSNMAction.popFindUser2(oParam, popFindUserCallback);
    }
    function popFindUserCallback(data) {
        _debug("선택된 사용자목록 정보\n\n" + JSON.stringify(data));
        if (null==data) {
            return false;
        }
        var arrChrgrList = $("#gridchrgr").alopexGrid("dataGet");
        for(var i=0; i<data.length; i++) {
            var oChrgr = data[i];
            var isExist = false;
            for(var j=0 ; j<arrChrgrList.length ; j++) {
                if (oChrgr.USER_ID == arrChrgrList[j].CHRGR_ID){
                    isExist = true;
                    break;
                }
            }
            oChrgr._state.added = true;
            oChrgr.CHRGR_ID = oChrgr.USER_ID; //담당자ID
            oChrgr.BLTN_BRD_ID = $("#BLTN_BRD_ID").val(); //게시판ID
            if (isExist == false) {
                $("#gridchrgr").alopexGrid("dataAdd", data[i], {_index : { data : 0 }});
                
                $("#gridchrgr").alopexGrid("startEdit");
                $("#gridchrgr").alopexGrid("endEdit");                
                //$("#gridchrgr table.table tr").removeClass("editing");
                //$("#gridchrgr table.table tr").removeClass("deleted");
            }
        }
    }

    //담당자목록 '삭제'
    function delBltnBrdChrgr(e) {
        var arrSelChrgr = $("#gridchrgr").alopexGrid("dataGet", {_state:{selected:true}}); //선택된 데이터
        if (arrSelChrgr.length<1) {
            $.PSNM.alert("E011", ["선택된"]); //"{0} 데이터가 없습니다!"
            return;
        }
        
        $("#gridchrgr").alopexGrid("dataDelete", {_state:{selected:true}, "FLAG":"I"}); //추가된 데이터는 화면에서 삭제
        $("#gridchrgr").alopexGrid("dataEdit", {_state:{deleted:true}}, {_state:{selected:true}});
        $("#gridchrgr table.table tr").removeClass("editing");
        $("#gridchrgr table.table tr").removeClass("deleted");
    }

    //상세 폼의 input, select 값이 변경된 경우 처리
    function onchangeBltnBrdData(e) {
        var elemId = e.target.id;
        var val = $("#"+ elemId).val();

        var arrSelBltnBrd = $("#gridbltnbrd").alopexGrid("dataGet", {_state:{selected:true}}); //선택된 데이터
        if (arrSelBltnBrd.length<1) {
            alert("갱신할 게시판을 선택하십시오!");
            return;
        }

        var oBltnbrdDataRaw = arrSelBltnBrd[0]; //1개만 있음
        var oCurrRowQuery = {_index:{data:oBltnbrdDataRaw._index.data}}; //현재 선택된 행

        var oBltnbrdDataOriginal = oBltnbrdDataRaw["_original"];
        var oBltnbrdDataCurrent  = AlopexGrid.trimData(oBltnbrdDataRaw);
        var isUpdated = false;

        var data = new Object();
            data[elemId] = val;
        if ( "ANM_TYP_CD"==elemId ) {
            data["ANM_TYP_NM"]  = ( ""==val ? "" : $("#"+ elemId + " option:selected").text() );
        }
        if ( "SRCH_PRD_CD"==elemId ) {
            data["SRCH_PRD_NM"] = ( ""==val ? "" : $("#"+ elemId + " option:selected").text() );
        }
        _debug("onchangeBltnBrdData", "data", JSON.stringify(data));

        $("#gridbltnbrd").alopexGrid("dataEdit", data, oCurrRowQuery);
    }

    //'상세폼'의 각 값을 초기화한후, 전달된 객체값으로 '상세폼'의 각 값을 설정함.
    function setDetailFormData(oBltnBrdData) {
        if ( $.PSNMUtils.isEmpty(oBltnBrdData) ) {
            return false;
        }

        $("#dform input").val(""); //폼 데이터 초기화
        $("#dform select").val("");
        $("#dform select").setSelected("");

        if ( "I"==oBltnBrdData["FLAG"] ) {
            //$("#BLTN_BRD_TYP_CD").setEnabled(true);
        }
        else {
            $("#BLTN_BRD_TYP_CD").setEnabled(false);
        }

        for(key in oBltnBrdData) {
            if ( $("#" + key).length ) {
                $("#" + key).val( oBltnBrdData[key] );
                $("#" + key).setSelected( oBltnBrdData[key] );
                _debug("setDetailFormData", "key = " + key, "val = " + oBltnBrdData[key]);
            }
        }

        var sBltnBrdTypCd = oBltnBrdData["BLTN_BRD_TYP_CD"];
        if ( "3"==sBltnBrdTypCd ) {
            $("#th_ADD_FILE_YN").addClass("psnm-required");
            $("#th_ANM_TYP_CD").addClass("psnm-required");
        }
        else {
            $("#th_ADD_FILE_YN").removeClass("psnm-required");
            $("#th_ANM_TYP_CD").removeClass("psnm-required");
        }

        $("#BLTN_BRD_NM").focus();
    }

    //게시판정보 및 담당자 정보가 변경되었는지 판단
    function isBbsDataChanged() {
        if ( $.PSNMUtils.isGridDataChanged('#gridbltnbrd') ) {
            return true;
        }
        if ( $.PSNMUtils.isGridDataRowAdded('#gridchrgr') || $.PSNMUtils.isGridDataRowDeleted('#gridchrgr') ) {
            return true;
        }
        return false;
    }

    //게시판정보를 저장
    function pSaveBltnBrd(e) {
        var updatedDataListRaw = $("#gridbltnbrd").alopexGrid("dataGet", {_state:{edited:true}});
        var updatedDataList = AlopexGrid.trimData( updatedDataListRaw );
        var updatedDataCount = updatedDataList.length; //변경된 게시판정보 개수

        var addCharList = $("#gridchrgr").alopexGrid("dataGet", {_state:{added:true}}); //추가된 담당자
        var delCharList = $("#gridchrgr").alopexGrid("dataGet", {_state:{deleted:true}}); //삭제된 담당자
        var updatedChrgrCount  = addCharList.length; //변경된 게시판담당자정보 개수
            updatedChrgrCount += delCharList.length;

        if ( updatedDataCount<1 && updatedChrgrCount<1 ) {
            var r = $.PSNM.alert("E011", ["변경된"], false);
            return r;
        }
        _debug("pSaveBltnBrd", "갱신된 건수", updatedDataCount);

        for(var i=0; i<updatedDataCount; i++) {
            var oBltnBrd = updatedDataListRaw[i];
            _debug("pSaveBltnBrd", "갱신된 게시판레코드", JSON.stringify(oBltnBrd));
            var sBltnBrdTypCd = oBltnBrd["BLTN_BRD_TYP_CD"];
            var r = true;

            if ( $.PSNMUtils.isEmpty(oBltnBrd["BLTN_BRD_NM"]) ) {
                r = $.PSNM.alert("E012", ["게시판명"], false); //{0} 항목은 필수값입니다!
                return false;
            }
            if ( oBltnBrd["BLTN_BRD_NM"].length < 2 ) {
                r = $.PSNM.alert("E013", ["게시판명", "2"], false); //{0} 항목은 {1}자 이상 입력하세요!
                return false;
            }
            if ( $.PSNMUtils.isEmpty(oBltnBrd["BRWS_SEQ"]) ) {
                r = $.PSNM.alert("E012", ["조회순서"], false);
                return false;
            }
            if ( $.PSNMUtils.isEmpty(oBltnBrd["USE_YN"]) ) {
                r = $.PSNM.alert("E012", ["사용여부"], false);
                return false;
            }
            if ( $.PSNMUtils.isEmpty(oBltnBrd["RCMND_OBJ_YN"]) ) {
                r = $.PSNM.alert("E012", ["추천기능사용"], false);
                return false;
            }
            if ( $.PSNMUtils.isEmpty(oBltnBrd["SCRT_NUM_SET_YN"]) ) {
                r = $.PSNM.alert("E012", ["비밀번호설정"], false);
                return false;
            }
            if ( "3"==sBltnBrdTypCd ) {
                if ( $.PSNMUtils.isEmpty(oBltnBrd["ADD_FILE_YN"]) ) {
                    r = $.PSNM.alert("E012", ["첨부파일"], false);
                    return false;
                }
                if ( $.PSNMUtils.isEmpty(oBltnBrd["ANM_TYP_CD"]) ) {
                    r = $.PSNM.alert("E012", ["작성자유형"], false);
                    return false;
                }
            }
            if (!r) {
                $("#gridbltnbrd").alopexGrid("dataEdit", {_state:{selected:false}}, {_state:{selected:true}});
                $("#gridbltnbrd").alopexGrid("dataEdit", {_state:{selected:true}},  {_index:{data:oBltnBrd._index.row}});
                pSearchBltnBrdByPk(oBltnBrd);
                return r;
            }
        }
        var updatedDataSet = $.PSNMUtils.getRequestDataUpdated("gridbltnbrd", "gridchrgr"); //변경된 데이터만 파라미터로 전달

        $.alopex.request(_TX_SAVE, {
            data: updatedDataSet,
            success: function(res) {
                if ( ! $.PSNM.success(res) ) {
                    return false;
                }
                $.PSNM.alert("I000"); //정상적으로 처리되었습니다.
                pSearchBltnBrdForcely();
            }
        });
    }

    function downloadExcel() {
        var oExcelMetaInfo = {
            filename  : "게시판목록.xls",
            sheetname : "게시판목록",
            gridname  : "gridbltnbrd" //그리드ID 
        };
        $.PSNMUtils.downloadExcelAll("sform", _TX_SEARCH, "gridbltnbrd", oExcelMetaInfo, [0,1,19,20,21]);
    }
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

    <!-- 1줄 find condition area -->
    <div class="textAR">
        <form id="sform">
            <table class="board02" style="width:92%;">
        	<colgroup>
	            <col style="width:15%"/>
	            <col style="width:35%"/>
	            <col style="width:15%"/>
	            <col style="width:*"/>
            </colgroup>
            <tr>
                <th scope="col" class="psnm-required">대그룹</th>
                <td class="tleft">
                    <select id="TOP_BLTN_BRD_ID" name="TOP_BLTN_BRD_ID" data-bind="options:options_TOP_BLTN_BRD_ID, selectedOptions:TOP_BLTN_BRD_ID" data-type="select" data-wrap="false"
                            data-validation-rule="{required:true}" 
                            data-validation-message="{required:$.PSNM.msg('E012', ['대그룹'])}" style="width: 150px;">
                        <option value="">-선택-</option>
                    </select>
                </td>
                <th class="">중그룹</th>
                <td class="tleft">
                    <select id="MID_BLTN_BRD_ID" name="MID_BLTN_BRD_ID" data-bind="options:options_MID_BLTN_BRD_ID, selectedOptions:MID_BLTN_BRD_ID" data-type="select" data-wrap="false" style="width: 150px;">
                        <option value="">-전체-</option>
                    </select>
                </td>
            </tr>
            </table>
        </form>
        <div class="ab_pos5">
            <button type="button" id="btnSearch" data-type="button" data-theme="af-psnm" data-authtype="R" data-altname="조회"></button>
        </div>
    </div>

    <div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>게시판목록</b>
        <p class="ab_pos2">
            <!-- <button id="btnInit"      type="button" data-type="button" data-theme="af-psnm0" data-authtype="R" >초기화</button> -->
            <button id="btnAdd"       type="button" data-type="button" data-theme="af-btn2"  data-authtype="W" data-altname="추가"></button>
            <button id="btnDel"       type="button" data-type="button" data-theme="af-btn13" data-authtype="W" data-altname="삭제"></button>
            <button id="btnSave"      type="button" data-type="button" data-theme="af-btn4"  data-authtype="W" data-altname="저장"></button>
            <button id="btnExcelAll"  type="button" data-type="button" data-theme="af-btn3"  data-authtype="W" data-altname="엑셀다운"></button>
        </p>
    </div>
    <!-- main grid -->
    <div id="gridbltnbrd" data-bind="grid:gridbltnbrd" data-ui="ds"></div>

    <div id="divbltnbrd-title" class="floatL4" style="display:none;"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>게시판상세</b>
        <p class="ab_pos2">
            &nbsp;
        </p>
    </div>
    <!-- main grid -->
    <div id="divbltnbrd" style="display:none;">
        <form id="dform">
            <table class="board02" width="100%" >
        	<colgroup>
	            <col style="width:90px"/>
	            <col style="width:100px"/>
	            <col style="width:90px"/>
	            <col style="width:100px"/>
	            <col style="width:110px"/>
	            <col style="width:*"/>
	            <col style="width:90px"/>
	            <col style="width:100px"/>
	            <col style="width:80px"/>
	            <col style="width:100px"/>
            </colgroup>
            <tr>
                <th scope="col" style="color:!important;">게시판유형</th>
                <td class="tleft">
                    <select id="BLTN_BRD_TYP_CD" name="BLTN_BRD_TYP_CD" data-type="select" data-bind="options:options_BLTN_BRD_TYP_CD, selectedOptions:BLTN_BRD_TYP_CD" 
                            data-wrap="false" style="width:70px">
                        <option value="">-선택-</option>
                    </select>
                </td>
                <th scope="col" style="color: !important;">게시판ID</th>
                <td class="tleft">
                    <input id="BLTN_BRD_ID" name="BLTN_BRD_ID" data-bind="value:BLTN_BRD_ID" data-type="textinput" data-keyfilter-rule="digits"
                           data-validation-rule="{required:true}" 
                           data-validation-message="{required:$.PSNM.msg('E012', ['게시판ID'])}" style="width:50px" maxlength="5">
                </td>
                <th scope="col" class="psnm-required" style="color:#f92020!important;">게시판명</th>
                <td colspan="3" class="tleft">
                    <input id="BLTN_BRD_NM" name="BLTN_BRD_NM" data-bind="value:BLTN_BRD_NM" data-type="textinput" 
                           data-validation-rule="{required:true}" 
                           data-validation-message="{required:$.PSNM.msg('E012', ['게시판명'])}" style="width:95%" maxlength="30">
                </td>
                <th scope="col" class="psnm-required" style="color:#f92020!important;">조회순서</th>
                <td class="tleft">
                    <input id="BRWS_SEQ" name="BRWS_SEQ" data-bind="value:BRWS_SEQ" data-type="textinput" data-keyfilter-rule="digits"
                           data-validation-rule="{required:true}" 
                           data-validation-message="{required:$.PSNM.msg('E012', ['조회순서'])}" style="width:50px" maxlength="3">
                </td>
            </tr>
            <tr>
                <th scope="col" style="color:#f92020!important;">사용여부</th>
                <td class="tleft">
                    <select id="USE_YN" name="USE_YN" data-type="select" data-bind="selectedOptions:USE_YN" data-wrap="false" style="width:70px!important">
                        <option value="">&nbsp;</option>
                        <option value="Y">Y</option>
                        <option value="N">N</option>
                    </select>
                </td>
                <th scope="col" style="color:#f92020!important;">비밀번호설정</th>
                <td class="tleft">
                    <select id="SCRT_NUM_SET_YN" name="SCRT_NUM_SET_YN" data-type="select" data-bind="selectedOptions:SCRT_NUM_SET_YN" data-wrap="false" style="width:60px!important">
                        <option value="">&nbsp;</option>
                        <option value="Y">Y</option>
                        <option value="N">N</option>
                    </select>
                </td>
                <th scope="col" style="color:#f92020!important;">추천기능사용</th>
                <td class="tleft" style="">
                    <select id="RCMND_OBJ_YN" name="RCMND_OBJ_YN" data-type="select" data-bind="selectedOptions:RCMND_OBJ_YN" data-wrap="false" style="width:50px!important">
                        <option value="">&nbsp;</option>
                        <option value="Y">Y</option>
                        <option value="N">N</option>
                    </select>
                </td>
                <th scope="col" id="th_ADD_FILE_YN" style="color:!important;">첨부파일</th>
                <td class="tleft">
                    <select id="ADD_FILE_YN" name="ADD_FILE_YN" data-type="select" data-bind="selectedOptions:ADD_FILE_YN" data-wrap="false" style="width:50px!important">
                        <option value="">&nbsp;</option>
                        <option value="Y">Y</option>
                        <option value="N">N</option>
                    </select>
                </td>
                <th scope="col">SMS수신</th>
                <td class="tleft">
                    <select id="SMS_RCV_YN" name="SMS_RCV_YN" data-type="select" data-bind="selectedOptions:SMS_RCV_YN" data-wrap="false" style="width:50px!important">
                        <option value="">&nbsp;</option>
                        <option value="Y">Y</option>
                        <option value="N">N</option>
                    </select>
                </td>
            </tr>
            <tr>
                <th scope="col" id="th_ANM_TYP_CD" style="color:!important;">작성자유형</th>
                <td class="tleft">
                    <select id="ANM_TYP_CD" name="ANM_TYP_CD" data-type="select" data-bind="options:options_ANM_TYP_CD, selectedOptions:ANM_TYP_CD" data-wrap="false" style="width:70px!important">
                        <option value="">-선택-</option>
                    </select>
                </td>
                <th scope="col">조회기간</th>
                <td class="tleft" style="">
                    <select id="SRCH_PRD_CD" name="SRCH_PRD_CD" data-type="select" data-bind="options:options_SRCH_PRD_CD, selectedOptions:SRCH_PRD_CD" data-wrap="false" style="width:60px!important">
                        <option value="">-선택-</option>
                    </select>
                </td>
                <th scope="col">조회기간변경가능</th>
                <td class="tleft" style="">
                    <select id="SRCH_PRD_CHG_YN" name="SRCH_PRD_CHG_YN" data-type="select" data-bind="selectedOptions:SRCH_PRD_CHG_YN" data-wrap="false" style="width:50px!important">
                        <option value="">&nbsp;</option>
                        <option value="Y">Y</option>
                        <option value="N">N</option>
                    </select>
                </td>
                <th scope="col">게시일시사용</th>
                <td class="tleft" style="">
                    <select id="BLT_DTM_YN" name="BLT_DTM_YN" data-type="select" data-bind="selectedOptions:BLT_DTM_YN" data-wrap="false" style="width:50px!important">
                        <option value="">&nbsp;</option>
                        <option value="Y">Y</option>
                        <option value="N">N</option>
                    </select>
                </td>
                <th scope="col">&nbsp;</th>
                <td class="tleft">
                    &nbsp;
                </td>
            </tr>
            </table>
        </form>
    </div>

    <div id="divchrgr" class="floatL4" style="display:none;"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>SMS수신 대상자</b>
        <p class="ab_pos1">
            <input id="btnAddChrgr" type="button" data-type="button" data-authtype="W" class="psnm-sbtn-add" />
            <input id="btnDelChrgr" type="button" data-type="button" data-authtype="W" class="psnm-sbtn-del" />
        </p>
    </div>
    <!-- 담당자목록 grid -->
    <div id="gridchrgr" data-bind="grid:gridchrgr" data-ui="ds" style="display:none;"></div>
</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>
