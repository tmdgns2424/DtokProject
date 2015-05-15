package com.psnm.dtok.biz.dfaxrcv.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/업무</li>
 * <li>단위업무명: DFAXRCV001</li>
 * <li>설  명 : D-FAX접수결과 DU</li>
 * <li>작성일 : 2014-12-24 16:09:35</li>
 * <li>작성자 : 이민재 (leeminjae)</li>
 * </ul>
 *
 * @author 이민재 (leeminjae)
 */
public class DFAXRCV001 extends nexcore.framework.coreext.pojo.biz.DataUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public DFAXRCV001(){
		super();
	}

	/**
	 * D-FAX접수결과 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-24 16:11:18
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchFaxRcv(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DFAXRCV001.dSearchFaxRcv", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs); 
	
	    return responseData;
	}

	/**
	 * D-FAX접수결과 건수 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-24 17:26:20
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchFaxRcvCount(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DFAXRCV001.dSearchFaxRcvCount", requestData.getFieldMap(), onlineCtx);
		responseData.putField("count", rs.get(0, 0));
	
	    return responseData;
	}

	/**
	 * D-FAX접수업무승인 정보를 저장하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-27 15:49:47
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertFaxRcvBizAprv(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    dbInsert("DFAXRCV001.dInsertFaxRcvBizAprv", requestData.getFieldMap(), onlineCtx);
	
	    return responseData;
	}

	/**
	 * D-FAX접수업무승인이력 정보를 저장하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-27 15:50:21
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertFaxRcvBizAprvHst(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    dbInsert("DFAXRCV001.dInsertFaxRcvBizAprvHst", requestData.getFieldMap(), onlineCtx);
	
	    return responseData;
	}

	/**
	 * D-FAX접수팩스관리 정보를 수정하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-27 17:10:26
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dUpdateFaxRcvTsal(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    dbUpdate("DFAXRCV001.dUpdateFaxRcvTsal", requestData.getFieldMap(), onlineCtx); 
	
	    return responseData;
	}

	/**
	 * D-FAX접수승인요청SMS발송(국장)
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-03-03 16:18:39
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchFaxRcvReqSms01(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DFAXRCV001.dSearchFaxRcvReqSms01", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs); 
	
	    return responseData;
	}

	/**
	 * D-FAX접수승인요청SMS발송(팀장)
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-03-03 16:19:15
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchFaxRcvReqSms02(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DFAXRCV001.dSearchFaxRcvReqSms02", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs); 
	
	    return responseData;
	}

	/**
	 * D-FAX접수승인요청SMS발송(MA)
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-03-03 16:19:39
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchFaxRcvReqSms03(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DFAXRCV001.dSearchFaxRcvReqSms03", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs); 
	
	    return responseData;
	}

	/**
	 * D-FAX접수승인SMS발송
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-03-03 17:22:19
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchFaxRcvAppSms(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DFAXRCV001.dSearchFaxRcvAppSms", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs); 
	
	    return responseData;
	}

	/**
	 * D-FAX접수승인요청SMS발송
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-03-03 17:45:24
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchFaxRcvReqSms(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DFAXRCV001.dSearchFaxRcvReqSms", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs); 
	
	    return responseData;
	}

	/**
	 * D-FAX접수승인SMS발송(국장승인)
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-03-03 17:55:25
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchFaxRcvAppReqSms(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DFAXRCV001.dSearchFaxRcvAppReqSms", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs); 
	
	    return responseData;
	}

	/**
	 * D-FAX접수반려SMS발송
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-03-03 18:03:21
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchFaxRcvReturnSms(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DFAXRCV001.dSearchFaxRcvReturnSms", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs); 
	
	    return responseData;
	}

	/**
	 * D-FAX접수결과조회모바일 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-03-09 14:28:39
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchFaxRcvMobile(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DFAXRCV001.dSearchFaxRcvMobile", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs); 
	
	    return responseData;
	}

	/**
	 * D-FAX접수결과총건수 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-03-19 13:36:38
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("unchecked")
	public IDataSet dSearchFaxRcvTotalCount(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    responseData.putFieldMap(dbSelectSingle("DFAXRCV001.dSearchFaxRcvTotalCount", requestData.getFieldMap(), onlineCtx)); 
	
	    return responseData;
	}
  
}
