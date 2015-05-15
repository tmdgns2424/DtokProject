package com.psnm.dtok.com.bizaprvsusp.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.exception.BizRuntimeException;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: PBIZAPRVSUSP001</li>
 * <li>설  명 : 업무승인일시정지관리 PU</li>
 * <li>작성일 : 2015-02-26 14:04:08</li>
 * <li>작성자 : 이민재 (leeminjae)</li>
 * </ul>
 *
 * @author 이민재 (leeminjae)
 */
public class PBIZAPRVSUSP001 extends nexcore.framework.coreext.pojo.biz.ProcessUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public PBIZAPRVSUSP001(){
		super();
	}

	/**
	 * 업무승인일시정지관리 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-26 15:01:22
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchBizAprvSusp(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	FBIZAPRVSUSP001 fu = (FBIZAPRVSUSP001) lookupFunctionUnit(FBIZAPRVSUSP001.class);
		
			responseData = fu.fSearchBizAprvSusp(requestData, onlineCtx);
			
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
	 * 업무승인일시정지관리 정보를 등록,수정 하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-26 15:02:25
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSaveBizAprvSusp(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	FBIZAPRVSUSP001 fu = (FBIZAPRVSUSP001) lookupFunctionUnit(FBIZAPRVSUSP001.class);
	    	
	    	IRecordSet rs = requestData.getRecordSet("grid");
	    	
			if(rs != null && rs.getRecordCount()!=0) {
				for(int i = 0 ; i < rs.getRecordCount() ; i++){
					IDataSet listData = new DataSet();
		    		listData.putFieldMap(rs.getRecordMap(i));
		    		
		    		if("I".equals(listData.getField("FLAG"))){
			    		fu.fInsertBizAprvSusp(listData, onlineCtx);
			    	}else if("U".equals(listData.getField("FLAG"))){
			    		fu.fUpdateBizAprvSusp(listData, onlineCtx);
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

	/**
	 * 업무승인일시정지관리 정보를 삭제하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-26 15:02:49
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pDeleteBizAprvSusp(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	FBIZAPRVSUSP001 fu = (FBIZAPRVSUSP001) lookupFunctionUnit(FBIZAPRVSUSP001.class);
	    	
	    	fu.fDeleteBizAprvSusp(requestData, onlineCtx);
	    	
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}
  
}
