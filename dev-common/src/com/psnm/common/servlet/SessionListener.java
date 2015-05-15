package com.psnm.common.servlet;

import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;
import javax.sql.DataSource;

import nexcore.framework.core.Constants;
import nexcore.framework.core.data.user.IUserInfo;

public class SessionListener implements HttpSessionListener {

	public void sessionCreated(HttpSessionEvent se) {
		
	}

	//세션 생성 감지
	public synchronized void sessionDestroyed(HttpSessionEvent se) {
		
		HttpSession aSession = se.getSession();
		
		IUserInfo userInfo = (IUserInfo)aSession.getAttribute(Constants.USER);
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		String sql = "UPDATE DSM_LIN_LOG SET LOGOUT_DTM = SYSDATE WHERE LOGOUT_DTM IS NULL AND SUCC_YN = 'Y' AND USER_ID = ? ";
		
		try {
			
			Context ctx = new InitialContext();
			DataSource ds = (DataSource)ctx.lookup("jdbc/BizDS");
			conn = ds.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userInfo.getLoginId());
			pstmt.executeUpdate();
			
			conn.commit();
			
		} catch(Exception e){
			e.printStackTrace();
		} finally {
			try{
				if( pstmt != null ) pstmt.close();
				if( conn != null ) conn.close();
			}catch(Exception ex){
				ex.printStackTrace();
			}
		}
		
	}
	
}
