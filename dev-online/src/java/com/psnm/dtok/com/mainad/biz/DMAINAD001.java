package com.psnm.dtok.com.mainad.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: [DU]메인광고관리</li>
 * <li>설  명 : </li>
 * <li>작성일 : 2015-03-16 13:34:12</li>
 * <li>작성자 : 이승훈2 (gunyoung)</li>
 * </ul>
 *
 * @author 이승훈2 (gunyoung)
 */
public class DMAINAD001 extends nexcore.framework.coreext.pojo.biz.DataUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public DMAINAD001(){
		super();
	}

	/**
	 *
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-03-16 13:34:49
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchMainAd(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();

		IRecordSet rs = dbSelect("DMAINAD001.dSearchMainAd", requestData.getFieldMap(), onlineCtx);

		responseData.putRecordSet("grid", rs);
	
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-03-16 13:36:56
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchMainAdCnt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();

		IRecordSet rs = dbSelect("DMAINAD001.dSearchMainAdCnt", requestData.getFieldMap(), onlineCtx);

		responseData.putRecordSet("COUNT", rs);

	    return responseData;
	}

	/**
	 *
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-03-16 13:34:12
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertMainAd(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    dbInsert("DMAINAD001.dInsertMainAd", requestData.getFieldMap(), onlineCtx);
	
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-03-16 16:38:45
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchMainAdSeq(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();

		IRecordSet rs = dbSelect("DMAINAD001.dSearchMainAdSeq", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("MAIN_AD", rs);
	
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-03-16 13:34:12
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("unchecked")
	public IDataSet dSearchMainAdDtl(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    responseData.putFieldMap(dbSelectSingle("DMAINAD001.dSearchMainAdDtl", requestData.getFieldMap(), onlineCtx));

	    return responseData;
	}

	/**
	 *
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-03-17 17:53:04
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dDeleteMainAd(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
		dbDelete("DMAINAD001.dDeleteMainAd", requestData.getFieldMap(), onlineCtx);

	    return responseData;
	}
  
}
