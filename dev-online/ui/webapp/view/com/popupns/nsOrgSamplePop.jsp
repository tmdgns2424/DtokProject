<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="nexcore.framework.core.Constants"%>
<%@ page import="nexcore.framework.core.code.ICode"%>
<%@ page import="nexcore.framework.core.data.user.IUserInfo"%>
<%@ page import="nexcore.framework.core.util.BaseUtils"%>
<%@ page import="nexcore.framework.online.channel.util.WebUtils"%>
<%
    IUserInfo userInfo = WebUtils.getSessionUserInfo(request);

%>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>비밀번호 변경 - PS&Marketing</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/psnm-ns.js"></script>

    <script type="text/javascript">
    _LOG_LEVEL = 0; //로그레벨 :: 0=debug, 1=info, 2=error

    var _TX_UPDATE_PWD = "com.MAINLOGIN@PLOGIN001_pUpdatePwd";
    var _isValid   = true;
    var _initParam = null;

    $a.page({
        init : function(id, param) {
            _initParam = param;
            _debug('<nsOrgSamplePop> $.alopex.page.init (param) : \n###### ' + JSON.stringify(param));
            $a.page.setEventListener();
            $a.page.setValidators();

            $.PSNMNS.setBasicOrgSelectBox();

            $('#HDQT_TEAM_ORG_ID').focus();
        },
        setEventListener : function() {
            $("#btnCancel").click( closeWithout );
            $("#iconCancel").click( closeWithout );
        },
        setGrid : function() {
        },
        setCodeData : function() {
        },
        setValidators : function() {
        }
    });//end-of-$.alopex.page //-------------------------------------------------------------------------------------------------------//

    function closeWithout() {
        $a.close();
    }

    function closeConfirm() {
        var oReturn = {};
        $a.close(oReturn);
    }

    </script>
</head>

<body>

<div id="Wrap">

<!-- title area -->
<div class="pop_header" ><span class="title">조직 select(세션없음)</span> <a href="#" class="pop_close" onclick="javascript:self.close();"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a9.gif" alt="팝업닫기" ></a> 
  
  <!--view_table area -->
  <div class="textAR">
    <table class="board02" width="100%" >
      <tr>
        <th class="psnm-required" style="width: 180px; " scope="col">HDQT_TEAM_ORG_ID</th>
        <td class="tleft">
            <select id="HDQT_TEAM_ORG_ID" data-type="select" data-bind="options:options_HDQT_TEAM_ORG_ID, selectedOptions:HDQT_TEAM_ORG_ID" style="width:150px;"></select>
        </td>
      </tr>
      <tr>
        <th  scope="col"><span style="">HDQT_PART_ORG_ID</span></th>
        <td class="tleft">
            <select id="HDQT_PART_ORG_ID" data-type="select" data-bind="options:options_HDQT_PART_ORG_ID, selectedOptions:HDQT_PART_ORG_ID" style="width:150px;"></select>
        </td>
      </tr>
      <tr>
        <th  scope="col"><span style="">SALE_DEPT_ORG_ID</span></th>
        <td class="tleft">
            <select id="SALE_DEPT_ORG_ID" data-type="select" data-bind="options:options_SALE_DEPT_ORG_ID, selectedOptions:SALE_DEPT_ORG_ID" style="width:150px;"></select>
        </td>
      </tr>
      <tr>
        <th  scope="col"><span style="">SALE_TEAM_ORG_ID</span></th>
        <td class="tleft">
            <select id="SALE_TEAM_ORG_ID" data-type="select" data-bind="options:options_SALE_TEAM_ORG_ID, selectedOptions:SALE_TEAM_ORG_ID" style="width:150px;"></select>
        </td>
      </tr>
      <tr>
        <th  scope="col"><span style="">SALE_AGNT_ORG_ID</span></th>
        <td class="tleft">
            <select id="SALE_AGNT_ORG_ID" data-type="select" data-bind="options:options_SALE_AGNT_ORG_ID, selectedOptions:SALE_AGNT_ORG_ID" style="width:150px;"></select>
        </td>
      </tr>
    </table>
    <p class="floatL2">
      <input type="button" value="" data-type="button" data-theme="af-btn8">
      <input type="button" value="" data-type="button" data-theme="af-btn10">
    </p>
  </div>
</div>

</div>

</body>
</html>