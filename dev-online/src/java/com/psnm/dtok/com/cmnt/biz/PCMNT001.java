package com.psnm.dtok.com.cmnt.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.exception.BizRuntimeException;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: PCMNT001</li>
 * <li>설  명 : 댓글관리PU</li>
 * <li>작성일 : 2014-12-05 17:04:30</li>
 * <li>작성자 : 이민재 (leeminjae)</li>
 * </ul>
 *
 * @author 이민재 (leeminjae)
 */
public class PCMNT001 extends nexcore.framework.coreext.pojo.biz.ProcessUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public PCMNT001(){
		super();
	}

	/**
	 * 댓글 목록을 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-05 17:29:24
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchCmnt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	FCMNT001 fu = (FCMNT001) lookupFunctionUnit(FCMNT001.class);
		
			responseData = fu.fSearchCmnt(requestData, onlineCtx);
			
			IRecordSet rs = responseData.getRecordSet("ds");
			
			//rs.setTotalRecordCount(responseData.getIntField("count"));
			//rs.setPageNo(requestData.getIntField("page"));
			//rs.setRecordCountPerPage(requestData.getIntField("page_size"));
			
			responseData.putRecordSet("gridcmnt", rs);
			responseData.putField("count", rs.getRecordCount());
			
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 댓글을 저장, 수정 하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-05 17:04:30
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pInsertCmnt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	FCMNT001 fu = (FCMNT001) lookupFunctionUnit(FCMNT001.class);
		
			fu.fInsertCmnt(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 댓글을 삭제하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-05 17:30:11
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pDeleteCmnt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	FCMNT001 fu = (FCMNT001) lookupFunctionUnit(FCMNT001.class);
		
			fu.fDeleteCmnt(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}
  
}
