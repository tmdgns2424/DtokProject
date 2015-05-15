package com.psnm.dtok.agn.agntmgmt.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.exception.BizRuntimeException;
import nexcore.framework.core.util.BaseUtils;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/에이전트</li>
 * <li>단위업무명: FAGENTECCR001</li>
 * <li>설  명 : MA지원상담조회 FU</li>
 * <li>작성일 : 2014-11-19 17:32:16</li>
 * <li>작성자 : 한상곤 (hansanggon)</li>
 * </ul>
 *
 * @author 한상곤 (hansanggon)
 */
public class FAGENTECCR001 extends nexcore.framework.coreext.pojo.biz.FunctionUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public FAGENTECCR001(){
		super();
	}

	/**
	 * MA지원상담 조회 FM
	 *
	 * @author 한상곤 (hansanggon)
	 * @since 2014-11-19 17:32:16
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchAgentEccr(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
		
		try{
			requestData.putField("NEW_PRD", BaseUtils.getConfiguration("brd.new.prd"));
			
			DAPLCNSLBRD001 du = (DAPLCNSLBRD001) lookupDataUnit(DAPLCNSLBRD001.class);
			
			responseData = du.dSearchAplCnslBrd(requestData, onlineCtx);
			
			responseData.putField("count", du.dSearchAplCnslBrdCnt(requestData, onlineCtx).getIntField("count"));
			
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
 
	    return responseData;
	}

	/**
	 * MA지원상담 상세조회 FM
	 *
	 * @author 한상곤 (hansanggon)
	 * @since 2014-11-24 09:27:32
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fDetailAgentEccr(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	   
	    try {
	    	
	    	DAPLCNSLBRD001 du = (DAPLCNSLBRD001) lookupDataUnit(DAPLCNSLBRD001.class);
	    	//상세
	    	responseData = du.dDetailAplCnslBrd(requestData, onlineCtx);
			
		    responseData.setOkResultMessage("PSNM-I000", null);
	    	
	    } catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
 
	    return responseData;
	}

	/**
	 * MA지원상담 상담국배정및상태수정 FM
	 *
	 * @author 한상곤 (hansanggon)
	 * @since 2014-11-19 17:32:16
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fUpdateAgentEccr(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	   
	    try{
			DAPLCNSLBRD001 du = (DAPLCNSLBRD001) lookupDataUnit(DAPLCNSLBRD001.class);
			
			du.dUpdateAplCnslBrd(requestData, onlineCtx).getIntField("result");
			//responseData.putField("APL_ST_CD", requestData.getField("APL_ST_CD"));		
		
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * MA지원상담 저장 FM
	 *
	 * @author 김보선 (kimbosun)
	 * @since 2014-11-19 17:32:16
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fMergeAgentEccr(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    
	    try {
	    	DAPLCNSLBRD001 du = (DAPLCNSLBRD001) lookupDataUnit(DAPLCNSLBRD001.class);
	    	du.dMergeAgentEccr(requestData, onlineCtx);
	    	
	    	responseData.setOkResultMessage("PSNM-I000", null);
	    	
	    } catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	    
	    return responseData;
	}

	/**
	 * MA지원상담 채번 FM
	 *
	 * @author 김보선 (kimbosun)
	 * @since 2015-02-17 14:31:01
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSelectAgentEccrNoSeq(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	DAPLCNSLBRD001 du = (DAPLCNSLBRD001) lookupDataUnit(DAPLCNSLBRD001.class);

	    	responseData.putField("APLCNSL_MGMT_NUM", du.dSelectAgentEccrNoSeq(requestData, onlineCtx).getField("APLCNSL_MGMT_NUM"));
	    	
	    	responseData.setOkResultMessage("PSNM-I000", null);
	    	
	    } catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * MA지원상담 삭제 FM
	 *
	 * @author 김보선 (kimbosun)
	 * @since 2015-02-23 18:33:20
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fDeleteAgentEccr(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	DAPLCNSLBRD001 du = (DAPLCNSLBRD001) lookupDataUnit(DAPLCNSLBRD001.class);

	    	du.dDeleteAgentEccr(requestData, onlineCtx);
	    	
	    	responseData.setOkResultMessage("PSNM-I000", null);
	    	
	    } catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * MA지원상담 에이전트ID저장 FM
	 *
	 * @author 김보선 (kimbosun)
	 * @since 2015-03-02 10:22:03
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fUpdateAgentEccrAgentId(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	DAPLCNSLBRD001 du = (DAPLCNSLBRD001) lookupDataUnit(DAPLCNSLBRD001.class);

	    	du.dUpdateAplCnslBrdAgentId(requestData, onlineCtx);
	    	
	    	responseData.setOkResultMessage("PSNM-I000", null);
	    	
	    } catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * MA지원상담 SMS발송조회 FM
	 *
	 * @author 김보선 (kimbosun)
	 * @since 2015-03-05 13:48:45
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSelectAgentEccrSmsSend(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    DAPLCNSLBRD001 du = (DAPLCNSLBRD001) lookupDataUnit(DAPLCNSLBRD001.class);
	    responseData = du.dSelectAgentEccrSmsSend(requestData, onlineCtx);
	
	    return responseData;
	}
  
}
