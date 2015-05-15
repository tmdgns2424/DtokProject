package com.psnm.dtok.agn.agntmgmt.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/에이전트</li>
 * <li>단위업무명: DAGENTSCHSHIPHST001</li>
 * <li>설  명 : 에이전트학력정보 DU</li>
 * <li>작성일 : 2014-12-18 14:42:25</li>
 * <li>작성자 : 한상곤 (hansanggon)</li>
 * </ul>
 *
 * @author 한상곤 (hansanggon)
 */
public class DAGENTSCHSHIPHST001 extends nexcore.framework.coreext.pojo.biz.DataUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public DAGENTSCHSHIPHST001(){
		super();
	}

	/**
	 * 에이전트학력정보 조회 DM
	 *
	 * @author 한상곤 (hansanggon)
	 * @since 2014-12-18 14:42:25
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchAgentSchshipHst(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    
	    //처리 결과값을 responseData에 넣어서 리턴하십시요 
	    responseData.putRecordSet("ds", dbSelect("DAGENTSCHSHIPHST001.dSearchAgentSchshipHst", requestData.getFieldMap(), onlineCtx));	    
	
	    return responseData;
	}

	/**
	 * 에이전트학력정보 저장 DM
	 *
	 * @author 김보선 (kimbosun)
	 * @since 2015-02-16 11:02:32
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertAgentSchshipHst(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    dbInsert("DAGENTSCHSHIPHST001.dInsertAgentSchshipHst", requestData.getFieldMap(), onlineCtx);
	
	    return responseData;
	}

	/**
	 * 에이전트학력정보 삭제 DM
	 *
	 * @author 김보선 (kimbosun)
	 * @since 2015-03-02 17:58:30
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dDeleteAgentSchshipHst(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    dbDelete("DAGENTSCHSHIPHST001.dDeleteAgentSchshipHst", requestData.getFieldMap(), onlineCtx);
	
	    return responseData;
	}
  
}
