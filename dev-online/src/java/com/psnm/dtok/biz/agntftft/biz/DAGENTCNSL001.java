package com.psnm.dtok.biz.agntftft.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/업무</li>
 * <li>단위업무명: DAGENTCNSL001</li>
 * <li>설  명 : 면담계획/수시면담 PU</li>
 * <li>작성일 : 2014-12-12 10:41:10</li>
 * <li>작성자 : 이민재 (leeminjae)</li>
 * </ul>
 *
 * @author 이민재 (leeminjae)
 */
public class DAGENTCNSL001 extends nexcore.framework.coreext.pojo.biz.DataUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public DAGENTCNSL001(){
		super();
	}

	/**
	 * 면담계획/수시면담을 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-12 10:46:46
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchAgentCnsl(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DAGENTCNSL001.dSearchAgentCnsl", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs); 
	
	    return responseData;
	}

	/**
	 * 면담계획/수시면담 건수를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-12 11:23:17
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchAgentCnslCount(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DAGENTCNSL001.dSearchAgentCnslCount", requestData.getFieldMap(), onlineCtx);
		responseData.putField("count", rs.get(0, 0));
	
	    return responseData;
	}

	/**
	 * 면담계획/수시면담을 저장하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-12 10:41:10
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertAgentCnsl(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    dbInsert("DAGENTCNSL001.dInsertAgentCnsl", requestData.getFieldMap(), onlineCtx);
	
	    return responseData;
	}

	/**
	 * 면담계획/수시면담을 삭제하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-12 15:37:11
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dDeleteAgentCnsl(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    dbUpdate("DAGENTCNSL001.dDeleteAgentCnsl", requestData.getFieldMap(), onlineCtx);
	
	    return responseData;
	}

	/**
	 * 면담계획SMS대상자정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-21 17:18:02
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchAgentCnslSms(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DAGENTCNSL001.dSearchAgentCnslSms", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs); 
	
	    return responseData;
	}

	/**
	 * 면담계획/수시면담총건수 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-03-19 15:37:54
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("unchecked")
	public IDataSet dSearchAgentCnslTotalCount(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    responseData.putFieldMap(dbSelectSingle("DAGENTCNSL001.dSearchAgentCnslTotalCount", requestData.getFieldMap(), onlineCtx)); 
	
	    return responseData;
	}
  
}
