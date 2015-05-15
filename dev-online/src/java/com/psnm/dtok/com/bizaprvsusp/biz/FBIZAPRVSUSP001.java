package com.psnm.dtok.com.bizaprvsusp.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.exception.BizRuntimeException;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: FBIZAPRVSUSP001</li>
 * <li>설  명 : 업무승인일시정지관리 FU</li>
 * <li>작성일 : 2015-02-26 14:05:02</li>
 * <li>작성자 : 이민재 (leeminjae)</li>
 * </ul>
 *
 * @author 이민재 (leeminjae)
 */
public class FBIZAPRVSUSP001 extends nexcore.framework.coreext.pojo.biz.FunctionUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public FBIZAPRVSUSP001(){
		super();
	}

	/**
	 * 업무승인일시정지관리 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-26 14:56:04
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchBizAprvSusp(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	DBIZAPRVSUSP001 du = (DBIZAPRVSUSP001) lookupDataUnit(DBIZAPRVSUSP001.class);
			
			responseData = du.dSearchBizAprvSusp(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}

	/**
	 * 업무승인일시정지관리 정보를 저장하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-26 14:56:34
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fInsertBizAprvSusp(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			
	    	DBIZAPRVSUSP001 du = (DBIZAPRVSUSP001) lookupDataUnit(DBIZAPRVSUSP001.class);
			
			du.dInsertBizAprvSusp(requestData, onlineCtx);

			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}

	/**
	 * 업무승인일시정지관리 정보를 수정하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-26 14:57:01
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fUpdateBizAprvSusp(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			
	    	DBIZAPRVSUSP001 du = (DBIZAPRVSUSP001) lookupDataUnit(DBIZAPRVSUSP001.class);
			
			du.dUpdateBizAprvSusp(requestData, onlineCtx);

			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}

	/**
	 * 업무승인일시정지관리 정보를 삭제하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-26 14:57:29
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fDeleteBizAprvSusp(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			
	    	DBIZAPRVSUSP001 du = (DBIZAPRVSUSP001) lookupDataUnit(DBIZAPRVSUSP001.class);
			
	    	IRecordSet rs = requestData.getRecordSet("grid");
	    	
			if(rs != null && rs.getRecordCount()!=0) {
				for(int i = 0 ; i < rs.getRecordCount() ; i++){
					IDataSet listData = new DataSet();
		    		listData.putFieldMap(rs.getRecordMap(i));
		    		
		    		if("D".equals(listData.getField("FLAG"))){
		    			du.dDeleteBizAprvSusp(listData, onlineCtx);
			    	}
				}
			}
			
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}
  
}
