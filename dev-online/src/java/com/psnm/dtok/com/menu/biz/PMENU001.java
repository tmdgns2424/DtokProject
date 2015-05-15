package com.psnm.dtok.com.menu.biz;

import java.io.UnsupportedEncodingException;
import java.util.Map;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.exception.BizRuntimeException;

import org.apache.commons.logging.Log;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: PMENU001</li>
 * <li>설  명 : 메뉴관리 PU</li>
 * <li>작성일 : 2014-12-09 17:55:24</li>
 * <li>작성자 : 안종광 (rhkd)</li>
 * </ul>
 *
 * @author 안종광 (rhkd)
 */
public class PMENU001 extends nexcore.framework.coreext.pojo.biz.ProcessUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public PMENU001(){
		super();
	}

	/**
	 * 메뉴조회(TREE)
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-09 17:56:10
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchMenu(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

	    Log log = getLog(onlineCtx);
		if (log.isDebugEnabled()) {
			Map<String, Object> param = requestData.getFieldMap();
			log.debug("<메뉴조회PM> 입력데이터 : " + requestData.getFieldMap());
			java.util.Set<String> keys = param.keySet();
			java.util.Iterator<String> iter = keys.iterator();
			while (iter.hasNext()) {
				String key = iter.next();
				String val = (String)param.get(key);
				try {
					log.debug("<메뉴조회PM> 입력param[ " + key + "] : " + java.net.URLDecoder.decode(val, "UTF-8"));
				}
				catch (UnsupportedEncodingException e) {
					log.equals("<메뉴조회PM> (오류) 입력데이터[ " + key + "] : " + val); 
				}
			}
		}

		try {
			//UserInfo userInfo = (UserInfo)onlineCtx.getUserInfo();

			FMENU001 fu = (FMENU001) lookupFunctionUnit(FMENU001.class);

			IRecordSet list = fu.fSearchMenu(requestData, onlineCtx).getRecordSet("ds");
			responseData.putRecordSet("gridmenu", list); //[alopex] 그리드 데이터는 dataSet.recordSets 하위에 그리드 아이디를 키로 위치

			log.debug("<메뉴조회PM> 메뉴목록 검색건수 = " + (null==list ? -1 : list.getRecordCount()));

			responseData.setOkResultMessage("PSNM-I000", null); //PSNM-I000
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
	 * @since 2014-12-10 18:23:18
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchMenuBySup(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

	    Log log = getLog(onlineCtx);
		if (log.isDebugEnabled()) {
			log.debug("<메뉴조회(상위조건)PM> 입력데이터 : " + requestData.getFieldMap());
		}

		try {
			FMENU001 fu = (FMENU001) lookupFunctionUnit(FMENU001.class);

			IRecordSet list = fu.fSearchMenuBySup(requestData, onlineCtx).getRecordSet("ds");
			responseData.putRecordSet("menubysup", list);

			log.debug("<메뉴조회(상위조건)PM> 메뉴목록 검색건수 = " + (null==list ? -1 : list.getRecordCount()));

			responseData.setOkResultMessage("PSNM-I000", null); //PSNM-I000
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
	 * @since 2014-12-11 15:11:11
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSaveMenu(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		try {
			FMENU001 fu = (FMENU001) lookupFunctionUnit(FMENU001.class);
			fu.fSaveMenu(requestData, onlineCtx); //저장(등록,수정,삭제)
			responseData.setOkResultMessage("PSNM-I000", null);
		}
		catch (BizRuntimeException be) {
			throw be;
		}
		catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000",e);
		}
	    return responseData;
	}

	/**
	 * [PM]메뉴찾기(팝업)
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-01-28 15:21:14
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchMenuPop(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = null;
		try {
			FMENU001 fu = (FMENU001) lookupFunctionUnit(FMENU001.class);
			responseData = fu.fSearchMenuPop(requestData, onlineCtx);
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
	 * [PM]메뉴조회(1건)
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-02-12 10:36:19
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchMenuByPk(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = null;
		try {
			FMENU001 fu = (FMENU001) lookupFunctionUnit(FMENU001.class);
			responseData = fu.fSearchMenuByPk(requestData, onlineCtx);
		}
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	    return responseData;
	}

}
