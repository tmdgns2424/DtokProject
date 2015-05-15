package com.psnm.dtok.com.share.biz;

import java.util.Calendar;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.data.user.UserInfo;
import nexcore.framework.core.exception.BizRuntimeException;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;

import com.ibm.icu.util.ChineseCalendar;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: FMISC</li>
 * <li>설  명 : [FU]기타관리</li>
 * <li>작성일 : 2015-01-14 11:21:05</li>
 * <li>작성자 : 안종광 (rhkd)</li>
 * </ul>
 *
 * @author 안종광 (rhkd)
 */
public class FMISC extends nexcore.framework.coreext.pojo.biz.FunctionUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public FMISC(){
		super();
	}

	/**
	 * 필드맴에서 컨텐츠ID값을 조회하여 반환.READ_MGMT_ID
	 * (주의) 여러개의 컨텐츠ID가 있다면 영문사전상 가장뒤의 컨텐츠ID가 선택됨
	 * 
	 * @param requestData
	 * @return
	 */
	private String getReadMgmtId(IDataSet requestData) {
		String readMgmtId = null;

		if ( requestData.containsField("ANNCE_ID") ) readMgmtId = requestData.getField("ANNCE_ID"); //DSM_ANNCE
		if ( requestData.containsField("FAQ_ID") ) readMgmtId = requestData.getField("FAQ_ID"); //DSM_FAQ
		if ( requestData.containsField("ISS_ID") ) readMgmtId = requestData.getField("ISS_ID"); //DSM_ISSUE
		if ( requestData.containsField("DSM_SALES_PLCY_ID") ) readMgmtId = requestData.getField("DSM_SALES_PLCY_ID"); //DSM_SALES_PLCY
		if ( requestData.containsField("BIZ_ID") ) readMgmtId = requestData.getField("BIZ_ID"); //DSM_BIZTRGT
		if ( requestData.containsField("SCH_ID") ) readMgmtId = requestData.getField("SCH_ID"); //DSM_SCHMGMT
		if ( requestData.containsField("BLTCONT_ID") ) readMgmtId = requestData.getField("BLTCONT_ID"); //DSM_BLTCONT, DSM_P2P_CNSL
/*		
		if ( requestData.containsField("BLTCONT_ID") ) atchMgmtId = requestData.getField("BLTCONT_ID"); //DSM_BLTCONT, DSM_P2P_CNSL
		if ( requestData.containsField("PAPER_ID") ) atchMgmtId = requestData.getField("PAPER_ID"); //DSM_RCV_PAPER, DSM_SND_PAPER
		if ( requestData.containsField("DSM_SALES_PLCY_ID") ) atchMgmtId = requestData.getField("DSM_SALES_PLCY_ID"); //DSM_SALES_PLCY
*/
		return readMgmtId;
	}

	/**
	 * [FM]열람자등록|갱신
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-01-14 11:21:05
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fMergeReadrMgmt(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		Log log = getLog(onlineCtx);

		if ( log.isDebugEnabled() ) {
			log.debug("<열람자등록|갱신> 입력파라미터 정보 :: " + requestData.getFieldMap());
		}

		UserInfo userInfo = (UserInfo)onlineCtx.getUserInfo();
		String userId = null==userInfo ? null : userInfo.getLoginId();
		if (null==userId || StringUtils.equalsIgnoreCase("Anonymous", userId)) {
			responseData.setOkResultMessage("PSNM-I001", new String[]{"(참고) 세션 사용자정보 없음!"});
			return responseData;
		}

	    try {
	    	DMISC du = (DMISC) lookupDataUnit(DMISC.class);

	    	String flag = requestData.getField("DSM_BRD_FLAG"); //해당페이지의 권한 플래그 : R|W
	    	String userType = (String)userInfo.get("DUTY_USER_TYP"); //로그인 사용자의 '사용자구분' 값
	    	String readMgmtId = requestData.getField("READ_MGMT_ID"); 

	    	if ( null==readMgmtId || StringUtils.isBlank(readMgmtId) ) {
	    		//열람관리ID(READ_MGMT_ID) 가 없으면 컨텐츠ID 값으로 설정
	    		readMgmtId = this.getReadMgmtId(requestData);
	    		requestData.putField("READ_MGMT_ID", readMgmtId);
	    	}

	    	if ( StringUtils.equals("R", flag) ) {
	    		if ( !(StringUtils.equals("1", userType) || StringUtils.equals("2", userType)) ) {
	    			du.dMergeReadrMgmt(requestData, onlineCtx);
	    		}
	    		else {
	    			log.info("<열람자등록|갱신> 임직원은 열람정보를 저장하지 않음. 사용자구분 = " + userType);
	    		}
	    	}
	    	else {
	    		log.info("<열람자등록|갱신> 쓰기권한인 경우 열람정보 저장하지 않음. DSM_BRD_FLAG = " + flag);
	    	}
		}
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	    responseData.setOkResultMessage("PSNM-I000", null);
	    return responseData;
	}

	/**
	 * [FM]주간날짜정보조회
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-03-12 16:31:15
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchWeekDayInfo(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		Log log = getLog(onlineCtx);

		if ( log.isDebugEnabled() ) {
			log.debug("<주간날짜조회> 입력파라미터 정보 :: " + requestData.getFieldMap());
		}

	    try {
	    	DMISC du = (DMISC) lookupDataUnit(DMISC.class);
	    	
	    	int dayOffset = 0;
	    	try {
	    		dayOffset = Integer.parseInt(requestData.getField("DAY_OFFSET"));
	    	}
	    	catch(Exception e) {
	    		dayOffset = 0;
	    	}

	    	Calendar cal = Calendar.getInstance();
	    	ChineseCalendar chCal = new ChineseCalendar();

	    	cal.add(Calendar.DATE, dayOffset);

	    	chCal.setTimeInMillis(cal.getTimeInMillis());

	    	int chYear  = chCal.get(ChineseCalendar.EXTENDED_YEAR)-2637;
	    	int chMonth = 1 + chCal.get(ChineseCalendar.MONTH);
	    	int chDate  = chCal.get(ChineseCalendar.DAY_OF_MONTH);

	    	StringBuffer chMd = new StringBuffer();
	    	chMd.append(chMonth<10? "0" : "").append(chMonth).append(chDate<10? "0" : "").append(chDate);

	    	requestData.putField("LUNAR_MMDD", chMd.toString());

	    	//생일자 목록 조회
	    	responseData = du.dSearchWeekDayInfo(requestData, onlineCtx); //.getRecordSet("ds");

	    	responseData.putField("LUNAR_YEAR",  chYear);
	    	responseData.putField("LUNAR_MONTH", chMonth);
	    	responseData.putField("LUNAR_DATE",  chDate);
	    	responseData.putField("LUNAR_YMD",  "" + chYear + chMd.toString());
		}
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	    responseData.setOkResultMessage("PSNM-I000", null);
	    return responseData;
	}
  
}
