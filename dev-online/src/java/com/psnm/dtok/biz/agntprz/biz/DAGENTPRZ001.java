package com.psnm.dtok.biz.agntprz.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/업무</li>
 * <li>단위업무명: DAGENTPRZ001</li>
 * <li>설  명 : 포상관리 DU</li>
 * <li>작성일 : 2014-11-26 18:17:32</li>
 * <li>작성자 : 한상곤 (hansanggon)</li>
 * </ul>
 *
 * @author 한상곤 (hansanggon)
 */
public class DAGENTPRZ001 extends nexcore.framework.coreext.pojo.biz.DataUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public DAGENTPRZ001(){
		super();
	}

	/**
	 * 포상관리 정보를 조회하는 메소드
	 *
	 * @author 한상곤 (hansanggon)
	 * @since 2014-11-26 18:17:32
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchAgentPrz(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DAGENTPRZ001.dSearchAgentPrz", requestData.getFieldMap(), onlineCtx);
	    responseData.putRecordSet("ds", rs);
	
	    return responseData;
	}

	/**
	 * 포상관리건수 정보를 조회하는 메소드
	 *
	 * @author 한상곤 (hansanggon)
	 * @since 2014-11-26 18:17:32
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchAgentPrzCount(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DAGENTPRZ001.dSearchAgentPrzCount", requestData.getFieldMap(), onlineCtx);
	    responseData.putField("count", rs.get(0, 0));
	
	    return responseData;
	}

	/**
	 * 포상관리상세 정보를 조회하는 메소드
	 *
	 * @author 한상곤 (hansanggon)
	 * @since 2014-11-26 18:17:32
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("unchecked")
	public IDataSet dDetailAgentPrz(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    responseData.putFieldMap(this.dbSelectSingle("DAGENTPRZ001.dDetailAgentPrz", requestData.getFieldMap(), onlineCtx));
	
	    return responseData;
	}

	/**
	 * 포상관리정보를 저장하는 메소드
	 *
	 * @author 한상곤 (hansanggon)
	 * @since 2014-11-26 18:17:32
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertAgentPrz(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    
	    dbInsert("DAGENTPRZ001.dInsertAgentPrz", requestData.getFieldMap(), onlineCtx);
	    
	    return responseData;
	    
	}

	/**
	 * 포상관리 정보를 수정하는 메소드
	 *
	 * @author 한상곤 (hansanggon)
	 * @since 2014-11-26 18:17:32
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dUpdateAgentPrz(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    
	    dbUpdate("DAGENTPRZ001.dUpdateAgentPrz", requestData.getFieldMap(), onlineCtx);
	  
	    return responseData;
	}

	/**
	 * 포상관리 정보를 삭제하는 메소드
	 *
	 * @author 한상곤 (hansanggon)
	 * @since 2014-11-26 18:17:32
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dDeleteAgentPrz(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    
	    dbDelete("DAGENTPRZ001.dDeleteAgentPrz", requestData.getFieldMap(), onlineCtx);
	    
	    return responseData;
	}

	/**
	 * 포상관리엑셀업로드정보를 조회하는 메소드
	 *
	 * @author 한상곤 (hansanggon)
	 * @since 2014-11-26 18:17:32
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	
	public IDataSet dSearchExlAgentPrz(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    
	    IRecordSet rs = dbSelect("DAGENTPRZ001.dSearchExlAgentPrz", requestData.getFieldMap(), onlineCtx);
	    responseData.putRecordSet("ds", rs);
		
	    return responseData;
	}
  
}
