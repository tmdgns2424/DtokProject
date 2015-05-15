package com.psnm.dtok.com.menu.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecord;
import nexcore.framework.core.data.IRecordSet;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: DMENU001</li>
 * <li>설  명 : 메뉴관리 DU</li>
 * <li>작성일 : 2014-12-09 17:02:41</li>
 * <li>작성자 : 안종광 (rhkd)</li>
 * </ul>
 *
 * @author 안종광 (rhkd)
 */
public class DMENU001 extends nexcore.framework.coreext.pojo.biz.DataUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public DMENU001(){
		super();
	}

	/**
	 * 메뉴조회(TREE)
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-09 17:03:42
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchMenu(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		IRecordSet rs = dbSelect("DMENU001.dSearchMenu", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
		return responseData;
	}

	/**
	 * 메뉴등록
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-09 17:05:01
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertMenu(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		int result = dbInsert("DMENU001.dInsertMenu", requestData.getFieldMap(), onlineCtx);
		responseData.putField("result", result);
		return responseData;
	}

	/**
	 * 메뉴갱신
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-09 17:05:21
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dUpdateMenu(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		int result = dbUpdate("DMENU001.dUpdateMenu", requestData.getFieldMap(), onlineCtx);
		responseData.putField("result", result);
		return responseData;
	}

	/**
	 * 메뉴삭제
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-09 17:05:41
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dDeleteMenu(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		int result = dbDelete("DMENU001.dDeleteMenu", requestData.getFieldMap(), onlineCtx);
		responseData.putField("result", result);
		return responseData;
	}

	/**
	 * 상위메뉴ID 조건으로 바로 하위 메뉴 목록을 조회
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-10 18:13:35
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchMenuBySup(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		IRecordSet rs = dbSelect("DMENU001.dSearchMenuBySup", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
		return responseData;
	}

	/**
	 * [DM]메뉴찾기(팝업)
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-01-28 15:19:09
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchMenuPop(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		IRecordSet rs = dbSelect("DMENU001.dSearchMenuPop", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
		return responseData;
	}

	/**
	 * [DM]메뉴조회(1건)
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-02-12 10:32:51
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchMenuByPk(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		IRecord r = dbSelectSingle("DMENU001.dSearchMenuByPk", requestData.getFieldMap(), onlineCtx);
		responseData.putFieldMap(r);
		return responseData;
	}
  
}
