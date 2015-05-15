package com.psnm.dtok.biz.agntftft.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.exception.BizRuntimeException;

import com.psnm.common.util.PsnmStringUtil;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/업무</li>
 * <li>단위업무명: PAGENTCNSLPLN001</li>
 * <li>설  명 : 면담계획/정기면담PU</li>
 * <li>작성일 : 2014-12-02 17:32:22</li>
 * <li>작성자 : 이민재 (leeminjae)</li>
 * </ul>
 *
 * @author 이민재 (leeminjae)
 */
public class PAGENTCNSLPLN001 extends nexcore.framework.coreext.pojo.biz.ProcessUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public PAGENTCNSLPLN001(){
		super();
	}

	/**
	 * 면담계획 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-02 17:32:22
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchAgentCnslPln(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		
		try {
			FAGENTCNSLPLN001 fu = (FAGENTCNSLPLN001) lookupFunctionUnit(FAGENTCNSLPLN001.class);
			
			responseData = fu.fSearchAgentCnslPln(requestData, onlineCtx);
			
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
	 * 면담계획 정보를 입력, 수정 하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-02 17:32:22
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSaveAgentCnslPln(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		
	    try {
	    	
	    	FAGENTCNSLPLN001 fu = (FAGENTCNSLPLN001) lookupFunctionUnit(FAGENTCNSLPLN001.class);
	    	
	    	String CNSL_STA_TM = requestData.getField("CNSL_STA_TM") + requestData.getField("CNSL_STA_M");
	    	String CNSL_END_TM = requestData.getField("CNSL_END_TM") + requestData.getField("CNSL_END_M");
	    	requestData.putField("CNSL_STA_TM", CNSL_STA_TM);
	    	requestData.putField("CNSL_END_TM", CNSL_END_TM);
			
			if( PsnmStringUtil.isEmpty(requestData.getField("AGENT_CNSL_PLN_NUM")) ) {
				fu.fInsertAgentCnslPln(requestData, onlineCtx);
			}else{
				fu.fUpdateAgentCnslPln(requestData, onlineCtx);
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
	 * 면담계획 상세를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-03 15:47:26
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pDetailAgentCnslPln(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	FAGENTCNSLPLN001 fu = (FAGENTCNSLPLN001) lookupFunctionUnit(FAGENTCNSLPLN001.class);
		    
	    	IDataSet list1 = fu.fDetailAgentCnslPlnUser(requestData, onlineCtx);
	    	responseData.putFieldMap(list1.getFieldMap());
	    	
	    	if(!PsnmStringUtil.isEmpty(requestData.getField("AGENT_CNSL_PLN_NUM"))){
	    		IDataSet list2 = fu.fDetailAgentCnslPlnCnslr(requestData, onlineCtx);
	    		responseData.putFieldMap(list2.getFieldMap());
	    	}
	    	
	    	if(!PsnmStringUtil.isEmpty(requestData.getField("AGENT_CNSL_MGMT_NUM"))){
	    		IDataSet list3 = fu.fDetailAgentCnslPlnMgmt(requestData, onlineCtx);
	    		responseData.putFieldMap(list3.getFieldMap());
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
	 * 면담계획/정기면담 면접확정일자를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-03 18:10:35
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pDetailAgentCnslPlnCnslDlDt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	FAGENTCNSLPLN001 fu = (FAGENTCNSLPLN001) lookupFunctionUnit(FAGENTCNSLPLN001.class);
		    
		    responseData.putFieldMap(fu.fDetailAgentCnslPlnCnslDlDt(requestData, onlineCtx).getFieldMap());
		    
		    responseData.setOkResultMessage("PSNM-I000", null);
		    
	    } catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 면담계획/정기면담 면담횟수를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-04 15:45:49
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pDetailAgentCnslPlnInputYn(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	FAGENTCNSLPLN001 fu = (FAGENTCNSLPLN001) lookupFunctionUnit(FAGENTCNSLPLN001.class);
		    
		    responseData.putFieldMap(fu.fDetailAgentCnslPlnInputYn(requestData, onlineCtx).getFieldMap());
		    
		    responseData.setOkResultMessage("PSNM-I000", null);
		    
	    } catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 면담계획/정기면담 정보를 삭제하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-04 17:25:18
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pDeleteAgentCnslPln(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	FAGENTCNSLPLN001 fu = (FAGENTCNSLPLN001) lookupFunctionUnit(FAGENTCNSLPLN001.class);
	    	
	    	fu.fDeleteAgentCnslPln(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 면담계획/정기면담 면담가능여부를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-04 17:44:20
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pDetailAgentCnslPlnCnslYn(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	FAGENTCNSLPLN001 fu = (FAGENTCNSLPLN001) lookupFunctionUnit(FAGENTCNSLPLN001.class);
		    
		    responseData.putFieldMap(fu.fDetailAgentCnslPlnCnslYn(requestData, onlineCtx).getFieldMap());
		    
		    responseData.setOkResultMessage("PSNM-I000", null);
		    
	    } catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}
  
}
