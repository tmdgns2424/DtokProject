<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

    <jsp:include page="/view/layouts/default_head.jsp" flush="false" />

    <script type="text/javascript">
    var _param; 
    
    $.alopex.page({
        init : function(id, param) {
            
            $.PSNM.initialize(id, param); //PSNM공통 초기화함수 호출
            
            _param = param;
            
            $a.page.setEventListener(); //버튼 초기화
            $a.page.setCodeData();      //공통코드 호출
            $a.page.setDetail(param);
            $.PSNMAction.setCmntData(param.APLCNSL_MGMT_NUM); // 댓글조회(이페이지로 전달된 아이디)
        },
        setEventListener : function() {         
            $("#btnList").click(function(){    // 목록버튼 클릭
                $a.back(_param);
            });         
              $("#btnCmntSave").click(function(){ // 덧글입력버튼 클릭
                var dsmContId = _param.APLCNSL_MGMT_NUM; // 이페이지로 전달된 아이디
                $.PSNMAction.saveCmntData(dsmContId, $("#cmnt")); // 댓글저장
            });
        },

        setCodeData : function() {
            $.PSNMUtils.setCodeData([
                { t:'code',  'elemid' : 'APL_ST_CD', 'header' : '' },
                { t:'org2',  'elemid' : 'HDQT_PART_ORG_ID', 'header' : '-전체-' }, //[본사파트]
                { t:'org3',  'elemid' : 'SALE_DEPT_ORG_ID', 'header' : '-전체-' }  //[영업국]
            ], $a.page.setCodeDataCallback);
        },
        setDetail : function(param){
            
            if($.PSNMUtils.isNotEmpty(param.APLCNSL_MGMT_NUM)){
                
                $.alopex.request('agn.AGNTMGMT@PAGENTECCR001_pDetailAgentEccr', {
                    
                    data: { dataSet : { fields : { APLCNSL_MGMT_NUM : param.APLCNSL_MGMT_NUM } } },
                    
                    success : ["#detailForm", function(res){
                        
                        
                    }]
                });
            }
        },
        
    });
    
    function onAgentFound( oResult ){    

        $("#AGNT_NM").val( oResult["AGNT_NM"] );
        $("#AGNT_ID").val( oResult["AGNT_ID"] );
        $("#AGNT_HDQT_PART_ORG_NM").val( oResult["HDQT_PART_ORG_NM"] );
        $("#AGNT_SALE_DEPT_ORG_NM").val( oResult["SALE_DEPT_ORG_NM"] );
        $("#AGNT_SALE_TEAM_ORG_NM").val( oResult["SALE_TEAM_ORG_NM"] );
    }
    </script>
</head>

<body>

<jsp:include page="/view/layouts/default_header.jsp" flush="false" />

