package com.psnm.dtok.com.share.biz;

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
 * <li>단위업무명: DSM002</li>
 * <li>설  명 : [DU]SMS백오피스</li>
 * <li>작성일 : 2015-01-13 16:29:32</li>
 * <li>작성자 : 안종광 (rhkd)</li>
 * </ul>
 *
 * @author 안종광 (rhkd)
 */
public class DSMS002 extends nexcore.framework.coreext.pojo.biz.DataUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public DSMS002(){
		super();
	}

	/**
	 * [DM]SMS큐등록 : PSNMSMS.TBO_SUBMIT_QUEUE
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-01-13 16:29:32
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertPsnmsmsQueue(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		int result = dbInsert("DSMS002.dInsertPsnmsmsQueue", requestData.getFieldMap(), "BoBizDS", onlineCtx);
		responseData.putField("result", result);
		return responseData;
	}

	/**
	 * [DM]SMS거래시각조회(Single)
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-01-13 16:29:32
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("unchecked")
	public IDataSet dSearchMsgDtm(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		IRecord record = dbSelectSingle("DSMS002.dSearchMsgDtm", requestData.getFieldMap(), "BoBizDS", onlineCtx);
		responseData.putFieldMap(record);
		return responseData;
	}

	/**
	 * [DM]SMS발송정보등록
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-01-13 17:53:29
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertSysMsgSnd(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		int result = dbInsert("DSMS002.dInsertSysMsgSnd", requestData.getFieldMap(), "BoBizDS", onlineCtx);
		responseData.putField("result", result);
		return responseData;
	}

	/**
	 * [DM]SMS발송정보이력등록
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-01-13 17:53:50
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertSysMsgSndHst(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		int result = dbInsert("DSMS002.dInsertSysMsgSndHst", requestData.getFieldMap(), "BoBizDS", onlineCtx);
		responseData.putField("result", result);
		return responseData;
	}

	/**
	 * [DM]SMS발송(BO)건수조회 - 발신년월, 발신번호조건
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-03-04 10:49:29
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("unchecked")
	public IDataSet dSearchBoSmsCount(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		IRecord record = dbSelectSingle("DSMS002.dSearchBoSmsCount", requestData.getFieldMap(), "BoBizDS", onlineCtx);
		responseData.putFieldMap(record);
		return responseData;
	}

}
