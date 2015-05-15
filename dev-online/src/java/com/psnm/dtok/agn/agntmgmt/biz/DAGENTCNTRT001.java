package com.psnm.dtok.agn.agntmgmt.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/에이전트</li>
 * <li>단위업무명: DAGENTCNTRT001</li>
 * <li>설  명 : 에이전트 계약관리 DU</li>
 * <li>작성일 : 2014-11-26 09:57:44</li>
 * <li>작성자 : 한상곤 (hansanggon)</li>
 * </ul>
 *
 * @author 한상곤 (hansanggon)
 */
public class DAGENTCNTRT001 extends nexcore.framework.coreext.pojo.biz.DataUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public DAGENTCNTRT001(){
		super();
	}

	/**
	 * 에이전트정보 조회 DM
	 *
	 * @author 한상곤 (hansanggon)
	 * @since 2014-11-26 09:57:44
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchAgentInfo(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DAGENTCNTRT001.dSearchAgentInfo", requestData.getFieldMap(), onlineCtx);
	    
	    responseData.putRecordSet("grid", rs);
	    
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    
	    return responseData;
	}

	/**
	 * 에이전트정보 건수조회 DM
	 *
	 * @author 한상곤 (hansanggon)
	 * @since 2014-11-26 09:57:44
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchAgentInfoCnt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    responseData.putField("count", dbSelect("DAGENTCNTRT001.dSearchAgentInfoCnt", requestData.getFieldMap(), onlineCtx).get(0, 0));
	    
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    return responseData;
	}

	/**
	 * 에이전트계약정보 조회 DM
	 *
	 * @author 한상곤 (hansanggon)
	 * @since 2014-11-26 09:57:44
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchAgentCntrt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();

	    IRecordSet rs = dbSelect("DAGENTCNTRT001.dSearchAgentCntrt", requestData.getFieldMap(), onlineCtx);
	    responseData.putRecordSet("grid", rs);
	
	    return responseData;
	}

	/**
	 * 에이전트계약정보 건수조회 DM
	 *
	 * @author 한상곤 (hansanggon)
	 * @since 2014-11-26 09:57:44
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchAgentCntrtCnt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();

	    responseData.putField("count", dbSelect("DAGENTCNTRT001.dSearchAgentCntrtCnt", requestData.getFieldMap(), onlineCtx).get(0, 0));
	
	    return responseData;
	}

	/**
	 * 에이전트계약정보 상세조회 DM
	 *
	 * @author 한상곤 (hansanggon)
	 * @since 2014-11-26 09:57:44
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("unchecked")
	public IDataSet dDetailAgentCntrt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();

	    responseData.putFieldMap(this.dbSelectSingle("DAGENTCNTRT001.dDetailAgentCntrt", requestData.getFieldMap(), onlineCtx));
	
	    return responseData;
	}

	/**
	 * 에이전트계약정보 상태수정 DM
	 *
	 * @author 한상곤 (hansanggon)
	 * @since 2014-11-26 09:57:44
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dUpdateAgentCntrt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    int result = dbUpdate("DAGENTCNTRT001.dUpdateAgentCntrt", requestData.getFieldMap(), onlineCtx);
	    
	    responseData.putField("result", result);
	
	    return responseData;
	}

	/**
	 * 에이전트계약정보 저장 DM
	 *
	 * @author 김보선 (kimbosun)
	 * @since 2014-11-26 09:57:44
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertAgentCntrt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    
	    dbInsert("DAGENTCNTRT001.dInsertAgentCntrt", requestData.getFieldMap(), onlineCtx);
	    	
	    return responseData;
	}

	/**
	 * 에이전트계약정보 채번 DM
	 *
	 * @author 김보선 (kimbosun)
	 * @since 2014-11-26 09:57:44
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("unchecked")
	public IDataSet dSelectAgentCntrtNoSeq(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    //responseData.putField("CNTRT_MGMT_NUM", dbSelect("DAGENTCNTRT001.dSearchAgentCntrtNoSeq", requestData.getFieldMap(), onlineCtx).get(0, 0));
	    responseData.putFieldMap(dbSelectSingle("DAGENTCNTRT001.dSearchAgentCntrtNoSeq", requestData.getFieldMap(), onlineCtx));
	    
	    return responseData;
	}

	/**
	 * 에이전트계약정보 SMS발송조회 DM
	 *
	 * @author 김보선 (kimbosun)
	 * @since 2015-02-16 14:01:24
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSelectAgentCntrtSmsSend(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();

	    //에이전트계약 신규등록(1) : 지원자발송
	    if( "1".equals(requestData.getField("SMS_CHK")) ) {	    	
	    	IRecordSet rs = dbSelect("DAGENTCNTRT001.dSelectAgentCntrtSmsSend1", requestData.getFieldMap(), onlineCtx);		    
		    responseData.putRecordSet("ds", rs);
	    }
	    //접수취소(21), 에이전트매핑저장(승인상태(3)에서 저장) : 지원자발송 
	    else if( "2".equals(requestData.getField("SMS_CHK")) ) {
	    	IRecordSet rs = dbSelect("DAGENTCNTRT001.dSelectAgentCntrtSmsSend2", requestData.getFieldMap(), onlineCtx);		    
		    responseData.putRecordSet("ds", rs);	
	    }//접수취소(21) : 국장발송
	    else if( "3".equals(requestData.getField("SMS_CHK")) ) {
	    	IRecordSet rs = dbSelect("DAGENTCNTRT001.dSelectAgentCntrtSmsSend3", requestData.getFieldMap(), onlineCtx);		    
		    responseData.putRecordSet("ds", rs);	
	    }
	    //에이전트계약 신규등록(1) : 국장발송
	    else if( "4".equals(requestData.getField("SMS_CHK")) ) {	    	
	    	IRecordSet rs = dbSelect("DAGENTCNTRT001.dSelectAgentCntrtSmsSend4", requestData.getFieldMap(), onlineCtx);		    
		    responseData.putRecordSet("ds", rs);
	    }
	    //면접승인완료(3) : 승인버튼 클릭시, SMS관리에서 지정된 메시지 구분이 면접승인완료의 임직원
	    else if( "5".equals(requestData.getField("SMS_CHK")) ) {	    	
	    	IRecordSet rs = dbSelect("DAGENTCNTRT001.dSelectAgentCntrtSmsSend5", requestData.getFieldMap(), onlineCtx);		    
		    responseData.putRecordSet("ds", rs);
	    }
	    //면접완료상태(21) : 면접건수가 국직속1조직이면(2회), 일반조직이면(3회)를 판단하여 면접완료상태(21)로 변경되면 면접시행 면접관명에게 SMS발송.
	    else if( "6".equals(requestData.getField("SMS_CHK")) ) {	    	
	    	IRecordSet rs = dbSelect("DAGENTCNTRT001.dSelectAgentCntrtSmsSend6", requestData.getFieldMap(), onlineCtx);		    
		    responseData.putRecordSet("ds", rs);
	    }
    	
	
	    return responseData;
	}

	/**
	 * 에이전트면접현황 조회 메소드
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-02-25 15:01:55
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchAgentCntrtInt(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		
	    IRecordSet rs = dbSelect("DAGENTCNTRT001.dSearchAgentCntrtInt", requestData.getFieldMap(), onlineCtx);
	    responseData.putRecordSet("grid", rs);
	
	    return responseData;
	}

	/**
	 * 에이전트면접현황 건수조회 메소드
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-02-25 15:02:35
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchAgentCntrtIntCnt(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		
	    responseData.putField("count", dbSelect("DAGENTCNTRT001.dSearchAgentCntrtIntCnt", requestData.getFieldMap(), onlineCtx).get(0, 0));
	    	
	    return responseData;
	}

	/**
	 * 에이전트계약정보 상태수정(에이전트매핑) DM
	 *
	 * @author 김보선 (kimbosun)
	 * @since 2015-03-02 16:11:50
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dUpdateAgentCntrtAgentMap(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    int result = dbUpdate("DAGENTCNTRT001.dUpdateAgentCntrtAgentMap", requestData.getFieldMap(), onlineCtx);
	    
	    responseData.putField("result", result);
	
	    return responseData;
	}

	/**
	 * 에이전트계약정보 거래처건수조회 DM
	 *
	 * @author 김보선 (kimbosun)
	 * @since 2015-03-02 17:01:15
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSelectAgentCntrtDealCnt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    responseData.putField("TOTCNT", dbSelect("DAGENTCNTRT001.dSelectAgentCntrtDealCnt", requestData.getFieldMap(), onlineCtx).get(0, 0));
	
	    return responseData;
	}

	/**
	 * 에이전트계약정보 삭제 DM
	 *
	 * @author 김보선 (kimbosun)
	 * @since 2015-03-02 17:55:28
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dDeleteAgentCntrt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    dbDelete("DAGENTCNTRT001.dDeleteAgentCntrt", requestData.getFieldMap(), onlineCtx);
	
	    return responseData;
	}

	/**
	 * 에이전트계약관리 상태수정(승인취소) DM
	 *
	 * @author 김보선 (kimbosun)
	 * @since 2015-03-03 12:22:40
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dUpdateAgentCntrtAppCan(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    dbDelete("DAGENTCNTRT001.dUpdateAgentCntrtAppCan", requestData.getFieldMap(), onlineCtx);
	
	    return responseData;
	}

	/**
	 * 에이전트계약정보 상태별건수조회 DM
	 *
	 * @author 김보선 (kimbosun)
	 * @since 2015-03-19 14:27:42
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("unchecked")
	public IDataSet dSearchAgentCntrtStCnt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    responseData.putFieldMap(dbSelectSingle("DAGENTCNTRT001.dSearchAgentCntrtStCnt", requestData.getFieldMap(), onlineCtx));
	
	    return responseData;
	}

	/**
	 * 에이전트계약정보 상태조회 DM
	 *
	 * @author 김보선 (kimbosun)
	 * @since 2015-04-13 17:56:49
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("unchecked")
	public IDataSet dSelectAgentCntrtStCd(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    //responseData.putField("CNTRT_MGMT_NUM", dbSelect("DAGENTCNTRT001.dSelectAgentCntrtStCd", requestData.getFieldMap(), onlineCtx).get(0, 0));
	    responseData.putFieldMap(dbSelectSingle("DAGENTCNTRT001.dSelectAgentCntrtStCd", requestData.getFieldMap(), onlineCtx));
	
	    return responseData;
	}
  
}
