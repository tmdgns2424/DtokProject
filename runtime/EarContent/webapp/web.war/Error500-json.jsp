<%@page contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" 
%><%@page import="nexcore.framework.core.ioc.ComponentRegistry"
%><%@page import="nexcore.framework.core.Constants"
%><%@page import="nexcore.framework.core.util.BaseUtils"
%><%@page import="nexcore.framework.core.ServiceConstants"
%><%@page import="nexcore.framework.core.data.json.*"
%><%@page import="nexcore.framework.core.data.IResultMessage"
%><%@page import="nexcore.framework.core.message.IMessageManager"
%><%@page import="nexcore.framework.core.message.IMessage"
%><%@page import="nexcore.framework.core.prototype.IMessageCoded"
%><%@page import="nexcore.framework.online.channel.util.WebUtils"
%><%@page import="net.sf.json.util.JSONUtils"
%><%
    Throwable cause = (Throwable) request.getAttribute("javax.servlet.error.exception");
    
    if (cause == null) {
        cause = (Throwable) request.getAttribute("javax.servlet.jsp.jspException");
    }
    
    if (cause == null) {
        cause = (Throwable) request.getAttribute("nexcore.bizlogic.exception");
    }
    
    String messageId = "N/A";
    String messageName =  "N/A";
    String reason = "N/A";
    String remark = "N/A";
    String stackTrace = "N/A";
    
    IMessageManager mm = (IMessageManager) ComponentRegistry.lookup(ServiceConstants.MESSAGE);
    if (cause instanceof IMessageCoded){
        IMessageCoded imc = ((IMessageCoded)cause);
        messageId = imc.getMessageId();
        IMessage message = mm.getMessage(messageId, WebUtils.getLocale(pageContext));
        messageName = message.getName(imc.getMessageParams());
        reason = message.getReason();
        remark = message.getRemark();
    }
    if (cause != null) {
        if (cause instanceof javax.servlet.jsp.JspException) {
            Throwable jspCause = ((javax.servlet.jsp.JspException)cause).getRootCause();
            if (jspCause != null) {
                cause = jspCause;
            }
        }
    }
    if (cause != null){
        stackTrace = BaseUtils.getExceptionStackTrace(cause);
    }

    // print 
	out.println("{");
	out.println("\t" + JSONUtils.quote(JsonProcessor.ELM_TX) + ": {" + JSONUtils.quote(JsonProcessor.ELM_TX_ID) + ": " + JSONUtils.quote("") + "},");
	out.println("\t" + JSONUtils.quote(JsonProcessor.ELM_DS) + ": {");
	out.println("\t\t" + JSONUtils.quote(JsonProcessor.ELM_DS_MSG) + ": {");
	out.println("\t\t\t" + JSONUtils.quote(JsonProcessor.ELM_DS_MSG_RESULT) + ": " + JSONUtils.quote(IResultMessage.STR_FAIL) + ",");
	out.println("\t\t\t" + JSONUtils.quote(JsonProcessor.ELM_DS_MSG_ID) + ": " + JSONUtils.quote(messageId == null ? "" : messageId) + ",");
	out.println("\t\t\t" + JSONUtils.quote(JsonProcessor.ELM_DS_MSG_NAME) + ": " + JSONUtils.quote(messageName == null ? "" : messageName));
	out.println("\t\t}");
	out.println("\t}");
	out.println("}");
%>