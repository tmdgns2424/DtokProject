package com.psnm.dtok.com.code.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecord;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.exception.BizRuntimeException;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: PCODE</li>
 * <li>설  명 : 공통 코드조회 처리 클래스</li>
 * <li>작성일 : 2014-11-14 11:54:43</li>
 * <li>작성자 : admin (admin)</li>
 * </ul>
 *
 * @author admin (admin)
 */
public class PCODE extends nexcore.framework.coreext.pojo.biz.ProcessUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public PCODE(){
		super();
	}

	/**
	 * 공통코드ID로 해당 코드목록을 조회하여 반환
	 (참고) DEL_YN=Y 제외, 정렬오름차순
	 *
	 * @author admin (admin)
	 * @since 2014-11-14 11:54:43
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchCodes(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();

	    Log log = getLog(onlineCtx);

		String paramCdId = requestData.getField("COMM_CD_ID");
		String[] cdIdList = paramCdId.split(",");
		int len = null==cdIdList ? 0 : cdIdList.length;
		
		StringBuffer respCodeIdList = new StringBuffer();

		for(int i=0; i<len; i++) {
			String commCdId = cdIdList[i];
			if (log.isDebugEnabled()) {
				log.debug("<코드조회> 코드그룹ID = " + commCdId);
			}

			IDataSet paramData = new DataSet();
					 paramData.putField("COMM_CD_ID", commCdId);

			//공통코드 조회 : 공유컴포넌트 호출
			IDataSet resultData = callSharedBizComponentByDirect("com.SHARE", "fSearchCodes", paramData, onlineCtx);
			IRecordSet rs = resultData.getRecordSet("ds");
			if (null!=rs) {
				requestData.putRecordSet(commCdId, rs);
				log.debug("<코드조회> 코드개수 = " + rs.getRecordCount());
			}
			responseData.putRecordSet(commCdId, rs); //공통코드ID를 키로 결과집합을 저장하여 반환

			if ( respCodeIdList.length() > 0 ) {
				respCodeIdList.append(",");
			}
			respCodeIdList.append(commCdId);
		}
		responseData.putField("COMM_CD_ID", respCodeIdList.toString());
	    return responseData;
	}

	/**
	 * 공통코드ID로 해당 코드목록을 조회하여 반환
	 (참고) 이 함수는 pSearchCodes 와 같으나 입력파라미터로 fields 가 아닌 recordSet["CODE_INFO_LIST"] 를 참조함
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-11-14 11:54:43
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchCodesByList(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

	    Log log = getLog(onlineCtx);

		IRecordSet codeInfoList = requestData.getRecordSet("CODE_INFO_LIST");
		int len = null==codeInfoList ? 0 : codeInfoList.getRecordCount();

		if (log.isDebugEnabled()) {
			log.debug("<코드조회2> 조회할 코드그룹ID 개수 : " + len);
		}

		for(int i=0; i<len; i++) {
			IRecord codeInfo = codeInfoList.getRecord(i);
			log.debug("<코드조회> 0. 요청정보 = '" + codeInfo + "' ");
			//System.out.println("<코드조회> 0. 요청정보 = '" + codeInfo + "' ");

			String type   = null; //코드구분 : 디폴트=code, org1=본사팀, org2=본사파트, org3=영업국, org4=영업팀
			try {
				type = codeInfo.get("t"); //코드구분 : 디폴트=code, org1=본사팀, org2=본사파트, org3=영업국, org4=영업팀
			}
			catch (Exception e) {
				type = "code"; //코드구분 : 디폴트=code
			}

			//String elemId = codeInfo.get("elemid"); //(필수) 화면 element ID (필수값으로 응답 recordSet의 키로 사용
			String elemId = null;
			String codeId = null;
			String dtokall = null;

			try { elemId = codeInfo.get("elemid"); } catch (Exception e) { elemId = null; }
			try { codeId = codeInfo.get("codeid"); } catch (Exception e) { codeId = null; }
			try { dtokall = codeInfo.get("dtokall"); } catch (Exception e) { dtokall = null; }

			if ( null==elemId && null==codeId ) { //둘다 null이면 코드를 조회할 수 없음!
				log.warn("<코드조회> 엘레멘트ID, 코드그룹ID가 모두 빈값! skip!");
				continue;
			}
			if (log.isDebugEnabled()) {
				log.debug("<코드조회> 1. 엘레멘트ID = '" + elemId + "', 코드그룹ID = '" + codeId + "' ");
			}

			if ( null!=elemId && null==codeId ) {
				if ( StringUtils.equals("code", type) ) {
					codeId = "DSM_" + elemId; //코드ID 값이 없으면 디폴트 공통코드로 보고 'DSM_'을 접두어로 붙임
				}
			}
			if (log.isDebugEnabled()) {
				log.debug("<코드조회> 2. 코드타입 = '" + type + "', 엘레멘트ID = '" + elemId + "', 코드그룹ID = '" + codeId + "'");
			}

			IDataSet resultData = null; //조회결과 데이터셋
			IRecordSet resultRs = null;
			IDataSet paramData = new DataSet(); //조회조건 데이터셋

			String callFuncName = _get_fmname_by_type(type); //"fSearchCodes"; //디폴트 : code 조회

			if ( StringUtils.equals("org1", type) ) { //A.1 본사팀 (fSearchHdqtTeamOrgId)
				;
			}
			else if ( StringUtils.equals("org2", type) ) { //A.2 본사파트 목록을 조회 (fSearchHdqtPartOrgId)
				paramData.putField("HDQT_TEAM_ORG_ID", codeId); //화면에서 선택된 '본사팀ID' 설정
			}
			else if ( StringUtils.equals("org3", type) ) { //A.3 영업국 목록을 조회 (fSearchSaleDeptOrgId)
				paramData.putField("HDQT_PART_ORG_ID", codeId);
				if ( StringUtils.isNotBlank(dtokall) ) {
					paramData.putField("dtokall", dtokall); //영업국조회시 필요하면 'DTOK_EFF_ORG_YN'='Y' 조건을 제외함(@since 2015-01-29)
				}
			}
			else if ( StringUtils.equals("org4", type) ) { //A.4 영업팀 목록을 조회 (fSearchSaleTeamOrgId)
				paramData.putField("SALE_DEPT_ORG_ID", codeId);
			}
			else if ( StringUtils.equals("org5", type) ) { //A.5 에이전트 목록을 조회 (fSearchSaleAgntOrgId)(@since 2014-12-18)
				paramData.putField("SALE_TEAM_ORG_ID", codeId); //영업팀 조직ID(조건)
			}
			else if ( StringUtils.equals("duty", type) ) { //B. 직무코드목록 조회(fSearchDuty)
				if ( StringUtils.isNotBlank(codeId) ) {
					paramData.putField("USER_TYP", codeId); //사용자유형[공통코드:USER_TYP](조건)
				}
			}
			else {
				paramData.putFieldMap( codeInfo );
				paramData.putField("COMM_CD_ID", codeId); //#공통코드 조회(fSearchCodes) com.SHARE@FCODE_fSearchCodes
			}
			log.info("<코드조회> 코드타입 = '" + type + "', 엘레멘트ID = '" + elemId + "', 코드그룹ID = '" + codeId + "', FM = '" + callFuncName + "'");

			//공유 컴포넌트 호출하여 결과데이터를 수신
			resultData = callSharedBizComponentByDirect("com.SHARE", callFuncName, paramData, onlineCtx);
			resultRs = resultData.getRecordSet("ds");

			if ( null==elemId ) {
				responseData.putRecordSet(codeId, resultRs); //엘레멘트ID가 없으면, 코드ID를 키로 결과집합을 저장하여 반환!
				if (log.isDebugEnabled()) {
					log.debug("<코드조회> 응답 레코드셋키(코드ID) = '" + codeId + "', 코드개수 = " + resultRs.getRecordCount() + "");
				}
			}
			else {
				responseData.putRecordSet(elemId, resultRs); //엘레멘트ID를 키로 결과집합을 저장하여 반환!
				if (log.isDebugEnabled()) {
					log.debug("<코드조회> 응답 레코드셋키(엘레멘트ID) = '" + elemId + "', 코드개수 = " + resultRs.getRecordCount() + "");
				}
			}
		}
	    return responseData;
	}

	private static String _get_fmname_by_type(String type) {
		String callFuncName = "fSearchCodes"; //디폴트 : code 조회

		if ( StringUtils.equals("org1", type) ) { //A.1 본사팀
			callFuncName = "fSearchHdqtTeamOrgId";
		}
		else if ( StringUtils.equals("org2", type) ) { //A.2 본사파트
			callFuncName = "fSearchHdqtPartOrgId";
		}
		else if ( StringUtils.equals("org3", type) ) { //A.3 영업국
			callFuncName = "fSearchSaleDeptOrgId";
		}
		else if ( StringUtils.equals("org4", type) ) { //A.4 영업팀
			callFuncName = "fSearchSaleTeamOrgId";
		}
		else if ( StringUtils.equals("org5", type) ) { //A.5 에이전트 목록을 조회(@since 2014-12-18)
			callFuncName = "fSearchSaleAgntOrgId";
		}
		else if ( StringUtils.equals("duty", type) ) { //B. 직무코드목록 조회
			callFuncName = "fSearchDuty";
		}
		else { //B. 공통코드
			callFuncName = "fSearchCodes";
		}
		return callFuncName;
	}

	/**
	 * 지정된 조직의 하위 조직목록을 조회(입력은 단건으로 필드맵에 { t(조회종류구분), codeid(지정조직ID), elemid(화면요소ID) } 파라미터)
	 
	 (참고) pSearchCodesByList 에서 공통코드와 같이 조회하는 형식에서 조직1건만 조회하는 방법을 추가함.
	 (둘중 어느것을 사용해도 됨. 이 함수는 1개의 지정된 조직에 대한 것만 처리)
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-11-14 11:54:43
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchOrgBySup(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

	    Log log = getLog(onlineCtx);

	    String type = requestData.getField("t"); //org1=본사팀, org2=본사파트, org3=영업국, org4=영업팀
		String elemId = requestData.getField("elemid"); //화면의 element ID, 서버측에서 이값을 사용하지는 않음!
		String codeId = requestData.getField("codeid"); //선택된 조직ID, org1일 경우 빈값 

		if ( StringUtils.isBlank(type) ) type = "org1"; //디폴트 본사팀 목록 조회

		if ( null==elemId && null==codeId ) { //둘다 null!!!
			log.warn("<조직코드조회> 엘레멘트ID, 코드그룹ID가 모두 빈값! skip!");
			throw new BizRuntimeException("PSNM-E001", new String[]{"(원인) 정보부족!"}); //"처리중 오류가 발생하였습니다! {0}"
		}

		IDataSet resultData = null; //조회결과 데이터셋
		IRecordSet resultRs = null;
		IDataSet paramData = new DataSet(); //조회조건 데이터셋

		try {
			if ( StringUtils.equals("org2", type) ) { //A.2 본사파트 목록을 조회 (fSearchHdqtPartOrgId)
				paramData.putField("HDQT_TEAM_ORG_ID", codeId); //화면에서 선택된 '본사팀ID' 설정
			}
			else if ( StringUtils.equals("org3", type) ) { //A.3 영업국 목록을 조회 (fSearchSaleTeamOrgId)
				paramData.putField("HDQT_PART_ORG_ID", codeId);
			}
			else if ( StringUtils.equals("org4", type) ) { //A.4 영업팀 목록을 조회 (fSearchSaleTeamOrgId)
				paramData.putField("SALE_DEPT_ORG_ID", codeId);
			}
			else if ( StringUtils.equals("org5", type) ) { //A.5 에이전트 목록을 조회 (fSearchSaleAgntOrgId)
				paramData.putField("SALE_TEAM_ORG_ID", codeId); //영업팀 조직ID(조건)
			}
			else {
				type = "org1"; //A.1 본사팀 (fSearchHdqtTeamOrgId) ------ default
			}
			String callFuncName = _get_fmname_by_type(type); //"fSearchCodes"; //디폴트 : fSearchHdqtTeamOrgId 조회

			log.info("<조직코드조회> 코드타입 = '" + type + "', 엘레멘트ID = '" + elemId + "', 코드그룹ID = '" + codeId + "', FM = '" + callFuncName + "'");

			//공유 컴포넌트 호출하여 결과데이터를 수신
			resultData = callSharedBizComponentByDirect("com.SHARE", callFuncName, paramData, onlineCtx);
			resultRs = resultData.getRecordSet("ds");

			if ( null==elemId ) {
				responseData.putRecordSet(codeId, resultRs); //엘레멘트ID가 없으면, 조직ID를 키로 결과집합을 저장하여 반환!
			}
			else {
				responseData.putRecordSet(elemId, resultRs); //엘레멘트ID를 키로 결과집합을 저장하여 반환!
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
	 * [PM]조직코드조회(세션없음)
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-01-08 15:42:24
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchOrgByUpper(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		try {
			responseData = callSharedBizComponentByDirect("com.SHARE", "fSearchOrgByUpper", requestData, onlineCtx);
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
	 * [PM]영업국조회 - 본사팀, 본사파트 조건
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-01-12 14:24:07
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSelectSaleDept(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		try {
			responseData = callSharedBizComponentByDirect("com.SHARE", "fSelectSaleDept", requestData, onlineCtx);
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
	 * 본사파트 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-13 10:33:03
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchHdqtPart(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			responseData = callSharedBizComponentByDirect("com.SHARE", "fSearchHdqtPartOrgId", requestData, onlineCtx);
			
			requestData.putRecordSet("grid", responseData.getRecordSet("ds"));
		}
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}
}
