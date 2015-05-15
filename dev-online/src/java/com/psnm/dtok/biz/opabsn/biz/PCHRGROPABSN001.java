package com.psnm.dtok.biz.opabsn.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.exception.BizRuntimeException;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/업무</li>
 * <li>단위업무명: PCHRGROPABSN001</li>
 * <li>설  명 : 담당자별업무부재설정 PU</li>
 * <li>작성일 : 2015-01-26 15:19:13</li>
 * <li>작성자 : 이민재 (leeminjae)</li>
 * </ul>
 *
 * @author 이민재 (leeminjae)
 */
public class PCHRGROPABSN001 extends nexcore.framework.coreext.pojo.biz.ProcessUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public PCHRGROPABSN001(){
		super();
	}

	/**
	 * 담당자별업무부재설정 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-26 16:22:01
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchChrgrOpabsn(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	FCHRGROPABSN001 fu = (FCHRGROPABSN001) lookupFunctionUnit(FCHRGROPABSN001.class);
		
			responseData = fu.fSearchChrgrOpabsn(requestData, onlineCtx);
			
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
	 * 담당자별업무부재설정사용자 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-26 16:22:35
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchChrgrOpabsnUser(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	FCHRGROPABSN001 fu = (FCHRGROPABSN001) lookupFunctionUnit(FCHRGROPABSN001.class);
		
			responseData = fu.fSearchChrgrOpabsnUser(requestData, onlineCtx);
			
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
	 * 담당자별업무부재설정 정보를 등록, 수정 하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-26 16:23:24
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSaveChrgrOpabsn(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	FCHRGROPABSN001 fu = (FCHRGROPABSN001) lookupFunctionUnit(FCHRGROPABSN001.class);
	    	
	    	String flag = requestData.getField("FLAG");
	    	
	    	if("I".equals(flag)){
		    	fu.fInsertChrgrOpabsn(requestData, onlineCtx);
	    	}else if("U".equals(flag)){
	    		fu.fUpdateChrgrOpabsn(requestData, onlineCtx);
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
	 * 담당자별업무부재설정 정보를 삭제하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-26 16:23:52
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pDeleteChrgrOpabsn(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	FCHRGROPABSN001 fu = (FCHRGROPABSN001) lookupFunctionUnit(FCHRGROPABSN001.class);
	    	
	    	fu.fDeleteChrgrOpabsn(requestData, onlineCtx);
	    	
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}
  
}
