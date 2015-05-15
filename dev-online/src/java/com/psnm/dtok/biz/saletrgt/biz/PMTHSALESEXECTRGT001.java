package com.psnm.dtok.biz.saletrgt.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.exception.BizRuntimeException;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/업무</li>
 * <li>단위업무명: PMTHSALESEXECTRGT001</li>
 * <li>설  명 : 영업목표관리 PU</li>
 * <li>작성일 : 2015-02-09 16:48:24</li>
 * <li>작성자 : 이민재 (leeminjae)</li>
 * </ul>
 *
 * @author 이민재 (leeminjae)
 */
public class PMTHSALESEXECTRGT001 extends nexcore.framework.coreext.pojo.biz.ProcessUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public PMTHSALESEXECTRGT001(){
		super();
	}

	/**
	 * 영업목표관리 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-09 17:36:05
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchSalesExecTrgt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	FMTHSALESEXECTRGT001 fu = (FMTHSALESEXECTRGT001) lookupFunctionUnit(FMTHSALESEXECTRGT001.class);
		
			IRecordSet rs1 = fu.fSearchSalesExecTrgt(requestData, onlineCtx).getRecordSet("ds");
			IRecordSet rs2 = fu.fSearchSalesExecTrgtTotal(requestData, onlineCtx).getRecordSet("ds");
			
			responseData.putRecordSet("grid", rs1);
			responseData.putRecordSet("gridtotal", rs2);
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 영업목표관리 정보를 등록,수정 하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-09 17:37:00
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSaveSalesExecTrgt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	FMTHSALESEXECTRGT001 fu = (FMTHSALESEXECTRGT001) lookupFunctionUnit(FMTHSALESEXECTRGT001.class);
			
	    	fu.fInsertSalesExecTrgt(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);
		
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 영업목표 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-10 13:43:13
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchSalesExecTrgtBrws(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	FMTHSALESEXECTRGT001 fu = (FMTHSALESEXECTRGT001) lookupFunctionUnit(FMTHSALESEXECTRGT001.class);
		
			IRecordSet rs = fu.fSearchSalesExecTrgtBrws(requestData, onlineCtx).getRecordSet("ds");
			
			responseData.putRecordSet("grid", rs);
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}
  
}
