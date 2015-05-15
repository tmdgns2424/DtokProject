package com.psnm.dtok.biz.agntprz.biz;

import com.psnm.common.util.PsnmStringUtil;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.exception.BizRuntimeException;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/업무</li>
 * <li>단위업무명: PAGENTPRZ001</li>
 * <li>설  명 : 포상관리 PU</li>
 * <li>작성일 : 2014-11-26 18:18:15</li>
 * <li>작성자 : 한상곤 (hansanggon)</li>
 * </ul>
 *
 * @author 한상곤 (hansanggon)
 */
public class PAGENTPRZ001 extends nexcore.framework.coreext.pojo.biz.ProcessUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public PAGENTPRZ001(){
		super();
	}

	/**
	 * 포상관리 정보를 조회하는 메소드
	 *
	 * @author 한상곤 (hansanggon)
	 * @since 2014-11-26 18:18:15
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchAgentPrz(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    
	    try {
			
	    	FAGENTPRZ001 fu = (FAGENTPRZ001)lookupFunctionUnit(FAGENTPRZ001.class);
			
	    	responseData = fu.fSearchAgentPrz(requestData, onlineCtx);
	    	
	    	IRecordSet rs = responseData.getRecordSet("ds");
			
			rs.setTotalRecordCount(responseData.getIntField("count"));
			rs.setPageNo(requestData.getIntField("page"));
			rs.setRecordCountPerPage(requestData.getIntField("page_size"));
			
			responseData.putRecordSet("grid", rs);
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000");
		}
	
	    return responseData;
	}

	/**
	 * 포상관리 상세정보를 조회하는 메소드
	 *
	 * @author 한상곤 (hansanggon)
	 * @since 2014-11-26 18:18:15
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pDetailAgentPrz(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    
	    try {
			
	    	FAGENTPRZ001 fu = (FAGENTPRZ001)lookupFunctionUnit(FAGENTPRZ001.class);
			
	    	responseData = fu.fDetailAgentPrz(requestData, onlineCtx);
	    	
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000");
		}
	
	    return responseData;
	}

	/**
	 * 포상관리를 등록, 수정하는 메소드
	 *
	 * @author 한상곤 (hansanggon)
	 * @since 2014-11-26 18:18:15
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSaveAgentPrz(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    
	    try {
			
	    	FAGENTPRZ001 fu = (FAGENTPRZ001)lookupFunctionUnit(FAGENTPRZ001.class);
	    	
	    	if( PsnmStringUtil.isEmpty(requestData.getField("PRZ_MGMT_NUM")) ) {
				
	    		fu.fInsertAgentPrz(requestData, onlineCtx);
			} else {
				fu.fUpdateAgentPrz(requestData, onlineCtx);
			}
	    	    	
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000");
		}
	
	    return responseData;
	}

	/**
	 * 포상관리 엑셀업로드 PM
	 *
	 * @author 한상곤 (hansanggon)
	 * @since 2014-11-26 18:18:15
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSaveExlAgentPrz(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    
	    try {
			
	    	FAGENTPRZ001 fu = (FAGENTPRZ001)lookupFunctionUnit(FAGENTPRZ001.class);
			
	    	responseData = fu.fInsertExlAgentPrz(requestData, onlineCtx);
	    	    	
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000");
		}
	
	    return responseData;
	}

	/**
	 * 포상관리정보를 삭제하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-20 11:49:21
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pDeleteAgentPrz(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			
	    	FAGENTPRZ001 fu = (FAGENTPRZ001)lookupFunctionUnit(FAGENTPRZ001.class);
			
	    	responseData = fu.fDeleteAgentPrz(requestData, onlineCtx);
	    	
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000");
		}
	
	    return responseData;
	}
  
}
