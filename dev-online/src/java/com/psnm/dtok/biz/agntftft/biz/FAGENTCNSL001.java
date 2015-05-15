package com.psnm.dtok.biz.agntftft.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.exception.BizRuntimeException;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/업무</li>
 * <li>단위업무명: FAGENTCNSL001</li>
 * <li>설  명 : 면담계획/수시면담 FU</li>
 * <li>작성일 : 2014-12-12 10:40:35</li>
 * <li>작성자 : 이민재 (leeminjae)</li>
 * </ul>
 *
 * @author 이민재 (leeminjae)
 */
public class FAGENTCNSL001 extends nexcore.framework.coreext.pojo.biz.FunctionUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public FAGENTCNSL001(){
		super();
	}

	/**
	 * 면담계획/수시면담을 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-12 10:46:23
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchAgentCnsl(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	DAGENTCNSL001 du = (DAGENTCNSL001) lookupDataUnit(DAGENTCNSL001.class);
	    	
			responseData = du.dSearchAgentCnsl(requestData, onlineCtx);
			responseData.putField("count", du.dSearchAgentCnslCount(requestData, onlineCtx).getIntField("count"));
			responseData.putFieldMap(du.dSearchAgentCnslTotalCount(requestData, onlineCtx).getFieldMap());
			
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 면담계획/수시면담을 저장하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-12 10:40:35
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fInsertAgentCnsl(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			
	    	DAGENTCNSL001 du = (DAGENTCNSL001) lookupDataUnit(DAGENTCNSL001.class);
	    	
	    	String CNSL_STA_TM2 = requestData.getField("CNSL_STA_TM2") + requestData.getField("CNSL_STA_M2");
	    	String CNSL_END_TM2 = requestData.getField("CNSL_END_TM2") + requestData.getField("CNSL_END_M2");
	    	requestData.putField("CNSL_STA_TM2", CNSL_STA_TM2);
	    	requestData.putField("CNSL_END_TM2", CNSL_END_TM2);
			
			du.dInsertAgentCnsl(requestData, onlineCtx);

			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}

	/**
	 * 면담계획/수시면담을 삭제하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-12 15:37:46
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fDeleteAgentCnsl(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			
	    	DAGENTCNSL001 du = (DAGENTCNSL001) lookupDataUnit(DAGENTCNSL001.class);
			
			du.dDeleteAgentCnsl(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}
  
}
