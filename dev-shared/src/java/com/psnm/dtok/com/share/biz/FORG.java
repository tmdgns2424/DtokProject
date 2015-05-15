package com.psnm.dtok.com.share.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.data.user.UserInfo;
import nexcore.framework.core.exception.BizRuntimeException;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: FORG</li>
 * <li>설  명 : [FU]조직정보조회</li>
 * <li>작성일 : 2015-01-08 16:12:45</li>
 * <li>작성자 : 안종광 (rhkd)</li>
 * </ul>
 *
 * @author 안종광 (rhkd)
 */
public class FORG extends nexcore.framework.coreext.pojo.biz.FunctionUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public FORG(){
		super();
	}

	/**
	 * 상위조직코드 정보 조건으로 조직정보조회(세션없음)
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-01-08 16:13:56
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchOrgByUpper(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

	    Log log = getLog(onlineCtx);

	    String type = requestData.getField("type"); //org1=본사팀, org2=본사파트, org3=영업국, org4=영업팀
		String elemId = requestData.getField("elemid"); //화면의 element ID, 서버측에서 이값을 사용하지는 않음!

		if ( StringUtils.isBlank(type) ) type = "org1"; //디폴트 본사팀 목록 조회
		if ( StringUtils.isBlank(elemId) ) type = "HDQT_TEAM_ORG_ID"; //디폴트 본사팀ID 조회

    	UserInfo userInfo = (UserInfo)onlineCtx.getUserInfo();

		if (log.isDebugEnabled()) {
			log.debug("<<조직코드조회(세션없음)>> 세션 사용자ID : " + userInfo.getLoginId()); //로그인ID는 직접 참조
		}

		IRecordSet resultRs = null;

		try {
			DORG du = (DORG) lookupDataUnit(DORG.class);

			if ( StringUtils.equals("org2", type) ) { //A.2 본사파트 목록을 조회
				resultRs = du.dSearchHdqtPartOrgId2(requestData, onlineCtx).getRecordSet("ds");
			}
			else if ( StringUtils.equals("org3", type) ) { //A.3 영업국 목록을 조회
				resultRs = du.dSearchSaleDeptOrgId2(requestData, onlineCtx).getRecordSet("ds");
			}
			else if ( StringUtils.equals("org4", type) ) { //A.4 영업팀 목록을 조회 (fSearchSaleTeamOrgId)
				resultRs = du.dSearchSaleTeamOrgId2(requestData, onlineCtx).getRecordSet("ds");
			}
			else if ( StringUtils.equals("org5", type) ) { //A.5 에이전트 목록을 조회 
				resultRs = du.dSearchSaleAgntOrgId2(requestData, onlineCtx).getRecordSet("ds");
			}
			else {
				resultRs = du.dSearchHdqtTeamOrgId2(requestData, onlineCtx).getRecordSet("ds");
			}
			log.info("<<조직코드조회(세션없음)>> 코드타입 = '" + type + "', 엘레멘트ID = '" + elemId + "'");

			responseData.putRecordSet(elemId, resultRs); //엘레멘트ID를 키로 결과집합을 저장하여 반환!
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
	 * [FM]영업국조회 - 본사팀, 본사파트 조건
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-01-12 14:19:06
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSelectSaleDept(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
	    Log log = getLog(onlineCtx);
	    if ( log.isDebugEnabled() ) {
	    	log.debug("<<영업국조회>> 입력파라미터 : " + requestData.getFieldMap() + "");
	    }

		IRecordSet resultRs = null;

		try {
			DORG du = (DORG) lookupDataUnit(DORG.class);

			resultRs = du.dSelectSaleDept(requestData, onlineCtx).getRecordSet("ds");
			log.info("<<영업국조회>> 조회결과건수 = " + (null==resultRs ? -1 : resultRs.getRecordCount()) + ""); //

			responseData.putRecordSet("griddept", resultRs);
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
