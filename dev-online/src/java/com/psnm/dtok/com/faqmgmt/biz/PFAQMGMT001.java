package com.psnm.dtok.com.faqmgmt.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.exception.BizRuntimeException;

import com.psnm.common.util.PsnmStringUtil;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: PFAQMGMT001</li>
 * <li>설  명 : FAQ관리 PU</li>
 * <li>작성일 : 2014-12-11 15:48:22</li>
 * <li>작성자 : 이승훈 (leeseunghun)</li>
 * </ul>
 *
 * @author 이승훈 (leeseunghun)
 */
public class PFAQMGMT001 extends nexcore.framework.coreext.pojo.biz.ProcessUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public PFAQMGMT001(){
		super();
	}
	
	/**
	 * FAQ정보를 조회하는 메소드
	 *
	 * @author 이승훈 (leeseunghun)
	 * @since 2014-12-11 15:48:22
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchFaq(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
		
		try {
			
			FFAQMGMT001 fu = (FFAQMGMT001) lookupFunctionUnit(FFAQMGMT001.class);	
			
		    responseData = fu.fSearchFaq(requestData, onlineCtx);
		    
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
	 * FAQ상세 정보를 조회하는 메소드
	 *
	 * @author 이승훈 (leeseunghun)
	 * @since 2014-12-11 15:48:22
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pDetailFaq(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	FFAQMGMT001 fu = (FFAQMGMT001) lookupFunctionUnit(FFAQMGMT001.class);
	    	
	    	responseData = fu.fDetailFaq(requestData, onlineCtx);
	    	
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * FAQ 정보를 입력, 수정하는 메소드
	 *
	 * @author 이승훈 (leeseunghun)
	 * @since 2014-12-11 15:48:22
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSaveFaq(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
			FFAQMGMT001 fu = (FFAQMGMT001) lookupFunctionUnit(FFAQMGMT001.class);
			DFAQMGMT001 du = (DFAQMGMT001) lookupDataUnit(DFAQMGMT001.class);
			
			String FAQ_ID = "";
			
			if( PsnmStringUtil.isEmpty(requestData.getField("FAQ_ID")) ) {
				FAQ_ID = du.dSearchFaqIdSeq(requestData, onlineCtx).getField("FAQ_ID");				
				requestData.putField("FAQ_ID", FAQ_ID);
				
				fu.fInsertFaq(requestData, onlineCtx);
			} else {
				fu.fUpdateFaq(requestData, onlineCtx);
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
	 * FAQ 정보를 삭제하는 메소드
	 *
	 * @author 이승훈 (leeseunghun)
	 * @since 2014-12-11 15:48:22
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pDeleteFaq(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	FFAQMGMT001 fu = (FFAQMGMT001) lookupFunctionUnit(FFAQMGMT001.class);
			
			fu.fDeleteFaq(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);
		
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * FAQ 게시자 정보를 조회하는 메소드
	 *
	 * @author 이승훈 (leeseunghun)
	 * @since 2014-12-11 15:48:22
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchFaqRgstrNm(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
		
		try {
			
			FFAQMGMT001 fu = (FFAQMGMT001) lookupFunctionUnit(FFAQMGMT001.class);	
			
		    responseData = fu.fSearchFaqRgstrNm(requestData, onlineCtx);
		    IRecordSet rs = responseData.getRecordSet("ds");
		    
		    responseData.putRecordSet("resultList", rs);
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}
  
}
