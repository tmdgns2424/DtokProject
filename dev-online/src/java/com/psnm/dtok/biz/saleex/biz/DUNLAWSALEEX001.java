package com.psnm.dtok.biz.saleex.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/업무</li>
 * <li>단위업무명: DUNLAWSALEEX001</li>
 * <li>설  명 : 불/편법영업사례 DU</li>
 * <li>작성일 : 2014-12-30 10:40:22</li>
 * <li>작성자 : 이민재 (leeminjae)</li>
 * </ul>
 *
 * @author 이민재 (leeminjae)
 */
public class DUNLAWSALEEX001 extends nexcore.framework.coreext.pojo.biz.DataUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public DUNLAWSALEEX001(){
		super();
	}

	/**
	 * 불/편법영업사례 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-30 10:46:26
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchUnlawSaleEx(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DUNLAWSALEEX001.dSearchUnlawSaleEx", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
	
	    return responseData;
	}

	/**
	 * 불/편법영업사례건수 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-30 10:46:53
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchUnlawSaleExCount(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DUNLAWSALEEX001.dSearchUnlawSaleExCount", requestData.getFieldMap(), onlineCtx);
		responseData.putField("count", rs.get(0, 0)); 
	
	    return responseData;
	}

	/**
	 * 불/편법영업사례상세 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-30 10:47:22
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("unchecked")
	public IDataSet dDetailUnlawSaleEx(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    responseData.putFieldMap(dbSelectSingle("DUNLAWSALEEX001.dDetailUnlawSaleEx", requestData.getFieldMap(), onlineCtx)); 
	
	    return responseData;
	}

	/**
	 * 불/편법영업사례ID 시퀀스 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-30 13:03:16
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("unchecked")
	public IDataSet dSearchUnlawSaleExIdSeq(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    responseData.putFieldMap(dbSelectSingle("DUNLAWSALEEX001.dSearchUnlawSaleExIdSeq", requestData.getFieldMap(), onlineCtx));
	
	    return responseData;
	}

	/**
	 * 불/편법영업사례 정보를 저장하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-30 13:03:38
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertUnlawSaleEx(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    dbInsert("DUNLAWSALEEX001.dInsertUnlawSaleEx", requestData.getFieldMap(), onlineCtx);
	
	    return responseData;
	}

	/**
	 * 불/편법영업사례 정보를 수정하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-30 13:04:02
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dUpdateUnlawSaleEx(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    dbUpdate("DUNLAWSALEEX001.dUpdateUnlawSaleEx", requestData.getFieldMap(), onlineCtx); 
	
	    return responseData;
	}

	/**
	 * 불/편법영업사례 정보를 삭제하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-30 13:04:24
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dDeleteUnlawSaleEx(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    dbUpdate("DUNLAWSALEEX001.dDeleteUnlawSaleEx", requestData.getFieldMap(), onlineCtx); 
	
	    return responseData;
	}
  
}
