package com.psnm.dtok.com.bltnbrd.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: DBLTNBRDAUTHMGMT002</li>
 * <li>설  명 : [DU]게시판권한관리CUD</li>
 * <li>작성일 : 2015-01-05 16:44:23</li>
 * <li>작성자 : 안종광 (rhkd)</li>
 * </ul>
 *
 * @author 안종광 (rhkd)
 */
public class DBLTNBRDAUTHMGMT002 extends nexcore.framework.coreext.pojo.biz.DataUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public DBLTNBRDAUTHMGMT002(){
		super();
	}

	/**
	 * [DM]게시판권한갱신(건별)
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-01-06 13:44:11
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dUpdateBrdAuth(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		int result = dbUpdate("DBLTNBRDAUTHMGMT002.dUpdateBrdAuth", requestData.getFieldMap(), onlineCtx);
		responseData.putField("result", result);
		return responseData;
	}

	/**
	 * [DM]게시판권한그룹삭제
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-01-06 15:13:34
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dDeleteBrdAuth(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		int result = dbDelete("DBLTNBRDAUTHMGMT002.dDeleteBrdAuth", requestData.getFieldMap(), onlineCtx);
		responseData.putField("result", result);
		return responseData;
	}

	/**
	 * [DM]게시판권한그룹등록
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-01-06 15:53:12
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertBrdAuth(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		int result = dbInsert("DBLTNBRDAUTHMGMT002.dInsertBrdAuth", requestData.getFieldMap(), onlineCtx);
		responseData.putField("result", result);
		return responseData;
	}

	/**
	 * [DM]게시판권한영업국추가
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-01-07 10:07:36
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertBrdAuthOrg(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		int result = dbInsert("DBLTNBRDAUTHMGMT002.dInsertBrdAuthOrg", requestData.getFieldMap(), onlineCtx);
		responseData.putField("result", result);
		return responseData;
	}

	/**
	 * [DM]게시판권한영업국삭제
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-01-07 10:07:56
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dDeleteBrdAuthOrg(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		int result = dbDelete("DBLTNBRDAUTHMGMT002.dDeleteBrdAuthOrg", requestData.getFieldMap(), onlineCtx);
		responseData.putField("result", result);
		return responseData;
	}

	/**
	 * [DM]게시판권한사용자추가
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-01-07 19:30:57
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertBrdAuthUser(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		int result = dbInsert("DBLTNBRDAUTHMGMT002.dInsertBrdAuthUser", requestData.getFieldMap(), onlineCtx);
		responseData.putField("result", result);
		return responseData;
	}

	/**
	 * [DM]게시판권한사용자삭제
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-01-07 19:31:24
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dDeleteBrdAuthUser(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		int result = dbDelete("DBLTNBRDAUTHMGMT002.dDeleteBrdAuthUser", requestData.getFieldMap(), onlineCtx);
		responseData.putField("result", result);
		return responseData;
	}

	/**
	 * [DM]게시판권한그룹복사저장
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-01-05 16:44:23
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertCopiedBrdAuth(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		int result = dbInsert("DBLTNBRDAUTHMGMT002.dInsertCopiedBrdAuth", requestData.getFieldMap(), onlineCtx);
		responseData.putField("result", result);
		return responseData;
	}

	/**
	 * [DM]게시판권한영업국복사저장
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-03-23 11:44:30
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertCopiedBrdAuthOrg(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		int result = dbInsert("DBLTNBRDAUTHMGMT002.dInsertCopiedBrdAuthOrg", requestData.getFieldMap(), onlineCtx);
		responseData.putField("result", result);
		return responseData;
	}

	/**
	 * [DM]게시판권한사용자복사저장
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-03-23 11:45:03
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertCopiedBrdAuthUser(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		int result = dbInsert("DBLTNBRDAUTHMGMT002.dInsertCopiedBrdAuthUser", requestData.getFieldMap(), onlineCtx);
		responseData.putField("result", result);
		return responseData;
	}
  
}
