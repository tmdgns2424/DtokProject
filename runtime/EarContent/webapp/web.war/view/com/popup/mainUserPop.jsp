<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="nexcore.framework.core.Constants"%>
<%@ page import="nexcore.framework.core.code.ICode"%>
<%@ page import="nexcore.framework.core.data.user.IUserInfo"%>
<%@ page import="nexcore.framework.core.util.BaseUtils"%>
<%@ page import="nexcore.framework.online.channel.util.WebUtils"%>
<%
    IUserInfo userInfo = WebUtils.getSessionUserInfo(request);
    System.out.println(" sessionUserPop.jsp :: 사용자정보 : " + userInfo);

    if (userInfo == null) {
        //response.sendRedirect("<c:out value='${pageContext.request.contextPath}'/>/index.jsp");
        System.err.println("############## main :: NOT LOGINED!");
    }
    else {
        System.out.println("<sessionUserPop.jsp> USER_ID : " + userInfo.getLoginId());
        System.out.println("<sessionUserPop.jsp> USER_NM : " + userInfo.get("USER_NM"));
        System.out.println("<sessionUserPop.jsp> SALE_TEAM_ORG_ID : " + userInfo.get("SALE_TEAM_ORG_ID"));
        System.out.println("<sessionUserPop.jsp> SALE_DEPT_ORG_ID : " + userInfo.get("SALE_DEPT_ORG_ID"));
        System.out.println("<sessionUserPop.jsp> HDQT_PART_ORG_ID : " + userInfo.get("HDQT_PART_ORG_ID"));
        System.out.println("<sessionUserPop.jsp> HDQT_TEAM_ORG_ID : " + userInfo.get("HDQT_TEAM_ORG_ID"));
    }

    String user_locale = request.getParameter("user_locale");
    if(user_locale != null && user_locale.trim().length() > 0){
        userInfo.setLocale(BaseUtils.asLocale(user_locale));
    }
    
    List topMenuList = null==userInfo ? null : (List)userInfo.get("psnm-topmenus"); //top-menu-rs
    int topMenuCount = null==topMenuList ? 0 : topMenuList.size();
    System.out.println("<sessionUserPop.jsp> psnm-topmenus count : " + topMenuCount);
%>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>세션 사용자정보 - PS&Marketing</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />

    <script type="text/javascript">
    var _initParam = null;

    $a.page({
        init : function(id, param) { //{"HDQT_TEAM_ORG_ID":"C21100","HDQT_PART_ORG_ID":"","SALE_DEPT_ORG_ID":"","SALE_TEAM_ORG_ID":"","AGNT_NM":"ab"} 
            _initParam = param;
            _debug('<sessionUserPop> $.alopex.page.init (param) : \n###### ' + JSON.stringify(param));
            //$.PSNM.initOrgSelectBox(); //본사팀, 본사파트, 영업국 select 객체 초기화

            $a.page.setEventListener();
            //$a.page.setGrid();

            //$('#searchForm').setData(param);
            //pSearchAgnt(); //조회
        },
        setEventListener : function() {
            $("#btnConfirm").click( closeConfirm );
            $("#iconCancel").click( closeWithout );

        }, //end-of-setEventListener
        setGrid : function() {
            //그리드 초기화
            $("#gridagnt").alopexGrid({
                paging: {
                    perPage : 10,
                    pagerCount : 10
                },
                columnMapping : [
                    { columnIndex : 0, key : "RN",               title : "번호",             align : "center", width : "40px" }, //{ columnIndex : 0, selectorColumn : true, width : "20px" },
                    { columnIndex : 1, key : "HDQT_TEAM_ORG_NM", title : "본사팀",           align : "left",   width : "80px" },
                    { columnIndex : 2, key : "HDQT_PART_ORG_NM", title : "본사파트",         align : "left",   width : "80px" },
                    { columnIndex : 3, key : "SALE_DEPT_ORG_NM", title : "영업국명",         align : "left",   width : "80px" },
                    { columnIndex : 4, key : "SALE_TEAM_ORG_NM", title : "영업팀명",         align : "left",   width : "80px" },
                    { columnIndex : 5, key : "AGNT_NM",          title : "에이전트명",       align : "center", width : "50px" },
                    { columnIndex : 6, key : "HDQT_TEAM_ORG_ID", title : "HDQT_TEAM_ORG_ID", align : "left",   hidden:true },
                    { columnIndex : 7, key : "HDQT_PART_ORG_ID", title : "HDQT_PART_ORG_ID", align : "left",   hidden:true },
                    { columnIndex : 8, key : "SALE_DEPT_ORG_ID", title : "SALE_DEPT_ORG_ID", align : "left",   hidden:true },
                    { columnIndex : 9, key : "SALE_TEAM_ORG_ID", title : "SALE_TEAM_ORG_ID", align : "left",   hidden:true },
                    { columnIndex :10, key : "AGNT_ID",          title : "AGNT_ID",          align : "left",   hidden:true },
                    { columnIndex :11, key : "DUTY",             title : "DUTY",             align : "left",   hidden:true },
                    { columnIndex :12, key : "DUTY_NM",          title : "DUTY_NM",          align : "left",   hidden:true },
                    { columnIndex :13, key : "RPSTY",            title : "RPSTY",            align : "left",   hidden:true },
                    { columnIndex :14, key : "RPSTY",            title : "RPSTY",            align : "left",   hidden:true },
                    { columnIndex :15, key : "RPSTY_NM",         title : "RPSTY_NM",         align : "left",   hidden:true },
                    { columnIndex :15, key : "USER_ID",          title : "USER_ID",          align : "left",   hidden:true }
                ],
                on : {
                    perPageChange : function(arg1) {
                        _debug("<sessionUserPop> <grid.on.perPageChange> 페이지당개수 변경 : arg1 = " + arg1);
                    }
                    ,
                    pageSet : function(pageNoToGo) {
                        _debug("<sessionUserPop> <grid.on.perPageChange> 페이지번호 변경 : 변경할 페이지번호 = " + pageNoToGo);
                        var p = {};
                            p.page = pageNoToGo;
                        var param = JSON.parse($a.session('alopex_parameters'));
                        param.page = pageNoToGo;

                        $a.session('alopex_parameters', JSON.stringify(param));
                        pSearchAgnt(p); //페이지 이동
                    }
                }
            });
            $("#gridagnt").alopexGrid('updateOption', {
                on : {
                    'cell' : {
                        "dblclick" : function(data, eh, e) {
                            _debug("<gridagnt.updateOption> 더블클릭된 데이터 : " + $.PSNMUtils.toString(data));
                            closeWith(data);
                        }
                    }
                }
            });
        }, //end-of-setGrid
        setCodeData : function() {
            $.PSNMUtils.setCodeData([
                { t:'org1',  'elemid' : 'HDQT_TEAM_ORG_ID', 'header' : '-전체-' } //[본사팀] 목록 조회
            ]);
        }
    });//end-of-$.alopex.page //-------------------------------------------------------------------------------------------------------//


    function closeWithout() {
        $a.close();
    }

    //현재창을 닫고 객체를 반환
    function closeConfirm() {
        var oReturn = {};
        $a.close(oReturn);
    }
    </script>
