package com.psnm.dtok.biz.saleplan.biz;

import java.text.SimpleDateFormat;
import java.util.Calendar;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.exception.BizRuntimeException;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/업무</li>
 * <li>단위업무명: FMTHSALESPLAN001</li>
 * <li>설  명 : 월별영업계획관리 FU</li>
 * <li>작성일 : 2015-02-11 11:12:21</li>
 * <li>작성자 : 이민재 (leeminjae)</li>
 * </ul>
 *
 * @author 이민재 (leeminjae)
 */
public class FMTHSALESPLAN001 extends nexcore.framework.coreext.pojo.biz.FunctionUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public FMTHSALESPLAN001(){
		super();
	}

	/**
	 * 월별영업실적 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-11 11:35:55
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchMthExecTrgt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	DMTHSALESPLAN001 du = (DMTHSALESPLAN001) lookupDataUnit(DMTHSALESPLAN001.class);
	    	
			responseData = du.dSearchMthExecTrgt(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 월별목표수량 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-11 11:36:32
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchMthExecTrgtQty(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	DMTHSALESPLAN001 du = (DMTHSALESPLAN001) lookupDataUnit(DMTHSALESPLAN001.class);
	    	
			responseData = du.dSearchMthExecTrgtQty(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 월별기준내용전월 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-11 11:12:21
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchMthStrdCttB(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	DMTHSALESPLAN001 du = (DMTHSALESPLAN001) lookupDataUnit(DMTHSALESPLAN001.class);
	    	
	    	requestData.putField("STRD_CL", "B");
			responseData = du.dSearchMthStrdCtt(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 월별기준내용당월 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-11 13:48:47
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchMthStrdCttC(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	DMTHSALESPLAN001 du = (DMTHSALESPLAN001) lookupDataUnit(DMTHSALESPLAN001.class);
	    	
	    	requestData.putField("STRD_CL", "C");
			responseData = du.dSearchMthStrdCtt(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}

	/**
	 * 월별기준내용목표 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-11 13:52:57
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchMthStrdCttP(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	DMTHSALESPLAN001 du = (DMTHSALESPLAN001) lookupDataUnit(DMTHSALESPLAN001.class);
	    	
	    	requestData.putField("STRD_CL", "P");
			responseData = du.dSearchMthStrdCtt(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 월별영업팀 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-11 17:17:22
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchMthTrgtTeam(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	DMTHSALESPLAN001 du = (DMTHSALESPLAN001) lookupDataUnit(DMTHSALESPLAN001.class);
	    	
			responseData = du.dSearchMthTrgtTeam(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 월별영업계획관리 정보를 저장하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-12 15:27:47
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("static-access")
	public IDataSet fInsertMthDsmTrgtHeadq(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	DMTHSALESPLAN001 du = (DMTHSALESPLAN001) lookupDataUnit(DMTHSALESPLAN001.class);
	    	
	    	du.dInsertMthDsmTrgtHeadq(requestData, onlineCtx);
			
	    	IRecordSet rs1 =  requestData.getRecordSet("gridtrgt");
			if(rs1 != null && rs1.getRecordCount()!=0) {
				
				SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMM");
    			Calendar cal = Calendar.getInstance(); 
    			
    			String year = requestData.getField("SALES_YM").substring(0,4);
    			String month = requestData.getField("SALES_YM").substring(4,6);
    			
    			cal.set(Integer.parseInt(year), Integer.parseInt(month)-1, cal.get(cal.DATE)); 
				cal.add(cal.MONTH, -1);
	    		 
				String beforeYear = dateFormat.format(cal.getTime()).substring(0,4); 
				String beforeMonth = dateFormat.format(cal.getTime()).substring(4,6);
				String beforeYm = beforeYear + beforeMonth;
				
				for(int i = 0 ; i < rs1.getRecordCount() ; i++){
					IDataSet listData = new DataSet();
		    		listData.putFieldMap(rs1.getRecordMap(i));
		    		listData.putField("SALES_YM", beforeYm); //전월
		    		listData.putField("SALE_DEPT_ORG_ID", requestData.getField("SALE_DEPT_ORG_ID"));
		    		
		    		du.dUpdateMthDsmTrgtHeadqDtl(listData, onlineCtx);
				}
			}
			
			IRecordSet rs2 =  requestData.getRecordSet("gridtrgtqty");
			if(rs2 != null && rs2.getRecordCount()!=0) {
				for(int i = 0 ; i < rs2.getRecordCount() ; i++){
					IDataSet listData = new DataSet();
		    		listData.putFieldMap(rs2.getRecordMap(i));
		    		listData.putField("SALES_YM", requestData.getField("SALES_YM")); //당월
		    		listData.putField("SALE_DEPT_ORG_ID", requestData.getField("SALE_DEPT_ORG_ID"));
		    		
		    		du.dInsertMthDsmTrgtHeadqDtl(listData, onlineCtx);
				}
			}
			
			IRecordSet rs3 =  requestData.getRecordSet("gridteam");
			if(rs3 != null && rs3.getRecordCount()!=0) {
				for(int i = 0 ; i < rs3.getRecordCount() ; i++){
					IDataSet listData = new DataSet();
		    		listData.putFieldMap(rs3.getRecordMap(i));
		    		listData.putField("SALES_YM", requestData.getField("SALES_YM"));
		    		listData.putField("SALE_DEPT_ORG_ID", requestData.getField("SALE_DEPT_ORG_ID"));
		    		
		    		du.dInsertMthDsmTrgtHeadqTeam(listData, onlineCtx);
				}
			}
			
			IRecordSet rs4 =  requestData.getRecordSet("gridteam");
			if(rs4 != null && rs4.getRecordCount()!=0) {
				for(int i = 0 ; i < rs4.getRecordCount() ; i++){
					IDataSet listData = new DataSet();
		    		listData.putFieldMap(rs4.getRecordMap(i));
		    		listData.putField("SALES_YM", requestData.getField("SALES_YM"));
		    		listData.putField("SALE_DEPT_ORG_ID", requestData.getField("SALE_DEPT_ORG_ID"));
		    		
		    		du.dInsertMthDsmTrgtHeadqTeamDtl(listData, onlineCtx);
				}
			}
			
			String[] strdMgmtSeq = requestData.getField("STRD_MGMT_SEQ").split(",");
			String[] salesPlanCtt = requestData.getField("SALES_PLAN_CTT").split(",", strdMgmtSeq.length);
			
			for(int i = 0 ; i < strdMgmtSeq.length ; i++){
				if(!"".equals(strdMgmtSeq[i])){
					IDataSet listData = new DataSet();
					listData.putField("SALES_YM", requestData.getField("SALES_YM"));
					listData.putField("SALE_DEPT_ORG_ID", requestData.getField("SALE_DEPT_ORG_ID"));
					listData.putField("STRD_MGMT_SEQ", strdMgmtSeq[i]);
					listData.putField("SALES_PLAN_CTT", salesPlanCtt[i]);
				
					du.dInsertMthDsmTrgtHeadqPlan(listData, onlineCtx);
				}
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
	 * 월별영업계획관리 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-11 11:12:21
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchHeadSalePlan(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	DMTHSALESPLAN001 du = (DMTHSALESPLAN001) lookupDataUnit(DMTHSALESPLAN001.class);
	    	
			responseData = du.dSearchHeadSalePlan(requestData, onlineCtx);
			responseData.putField("count", du.dSearchHeadSalePlanCount(requestData, onlineCtx).getIntField("count"));
			responseData.putFieldMap(du.dSearchHeadSalePlanTotCount(requestData, onlineCtx).getFieldMap());
			
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
	 * @since 2015-02-11 11:12:21
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchSalePlanCnslDlDt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	DMTHSALESPLAN001 du = (DMTHSALESPLAN001) lookupDataUnit(DMTHSALESPLAN001.class);
	    	
			responseData = du.dSearchSalePlanCnslDlDt(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 월별영업실적영업팀 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-23 16:29:48
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchMthExecTrgtTeam(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	DMTHSALESPLAN001 du = (DMTHSALESPLAN001) lookupDataUnit(DMTHSALESPLAN001.class);
	    	
			responseData = du.dSearchMthExecTrgtTeam(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 월별목표수량영업팀 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-23 16:31:16
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchMthExecTrgtQtyTeam(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	DMTHSALESPLAN001 du = (DMTHSALESPLAN001) lookupDataUnit(DMTHSALESPLAN001.class);
	    	
			responseData = du.dSearchMthExecTrgtQtyTeam(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 월별영업팀에이전트 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-23 16:32:33
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchMthTrgtTeamAgnt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	DMTHSALESPLAN001 du = (DMTHSALESPLAN001) lookupDataUnit(DMTHSALESPLAN001.class);
	    	
			responseData = du.dSearchMthTrgtTeamAgnt(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 월별영업팀에이전트MA수 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-23 17:51:09
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchMthTrgtTeamAgntPrsnCnt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	DMTHSALESPLAN001 du = (DMTHSALESPLAN001) lookupDataUnit(DMTHSALESPLAN001.class);
	    	
			responseData = du.dSearchMthTrgtTeamAgntPrsnCnt(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}  
	
	    return responseData;
	}

	/**
	 * 월별영업계획관리영업팀 정보를 저장하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-24 10:24:33
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("static-access")
	public IDataSet fInsertMthDsmTrgtTeam(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	DMTHSALESPLAN001 du = (DMTHSALESPLAN001) lookupDataUnit(DMTHSALESPLAN001.class);
	    	
	    	du.dInsertMthDsmTrgtTeam(requestData, onlineCtx);
			
	    	IRecordSet rs1 =  requestData.getRecordSet("gridtrgt");
			if(rs1 != null && rs1.getRecordCount()!=0) {
				
				SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMM");
    			Calendar cal = Calendar.getInstance(); 
    			
    			String year = requestData.getField("SALES_YM").substring(0,4);
    			String month = requestData.getField("SALES_YM").substring(4,6);
    			
    			cal.set(Integer.parseInt(year), Integer.parseInt(month)-1, cal.get(cal.DATE)); 
				cal.add(cal.MONTH, -1);
	    		 
				String beforeYear = dateFormat.format(cal.getTime()).substring(0,4); 
				String beforeMonth = dateFormat.format(cal.getTime()).substring(4,6);
				String beforeYm = beforeYear + beforeMonth;
				
				for(int i = 0 ; i < rs1.getRecordCount() ; i++){
					IDataSet listData = new DataSet();
		    		listData.putFieldMap(rs1.getRecordMap(i));
		    		listData.putField("SALES_YM", beforeYm); //전월
		    		listData.putField("SALE_DEPT_ORG_ID", requestData.getField("SALE_DEPT_ORG_ID"));
		    		listData.putField("SALE_TEAM_ORG_ID", requestData.getField("SALE_TEAM_ORG_ID"));
		    		
		    		du.dUpdateMthDsmTrgtTeamDtl(listData, onlineCtx);
				}
			}
			
			IRecordSet rs2 =  requestData.getRecordSet("gridtrgtqty");
			if(rs2 != null && rs2.getRecordCount()!=0) {
				for(int i = 0 ; i < rs2.getRecordCount() ; i++){
					IDataSet listData = new DataSet();
		    		listData.putFieldMap(rs2.getRecordMap(i));
		    		listData.putField("SALES_YM", requestData.getField("SALES_YM")); //당월
		    		listData.putField("SALE_DEPT_ORG_ID", requestData.getField("SALE_DEPT_ORG_ID"));
		    		listData.putField("SALE_TEAM_ORG_ID", requestData.getField("SALE_TEAM_ORG_ID"));
		    		
		    		du.dInsertMthDsmTrgtTeamDtl(listData, onlineCtx);
				}
			}
			
			IRecordSet rs3 =  requestData.getRecordSet("gridteam");
			if(rs3 != null && rs3.getRecordCount()!=0) {
				for(int i = 0 ; i < rs3.getRecordCount() ; i++){
					IDataSet listData = new DataSet();
		    		listData.putFieldMap(rs3.getRecordMap(i));
		    		listData.putField("SALES_YM", requestData.getField("SALES_YM"));
		    		listData.putField("SALE_DEPT_ORG_ID", requestData.getField("SALE_DEPT_ORG_ID"));
		    		listData.putField("SALE_TEAM_ORG_ID", requestData.getField("SALE_TEAM_ORG_ID"));
		    		
		    		du.dInsertMthDsmTrgtTeamAgntDtl(listData, onlineCtx);
				}
			}
			
			String[] strdMgmtSeq = requestData.getField("STRD_MGMT_SEQ").split(",");
			String[] salesPlanCtt = requestData.getField("SALES_PLAN_CTT").split(",", strdMgmtSeq.length);
			
			for(int i = 0 ; i < strdMgmtSeq.length ; i++){
				if(!"".equals(strdMgmtSeq[i])){
					IDataSet listData = new DataSet();
					listData.putField("SALES_YM", requestData.getField("SALES_YM"));
					listData.putField("SALE_DEPT_ORG_ID", requestData.getField("SALE_DEPT_ORG_ID"));
					listData.putField("SALE_TEAM_ORG_ID", requestData.getField("SALE_TEAM_ORG_ID"));
					listData.putField("STRD_MGMT_SEQ", strdMgmtSeq[i]);
					listData.putField("SALES_PLAN_CTT", salesPlanCtt[i]);
				
					du.dInsertMthDsmTrgtTeamPlan(listData, onlineCtx);
				}
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
