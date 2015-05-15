package com.psnm.dtok.com.share.biz;

import java.util.Map;

import org.apache.commons.logging.Log;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecord;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.data.IResultMessage;
import nexcore.framework.core.data.ResultMessage;
import nexcore.framework.core.data.user.UserInfo;
import nexcore.framework.core.exception.BizRuntimeException;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: DCODE</li>
 * <li>설  명 : 공통코드 조회 전용 DAO 클래스</li>
 * <li>작성일 : 2014-11-14 11:20:49</li>
 * <li>작성자 : admin (admin)</li>
 * </ul>
 *
 * @author admin (admin)
 */
public class DCODE extends nexcore.framework.coreext.pojo.biz.DataUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public DCODE(){
		super();
	}

	/**
	 * 지정된 코드그룹(COMM_CD_ID)의 코드 목록을 조회(조건 = COMM_CD_ID, 사용중인것만)하여 반환
	 (참고) PRT_SEQ 오름차순정렬
	 *
	 * @author admin (admin)
	 * @since 2014-11-14 11:20:49
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchCodes(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

		Log log = getLog(onlineCtx);
		if ( log.isDebugEnabled() ) {
			log.debug("[코드조회] 입력파라미터 : " + requestData.getFieldMap() );
		}

	    IRecordSet rs = dbSelect("DCODE.dSearchCodes", requestData.getFieldMap(), onlineCtx);

		responseData.putRecordSet("ds", rs);

		return responseData;
	}

	/**
	 * 직무코드 정보 조회
	 *
	 * @author admin (admin)
	 * @since 2014-11-18 16:33:13
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchDuty(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

		Log log = getLog(onlineCtx);
		if ( log.isDebugEnabled() ) {
			log.debug("[직무코드조회] 입력파라미터 : " + requestData.getFieldMap() );
		}

	    IRecordSet rs = dbSelect("DCODE.dSearchDuty", requestData.getFieldMap(), onlineCtx);

		responseData.putRecordSet("ds", rs);

		return responseData;
	}

	/**
	 * 본사팀을 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-11-14 11:20:49
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchHdqtTeamOrgId(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();

	    Log log = getLog(onlineCtx);
    	UserInfo userInfo = (UserInfo)onlineCtx.getUserInfo();

		if (log.isDebugEnabled()) {
			log.debug("<조직조회> 조회조건 : " + requestData.getFieldMap());
			log.debug("<조직조회> 세션 DUTY = '" + userInfo.get("DUTY") + "'"); //직무구분
		}

	    IRecordSet rs = dbSelect("DCODE.dSearchHdqtTeamOrgId", requestData.getFieldMap(), onlineCtx);

		responseData.putRecordSet("ds", rs);
	
	    return responseData;
	}

	/**
	 * 본사파트를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-11-14 11:20:49
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchHdqtPartOrgId(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DCODE.dSearchHdqtPartOrgId", requestData.getFieldMap(), onlineCtx);

		responseData.putRecordSet("ds", rs);
	
	    return responseData;
	}

	/**
	 * 영업국명을 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-11-14 11:20:49
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchSaleDeptOrgId(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DCODE.dSearchSaleDeptOrgId", requestData.getFieldMap(), onlineCtx);

		responseData.putRecordSet("ds", rs);
	
	    return responseData;
	}

	/**
	 * 영업팀명을 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-11-14 11:20:49
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchSaleTeamOrgId(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DCODE.dSearchSaleTeamOrgId", requestData.getFieldMap(), onlineCtx);

		responseData.putRecordSet("ds", rs);
	
	    return responseData;
	}

	/**
	 * 에이전트목록조회
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-18 19:30:27
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchSaleAgntOrgId(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
	    IRecordSet rs = dbSelect("DCODE.dSearchSaleAgntOrgId", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
	    return responseData;
	}
  
}
