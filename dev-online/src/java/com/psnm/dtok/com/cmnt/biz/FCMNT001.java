package com.psnm.dtok.com.cmnt.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.exception.BizRuntimeException;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: FCMNT001</li>
 * <li>설  명 : 댓글관리 FU</li>
 * <li>작성일 : 2014-12-05 17:05:35</li>
 * <li>작성자 : 이민재 (leeminjae)</li>
 * </ul>
 *
 * @author 이민재 (leeminjae)
 */
public class FCMNT001 extends nexcore.framework.coreext.pojo.biz.FunctionUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public FCMNT001(){
		super();
	}

	/**
	 * 댓글 목록을 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-05 17:23:13
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchCmnt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	DCMNT001 du = (DCMNT001) lookupDataUnit(DCMNT001.class);
	    	
			responseData = du.dSearchCmnt(requestData, onlineCtx);
			responseData.putField("count", du.dSearchCmntCount(requestData, onlineCtx).getIntField("count"));
			
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}

	/**
	 * 댓글을 저장하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-05 17:23:49
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fInsertCmnt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			
	    	DCMNT001 du = (DCMNT001) lookupDataUnit(DCMNT001.class);
	    	
	    	//2013.12 XSS 방지
			String ctt = requestData.getField("CMNT_CTT");
			ctt = ctt.replaceAll("<", "&lt;");
			ctt = ctt.replaceAll(">", "&gt;");
			requestData.putField("CMNT_CTT", ctt);
			
			du.dInsertCmnt(requestData, onlineCtx);

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
	 * @since 2014-12-05 17:24:18
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fDeleteCmnt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			
	    	DCMNT001 du = (DCMNT001) lookupDataUnit(DCMNT001.class);
			
			du.dDeleteCmnt(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}
  
}
