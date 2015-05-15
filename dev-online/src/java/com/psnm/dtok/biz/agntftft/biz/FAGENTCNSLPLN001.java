package com.psnm.dtok.biz.agntftft.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.exception.BizRuntimeException;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/업무</li>
 * <li>단위업무명: FAGENTCNSLPLN001</li>
 * <li>설  명 : 면담계획/정기면담FU</li>
 * <li>작성일 : 2014-12-02 17:32:48</li>
 * <li>작성자 : 이민재 (leeminjae)</li>
 * </ul>
 *
 * @author 이민재 (leeminjae)
 */
public class FAGENTCNSLPLN001 extends nexcore.framework.coreext.pojo.biz.FunctionUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public FAGENTCNSLPLN001(){
		super();
	}

	/**
	 * 면담계획 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-02 17:32:48
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchAgentCnslPln(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		
	    try {
	    	
			DAGENTCNSLPLN001 du = (DAGENTCNSLPLN001) lookupDataUnit(DAGENTCNSLPLN001.class);
	    	
			responseData = du.dSearchAgentCnslPln(requestData, onlineCtx);
			responseData.putField("count", du.dSearchAgentCnslPlnCount(requestData, onlineCtx).getIntField("count"));
			responseData.putFieldMap(du.dSearchAgentCnslPlnTotCount(requestData, onlineCtx).getFieldMap());
			
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	    
	    return responseData;
	}

	/**
	 * 면담계획 정보를 저장하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-02 17:32:48
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fInsertAgentCnslPln(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		
	    try {
			
	    	DAGENTCNSLPLN001 du = (DAGENTCNSLPLN001) lookupDataUnit(DAGENTCNSLPLN001.class);
			
			du.dInsertAgentCnslPln(requestData, onlineCtx);

			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 면담계획 정보를 수정하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-03 15:29:19
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fUpdateAgentCnslPln(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		
	    try {
			
	    	DAGENTCNSLPLN001 du = (DAGENTCNSLPLN001) lookupDataUnit(DAGENTCNSLPLN001.class);
			
			du.dUpdateAgentCnslPln(requestData, onlineCtx);

			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 면담계획/정기면담 사용자를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-03 16:00:03
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fDetailAgentCnslPlnUser(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
			DAGENTCNSLPLN001 du = (DAGENTCNSLPLN001) lookupDataUnit(DAGENTCNSLPLN001.class);
	    	
			responseData = du.dDetailAgentCnslPlnUser(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}

	/**
	 * 면담계획/정기면담 면담자를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-03 16:00:54
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fDetailAgentCnslPlnCnslr(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
			DAGENTCNSLPLN001 du = (DAGENTCNSLPLN001) lookupDataUnit(DAGENTCNSLPLN001.class);
	    	
			responseData = du.dDetailAgentCnslPlnCnslr(requestData, onlineCtx);
			
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
	 * @since 2014-12-03 18:09:41
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fDetailAgentCnslPlnCnslDlDt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
			DAGENTCNSLPLN001 du = (DAGENTCNSLPLN001) lookupDataUnit(DAGENTCNSLPLN001.class);
	    	
			responseData = du.dDetailAgentCnslPlnCnslDlDt(requestData, onlineCtx);
			
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
	 * @since 2014-12-04 15:43:49
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fDetailAgentCnslPlnInputYn(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
			DAGENTCNSLPLN001 du = (DAGENTCNSLPLN001) lookupDataUnit(DAGENTCNSLPLN001.class);
	    	
			responseData = du.dDetailAgentCnslPlnInputYn(requestData, onlineCtx);
			
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
	 * @since 2014-12-04 17:24:38
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fDeleteAgentCnslPln(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			
	    	DAGENTCNSLPLN001 du = (DAGENTCNSLPLN001) lookupDataUnit(DAGENTCNSLPLN001.class);
			
			du.dDeleteAgentCnslPln(requestData, onlineCtx);
			
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
	 * @since 2014-12-04 17:43:42
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fDetailAgentCnslPlnCnslYn(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
			DAGENTCNSLPLN001 du = (DAGENTCNSLPLN001) lookupDataUnit(DAGENTCNSLPLN001.class);
	    	
			responseData = du.dDetailAgentCnslPlnCnslYn(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 면담계획/정기면담 면담일지를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-10 11:45:41
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fDetailAgentCnslPlnMgmt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
			DAGENTCNSLPLN001 du = (DAGENTCNSLPLN001) lookupDataUnit(DAGENTCNSLPLN001.class);
	    	
			responseData = du.dDetailAgentCnslPlnMgmt(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}
  
}
