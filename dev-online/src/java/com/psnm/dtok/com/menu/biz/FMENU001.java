package com.psnm.dtok.com.menu.biz;

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
 * <li>단위업무명: FMENU001</li>
 * <li>설  명 : 메뉴관리 FU</li>
 * <li>작성일 : 2014-12-09 17:50:06</li>
 * <li>작성자 : 안종광 (rhkd)</li>
 * </ul>
 *
 * @author 안종광 (rhkd)
 */
public class FMENU001 extends nexcore.framework.coreext.pojo.biz.FunctionUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public FMENU001(){
		super();
	}

	/**
	 * 메뉴조회(TREE)
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-09 17:50:38
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchMenu(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		Log log = getLog(onlineCtx);

		if ( log.isDebugEnabled() ) {
			log.debug("<메뉴조회> 입력파라미터 : " + requestData.getFieldMap());
		}

	    try {
	    	DMENU001 du = (DMENU001) lookupDataUnit(DMENU001.class);
		    IRecordSet list = du.dSearchMenu(requestData, onlineCtx).getRecordSet("ds");
		    responseData.putRecordSet("ds", list);
		    responseData.setOkResultMessage("PSNM-I000", null);
		}
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	    return responseData;
	}

	/**
	 * 상위메뉴ID 조건으로 바로 하위 메뉴 목록을 조회
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-10 18:14:32
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchMenuBySup(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		Log log = getLog(onlineCtx);

		if ( log.isDebugEnabled() ) {
			log.debug("<<메뉴조회(상위조건)>> 입력파라미터 : " + requestData.getFieldMap());
		}

	    try {
	    	DMENU001 du = (DMENU001) lookupDataUnit(DMENU001.class);
		    IRecordSet list = du.dSearchMenuBySup(requestData, onlineCtx).getRecordSet("ds");
		    responseData.putRecordSet("ds", list);
		    responseData.setOkResultMessage("PSNM-I000", null);
		}
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	    return responseData;
	}

	/**
	 * 메뉴정보를 저장(등록,수정,삭제)
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-11 15:10:46
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSaveMenu(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		Log log = getLog(onlineCtx);
		//IUserInfo iUserInfo = onlineCtx.getUserInfo();

		try {
			DMENU001 du = (DMENU001) lookupDataUnit(DMENU001.class);

			IRecordSet list = requestData.getRecordSet("gridmenu");
			int listCount = null==list ? 0 : list.getRecordCount();

			//2. 첨부파일 저장
			for(int i=0; i<listCount; i++) {
				//IRecord record = list.getRecord(i);
				Map<String, Object> record = list.getRecordMap(i);
				if (log.isDebugEnabled()) {
					log.debug("<<메뉴저장>> 저장할레코드 : " + record);
				}

				IDataSet dsParam = new DataSet();
				dsParam.putFieldMap( record );

				String flag = (String)record.get("FLAG");

				if ( StringUtils.equals(flag, "I") ) { //등록
					du.dInsertMenu(dsParam, onlineCtx);
				}
				else if ( StringUtils.equals(flag, "D") ) { //삭제
					du.dDeleteMenu(dsParam, onlineCtx);
				}
				else if ( StringUtils.equals(flag, "U") ) { //갱신
					du.dUpdateMenu(dsParam, onlineCtx);
				}
				else {
					log.warn("<<메뉴저장>> 알수없는플래그 : [" + flag + "] 레코드정보 : " + record);
				}
			}
			responseData.setOkResultMessage("PSNM-I000", null);
		}
		catch (BizRuntimeException be) {
			throw be;
		}
		catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	    return responseData;
	}

	/**
	 * [FM]메뉴찾기(팝업)
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-01-28 15:20:05
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchMenuPop(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		Log log = getLog(onlineCtx);

		if ( log.isDebugEnabled() ) {
			log.debug("<메뉴찾기> 입력파라미터 : " + requestData.getFieldMap());
		}

	    try {
	    	DMENU001 du = (DMENU001) lookupDataUnit(DMENU001.class);
		    IRecordSet list = du.dSearchMenuPop(requestData, onlineCtx).getRecordSet("ds");
		    responseData.putRecordSet("gridmenu", list);
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
	 * [FM]메뉴조회(1건)
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-02-12 10:33:37
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchMenuByPk(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		Log log = getLog(onlineCtx);

		if ( log.isDebugEnabled() ) {
			log.debug("<메뉴조회1건> 입력파라미터 : " + requestData.getFieldMap());
		}

	    try {
	    	DMENU001 du = (DMENU001) lookupDataUnit(DMENU001.class);
	    	responseData = du.dSearchMenuByPk(requestData, onlineCtx); //필드에 값이 있음
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
