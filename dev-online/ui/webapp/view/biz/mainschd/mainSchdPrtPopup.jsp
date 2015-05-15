<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="nexcore.framework.core.util.BaseUtils"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />
<%
	String server = BaseUtils.getConfiguration("oz.server");
%>
    <script type="text/javascript">
    var _param;
    
    $.alopex.page({

        init : function(id, param) { 
    	  	$a.page.excuteOzReport( param );    	 
        },
        excuteOzReport : function( param ) {
    		var SCH_ID        = param.SCH_ID;
    		var reprotpullname      = null;
    		var odinames            = null;

   			reprotpullname = "DTOK/mainSchdReport.ozr"; 
   			odinames = "mainSchdReport";

    	    // report viewer install
			var installTag = "<object id='ZTransferX' width='0' height='0' classid='CLSID:C7C7225A-9476-47AC-B0B0-FF3B79D55E67' codebase='<%=server%>/oz60/ozrviewer/ZTransferX.cab#version=2,2,4,9'>"
			                 + "<param name='download.server' value='<%=server%>/oz60/ozrviewer/'>"
			                 + "<param name='download.instruction' value='ozrviewer.idf'>"
			                 + "<param name='install.base' value='<PROGRAMS>/Forcs'>"
			                 + "<param name='install.namespace' value='dtok'></object>";
			document.write( installTag );
    	    
    	    var viewerTag = "<object id='OZReportViewer' classid='CLSID:0DEF32F8-170F-46f8-B1FF-4BF7443F5F25' width='100%' height='100%'>"
    	                    + "<param name='connection.servlet'  value='<%=server%>/oz60/server'>"
    	                    + "<param name='connection.reportname' value='"+reprotpullname+"'>"
    	                    + "<param name='viewer.isframe' value='false'>"
    	                    + "<param name='odi.odinames' value='"+odinames+"'>"
    	                    + "<param name='odi."+odinames+".pcount' value='4'>"
    		                + "<param name='odi."+odinames+".args1' value='SCH_ID="+SCH_ID+"''>"
    	                    + "</object>";
    	    document.write( viewerTag );
        }, 
        
    });
    </script>

</head>

<body style='height:100%'>
	<div id="InstallOZViewer" style='width:0px; height:0px'>
	</div>
	<div id="RunOZViewer" style='width:100%; height:100%'>
	</div>
</body>
</html>