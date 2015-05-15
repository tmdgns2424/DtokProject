package com.psnm.dtok.biz.bizmgmt.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.exception.BizRuntimeException;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/업무</li>
 * <li>단위업무명: [PU]전화번호부</li>
 * <li>설  명 : </li>
 * <li>작성일 : 2015-01-23 10:49:26</li>
 * <li>작성자 : 이승훈2 (gunyoung)</li>
 * </ul>
 *
 * @author 이승훈2 (gunyoung)
 */
public class PPHONBK001 extends nexcore.framework.coreext.pojo.biz.ProcessUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public PPHONBK001(){
		super();
	}

	/**
	 * 전화번호부를 조회하는 메소드
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-23 10:49:26
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchPhonBk(IDataSet requestData, IOnlineContext onlineCtx) {

	    IDataSet responseData = new DataSet();
	    
	    try {
	    	
	    	FPHONBK001 fu = (FPHONBK001)lookupFunctionUnit(FPHONBK001.class);
	    	
	    	responseData = fu.fSearchPhonBk(requestData, onlineCtx);
	    	
	    	responseData.setOkResultMessage("PSNM-I000", null);
	    	
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-27 17:12:07
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchSaleTeam(IDataSet requestData, IOnlineContext onlineCtx) {
		
		IDataSet responseData = new DataSet();
		
	    try {
	    	
	    	FPHONBK001 fu = (FPHONBK001)lookupFunctionUnit(FPHONBK001.class);
	    	
	    	responseData = fu.fSearchSaleTeam(requestData, onlineCtx);
	    	
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	    return responseData;
	}

	/**
	 * 전화번호부 정보를 상세 조회 하는 메소드
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-02-12 09:54:23
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pDetailPhonBk(IDataSet requestData, IOnlineContext onlineCtx) {
IDataSet responseData = new DataSet();
		
	    try {
	    	
	    	FPHONBK001 fu = (FPHONBK001)lookupFunctionUnit(FPHONBK001.class);
	    	
	    	responseData = fu.fDetailPhonBk(requestData, onlineCtx);
	    	
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	    return responseData;
	}

	/**
	 * 전화번호부 정보를 조건 별로 조회 하는 메소드
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-02-12 14:44:32
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchPhonBkCondi(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
	    
	    try {
	    	
	    	FPHONBK001 fu = (FPHONBK001)lookupFunctionUnit(FPHONBK001.class);
	    	
	    	responseData = fu.fSearchPhonBkCondi(requestData, onlineCtx);
	    	
	    	responseData.setOkResultMessage("PSNM-I000", null);
	    	
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	    return responseData;
	}
  
}
