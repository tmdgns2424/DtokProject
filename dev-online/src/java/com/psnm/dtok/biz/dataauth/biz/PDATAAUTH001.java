package com.psnm.dtok.biz.dataauth.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.exception.BizRuntimeException;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/업무</li>
 * <li>단위업무명: PDATAAUTH001</li>
 * <li>설  명 : 데이터권한관리 PU</li>
 * <li>작성일 : 2015-01-27 14:27:32</li>
 * <li>작성자 : 이민재 (leeminjae)</li>
 * </ul>
 *
 * @author 이민재 (leeminjae)
 */
public class PDATAAUTH001 extends nexcore.framework.coreext.pojo.biz.ProcessUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public PDATAAUTH001(){
		super();
	}

	/**
	 * 데이터권한관리 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-27 14:37:12
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchDataAuth(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	FDATAAUTH001 fu = (FDATAAUTH001) lookupFunctionUnit(FDATAAUTH001.class);
		
			responseData = fu.fSearchDataAuth(requestData, onlineCtx);
			
			IRecordSet rs = responseData.getRecordSet("ds");
			
			responseData.putRecordSet("grid", rs);
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}

	/**
	 * 데이터권한관리사용자 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-27 14:37:37
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchDataAuthUser(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	FDATAAUTH001 fu = (FDATAAUTH001) lookupFunctionUnit(FDATAAUTH001.class);
		
			responseData = fu.fSearchDataAuthUser(requestData, onlineCtx);
			
			IRecordSet rs = responseData.getRecordSet("ds");
			
			responseData.putRecordSet("grid", rs);
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 데이터권한관리 정보를 등록,수정 하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-27 14:38:23
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSaveDataAuth(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	FDATAAUTH001 fu = (FDATAAUTH001) lookupFunctionUnit(FDATAAUTH001.class);
	    	
	    	String flag = requestData.getField("FLAG");
	    	
	    	if("I".equals(flag)){
		    	fu.fInsertDataAuth(requestData, onlineCtx);
	    	}else if("U".equals(flag)){
	    		fu.fUpdateDataAuth(requestData, onlineCtx);
	    	}
			
			responseData.setOkResultMessage("PSNM-I000", null);
		
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}  
	
	    return responseData;
	}

	/**
	 * 데이터권한관리 정보를 삭제하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-27 14:38:50
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pDeleteDataAuth(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	FDATAAUTH001 fu = (FDATAAUTH001) lookupFunctionUnit(FDATAAUTH001.class);
	    	
	    	fu.fDeleteDataAuth(requestData, onlineCtx);
	    	
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}

	/**
	 * 데이터권한관리본사파트 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-27 14:27:32
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchDataAuthPart(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	FDATAAUTH001 fu = (FDATAAUTH001) lookupFunctionUnit(FDATAAUTH001.class);
		
			responseData = fu.fSearchDataAuthPart(requestData, onlineCtx);
			
			IRecordSet rs = responseData.getRecordSet("ds");
			
			responseData.putRecordSet("resultList", rs);
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}
  
}
