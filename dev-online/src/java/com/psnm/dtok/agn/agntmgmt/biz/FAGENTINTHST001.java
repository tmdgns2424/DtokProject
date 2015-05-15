package com.psnm.dtok.agn.agntmgmt.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.exception.BizRuntimeException;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/에이전트</li>
 * <li>단위업무명: FAGENTINTHST001</li>
 * <li>설  명 : 에이전트면접정보 FU</li>
 * <li>작성일 : 2015-02-26 09:20:17</li>
 * <li>작성자 : 김보선 (kimbosun)</li>
 * </ul>
 *
 * @author 김보선 (kimbosun)
 */
public class FAGENTINTHST001 extends nexcore.framework.coreext.pojo.biz.FunctionUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public FAGENTINTHST001(){
		super();
	}

	/**
	 * 에이전트면접정보 조회 FM
	 *
	 * @author 김보선 (kimbosun)
	 * @since 2015-02-26 09:20:17
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchAgentIntHst(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    try{
			
			DAGENTINTHST001 du = (DAGENTINTHST001)lookupDataUnit(DAGENTINTHST001.class);
			
			responseData = du.dSearchAgentIntHst(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 에이전트면접정보 상세조회 FM
	 *
	 * @author 김보선 (kimbosun)
	 * @since 2015-02-26 09:20:17
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fDetailAgentIntHst(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    try {
	    	
	    	DAGENTINTHST001 du = (DAGENTINTHST001) lookupDataUnit(DAGENTINTHST001.class);

	    	responseData = du.dDetailAgentIntHst(requestData, onlineCtx);
			
		    responseData.setOkResultMessage("PSNM-I000", null);
	    	
	    } catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 에이전트면접정보 저장 FM
	 *
	 * @author 김보선 (kimbosun)
	 * @since 2015-02-26 16:48:12
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fInsertAgentIntHst(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    try {
	    	
	    	DAGENTINTHST001 du = (DAGENTINTHST001)lookupDataUnit(DAGENTINTHST001.class);	    	
		    du.dInsertAgentIntHst(requestData, onlineCtx);
		    
	    } catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}	
	
	    return responseData;
	}

	/**
	 * 에이전트면접정보 상태수정 FM
	 *
	 * @author 김보선 (kimbosun)
	 * @since 2015-02-26 09:20:17
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fUpdateAgentIntHst(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    try {
	    	
	    	DAGENTINTHST001 du = (DAGENTINTHST001)lookupDataUnit(DAGENTINTHST001.class);	    	
		    du.dUpdateAgentIntHst(requestData, onlineCtx);
		    
	    } catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}	
	
	    return responseData;
	}

	/**
	 * 에이전트면접정보 삭제 FM
	 *
	 * @author 김보선 (kimbosun)
	 * @since 2015-03-02 18:01:09
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fDeleteAgentIntHst(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			
	    	DAGENTINTHST001 du = (DAGENTINTHST001) lookupDataUnit(DAGENTINTHST001.class);
			
			du.dDeleteAgentIntHst(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}
  
}
