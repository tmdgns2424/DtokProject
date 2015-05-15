package com.psnm.dtok.biz.saleplan.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.exception.BizRuntimeException;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/업무</li>
 * <li>단위업무명: PSALEPLANSTRD001</li>
 * <li>설  명 : 영업계획기준관리 PU</li>
 * <li>작성일 : 2015-01-29 10:38:29</li>
 * <li>작성자 : 이민재 (leeminjae)</li>
 * </ul>
 *
 * @author 이민재 (leeminjae)
 */
public class PSALEPLANSTRD001 extends nexcore.framework.coreext.pojo.biz.ProcessUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public PSALEPLANSTRD001(){
		super();
	}

	/**
	 * 영업계획기준관리 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-29 10:38:29
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchSalePlanStrd(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	FSALEPLANSTRD001 fu = (FSALEPLANSTRD001) lookupFunctionUnit(FSALEPLANSTRD001.class);
		
			IRecordSet rs1 = fu.fSearchSalePlanStrdProd(requestData, onlineCtx).getRecordSet("ds");
			IRecordSet rs2 = fu.fSearchSalePlanStrdCtt(requestData, onlineCtx).getRecordSet("ds");
			
			responseData.putRecordSet("gridprod", rs1);
			responseData.putRecordSet("gridctt", rs2);
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}

	/**
	 * 영업계획기준관리 정보를 등록,수정,삭제 하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-29 10:38:29
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSaveSalePlanStrd(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	FSALEPLANSTRD001 fu = (FSALEPLANSTRD001) lookupFunctionUnit(FSALEPLANSTRD001.class);
			
	    	fu.fInsertSalePlanStrdProd(requestData, onlineCtx);
	    	fu.fInsertSalePlanStrdCtt(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);
		
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}

	/**
	 * 영업계획기준관리정보를 복사하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-09 14:09:30
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pCopySalePlanStrd(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	FSALEPLANSTRD001 fu = (FSALEPLANSTRD001) lookupFunctionUnit(FSALEPLANSTRD001.class);
			
	    	fu.fCopySalePlanStrd(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);
		
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}
  
}
