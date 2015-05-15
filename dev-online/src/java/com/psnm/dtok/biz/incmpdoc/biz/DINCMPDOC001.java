package com.psnm.dtok.biz.incmpdoc.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/업무</li>
 * <li>단위업무명: DINCMPDOC001</li>
 * <li>설  명 : 미비서류접수 업무 관련 DataUnit</li>
 * <li>작성일 : 2015-01-22 14:06:59</li>
 * <li>작성자 : 김지홍 (kimjihong)</li>
 * </ul>
 *
 * @author 김지홍 (kimjihong)
 */
public class DINCMPDOC001 extends nexcore.framework.coreext.pojo.biz.DataUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public DINCMPDOC001(){
		super();
	}

	/**
	 * 미비서류접수 검색을 위하여 관련 테이블 조회
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-01-22 14:06:59
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchIncmpDoc(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DINCMPDOC001.dSearchIncmpDoc", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
		
		rs = dbSelect("DINCMPDOC001.dSearchIncmpDocCount", requestData.getFieldMap(), onlineCtx);
		responseData.putField("count", rs.get(0, 0));
		
		rs = dbSelect("DINCMPDOC001.dSearchIncmpDocStCount", requestData.getFieldMap(), onlineCtx);
		responseData.putField("PROC_ST_CNT", rs.get(0, 0));
		
	    return responseData;
	}

	/**
	 * 미비서류접수 정보를 추가하는 메소드
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-01-22 14:06:59
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertIncmpDoc(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    dbInsert("DINCMPDOC001.dInsertIncmpDoc", requestData.getFieldMap(), onlineCtx);
			
	    return responseData;
	}

	/**
	 * 미비서류접수 정보를 수정하는 메소드
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-01-22 14:06:59
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dUpdateIncmpDoc(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    dbUpdate("DINCMPDOC001.dUpdateIncmpDoc", requestData.getFieldMap(), onlineCtx);
	
	    return responseData;
	}

	/**
	 * 미비서류접수정보 상세 조회 DM
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-01-23 14:29:10
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("unchecked")
	public IDataSet dDetailIncmpDoc(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    responseData.putFieldMap(dbSelectSingle("DINCMPDOC001.dDetailIncmpDoc", requestData.getFieldMap(), onlineCtx));
			
	    return responseData;
	}

	/**
	 * 미비서류접수 ID 시퀀스 조회
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-01-26 14:11:39
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("unchecked")
	public IDataSet dSearchIncmpDocIdSeq(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    responseData.putFieldMap(dbSelectSingle("DINCMPDOC001.dSearchIncmpDocIdSeq", requestData.getFieldMap(), onlineCtx));
	
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-01-28 15:29:53
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSaveIncmpDocResult(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    dbUpdate("DINCMPDOC001.dUpdateIncmpDocResult", requestData.getFieldMap(), onlineCtx);
	
	    return responseData;
	}
  
}
