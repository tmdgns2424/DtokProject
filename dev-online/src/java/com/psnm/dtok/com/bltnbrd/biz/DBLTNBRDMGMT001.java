package com.psnm.dtok.com.bltnbrd.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecord;
import nexcore.framework.core.data.IRecordSet;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: DBLTNBRDMGMT001</li>
 * <li>설  명 : 게시판관리</li>
 * <li>작성일 : 2014-12-26 13:25:41</li>
 * <li>작성자 : 안종광 (rhkd)</li>
 * </ul>
 *
 * @author 안종광 (rhkd)
 */
public class DBLTNBRDMGMT001 extends nexcore.framework.coreext.pojo.biz.DataUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public DBLTNBRDMGMT001(){
		super();
	}

	/**
	 * 유형별 게시판 목록 조회
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-26 13:45:05
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchBltnBrdByType(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		IRecordSet rs = dbSelect("DBLTNBRDMGMT001.dSearchBltnBrdByType", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
		return responseData;
	}

	/**
	 * 지정된 게시판 포함 하위 게시판목록 조회(TREE형)
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-26 15:11:12
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchBltnBrd(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		IRecordSet rs = dbSelect("DBLTNBRDMGMT001.dSearchBltnBrd", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
		return responseData;
	}

	/**
	 * 게시판 정보 1건 조회
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-26 15:56:46
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("unchecked")
	public IDataSet dSearchBltnBrdByPk(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		IRecord record = dbSelectSingle("DBLTNBRDMGMT001.dSearchBltnBrdByPk", requestData.getFieldMap(), onlineCtx);
		responseData.putFieldMap(record);
		return responseData;
	}

	/**
	 * [DM]게시판ID채번
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-01-28 10:36:06
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	@SuppressWarnings("unchecked")
	public IDataSet dSearchNextBltnBrdId(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		IRecord record = dbSelectSingle("DBLTNBRDMGMT001.dSearchNextBltnBrdId", requestData.getFieldMap(), onlineCtx);
		responseData.putFieldMap(record); //BLTN_BRD_ID
		return responseData;
	}

	/**
	 * [DM]게시판등록
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-01-28 10:36:38
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertBltnBrd(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		int result = dbInsert("DBLTNBRDMGMT001.dInsertBltnBrd", requestData.getFieldMap(), onlineCtx);
		responseData.putField("result", result);
		return responseData;
	}

	/**
	 * [DM]게시판수정
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-01-28 10:36:58
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dUpdateBltnBrd(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		int result = dbUpdate("DBLTNBRDMGMT001.dUpdateBltnBrd", requestData.getFieldMap(), onlineCtx);
		responseData.putField("result", result);
		return responseData;
	}

	/**
	 * [DM]게시판삭제
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-01-28 10:37:18
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dDeleteBltnBrd(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		int result = dbDelete("DBLTNBRDMGMT001.dDeleteBltnBrd", requestData.getFieldMap(), onlineCtx);
		responseData.putField("result", result);
		return responseData;
	}

	/**
	 * [DM]게시판담당자목록
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-26 13:25:41
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchBltnBrdChrgr2(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		IRecordSet rs = dbSelect("DBLTNBRDMGMT001.dSearchBltnBrdChrgr2", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
		return responseData;
	}

	/**
	 * [DM]하위게시판목록
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-02-16 10:18:02
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchBltnBrdBySup(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		IRecordSet rs = dbSelect("DBLTNBRDMGMT001.dSearchBltnBrdBySup", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
		return responseData;
	}

	/**
	 * [DM]게시판담당자등록
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-02-16 17:03:47
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertBltnBrdChrgr(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		int result = dbUpdate("DBLTNBRDMGMT001.dInsertBltnBrdChrgr", requestData.getFieldMap(), onlineCtx);
		responseData.putField("result", result);
		return responseData;
	}

	/**
	 * [DM]게시판담당자삭제
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-02-16 17:04:08
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dDeleteBltnBrdChrgr(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		int result = dbUpdate("DBLTNBRDMGMT001.dDeleteBltnBrdChrgr", requestData.getFieldMap(), onlineCtx);
		responseData.putField("result", result);
		return responseData;
	}

	/**
	 *
	 *
	 * @author 채수윤 (chesuyun)
	 * @since 2015-03-19 14:00:16
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dDeleteBltCont(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
		int result = dbUpdate("DBLTNBRDMGMT001.dDeleteBltCont", requestData.getFieldMap(), onlineCtx);
		responseData.putField("result", result);
	
	    return responseData;
	}
  
}
