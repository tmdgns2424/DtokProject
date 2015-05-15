package com.psnm.dtok.com.faqmgmt.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: DFAQMGMT001</li>
 * <li>설  명 : FAQ관리 DU</li>
 * <li>작성일 : 2014-12-11 16:30:50</li>
 * <li>작성자 : 이승훈 (leeseunghun)</li>
 * </ul>
 *
 * @author 이승훈 (leeseunghun)
 */
public class DFAQMGMT001 extends nexcore.framework.coreext.pojo.biz.DataUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public DFAQMGMT001(){
		super();
	}

	/**
	 * FAQ관리 정보를 조회하는 메소드
	 *
	 * @author 이승훈 (leeseunghun)
	 * @since 2014-12-11 16:30:50
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchFaq(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DFAQMGMT001.dSearchFaq", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
	
	    return responseData;
	}
	
	/**
	 * FAQ관리건수 정보를 조회하는 메소드
	 *
	 * @author 이승훈 (leeseunghun)
	 * @since 2014-12-11 16:30:50
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchFaqCount(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DFAQMGMT001.dSearchFaqCount", requestData.getFieldMap(), onlineCtx);
	    responseData.putField("count", rs.get(0, 0));
	
	    return responseData;
	}
	
	/**
	 * FAQ관리상세 정보를 조회하는 메소드
	 *
	 * @author 이승훈 (leeseunghun)
	 * @since 2014-12-11 16:30:50
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("unchecked")
	public IDataSet dDetailFaq(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    
	    responseData.putFieldMap(dbSelectSingle("DFAQMGMT001.dDetailFaq", requestData.getFieldMap(), onlineCtx)); 
	
	    return responseData;
	}
	
	/**
	 * FAQ관리 시퀀스 정보를 조회하는 메소드
	 *
	 * @author 이승훈 (leeseunghun)
	 * @since 2014-12-11 16:30:50
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("unchecked")
	public IDataSet dSearchFaqIdSeq(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    
	    responseData.putFieldMap(dbSelectSingle("DFAQMGMT001.dSearchFaqIdSeq", requestData.getFieldMap(), onlineCtx));
	
	    return responseData;
	}

	/**
	 * FAQ관리 정보를 추가하는 메소드
	 *
	 * @author 이승훈 (leeseunghun)
	 * @since 2014-12-11 16:30:50
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertFaq(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    dbInsert("DFAQMGMT001.dInsertFaq", requestData.getFieldMap(), onlineCtx);
	
	    return responseData;
	}

	/**
	 * FAQ관리 정보를 수정하는 메소드
	 *
	 * @author 이승훈 (leeseunghun)
	 * @since 2014-12-11 16:30:50
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dUpdateFaq(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    dbUpdate("DFAQMGMT001.dUpdateFaq", requestData.getFieldMap(), onlineCtx);
	
	    return responseData;
	}

	/**
	 * FAQ관리 정보를 삭제하는 메소드
	 *
	 * @author 이승훈 (leeseunghun)
	 * @since 2014-12-11 16:30:50
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dDeleteFaq(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();		
	    
	    dbDelete("DFAQMGMT001.dDeleteFaq", requestData.getFieldMap(), onlineCtx);
	
	    return responseData;
	}

	/**
	 * FAQ관리등록게시자를 조회하는 메소드
	 *
	 * @author 이승훈 (leeseunghun)
	 * @since 2014-12-11 16:30:50
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchFaqRgstrNm(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DFAQMGMT001.dSearchFaqRgstrNm", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
	
	    return responseData;
	}
  
}
