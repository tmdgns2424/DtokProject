package com.psnm.dtok.com.share.biz;

import org.apache.commons.logging.Log;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecord;
import nexcore.framework.core.data.IRecordSet;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: DMISC</li>
 * <li>설  명 : [DU]기타관리</li>
 * <li>작성일 : 2015-01-14 11:09:38</li>
 * <li>작성자 : 안종광 (rhkd)</li>
 * </ul>
 *
 * @author 안종광 (rhkd)
 */
public class DMISC extends nexcore.framework.coreext.pojo.biz.DataUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public DMISC(){
		super();
	}

	/**
	 * [DM]열람자등록|갱신
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-01-14 11:20:01
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dMergeReadrMgmt(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		int result = dbInsert("DMISC.dMergeReadrMgmt", requestData.getFieldMap(), onlineCtx);
		responseData.putField("result", result);
		return responseData;
	}

	/**
	 * [DM]주간날짜정보조회
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-03-12 16:30:45
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("unchecked")
	public IDataSet dSearchWeekDayInfo(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		IRecord record = dbSelectSingle("DMISC.dSearchWeekDayInfo", requestData.getFieldMap(), onlineCtx);
		responseData.putFieldMap(record);
		return responseData;
	}
  
}
