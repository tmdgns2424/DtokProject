package com.psnm.dtok.com.bltnbrd.biz;

import java.util.Map;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.exception.BizRuntimeException;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: FBLTNBRDMGMT001</li>
 * <li>설  명 : 게시판관리</li>
 * <li>작성일 : 2014-12-26 13:26:16</li>
 * <li>작성자 : 안종광 (rhkd)</li>
 * </ul>
 *
 * @author 안종광 (rhkd)
 */
public class FBLTNBRDMGMT001 extends nexcore.framework.coreext.pojo.biz.FunctionUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public FBLTNBRDMGMT001(){
		super();
	}

	/**
	 * 유형별 게시판 목록 조회
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-26 13:46:47
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchBltnBrdByType(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		Log log = getLog(onlineCtx);

		if ( log.isDebugEnabled() ) {
			log.debug("<<유형별게시판목록>> 입력파라미터 : " + requestData.getFieldMap());
		}

	    try {
	    	DBLTNBRDMGMT001 du = (DBLTNBRDMGMT001) lookupDataUnit(DBLTNBRDMGMT001.class);

		    IRecordSet list = du.dSearchBltnBrdByType(requestData, onlineCtx).getRecordSet("ds"); //목록 조회

			responseData.putRecordSet("gridbltnbrdtype", list);

			if (log.isDebugEnabled()) {
				log.debug("<<유형별게시판목록>> 목록 검색건수 = " + (null==list ? -1 : list.getRecordCount()));
			}
		}
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	    responseData.setOkResultMessage("PSNM-I000", null);
	    return responseData;
	}

	/**
	 * 지정된 게시판 포함 하위 게시판목록 조회(TREE형)
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-26 13:26:16
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchBltnBrd(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		Log log = getLog(onlineCtx);

		String bltnBrdId = requestData.getField("TOP_BLTN_BRD_ID");
		requestData.putField("BLTN_BRD_ID", bltnBrdId);

		if ( log.isDebugEnabled() ) {
			log.debug("<<게시판목록TREE>> 입력파라미터 : " + requestData.getFieldMap());
		}

	    try {
	    	DBLTNBRDMGMT001 du = (DBLTNBRDMGMT001) lookupDataUnit(DBLTNBRDMGMT001.class);

		    IRecordSet list = du.dSearchBltnBrd(requestData, onlineCtx).getRecordSet("ds"); //목록 조회

			responseData.putRecordSet("gridbltnbrd", list);

			if (log.isDebugEnabled()) {
				log.debug("<<게시판목록TREE>> 목록 검색건수 = " + (null==list ? -1 : list.getRecordCount()));
			}
		}
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	    responseData.setOkResultMessage("PSNM-I000", null);
	    return responseData;
	}

	/**
	 * 게시판 정보 1건 조회
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-26 16:02:23
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchBltnBrdByPk(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		Log log = getLog(onlineCtx);

		if ( log.isDebugEnabled() ) {
			log.debug("<<게시판정보1>> 입력파라미터 : " + requestData.getFieldMap());
		}

	    try {
	    	DBLTNBRDMGMT001 du = (DBLTNBRDMGMT001) lookupDataUnit(DBLTNBRDMGMT001.class);

	    	//1. 게시판정보(필드맵)
	    	responseData = du.dSearchBltnBrdByPk(requestData, onlineCtx);

	    	//2. 게시판담당자목록
	    	IRecordSet gridchrgr = du.dSearchBltnBrdChrgr2(requestData, onlineCtx).getRecordSet("ds");
	    	responseData.putRecordSet("gridchrgr", gridchrgr);
		}
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	    responseData.setOkResultMessage("PSNM-I000", null);
	    return responseData;
	}

	/**
	 * [FM]게시판저장
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-01-28 10:38:13
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSaveBltnBrd(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		Log log = getLog(onlineCtx);
		//IUserInfo iUserInfo = onlineCtx.getUserInfo();

		try {
			DBLTNBRDMGMT001 du = (DBLTNBRDMGMT001) lookupDataUnit(DBLTNBRDMGMT001.class);

			//1. 게시판 저장
			IRecordSet list = requestData.getRecordSet("gridbltnbrd");
			int listCount = null==list ? 0 : list.getRecordCount();

			for(int i=0; i<listCount; i++) {
				Map<String, Object> record = list.getRecordMap(i);
				if (log.isDebugEnabled()) {
					log.debug("<<게시판저장>> 저장할레코드 : " + record);
				}

				IDataSet dsParam = new DataSet();
				dsParam.putFieldMap( record );

				String flag = (String)record.get("FLAG");

				if ( StringUtils.equals(flag, "I") ) { //등록
					IDataSet dsTmp = du.dSearchNextBltnBrdId(requestData, onlineCtx); //게시판ID 채번
					dsParam.putField("BLTN_BRD_ID", dsTmp.getField("BLTN_BRD_ID"));
					du.dInsertBltnBrd(dsParam, onlineCtx);
				}
				else if ( StringUtils.equals(flag, "U") ) { //갱신
					du.dUpdateBltnBrd(dsParam, onlineCtx);
				}
				else if ( StringUtils.equals(flag, "D") ) { //삭제
					du.dDeleteBltnBrd(dsParam, onlineCtx);
					du.dDeleteBltnBrdChrgr(dsParam, onlineCtx);
					// 2015.03.19 해당 게시판의 게시글 전체 삭제 로직 추가
					du.dDeleteBltCont(dsParam, onlineCtx);
				}
				else {
					log.warn("<<게시판저장>> 알수없는플래그 : [" + flag + "] 레코드정보 : " + record);
				}
			}

			//2. 게시판 담당자 저장
			IRecordSet gridchrgr = requestData.getRecordSet("gridchrgr");
			int chrgrCount = null==gridchrgr ? 0 : gridchrgr.getRecordCount();

			for(int k=0; k<chrgrCount; k++) {
				Map<String, Object> record = gridchrgr.getRecordMap(k);
				if (log.isDebugEnabled()) {
					log.debug("<<게시판저장>> 담당자정보 : " + record);
				}

				IDataSet dsParam2 = new DataSet();
				dsParam2.putFieldMap( record );

				String flag = (String)record.get("FLAG");

				if ( StringUtils.equals(flag, "I") ) { //담당자등록
					du.dInsertBltnBrdChrgr(dsParam2, onlineCtx);
				}
				else if ( StringUtils.equals(flag, "D") ) { //담당자삭제
					du.dDeleteBltnBrdChrgr(dsParam2, onlineCtx);
				}
				else {
					log.warn("<<게시판저장>> 담당자저장 알수없는플래그 : [" + flag + "] 레코드정보 : " + record);
				}
			}
		}
		catch (BizRuntimeException be) {
			throw be;
		}
		catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
		responseData.setOkResultMessage("PSNM-I000", null);
	    return responseData;
	}

	/**
	 * [FM]게시판담당자목록
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-02-16 09:34:32
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchBltnBrdChrgr(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		Log log = getLog(onlineCtx);

		if ( log.isDebugEnabled() ) {
			log.debug("<<게시판담당자목록>> 입력파라미터 : " + requestData.getFieldMap());
		}

	    try {
	    	DBLTNBRDMGMT001 du = (DBLTNBRDMGMT001) lookupDataUnit(DBLTNBRDMGMT001.class);

	    	IRecordSet gridchrgr = du.dSearchBltnBrdChrgr2(requestData, onlineCtx).getRecordSet("ds");
	    	responseData.putRecordSet("gridchrgr", gridchrgr);
		}
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	    responseData.setOkResultMessage("PSNM-I000", null);
	    return responseData;
	}

	/**
	 * [FM]하위게시판목록
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-02-16 10:18:28
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchBltnBrdBySup(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		Log log = getLog(onlineCtx);

		if ( log.isDebugEnabled() ) {
			log.debug("<<하위게시판목록>> 입력파라미터 : " + requestData.getFieldMap());
		}

	    try {
	    	DBLTNBRDMGMT001 du = (DBLTNBRDMGMT001) lookupDataUnit(DBLTNBRDMGMT001.class);
	    	IRecordSet grid  = du.dSearchBltnBrdBySup(requestData, onlineCtx).getRecordSet("ds");
	    	responseData.putRecordSet("gridbltnbrdsup", grid);
		}
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	    responseData.setOkResultMessage("PSNM-I000", null);
	    return responseData;
	}
  
}
