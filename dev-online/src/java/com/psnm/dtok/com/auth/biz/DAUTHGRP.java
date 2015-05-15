package com.psnm.dtok.com.auth.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: DAUTHGRP</li>
 * <li>설  명 : 권한그룹관리</li>
 * <li>작성일 : 2014-12-15 14:22:20</li>
 * <li>작성자 : 안종광 (rhkd)</li>
 * </ul>
 *
 * @author 안종광 (rhkd)
 */
public class DAUTHGRP extends nexcore.framework.coreext.pojo.biz.DataUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public DAUTHGRP(){
		super();
	}

	/**
	 * 권한그룹조회
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-15 14:23:05
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchAuthGrp(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		IRecordSet rs = dbSelect("DAUTHGRP.dSearchAuthGrp", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
		return responseData;
	}

	/**
	 * 권한그룹적용직무조회
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-15 14:25:08
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchAuthGrpAplyDuty(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		IRecordSet rs = dbSelect("DAUTHGRP.dSearchAuthGrpAplyDuty", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
		return responseData;
	}

	/**
	 * 권한그룹merge(등록|수정)
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-15 14:27:58
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dMergeAuthGrp(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		int result = dbInsert("DAUTHGRP.dMergeAuthGrp", requestData.getFieldMap(), onlineCtx);
		responseData.putField("result", result);
		return responseData;
	}

	/**
	 * 권한그룹삭제
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-15 14:28:33
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dDeleteAuthGrp(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		int result = dbInsert("DAUTHGRP.dDeleteAuthGrp", requestData.getFieldMap(), onlineCtx);
		responseData.putField("result", result);
		return responseData;
	}

	/**
	 * 권한그룹적용직무등록
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-15 14:29:18
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertAuthGrpAplyDuty(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		int result = dbInsert("DAUTHGRP.dInsertAuthGrpAplyDuty", requestData.getFieldMap(), onlineCtx);
		responseData.putField("result", result);
		return responseData;
	}

	/**
	 * 권한그룹적용직무삭제
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-15 14:29:45
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dDeleteAuthGrpAplyDuty(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		int result = dbInsert("DAUTHGRP.dDeleteAuthGrpAplyDuty", requestData.getFieldMap(), onlineCtx);
		responseData.putField("result", result);
		return responseData;
	}
  
}
