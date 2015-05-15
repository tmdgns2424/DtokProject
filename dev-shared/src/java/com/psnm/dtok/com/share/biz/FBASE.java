package com.psnm.dtok.com.share.biz;

import org.apache.commons.logging.Log;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.exception.BizRuntimeException;
import nexcore.framework.core.util.DateUtils;
import nexcore.framework.core.util.StringUtils;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: FBASE</li>
 * <li>설  명 : 공통 기준정보 조회 기능 클래스</li>
 * <li>작성일 : 2014-12-03 16:15:56</li>
 * <li>작성자 : 안종광 (rhkd)</li>
 * </ul>
 *
 * @author 안종광 (rhkd)
 */
public class FBASE extends nexcore.framework.coreext.pojo.biz.FunctionUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다..
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public FBASE(){
		super();
	}

	/**
	 * 에이전트 정보를 조회(NO페이징, 팝업용)
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-03 16:16:39
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchAgent(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		Log log = getLog(onlineCtx);

		if ( log.isDebugEnabled() ) {
			log.debug("<<에이전트검색1>> 입력파라미터 ::: " + requestData.getFieldMap());
		}

		try {
	    	DBASE du = (DBASE) lookupDataUnit(DBASE.class);

	    	String findtype = requestData.getField("FINDTYPE"); //DEFAULT || ALL

	    	if ( StringUtils.equalsIgnoreCase(findtype, "all") ) {
	    		//상태 등 조건 없이 에이전트 조회
	    	}
	    	else { //디폴트 조회조건
	    		requestData.putField("CONS_MTH",   DateUtils.getCurrentDate("yyyyMM")); ////디폴트 이번달
	    		requestData.putField("USER_ST",    "1"); //디폴트 재직상태
	    		requestData.putField("SCRB_ST_CD", "02"); //02=가입승인, 01=가입요청, 03=가입반려, 04=가입탈퇴(해촉), 05=일시접근제한
	    	}

		    IRecordSet recordSet = du.dSearchAgent(requestData, onlineCtx).getRecordSet("ds");
		    responseData.putRecordSet("ds", recordSet);

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
	 * 회원 팝업 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-15 17:28:47
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchUserPop(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	DBASE du = (DBASE) lookupDataUnit(DBASE.class);
		    IRecordSet recordSet = du.dSearchUserPop(requestData, onlineCtx).getRecordSet("ds");
		    responseData.putRecordSet("ds", recordSet);

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
	 * 본사직원조회(팝업용)
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-29 16:17:36
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchEmpPop(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
	    try {
	    	DBASE du = (DBASE) lookupDataUnit(DBASE.class);
		    IRecordSet recordSet = du.dSearchEmpPop(requestData, onlineCtx).getRecordSet("ds");
		    responseData.putRecordSet("gridemp", recordSet); //'gridemp' 이름으로 화면으로 응답(PU는 패스)
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
	 * [FM]권한그룹목록
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-03 16:15:56
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchAuthGrp(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
	    try {
	    	DBASE du = (DBASE) lookupDataUnit(DBASE.class);
		    IRecordSet recordSet = du.dSearchAuthGrp(requestData, onlineCtx).getRecordSet("ds");
		    responseData.putRecordSet("gridauthgrp", recordSet); //'gridauthgrp' 이름으로 화면으로 응답(PU는 패스)
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
	 * [FM]에이전트조회(회원가입시)
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-03-05 17:28:23
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchAgentNoMember(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		Log log = getLog(onlineCtx);

		if ( log.isDebugEnabled() ) {
			log.debug("<<에이전트검색(회원가입시)>> 입력파라미터 ::: " + requestData.getFieldMap());
		}

		try {
	    	DBASE du = (DBASE) lookupDataUnit(DBASE.class);

	    	String findtype = requestData.getField("FINDTYPE"); //DEFAULT || ALL

	    	if ( StringUtils.equalsIgnoreCase(findtype, "all") ) {
	    		//상태 등 조건 없이 에이전트 조회
	    	}
	    	else { //디폴트 조회조건
	    		requestData.putField("CONS_MTH", DateUtils.getCurrentDate("yyyyMM")); ////디폴트 이번달
	    	}
	    	IRecordSet rs = du.dSearchAgentNoMember(requestData, onlineCtx).getRecordSet("ds");
	    	responseData.putRecordSet("gridagent", rs);
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
	 *
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-03-13 16:14:26
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchAllUserPop(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
		
	    try {
	    	
	    	DBASE du = (DBASE) lookupDataUnit(DBASE.class);
		    IRecordSet recordSet = du.dSearchAllUserPop(requestData, onlineCtx).getRecordSet("ds");
		    responseData.putRecordSet("ds", recordSet);

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
