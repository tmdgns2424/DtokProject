package com.psnm.dtok.biz.saleex.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.exception.BizRuntimeException;

import com.psnm.common.util.PsnmStringUtil;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/업무</li>
 * <li>단위업무명: PUNLAWSALEEX001</li>
 * <li>설  명 : 불/편법영업사례 PU</li>
 * <li>작성일 : 2014-12-30 10:39:25</li>
 * <li>작성자 : 이민재 (leeminjae)</li>
 * </ul>
 *
 * @author 이민재 (leeminjae)
 */
public class PUNLAWSALEEX001 extends nexcore.framework.coreext.pojo.biz.ProcessUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public PUNLAWSALEEX001(){
		super();
	}

	/**
	 * 불/편법영업사례 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-30 13:18:30
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchUnlawSaleEx(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	FUNLAWSALEEX001 fu = (FUNLAWSALEEX001) lookupFunctionUnit(FUNLAWSALEEX001.class);
		
			responseData = fu.fSearchUnlawSaleEx(requestData, onlineCtx);
			
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
	 * 불/편법영업사례 정보를 등록, 수정 하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-30 13:19:26
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSaveUnlawSaleEx(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	FUNLAWSALEEX001 fu = (FUNLAWSALEEX001) lookupFunctionUnit(FUNLAWSALEEX001.class);
	    	DUNLAWSALEEX001 du = (DUNLAWSALEEX001) lookupDataUnit(DUNLAWSALEEX001.class);
			
			String UNLAW_MGMT_NUM = "";
			
			if( PsnmStringUtil.isEmpty(requestData.getField("UNLAW_MGMT_NUM")) ) {
				UNLAW_MGMT_NUM = du.dSearchUnlawSaleExIdSeq(requestData, onlineCtx).getField("UNLAW_MGMT_NUM");
				
				requestData.putField("UNLAW_MGMT_NUM", UNLAW_MGMT_NUM);
				
				fu.fInsertUnlawSaleEx(requestData, onlineCtx);
			} else {
				fu.fUpdateUnlawSaleEx(requestData, onlineCtx);
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
	 * 불/편법영업사례상세 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-30 13:20:01
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pDetailUnlawSaleEx(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	FUNLAWSALEEX001 fu = (FUNLAWSALEEX001) lookupFunctionUnit(FUNLAWSALEEX001.class);
		    
	    	responseData = fu.fDetailUnlawSaleEx(requestData, onlineCtx);
		    
		    responseData.setOkResultMessage("PSNM-I000", null);
		    
	    } catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 불/편법영업사례 정보를 삭제하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-30 13:20:47
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pDeleteUnlawSaleEx(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	FUNLAWSALEEX001 fu = (FUNLAWSALEEX001) lookupFunctionUnit(FUNLAWSALEEX001.class);
	    	
	    	fu.fDeleteUnlawSaleEx(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}
  
}
