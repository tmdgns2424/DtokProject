package com.psnm.dtok.biz.saleprst.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.exception.BizRuntimeException;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/업무</li>
 * <li>단위업무명: [PU]판매현황</li>
 * <li>설  명 : </li>
 * <li>작성일 : 2014-12-23 09:49:47</li>
 * <li>작성자 : 채수윤 (chesuyun)</li>
 * </ul>
 *
 * @author 채수윤 (chesuyun)
 */
public class PSALEPRST001 extends nexcore.framework.coreext.pojo.biz.ProcessUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public PSALEPRST001(){
		super();
	}

	/**
	 * PM : 여신현황을 조회한다.
	 *
	 * @author 채수윤 (chesuyun)
	 * @since 2014-12-23 09:49:47
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchCrdPrst(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	FSALEPRST001 fu = (FSALEPRST001)lookupFunctionUnit(FSALEPRST001.class);
	    	responseData = fu.fSearchCrdPrst(requestData, onlineCtx);

			IRecordSet rs = responseData.getRecordSet("ds");
			rs.setTotalRecordCount(responseData.getRecordSet("dsCnt").getRecord(0).getInt("TOT_CNT"));
			rs.setPageNo(requestData.getIntField("page")); // page는 클라이언트에서 넘기는 것을 그대로 리턴하면 됩니다.
			rs.setRecordCountPerPage(requestData.getIntField("page_size"));
	    	
			responseData.putRecordSet("gridMain", rs); //[alopex] 그리드 데이터는 dataSet.recordSets 하위에 그리드 아이디를 키로 위치

			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000");
		}
	
	    return responseData;
	}

	/**
	 * 위탁재고 현황을 조회하는 메소드
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-02-10 15:25:29
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchCnsgInvePrst(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		
		FSALEPRST001 fu = (FSALEPRST001)lookupFunctionUnit(FSALEPRST001.class);
    	responseData = fu.fSearchCnsgInvePrst(requestData, onlineCtx);
		
	    return responseData;
	}

	/**
	 * 상품별 실적현황을 조회하는 메소드
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2014-12-23 09:49:47
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchProdRsltPrst(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		
		FSALEPRST001 fu = (FSALEPRST001)lookupFunctionUnit(FSALEPRST001.class);
    	responseData = fu.fSearchProdRsltPrst(requestData, onlineCtx);
		
	    return responseData;
	}

	/**
	 * 에이전트별 실적현황을 조회하는 메소드
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-02-26 14:19:55
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchAgentRsltPrst(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		
		FSALEPRST001 fu = (FSALEPRST001)lookupFunctionUnit(FSALEPRST001.class);
    	responseData = fu.fSearchAgentRsltPrst(requestData, onlineCtx);
		
	    return responseData;
	}

	/**
	 * 일별 실적현황을 조회하는 메소드
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2014-12-23 09:49:47
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchDayRsltPrst(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		
		FSALEPRST001 fu = (FSALEPRST001)lookupFunctionUnit(FSALEPRST001.class);
    	responseData = fu.fSearchDayRsltPrst(requestData, onlineCtx);
		
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2014-12-23 09:49:47
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchMthRsltPrst(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		
		FSALEPRST001 fu = (FSALEPRST001)lookupFunctionUnit(FSALEPRST001.class);
    	responseData = fu.fSearchMthRsltPrst(requestData, onlineCtx);
		
	    return responseData;
	}
  
}
