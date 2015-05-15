package com.psnm.dtok.biz.agntftft.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.exception.BizRuntimeException;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/업무</li>
 * <li>단위업무명: FAGENTCNSLPRSS001</li>
 * <li>설  명 : 면담현황 FU</li>
 * <li>작성일 : 2014-12-19 13:22:07</li>
 * <li>작성자 : 이민재 (leeminjae)</li>
 * </ul>
 *
 * @author 이민재 (leeminjae)
 */
public class FAGENTCNSLPRSS001 extends nexcore.framework.coreext.pojo.biz.FunctionUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public FAGENTCNSLPRSS001(){
		super();
	}

	/**
	 * 면담현황 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-19 13:23:27
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchAgentCnslPrss(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	DAGENTCNSLPRSS001 du = (DAGENTCNSLPRSS001) lookupDataUnit(DAGENTCNSLPRSS001.class);
	    	
			responseData.putRecordSet("grid1", du.dSearchAgentCnslPrss(requestData, onlineCtx).getRecordSet("ds"));
			responseData.putRecordSet("grid2", du.dSearchAgentCnslPrssCount(requestData, onlineCtx).getRecordSet("ds"));
			responseData.putFieldMap(du.dSearchAgentCnslPrssTotCount(requestData, onlineCtx).getFieldMap());
			
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 면담현황엑셀 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-19 17:22:23
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchAgentCnslPrssExcel(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	DAGENTCNSLPRSS001 du = (DAGENTCNSLPRSS001) lookupDataUnit(DAGENTCNSLPRSS001.class);
	    	
	    	responseData = du.dSearchAgentCnslPrssExcel(requestData, onlineCtx);
	    	
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}

	/**
	 * 면담현황통계 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-29 10:46:19
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchAgentCnslPrssTotal(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	DAGENTCNSLPRSS001 du = (DAGENTCNSLPRSS001) lookupDataUnit(DAGENTCNSLPRSS001.class);
	    	
			responseData = du.dSearchAgentCnslPrssTotal(requestData, onlineCtx);
			responseData.putField("count", du.dSearchAgentCnslPrssTotalCount(requestData, onlineCtx).getIntField("count"));
			
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}
  
}