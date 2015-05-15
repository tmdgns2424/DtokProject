package com.psnm.dtok.biz.mainschd.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/업무</li>
 * <li>단위업무명: DSCHRCVGRP001</li>
 * <li>설  명 : </li>
 * <li>작성일 : 2015-01-15 15:33:12</li>
 * <li>작성자 : 이승훈2 (gunyoung)</li>
 * </ul>
 *
 * @author 이승훈2 (gunyoung)
 */
public class DSCHRCVGRP001 extends nexcore.framework.coreext.pojo.biz.DataUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public DSCHRCVGRP001(){
		super();
	}

	/**
	 * 주요일정 수신그룹 정보를 조회하는 메소드
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-15 15:33:12
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchSchRcvGrp(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    IRecordSet rs = dbSelect("DSCHRCVGRP001.dSearchSchRcvGrp", requestData.getFieldMap(), onlineCtx);
	    responseData.putRecordSet("ds", rs);
	    return responseData;
	}

	/**
	 * 주요일정 수신그룹 정보를 추가하는 메소드
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-15 18:30:11
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertSchRcvGrp(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    dbInsert("DSCHRCVGRP001.dInsertSchRcvGrp", requestData.getFieldMap(), onlineCtx);
	    return responseData;
	}

	/**
	 * 주요일정 수신그룹 정보를 삭제하는 메소드
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-15 18:30:47
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dDeleteSchRcvGrp(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    dbDelete("DSCHRCVGRP001.dDeleteSchRcvGrp", requestData.getFieldMap(), onlineCtx); 
	    return responseData;
	}
  
}
