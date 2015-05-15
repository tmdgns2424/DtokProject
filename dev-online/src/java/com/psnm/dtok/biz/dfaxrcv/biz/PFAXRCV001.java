package com.psnm.dtok.biz.dfaxrcv.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.exception.BizRuntimeException;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/업무</li>
 * <li>단위업무명: PFAXRCV001</li>
 * <li>설  명 : D-FAX접수결과 PU</li>
 * <li>작성일 : 2014-12-24 16:08:29</li>
 * <li>작성자 : 이민재 (leeminjae)</li>
 * </ul>
 *
 * @author 이민재 (leeminjae)
 */
public class PFAXRCV001 extends nexcore.framework.coreext.pojo.biz.ProcessUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public PFAXRCV001(){
		super();
	}

	/**
	 * D-FAX접수결과 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-24 16:10:20
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchFaxRcv(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	FFAXRCV001 fu = (FFAXRCV001) lookupFunctionUnit(FFAXRCV001.class);
			
			responseData = fu.fSearchFaxRcv(requestData, onlineCtx);
			
			IRecordSet rs = responseData.getRecordSet("ds");
			
			rs.setTotalRecordCount(responseData.getIntField("count"));
			rs.setPageNo(requestData.getIntField("page"));
			rs.setRecordCountPerPage(requestData.getIntField("page_size"));
			
			responseData.putRecordSet("griddfaxrcv", rs);
			responseData.setOkResultMessage("PSNM-I000", null);
		
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * D-FAX접수업무승인 정보를 등록,수정 하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-27 16:04:18
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSaveFaxRcvBizAprv(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	FFAXRCV001 fu = (FFAXRCV001) lookupFunctionUnit(FFAXRCV001.class);
	    	
	    	fu.fInsertFaxRcvBizAprv(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);
		
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * D-FAX접수첨부파일 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-03-03 14:27:41
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchFaxRcvFile(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	//첨부파일 조회
	    	requestData.putField("ATCH_MGMT_ID", "DFAX"+requestData.getField("FAX_RCV_NO"));
    		IDataSet fileDataset = callSharedBizComponentByDirect("com.SHARE", "fSearchFileMapping", requestData, onlineCtx);
    		responseData.putRecordSet("gridfile", fileDataset.getRecordSet("ds"));
	    	
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * D-FAX접수결과조회모바일 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-03-09 14:33:38
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchFaxRcvMobile(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	FFAXRCV001 fu = (FFAXRCV001) lookupFunctionUnit(FFAXRCV001.class);
			
			responseData = fu.fSearchFaxRcvMobile(requestData, onlineCtx);
			
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
