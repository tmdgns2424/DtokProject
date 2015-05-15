package com.psnm.dtok.biz.agntprz.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.exception.BizRuntimeException;

import com.psnm.common.util.PsnmStringUtil;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/업무</li>
 * <li>단위업무명: PAGENTDSCPL001</li>
 * <li>설  명 : 징계관리 PU</li>
 * <li>작성일 : 2015-01-20 13:21:05</li>
 * <li>작성자 : 이민재 (leeminjae)</li>
 * </ul>
 *
 * @author 이민재 (leeminjae)
 */
public class PAGENTDSCPL001 extends nexcore.framework.coreext.pojo.biz.ProcessUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public PAGENTDSCPL001(){
		super();
	}

	/**
	 * 징계관리정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-20 14:03:40
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchAgentDscpl(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			
	    	FAGENTDSCPL001 fu = (FAGENTDSCPL001)lookupFunctionUnit(FAGENTDSCPL001.class);
			
	    	responseData = fu.fSearchAgentDscpl(requestData, onlineCtx);
	    	
	    	IRecordSet rs = responseData.getRecordSet("ds");
			
			rs.setTotalRecordCount(responseData.getIntField("count"));
			rs.setPageNo(requestData.getIntField("page"));
			rs.setRecordCountPerPage(requestData.getIntField("page_size"));
			
			responseData.putRecordSet("grid", rs);
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000");
		} 
	
	    return responseData;
	}

	/**
	 * 징계관리상세 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-20 14:05:40
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pDetailAgentDscpl(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			
	    	FAGENTDSCPL001 fu = (FAGENTDSCPL001)lookupFunctionUnit(FAGENTDSCPL001.class);
			
	    	responseData = fu.fDetailAgentDscpl(requestData, onlineCtx);
	    	
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000");
		} 
	
	    return responseData;
	}

	/**
	 * 징계관리정보를 등록,수정 하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-20 14:06:40
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSaveAgentDscpl(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			
	    	FAGENTDSCPL001 fu = (FAGENTDSCPL001)lookupFunctionUnit(FAGENTDSCPL001.class);
	    	
	    	if( PsnmStringUtil.isEmpty(requestData.getField("DISPL_MGMT_NUM")) ) {
				
	    		fu.fInsertAgentDscpl(requestData, onlineCtx);
			} else {
				fu.fUpdateAgentDscpl(requestData, onlineCtx);
			}
	    	    	
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000");
		} 
	
	    return responseData;
	}

	/**
	 * 징계관리엑셀업로드 정보를 저장하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-20 14:07:28
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSaveExlAgentDscpl(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			
	    	FAGENTDSCPL001 fu = (FAGENTDSCPL001)lookupFunctionUnit(FAGENTDSCPL001.class);
			
	    	responseData = fu.fInsertExlAgentDscpl(requestData, onlineCtx);
	    	    	
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000");
		} 
	
	    return responseData;
	}

	/**
	 * 징계관리정보를 삭제하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-20 14:07:56
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pDeleteAgentDscpl(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			
	    	FAGENTDSCPL001 fu = (FAGENTDSCPL001)lookupFunctionUnit(FAGENTDSCPL001.class);
			
	    	responseData = fu.fDeleteAgentDscpl(requestData, onlineCtx);
	    	
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000");
		} 
	
	    return responseData;
	}
  
}
