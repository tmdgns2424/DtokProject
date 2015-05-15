package com.psnm.dtok.agn.agntmgmt.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.exception.BizRuntimeException;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/에이전트</li>
 * <li>단위업무명: FAGENTCAREERHST001</li>
 * <li>설  명 : 에이전트경력정보 FU</li>
 * <li>작성일 : 2015-02-16 11:10:20</li>
 * <li>작성자 : 김보선 (kimbosun)</li>
 * </ul>
 *
 * @author 김보선 (kimbosun)
 */
public class FAGENTCAREERHST001 extends nexcore.framework.coreext.pojo.biz.FunctionUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public FAGENTCAREERHST001(){
		super();
	}

	/**
	 * 에이전터경력정보 조회 FM
	 *
	 * @author 김보선 (kimbosun)
	 * @since 2015-02-16 11:12:19
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchAgentCareerHst(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    try{
			
			DAGENTCAREERHST001 du = (DAGENTCAREERHST001)lookupDataUnit(DAGENTCAREERHST001.class);
			
			responseData = du.dSearchAgentCareerHst(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 에이전트경력정보 저장 FM
	 *
	 * @author 김보선 (kimbosun)
	 * @since 2015-02-16 11:12:58
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fInsertAgentCareerHst(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요
	    try {
	    	
	    	DAGENTCAREERHST001 du = (DAGENTCAREERHST001)lookupDataUnit(DAGENTCAREERHST001.class);	    	
		    du.dInsertAgentCareerHst(requestData, onlineCtx);
		    
	    } catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	    
	    responseData.setOkResultMessage("PSNM-I000", null);	
	    return responseData;
	}

	/**
	 * 에이전트경력정보 삭제 FM
	 *
	 * @author 김보선 (kimbosun)
	 * @since 2015-03-02 18:04:11
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fDeleteAgentCareerHst(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();	
	    
	    try {
			
	    	DAGENTCAREERHST001 du = (DAGENTCAREERHST001) lookupDataUnit(DAGENTCAREERHST001.class);
			
			du.dDeleteAgentCareerHst(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}
  
}
