package com.psnm.dtok.biz.agntftft.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.exception.BizRuntimeException;

import org.apache.commons.lang.StringUtils;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/업무</li>
 * <li>단위업무명: PAGENTCNSL001</li>
 * <li>설  명 : 면담계획/수시면담 PU</li>
 * <li>작성일 : 2014-12-12 10:39:53</li>
 * <li>작성자 : 이민재 (leeminjae)</li>
 * </ul>
 *
 * @author 이민재 (leeminjae)
 */
public class PAGENTCNSL001 extends nexcore.framework.coreext.pojo.biz.ProcessUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public PAGENTCNSL001(){
		super();
	}

	/**
	 * 면담계획/수시면담을 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-12 10:45:50
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchAgentCnsl(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	FAGENTCNSL001 fu = (FAGENTCNSL001) lookupFunctionUnit(FAGENTCNSL001.class);
			
			responseData = fu.fSearchAgentCnsl(requestData, onlineCtx);
			
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
	 * 면담계획/수시면담을 저장,수정 하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-12 10:39:53
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSaveAgentCnsl(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	FAGENTCNSL001 fu = (FAGENTCNSL001) lookupFunctionUnit(FAGENTCNSL001.class);
			
	    	fu.fInsertAgentCnsl(requestData, onlineCtx);
	    	
	    	//SMS 전송로직
	    	String ATTC_CAT = onlineCtx.getUserInfo().get("ATTC_CAT").toString();
	    	
	    	if ( !StringUtils.equals("1", ATTC_CAT) || !StringUtils.equals("2", ATTC_CAT) || !StringUtils.equals("3", ATTC_CAT) ) {
	    		DAGENTCNSL001 du = (DAGENTCNSL001) lookupDataUnit(DAGENTCNSL001.class);
		    	
		    	IDataSet _ds_sms = du.dSearchAgentCnslSms(requestData, onlineCtx);
		    	
		    	_ds_sms.putField("TRAN_MENU_ID", "6101");
		    	_ds_sms.putField("TRAN_TYP_CD", "01");
		    	_ds_sms.putField("TRAN_SYS", "TKEY");

		    	responseData = callSharedBizComponentByDirect("com.SHARE", "fSendSms", _ds_sms, onlineCtx);
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
	 * 면담계획/수시면담을 삭제하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-12 15:38:22
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pDeleteAgentCnsl(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	FAGENTCNSL001 fu = (FAGENTCNSL001) lookupFunctionUnit(FAGENTCNSL001.class);
	    	
	    	fu.fDeleteAgentCnsl(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}
  
}
