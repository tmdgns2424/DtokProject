package com.psnm.dtok.com.ppcnslmgmt.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.exception.BizRuntimeException;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: FP2PCNSLMGMT001</li>
 * <li>설  명 : 무엇이든물어보세요 FU</li>
 * <li>작성일 : 2014-12-11 17:47:12</li>
 * <li>작성자 : 이승훈 (leeseunghun)</li>
 * </ul>
 *
 * @author 이승훈 (leeseunghun)
 */
public class FP2PCNSLMGMT001 extends nexcore.framework.coreext.pojo.biz.FunctionUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public FP2PCNSLMGMT001(){
		super();
	}

	/**
	 * 무엇이든물어보세요 정보를 조회하는 메소드
	 *
	 * @author 이승훈 (leeseunghun)
	 * @since 2014-12-11 17:47:12
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchP2pCnsl(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
			String ATTC_CAT = onlineCtx.getUserInfo().get("ATTC_CAT").toString(); //1차 - dutyTypCd
			
			if(("1".equals(ATTC_CAT) || "2".equals(ATTC_CAT))){
				requestData.putField("ALL_YN", "Y");
			}else{
				requestData.putField("ALL_YN", "N");
			}
	    	
	    	DP2PCNSLMGMT001 du = (DP2PCNSLMGMT001) lookupDataUnit(DP2PCNSLMGMT001.class);
			responseData = du.dSearchP2pCnsl(requestData, onlineCtx);
			responseData.putField("count", du.dSearchP2pCnslCount(requestData, onlineCtx).getIntField("count"));
			
			responseData.setOkResultMessage("MSTAE00010", null);
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("MSTAE00000", e);
		}
	
	    return responseData;
	}
	
	/**
	 * 무엇이든물어보세요상세 정보를 조회하는 메소드
	 *
	 * @author 이승훈 (leeseunghun)
	 * @since 2014-12-11 17:47:12
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fDetailP2pCnsl(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	DP2PCNSLMGMT001 du = (DP2PCNSLMGMT001) lookupDataUnit(DP2PCNSLMGMT001.class);
			responseData = du.dDetailP2pCnsl(requestData, onlineCtx);
			
			//첨부파일 조회
    		IDataSet fileDataset = callSharedBizComponentByDirect("com.SHARE", "fSearchFileMapping", requestData, onlineCtx);
    		responseData.putRecordSet("gridfile", fileDataset.getRecordSet("ds"));
			
			responseData.setOkResultMessage("MSTAE00010", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("MSTAE00000", e);
		}
	
	    return responseData;
	}  

	/**
	 * 무엇이든물어보세요 정보를 저장하는 메소드
	 *
	 * @author 이승훈 (leeseunghun)
	 * @since 2014-12-11 17:47:12
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fInsertP2pCnsl(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			
	    	DP2PCNSLMGMT001 du = (DP2PCNSLMGMT001) lookupDataUnit(DP2PCNSLMGMT001.class);
			
			du.dInsertP2pCnsl(requestData, onlineCtx);
			
	    	IDataSet _ds_sms = du.dSearchP2pCnslSms(requestData, onlineCtx);
	    	
	    	_ds_sms.putField("TRAN_MENU_ID", "4301");
	    	_ds_sms.putField("TRAN_TYP_CD", "45");
	    	_ds_sms.putField("TRAN_SYS", "TKEY");

	    	responseData = callSharedBizComponentByDirect("com.SHARE", "fSendSms", _ds_sms, onlineCtx);

			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}

	/**
	 * 무엇이든물어보세요 정보를 수정하는 메소드
	 *
	 * @author 이승훈 (leeseunghun)
	 * @since 2014-12-11 17:47:12
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fUpdateP2pCnsl(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {				
	    	
	    	DP2PCNSLMGMT001 du = (DP2PCNSLMGMT001) lookupDataUnit(DP2PCNSLMGMT001.class);	
	    	
			du.dUpdateP2pCnsl(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 무엇이든물어보세요 정보를 삭제하는 메소드
	 *
	 * @author 이승훈 (leeseunghun)
	 * @since 2014-12-11 17:47:12
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fDeleteP2pCnsl(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {				
	    	
	    	DP2PCNSLMGMT001 du = (DP2PCNSLMGMT001) lookupDataUnit(DP2PCNSLMGMT001.class);	
	    	
			du.dDeleteP2pCnsl(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 무엇이든물어보세요답글 정보를 저장하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-14 16:48:42
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fInsertP2pCnslRejnd(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			
	    	DP2PCNSLMGMT001 du = (DP2PCNSLMGMT001) lookupDataUnit(DP2PCNSLMGMT001.class);
			
			du.dInsertP2pCnslRejnd(requestData, onlineCtx);
			
			IDataSet _ds_sms = du.dSearchP2pCnslRejndSms(requestData, onlineCtx);
	    	
	    	_ds_sms.putField("TRAN_MENU_ID", "4301");
	    	_ds_sms.putField("TRAN_TYP_CD", "46");
	    	_ds_sms.putField("TRAN_SYS", "TKEY");

	    	responseData = callSharedBizComponentByDirect("com.SHARE", "fSendSms", _ds_sms, onlineCtx);

			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}
	
}
