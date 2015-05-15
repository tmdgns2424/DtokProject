package com.psnm.dtok.com.ppcnslmgmt.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.exception.BizRuntimeException;

import com.psnm.common.util.PsnmStringUtil;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: PP2PCNSLMGMT001</li>
 * <li>설  명 : 무엇이든물어보세요 PU</li>
 * <li>작성일 : 2014-12-11 17:46:22</li>
 * <li>작성자 : 이승훈 (leeseunghun)</li>
 * </ul>
 *
 * @author 이승훈 (leeseunghun)
 */
public class PP2PCNSLMGMT001 extends nexcore.framework.coreext.pojo.biz.ProcessUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public PP2PCNSLMGMT001(){
		super();
	}

	/**
	 * 무엇이든물어보세요 정보를 조회하는 메소드
	 *
	 * @author 이승훈 (leeseunghun)
	 * @since 2014-12-11 17:46:22
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchP2pCnsl(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
			FP2PCNSLMGMT001 fu = (FP2PCNSLMGMT001) lookupFunctionUnit(FP2PCNSLMGMT001.class);		    
		    responseData = fu.fSearchP2pCnsl(requestData, onlineCtx);
		    
		    IRecordSet rs = responseData.getRecordSet("ds");	    
		    rs.setTotalRecordCount(responseData.getIntField("count"));
			rs.setPageNo(requestData.getIntField("page"));
			rs.setRecordCountPerPage(requestData.getIntField("page_size"));
			
			responseData.putRecordSet("grid", rs);
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
	 * @since 2014-12-11 17:46:22
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pDetailP2pCnsl(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	FP2PCNSLMGMT001 fu = (FP2PCNSLMGMT001) lookupFunctionUnit(FP2PCNSLMGMT001.class);
		    responseData = fu.fDetailP2pCnsl(requestData, onlineCtx);
		    
			responseData.setOkResultMessage("MSTAE00010", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("MSTAE00000", e);
		}
	
	    return responseData;
	}

	/**
	 * 무엇이든물어보세요 정보를 등록, 수정 하는 메소드
	 *
	 * @author 이승훈 (leeseunghun)
	 * @since 2014-12-11 17:46:22
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSaveP2pCnsl(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	FP2PCNSLMGMT001 fu = (FP2PCNSLMGMT001) lookupFunctionUnit(FP2PCNSLMGMT001.class);
	    	DP2PCNSLMGMT001 du = (DP2PCNSLMGMT001) lookupDataUnit(DP2PCNSLMGMT001.class);
			
			String BLTCONT_ID = "";
			
			if( PsnmStringUtil.isEmpty(requestData.getField("BLTCONT_ID")) ) {
				BLTCONT_ID = du.dSearchP2pCnslIdSeq(requestData, onlineCtx).getField("BLTCONT_ID");				
				requestData.putField("BLTCONT_ID", BLTCONT_ID);
				
				fu.fInsertP2pCnsl(requestData, onlineCtx);
			} else {
				fu.fUpdateP2pCnsl(requestData, onlineCtx);
			}
			
			//첨부파일 저장
			if(requestData.getRecordSet("gridfile") != null){
				//첨부파일 정보를 저장(등록 | 삭제) : 공유컴포넌트 호출
				callSharedBizComponentByDirect("com.SHARE", "fSaveFileList", requestData, onlineCtx);
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
	 * 무엇이든물어보세요 정보를 삭제한다
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-14 15:22:43
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pDeleteP2pCnsl(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	FP2PCNSLMGMT001 fu = (FP2PCNSLMGMT001) lookupFunctionUnit(FP2PCNSLMGMT001.class);
			
			fu.fDeleteP2pCnsl(requestData, onlineCtx);
			
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
	 * @since 2015-01-14 17:16:50
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pInsertP2pCnslRejnd(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	FP2PCNSLMGMT001 fu = (FP2PCNSLMGMT001) lookupFunctionUnit(FP2PCNSLMGMT001.class);
	    	DP2PCNSLMGMT001 du = (DP2PCNSLMGMT001) lookupDataUnit(DP2PCNSLMGMT001.class);
			
	    	requestData.putField("ORGL_BLTCONT_ID", requestData.getField("BLTCONT_ID"));

	    	String BLTCONT_ID = du.dSearchP2pCnslIdSeq(requestData, onlineCtx).getField("BLTCONT_ID");	
			requestData.putField("BLTCONT_ID", BLTCONT_ID);
			
			fu.fInsertP2pCnslRejnd(requestData, onlineCtx);
			
			//첨부파일 저장
			if(requestData.getRecordSet("gridfile") != null){
				//첨부파일 정보를 저장(등록 | 삭제) : 공유컴포넌트 호출
				callSharedBizComponentByDirect("com.SHARE", "fSaveFileList", requestData, onlineCtx);
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
