package com.psnm.dtok.com.auth.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.exception.BizRuntimeException;

import org.apache.commons.logging.Log;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: FAUTHINFO</li>
 * <li>설  명 : 권한그룹 관련된 각종 정보 조회</li>
 * <li>작성일 : 2014-12-24 16:56:46</li>
 * <li>작성자 : 안종광 (rhkd)</li>
 * </ul>
 *
 * @author 안종광 (rhkd)
 */
public class FAUTHINFO extends nexcore.framework.coreext.pojo.biz.FunctionUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public FAUTHINFO(){
		super();
	}

	/**
	 * 권한그룹 메뉴목록 조회(TREE형식)
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-24 16:57:54
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchAuthMenu(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		Log log = getLog(onlineCtx);

		if ( log.isDebugEnabled() ) {
			log.debug("<<권한그룹메뉴조회>> 입력파라미터 : " + requestData.getFieldMap());
		}

	    try {
	    	DAUTHINFO du = (DAUTHINFO) lookupDataUnit(DAUTHINFO.class);
		    IRecordSet list = du.dSearchAuthMenu(requestData, onlineCtx).getRecordSet("ds");
		    responseData.putRecordSet("gridmenu", list);
			if (log.isDebugEnabled()) {
				log.debug("<<권한그룹메뉴조회>> 목록 검색건수 = " + (null==list ? -1 : list.getRecordCount()));
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
	 * 권한그룹의 사용자 목록조회(P페이징)
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-24 16:58:35
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchAuthUser(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		Log log = getLog(onlineCtx);

		if ( log.isDebugEnabled() ) {
			log.debug("<<권한그룹사용자조회>> 입력파라미터 : " + requestData.getFieldMap());
		}

	    try {
	    	DAUTHINFO du = (DAUTHINFO) lookupDataUnit(DAUTHINFO.class);

		    IRecordSet list = du.dSearchAuthUser(requestData, onlineCtx).getRecordSet("ds"); //목록 조회

		    list.setPageNo(requestData.getIntField("page")); // page는 클라이언트에서 넘어온 값을 그대로 리턴
		    list.setRecordCountPerPage(requestData.getIntField("page_size"));

		    IDataSet ds2 = du.dSearchAuthUserCount(requestData, onlineCtx); //전체 건수 조회
		    list.setTotalRecordCount( ds2.getIntField("CNT") );

			responseData.putRecordSet("griduser", list);

			if (log.isDebugEnabled()) {
				log.debug("<<권한그룹사용자조회>> 목록 검색건수 = " + (null==list ? -1 : list.getRecordCount()));
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
