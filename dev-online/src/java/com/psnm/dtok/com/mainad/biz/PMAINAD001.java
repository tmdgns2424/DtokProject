package com.psnm.dtok.com.mainad.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.exception.BizRuntimeException;
import nexcore.framework.core.util.StringUtils;

import com.psnm.common.util.PsnmStringUtil;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: [PU]메인광고관리</li>
 * <li>설  명 : </li>
 * <li>작성일 : 2015-03-16 13:31:21</li>
 * <li>작성자 : 이승훈2 (gunyoung)</li>
 * </ul>
 *
 * @author 이승훈2 (gunyoung)
 */
public class PMAINAD001 extends nexcore.framework.coreext.pojo.biz.ProcessUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public PMAINAD001(){
		super();
	}

	/**
	 *
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-03-16 13:32:54
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchMainAd(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();

		try {
			FMAINAD001 fu = (FMAINAD001) lookupFunctionUnit(FMAINAD001.class);

			responseData = fu.fSearchMainAd(requestData, onlineCtx);

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
	 * @since 2015-03-16 14:54:34
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSaveMainAd(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	FMAINAD001 fu = (FMAINAD001) lookupFunctionUnit(FMAINAD001.class);

			if (PsnmStringUtil.isEmpty(requestData.getField("MAIN_AD_ID"))) {
				fu.fInsertMainAd(requestData, onlineCtx);
			} else {
				fu.fUpdateMainAd(requestData, onlineCtx);
			}
			//사진 등록
	    	if( StringUtils.isNotEmpty(requestData.getField("FILE_NM")) ) {
	    		
	    		requestData.putField("MAD_FILE_ID", requestData.getField("ATCH_FILE_ID"));    		
				callSharedBizComponentByDirect("com.SHARE", "fSavePictuerFile", requestData, onlineCtx);
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
	 * @since 2015-03-16 13:31:21
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchMainAdDtl(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

		try {
			FMAINAD001 fu = (FMAINAD001) lookupFunctionUnit(FMAINAD001.class);
			responseData=fu.fSearchMainAdDtl(requestData, onlineCtx);
				
			
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
	 * @since 2015-03-17 17:52:34
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pDeleteMainAd(IDataSet requestData, IOnlineContext onlineCtx) {
			IDataSet responseData = new DataSet();

			try {
				FMAINAD001 fu = (FMAINAD001) lookupFunctionUnit(FMAINAD001.class);
				
				fu.fDeleteMainAd(requestData, onlineCtx);
				callSharedBizComponentByDirect("com.SHARE", "fDeleteFileByFileId", requestData, onlineCtx);

				responseData.setOkResultMessage("PSNM-I000", null);

			} catch (BizRuntimeException be) {
				throw be;
			} catch (Exception e) {
				throw new BizRuntimeException("PSNM-E000", e);
			}

			return responseData;
		}

	}
