package com.psnm.dtok.biz.bizmgmt.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.exception.BizRuntimeException;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/업무</li>
 * <li>단위업무명: FPHONBK001</li>
 * <li>설  명 : </li>
 * <li>작성일 : 2015-02-11 13:33:31</li>
 * <li>작성자 : 이승훈2 (gunyoung)</li>
 * </ul>
 *
 * @author 이승훈2 (gunyoung)
 */
public class FPHONBK001 extends nexcore.framework.coreext.pojo.biz.FunctionUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public FPHONBK001(){
		super();
	}

	/**
	 *
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-02-11 13:36:12
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchPhonBk(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
	    
	    try {
	    	
	    	DPHONBK001 du = (DPHONBK001)lookupDataUnit(DPHONBK001.class);
	    	
	    	responseData = du.dSearchPhonBk(requestData, onlineCtx);
	    	
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
	 * @since 2015-02-11 13:36:40
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchSaleTeam(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		
	    try {
	    	
	    	DPHONBK001 du = (DPHONBK001)lookupDataUnit(DPHONBK001.class);
	    	
	    	responseData = du.dSearchSaleTeam(requestData, onlineCtx);
	    	
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
	 * @since 2015-02-11 13:33:31
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fDetailPhonBk(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		
	    try {
	    	
	    	DPHONBK001 du = (DPHONBK001)lookupDataUnit(DPHONBK001.class);
	    	
	    	responseData.putFieldMap(du.dDetailPhonBk(requestData, onlineCtx).getFieldMap());
	    	
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
	 * @since 2015-02-11 13:33:31
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchPhonBkCondi(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
	    
	    try {
	    	
	    	DPHONBK001 du = (DPHONBK001)lookupDataUnit(DPHONBK001.class);
	    	
	    	responseData = du.dSearchPhonBkCondi(requestData, onlineCtx);
	    	
	    	responseData.setOkResultMessage("PSNM-I000", null);
	    	
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	    return responseData;
	}
  
}
