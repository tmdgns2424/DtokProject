
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

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />
    <script type="text/javascript">
    
    $.alopex.page({

        init : function(id, param) { 
            $a.page.setGrid(); 
            $a.page.setaddgrid();
            $a.page.setEventListener();
            $a.page.setaddgrid();
            pSearchPhrs(param);
        },
        setGrid : function() {
            $("#grid1").alopexGrid({
                pager :false,
                height:200,
                virtualScroll:true,
                rowClickSelect : false,
                rowInlineEdit : true,
                columnMapping : [
                                    {  columnIndex : 0, key : "USER_ID",        	title : "회원ID",			hidden : true  				   },
                                    {  columnIndex : 1, key : "USER_NM",        	title : "회원명",			align: "center", width: "14%"  },
                                    {  columnIndex : 2, key : "HDQT_TEAM_ORG_NM", 	title : "본사팀",			align: "center", width: "14%"  },
                                    {  columnIndex : 3, key : "HDQT_PART_ORG_NM", 	title : "본사파트",		align: "center", width: "14%"  },
                                    {  columnIndex : 4, key : "SALE_DEPT_ORG_NM",   title : "영업국",  		align: "center", width: "14%"  },
                                    {  columnIndex : 5, key : "SALE_TEAM_ORG_NM",   title : "영업팀",			align: "center", width: "15%"  },
                                    {  columnIndex : 6, key : "UPD_DTM",       		title : "열람시간",		align: "center", width: "15%"  },
                ],
            });
        }, 
        setaddgrid : function() {
            $("#grid2").alopexGrid({
                pager: false,
                rowClickSelect : true,
                height : 200,
                columnMapping : [
                                 {  columnIndex : 0, key : "USER_ID",        	title : "회원ID",			hidden : true  				   },
                                 {  columnIndex : 1, key : "USER_NM",        	title : "회원명",			align: "center", width: "14%"  },
                                 {  columnIndex : 2, key : "HDQT_TEAM_ORG_NM", 	title : "본사팀",			align: "center", width: "14%"  },
                                 {  columnIndex : 3, key : "HDQT_PART_ORG_NM",	title : "본사파트",		align: "center", width: "14%"  },
                                 {  columnIndex : 4, key : "SALE_DEPT_ORG_NM",	title : "영업국",  		align: "center", width: "14%"  },
                                 {  columnIndex : 5, key : "SALE_TEAM_ORG_NM",  title : "영업팀",			align: "center", width: "15%"  },
                                 {  columnIndex : 6, key : "UPD_DTM",       	title : "보낸시간",		align: "center", width: "15%"  },
                ],
            });
        }, 
        setEventListener : function() {
            $("#btnConfirm").click(function(){
                $a.close();
            });
        }
    });
    function pSearchPhrs(param) {
        $.alopex.request("com.PAPER@PPAPERMGMT001_pSearchOpend", {    
               data: {dataSet: {fields: {IS_OPEND :"Y", PAPER_ID : param.PAPER_ID}}},
            success: '#grid1'
        });
        $.alopex.request("com.PAPER@PPAPERMGMT001_pSearchOpend", {
            data: {dataSet: {fields: {IS_OPEND :"N", PAPER_ID : param.PAPER_ID}}},
            success: '#grid2'
        });
    }
    </script>
</head>
<body style="max-height: 500px">
<div id="Wrap">
    <div class="pop_header" >
        <div class="textAR">

        <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>열람 회원 목록</b></div>

        <!-- dataGrid start -->
        <div id="grid1" data-bind="grid:grid1" ></div>
        <!-- //dataGrid end -->         
            <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>미열람 회원 목록</b></div>
        <!-- dataGrid start -->
        <div id="grid2" data-bind="grid:grid2" ></div>

        <!-- //dataGrid end -->      
        </div>
    </div>
</div>
</body>
</html>


