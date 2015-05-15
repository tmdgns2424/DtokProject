package com.psnm.dtok.biz.saleplcy.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;


/**
 * <ul>
 * <li>업무 그룹명 : </li>
 * <li>단위업무명: DPLCYRCVGRP001</li>
 * <li>설  명 : 영업정책그룹관리DU</li>
 * <li>작성일 : 2014-11-21 12:52:43</li>
 * <li>작성자 : 이민재 (leeminjae)</li>
 * </ul>
 *
 * @author 이민재 (leeminjae)
 */
public class DPLCYRCVGRP001 extends nexcore.framework.coreext.pojo.biz.DataUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public DPLCYRCVGRP001(){
		super();
	}

	/**
	 * 영업정책 수신그룹 정보를 추가하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-11-21 12:57:32
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertPlcyRcvGrp(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    dbInsert("DPLCYRCVGRP001.dInsertPlcyRcvGrp", requestData.getFieldMap(), onlineCtx);
	
	    return responseData;
	}

	/**
	 * 영업정책 수신그룹 정보를 삭제하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-11-21 12:58:13
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dDeletePlcyRcvGrp(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    dbUpdate("DPLCYRCVGRP001.dDeletePlcyRcvGrp", requestData.getFieldMap(), onlineCtx);
	
	    return responseData;
	}

	/**
	 * 영업정책수신그룹 공지대상권한을 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-11-21 12:52:43
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchPlcyRcvGrpAuthTarget(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DPLCYRCVGRP001.dSearchPlcyRcvGrpAuthTarget", requestData.getFieldMap(), onlineCtx);

		responseData.putRecordSet("ds", rs); 
	
	    return responseData;
	}

	/**
	 * 영업정책수신그룹 공지할 권한을 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-11-21 15:05:26
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchPlcyRcvGrpAuthObjet(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DPLCYRCVGRP001.dSearchPlcyRcvGrpAuthObjet", requestData.getFieldMap(), onlineCtx);

		responseData.putRecordSet("ds", rs); 
	
	    return responseData;
	}
  
}
