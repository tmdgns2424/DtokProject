package com.psnm.dtok.agn.agntmgmt.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.exception.BizRuntimeException;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/에이전트</li>
 * <li>단위업무명: FAGENTSCHSHIPHST001</li>
 * <li>설  명 : 에이전트학력정보 FU</li>
 * <li>작성일 : 2015-02-16 10:59:13</li>
 * <li>작성자 : 김보선 (kimbosun)</li>
 * </ul>
 *
 * @author 김보선 (kimbosun)
 */
public class FAGENTSCHSHIPHST001 extends nexcore.framework.coreext.pojo.biz.FunctionUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public FAGENTSCHSHIPHST001(){
		super();
	}

	/**
	 * 에이전트학력정보 조회 FM
	 *
	 * @author 김보선 (kimbosun)
	 * @since 2015-02-16 11:00:46
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchAgentSchshipHst(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요
	    try{
			
			DAGENTSCHSHIPHST001 du = (DAGENTSCHSHIPHST001)lookupDataUnit(DAGENTSCHSHIPHST001.class);
			
			responseData = du.dSearchAgentSchshipHst(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 에이전트학력정보 저장 FM
	 *
	 * @author 김보선 (kimbosun)
	 * @since 2015-02-16 11:01:47
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fInsertAgentSchshipHst(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    try {
	    	
	    	DAGENTSCHSHIPHST001 du = (DAGENTSCHSHIPHST001)lookupDataUnit(DAGENTSCHSHIPHST001.class);	    	
		    du.dInsertAgentSchshipHst(requestData, onlineCtx);
		    
	    } catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}	
	    
	    responseData.setOkResultMessage("PSNM-I000", null);	
	    return responseData;
	}

	/**
	 * 에이전트학력정보 삭제 FM
	 *
	 * @author 김보선 (kimbosun)
	 * @since 2015-03-02 17:57:57
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fDeleteAgentSchshipHst(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			
	    	DAGENTSCHSHIPHST001 du = (DAGENTSCHSHIPHST001) lookupDataUnit(DAGENTSCHSHIPHST001.class);
			
			du.dDeleteAgentSchshipHst(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}
  
}
