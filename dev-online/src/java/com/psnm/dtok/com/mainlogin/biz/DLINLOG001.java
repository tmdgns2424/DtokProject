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
import nexcore.framework.core.data.user.IUserInfo;
import nexcore.framework.core.exception.BizRuntimeException;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: DLINLOG001</li>
 * <li>설  명 : 로그인, 로그아웃 로그 등록/수정</li>
 * <li>작성일 : 2014-11-21 16:39:13</li>
 * <li>작성자 : 안종광 (rhkd)</li>
 * </ul>
 *
 * @author 안종광 (rhkd)
 */
public class DLINLOG001 extends nexcore.framework.coreext.pojo.biz.DataUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public DLINLOG001(){
		super();
	}

	/**
	 * 로그인로그 등록
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-11-21 16:54:59
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertLog(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		Log log = getLog(onlineCtx);

		Map param = requestData.getFieldMap();
		if (log.isDebugEnabled()) {
			log.debug("[로그인로그등록] 입력파라미터 = " + param);
		}

		int result = dbInsert("DLINLOG001.dInsertLog", param, onlineCtx);

		if (log.isDebugEnabled()) {
			log.debug("[로그인로그등록] 결과 = " + result);
		}
		return responseData;
	}

	/**
	 * 로그아웃시 로그수정
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-11-21 16:55:32
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dUpdateLog(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();

		Log log = getLog(onlineCtx);

		Map param = requestData.getFieldMap();

		if (log.isDebugEnabled()) {
			log.debug("[로그아웃로그수정] 입력파라미터 = " + param);
		}

		int result = dbUpdate("DLINLOG001.dUpdateLog", param, onlineCtx);

		if (log.isDebugEnabled()) {
			log.debug("[로그아웃로그수정] 결과 : " + result);
		}

	    return responseData;
	}
  
}
