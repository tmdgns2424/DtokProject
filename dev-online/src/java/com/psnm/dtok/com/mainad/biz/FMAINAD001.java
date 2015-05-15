package com.psnm.dtok.com.mainad.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.exception.BizRuntimeException;

import org.apache.commons.logging.Log;

import com.psnm.common.util.PsnmStringUtil;

/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: [FU]메인광고 조회</li>
 * <li>설 명 :</li>
 * <li>작성일 : 2015-03-16 13:33:42</li>
 * <li>작성자 : 이승훈2 (gunyoung)</li>
 * </ul>
 * 
 * @author 이승훈2 (gunyoung)
 */
public class FMAINAD001 extends nexcore.framework.coreext.pojo.biz.FunctionUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public FMAINAD001() {
		super();
	}

	/**
	 * 
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-03-16 13:33:42
	 * 
	 * @param requestData
	 *            요청정보 DataSet 객체
	 * @param onlineCtx
	 *            요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchMainAd(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		Log log = getLog(onlineCtx);
		try {

			DMAINAD001 du = (DMAINAD001) lookupDataUnit(DMAINAD001.class);
			int count = du.dSearchMainAdCnt(requestData, onlineCtx)
					.getRecordSet("COUNT").getRecord(0).getInt("COUNT");
			log.debug("<이달의상품조회> 전체건수 = " + count);

			responseData = du.dSearchMainAd(requestData, onlineCtx);
			responseData.setOkResultMessage("PSNM-I000", null);
			responseData.getRecordSet("grid").setPageNo(
					requestData.getIntField("page"));
			responseData.getRecordSet("grid").setRecordCountPerPage(
					requestData.getIntField("page_size"));
			responseData.getRecordSet("grid").setTotalRecordCount(count);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}

		return responseData;
	}

	/**
	 * 
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-03-16 13:33:42
	 * 
	 * @param requestData
	 *            요청정보 DataSet 객체
	 * @param onlineCtx
	 *            요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fInsertMainAd(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

		Log log = getLog(onlineCtx);

		DMAINAD001 du = (DMAINAD001) lookupDataUnit(DMAINAD001.class);

		requestData.putField("MAIN_AD_ID", du.dSearchMainAdSeq(requestData, onlineCtx).getRecordSet("MAIN_AD").getRecord(0).get("MAIN_AD"));

		du.dInsertMainAd(requestData, onlineCtx);

		return responseData;
	}

	/**
	 * 
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-03-16 16:19:11
	 * 
	 * @param requestData
	 *            요청정보 DataSet 객체
	 * @param onlineCtx
	 *            요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fUpdateMainAd(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

		Log log = getLog(onlineCtx);

		DMAINAD001 du = (DMAINAD001) lookupDataUnit(DMAINAD001.class);
		
		du.dInsertMainAd(requestData, onlineCtx);

		return responseData;

	}

	/**
	 * 
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-03-16 13:33:42
	 * 
	 * @param requestData
	 *            요청정보 DataSet 객체
	 * @param onlineCtx
	 *            요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchMainAdDtl(IDataSet requestData,
			IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		Log log = getLog(onlineCtx);
		try {

			DMAINAD001 du = (DMAINAD001) lookupDataUnit(DMAINAD001.class);

			if (PsnmStringUtil.isEmpty(requestData.getField("MAIN_AD_ID")) == false) {

				responseData.putFieldMap(du.dSearchMainAdDtl(requestData, onlineCtx).getFieldMap());
				
			}

			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}

		return responseData;
	}

	/**
	 *
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-03-17 17:52:47
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fDeleteMainAd(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

		try {

			DMAINAD001 du = (DMAINAD001) lookupDataUnit(DMAINAD001.class);

			du.dDeleteMainAd(requestData, onlineCtx);

			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}

		return responseData;
	}

}
