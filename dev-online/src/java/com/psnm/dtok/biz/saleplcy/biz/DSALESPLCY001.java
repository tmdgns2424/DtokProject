package com.psnm.dtok.biz.saleplcy.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/업무</li>
 * <li>단위업무명: DSALESPLCY001</li>
 * <li>설  명 : 영업정책관리DU</li>
 * <li>작성일 : 2014-11-19 16:30:30</li>
 * <li>작성자 : 이민재 (leeminjae)</li>
 * </ul>
 *
 * @author 이민재 (leeminjae)
 */
public class DSALESPLCY001 extends nexcore.framework.coreext.pojo.biz.DataUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public DSALESPLCY001(){
		super();
	}

	/**
	 * 영업정책관리 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-11-19 16:30:30
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchSalesPlcy(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		
		IRecordSet rs = dbSelect("DSALESPLCY001.dSearchSalesPlcy", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);

		return responseData;
	}

	/**
	 * 영업정책관리 총건수를 조회한다
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-11-19 16:30:30
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchSalesPlcyCount(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		
		IRecordSet rs = dbSelect("DSALESPLCY001.dSearchSalesPlcyCount", requestData.getFieldMap(), onlineCtx);
		responseData.putField("count", rs.get(0, 0));
	
	    return responseData;
	}

	/**
	 * 영업정책관리 정보를 추가하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-11-19 16:30:30
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertSalesPlcy(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		
		dbInsert("DSALESPLCY001.dInsertSalesPlcy", requestData.getFieldMap(), onlineCtx);
		
		return responseData;
	}

	/**
	 * 영업정책관리 정보를 수정하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-11-19 16:30:30
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dUpdateSalesPlcy(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		
		dbUpdate("DSALESPLCY001.dUpdateSalesPlcy", requestData.getFieldMap(), onlineCtx);
		
		return responseData;
	}

	/**
	 * 영업정책관리 시퀀스를 조회 하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-11-19 16:30:30
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("unchecked")
	public IDataSet dSearchSalesPlcyIdSeq(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
		
		responseData.putFieldMap(dbSelectSingle("DSALESPLCY001.dSearchSalesPlcyIdSeq", requestData.getFieldMap(), onlineCtx));
		return responseData;
	}

	/**
	 * 영업정책관리통계를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-11-19 16:30:30
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchSalesPlcyStc(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DSALESPLCY001.dSearchSalesPlcyStc", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
	
	    return responseData;
	}

	/**
	 * 영업정책관리 상세를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-11-19 16:30:30
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("unchecked")
	public IDataSet dDetailSalesPlcy(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
		
		responseData.putFieldMap(dbSelectSingle("DSALESPLCY001.dDetailSalesPlcy", requestData.getFieldMap(), onlineCtx));
	
	    return responseData;
	}

	/**
	 * 영업정책관리 정보를 삭제하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-11-19 16:30:30
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dDeleteSalesPlcy(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    dbUpdate("DSALESPLCY001.dDeleteSalesPlcy", requestData.getFieldMap(), onlineCtx);
	
	    return responseData;
	}

	/**
	 * 영업정책관리 접속현황을 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-11-19 16:30:30
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchSalesPlcyContact(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DSALESPLCY001.dSearchSalesPlcyContact", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
	
	    return responseData;
	}

	/**
	 * 영업정책정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-16 10:14:01
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchSalesPlcyBrws(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DSALESPLCY001.dSearchSalesPlcyBrws", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
	
	    return responseData;
	}

	/**
	 * 영업정책건수정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-16 10:14:23
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchSalesPlcyBrwsCount(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DSALESPLCY001.dSearchSalesPlcyBrwsCount", requestData.getFieldMap(), onlineCtx);
		responseData.putField("count", rs.get(0, 0));
	
	    return responseData;
	}

	/**
	 * 영업정책관리통계영업국명 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-16 15:46:07
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchSalesPlcyStcDept(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DSALESPLCY001.dSearchSalesPlcyStcDept", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
	
	    return responseData;
	}
  
}
