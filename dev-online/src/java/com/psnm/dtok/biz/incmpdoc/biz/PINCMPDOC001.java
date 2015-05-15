package com.psnm.dtok.biz.incmpdoc.biz;

import java.util.Map;

import com.psnm.common.util.PsnmStringUtil;

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
 * <li>단위업무명: PINCMPDOC001</li>
 * <li>설  명 : 미비서류 접수 관련 업무 Process Unit</li>
 * <li>작성일 : 2015-01-22 14:09:58</li>
 * <li>작성자 : 김지홍 (kimjihong)</li>
 * </ul>
 *
 * @author 김지홍 (kimjihong)
 */
public class PINCMPDOC001 extends nexcore.framework.coreext.pojo.biz.ProcessUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public PINCMPDOC001(){
		super();
	}

	/**
	 * 미비서류접수 정보를 조회하는 메소드
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-01-22 15:35:09
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchIncmpDoc(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	FINCMPDOC001 fu = (FINCMPDOC001) lookupFunctionUnit(FINCMPDOC001.class);
		
			responseData = fu.fSearchIncmpDoc(requestData, onlineCtx);
			
			IRecordSet rs = responseData.getRecordSet("ds");
			
			rs.setTotalRecordCount(responseData.getIntField("count"));
			rs.setPageNo(requestData.getIntField("page"));
			rs.setRecordCountPerPage(requestData.getIntField("page_size"));
			
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
	 * 미비서류접수 정보를 입력,수정,삭제하는 메소드
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-01-22 14:09:58
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSaveIncmpDoc(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {	    	
	    	FINCMPDOC001 fu = (FINCMPDOC001) lookupFunctionUnit(FINCMPDOC001.class);			
						
			fu.fSaveIncmpDoc(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);
		
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}

	/**
	 * 미비서류접수 상세정보 조회하는 PM
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-01-22 14:09:58
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pDetailIncmpDoc(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	FINCMPDOC001 fu = (FINCMPDOC001) lookupFunctionUnit(FINCMPDOC001.class);
		
			responseData = fu.fDetailIncmpDoc(requestData, onlineCtx);	
			
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}  
	
	    return responseData;
	}

	/**
	 * 미비서류접수처리결과저장 PM
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-01-22 14:09:58
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSaveIncmpDocResult(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	FINCMPDOC001 fu = (FINCMPDOC001) lookupFunctionUnit(FINCMPDOC001.class);
		
			responseData = fu.fSaveIncmpDocResult(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}  
	
	    return responseData;
	}
  
}
