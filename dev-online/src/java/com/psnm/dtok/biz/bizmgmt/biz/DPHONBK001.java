package com.psnm.dtok.biz.bizmgmt.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/업무</li>
 * <li>단위업무명: DPHONBK001</li>
 * <li>설  명 : </li>
 * <li>작성일 : 2015-01-23 10:51:45</li>
 * <li>작성자 : 이승훈2 (gunyoung)</li>
 * </ul>
 *
 * @author 이승훈2 (gunyoung)
 */
public class DPHONBK001 extends nexcore.framework.coreext.pojo.biz.DataUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public DPHONBK001(){
		super();
	}

	/**
	 * 전화번호부를 조회하는 메소드
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-23 10:53:20
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchPhonBk(IDataSet requestData, IOnlineContext onlineCtx) {

		IDataSet responseData = new DataSet();
		
		IRecordSet rs = dbSelect("DPHONBK001.dSearchPhonBk", requestData.getFieldMap(), onlineCtx);
		
		responseData.putRecordSet("grid", rs);//앞에는 알로펙스값 뒤에 rs는 해당 값
		
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-27 17:12:35
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchSaleTeam(IDataSet requestData, IOnlineContext onlineCtx) {
		
		IDataSet responseData = new DataSet();
		
	    IRecordSet rs = dbSelect("DPHONBK001.dSearchSaleTeam", requestData.getFieldMap(), onlineCtx);
	    
		responseData.putRecordSet("teamSearch", rs);//앞에는 알로펙스값 뒤에 rs는 해당 값
		
	    return responseData;
	}

	/**
	 * 전화번호부 정보를 상세 조회 하는 메소드
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-23 10:51:45
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dDetailPhonBk(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
 
		responseData.putFieldMap(dbSelectSingle("DPHONBK001.dDetailPhonBk", requestData.getFieldMap(), onlineCtx));
	    
		return responseData;
	}

	/**
	 * 전화번호부 정보를 조건 별로 조회 하는 메소드
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-23 10:51:45
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchPhonBkCondi(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		
		IRecordSet rs = dbSelect("DPHONBK001.dSearchPhonBkCondi", requestData.getFieldMap(), onlineCtx);
		
		responseData.putRecordSet("grid", rs);//앞에는 알로펙스값 뒤에 rs는 해당 값
		
	    return responseData;
	}
}
