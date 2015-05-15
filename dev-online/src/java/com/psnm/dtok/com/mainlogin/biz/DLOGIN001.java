package com.psnm.dtok.com.mainlogin.biz;

import java.util.Map;

import org.apache.commons.logging.Log;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecord;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.data.IResultMessage;
import nexcore.framework.core.data.ResultMessage;
import nexcore.framework.core.exception.BizRuntimeException;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: DLOGIN001</li>
 * <li>설  명 : 로그인 로그아웃 처리 DU</li>
 * <li>작성일 : 2014-11-19 15:10:35</li>
 * <li>작성자 : admin (admin)</li>
 * </ul>
 *
 * @author admin (admin)
 */
public class DLOGIN001 extends nexcore.framework.coreext.pojo.biz.DataUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public DLOGIN001(){
		super();
	}

	/**
	 * 사용자ID로 사용자정보 조회 
	 *
	 * @author admin (admin)
	 * @since 2014-11-19 15:26:37
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("unchecked")
	public IDataSet dSearchLogin(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
		IRecord map = this.dbSelectSingle("DLOGIN001.dSearchLogin", requestData.getFieldMap(), onlineCtx);
		responseData.putFieldMap(map);
	    return responseData;
	}

	/**
	 * 로그인실패회수를 초기화(0)하거나 +1 갱신
	 *
	 * @author admin (admin)
	 * @since 2014-11-20 14:07:32
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dUpdateFailCnt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();

		Log log = getLog(onlineCtx);

		int result = dbUpdate("DLOGIN001.dUpdateFailCnt", requestData.getFieldMap(), onlineCtx);

		if (log.isDebugEnabled()) {
			log.debug("[로그인실패회수수정] 결과 : " + result);
		}

	    return responseData;
	}

	/**
	 * 비밀번호변경
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-19 11:36:13
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dUpdatePwd(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		int result = dbUpdate("DLOGIN001.dUpdatePwd", requestData.getFieldMap(), onlineCtx);
		responseData.putField("result", result);
	    return responseData;
	}

	/**
	 * [DM]회원권한그룹조회 - 로그인회원의 직무에 따른 권한그룹 목록 조회
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-01-15 14:27:01
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchUserAuthGrpByDuty(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		IRecordSet rs = this.dbSelect("DLOGIN001.dSearchUserAuthGrpByDuty", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
	    return responseData;
	}

	/**
	 * [DM]회원데이터권한조직조회 : 로그인회원의 소속 '본사파트'와 등록된 권한'본사파트' 정보를 조회
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-01-15 15:04:56
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchUserDataAuthOrg(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		IRecordSet rs = this.dbSelect("DLOGIN001.dSearchUserDataAuthOrg", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
	    return responseData;
	}

	/**
	 * [DM]최근로그인로그조회
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-04-22 17:33:10
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchRecentLoginLog(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		IRecordSet rs = this.dbSelect("DLOGIN001.dSearchRecentLoginLog", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-05-04 10:02:12
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchIsRecentPwd(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    responseData.putFieldMap( dbSelectSingle("DLOGIN001.dSearchIsRecentPwd", requestData.getFieldMap(), onlineCtx) );
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-05-04 10:02:27
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertPwdChgHst(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    dbInsert("DLOGIN001.dInsertPwdChgHst", requestData.getFieldMap(), onlineCtx);
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-05-12 10:54:09
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dUpdateLogout(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
		
	    int result = dbUpdate("DLOGIN001.dUpdateLogout", requestData.getFieldMap(), onlineCtx);
		responseData.putField("result", result);

		return responseData;
	}

}
