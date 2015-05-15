package com.psnm.dtok.com.ppcnslmgmt.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: DP2PCNSLMGMT001</li>
 * <li>설  명 : 무엇이든물어보세요 DU</li>
 * <li>작성일 : 2014-12-11 17:48:00</li>
 * <li>작성자 : 이승훈 (leeseunghun)</li>
 * </ul>
 *
 * @author 이승훈 (leeseunghun)
 */
public class DP2PCNSLMGMT001 extends nexcore.framework.coreext.pojo.biz.DataUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public DP2PCNSLMGMT001(){
		super();
	}
	
	/**
	 * 무엇이든물어보세요 정보를 조회하는 메소드
	 *
	 * @author 이승훈 (leeseunghun)
	 * @since 2014-12-11 17:48:00
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchP2pCnsl(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		
		IRecordSet rs = dbSelect("DP2PCNSLMGMT001.dSearchP2pCnsl", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
		
		return responseData;
	}
	
	/**
	 * 무엇이든물어보세요건수 정보를 조회하는 메소드
	 *
	 * @author 이승훈 (leeseunghun)
	 * @since 2014-12-11 17:48:00
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchP2pCnslCount(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DP2PCNSLMGMT001.dSearchP2pCnslCount", requestData.getFieldMap(), onlineCtx);
	    responseData.putField("count", rs.get(0, 0));
	
	    return responseData;
	}
	
	/**
	 * 무엇이든물어보세요상세 정보를 조회하는 메소드
	 *
	 * @author 이승훈 (leeseunghun)
	 * @since 2014-12-11 17:48:00
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("unchecked")
	public IDataSet dDetailP2pCnsl(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
		
		responseData.putFieldMap(dbSelectSingle("DP2PCNSLMGMT001.dDetailP2pCnsl", requestData.getFieldMap(), onlineCtx)); 
	
	    return responseData;
	}
	
	/**
	 * 무엇이든물어보세요 시퀀스 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-14 15:13:11
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("unchecked")
	public IDataSet dSearchP2pCnslIdSeq(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    responseData.putFieldMap(dbSelectSingle("DP2PCNSLMGMT001.dSearchP2pCnslIdSeq", requestData.getFieldMap(), onlineCtx));
	
	    return responseData;
	}
	
	/**
	 * 무엇이든물어보세요 정보를 저장하는 메소드
	 *
	 * @author 이승훈 (leeseunghun)
	 * @since 2014-12-11 17:48:00
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertP2pCnsl(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		
		dbInsert("DP2PCNSLMGMT001.dInsertP2pCnsl", requestData.getFieldMap(), onlineCtx);
		
		return responseData;
	}

	/**
	 * 무엇이든물어보세요 정보를 수정하는 메소드
	 *
	 * @author 이승훈 (leeseunghun)
	 * @since 2014-12-11 17:48:00
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dUpdateP2pCnsl(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    dbUpdate("DP2PCNSLMGMT001.dUpdateP2pCnsl", requestData.getFieldMap(), onlineCtx);
	
	    return responseData;
	}


	/**
	 * 무엇이든물어보세요 정보를 삭제하는 메소드
	 *
	 * @author 이승훈 (leeseunghun)
	 * @since 2014-12-11 17:48:00
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dDeleteP2pCnsl(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    dbUpdate("DP2PCNSLMGMT001.dDeleteP2pCnsl", requestData.getFieldMap(), onlineCtx);
	
	    return responseData;
	}

	/**
	 * 무엇이든물어보세요답글 정보를 저장하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-14 16:47:52
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertP2pCnslRejnd(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    dbInsert("DP2PCNSLMGMT001.dInsertP2pCnslRejnd", requestData.getFieldMap(), onlineCtx); 
	
	    return responseData;
	}

	/**
	 * 무엇이든물어보세요SMS대상자 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-23 15:28:44
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchP2pCnslSms(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DP2PCNSLMGMT001.dSearchP2pCnslSms", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
	
	    return responseData;
	}

	/**
	 * 무엇이든물어보세요답변SMS대상자 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-23 16:44:48
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchP2pCnslRejndSms(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DP2PCNSLMGMT001.dSearchP2pCnslRejndSms", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
	
	    return responseData;
	}
  
}
