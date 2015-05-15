package com.psnm.dtok.agn.agntmgmt.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.exception.BizRuntimeException;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/에이전트</li>
 * <li>단위업무명: FAGENTCNTRT001</li>
 * <li>설  명 : 에이전트 계약관리 FU</li>
 * <li>작성일 : 2014-11-26 09:57:17</li>
 * <li>작성자 : 한상곤 (hansanggon)</li>
 * </ul>
 *
 * @author 한상곤 (hansanggon)
 */
public class FAGENTCNTRT001 extends nexcore.framework.coreext.pojo.biz.FunctionUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public FAGENTCNTRT001(){
		super();
	}

	/**
	 * 에이전트계약 조회 FM
	 *
	 * @author 한상곤 (hansanggon)
	 * @since 2014-11-26 09:57:17
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchAgentInfo(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	  
		try{
			DAGENTCNTRT001 du = (DAGENTCNTRT001)lookupDataUnit(DAGENTCNTRT001.class);
			
			responseData = du.dSearchAgentInfo(requestData, onlineCtx);
			
			responseData.putField("count", du.dSearchAgentInfoCnt(requestData, onlineCtx).getIntField("count"));
			
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 에이전트계약정보 조회 FM
	 *
	 * @author 한상곤 (hansanggon)
	 * @since 2014-11-26 09:57:17
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchAgentCntrt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    IDataSet responseData1 = new DataSet();
	    
		requestData.putField("S_DUTY_USER_TYP", onlineCtx.getUserInfo().get("DUTY_USER_TYP").toString());
		requestData.putField("S_SALE_DEPT_ORG_ID", onlineCtx.getUserInfo().get("SALE_DEPT_ORG_ID").toString());
		requestData.putField("S_SALE_TEAM_ORG_ID", onlineCtx.getUserInfo().get("SALE_TEAM_ORG_ID").toString());
	
		try{
			
			DAGENTCNTRT001 du = (DAGENTCNTRT001)lookupDataUnit(DAGENTCNTRT001.class);
			
			responseData = du.dSearchAgentCntrt(requestData, onlineCtx);
			
			responseData.putField("count", du.dSearchAgentCntrtCnt(requestData, onlineCtx).getIntField("count"));
			
			responseData1 = du.dSearchAgentCntrtStCnt(requestData, onlineCtx);
			
			responseData.putField("CNTRT_ST_CNT1", responseData1.getField("CNTRT_ST_CNT1"));
			responseData.putField("CNTRT_ST_CNT2", responseData1.getField("CNTRT_ST_CNT2"));
			responseData.putField("CNTRT_ST_CNT3", responseData1.getField("CNTRT_ST_CNT3"));
			responseData.putField("CNTRT_ST_CNT4", responseData1.getField("CNTRT_ST_CNT4"));
			responseData.putField("CNTRT_ST_CNT5", responseData1.getField("CNTRT_ST_CNT5"));
			responseData.putField("CNTRT_ST_CNT6", responseData1.getField("CNTRT_ST_CNT6"));
			
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 에이전트계약정보 상세조회 FM
	 *
	 * @author 한상곤 (hansanggon)
	 * @since 2014-11-26 09:57:17
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fDetailAgentCntrt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    
	    try{
	    	
	    	DAGENTCNTRT001 du1 = (DAGENTCNTRT001)lookupDataUnit(DAGENTCNTRT001.class);
    	
	    	//에이전트계약정보
	    	responseData.putFieldMap(du1.dDetailAgentCntrt(requestData, onlineCtx).getFieldMap());
			
			responseData.setOkResultMessage("PSNM-I000", null);
			
	    }catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 에이전트계약정보 상태수정 FM
	 *
	 * @author 한상곤 (hansanggon)
	 * @since 2014-11-26 09:57:17
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fUpdateAgentCntrt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	DAGENTCNTRT001 du = (DAGENTCNTRT001)lookupDataUnit(DAGENTCNTRT001.class);
	    	
		    du.dUpdateAgentCntrt(requestData, onlineCtx);
		    
		    responseData.setOkResultMessage("PSNM-I000", null);
		    
	    } catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}	
	
	    return responseData;
	}

	/**
	 * 에이전트계약정보 저장 FM
	 *
	 * @author 김보선 (kimbosun)
	 * @since 2014-11-26 09:57:17
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fInsertAgentCntrt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	DAGENTCNTRT001 du = (DAGENTCNTRT001)lookupDataUnit(DAGENTCNTRT001.class);
	    	
		    du.dInsertAgentCntrt(requestData, onlineCtx);
		    
		    responseData.setOkResultMessage("PSNM-I000", null);
		    
	    } catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}	    
	    
	    return responseData;
	}

	/**
	 * 에이전트계약정보 채번 FM
	 *
	 * @author 김보선 (kimbosun)
	 * @since 2014-11-26 09:57:17
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSelectAgentCntrtNoSeq(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    DAGENTCNTRT001 du = (DAGENTCNTRT001)lookupDataUnit(DAGENTCNTRT001.class);
	    
	    responseData.putField("CNTRT_MGMT_NUM", du.dSelectAgentCntrtNoSeq(requestData, onlineCtx).getField("CNTRT_MGMT_NUM"));
	    
	    return responseData;
	}

	/**
	 * 에이전트계약정보 SMS발송조회 FU
	 *
	 * @author 김보선 (kimbosun)
	 * @since 2014-11-26 09:57:17
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSelectAgentCntrtSmsSend(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    DAGENTCNTRT001 du = (DAGENTCNTRT001)lookupDataUnit(DAGENTCNTRT001.class);
	    responseData = du.dSelectAgentCntrtSmsSend(requestData, onlineCtx);
	
	    return responseData;
	}

	/**
	 * 에이전트계약면접 현황 조회
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2014-11-26 09:57:17
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchAgentCntrtInt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    
	    try {
	    	DAGENTCNTRT001 du = (DAGENTCNTRT001)lookupDataUnit(DAGENTCNTRT001.class);
		   
			responseData = du.dSearchAgentCntrtInt(requestData, onlineCtx);
			
			responseData.putField("count", du.dSearchAgentCntrtIntCnt(requestData, onlineCtx).getIntField("count"));
			
			responseData.setOkResultMessage("PSNM-I000", null);
			
	    } catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	    
	    return responseData;
	}

	/**
	 * 에이전트계약정보 상태수정(에이전트매핑) FM
	 *
	 * @author 김보선 (kimbosun)
	 * @since 2015-03-02 16:10:56
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fUpdateAgentCntrtAgentMap(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	DAGENTCNTRT001 du = (DAGENTCNTRT001)lookupDataUnit(DAGENTCNTRT001.class);
	    	
		    du.dUpdateAgentCntrtAgentMap(requestData, onlineCtx);
		    
		    responseData.setOkResultMessage("PSNM-I000", null);
		    
	    } catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 에이전트계약정보 거래처건수조회 DM
	 *
	 * @author 김보선 (kimbosun)
	 * @since 2014-11-26 09:57:17
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSelectAgentCntrtDealCnt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	DAGENTCNTRT001 du = (DAGENTCNTRT001)lookupDataUnit(DAGENTCNTRT001.class);

	    	responseData.putField("TOTCNT", du.dSelectAgentCntrtDealCnt(requestData, onlineCtx).getField("TOTCNT"));
		   
			responseData.setOkResultMessage("PSNM-I000", null);
			
	    } catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 에이젼트계약정보 삭제 FM
	 *
	 * @author 김보선 (kimbosun)
	 * @since 2015-03-02 17:54:50
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fDeleteAgentCntrt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			
	    	DAGENTCNTRT001 du = (DAGENTCNTRT001) lookupDataUnit(DAGENTCNTRT001.class);
			
			du.dDeleteAgentCntrt(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}

	/**
	 * 에이전트계약정보 상태수정(승인취소) FM
	 *
	 * @author 김보선 (kimbosun)
	 * @since 2015-03-03 12:21:57
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fUpdateAgentCntrtAppCan(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			
	    	DAGENTCNTRT001 du = (DAGENTCNTRT001) lookupDataUnit(DAGENTCNTRT001.class);
			
			du.dUpdateAgentCntrtAppCan(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 에이전트계약정보 상태조회 FM
	 *
	 * @author 김보선 (kimbosun)
	 * @since 2015-04-13 17:56:14
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSelectAgentCntrtStCd(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    DAGENTCNTRT001 du = (DAGENTCNTRT001)lookupDataUnit(DAGENTCNTRT001.class);	    
	    responseData.putField("CNTRT_ST_CD", du.dSelectAgentCntrtStCd(requestData, onlineCtx).getField("CNTRT_ST_CD"));
	
	    return responseData;
	}
  
}
