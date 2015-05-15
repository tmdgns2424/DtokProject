package com.psnm.dtok.com.bltnbrd.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: DBLTNBRD001</li>
 * <li>설  명 : 커뮤니티 > 게시판 관련 DU</li>
 * <li>작성일 : 2015-01-30 17:04:07</li>
 * <li>작성자 : 김지홍 (kimjihong)</li>
 * </ul>
 *
 * @author 김지홍 (kimjihong)
 */
public class DBLTNBRD001 extends nexcore.framework.coreext.pojo.biz.DataUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public DBLTNBRD001(){
		super();
	}

	/**
	 *
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-01-30 17:11:07
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchBltnBrdTree(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		IRecordSet rs = dbSelect("DBLTNBRD001.dSearchBltnBrdTree", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
		return responseData;
	}

	/**
	 * 해당 게시판 목록 조회 DM
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-01-30 17:04:07
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchBltnBrdList(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    
	    IRecordSet rs = dbSelect("DBLTNBRD001.dSearchBltnBrdList", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);			
		rs = dbSelect("DBLTNBRD001.dSearchBltnBrdCount", requestData.getFieldMap(), onlineCtx);
		responseData.putField("count", rs.get(0, 0));
		
	    return responseData;
	}

	/**
	 * 해당 게시판 상세 조회
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-02-03 16:56:18
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("unchecked")
	public IDataSet dDetailBltnBrd(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    responseData.putFieldMap(dbSelectSingle("DBLTNBRD001.dDetailBltnBrd", requestData.getFieldMap(), onlineCtx)); 
	
	    return responseData;
	}

	/**
	 * 게시판 신규 등록하는  메소드
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-01-30 17:04:07
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertBltnBrdInfo(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	   	dbInsert("DBLTNBRD001.dInsertBltnBrdInfo", requestData.getFieldMap(), onlineCtx); 
	
	    return responseData;
	}

	/**
	 * 게시판 정보 수정하는 메소드
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-02-04 18:14:10
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dUpdateBltnBrdInfo(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    dbUpdate("DBLTNBRD001.dUpdateBltnBrd", requestData.getFieldMap(), onlineCtx); 
	
	    return responseData;
	}

	/**
	 * 게시판ID 시퀀스채번하는 메소드
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-01-30 17:04:07
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("unchecked")
	public IDataSet dSearchBltnBrdIdSeq(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    responseData.putFieldMap(dbSelectSingle("DBLTNBRD001.dSearchBltnBrdIdSeq", requestData.getFieldMap(), onlineCtx));
	
	    return responseData;
	}

	/**
	 * 해당 게시글 삭제 메소드
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-02-05 09:53:39
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dDeleteBltnBrdInfo(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    int result = dbDelete("DBLTNBRD001.dDeleteBltnBrd", requestData.getFieldMap(), onlineCtx);
		responseData.putField("result", result);
	
	    return responseData;
	}

	/**
	 * 게시글 삭제 권한이 있는지 확인하는 메소드
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-02-05 10:31:58
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("unchecked")
	public IDataSet dCheckBltnBrd(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    responseData.putFieldMap(dbSelectSingle("DBLTNBRD001.dCheckBltBrd", requestData.getFieldMap(), onlineCtx));
			
	    return responseData;
	}

	/**
	 * 게실글에 대한 답변 저장하는 메소드
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-02-05 15:34:13
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertBltnBrdReply(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    dbInsert("DBLTNBRD001.dInsertBltnBrdReply", requestData.getFieldMap(), onlineCtx); 
	
	    return responseData;
	}

	/**
	 * 게시판비밀번호가능여부 체크하는 메소드
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-01-30 17:04:07
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("unchecked")
	public IDataSet dCheckBltnBrdScrtNum(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    responseData.putFieldMap(dbSelectSingle("DBLTNBRD001.dCheckBltBrdScrtNum", requestData.getFieldMap(), onlineCtx));
	
	    return responseData;
	}

	/**
	 * 게시글 이동에서 사용되는 게시글 상세내용 조회 메소드
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-02-06 12:50:56
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("unchecked")
	public IDataSet dDetailBltnBrdForMove(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    responseData.putFieldMap(dbSelectSingle("DBLTNBRD001.dDetailBltBrdForMove", requestData.getFieldMap(), onlineCtx));
	
	    return responseData;
	}

	/**
	 * 게시판 대그룹 조회 메소드
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-02-06 12:55:59
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchBntlBrdLvl1(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DBLTNBRD001.dSearchBltnBrdLvl1", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs); 
	
	    return responseData;
	}

	/**
	 * 게시글 이동시 호출되는 게시판 중그룹조회 메소드
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-02-06 13:06:52
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchBltnBrdLvl2(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DBLTNBRD001.dSearchBltnBrdLvl2", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);  
	
	    return responseData;
	}

	/**
	 * 게시글 이동 관련하여 호출되는 게시판그룹조회 메소드
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-02-06 13:10:40
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchBltnBrdLvl3(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DBLTNBRD001.dSearchBltnBrdLvl3", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs); 
	
	    return responseData;
	}

	/**
	 * 게시글이동시 사용되는 답글목록 조회 메소드
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-02-06 13:20:34
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchBltnBrdReplyList(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DBLTNBRD001.dSearchBltnBrdReplyList", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs); 
	
	    return responseData;
	}

	/**
	 * 게시글 이동하는 메소드
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-02-06 17:10:19
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dUpdateBltnBrdMove(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    dbUpdate("DBLTNBRD001.dUpdateBltnBrdMove", requestData.getFieldMap(), onlineCtx); 
	
	    return responseData;
	}

	/**
	 * 주간 추천 가능여부확인 메소드
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-01-30 17:04:07
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("unchecked")
	public IDataSet dCheckWeekRcmndPsbl(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    responseData.putFieldMap(dbSelectSingle("DBLTNBRD001.dCheckWeekcmndPsbl", requestData.getFieldMap(), onlineCtx));
	
	    return responseData;
	}

	/**
	 * 주간, 월간 추천 등록 메소드
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-01-30 17:04:07
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertRcmnd(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    int result = dbInsert("DBLTNBRD001.dInsertRcmnd", requestData.getFieldMap(), onlineCtx); 
	    responseData.putField("result", result);
	    return responseData;
	}

	/**
	 * 월간추천가능여부 확인 메소드
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-02-06 18:08:08
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("unchecked")
	public IDataSet dCheckMothRcmndPsbl(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    responseData.putFieldMap(dbSelectSingle("DBLTNBRD001.dCheckMonthRcmndPsbl", requestData.getFieldMap(), onlineCtx));
	
	    return responseData;
	}

	/**
	 * 게시판 정보 조회
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-02-10 15:39:11
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("unchecked")
	public IDataSet dSearchBltnBrdInfo(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    responseData.putFieldMap(dbSelectSingle("DBLTNBRD001.dSearchBltnBrdInfo", requestData.getFieldMap(), onlineCtx));
	
	    return responseData;
	}

	/**
	 * 신규등록시 SMS발송을 위하여 해당 게시판 담당자조회
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-01-30 17:04:07
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchBltnBrdChrgrForSms(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DBLTNBRD001.dSearchBltnBrdChrgrforSms", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs); 
	
	    return responseData;
	}

	/**
	 * 게시판삭제(기간조회) DM
	 *
	 * @author 김보선 (kimbosun)
	 * @since 2015-03-18 11:04:00
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dDeleteBltnBrdSrchAll(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    int result = dbDelete("DBLTNBRD001.dDeleteBltnBrdSrchAll", requestData.getFieldMap(), onlineCtx);
		responseData.putField("result", result);
	
	    return responseData;
	}
  
}
