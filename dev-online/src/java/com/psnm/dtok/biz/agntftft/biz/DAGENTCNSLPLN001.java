package com.psnm.dtok.biz.agntftft.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/업무</li>
 * <li>단위업무명: DAGENTCNSLPLN001</li>
 * <li>설  명 : 면담계획/정기면담DU</li>
 * <li>작성일 : 2014-12-02 17:33:10</li>
 * <li>작성자 : 이민재 (leeminjae)</li>
 * </ul>
 *
 * @author 이민재 (leeminjae)
 */
public class DAGENTCNSLPLN001 extends nexcore.framework.coreext.pojo.biz.DataUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public DAGENTCNSLPLN001(){
		super();
	}

	/**
	 * 면담계획 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-02 17:33:10
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchAgentCnslPln(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		
	    IRecordSet rs = dbSelect("DAGENTCNSLPLN001.dSearchAgentCnslPln", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
	
	    return responseData;
	}

	/**
	 * 면담계획현황건수를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-02 17:33:10
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchAgentCnslPlnCount(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		
	    IRecordSet rs = dbSelect("DAGENTCNSLPLN001.dSearchAgentCnslPlnCount", requestData.getFieldMap(), onlineCtx);
		responseData.putField("count", rs.get(0, 0));
	
	    return responseData;
	}

	/**
	 * 면담계획 정보를 추가하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-02 17:33:10
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertAgentCnslPln(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		
		dbInsert("DAGENTCNSLPLN001.dInsertAgentCnslPln", requestData.getFieldMap(), onlineCtx);
		
		return responseData;
	}

	/**
	 * 면담계획 정보를 수정하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-03 15:31:53
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dUpdateAgentCnslPln(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		dbUpdate("DAGENTCNSLPLN001.dUpdateAgentCnslPln", requestData.getFieldMap(), onlineCtx);
		
		return responseData;
	}

	/**
	 * 면담계획/정기면담 사용자를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-02 17:33:10
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("unchecked")
	public IDataSet dDetailAgentCnslPlnUser(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		
		responseData.putFieldMap(dbSelectSingle("DAGENTCNSLPLN001.dDetailAgentCnslPlnUser", requestData.getFieldMap(), onlineCtx));
	
	    return responseData;
	}

	/**
	 * 면담계획/정기면담 면담자를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-02 17:33:10
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("unchecked")
	public IDataSet dDetailAgentCnslPlnCnslr(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		
		responseData.putFieldMap(dbSelectSingle("DAGENTCNSLPLN001.dDetailAgentCnslPlnCnslr", requestData.getFieldMap(), onlineCtx));
	
	    return responseData;
	}

	/**
	 * 면담계획/정기면담 면접확정일자를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-03 18:07:17
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("unchecked")
	public IDataSet dDetailAgentCnslPlnCnslDlDt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    responseData.putFieldMap(dbSelectSingle("DAGENTCNSLPLN001.dDetailAgentCnslPlnCnslDlDt", requestData.getFieldMap(), onlineCtx));
	
	    return responseData;
	}

	/**
	 * 면담계획/정기면담 면담횟수를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-04 15:41:53
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("unchecked")
	public IDataSet dDetailAgentCnslPlnInputYn(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    responseData.putFieldMap(dbSelectSingle("DAGENTCNSLPLN001.dDetailAgentCnslPlnInputYn", requestData.getFieldMap(), onlineCtx));
	
	    return responseData;
	}

	/**
	 * 면담계획/정기면담 정보를 삭제하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-04 17:23:01
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dDeleteAgentCnslPln(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    dbUpdate("DAGENTCNSLPLN001.dDeleteAgentCnslPln", requestData.getFieldMap(), onlineCtx);
	
	    return responseData;
	}

	/**
	 * 면담계획/정기면담 면담가능여부를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-04 17:42:11
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("unchecked")
	public IDataSet dDetailAgentCnslPlnCnslYn(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    responseData.putFieldMap(dbSelectSingle("DAGENTCNSLPLN001.dDetailAgentCnslPlnCnslYn", requestData.getFieldMap(), onlineCtx));
	
	    return responseData;
	}

	/**
	 * 면담계획/정기면담 면담일지를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-10 11:46:18
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("unchecked")
	public IDataSet dDetailAgentCnslPlnMgmt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    responseData.putFieldMap(dbSelectSingle("DAGENTCNSLPLN001.dDetailAgentCnslPlnMgmt", requestData.getFieldMap(), onlineCtx));
	
	    return responseData;
	}

	/**
	 * 면담계획/정기면담총건수 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-03-19 15:02:30
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("unchecked")
	public IDataSet dSearchAgentCnslPlnTotCount(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    responseData.putFieldMap(dbSelectSingle("DAGENTCNSLPLN001.dSearchAgentCnslPlnTotCount", requestData.getFieldMap(), onlineCtx)); 
	
	    return responseData;
	}
  
}
