package com.psnm.dtok.com.auth.biz;

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
 * <li>단위업무명: DAUTHINFO</li>
 * <li>설  명 : 권한그룹과 관련된 각종 조회 처리 클래스</li>
 * <li>작성일 : 2014-12-24 15:43:41</li>
 * <li>작성자 : 안종광 (rhkd)</li>
 * </ul>
 *
 * @author 안종광 (rhkd)
 */
public class DAUTHINFO extends nexcore.framework.coreext.pojo.biz.DataUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public DAUTHINFO(){
		super();
	}

	/**
	 * 지정된 권한그룹의 메뉴 목록조회(TREE)
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-24 16:51:04
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchAuthMenu(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		IRecordSet rs = dbSelect("DAUTHINFO.dSearchAuthMenu", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
		return responseData;
	}

	/**
	 * 권한그룹의 사용자 총수 조회
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-24 16:52:21
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("unchecked")
	public IDataSet dSearchAuthUserCount(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		IRecord map = this.dbSelectSingle("DAUTHINFO.dSearchAuthUserCount", requestData.getFieldMap(), onlineCtx);
		responseData.putFieldMap(map);
	    return responseData;
	}

	/**
	 * 권한그룹의 사용자 목록조회(P페이징)
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-24 16:52:56
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchAuthUser(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		IRecordSet rs = dbSelect("DAUTHINFO.dSearchAuthUser", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
		return responseData;
	}
  
}
