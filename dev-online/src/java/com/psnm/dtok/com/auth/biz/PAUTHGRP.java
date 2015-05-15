package com.psnm.dtok.com.auth.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.exception.BizRuntimeException;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: PAUTHGRP</li>
 * <li>설  명 : 권한그룹관리</li>
 * <li>작성일 : 2014-12-16 09:59:04</li>
 * <li>작성자 : 안종광 (rhkd)</li>
 * </ul>
 *
 * @author 안종광 (rhkd)
 */
public class PAUTHGRP extends nexcore.framework.coreext.pojo.biz.ProcessUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public PAUTHGRP(){
		super();
	}

	/**
	 * 권한그룹조회
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-16 09:59:33
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchAuthGrp(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		try {
			FAUTHGRP fu = (FAUTHGRP) lookupFunctionUnit(FAUTHGRP.class);
			responseData = fu.fSearchAuthGrp(requestData, onlineCtx);
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
	 * 권한그룹적용직무조회
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-16 10:00:03
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchAuthGrpAplyDuty(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = null;
		try {
			FAUTHGRP fu = (FAUTHGRP) lookupFunctionUnit(FAUTHGRP.class);
			responseData = fu.fSearchAuthGrpAplyDuty(requestData, onlineCtx);
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
	 * 권한그룹저장
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-16 10:00:58
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSaveAuthGrp(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = null;
		try {
			FAUTHGRP fu = (FAUTHGRP) lookupFunctionUnit(FAUTHGRP.class);
			responseData = fu.fSaveAuthGrp(requestData, onlineCtx); //저장(1건 등록|수정)
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
	 * 권한그룹적용직무저장
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-16 10:01:37
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSaveAuthGrpAplyDuty(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = null;
		try {
			FAUTHGRP fu = (FAUTHGRP) lookupFunctionUnit(FAUTHGRP.class);
			responseData = fu.fSaveAuthGrpAplyDuty(requestData, onlineCtx); //저장(등록,수정,삭제)
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
	 * 권한그룹삭제
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-24 10:51:03
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pDeleteAuthGrp(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = null;
		try {
			FAUTHGRP fu = (FAUTHGRP) lookupFunctionUnit(FAUTHGRP.class);
			responseData = fu.fDeleteAuthGrp(requestData, onlineCtx); //저장(1건 등록|수정)
		}
		catch (BizRuntimeException be) {
			throw be;
		}
		catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000",e);
		}
	    return responseData;
	}
  
}
