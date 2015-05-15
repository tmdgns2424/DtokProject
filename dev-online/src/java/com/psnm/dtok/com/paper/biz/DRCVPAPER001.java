package com.psnm.dtok.com.paper.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: DRCVPAPER001</li>
 * <li>설  명 : 받은 쪽지함 DU</li>
 * <li>작성일 : 2015-01-07 13:52:17</li>
 * <li>작성자 : 이승훈2 (gunyoung)</li>
 * </ul>
 *
 * @author 이승훈2 (gunyoung)
 */
public class DRCVPAPER001 extends nexcore.framework.coreext.pojo.biz.DataUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public DRCVPAPER001(){
		super();
	}

	/**
	 *
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-07 13:52:17
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchRcvPaper(IDataSet requestData, IOnlineContext onlineCtx) {
	
		IDataSet responseData = new DataSet();
		IRecordSet rs = dbSelect("DRCVPAPER001.dSearchRcvPaper", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("gridpaper", rs);//앞에는 알로펙스값 뒤에 rs는 해당 값
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-07 13:52:17
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dDeleteRcvPaper(IDataSet requestData, IOnlineContext onlineCtx) {

	    IDataSet responseData = new DataSet();

	    dbUpdate("DRCVPAPER001.dDeleteRcvPaper", requestData.getFieldMap(), onlineCtx);
	    
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-07 13:52:17
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchRcvCount(IDataSet requestData, IOnlineContext onlineCtx) {
	    
		IDataSet responseData = new DataSet();
		IRecordSet rs = dbSelect("DRCVPAPER001.dSearchRcvCount", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("COUNT", rs);//앞에는 알로펙스값 뒤에 rs는 해당 값
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-09 15:10:56
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("unchecked")
	public IDataSet dSearchRcvPaperDtl(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

		responseData.putFieldMap(dbSelectSingle("DRCVPAPER001.dSearchRcvPaperDtl", requestData.getFieldMap(), onlineCtx)); 
	    
		return responseData;
	}


	/**
	 *
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-12 17:17:58
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertRcvPaper(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
		dbInsert("DRCVPAPER001.dInsertRcvPaper", requestData.getFieldMap(), onlineCtx);	    
		return responseData;
	}

	/**
	 *
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-14 13:37:10
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dUpdateRcvPaper(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		dbUpdate("DRCVPAPER001.dUpdateRcvPaper", requestData.getFieldMap(), onlineCtx);
	    return responseData;
	}
  
}
