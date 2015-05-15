package com.psnm.dtok.biz.smsmgmt.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecord;
import nexcore.framework.core.data.IRecordSet;

/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/업무</li>
 * <li>단위업무명: [DU]SMS관리</li>
 * <li>설 명 :</li>
 * <li>작성일 : 2015-02-11 15:00:41</li>
 * <li>작성자 : 이승훈2 (gunyoung)</li>
 * </ul>
 * 
 * @author 이승훈2 (gunyoung)
 */
public class DSMSMGMT001 extends nexcore.framework.coreext.pojo.biz.DataUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public DSMSMGMT001() {
		super();
	}

	/**
	 * 
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-02-12 13:06:19
	 * 
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx 요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchSmsMgmt(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		IRecordSet rs = dbSelect("DSMSMGMT001.dSearchSmsMgmt", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
		return responseData;
	}

	/**
	 * 
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-02-12 13:10:20
	 * 
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx 요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchMsgGrp(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		IRecordSet rs = dbSelect("DSMSMGMT001.dSearchMsgGrp", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
		return responseData;
	}

	/**
	 * 
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-02-23 09:40:23
	 * 
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx 요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchHPart(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		IRecordSet rs = dbSelect("DSMSMGMT001.dSearchHPart", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
		return responseData;
	}

	/**
	 * 
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-02-23 14:27:38
	 * 
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx 요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertSmsSnd(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		dbInsert("DSMSMGMT001.dInsertSmsSnd", requestData.getFieldMap(), onlineCtx);
		return responseData;
	}

	/**
	 * 
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-02-23 14:59:19
	 * 
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx 요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dDeleteSmsSnd(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		dbUpdate("DSMSMGMT001.dDeleteSmsSnd", requestData.getFieldMap(), onlineCtx);
		return responseData;
	}

	/**
	 * 
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-02-24 15:22:13
	 * 
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx 요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchHTeam(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		IRecordSet rs = dbSelect("DSMSMGMT001.dSearchHTeam", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
		return responseData;
	}

	/**
	 * 
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-02-26 09:21:41
	 * 
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx 요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchDuty(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		IRecordSet rs = dbSelect("DSMSMGMT001.dSearchDuty", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
		return responseData;
	}

	/**
	 * 
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-02-27 10:50:44
	 * 
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx 요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchUser(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		IRecordSet rs = dbSelect("DSMSMGMT001.dSearchUser", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
		return responseData;
	}

	/**
	 * 
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-03-03 16:17:19
	 * 
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx 요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchDeptUser(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		IRecordSet rs = dbSelect("DSMSMGMT001.dSearchDeptUser", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
		return responseData;
	}

	/**
	 * 
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-02-11 15:00:41
	 * 
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx 요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("unchecked")
	public IDataSet dSearchMsgCount(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		IRecord record = dbSelectSingle("DSMSMGMT001.dSearchMsgCount", requestData.getFieldMap(), onlineCtx);
		responseData.putFieldMap(record);
		return responseData;
	}

	/**
	 *
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-03-20 09:36:39
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchDutySMgtm(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		IRecordSet rs = dbSelect("DSMSMGMT001.dSearchDutySMgtm", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
		return responseData;
	}

}
