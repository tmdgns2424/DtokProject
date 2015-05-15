package com.psnm.dtok.biz.saleplan.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.exception.BizRuntimeException;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/업무</li>
 * <li>단위업무명: PMTHSALESPLAN001</li>
 * <li>설  명 : 월별영업계획관리 PU</li>
 * <li>작성일 : 2015-02-11 11:11:49</li>
 * <li>작성자 : 이민재 (leeminjae)</li>
 * </ul>
 *
 * @author 이민재 (leeminjae)
 */
public class PMTHSALESPLAN001 extends nexcore.framework.coreext.pojo.biz.ProcessUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public PMTHSALESPLAN001(){
		super();
	}

	/**
	 * 월별영업계획관리등록정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-11 11:11:49
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchMthExecTrgt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	FMTHSALESPLAN001 fu = (FMTHSALESPLAN001) lookupFunctionUnit(FMTHSALESPLAN001.class);
		
			IRecordSet rs1 = fu.fSearchMthExecTrgt(requestData, onlineCtx).getRecordSet("ds");
			IRecordSet rs2 = fu.fSearchMthExecTrgtQty(requestData, onlineCtx).getRecordSet("ds");
			IRecordSet rs3 = fu.fSearchMthStrdCttB(requestData, onlineCtx).getRecordSet("ds");
			IRecordSet rs4 = fu.fSearchMthStrdCttC(requestData, onlineCtx).getRecordSet("ds");
			IRecordSet rs5 = fu.fSearchMthStrdCttP(requestData, onlineCtx).getRecordSet("ds");
			IRecordSet rs6 = fu.fSearchMthTrgtTeam(requestData, onlineCtx).getRecordSet("ds");
			
			responseData.putRecordSet("gridtrgt", rs1);
			responseData.putRecordSet("gridtrgtqty", rs2);
			responseData.putRecordSet("gridcttb", rs3);
			responseData.putRecordSet("gridcttc", rs4);
			responseData.putRecordSet("gridcttp", rs5);
			responseData.putRecordSet("gridteam", rs6);
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}

	/**
	 * 월별영업계획관리 정보를 등록,수정 하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-12 15:26:23
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSaveMthDsmTrgtHeadq(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	FMTHSALESPLAN001 fu = (FMTHSALESPLAN001) lookupFunctionUnit(FMTHSALESPLAN001.class);
		
	    	fu.fInsertMthDsmTrgtHeadq(requestData, onlineCtx);
	    	
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 월별영업계획관리 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-11 11:11:49
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchHeadSalePlan(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	FMTHSALESPLAN001 fu = (FMTHSALESPLAN001) lookupFunctionUnit(FMTHSALESPLAN001.class);
		
			responseData = fu.fSearchHeadSalePlan(requestData, onlineCtx);
			
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
	 * 월별영업계획관리계획기간 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-11 11:11:49
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchSalePlanCnslDlDt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	FMTHSALESPLAN001 fu = (FMTHSALESPLAN001) lookupFunctionUnit(FMTHSALESPLAN001.class);
	    	
	    	IDataSet list = fu.fSearchSalePlanCnslDlDt(requestData, onlineCtx);
			
    		responseData.putFieldMap(list.getFieldMap());
			
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}

	/**
	 * 월별영업계획관리등록정보영업팀 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-11 11:11:49
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchMthExecTrgtTeam(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	FMTHSALESPLAN001 fu = (FMTHSALESPLAN001) lookupFunctionUnit(FMTHSALESPLAN001.class);
		
			IRecordSet rs1 = fu.fSearchMthExecTrgtTeam(requestData, onlineCtx).getRecordSet("ds");
			IRecordSet rs2 = fu.fSearchMthExecTrgtQtyTeam(requestData, onlineCtx).getRecordSet("ds");
			IRecordSet rs3 = fu.fSearchMthStrdCttB(requestData, onlineCtx).getRecordSet("ds");
			IRecordSet rs4 = fu.fSearchMthStrdCttC(requestData, onlineCtx).getRecordSet("ds");
			IRecordSet rs5 = fu.fSearchMthStrdCttP(requestData, onlineCtx).getRecordSet("ds");
			IRecordSet rs6 = fu.fSearchMthTrgtTeamAgnt(requestData, onlineCtx).getRecordSet("ds");
			IRecordSet rs7 = fu.fSearchMthTrgtTeamAgntPrsnCnt(requestData, onlineCtx).getRecordSet("ds");
			IRecordSet rs8 = fu.fSearchMthTrgtTeam(requestData, onlineCtx).getRecordSet("ds");
			
			responseData.putRecordSet("gridtrgt", rs1);
			responseData.putRecordSet("gridtrgtqty", rs2);
			responseData.putRecordSet("gridcttb", rs3);
			responseData.putRecordSet("gridcttc", rs4);
			responseData.putRecordSet("gridcttp", rs5);
			responseData.putRecordSet("gridteam", rs6);
			if(rs7.getRecordCount() != 0){
				responseData.putField("PRSN_CNT", rs7.get(0, 0));
				responseData.putField("ACTV_PRSN_CNT", rs7.get(0, 1));
				responseData.putField("INCP_PLAN_PRSN_CNT", rs7.get(0, 2));
			}
			responseData.putRecordSet("gridheadq", rs8);
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}

	/**
	 * 월별영업계획관리영업팀 정보를 등록,수정하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-24 10:32:10
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSaveMthDsmTrgtTeam(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	FMTHSALESPLAN001 fu = (FMTHSALESPLAN001) lookupFunctionUnit(FMTHSALESPLAN001.class);
		
	    	fu.fInsertMthDsmTrgtTeam(requestData, onlineCtx);
	    	
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}
  
}
