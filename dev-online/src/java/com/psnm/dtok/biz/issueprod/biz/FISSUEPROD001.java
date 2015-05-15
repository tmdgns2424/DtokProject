package com.psnm.dtok.biz.issueprod.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.exception.BizRuntimeException;

import org.apache.commons.logging.Log;

import com.psnm.common.util.PsnmStringUtil;

/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/업무</li>
 * <li>단위업무명: [FU]이달의상품</li>
 * <li>설 명 :</li>
 * <li>작성일 : 2015-01-08 09:17:27</li>
 * <li>작성자 : 이승훈2 (gunyoung)</li>
 * </ul>
 * 
 * @author 이승훈2 (gunyoung)
 */
public class FISSUEPROD001 extends nexcore.framework.coreext.pojo.biz.FunctionUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public FISSUEPROD001() {
		super();
	}

	/**
	 * 이달의 상품 정보를 조회하는 메소드
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-08 09:17:52
	 * 
	 * @param requestData
	 *            요청정보 DataSet 객체
	 * @param onlineCtx
	 *            요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchIssueProd(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		Log log = getLog(onlineCtx);
		try {

			DISSUEPROD001 du = (DISSUEPROD001) lookupDataUnit(DISSUEPROD001.class);
			int count = du.dSearchIssueCnt(requestData, onlineCtx).getRecordSet("COUNT").getRecord(0).getInt("COUNT");
			log.debug("<이달의상품조회> 전체건수 = " + count);

			responseData = du.dSearchIssue(requestData, onlineCtx);
			responseData.setOkResultMessage("PSNM-I000", null);

			responseData.getRecordSet("grid").setPageNo(requestData.getIntField("page"));
			responseData.getRecordSet("grid").setRecordCountPerPage(requestData.getIntField("page_size"));
			responseData.getRecordSet("grid").setTotalRecordCount(count);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}

		return responseData;
	}

	/**
	 * 이달의 상품 정보를 상세조회하는 메소드
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-08 09:17:27
	 * 
	 * @param requestData
	 *            요청정보 DataSet 객체
	 * @param onlineCtx
	 *            요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fDetailIssueProd(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		Log log = getLog(onlineCtx);
		try {

			DISSUEPROD001 du = (DISSUEPROD001) lookupDataUnit(DISSUEPROD001.class);

			if (PsnmStringUtil.isEmpty(requestData.getField("ISS_ID")) == false) {
				
				responseData.putFieldMap(du.dDetailIssueProd(requestData, onlineCtx).getFieldMap());
				
				// 첨부파일 조회
				IDataSet fileDataset = callSharedBizComponentByDirect("com.SHARE", "fSearchFileMapping", requestData, onlineCtx);
				responseData.putRecordSet("gridfile", fileDataset.getRecordSet("ds"));
				
				//열람자 등록
//				du.dInsertIssueReadr(requestData, onlineCtx);
				callSharedBizComponentByDirect("com.SHARE", "fMergeReadrMgmt", requestData, onlineCtx);
				
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
	 * 이달의 상품 정보를 추가하는 메소드
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-09 10:50:50
	 * 
	 * @param requestData
	 *            요청정보 DataSet 객체
	 * @param onlineCtx
	 *            요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fInsertIssueProd(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

		Log log = getLog(onlineCtx);

		DISSUEPROD001 du = (DISSUEPROD001) lookupDataUnit(DISSUEPROD001.class);

		requestData.putField("ISS_ID", du.dSearchIssueSeq(requestData, onlineCtx).getRecordSet("ISS_ID").getRecord(0).get("ISS_ID"));
		
		du.dInsertIssue(requestData, onlineCtx);

		return responseData;
	}

	/**
	 * 
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-09 10:52:24
	 * 
	 * @param requestData
	 *            요청정보 DataSet 객체
	 * @param onlineCtx
	 *            요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fUpdateIssueProd(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

		Log log = getLog(onlineCtx);

		DISSUEPROD001 du = (DISSUEPROD001) lookupDataUnit(DISSUEPROD001.class);
		
		du.dInsertIssue(requestData, onlineCtx);

		return responseData;
	}

	/**
	 * 이달의 상품 정보를 삭제하는 메소드
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-09 15:20:04
	 * 
	 * @param requestData
	 *            요청정보 DataSet 객체
	 * @param onlineCtx
	 *            요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fDeleteIssueProd(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

		try {

			DISSUEPROD001 du = (DISSUEPROD001) lookupDataUnit(DISSUEPROD001.class);

			du.dDeleteIssue(requestData, onlineCtx);

			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}

		return responseData;
	}

}
