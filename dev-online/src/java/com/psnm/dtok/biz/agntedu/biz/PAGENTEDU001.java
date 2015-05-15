package com.psnm.dtok.biz.agntedu.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.exception.BizRuntimeException;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/업무</li>
 * <li>단위업무명: PAGENTEDU001</li>
 * <li>설  명 : 교육관리PU</li>
 * <li>작성일 : 2014-11-24 17:33:25</li>
 * <li>작성자 : 이민재 (leeminjae)</li>
 * </ul>
 *
 * @author 이민재 (leeminjae)
 */
public class PAGENTEDU001 extends nexcore.framework.coreext.pojo.biz.ProcessUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public PAGENTEDU001(){
		super();
	}

	/**
	 * 교육 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-11-24 17:34:09
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchAgentEdu(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	FAGENTEDU001 fu = (FAGENTEDU001) lookupFunctionUnit(FAGENTEDU001.class);
			
			responseData = fu.fSearchAgentEdu(requestData, onlineCtx);
			
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
	 * 교육관리 상세를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-15 11:01:43
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pDetailAgentEdu(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	FAGENTEDU001 fu = (FAGENTEDU001) lookupFunctionUnit(FAGENTEDU001.class);
	    	
	    	responseData.putFieldMap(fu.fDetailAgentEdu(requestData, onlineCtx).getFieldMap());
	    	responseData.putRecordSet("grid1",fu.fDetailAgentEduAtndr(requestData, onlineCtx).getRecordSet("ds"));
	    	
	    	//첨부파일 조회
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
	 * 교육관리참석자 엑셀업로드 정보를 조회한다.
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-16 15:31:48
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchAgentEduAtndr(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	FAGENTEDU001 fu = (FAGENTEDU001) lookupFunctionUnit(FAGENTEDU001.class);
			
			responseData = fu.fSearchAgentEduAtndr(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);
		
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 교육관리 정보를 입력, 수정 하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-17 10:47:58
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSaveAgentEdu(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	FAGENTEDU001 fu = (FAGENTEDU001) lookupFunctionUnit(FAGENTEDU001.class);
			
			fu.fInsertAgentEdu(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);
		
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 교육관리 정보를 삭제하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-17 11:40:42
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pDeleteAgentEdu(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	FAGENTEDU001 fu = (FAGENTEDU001) lookupFunctionUnit(FAGENTEDU001.class);
			
			fu.fDeleteAgentEdu(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);
		
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 교육현황 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-26 10:35:09
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchAgentEduPrst(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	FAGENTEDU001 fu = (FAGENTEDU001) lookupFunctionUnit(FAGENTEDU001.class);
			
			responseData = fu.fSearchAgentEduPrst(requestData, onlineCtx);
			
			IRecordSet rs = responseData.getRecordSet("ds");
			
			rs.setTotalRecordCount(responseData.getIntField("count"));
			rs.setPageNo(requestData.getIntField("page"));
			rs.setRecordCountPerPage(requestData.getIntField("page_size"));
			
			responseData.putRecordSet("gridedu", rs);
			responseData.setOkResultMessage("PSNM-I000", null);
		
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}
  
}
