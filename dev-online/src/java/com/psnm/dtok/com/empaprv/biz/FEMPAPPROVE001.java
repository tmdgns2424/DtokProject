package com.psnm.dtok.com.empaprv.biz;

import com.psnm.common.util.PsnmStringUtil;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.exception.BizRuntimeException;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: FEMPAPPROVE001</li>
 * <li>설  명 : 임직원로그인관리 FU</li>
 * <li>작성일 : 2014-12-23 13:12:21</li>
 * <li>작성자 : 이민재 (leeminjae)</li>
 * </ul>
 *
 * @author 이민재 (leeminjae)
 */
public class FEMPAPPROVE001 extends nexcore.framework.coreext.pojo.biz.FunctionUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public FEMPAPPROVE001(){
		super();
	}

	/**
	 * 임직원로그인 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-23 14:15:45
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchAprove(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();

	    try {
	    	
			DEMPAPPROVE001 du = (DEMPAPPROVE001) lookupDataUnit(DEMPAPPROVE001.class);
			
			responseData = du.dSearchAprove(requestData, onlineCtx);

			requestData.putField("W_HEADQ_YN", "Y");
			responseData.putField("HEADQ_CNT", du.dSearchHeadqCnt(requestData, onlineCtx).getField("CNT"));
			requestData.putField("W_HEADQ_YN", "N");
			responseData.putField("NON_HEADQ_CNT", du.dSearchHeadqCnt(requestData, onlineCtx).getField("CNT"));

			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 임직원로그인관리 사용자 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-23 14:16:15
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchAproveUser(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
			DEMPAPPROVE001 du = (DEMPAPPROVE001) lookupDataUnit(DEMPAPPROVE001.class);
			
			responseData = du.dSearchAproveUser(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 임직원로그인관리 정보를 저장하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-23 14:16:42
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fInsertAprove(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			
	    	DEMPAPPROVE001 du = (DEMPAPPROVE001) lookupDataUnit(DEMPAPPROVE001.class);
			
			du.dInsertAprove(requestData, onlineCtx);

			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}

	/**
	 * 임직원로그인관리 정보를 삭제하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-23 14:17:33
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fDeleteAprove(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    
	    try {
	    	
	    	IRecordSet rs =  requestData.getRecordSet("grid");
			
	    	DEMPAPPROVE001 du = (DEMPAPPROVE001) lookupDataUnit(DEMPAPPROVE001.class);
	    	
	    	for(int i = 0 ; i < rs.getRecordCount() ; i++){
				IDataSet listData = new DataSet();
	    		listData.putFieldMap(rs.getRecordMap(i));
	    		
	    		if("D".equals(listData.getField("FLAG"))){
	    			du.dDeleteAprove(listData, onlineCtx);
		    		du.dDeleteAproveHeadq(listData, onlineCtx);
	    		}
			}
	    	
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 임직원로그인관리직무정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-20 16:22:46
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchDutyMgmt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
			DEMPAPPROVE001 du = (DEMPAPPROVE001) lookupDataUnit(DEMPAPPROVE001.class);
			
			responseData = du.dSearchDutyMgmt(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2014-12-23 13:12:21
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fInsertDutyChgHst(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    try {
	    	
    		IRecordSet rs =  requestData.getRecordSet("grid");
			
	    	DEMPAPPROVE001 du = (DEMPAPPROVE001) lookupDataUnit(DEMPAPPROVE001.class);
	    	
	    	if(rs != null){
	    		for(int i = 0 ; i < rs.getRecordCount() ; i++){
					IDataSet listData = new DataSet();
		    		listData.putFieldMap(rs.getRecordMap(i));
		    		
		    		if("D".equals(listData.getField("FLAG"))){
		    			listData.putField("DEL_YN", "Y");
		    			du.dInsertDutyChgHst(listData, onlineCtx);
		    		}
				}
	    	}else{
	    		du.dInsertDutyChgHst(requestData, onlineCtx);
	    	}

			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	    
	    return responseData;
	}
  
}
