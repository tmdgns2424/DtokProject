package com.psnm.dtok.com.menu.biz;

import java.util.Map;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecord;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.data.IResultMessage;
import nexcore.framework.core.data.ResultMessage;
import nexcore.framework.core.exception.BizRuntimeException;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: DMENUAUTH001</li>
 * <li>설  명 : 메뉴권한관리(DSM_MENU_AUTH)</li>
 * <li>작성일 : 2014-12-12 09:42:20</li>
 * <li>작성자 : 안종광 (rhkd)</li>
 * </ul>
 *
 * @author 안종광 (rhkd)
 */
public class DMENUAUTH001 extends nexcore.framework.coreext.pojo.biz.DataUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public DMENUAUTH001(){
		super();
	}

	/**
	 * 메뉴권한조회
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-12 10:07:31
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchMenuAuth(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		IRecordSet rs = dbSelect("DMENUAUTH001.dSearchMenuAuth", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
		return responseData;
	}

	/**
	 * 메뉴권한등록
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-12 10:07:55
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertMenuAuth(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		int result = dbInsert("DMENUAUTH001.dInsertMenuAuth", requestData.getFieldMap(), onlineCtx);
		responseData.putField("result", result);
		return responseData;
	}

	/**
	 * 메뉴권한삭제
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-12 10:08:18
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dDeleteMenuAuth(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		int result = dbDelete("DMENUAUTH001.dDeleteMenuAuth", requestData.getFieldMap(), onlineCtx);
		responseData.putField("result", result);
		return responseData;
	}

	/**
	 * 메뉴권한merge(update or insert)
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-12 14:46:27
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dMergeMenuAuth(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		int result = dbUpdate("DMENUAUTH001.dMergeMenuAuth", requestData.getFieldMap(), onlineCtx);
		responseData.putField("result", result);
		return responseData;
	}

	/**
	 * [DM]메뉴권한이력등록
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-04-28 17:44:44
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertMenuAuthHst(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		int result = dbInsert("DMENUAUTH001.dInsertMenuAuthHst", requestData.getFieldMap(), onlineCtx);
		responseData.putField("result", result);
		return responseData;
	}
  
}
