package com.psnm.dtok.com.share.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.data.user.UserInfo;
import nexcore.framework.core.exception.BizRuntimeException;

import org.apache.commons.logging.Log;

import com.psnm.common.util.PsnmUtils;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: FCODE</li>
 * <li>설  명 : 공통코드 조회 기능 클래스</li>
 * <li>작성일 : 2014-11-14 11:48:26</li>
 * <li>작성자 : admin (admin)</li>
 * </ul>
 *
 * @author admin (admin)
 */
public class FCODE extends nexcore.framework.coreext.pojo.biz.FunctionUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public FCODE(){
		super();
	}

	/**
	 * 지정된 코드그룹(COMM_CD_ID)의 코드 목록을 조회(조건 = COMM_CD_ID, 사용중인것만)하여 반환
	 (참고) PRT_SEQ 오름차순정렬
	 *
	 * @author admin (admin)
	 * @since 2014-11-14 11:48:26
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchCodes(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
		Log log = getLog(onlineCtx);

		if ( log.isDebugEnabled() ) {
			log.debug("<코드조회> 입력파라미터 정보 ----\n" + requestData);
		}

	    try {
	    	DCODE du = (DCODE) lookupDataUnit(DCODE.class);
		    IRecordSet codeList = du.dSearchCodes(requestData, onlineCtx).getRecordSet("ds");
		    responseData.putRecordSet("ds", codeList);

		    responseData.setOkResultMessage("PSNM-I000", null);
		}
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 직무코드 조회
	 (참고) DUTY_CD (숫자형) 오름차순정렬
	 *
	 * @author admin (admin)
	 * @since 2014-11-14 11:48:26
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchDuty(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
		Log log = getLog(onlineCtx);

		if ( log.isDebugEnabled() ) {
			log.debug("<직무코드조회> 입력파라미터 정보 ---\n" + requestData);
		}

	    try {
	    	DCODE du = (DCODE) lookupDataUnit(DCODE.class);
		    IRecordSet codeList = du.dSearchDuty(requestData, onlineCtx).getRecordSet("ds");
		    responseData.putRecordSet("ds", codeList);

		    responseData.setOkResultMessage("PSNM-I000", null);
		}
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
			//throw new BizRuntimeException("PSNM-E000", e);
	    	throw new BizRuntimeException("PCOM-E001", new String[] {e.getMessage()});
		}

	    return responseData;
	}

	/**
	 * 본사팀을 조회 하는 메소드
	 (참고) 세션의 직무코드(DUTY)를 참조하여, 권한그룹에 '관리자'(01)가 있으면, 전체목록을 조회하고, 없으면 자기의 소속 본사팀 정보만 반환
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-11-14 11:48:26
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchHdqtTeamOrgId(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();

	    Log log = getLog(onlineCtx);
	
	    try {
	    	DCODE du = (DCODE) lookupDataUnit(DCODE.class);

	    	UserInfo userInfo = (UserInfo)onlineCtx.getUserInfo();

	    	//본사팀 조회시 '데이터권한'이 있으면 적용처리함.(없으면 자기 소속 본사팀만 조회됨)
	    	/*@SuppressWarnings("unchecked")
			List<Map<String, Object>> listDataAuth = (List<Map<String, Object>>)userInfo.get("dataauthorg");
	    	int sizeDataAuth = null==listDataAuth ? 0 : listDataAuth.size();
	    	log.info("<본사팀조회> 권한이 있는 본사파트 조직 개수: " + sizeDataAuth);

	    	String[] AUTH_ORGS = null;

	    	if (sizeDataAuth>0) {
	    		AUTH_ORGS = new String[sizeDataAuth];
	    		for(int i=0; i<sizeDataAuth; i++) {
	    			Map<String, Object> daOrg = listDataAuth.get(i);
	    			AUTH_ORGS[i] = (String)daOrg.get("HDQT_TEAM_ORG_ID");
	    			log.info("<본사팀조회> 권한이 있는 본사팀 조직ID : " + AUTH_ORGS[i]);
	    		}
	    		requestData.putField("AUTH_ORGS", AUTH_ORGS); //권한이 있는 본사팀 조직ID
	    	}*/
	    	String[] AUTH_ORGS = PsnmUtils.extractUserDataAuthOrg(userInfo, "HDQT_TEAM_ORG_ID");
	    	requestData.putField("AUTH_ORGS", AUTH_ORGS); //권한이 있는 본사팀 조직ID

			if (log.isDebugEnabled()) {
				log.debug("<본사팀조회> 세션 사용자정보\n" + PsnmUtils.toString(userInfo));
			}

			requestData.putField("S_DUTY",             userInfo.get("DUTY")); //직문코드
			requestData.putField("S_HDQT_TEAM_ORG_ID", userInfo.get("HDQT_TEAM_ORG_ID")); //본사팀 조직ID

	    	responseData = du.dSearchHdqtTeamOrgId(requestData, onlineCtx);
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
	 * 본사파트를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-11-14 11:48:26
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchHdqtPartOrgId(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();

	    Log log = getLog(onlineCtx);

	    try {
	    	DCODE du = (DCODE) lookupDataUnit(DCODE.class);

	    	UserInfo userInfo = (UserInfo)onlineCtx.getUserInfo();

	    	//본사파트 조회시 '데이터권한'이 있으면 적용처리함.(없으면 자기 소속 본사파트만 조회됨)
	    	/*
	    	@SuppressWarnings("unchecked")
			List<Map<String, Object>> listDataAuth = (List<Map<String, Object>>)userInfo.get("dataauthorg");
	    	int sizeDataAuth = null==listDataAuth ? 0 : listDataAuth.size();

	    	String[] AUTH_OUT_ORGS = null;

	    	if (sizeDataAuth>0) {
	    		AUTH_OUT_ORGS = new String[sizeDataAuth];
	    		for(int i=0; i<sizeDataAuth; i++) {
	    			Map<String, Object> daOrg = listDataAuth.get(i);
	    			AUTH_OUT_ORGS[i] = (String)daOrg.get("HDQT_PART_ORG_ID");
	    			log.info("<본사파트조회> 권한이 있는 본사파트 조직ID : " + AUTH_OUT_ORGS[i]);
	    		}
	    		requestData.putField("AUTH_OUT_ORGS", AUTH_OUT_ORGS); //권한이 있는 본사파트 조직ID
	    	}
	    	*/
	    	String[] AUTH_OUT_ORGS = PsnmUtils.extractUserDataAuthOrg(userInfo, "HDQT_PART_ORG_ID");
	    	requestData.putField("AUTH_OUT_ORGS", AUTH_OUT_ORGS); //권한이 있는 본사파트 조직ID

	    	responseData = du.dSearchHdqtPartOrgId(requestData, onlineCtx);
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
	 * 영업국명을 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-11-14 11:48:26
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchSaleDeptOrgId(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	DCODE du = (DCODE) lookupDataUnit(DCODE.class);

	    	UserInfo userInfo = (UserInfo)onlineCtx.getUserInfo();

	    	if ( null != userInfo ) {
		    	responseData.putField("S_DUTY",             userInfo.get("S_DUTY"));           //(세션)직무.사용자타입(TBAS_DUTY_MGMT.USER_TYP)
		    	responseData.putField("S_DUTY_USER_TYP",    userInfo.get("DUTY_USER_TYP"));    //(세션)직무.사용자타입(TBAS_DUTY_MGMT.USER_TYP)
		    	responseData.putField("S_HDQT_TEAM_ORG_ID", userInfo.get("HDQT_TEAM_ORG_ID")); //(세션)본사팀 조직ID
		    	responseData.putField("S_HDQT_PART_ORG_ID", userInfo.get("HDQT_PART_ORG_ID")); //(세션)본사파트 조직ID
	    	}
	    	responseData = du.dSearchSaleDeptOrgId(requestData, onlineCtx);
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
	 * 영업팀명을 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-11-14 11:48:26
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchSaleTeamOrgId(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();

	    try {
	    	DCODE du = (DCODE) lookupDataUnit(DCODE.class);

	    	UserInfo userInfo = (UserInfo)onlineCtx.getUserInfo();

	    	if ( null != userInfo ) {
		    	responseData.putField("S_DUTY",             userInfo.get("S_DUTY"));           //(세션)직무.사용자타입(TBAS_DUTY_MGMT.USER_TYP)
		    	responseData.putField("S_DUTY_USER_TYP",    userInfo.get("DUTY_USER_TYP"));    //(세션)직무.사용자타입(TBAS_DUTY_MGMT.USER_TYP)
		    	responseData.putField("S_HDQT_TEAM_ORG_ID", userInfo.get("HDQT_TEAM_ORG_ID")); //(세션)본사팀 조직ID
		    	responseData.putField("S_HDQT_PART_ORG_ID", userInfo.get("HDQT_PART_ORG_ID")); //(세션)본사파트 조직ID
	    	}

	    	responseData = du.dSearchSaleTeamOrgId(requestData, onlineCtx);
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
	 * 에이전트 목록 조회(select 박스 용)
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-11-14 11:48:26
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchSaleAgntOrgId(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		Log log = getLog(onlineCtx);
		if ( log.isDebugEnabled() ) {
			log.debug("<<에이전트목록조회>> 입력파라미터 ::: " + requestData.getFieldMap());
		}
		try {
			DCODE du = (DCODE) lookupDataUnit(DCODE.class);
			// UserInfo userInfo = (UserInfo)onlineCtx.getUserInfo();
			responseData = du.dSearchSaleAgntOrgId(requestData, onlineCtx);
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
