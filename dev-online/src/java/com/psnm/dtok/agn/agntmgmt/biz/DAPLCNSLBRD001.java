package com.psnm.dtok.agn.agntmgmt.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/에이전트</li>
 * <li>단위업무명: DAPLCNSLBRD001</li>
 * <li>설  명 : MA지원상담조회 DU</li>
 * <li>작성일 : 2014-11-19 17:35:16</li>
 * <li>작성자 : 한상곤 (hansanggon)</li>
 * </ul>
 *
 * @author 한상곤 (hansanggon)
 */
public class DAPLCNSLBRD001 extends nexcore.framework.coreext.pojo.biz.DataUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public DAPLCNSLBRD001(){
		super();
	}

	/**
	 * MA지원상담 조회 DM
	 *
	 * @author 한상곤 (hansanggon)
	 * @since 2014-11-19 17:35:16
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchAplCnslBrd(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();

		IRecordSet rs = dbSelect("DAPLCNSLBRD001.dSearchAplCnslBrd", requestData.getFieldMap(), onlineCtx);
		
		responseData.putRecordSet("grid", rs);
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    return responseData;
	}

	/**
	 * MA지원상담 건수조회 DM
	 *
	 * @author 한상곤 (hansanggon)
	 * @since 2014-11-19 17:35:16
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchAplCnslBrdCnt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
		IRecordSet rs = dbSelect("DAPLCNSLBRD001.dSearchAplCnslBrdCnt", requestData.getFieldMap(), onlineCtx);
		
		responseData.putField("count", rs.get(0, 0));
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    return responseData;
	}

	/**
	 * MA지원상담 상세조회 DM
	 *
	 * @author 한상곤 (hansanggon)
	 * @since 2014-11-24 09:28:20
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("unchecked")
	public IDataSet dDetailAplCnslBrd(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
		
		responseData.putFieldMap(this.dbSelectSingle("DAPLCNSLBRD001.dDetailAplCnslBrd", requestData.getFieldMap(), onlineCtx));
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	
	    return responseData;
	}

	/**
	 * MA지원상담 상담국배정및상태수정 DM
	 *
	 * @author 한상곤 (hansanggon)
	 * @since 2014-11-19 17:35:16
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dUpdateAplCnslBrd(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    int result = dbUpdate("DAPLCNSLBRD001.dUpdateAplCnslBrd", requestData.getFieldMap(), onlineCtx);
	    
	    responseData.putField("result", result);
	    
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	
	    return responseData;
	}

	/**
	 * MA지원상담 저장 DM
	 *
	 * @author 김보선 (kimbosun)
	 * @since 2014-11-19 17:35:16
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dMergeAgentEccr(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    dbInsert("DAPLCNSLBRD001.dMergeAgentEccr", requestData.getFieldMap(), onlineCtx);
	
	    return responseData;
	}

	/**
	 * MA지원상담 채번 DM
	 *
	 * @author 김보선 (kimbosun)
	 * @since 2015-02-23 09:07:49
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("unchecked")
	public IDataSet dSelectAgentEccrNoSeq(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    responseData.putFieldMap(dbSelectSingle("DAPLCNSLBRD001.dSelectAgentEccrNoSeq", requestData.getFieldMap(), onlineCtx));
	
	    return responseData;
	}

	/**
	 * MA지원상담 삭제 DM
	 *
	 * @author 김보선 (kimbosun)
	 * @since 2015-02-23 18:34:23
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dDeleteAgentEccr(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    dbUpdate("DAPLCNSLBRD001.dDeleteAgentEccr", requestData.getFieldMap(), onlineCtx);
	
	    return responseData;
	}

	/**
	 * MA지원상담 에이전트ID저장 DM
	 *
	 * @author 김보선 (kimbosun)
	 * @since 2015-03-02 10:24:28
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dUpdateAplCnslBrdAgentId(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    dbUpdate("DAPLCNSLBRD001.dUpdateAplCnslBrdAgentId", requestData.getFieldMap(), onlineCtx);
	
	    return responseData;
	}

	/**
	 * MA지원상담 SMS발송조회 DM
	 *
	 * @author 김보선 (kimbosun)
	 * @since 2014-11-19 17:35:16
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSelectAgentEccrSmsSend(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    //1.영업국배정:지원자발송
	    if( "1".equals(requestData.getField("SMS_CHK")) ) {
	    	IRecordSet rs = dbSelect("DAPLCNSLBRD001.dSelectAgentEccrSmsSend1", requestData.getFieldMap(), onlineCtx);
	    	responseData.putRecordSet("ds", rs);
	    }
	    //2.영업국배정, 상담종료(적합) :국장발송
	    else if( "2".equals(requestData.getField("SMS_CHK")) ) {
	    	IRecordSet rs = dbSelect("DAPLCNSLBRD001.dSelectAgentEccrSmsSend2", requestData.getFieldMap(), onlineCtx);
	    	responseData.putRecordSet("ds", rs);
	    }
	    //3.상담종료(적합) :지원자발송
	    else if( "3".equals(requestData.getField("SMS_CHK")) ) {
	    	IRecordSet rs = dbSelect("DAPLCNSLBRD001.dSelectAgentEccrSmsSend3", requestData.getFieldMap(), onlineCtx);
	    	responseData.putRecordSet("ds", rs);
	    }
	    //4.상담요청:SMS관리에서 지정된 메시지 구분이 MA지원상담요청의 임직원
	    else if( "4".equals(requestData.getField("SMS_CHK")) ) {
	    	IRecordSet rs = dbSelect("DAPLCNSLBRD001.dSelectAgentEccrSmsSend4", requestData.getFieldMap(), onlineCtx);
	    	responseData.putRecordSet("ds", rs);
	    }
	
	    return responseData;
	}
  
}
