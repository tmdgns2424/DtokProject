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
    var _TX_SEARCH        = "com.BLTNBRD@PBLTNBRDMGMT001_pSearchBltnBrd";

    $.alopex.page({
        init : function(id, param) { 
            $.PSNM.initialize(id, param); //PSNM공통 초기화함수 호출(서브 페이지에서는 필수 호출)

            $a.page.setCodeData();
            $a.page.setEventListener();
            $a.page.setGrid();

            $('#sform').setData(param); //(설명) 상세페이지에서 돌아오는 경우, 이 값들이 세션스토리지에서 반환됨.

            if ( !$.PSNMUtils.isEmpty(param) && !$.PSNMUtils.isEmpty(param["TOP_BLTN_BRD_ID"]) ) {
                pSearchBltnBrd();
            }

            $("#TOP_BLTN_BRD_ID").focus();
        },
        setEventListener : function() {
            $("#btnSearch").click( pSearchBltnBrd );
        },
        setGrid : function() {
            $("#gridbltnbrd").alopexGrid({
                pager:false,
                rowSingleSelect: true,
                //rowInlineEdit  : true, //더블클릭을 이용하여 행을 편집모드로 바꿀 수 있도록 해주는 옵션.
                columnMapping : [
                    { columnIndex : 0, key : "BLTN_BRD_TYP_CD", title : "선택",     width : "80px",
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
                    { columnIndex : 1, key : "BLTN_BRD_TYP_NM", title : "게시판유형",       align : "center", width : "90px"  },
                    { columnIndex : 2, key : "BLTN_BRD_ID",     title : "게시판ID",         align : "center", width : "70px"  },
                    { columnIndex : 3, key : "BLTN_BRD_NM",     title : "게시판명",         align : "left",   width : "150px" },
                    { columnIndex : 4, key : "BRWS_SEQ",        title : "조회순서",         align : "center", width : "70px"  },
                    { columnIndex : 5, key : "USE_YN",          title : "사용여부",         align : "center", width : "70px"  },
                    { columnIndex : 6, key : "SCRT_NUM_SET_YN", title : "비밀번호설정",     align : "center", width : "90px"  },
                    { columnIndex : 7, key : "RCMND_OBJ_YN",    title : "추천기능사용",     align : "center", width : "90px"  },
                    { columnIndex : 8, key : "ADD_FILE_YN",     title : "첨부파일",         align : "center", width : "70px"  },
                    { columnIndex : 9, key : "SMS_RCV_YN",      title : "SMS수신",          align : "center", width : "70px"  },
                    { columnIndex :11, key : "ANM_TYP_NM",      title : "작성자유형",       align : "center", width : "80px"  },
                    { columnIndex :12, key : "SRCH_PRD_NM",     title : "조회기간",         align : "center", width : "70px"  },
                    { columnIndex :13, key : "SRCH_PRD_CHG_YN", title : "조회기간변경가능", align : "center", width : "120px" },
                    { columnIndex :14, key : "BLT_DTM_YN",      title : "게시일시",         align : "center", width : "70px"  },
                    { columnIndex :15, key : "AUTH_YN",         title : "권한설정",         align : "center", width : "70px"  },
                    { columnIndex :16, key : "UPDR_NM",         title : "최종수정자",       align : "center", width : "80px"  },
                    { columnIndex :17, key : "UPD_YMD",         title : "최종수정일",       align : "center", width : "80px"  },
                    { columnIndex :18, key : "BLTCONT_CNT",     title : "BLTCONT_CNT",      hidden:true },
                    { columnIndex :19, key : "SUB_BLTN_BRD_CNT",title : "SUB_BLTN_BRD_CNT", hidden:true }
                ]
                ,
                on : {
                    'cell' : {
                        "click" : function(data, eh, e) {
                            //gotoBrdAuthMgmt(data);
                        }
                        ,
                        "dblclick" : function(data, eh, e) {
                            gotoBrdAuthMgmt(data);
                        }
                    }
                }
            });
        }, //end-of-setGrid
        setCodeData : function() {
            $.alopex.request(_TX_SEARCH_BY_TYP, {
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
        }
    });//end-of-$.alopex.page //-------------------------------------------------------------------------------------------------------//

    //게시판목록조회(TREE)
    function pSearchBltnBrd() {
        if ( !$.PSNM.isValid('#sform') ) {
            return false;
        }

        $.alopex.request(_TX_SEARCH, {
            data: ['#sform', function() {
                //this.data.dataSet.fields["BLTN_BRD_ID"] = this.data.dataSet.fields.TOP_BLTN_BRD_ID;
                //_debug("<pSearchBltnBrd> <request.data> 파라미터 (this.data.dataSet.fields) : " + JSON.stringify(this.data.dataSet.fields));
            }],
            success: ['#gridbltnbrd', function(res) {
                //_debug("<pSearchBltnBrd> <request.success> 결과데이터 : " + JSON.stringify(res));
            }]
        });
    } //end of pSearchBltnBrd()

    //게시판권한설정으로 이동
    function gotoBrdAuthMgmt(oParam) {
        var sBrdTypCode = oParam["BLTN_BRD_TYP_CD"];
        if ( "3"!=sBrdTypCode ) {
            $.PSNM.alert("권한설정은 게시판만 가능합니다.");
            return false;
        }
        _debug("gotoBrdAuthMgmt", "param : " + JSON.stringify(oParam));

        oParam["TOP_BLTN_BRD_ID"] = $("#TOP_BLTN_BRD_ID").val(); //검색조건을 저장해둠

        $a.navigate("bltnBrdAuthMgmt.jsp", oParam);
    } //end of gotoBrdAuthMgmt()

    </script>

</head>

<body>

<jsp:include page="/view/layouts/default_header.jsp" flush="false" />

<!-- title area -->
<div id="contents">
    <div class="content_title">
        <div class="ub_txt6">
            <span class="txt6_img"><b id="sub-title">게시판권한관리</b>
                <span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif">
                <span class="a2">본사업무</span> <span class="a3"> > </span> <span class="a4"><b>공통관리</b></span> 
            </span>
        </div>
    </div>

    <!-- 1줄 find condition area -->
    <div class="textAR">
        <form id="sform">
            <table class="board02" style="width:92%;">
        	<colgroup>
	            <col style="width:15%"/>
	            <col style="width:*"/>
            </colgroup>
            <tr>
                <th style=" color:#ea002c;" scope="col" class="psnm-required">대그룹</th>
                <td class="tleft">
                    <select id="TOP_BLTN_BRD_ID" name="TOP_BLTN_BRD_ID" data-bind="options:options_TOP_BLTN_BRD_ID, selectedOptions:TOP_BLTN_BRD_ID" data-type="select" 
                            data-validation-rule="{required:true}" 
                            data-validation-message="{required:$.PSNM.msg('E012', ['대그룹'])}">
                        <option value="">-선택-</option>
                    </select>
                    <!-- <input name="BLTN_BRD_ID" type="hidden" data-bind="" data-type="hidden" /> -->
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
            <!-- <button id="btnInit" type="button" data-type="button" data-theme="af-psnm0" data-authtype="R" >초기화</button> -->
        </p>
    </div>

    <!-- main grid -->
    <div id="gridbltnbrd" data-bind="grid:gridbltnbrd" data-ui="ds"></div>

</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>
