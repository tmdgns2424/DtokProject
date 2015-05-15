package com.psnm.dtok.biz.issueprod.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.exception.BizRuntimeException;

import com.psnm.common.util.PsnmStringUtil;

/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/업무</li>
 * <li>단위업무명: [PU]이달의상품</li>
 * <li>설 명 :</li>
 * <li>작성일 : 2015-01-08 09:11:47</li>
 * <li>작성자 : 이승훈2 (gunyoung)</li>
 * </ul>
 * 
 * @author 이승훈2 (gunyoung)
 */
public class PISSUEPROD001 extends nexcore.framework.coreext.pojo.biz.ProcessUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public PISSUEPROD001() {
		super();
	}

	/**
	 * 
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-08 09:11:47
	 * 
	 * @param requestData
	 *            요청정보 DataSet 객체
	 * @param onlineCtx
	 *            요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchIssueProd(IDataSet requestData, IOnlineContext onlineCtx) {

		IDataSet responseData = new DataSet();

		try {
			FISSUEPROD001 fu = (FISSUEPROD001) lookupFunctionUnit(FISSUEPROD001.class);

			responseData = fu.fSearchIssueProd(requestData, onlineCtx);

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
	 * @since 2015-01-08 15:24:41
	 * 
	 * @param requestData
	 *            요청정보 DataSet 객체
	 * @param onlineCtx
	 *            요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pDetailIssueProd(IDataSet requestData, IOnlineContext onlineCtx) {
		
		IDataSet responseData = new DataSet();

		try {
			FISSUEPROD001 fu = (FISSUEPROD001) lookupFunctionUnit(FISSUEPROD001.class);

			responseData=fu.fDetailIssueProd(requestData, onlineCtx);
				
			
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
	 * @since 2015-01-08 09:11:47
	 * 
	 * @param requestData
	 *            요청정보 DataSet 객체
	 * @param onlineCtx
	 *            요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSaveIssueProd(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

		try {
			FISSUEPROD001 fu = (FISSUEPROD001) lookupFunctionUnit(FISSUEPROD001.class);

			if (PsnmStringUtil.isEmpty(requestData.getField("ISS_ID"))) {
				fu.fInsertIssueProd(requestData, onlineCtx);
			} else {
				fu.fUpdateIssueProd(requestData, onlineCtx);
			}

			if (requestData.getRecordSet("gridfile") != null) {
				// 첨부파일 정보를 저장(등록 | 삭제) : 공유컴포넌트 호출
				callSharedBizComponentByDirect("com.SHARE", "fSaveFileList", requestData, onlineCtx);
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
	 * @since 2015-01-09 15:18:04
	 * 
	 * @param requestData
	 *            요청정보 DataSet 객체
	 * @param onlineCtx
	 *            요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pDeleteIssueProd(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

		try {
			FISSUEPROD001 fu = (FISSUEPROD001) lookupFunctionUnit(FISSUEPROD001.class);
			
			fu.fDeleteIssueProd(requestData, onlineCtx);
				
			// 첨부파일 정보를 저장(등록 | 삭제) : 공유컴포넌트 호출
			callSharedBizComponentByDirect("com.SHARE", "fDeleteFileMapping", requestData, onlineCtx);



			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}

		return responseData;
	}

}
