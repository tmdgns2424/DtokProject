package com.psnm.dtok.biz.saleplcy.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.exception.BizRuntimeException;

import com.psnm.common.util.PsnmStringUtil;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/업무</li>
 * <li>단위업무명: PSALESPLCY001</li>
 * <li>설  명 : 영업정책관리PU</li>
 * <li>작성일 : 2014-11-19 16:22:56</li>
 * <li>작성자 : 이민재 (leeminjae)</li>
 * </ul>
 *
 * @author 이민재 (leeminjae)
 */
public class PSALESPLCY001 extends nexcore.framework.coreext.pojo.biz.ProcessUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public PSALESPLCY001(){
		super();
	}

	/**
	 * 영업정책관리 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-11-19 16:22:56
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchSalesPlcy(IDataSet requestData, IOnlineContext onlineCtx) {
		
		IDataSet responseData = new DataSet();
		
		try {
			FSALESPLCY001 fu = (FSALESPLCY001) lookupFunctionUnit(FSALESPLCY001.class);
		
			responseData = fu.fSearchSalesPlcy(requestData, onlineCtx);
			
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
	 * 영업정책관리 상세정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-11-19 16:22:56
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pDetailSalesPlcy(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	FSALESPLCY001 fu = (FSALESPLCY001) lookupFunctionUnit(FSALESPLCY001.class);
	    	
	    	responseData = fu.fDetailSalesPlcy(requestData, onlineCtx);
	    	
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 영업정책관리 정보를 입력, 수정, 삭제하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-11-19 16:22:56
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSaveSalesPlcy(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			FSALESPLCY001 fu = (FSALESPLCY001) lookupFunctionUnit(FSALESPLCY001.class);
			DSALESPLCY001 du = (DSALESPLCY001) lookupDataUnit(DSALESPLCY001.class);
			
			String DSM_SALES_PLCY_ID = "";
			
			if( PsnmStringUtil.isEmpty(requestData.getField("DSM_SALES_PLCY_ID")) ) {
				DSM_SALES_PLCY_ID = du.dSearchSalesPlcyIdSeq(requestData, onlineCtx).getField("DSM_SALES_PLCY_ID");
				
				requestData.putField("DSM_SALES_PLCY_ID", DSM_SALES_PLCY_ID);
				
				fu.fInsertSalesPlcy(requestData, onlineCtx);
			} else {
				fu.fUpdateSalesPlcy(requestData, onlineCtx);
			}
			
			fu.fInsertSalesPlcyGrp(requestData, onlineCtx);
			fu.fInsertSalesPlcyOrg(requestData, onlineCtx);
			
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
	 * 영업정책관리 통계를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-11-19 16:22:56
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchSalesPlcyStc(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	FSALESPLCY001 fu = (FSALESPLCY001) lookupFunctionUnit(FSALESPLCY001.class);
	    	
	    	IRecordSet rs = fu.fSearchSalesPlcyStc(requestData, onlineCtx).getRecordSet("ds");
			
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
	 * 영업정책을 삭제하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-11-19 16:22:56
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pDeleteSalesPlcy(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	FSALESPLCY001 fu = (FSALESPLCY001) lookupFunctionUnit(FSALESPLCY001.class);
	    	
	    	fu.fDeleteSalesPlcy(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 영업정책관리 접속현황을 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-11-19 16:22:56
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchSalesPlcyContact(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			FSALESPLCY001 fu = (FSALESPLCY001) lookupFunctionUnit(FSALESPLCY001.class);
		
			responseData = fu.fSearchSalesPlcyContact(requestData, onlineCtx);
			
			IRecordSet rs = responseData.getRecordSet("ds");
			
			responseData.putRecordSet("grid", rs);
			responseData.putField("count", rs.getRecordCount());
			
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 영업정책수신조직공지대상영업국 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-12 11:07:00
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchPlcyRcvOrgDeptTarget(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			FSALESPLCY001 fu = (FSALESPLCY001) lookupFunctionUnit(FSALESPLCY001.class);
		
			responseData = fu.fSearchPlcyRcvOrgDeptTarget(requestData, onlineCtx);
			
			IRecordSet rs = responseData.getRecordSet("ds");
			
			responseData.putRecordSet("grid3", rs);
			
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 영업정책정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-16 10:16:53
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchSalesPlcyBrws(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
		try {
			FSALESPLCY001 fu = (FSALESPLCY001) lookupFunctionUnit(FSALESPLCY001.class);
		
			responseData = fu.fSearchSalesPlcyBrws(requestData, onlineCtx);
			
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
	 * 영업정책관리통계영업국명 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-16 15:48:43
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchSalesPlcyStcDept(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
		try {
			FSALESPLCY001 fu = (FSALESPLCY001) lookupFunctionUnit(FSALESPLCY001.class);
		
			responseData = fu.fSearchSalesPlcyStcDept(requestData, onlineCtx);
			
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
