package com.psnm.dtok.biz.saleplan.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/업무</li>
 * <li>단위업무명: DMTHSALESPLAN001</li>
 * <li>설  명 : 월별영업계획관리 DU</li>
 * <li>작성일 : 2015-02-11 11:12:44</li>
 * <li>작성자 : 이민재 (leeminjae)</li>
 * </ul>
 *
 * @author 이민재 (leeminjae)
 */
public class DMTHSALESPLAN001 extends nexcore.framework.coreext.pojo.biz.DataUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public DMTHSALESPLAN001(){
		super();
	}

	/**
	 * 월별영업실적 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-11 11:32:04
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchMthExecTrgt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DMTHSALESPLAN001.dSearchMthExecTrgt", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
	
	    return responseData;
	}

	/**
	 * 월별목표수량 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-11 11:33:03
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchMthExecTrgtQty(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DMTHSALESPLAN001.dSearchMthExecTrgtQty", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
	
	    return responseData;
	}

	/**
	 * 월별기준내용 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-11 11:34:07
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchMthStrdCtt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DMTHSALESPLAN001.dSearchMthStrdCtt", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
	
	    return responseData;
	}

	/**
	 * 월별영업팀 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-11 17:16:30
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchMthTrgtTeam(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DMTHSALESPLAN001.dSearchMthTrgtTeam", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
	
	    return responseData;
	}

	/**
	 * 월별목표영업국 정보를 저장하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-12 15:21:28
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertMthDsmTrgtHeadq(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    dbInsert("DMTHSALESPLAN001.dInsertMthDsmTrgtHeadq", requestData.getFieldMap(), onlineCtx);
	
	    return responseData;
	}

	/**
	 * 월별목표영업국별상세 정보를 저장하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-12 15:22:05
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertMthDsmTrgtHeadqDtl(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    dbInsert("DMTHSALESPLAN001.dInsertMthDsmTrgtHeadqDtl", requestData.getFieldMap(), onlineCtx);
	
	    return responseData;
	}

	/**
	 * 월별목표영업국별영업팀 정보를 저장하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-12 15:22:39
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertMthDsmTrgtHeadqTeam(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    dbInsert("DMTHSALESPLAN001.dInsertMthDsmTrgtHeadqTeam", requestData.getFieldMap(), onlineCtx);
	
	    return responseData;
	}

	/**
	 * 월별목표영업국별영업팀상세 정보를 저장하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-12 15:23:08
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertMthDsmTrgtHeadqTeamDtl(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    dbInsert("DMTHSALESPLAN001.dInsertMthDsmTrgtHeadqTeamDtl", requestData.getFieldMap(), onlineCtx);
	
	    return responseData;
	}

	/**
	 * 월별목표영업국별계획 정보를 저장하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-12 15:23:40
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertMthDsmTrgtHeadqPlan(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    dbInsert("DMTHSALESPLAN001.dInsertMthDsmTrgtHeadqPlan", requestData.getFieldMap(), onlineCtx);
	
	    return responseData;
	}

	/**
	 * 월별목표영업국별상세 정보를 수정하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-13 11:31:49
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dUpdateMthDsmTrgtHeadqDtl(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    dbUpdate("DMTHSALESPLAN001.dUpdateMthDsmTrgtHeadqDtl", requestData.getFieldMap(), onlineCtx);
	
	    return responseData;
	}

	/**
	 * 월별영업계획관리 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-11 11:12:44
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchHeadSalePlan(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DMTHSALESPLAN001.dSearchHeadSalePlan", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
	
	    return responseData;
	}

	/**
	 * 월별영업계획관리건수 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-11 11:12:44
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchHeadSalePlanCount(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DMTHSALESPLAN001.dSearchHeadSalePlanCount", requestData.getFieldMap(), onlineCtx);
		responseData.putField("count", rs.get(0, 0));
	
	    return responseData;
	}

	/**
	 * 월별영업계획관리기간 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-11 11:12:44
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchSalePlanCnslDlDt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DMTHSALESPLAN001.dSearchSalePlanCnslDlDt", requestData.getFieldMap(), onlineCtx);
	    responseData.putField("CNSL_DL_DT_FROM", rs.get(0, 0));
		responseData.putField("CNSL_DL_DT_TO", rs.get(1, 0));
	
	    return responseData;
	}

	/**
	 * 월별영업실적영업팀 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-23 13:23:39
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchMthExecTrgtTeam(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DMTHSALESPLAN001.dSearchMthExecTrgtTeam", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
	
	    return responseData;
	}

	/**
	 * 월별목표수량영업팀 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-23 14:47:39
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchMthExecTrgtQtyTeam(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DMTHSALESPLAN001.dSearchMthExecTrgtQtyTeam", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
	
	    return responseData;
	}

	/**
	 * 월별영업팀에이전트 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-23 16:27:13
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchMthTrgtTeamAgnt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DMTHSALESPLAN001.dSearchMthTrgtTeamAgnt", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
	
	    return responseData;
	}

	/**
	 * 월별영업팀에이전트MA수 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-23 17:49:27
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchMthTrgtTeamAgntPrsnCnt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    
	    IRecordSet rs = dbSelect("DMTHSALESPLAN001.dSearchMthTrgtTeamAgntPrsnCnt", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
	
	    return responseData;
	}

	/**
	 * 월별목표영업팀 정보를 저장하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-24 10:21:14
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertMthDsmTrgtTeam(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    dbInsert("DMTHSALESPLAN001.dInsertMthDsmTrgtTeam", requestData.getFieldMap(), onlineCtx);
	
	    return responseData;
	}

	/**
	 * 월별목표영업팀별상세 정보를 저장하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-24 10:08:19
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertMthDsmTrgtTeamDtl(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    dbInsert("DMTHSALESPLAN001.dInsertMthDsmTrgtTeamDtl", requestData.getFieldMap(), onlineCtx);
	
	    return responseData;
	}
	
	/**
	 * 월별목표영업팀별상세 정보를 수정하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-24 09:44:50
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dUpdateMthDsmTrgtTeamDtl(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    dbUpdate("DMTHSALESPLAN001.dUpdateMthDsmTrgtTeamDtl", requestData.getFieldMap(), onlineCtx);
	
	    return responseData;
	}

	/**
	 * 월별목표영업국별영업팀에이전트상세 정보를 저장하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-24 10:23:16
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertMthDsmTrgtTeamAgntDtl(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    dbInsert("DMTHSALESPLAN001.dInsertMthDsmTrgtTeamAgntDtl", requestData.getFieldMap(), onlineCtx);
	
	    return responseData;
	}

	/**
	 * 월별목표영업팀별계획 정보를 저장하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-24 10:29:36
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertMthDsmTrgtTeamPlan(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    dbInsert("DMTHSALESPLAN001.dInsertMthDsmTrgtTeamPlan", requestData.getFieldMap(), onlineCtx);
	
	    return responseData;
	}

	/**
	 * 월별영업계획관리총건수 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-03-19 14:18:24
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("unchecked")
	public IDataSet dSearchHeadSalePlanTotCount(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    responseData.putFieldMap(dbSelectSingle("DMTHSALESPLAN001.dSearchHeadSalePlanTotCount", requestData.getFieldMap(), onlineCtx)); 
	
	    return responseData;
	}

}