</head>

<body>

<div id="Wrap"> 

    <!-- title area -->
    <div class="pop_header" style="max-height:;">

        <div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>사용자정보</b></div>

        <table class="board02" width="100%" >
        <tr>
          <th width="120px" scope="col">성명</th>
          <td width="450px" class="tleft"><%=userInfo.get("USER_NAME")%></td>
          <th >아이디</th>
          <td width="200px"class="tleft"><%=userInfo.getLoginId()%></td>
        </tr>
        <tr>
          <th scope="col">본사팀</th>
          <td class="tleft"><%=userInfo.get("HDQT_TEAM_ORG_ID")%> (<%=userInfo.get("HDQT_TEAM_ORG_NM")%>)</td>
          <th >본사파트</th>
          <td class="tleft"><%=userInfo.get("HDQT_PART_ORG_ID")%> (<%=userInfo.get("HDQT_PART_ORG_NM")%>)</td>
        </tr>
        <tr>
          <th scope="col">영업국</th>
          <td class="tleft"><%=userInfo.get("SALE_DEPT_ORG_ID")%> (<%=userInfo.get("SALE_DEPT_ORG_NM")%>)</td>
          <th>영업팀</th>
          <td class="tleft"><%=userInfo.get("SALE_TEAM_ORG_ID")%> (<%=userInfo.get("SALE_TEAM_ORG_NM")%>)</td>
        </tr>
        <tr>
          <th scope="col">CPLAZA_ORG_CD</th>
          <td class="tleft"><%=userInfo.get("CPLAZA_ORG_CD")%></td>
          <th>ATTC_CAT</th>
          <td class="tleft"><%=userInfo.get("ATTC_CAT")%>&nbsp;</td>
        </tr>
        <tr>
          <th scope="col">ORG_ID</th>
          <td class="tleft"><%=userInfo.get("ORG_ID")%>&nbsp;</td>
          <th>ORG_AREA</th>
          <td class="tleft"><%=userInfo.get("ORG_AREA")%>&nbsp;</td>
        </tr>
        <tr>
          <th scope="col">NEW_ORG_ID</th>
          <td class="tleft"><%=userInfo.get("NEW_ORG_ID")%>&nbsp;</td>
          <th>OUT_ORG_ID</th>
          <td class="tleft"><%=userInfo.get("OUT_ORG_ID")%>&nbsp;</td>
        </tr>
        <tr>
          <th scope="col">OUT_USER_TYP</th>
          <td class="tleft"><%=userInfo.get("OUT_USER_TYP")%>&nbsp;</td>
          <th>U_KEY_ID</th>
          <td class="tleft"><%=userInfo.get("U_KEY_ID")%></td>
        </tr>
        <tr>
          <th scope="col">직무(DUTY)</th>
          <td class="tleft"><%=userInfo.get("DUTY_NM")%> (<%=userInfo.get("DUTY")%>)</td>
          <th>직책</th>
          <td class="tleft"><%=userInfo.get("RPSTY_NM")%> (<%=userInfo.get("MBR_RPSTY")%>)</td>
        </tr>
        <tr>
          <th scope="col">전화</th>
          <td class="tleft"><%=userInfo.get("WPHON")%></td>
          <th>이동전화</th>
          <td class="tleft"><%=userInfo.get("MBL_PHON")%></td>
        </tr>
        <tr>
          <th scope="col">이메일ID</th>
          <td class="tleft"><%=userInfo.get("EMAIL_ID")%>&nbsp;</td>
          <th>이메일도메인</th>
          <td class="tleft"><%=userInfo.get("EMAIL_DMN_NM")%>&nbsp;(<%=userInfo.get("EMAIL_DMN_CD")%>)</td>
        </tr>
        <tr>
          <th scope="col">USER_TYP</th>
          <td class="tleft"><%=userInfo.get("USER_TYP")%>&nbsp;<span style="color:red;">(프로그램에서 사용하지 말것)</style></td>
          <th>DUTY_USER_TYP</th>
          <td class="tleft"><%=userInfo.get("DUTY_USER_TYP")%>&nbsp;<span style="color:red;">(=asis DUTY_TYP_CD)</span></td>
        </tr>
        <tr>
          <th scope="col">USER_GRP</th>
          <td class="tleft"><%=userInfo.get("USER_GRP")%>&nbsp;</td>
          <th>PWD_END_DT</th>
          <td class="tleft"><%=userInfo.get("PWD_END_DT")%>&nbsp;</td>
        </tr>
        <tr>
          <th scope="col">PIC_FILE_ID</th>
          <td class="tleft"><%=userInfo.get("PIC_FILE_ID")%>&nbsp;</td>
          <th>NICK_NM</th>
          <td class="tleft"><%=userInfo.get("NICK_NM")%>&nbsp;</td>
        </tr>
        <tr>
          <th scope="col">권한그룹</th>
          <td colspan="3" class="tleft">
                <table class="" width="100%" >
                <tr><!-- AUTH_GRP_ID | AUTH_GRP_NM | AUTH_TYP_ID | AUTH_TYP_NM -->
                    <th scope="col" style="text-align: center;">권한그룹D</th>
                    <th scope="col" style="text-align: center;">권한그룹명</th>
                    <th scope="col" style="text-align: center;">권한타입ID</th>
                    <th scope="col" style="text-align: center;">권한타입명</th>
                </tr>
