package com.psnm.dtok.biz.saleprst.biz;

import java.util.Map;

import org.apache.commons.logging.Log;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecord;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.data.IResultMessage;
import nexcore.framework.core.data.ResultMessage;
import nexcore.framework.core.exception.BizRuntimeException;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/업무</li>
 * <li>단위업무명: DSALEPRST001</li>
 * <li>설  명 : </li>
 * <li>작성일 : 2014-12-23 09:51:12</li>
 * <li>작성자 : 채수윤 (chesuyun)</li>
 * </ul>
 *
 * @author 채수윤 (chesuyun)
 */
public class DSALEPRST001 extends nexcore.framework.coreext.pojo.biz.DataUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public DSALEPRST001(){
		super();
	}

	/**
	 * DM : 여신현황을 조회한다.
	 *
	 * @author 채수윤 (chesuyun)
	 * @since 2014-12-23 09:51:12
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchCrdPrst(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();

		IRecordSet rs = dbSelect("DSALEPRST001.CRD_PRST", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
	
	    IRecordSet rs1 = dbSelect("DSALEPRST001.CRD_PRST_CNT", requestData.getFieldMap(), onlineCtx);
	    responseData.putRecordSet("dsCnt", rs1);
		
	    return responseData;
	}

	/**
	 * 위탁재고 현황을 조회 하는 메소드
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2014-12-23 09:51:12
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchCnsgInvePrst(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

		IRecordSet rs = dbSelect("DSALEPRST001.dSearchCnsgInvePrst", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
	
	    IRecordSet rs1 = dbSelect("DSALEPRST001.dSearchCnsgInvePrstCnt", requestData.getFieldMap(), onlineCtx);
	    responseData.putRecordSet("dsCnt", rs1);
	
	    return responseData;
	}

	/**
	 * 상품별 실적현황 검색을 위하여 관련 테이블(TPR_RETL_SALE)을 조인하여 상품별 실적현황 객체를 map객체로 가져오는 메소드
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2014-12-23 09:51:12
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchProdRsltPrst(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

		IRecordSet rs = dbSelect("DSALEPRST001.dSearchProdRsltPrst", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("gridMain", rs);
	
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-02-26 14:21:31
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchAgentRsltPrst(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

		IRecordSet rs = dbSelect("DSALEPRST001.dSearchAgentRsltPrst", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("gridMain", rs);
	
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-02-26 14:22:56
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchDayRsltPrst(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

		IRecordSet rs = dbSelect("DSALEPRST001.dSearchDayRsltPrst", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("gridMain", rs);
	
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-02-26 14:24:11
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchMthRsltPrst(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

		IRecordSet rs = dbSelect("DSALEPRST001.dSearchMthRsltPrst", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("gridMain", rs);
	
	    return responseData;
	}
  
}
