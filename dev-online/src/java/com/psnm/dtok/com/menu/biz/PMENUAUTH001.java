package com.psnm.dtok.com.menu.biz;

import java.io.UnsupportedEncodingException;
import java.util.Map;

import org.apache.commons.logging.Log;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecord;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.data.IResultMessage;
import nexcore.framework.core.data.ResultMessage;
import nexcore.framework.core.exception.BizRuntimeException;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: PMENUAUTH001</li>
 * <li>설  명 : 메뉴권한관리</li>
 * <li>작성일 : 2014-12-12 10:09:26</li>
 * <li>작성자 : 안종광 (rhkd)</li>
 * </ul>
 *
 * @author 안종광 (rhkd)
 */
public class PMENUAUTH001 extends nexcore.framework.coreext.pojo.biz.ProcessUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public PMENUAUTH001() {
		super();
	}

	/**
	 * 메뉴권한조회
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-12 10:09:26
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchMenuAuth(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

	    Log log = getLog(onlineCtx);
		if (log.isDebugEnabled()) {
			Map<String, Object> param = requestData.getFieldMap();
			log.debug("<메뉴권한조회> 입력데이터 : " + param);
		}

		try {
			//UserInfo userInfo = (UserInfo)onlineCtx.getUserInfo();

			FMENUAUTH001 fu = (FMENUAUTH001) lookupFunctionUnit(FMENUAUTH001.class);

			IRecordSet list = fu.fSearchMenuAuth(requestData, onlineCtx).getRecordSet("ds");
			responseData.putRecordSet("gridmenuauth", list); //[alopex] 그리드 데이터는 dataSet.recordSets 하위에 그리드 아이디를 키로 위치

			log.debug("<메뉴권한조회> 검색건수 = " + (null==list ? -1 : list.getRecordCount()));

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
	 * 메뉴권한저장(등록, 삭제)
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-12 10:11:16
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSaveMenuAuth(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		try {
			FMENUAUTH001 fu = (FMENUAUTH001) lookupFunctionUnit(FMENUAUTH001.class);
			fu.fSaveMenuAuth(requestData, onlineCtx); //저장(등록,삭제)
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
  
}
