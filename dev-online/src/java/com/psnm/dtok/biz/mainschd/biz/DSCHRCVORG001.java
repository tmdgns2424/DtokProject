package com.psnm.dtok.biz.mainschd.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/업무</li>
 * <li>단위업무명: DSCHRCVORG001</li>
 * <li>설  명 : </li>
 * <li>작성일 : 2015-01-15 16:55:15</li>
 * <li>작성자 : 이승훈2 (gunyoung)</li>
 * </ul>
 *
 * @author 이승훈2 (gunyoung)
 */
public class DSCHRCVORG001 extends nexcore.framework.coreext.pojo.biz.DataUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public DSCHRCVORG001(){
		super();
	}

	/**
	 * 주요일정 수신조직 정보를 조회하는 메소드
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-15 16:55:59
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchSchRcvOrg(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    IRecordSet rs = dbSelect("DSCHRCVORG001.dSearchSchRcvOrg", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs); 
	    return responseData;
	}

	/**
	 * 주요일정 수신조직 정보를 추가하는 메소드
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-15 18:31:47
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertSchRcvOrg(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    dbInsert("DSCHRCVORG001.dInsertSchRcvOrg", requestData.getFieldMap(), onlineCtx);
	    return responseData;
	}

	/**
	 * 주요일정 수신조직 정보를 삭제하는 메소드
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-15 18:32:18
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dDeleteSchRcvOrg(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    dbDelete("DSCHRCVORG001.dDeleteSchRcvOrg", requestData.getFieldMap(), onlineCtx); 
	    return responseData;
	}
  
}
