package com.psnm.dtok.com.share.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: DORG</li>
 * <li>설  명 : [DU]코드조회2</li>
 * <li>작성일 : 2015-01-08 15:49:34</li>
 * <li>작성자 : 안종광 (rhkd)</li>
 * </ul>
 *
 * @author 안종광 (rhkd)
 */
public class DORG extends nexcore.framework.coreext.pojo.biz.DataUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public DORG(){
		super();
	}

	/**
	 * [DM]본사팀목록(세션없음)
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-01-08 15:49:34
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchHdqtTeamOrgId2(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
	    IRecordSet rs = dbSelect("DORG.dSearchHdqtTeamOrgId2", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
		return responseData;
	}

	/**
	 * [DM]본사파트 목록 조회(세션없음)
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-01-08 15:52:25
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchHdqtPartOrgId2(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
	    IRecordSet rs = dbSelect("DORG.dSearchHdqtPartOrgId2", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
		return responseData;
	}

	/**
	 * [DM]영업국(세션없음)
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-01-08 15:53:08
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchSaleDeptOrgId2(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
	    IRecordSet rs = dbSelect("DORG.dSearchSaleDeptOrgId2", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
		return responseData;
	}

	/**
	 * [DM]영업팀목록(세션없음)
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-01-08 15:53:42
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchSaleTeamOrgId2(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
	    IRecordSet rs = dbSelect("DORG.dSearchSaleTeamOrgId2", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
		return responseData;
	}

	/**
	 * [DM]에이전트목록(세션없음)
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-01-08 15:54:16
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchSaleAgntOrgId2(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
	    IRecordSet rs = dbSelect("DORG.dSearchSaleAgntOrgId2", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
		return responseData;
	}

	/**
	 * [DM]영업국조회 - 본사팀, 본사파트 조건
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-01-12 14:18:01
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSelectSaleDept(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
	    IRecordSet rs = dbSelect("DORG.dSelectSaleDept", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
		return responseData;
	}
  
}
