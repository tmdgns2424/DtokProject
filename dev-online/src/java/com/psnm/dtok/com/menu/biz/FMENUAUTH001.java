package com.psnm.dtok.com.menu.biz;

import java.util.Map;

import org.apache.commons.lang.StringUtils;
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
 * <li>단위업무명: FMENUAUTH001</li>
 * <li>설  명 : 메뉴권한관리</li>
 * <li>작성일 : 2014-12-12 10:09:03</li>
 * <li>작성자 : 안종광 (rhkd)</li>
 * </ul>
 *
 * @author 안종광 (rhkd)
 */
public class FMENUAUTH001 extends nexcore.framework.coreext.pojo.biz.FunctionUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public FMENUAUTH001(){
		super();
	}

	/**
	 * 메뉴권한조회
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-12 10:09:52
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchMenuAuth(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		Log log = getLog(onlineCtx);

		if ( log.isDebugEnabled() ) {
			log.debug("<<메뉴권한조회>> 입력파라미터 : " + requestData.getFieldMap());
		}

	    try {
	    	DMENUAUTH001 du = (DMENUAUTH001) lookupDataUnit(DMENUAUTH001.class);
		    IRecordSet list = du.dSearchMenuAuth(requestData, onlineCtx).getRecordSet("ds");
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
	 * 메뉴권한저장(등록, 삭제)
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-12 10:10:17
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSaveMenuAuth(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		Log log = getLog(onlineCtx);
		//IUserInfo iUserInfo = onlineCtx.getUserInfo();

		try {
			DMENUAUTH001 du = (DMENUAUTH001) lookupDataUnit(DMENUAUTH001.class);

			IRecordSet list = requestData.getRecordSet("gridmenuauth");
			int listCount = null==list ? 0 : list.getRecordCount();

			// 저장
			for(int i=0; i<listCount; i++) {
				//IRecord record = list.getRecord(i);
				Map<String, Object> record = list.getRecordMap(i);
				if (log.isDebugEnabled()) {
					log.debug("<<메뉴권한저장>> 저장할레코드 : " + record);
				}

				IDataSet dsParam = new DataSet();
				dsParam.putFieldMap( record );

				String flag = (String)record.get("FLAG");

				if ( StringUtils.equals(flag, "U") ) { //merge(등록과 갱신)
					du.dMergeMenuAuth(dsParam, onlineCtx);

					try {
						du.dInsertMenuAuthHst(dsParam, onlineCtx);
					}
					catch (Exception e) {
						log.warn("<<메뉴권한저장>> 메뉴권한이력 저장 오류! 저장할레코드 : " + record);
						log.warn("<<메뉴권한저장>> 메뉴권한이력 저장 오류! 오류원인 : " + e.getMessage());
					}
				}
				else {
					log.warn("<<메뉴권한저장>> 알수없는플래그 : [" + flag + "] 레코드정보 : " + record);
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
  
}
