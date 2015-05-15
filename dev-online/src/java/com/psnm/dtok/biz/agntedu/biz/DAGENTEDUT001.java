package com.psnm.dtok.biz.agntedu.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/업무</li>
 * <li>단위업무명: DAGENTEDUT001</li>
 * <li>설  명 : 교육관리DU</li>
 * <li>작성일 : 2014-11-24 17:35:25</li>
 * <li>작성자 : 이민재 (leeminjae)</li>
 * </ul>
 *
 * @author 이민재 (leeminjae)
 */
public class DAGENTEDUT001 extends nexcore.framework.coreext.pojo.biz.DataUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public DAGENTEDUT001(){
		super();
	}

	/**
	 * 교육정보 검색을 위하여 관련 테이블(DSM_AGENT_EDU)을 조인하여 교육정보 객체를 map객체로 가져오는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-11-24 17:36:46
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchAgentEdu(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DAGENTEDUT001.dSearchAgentEdu", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
	
	    return responseData;
	}

	/**
	 * 교육관리 건수를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-11-24 17:41:49
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchAgentEduCount(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DAGENTEDUT001.dSearchAgentEduCount", requestData.getFieldMap(), onlineCtx);
		responseData.putField("count", rs.get(0, 0));
	
	    return responseData;
	}

	/**
	 * 교육관리 상세를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-15 11:02:34
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("unchecked")
	public IDataSet dDetailAgentEdu(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    responseData.putFieldMap(dbSelectSingle("DAGENTEDUT001.dDetailAgentEdu", requestData.getFieldMap(), onlineCtx)); 
	
	    return responseData;
	}

	/**
	 * 교육관리 참석자결과를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-15 11:36:59
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dDetailAgentEduAtndr(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DAGENTEDUT001.dDetailAgentEduAtndr", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
	    
	    return responseData;
	}

	/**
	 * 교육관리참석자 엑셀 업로드 정보를 조회한다.
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-16 15:30:16
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchAgentEduAtndr(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DAGENTEDUT001.dSearchAgentEduAtndr", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
	
	    return responseData;
	}

	/**
	 * 교육관리 정보를 등록 수정 하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-11-24 17:35:25
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertAgentEdu(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    dbInsert("DAGENTEDUT001.dInsertAgentEdu", requestData.getFieldMap(), onlineCtx);
	
	    return responseData;
	}

	/**
	 * 교육관리 참석자를 삭제하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-11-24 17:35:25
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dDeleteAgentEduAtndr(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    dbUpdate("DAGENTEDUT001.dDeleteAgentEduAtndr", requestData.getFieldMap(), onlineCtx);
	
	    return responseData;
	}

	/**
	 * 교육관리 참석자를 등록 수정 하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-11-24 17:35:25
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertAgentEduAtndr(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    dbInsert("DAGENTEDUT001.dInsertAgentEduAtndr", requestData.getFieldMap(), onlineCtx);
	
	    return responseData;
	}

	/**
	 * 교육관리 정보를 삭제하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-17 11:38:53
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dDeleteAgentEdu(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    dbUpdate("DAGENTEDUT001.dDeleteAgentEdu", requestData.getFieldMap(), onlineCtx);
	
	    return responseData;
	}

	/**
	 * 교육관리 참삭자 정보를 전체 삭제하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-17 11:39:27
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dDeleteAgentEduAtndrAll(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    dbUpdate("DAGENTEDUT001.dDeleteAgentEduAtndrAll", requestData.getFieldMap(), onlineCtx);
	
	    return responseData;
	}

	/**
	 * 교육관리ID시퀀스채번
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-17 13:05:00
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("unchecked")
	public IDataSet dSearchAgentEduIdSeq(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    responseData.putFieldMap(dbSelectSingle("DAGENTEDUT001.dSearchAgentEduIdSeq", requestData.getFieldMap(), onlineCtx));  
	
	    return responseData;
	}

	/**
	 * 교육현황 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-26 10:34:24
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchAgentEduPrst(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DAGENTEDUT001.dSearchAgentEduPrst", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
	
	    return responseData;
	}

	/**
	 * 교육현황건수 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-26 10:41:21
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchAgentEduPrstCount(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DAGENTEDUT001.dSearchAgentEduPrstCount", requestData.getFieldMap(), onlineCtx);
		responseData.putField("count", rs.get(0, 0));
	
	    return responseData;
	}
  
}
