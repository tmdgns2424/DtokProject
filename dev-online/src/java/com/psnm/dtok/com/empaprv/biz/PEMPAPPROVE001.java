package com.psnm.dtok.com.empaprv.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.exception.BizRuntimeException;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: PEMPAPPROVE001</li>
 * <li>설  명 : 임직원로그인관리 PU</li>
 * <li>작성일 : 2014-12-23 13:11:56</li>
 * <li>작성자 : 이민재 (leeminjae)</li>
 * </ul>
 *
 * @author 이민재 (leeminjae)
 */
public class PEMPAPPROVE001 extends nexcore.framework.coreext.pojo.biz.ProcessUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public PEMPAPPROVE001(){
		super();
	}

	/**
	 * 임직원로그인 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-23 14:29:13
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchAprove(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	FEMPAPPROVE001 fu = (FEMPAPPROVE001) lookupFunctionUnit(FEMPAPPROVE001.class);
		
			responseData = fu.fSearchAprove(requestData, onlineCtx);
			
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
	 * 임직원로그인관리 사용자 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-23 14:30:28
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchAproveUser(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	FEMPAPPROVE001 fu = (FEMPAPPROVE001) lookupFunctionUnit(FEMPAPPROVE001.class);
		    
	    	responseData = fu.fSearchAproveUser(requestData, onlineCtx);
			
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
	 * 임직원로그인관리 정보를 등록,수정 하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-23 14:31:20
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSaveAprove(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	FEMPAPPROVE001 fu = (FEMPAPPROVE001) lookupFunctionUnit(FEMPAPPROVE001.class);
	    	
	    	String flag = requestData.getField("FLAG");
	    	
	    	IRecordSet rs = fu.fSearchAprove(requestData, onlineCtx).getRecordSet("ds");
	    	
	    	if("I".equals(flag)){
	    		if(rs.getRecordCount() == 0){
		    		fu.fInsertAprove(requestData, onlineCtx);
		    		fu.fInsertDutyChgHst(requestData, onlineCtx);
		    	}
	    		responseData.putField("count", rs.getRecordCount());
	    		
	    	}else if("U".equals(flag)){
	    		fu.fInsertAprove(requestData, onlineCtx);
	    		fu.fInsertDutyChgHst(requestData, onlineCtx);
	    		responseData.putField("count", 0);
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
	 * 임직원로그인관리 정보를 삭제하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-23 14:31:50
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pDeleteAprove(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	FEMPAPPROVE001 fu = (FEMPAPPROVE001) lookupFunctionUnit(FEMPAPPROVE001.class);
	    	
	    	fu.fInsertDutyChgHst(requestData, onlineCtx);
	    	fu.fDeleteAprove(requestData, onlineCtx);
	    	
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 임직원로그인관리직무정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-20 16:23:47
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchDutyMgmt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	FEMPAPPROVE001 fu = (FEMPAPPROVE001) lookupFunctionUnit(FEMPAPPROVE001.class);
		
			responseData = fu.fSearchDutyMgmt(requestData, onlineCtx);
			
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
