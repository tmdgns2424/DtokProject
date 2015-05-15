package com.psnm.dtok.com.mainlogin.biz;

import java.util.Map;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.exception.BizRuntimeException;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;

import com.psnm.common.util.PsnmUtils;


/**
 * <ul>
 * <li>업무 그룹명 : </li>
 * <li>단위업무명: DMENU001</li>
 * <li>설  명 : 로그인 사용자의 메뉴목록 조회</li>
 * <li>작성일 : 2014-11-20 16:48:40</li>
 * <li>작성자 : admin (admin)</li>
 * </ul>
 *
 * @author admin (admin)
 */
public class DMENU001 extends nexcore.framework.coreext.pojo.biz.DataUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public DMENU001(){
		super();
	}

	/**
	 * 상위 메뉴ID로 메뉴 목록 조회
	 *
	 * @author admin (admin)
	 * @since 2014-11-20 16:58:58
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchMenuBySup(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

	    Log log = getLog(onlineCtx);
	    log.debug("[하위메뉴목록] 검색조건(필드맵) :: " + requestData.getFieldMap());

		IRecordSet rs = dbSelect("DMENU001.dSearchMenuBySup", requestData.getFieldMap(), onlineCtx);

		if (rs == null)
			throw new BizRuntimeException("MSTAE00001");

		if (rs != null && rs.getRecordCount() > 0) {
			log.debug("[하위메뉴목록] 1번째 레코드 : " + rs.getRecord(0) + "");
		}
		responseData.putRecordSet("ds", rs);

		return responseData;
	}

	/**
	 * 최상위메뉴ID(0000) 또는 지정된 (탑)메뉴ID로 [사용자]별 하위 메뉴 TREE 조회
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-11-20 16:48:40
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchMenuTree(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

		String userId = requestData.getField("USER_ID");
	    if ( StringUtils.isBlank(userId) ) {
	    	requestData.putField("USER_ID", onlineCtx.getUserInfo().getLoginId());
	    }

	    Map<String, Object> param = requestData.getFieldMap();
	    param.put("USER_ID", onlineCtx.getUserInfo().getLoginId());

		IRecordSet rs = dbSelect("DMENU001.dSearchMenuTreeBySup", requestData.getFieldMap(), onlineCtx);
		
		//----------------------------------------------------------------------------------------//
		//DSM 국장 접속시 부산, 대구 등 지방 조직 메뉴명 안보이게 //@since 2015-03-17
		/*
		String duty = PsnmUtils.getSessionValue(onlineCtx, "DUTY"); //직무코드(01~20)
		int iDuty = 0; //직무코드(정수형)
		try {
			iDuty = Integer.parseInt(duty);
		}
		catch (Exception e) {
			iDuty = 0;
		}

		if ( 14<=iDuty ) { //DSM 국장 이하 ...
		*/
		if ( !PsnmUtils.isEmployee(onlineCtx) ) { //ATTC_CAT = 1,2,3 이면 '임직원', 4= 외부사용자 DUTY_USER_TYP와 코드같음
			String partOrgId = PsnmUtils.getSessionValue(onlineCtx, "HDQT_PART_ORG_ID"); //소속 본사파트조직ID
			int size = null==rs ? 0 : rs.getRecordCount();

			//(예)5102 | DSM대구 | com/bltnbrd/bltnBrdList.jsp?FLAG=1003&OO=02 | 5100 | 게시판 | 3 | 3 | N001 | N | A | N | W
			for(int I=size-1; I>=0; I--) {
				String supMenuId = (String)rs.get(I, "SUP_MENU_ID");
				if ( !StringUtils.equals("5100", supMenuId) )
					continue;

				StringBuffer sb = new StringBuffer();

				String menuUrl = (String)rs.get(I, "MENU_URL");
				int idx = menuUrl.indexOf("OO=");
				sb.append("- MENU_URL = [").append(menuUrl).append("], indexOf(OO=) = ").append(idx);

				if ( idx>0 ) {
					String menuOOid = menuUrl.substring( idx+3 ); sb.append(", OO = [").append(menuOOid).append("]");
					if ( ! StringUtils.equals(partOrgId, menuOOid) ) {
						rs.removeRecord(I);
						sb.append(", ROW[").append(I).append("] removed!");
					}
				}
				sb.append(", curr row length = ").append( rs.getRecordCount() ).append(".");
				//System.out.println(sb.toString());
			}
		}
		
		//----------------------------------------------------------------------------------------//
		responseData.putRecordSet("ds", rs);

		return responseData;
	}
  
}
