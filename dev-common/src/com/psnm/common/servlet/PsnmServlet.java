package com.psnm.common.servlet;

import java.io.BufferedOutputStream;
import java.io.IOException;
import java.util.Enumeration;
import java.util.List;
import java.util.Locale;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import nexcore.framework.core.Constants;
import nexcore.framework.core.code.ICode;
import nexcore.framework.core.data.user.IUserInfo;
import nexcore.framework.core.log.LogManager;
import nexcore.framework.core.util.BaseUtils;
import nexcore.framework.core.util.StringUtils;
import nexcore.framework.coreext.pojo.biz.base.BizComponentCaller;

import org.apache.commons.logging.Log;

public class PsnmServlet extends HttpServlet {
	private Log logger;
	private String encoding;
	private Locale locale;

	
	/**
	 * 서블릿 초기화
	 */
	public void init(ServletConfig servletConfig) throws ServletException {
		super.init(servletConfig);
		
		//Encoding
		this.encoding = StringUtils.isEmpty(servletConfig.getInitParameter("encoding")) ? 
				"UTF-8" : 
				servletConfig.getInitParameter("encoding");
		
		//Locale
//		this.locale = StringUtils.isEmpty(servletConfig.getInitParameter("locale")) ?
//				BaseUtils.getDefaultLocale() :
//				new Locale (servletConfig.getInitParameter("locale"));
		
		logger = LogManager.getFwkLog();
		
		//BizComponentCaller.callBizComponentByDirect(callerCompFqId, calleeCompObj, methodName, requestData, onlineCtx)
	}
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
		doPost(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
		doRequest(request, response);
	}

	/**
	 * 요청에 대한 처리 수행
	 */
	private void doRequest(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        IUserInfo userInfo = (IUserInfo)session.getAttribute(Constants.USER);

        if ( null==userInfo ) {
        	logger.error("세션정보 없음!");
        	response.sendRedirect("index.jsp");
        	//this.getServletContext().getRequestDispatcher("").forward(request, response);
        }

        this.locale = userInfo == null ? BaseUtils.getDefaultLocale() : userInfo.getLocale();

		Enumeration<String> names = request.getParameterNames();

		//StringBuilder rsetString = null;
		String forwardUrl = null;

		while (names.hasMoreElements()) {
			String paramKey = names.nextElement();
			String paramVal = request.getParameter(paramKey);

			logger.debug("- param[" + paramKey + "] = [" + paramVal + "]");
			System.out.println("- param[" + paramKey + "] = [" + paramVal + "]");

			if ( StringUtils.equals("view", paramKey) ) {
				forwardUrl = "/view/" + paramVal + ".jsp";
				System.out.println("- forwardUrl = [" + forwardUrl + "]");
			}
		}

		try {
			this.getServletContext().getRequestDispatcher(forwardUrl).forward(request, response);
		}
		catch (ServletException e) {
			e.printStackTrace();
			throw new IOException(e.getMessage());
		}
	}

}
