package com.psnm.dtok.com.auth.biz;

import java.util.Map;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordHeader;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.exception.BizRuntimeException;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: FAUTHGRP</li>
 * <li>설  명 : 권한그룹관리</li>
 * <li>작성일 : 2014-12-16 09:45:10</li>
 * <li>작성자 : 안종광 (rhkd)</li>
 * </ul>
 *
 * @author 안종광 (rhkd)
 */
public class FAUTHGRP extends nexcore.framework.coreext.pojo.biz.FunctionUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public FAUTHGRP(){
		super();
	}

	/**
	 * 권한그룹조회
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-16 09:45:48
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchAuthGrp(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		Log log = getLog(onlineCtx);

		if ( log.isDebugEnabled() ) {
			log.debug("<<권한그룹조회>> 입력파라미터 : " + requestData.getFieldMap());
		}

	    try {
	    	DAUTHGRP du = (DAUTHGRP) lookupDataUnit(DAUTHGRP.class);
		    IRecordSet list = du.dSearchAuthGrp(requestData, onlineCtx).getRecordSet("ds");
		    responseData.putRecordSet("gridauthgrp", list);
			if (log.isDebugEnabled()) {
				log.debug("<<권한그룹조회>> 목록 검색건수 = " + (null==list ? -1 : list.getRecordCount()));
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
	 * 권한그룹적용직무조회
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-16 09:46:30
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchAuthGrpAplyDuty(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		Log log = getLog(onlineCtx);

		if ( log.isDebugEnabled() ) {
			log.debug("<<권한그룹적용직무조회>> 입력파라미터 : " + requestData.getFieldMap());
		}
		
/*		String[] userTypList = {
				"1",
				"3",
				"4"
		};*/
		String[] DUTY_USER_TYPE_LIST = { "1", "3", "4" };

	    try {
	    	DAUTHGRP du = (DAUTHGRP) lookupDataUnit(DAUTHGRP.class);
		    IRecordSet list = du.dSearchAuthGrpAplyDuty(requestData, onlineCtx).getRecordSet("ds");
		    responseData.putRecordSet("gridauthgrpaplyduty", list);
			if (log.isDebugEnabled()) {
				log.debug("<<권한그룹적용직무조회>> 목록 검색건수 = " + (null==list ? -1 : list.getRecordCount()));
			}
			String rsId = list.getId();
			int headCount = list.getHeaderCount();
			String[] headerNames = new String[headCount];
			
			for(int i=0; i<headCount; i++) {
				IRecordHeader rh = list.getHeader(i);
				headerNames[i] = rh.getName();
				log.debug("<<권한그룹적용직무조회>> 헤더[" + i + "] = '" + headerNames[i] + "'");
			}
			log.debug("<<권한그룹적용직무조회>> rsId = '" + rsId + "'");

			for(int i=0; i<DUTY_USER_TYPE_LIST.length; i++) {
				IRecordSet alist = list.clone(rsId, headerNames);
				for(int x=alist.getRecordCount()-1; x>=0; x--) {
					String userTyp = alist.get(x, "USER_TYP");
					if ( !StringUtils.equals(DUTY_USER_TYPE_LIST[i], userTyp) ) {
						alist.removeRecord(x);
					}
				}
				responseData.putRecordSet("gridauthgrpaplyduty" + DUTY_USER_TYPE_LIST[i], alist);
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
	 * 권한그룹저장(1건 등록 or 수정)
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-16 09:45:10
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSaveAuthGrp(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		Log log = getLog(onlineCtx);
		//IUserInfo iUserInfo = onlineCtx.getUserInfo();

		try {
			DAUTHGRP du = (DAUTHGRP) lookupDataUnit(DAUTHGRP.class);
			log.debug("<<권한그룹저장>> 저장할정보 : " + requestData.getFieldMap());
			du.dMergeAuthGrp(requestData, onlineCtx);
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
	 * 권한그룹적용직무저장(등록,삭제)
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-16 09:47:56
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSaveAuthGrpAplyDuty(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		Log log = getLog(onlineCtx);
		//IUserInfo iUserInfo = onlineCtx.getUserInfo();

		String[] DUTY_USER_TYPE_LIST = { "1", "3", "4" };

		try {
			DAUTHGRP du = (DAUTHGRP) lookupDataUnit(DAUTHGRP.class);

			String authGrpId = requestData.getField("AUTH_GRP_ID");

			//#1. 적용직무 정보 저장
			for(int i=0; i<DUTY_USER_TYPE_LIST.length; i++) {
				String rsid = "gridauthgrpaplyduty" + DUTY_USER_TYPE_LIST[i]; //gridauthgrpaplyduty1, gridauthgrpaplyduty3, ..

				IRecordSet dutylist = requestData.getRecordSet( rsid );
				int dutylistCount = null==dutylist ? 0 : dutylist.getRecordCount();

				if ( dutylistCount<1 ) {
					log.info("<<권한그룹직무적용저장>> 직무(" + rsid + ")의 변경된 정보는 없음.");
					continue;
				}

				for(int k=0; k<dutylistCount; k++) {
					Map<String, Object> record = dutylist.getRecordMap(k);
					if (log.isDebugEnabled()) {
						log.debug("<<권한그룹직무적용저장>> 저장할 직무정보 : " + record);
					}

					IDataSet dsParam = new DataSet();
					dsParam.putFieldMap( record );
					dsParam.putField("AUTH_GRP_ID", authGrpId); //권한그룹ID

					String flag = (String)record.get("FLAG");
					String isApplied = (String)record.get("IS_APPLIED");

					if ( StringUtils.equals(flag, "U") ) {
						//삭제후 등록
						du.dDeleteAuthGrpAplyDuty(dsParam, onlineCtx); //삭제
						if ( StringUtils.equals(isApplied, "1") ) {
							du.dInsertAuthGrpAplyDuty(dsParam, onlineCtx); //등록
						}
					}
				}
			}

			//#2. 권한그룹 적용직무데이터를 재조회하여 반환
			responseData = this.fSearchAuthGrpAplyDuty(requestData, onlineCtx); //AUTH_GRP_ID이 필드에 있음
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
	 * 권한그룹삭제(여러건 삭제)
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-16 09:45:10
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fDeleteAuthGrp(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		Log log = getLog(onlineCtx);
		//IUserInfo iUserInfo = onlineCtx.getUserInfo();

		try {
			DAUTHGRP du = (DAUTHGRP) lookupDataUnit(DAUTHGRP.class);

			IRecordSet list = requestData.getRecordSet("gridauthgrp");
			int listCount = null==list ? 0 : list.getRecordCount();

			for(int i=0; i<listCount; i++) {
				Map<String, Object> record = list.getRecordMap(i);
				if (log.isDebugEnabled()) {
					log.debug("<<권한그룹삭제>> 삭제할정보 : " + record);
				}

				IDataSet dsParam = new DataSet();
				dsParam.putFieldMap( record );

				String flag = (String)record.get("FLAG");

				if ( StringUtils.equals(flag, "D") ) { //삭제
					du.dDeleteAuthGrpAplyDuty(dsParam, onlineCtx); //권한그룹적용직무도 삭제함
					du.dDeleteAuthGrp(dsParam, onlineCtx);
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