<%
    List _authgrp = null==userInfo ? null : (List)userInfo.get("authgrp"); //권한그룹 정보
    int _authgrpCount = null==_authgrp ? 0 : _authgrp.size();
    for(int i=0; i<_authgrpCount; i++) {
        Map<String, Object> ag = (Map<String, Object>)_authgrp.get(i);
%>
                    <tr>
                        <td><%=ag.get("AUTH_GRP_ID")%></td>
                        <td><%=ag.get("AUTH_GRP_NM")%></td>
                        <td><%=ag.get("AUTH_TYP_ID")%></td>
                        <td><%=ag.get("AUTH_TYP_NM")%></td>
                    </tr>
<%
    }
%>
                </table>
          </td>
        </tr>
        <tr>
          <th scope="col">데이터권한조직</th>
          <td colspan="3" class="tleft">
                <table class="" width="100%" >
                <tr><!-- HDQT_TEAM_ORG_ID | HDQT_TEAM_ORG_NM | HDQT_PART_ORG_ID | HDQT_PART_ORG_NM -->
                    <th scope="col" style="text-align: center;">본사팀ID</th>
                    <th scope="col" style="text-align: center;">본사팀명</th>
                    <th scope="col" style="text-align: center;">본사파트ID</th>
                    <th scope="col" style="text-align: center;">본사파트명</th>
                </tr>
<%
    List _dataauthorg = null==userInfo ? null : (List)userInfo.get("dataauthorg"); //권한그룹 정보
    int _dataauthorgCount = null==_dataauthorg ? 0 : _dataauthorg.size();
    for(int i=0; i<_dataauthorgCount; i++) {
        Map<String, Object> dao = (Map<String, Object>)_dataauthorg.get(i);
%>
                <tr>
                    <td><%=dao.get("HDQT_TEAM_ORG_ID")%></td>
                    <td><%=dao.get("HDQT_TEAM_ORG_NM")%></td>
                    <td><%=dao.get("HDQT_PART_ORG_ID")%></td>
                    <td><%=dao.get("HDQT_PART_ORG_NM")%></td>
                </tr>
<%
    }
%>
                </table>
          </td>
        </tr>
        </table>

        <!-- btn area -->
        <div class="btn_area">
          <p class="floatL3">
            <input id="btnConfirm" type="button" data-type="button" value=""  data-theme="af-btn8" >
          </p>
        </div>

    </div>

</div>

</body>
</html>