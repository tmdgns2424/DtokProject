package com.psnm.dtok.com.phrs.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: DPHRS001</li>
 * <li>설  명 : 명언관리DU
</li>
 * <li>작성일 : 2015-01-05 15:14:41</li>
 * <li>작성자 : 이승훈2 (gunyoung)</li>
 * </ul>
 *
 * @author 이승훈2 (gunyoung)
 */
public class DPHRS001 extends nexcore.framework.coreext.pojo.biz.DataUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public DPHRS001(){
		super();
	}

	/**
	 * 명언관리 조회 DM
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-05 15:14:41
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchPhrs(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    responseData.putRecordSet("gridphrs", dbSelect("DPHRS001.dSearchPhrs", requestData.getFieldMap(), onlineCtx));
	    

	    return responseData;
	}

	/**
	 *
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-05 15:14:41
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSavePhrs(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    int result = dbUpdate("DPHRS001.dUpdatePhrs", requestData.getFieldMap(), onlineCtx);
	    responseData.putField("result", result);
	    return responseData;
	}
	  
}
