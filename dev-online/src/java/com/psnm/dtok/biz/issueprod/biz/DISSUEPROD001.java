package com.psnm.dtok.biz.issueprod.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;

/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/업무</li>
 * <li>단위업무명: [DU]이달의상품</li>
 * <li>설 명 :</li>
 * <li>작성일 : 2015-01-08 09:19:02</li>
 * <li>작성자 : 이승훈2 (gunyoung)</li>
 * </ul>
 * 
 * @author 이승훈2 (gunyoung)
 */
public class DISSUEPROD001 extends nexcore.framework.coreext.pojo.biz.DataUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public DISSUEPROD001() {
		super();
	}

	/**
	 * 이달의 상품 검색을 위하여 관련 테이블(DSM_ISSUE, DSM_ISSUE_READR)을 조인하여 이달의 상품 객체를 map객체로
	 * 가져오는 메소드
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-08 09:19:27
	 * 
	 * @param requestData
	 *            요청정보 DataSet 객체
	 * @param onlineCtx
	 *            요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchIssue(IDataSet requestData, IOnlineContext onlineCtx) {
		
		IDataSet responseData = new DataSet();

		IRecordSet rs = dbSelect("DISSUEPROD001.dSearchIssue", requestData.getFieldMap(), onlineCtx);

		responseData.putRecordSet("grid", rs);

		// 처리 결과값을 responseData에 넣어서 리턴하십시요

		return responseData;
	}

	/**
	 * 이달의 상품 건수를 조회하는 메소드
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-08 09:19:02
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchIssueCnt(IDataSet requestData, IOnlineContext onlineCtx) {
		
		IDataSet responseData = new DataSet();

		IRecordSet rs = dbSelect("DISSUEPROD001.dSearchIssueCnt", requestData.getFieldMap(), onlineCtx);

		responseData.putRecordSet("COUNT", rs);

		return responseData;
	}

	/**
	 * 이달의 상품 정보를 상세 조회 하는 메소드
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-08 09:19:02
	 * 
	 * @param requestData
	 *            요청정보 DataSet 객체
	 * @param onlineCtx
	 *            요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dDetailIssueProd(IDataSet requestData, IOnlineContext onlineCtx) {

		IDataSet responseData = new DataSet();

		responseData.putFieldMap(dbSelectSingle("DISSUEPROD001.dDetailIssue", requestData.getFieldMap(), onlineCtx));

		return responseData;
	}

	/**
	 * 이달의 상품 정보를 추가하는 메소드
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-09 11:01:17
	 * 
	 * @param requestData
	 *            요청정보 DataSet 객체
	 * @param onlineCtx
	 *            요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertIssue(IDataSet requestData, IOnlineContext onlineCtx) {
		
		IDataSet responseData = new DataSet();

		dbInsert("DISSUEPROD001.dInsertIssue", requestData.getFieldMap(), onlineCtx);

		return responseData;
	}

	/**
	 * 이달의 상품 정보를 수정하는 메소드
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-09 11:09:02
	 * 
	 * @param requestData
	 *            요청정보 DataSet 객체
	 * @param onlineCtx
	 *            요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dUpdateIssue(IDataSet requestData, IOnlineContext onlineCtx) {
		
		IDataSet responseData = new DataSet();

		dbInsert("DISSUEPROD001.dInsertIssue", requestData.getFieldMap(), onlineCtx);

		return responseData;
	}

	/**
	 * 이달의 상품 정보 추가 시 시퀀스 채번
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-09 11:44:12
	 * 
	 * @param requestData
	 *            요청정보 DataSet 객체
	 * @param onlineCtx
	 *            요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchIssueSeq(IDataSet requestData, IOnlineContext onlineCtx) {
		
		IDataSet responseData = new DataSet();

		IRecordSet rs = dbSelect("DISSUEPROD001.dSearchIssueSeq", requestData.getFieldMap(), onlineCtx);

		responseData.putRecordSet("ISS_ID", rs);

		return responseData;
	}

	/**
	 * 이달의 상품 정보를 삭제하는 메소드
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-09 15:20:31
	 * 
	 * @param requestData
	 *            요청정보 DataSet 객체
	 * @param onlineCtx
	 *            요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dDeleteIssue(IDataSet requestData, IOnlineContext onlineCtx) {

		IDataSet responseData = new DataSet();

		dbDelete("DISSUEPROD001.dDeleteIssue", requestData.getFieldMap(), onlineCtx);

		return responseData;
	}

	/**
	 * 
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-12 14:43:57
	 * 
	 * @param requestData
	 *            요청정보 DataSet 객체
	 * @param onlineCtx
	 *            요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertIssueReadr(IDataSet requestData, IOnlineContext onlineCtx) {

		IDataSet responseData = new DataSet();
		
		dbInsert("DISSUEPROD001.dInsertIssueReadr", requestData.getFieldMap(), onlineCtx);

		return responseData;
	}

}