<div id="contents">
    
    <!-- sub title area -->
    <div class="content_title">
       <div class="ub_txt6">
          <span class="txt6_img"><b id="sub-title">MA지원상담관리</b>
          <span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif"> 
          <span class="a2">대메뉴명</span> <span class="a3"> > </span> <span class="a4"><b>중메뉴명</b> </span></span></span>
       </div>
    </div>

    <!-- btn area -->
    <div class="btn_area">  
        <div class="ab_btn_right">
            <button id="btnList"    type="button" value="" data-type="button" data-theme="af-btn14" data-altname="목록"></button>
        </div>
    </div>
    
    <div class="textAR">
        <form id="detailForm">
        
        <div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>상담정보</b> </div>
        <font size="2" color="red">&bull; 상담정보를 입력해 주시면, 담당 영업국 배정 후 지원자님께 3일 이내에 연락 드릴 예정입니다. </font>
        
        <input id="APLCNSL_MGMT_NUM" data-type="hidden" data-bind="value:APLCNSL_MGMT_NUM" type="hidden"/>
        
        <table id="detailTable" class="board02" style="width:100%;">
       	<colgroup>
            <col style="width:15%"/>
            <col style="width:35%"/>
            <col style="width:13%"/>
            <col style="width:*"/>
        </colgroup>
        <tr>
            <th scope="col">성명(한글)</th>
            <td class="tleft  time">
                <label data-bind="html:NAME_KOR" data-theme="af-textinput"></label></td>
            <th >연락처</th>
            <td class="tleft"><span class="tleft  time"></span>
                <label data-bind="html:MBL_PHON_NUM1" data-theme="af-textinput"></label> -
                <label data-bind="html:MBL_PHON_NUM2" data-theme="af-textinput"></label> -
                <label data-bind="html:MBL_PHON_NUM3" data-theme="af-textinput"></label>
            </td>
        </tr>
        <tr>
            <th scope="col">나이</th>
            <td class="tleft  time">
                <label data-bind="html:AGE" data-theme="af-textinput"></label></td>
            <th >성별</th>
            <td class="tleft"><span class="tleft  time"></span>
                <input id="SEX_M" type="radio" data-bind="checked:SEX" value="M" name="SEX" data-type="radio"/>
                <label for="M">남</label>
                <input id="SEX_W" type="radio" data-bind="checked:SEX" value="W" name="SEX" data-type="radio" />
                <label for="W">여</label></td>
        </tr>
        <tr>
            <th scope="col">판매방식</th>
            <td class="tleft  time">
                <label data-bind="html:RETL_TYP_NM" data-theme="af-textinput"></label>
                <!--  <select id="RETL_TYP_CD" data-type="select" data-bind="value:RETL_TYP_CD, options:selectOptionsData, selectedOptions:RETL_TYP_CD" data-wrap="true"></select>-->
            </td>
            <th>휴대폰판매경력</th>
            <td class="tleft"><span class="tleft  time"></span>
                <label data-bind="html:SALES_HST" data-theme="af-textinput"></label>
                <!--  <input data-bind="value:SALES_HST" data-type="textinput" data-disabled="true" data-theme="af-textinput"/>-->
            </td>
        </tr>
        <tr>
            <th scope="col">영업예정지역</th>
            <td colspan="3" class="tleft time">
                <label data-bind="html:ACT_ZONE" data-theme="af-textinput"></label>
            </td>
        </tr>
        <tr>
            <th scope="col">문의사항</th>
            <td colspan="3" class="tleft time">
                <p class="cb_dsc"><span data-bind="text: MEMO"></span></p>
            </td>
        </tr>
        </table>
        
        <div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>상태 및 배정정보</b> </div>
                
        
        <table id ="procTable" class="board02" style="width:100%;">
       	<colgroup>
            <col style="width:15%"/>
            <col style="width:35%"/>
            <col style="width:13%"/>
            <col style="width:*"/>
        </colgroup>
        <tr>
            <th scope="col">처리상태</th>
            <td class="tleft time">
                <label id="APL_ST_NM" data-bind="html:APL_ST_NM" data-theme="af-textinput" ></label>
            </td>
            <th >상담국 배정</th>
            <td class="tleft">
                <label id="HDQT_PART_ORG_NM" data-bind="html:HDQT_PART_ORG_NM" data-theme="af-textinput" ></label>    <!-- 본사파트 -->             
                <label id="SALE_DEPT_ORG_NM" data-bind="html:SALE_DEPT_ORG_NM" data-theme="af-textinput" ></label>    <!-- 영업국 -->
            </td>
        </tr>
        </table>
        
        <div id="dialog" data-type="dialog"><div class="contents">컨텐츠 영역입니다.</div></div>
        
        <!-- 에이전트 코드 매핑 area -->
        <div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>에이전트 코드 매핑</b> </div>
        <div class="view_table vline">
        
            <table id ="agentTable" data-type="table">
            <colgroup>
                <col style="width:150px;"></col>
                <col style="width:120px;"></col>
                <col style="width:120px;"></col>
                <col style="width:100px;"></col>
                <col style="width:100px;"></col>
                <col style="width:100px;"></col>
                <col style="width:100px;"></col>
            </colgroup>
            <thead class="table-body">
            <tr >
                <th >에이전트코드</th>
                <th >에이전트명</th>
                <th >본사파트</th>
                <th >영업국명</th>
                <th >영업팀명</th>
                <th >처리자</th>
                <th >처리일</th>
            </tr>
            </thead>
            <tbody class="table-body">
            <tr class="row-odd">
                <td>
                    <input id="AGNT_ID" data-bind="value:AGNT_ID" data-type="textinput" data-disabled="true" data-callback="onAgentFound" style="text-align:center">
                </td>
                <td>
                    <input id="AGNT_NM" data-bind="value:AGNT_NM" data-type="textinput" data-disabled="true" style="text-align:center">
                </td>
                <td>
                    <input id="AGNT_HDQT_PART_ORG_NM" data-bind="value:AGNT_HDQT_PART_ORG_NM" data-type="textinput" data-disabled="true" style="text-align:center">
                </td>
                <td>
                    <input id="AGNT_SALE_DEPT_ORG_NM" data-bind="value:AGNT_SALE_DEPT_ORG_NM" data-type="textinput" data-disabled="true" style="text-align:center">
                </td>
                <td>
                    <input id="AGNT_SALE_TEAM_ORG_NM" data-bind="value:AGNT_SALE_TEAM_ORG_NM" data-type="textinput" data-disabled="true" style="text-align:center">
                </td>
                <td>
                    <input id="AGNT_OPR_NM" data-bind="value:AGNT_OPR_NM" data-type="textinput" data-disabled="true" style="text-align:center">
                </td>
                <td>
                    <input id="AGNT_OP_DTM" data-bind="value:AGNT_OP_DTM" data-type="textinput" data-disabled="true" style="text-align:center">
                </td>
            </tr>
            </tbody>
            </table>

        </div> 
        
        <!--view_댓글 area -->
        <jsp:include page="/view/layouts/cmnt_comm.jsp" flush="false" />
        
        </form>
    </div>
  
</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>
