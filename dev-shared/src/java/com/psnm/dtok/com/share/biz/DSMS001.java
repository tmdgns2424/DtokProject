package com.psnm.dtok.com.share.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecord;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: DSMS</li>
 * <li>설  명 : [DU]SMS기본 (설명) TKEY! 같은 데이터베이스 PS_MNG 사용자 테이블 참조</li>
 * <li>작성일 : 2015-01-12 18:23:20</li>
 * <li>작성자 : 안종광 (rhkd)</li>
 * </ul>
 *
 * @author 안종광 (rhkd)
 */
public class DSMS001 extends nexcore.framework.coreext.pojo.biz.DataUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public DSMS001(){
		super();
	}

	/**
	 * [DM]SMS전송차수SEQ다음값 조회
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-01-12 18:23:20
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("unchecked")
	public IDataSet dSearchNextTranSeq(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		IRecord record = dbSelectSingle("DSMS001.dSearchNextTranSeq", requestData.getFieldMap(), onlineCtx);
		responseData.putFieldMap(record);
		return responseData;
	}

	/**
	 * [DM]SMS고유ID다음값 조회
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-01-12 18:23:20
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("unchecked")
	public IDataSet dSearchNextCmpMsgSeq(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		IRecord record = dbSelectSingle("DSMS001.dSearchNextCmpMsgSeq", requestData.getFieldMap(), onlineCtx);
		responseData.putFieldMap(record);
		return responseData;
	}

	/**
	 * [DM]SMS거래정보등록
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-01-12 18:23:20
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertSmsTran(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		int result = dbInsert("DSMS001.dInsertSmsTran", requestData.getFieldMap(), onlineCtx);
		responseData.putField("result", result);
		return responseData;
	}

	/**
	 * [DM]SMS거래정보등록(상세)
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-01-12 18:23:20
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertSmsTranDtl(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		int result = dbInsert("DSMS001.dInsertSmsTranDtl", requestData.getFieldMap(), onlineCtx);
		responseData.putField("result", result);
		return responseData;
	}

	/**
	 * [DM]SMS발송정보등록
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-01-12 18:23:20
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertTelinkSms(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		int result = dbInsert("DSMS001.dInsertTelinkSms", requestData.getFieldMap(), onlineCtx);
		responseData.putField("result", result);
		return responseData;
	}

	/**
	 * [DM]SMS기본정보조회 : 사용자ID조건
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-01-14 17:26:45
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("unchecked")
	public IDataSet dSearchSmsInfoByUser(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		IRecord record = dbSelectSingle("DSMS001.dSearchSmsInfoByUser", requestData.getFieldMap(), onlineCtx);
		responseData.putFieldMap(record);
		return responseData;
	}

	/**
	 * [DM]영업국사용자부재여부체크 - SMS발송시 현재 부재여부 데이터 조회
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-01-21 14:20:21
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("unchecked")
	public IDataSet dSearchChrgrOpAbsn(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		IRecord record = dbSelectSingle("DSMS001.dSearchChrgrOpAbsn", requestData.getFieldMap(), onlineCtx);
		responseData.putFieldMap(record);
		return responseData;
	}

	/**
	 * [DM]SMS전송건수조회 - 지정된 년/월과 전송전화번호 조건
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-03-04 09:45:34
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("unchecked")
	public IDataSet dSearchSmsCount(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		IRecord record = dbSelectSingle("DSMS001.dSearchSmsCount", requestData.getFieldMap(), onlineCtx);
		responseData.putFieldMap(record);
		return responseData;
	}
  
}
