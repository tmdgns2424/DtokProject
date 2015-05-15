package com.psnm.dtok.com.userstrct.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: [DU]모드관리</li>
 * <li>설  명 : </li>
 * <li>작성일 : 2015-01-27 09:52:31</li>
 * <li>작성자 : 이승훈2 (gunyoung)</li>
 * </ul>
 *
 * @author 이승훈2 (gunyoung)
 */
public class DUSERSTRCT001 extends nexcore.framework.coreext.pojo.biz.DataUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public DUSERSTRCT001(){
		super();
	}

	/**
	 *
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-27 09:52:31
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
		public IDataSet dSearchUseRstrctMgmt(IDataSet requestData, IOnlineContext onlineCtx) {
		    IDataSet responseData = new DataSet();
		    IRecordSet rs = dbSelect("DUSERSTRCT001.dSearchUseRstrctMgmt", requestData.getFieldMap(), onlineCtx);
			
			
		    responseData.putRecordSet("grid", rs); 
		    
		    return responseData;
		}

	/**
	 *
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-27 09:52:31
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
		public IDataSet dSearchDay(IDataSet requestData, IOnlineContext onlineCtx) {
		    IDataSet responseData = new DataSet();
			
		    IRecordSet rs = dbSelect("DUSERSTRCT001.dSearchDay", requestData.getFieldMap(), onlineCtx);
			responseData.putRecordSet("ds", rs);
		
		    return responseData;
		}

	/**
	 *
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-27 09:52:31
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
		@SuppressWarnings("unchecked")
		public IDataSet dSearchToDay(IDataSet requestData, IOnlineContext onlineCtx) {
		    IDataSet responseData = new DataSet();
		
		    responseData.putFieldMap(dbSelectSingle("DUSERSTRCT001.dSearchToDay", requestData.getFieldMap(), onlineCtx));
			
		    return responseData;
		}

	/**
	 *
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-27 09:52:31
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
		public IDataSet dSaveUseRstrctMgmt(IDataSet requestData, IOnlineContext onlineCtx) {
		    IDataSet responseData = new DataSet();
		    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
		    int result = dbUpdate("DUSERSTRCT001.dSaveUseRstrctMgmt", requestData.getFieldMap(), onlineCtx);
		    responseData.putField("result", result);
		    return responseData;
		}
}
