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
 * <li>단위업무명: FUSERMENUAUTH001</li>
 * <li>설  명 : [FU]사용자메뉴권한관리</li>
 * <li>작성일 : 2015-01-26 17:04:19</li>
 * <li>작성자 : 안종광 (rhkd)</li>
 * </ul>
 *
 * @author 안종광 (rhkd)
 */
public class FUSERMENUAUTH001 extends nexcore.framework.coreext.pojo.biz.FunctionUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public FUSERMENUAUTH001(){
		super();
	}

	/**
	 * [FM]사용자메뉴권한조회
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-01-26 17:04:19
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchUserMenuAuth(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		Log log = getLog(onlineCtx);

		if ( log.isDebugEnabled() ) {
			log.debug("<<사용자메뉴권한조회>> 입력파라미터 : " + requestData.getFieldMap());
		}

	    try {
	    	//#1. 지정된 사용자의 메뉴목록 조회
		    //DMENU001 duMENU = (DMENU001) lookupDataUnit(DMENU001.class);
	    	DUSERMENUAUTH001 du = (DUSERMENUAUTH001) lookupDataUnit(DUSERMENUAUTH001.class);
			IRecordSet gridusermenu = du.dSearchMenuTree(requestData, onlineCtx).getRecordSet("ds");
			responseData.putRecordSet("gridusermenu", gridusermenu);

			//#2. 사용자메뉴권한조회
	    	//DUSERMENUAUTH001 du = (DUSERMENUAUTH001) lookupDataUnit(DUSERMENUAUTH001.class);
		    IRecordSet gridusermenuauth = du.dSearchUserMenuAuth(requestData, onlineCtx).getRecordSet("ds");
		    responseData.putRecordSet("gridusermenuauth", gridusermenuauth);
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
	 * [FM]사용자메뉴권한저장
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-01-28 16:35:42
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSaveUserMenuAuth(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		Log log = getLog(onlineCtx);

		if ( log.isDebugEnabled() ) {
			log.debug("<<사용자메뉴권한저장>> 입력파라미터 : " + requestData.getFieldMap());
		}

	    try {
	    	//#1. 지정된 사용자의 메뉴목록 조회
	    	DUSERMENUAUTH001 du = (DUSERMENUAUTH001) lookupDataUnit(DUSERMENUAUTH001.class);

			IRecordSet list = requestData.getRecordSet("gridusermenuauth");
			int listCount = null==list ? 0 : list.getRecordCount();

			//2. 첨부파일 저장
			for(int i=0; i<listCount; i++) {
				Map<String, Object> record = list.getRecordMap(i);
				if (log.isDebugEnabled()) {
					log.debug("<<사용자메뉴권한저장>> 저장할 레코드 : " + record);
				}

				IDataSet dsParam = new DataSet();
				dsParam.putFieldMap( record );
				dsParam.putField("USER_ID", requestData.getField("USER_ID"));

				String flag = (String)record.get("FLAG");

				if ( StringUtils.equals(flag, "D") ) { //삭제
					du.dDeleteUserMenuAuth(dsParam, onlineCtx);
				}
				else {
					du.dMergeUserMenuAuth(dsParam, onlineCtx);
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
  
}
