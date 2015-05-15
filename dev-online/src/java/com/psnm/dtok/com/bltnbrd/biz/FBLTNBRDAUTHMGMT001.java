package com.psnm.dtok.com.bltnbrd.biz;

import java.util.Map;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.data.user.UserInfo;
import nexcore.framework.core.exception.BizRuntimeException;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: FBLTNBRDAUTHMGMT001</li>
 * <li>설  명 : [FU]게시판권한관리</li>
 * <li>작성일 : 2014-12-31 10:32:51</li>
 * <li>작성자 : 안종광 (rhkd)</li>
 * </ul>
 *
 * @author 안종광 (rhkd)
 */
public class FBLTNBRDAUTHMGMT001 extends nexcore.framework.coreext.pojo.biz.FunctionUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public FBLTNBRDAUTHMGMT001(){
		super();
	}

	/**
	 * [FM] 적용대상권한, 적용권한, 적용대상영업국, 적용영업국 및 회원정보를 조회하여 반환
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-31 10:32:51
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchAuthDeptUser(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		Log log = getLog(onlineCtx);

		if ( log.isDebugEnabled() ) {
			log.debug("<<게시판 권한+영업국+회원>> 입력파라미터 : " + requestData.getFieldMap());
		}

	    try {
	    	DBLTNBRDAUTHMGMT001 du = (DBLTNBRDAUTHMGMT001) lookupDataUnit(DBLTNBRDAUTHMGMT001.class);

	    	//1. 권한그룹
	    	IRecordSet gridauthgrp = du.dSearchBrdAuthGrp(requestData, onlineCtx).getRecordSet("ds"); //
			responseData.putRecordSet("gridauthgrp", gridauthgrp);

	    	//2. 영업국
	    	IRecordSet gridauthorg = du.dSearchBrdAuthOrg(requestData, onlineCtx).getRecordSet("ds"); //
			responseData.putRecordSet("gridauthorg", gridauthorg);

	    	//3. 적용 회원
	    	IRecordSet gridauthuser = du.dSearchBrdAuthUser(requestData, onlineCtx).getRecordSet("ds"); //
			responseData.putRecordSet("gridauthuser", gridauthuser);
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
	 * [FM]게시판권한관리 - 사용자조회(팝업용)
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-01-05 13:48:16
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchDeptUser(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		Log log = getLog(onlineCtx);

		if ( log.isDebugEnabled() ) {
			log.debug("<<사용자조회(팝업용)>> 입력파라미터 : " + requestData.getFieldMap());
			log.debug("<<사용자조회(팝업용)>> RecordSetCount : " + requestData.getRecordSetCount());
		}

	    try {
	    	DBLTNBRDAUTHMGMT001 du = (DBLTNBRDAUTHMGMT001) lookupDataUnit(DBLTNBRDAUTHMGMT001.class);

	    	IRecordSet rsUserList = requestData.getRecordSet("EXCLUDE_USER_LIST");
	    	int cntUserList = null==rsUserList ? 0 : rsUserList.getRecordCount();

	    	if (cntUserList>0) {
	    		String[] userids = new String[cntUserList];
	    		for(int i=0; i<cntUserList; i++) {
	    			userids[i] = rsUserList.get(i, "USER_ID");
	    			log.info("<<사용자조회(팝업용)>> 제외할 사용자ID 목록 : " + userids[i]);
	    		}
	    		requestData.putField("EXCLUDE_USER_ID", userids);
	    	}

	    	UserInfo userInfo = (UserInfo)onlineCtx.getUserInfo();
	    	requestData.putField("HDQT_TEAM_ORG_ID", userInfo.get("HDQT_TEAM_ORG_ID")); //로그인사용자의 '본사팀ID' 조건 추가

			if (log.isDebugEnabled()) {
				log.debug("<<사용자조회(팝업용)>> 최종조회파라미터 : " + requestData.getFieldMap());
			}

	    	//게시판권한 사용자 조회
	    	IRecordSet griduser = du.dSearchDeptUser(requestData, onlineCtx).getRecordSet("ds"); //
			responseData.putRecordSet("griduser", griduser);
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
	 * [FM]게시판권한저장
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-31 10:32:51
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSaveBrdAuth(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		Log log = getLog(onlineCtx);

		if ( log.isDebugEnabled() ) {
			log.debug("<<게시판권한저장>> 입력파라미터 : " + requestData.getFieldMap());
		}

	    try {
	    	DBLTNBRDAUTHMGMT002 du2 = (DBLTNBRDAUTHMGMT002) lookupDataUnit(DBLTNBRDAUTHMGMT002.class);

	    	IDataSet dsParam = new DataSet();
	    	dsParam.putField("BLTN_BRD_ID", requestData.getField("BLTN_BRD_ID")); //게시판ID

	    	IRecordSet gridauthgrp = requestData.getRecordSet("gridauthgrp"); //(화면에서 전달된) 권한그룹 정보 목록
	    	int lenauthgrp = null==gridauthgrp ? 0 : gridauthgrp.getRecordCount();

	    	//1. 권한그룹 변경
	    	for(int i=0; i<lenauthgrp; i++) {
	    		Map<String,Object> authgrp = gridauthgrp.getRecordMap(i);
	    		
	    		dsParam.putFieldMap(authgrp);

	    		String authTypeCd = "R"; //디폴트 읽기권한
	    		if ( StringUtils.equals("Y", (String)authgrp.get("E_AUTH")) ) {
	    			authTypeCd = "E"; //삭제
	    		}
	    		else if ( StringUtils.equals("Y", (String)authgrp.get("W_AUTH")) ) {
	    			authTypeCd = "W"; //쓰기
	    		}
	    		dsParam.putField("AUTH_TYP_CD", authTypeCd);
	    		log.info("<<게시판권한저장>> 권한그룹 정보 : " + dsParam.getFieldMap());

	    		if ( StringUtils.equals("I", (String)authgrp.get("FLAG")) ) {
	    			du2.dInsertBrdAuth(dsParam, onlineCtx);
	    		}
	    		else if ( StringUtils.equals("D", (String)authgrp.get("FLAG")) ) {
	    			du2.dDeleteBrdAuth(dsParam, onlineCtx);
	    		}
	    		else {
	    			du2.dUpdateBrdAuth(dsParam, onlineCtx);
	    		}
	    	}

	    	IRecordSet gridauthorg = requestData.getRecordSet("gridauthorg"); //(화면에서 전달된) 영업국 정보 목록
	    	int lenauthorg = null==gridauthorg ? 0 : gridauthorg.getRecordCount();

	    	//2. 영업국 변경
	    	for(int i=0; i<lenauthorg; i++) {
	    		Map<String,Object> authorg = gridauthorg.getRecordMap(i);

	    		dsParam.putFieldMap(authorg);

	    		du2.dDeleteBrdAuthOrg(dsParam, onlineCtx);
	    		log.info("<<게시판권한저장>> 영업국 정보 : " + dsParam.getFieldMap());

	    		if ( StringUtils.equals("I", (String)authorg.get("FLAG")) ) {
	    			du2.dInsertBrdAuthOrg(dsParam, onlineCtx);
	    		}
	    		else if ( StringUtils.equals("D", (String)authorg.get("FLAG")) ) {
	    			du2.dDeleteBrdAuthOrg(dsParam, onlineCtx);
	    		}
	    		/*if ( StringUtils.equals("Y", (String)authorg.get("AUTH_YN")) ) {
	    			du2.dInsertBrdAuthOrg(dsParam, onlineCtx);
	    		}*/
	    	}

	    	IRecordSet gridauthuser = requestData.getRecordSet("gridauthuser"); //(화면에서 전달된) 적용회원 목록
	    	int lenauthuser = null==gridauthuser ? 0 : gridauthuser.getRecordCount();

	    	//3. 적용회원 변경
	    	for(int i=0; i<lenauthuser; i++) {
	    		Map<String,Object> authuser = gridauthuser.getRecordMap(i);

	    		dsParam.putFieldMap(authuser);

	    		log.info("<<게시판권한저장>> 적용회원 정보 : " + dsParam.getFieldMap());

	    		if ( StringUtils.equals("I", (String)authuser.get("FLAG")) ) {
	    			du2.dInsertBrdAuthUser(dsParam, onlineCtx);
	    		}
	    		else if ( StringUtils.equals("D", (String)authuser.get("FLAG")) ) {
	    			du2.dDeleteBrdAuthUser(dsParam, onlineCtx);
	    		}
	    	}
			//DBLTNBRDAUTHMGMT001 du = (DBLTNBRDAUTHMGMT001) lookupDataUnit(DBLTNBRDAUTHMGMT001.class);

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
	 * [FM]게시판권한복사
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-03-23 11:21:49
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fCopyBrdAuth(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		Log log = getLog(onlineCtx);

		if ( log.isDebugEnabled() ) {
			log.debug("<<게시판권한복사>> 입력파라미터 : " + requestData.getFieldMap());
		}

	    try {
	    	DBLTNBRDAUTHMGMT002 du2 = (DBLTNBRDAUTHMGMT002) lookupDataUnit(DBLTNBRDAUTHMGMT002.class);

	    	IDataSet dsParam = new DataSet();
	    	dsParam.putField("BLTN_BRD_ID", requestData.getField("BLTN_BRD_ID")); //게시판ID

	    	//1. 해당 게시판의 권한그룹, 권한조직, 권한사용자 정보 삭제 
	    	du2.dDeleteBrdAuth(requestData, onlineCtx);
	    	//du2.dDeleteBrdAuthOrg(requestData, onlineCtx);
	    	//du2.dDeleteBrdAuthUser(requestData, onlineCtx);

	    	//2. 해당 게시판의 권한그룹, 권한조직, 권한사용자 정보를 복사하여 저장 
	    	du2.dInsertCopiedBrdAuth(requestData, onlineCtx);
	    	//du2.dInsertCopiedBrdAuthOrg(requestData, onlineCtx);
	    	//du2.dDeleteBrdAuthUser(requestData, onlineCtx);

	    	//재조회함
	    	DBLTNBRDAUTHMGMT001 du = (DBLTNBRDAUTHMGMT001) lookupDataUnit(DBLTNBRDAUTHMGMT001.class);

	    	//1. 권한그룹
	    	IRecordSet gridauthgrp = du.dSearchBrdAuthGrp(requestData, onlineCtx).getRecordSet("ds"); //
			responseData.putRecordSet("gridauthgrp", gridauthgrp);

	    	//2. 영업국
	    	//IRecordSet gridauthorg = du.dSearchBrdAuthOrg(requestData, onlineCtx).getRecordSet("ds"); //
			//responseData.putRecordSet("gridauthorg", gridauthorg);

	    	//3. 적용 회원
	    	//IRecordSet gridauthuser = du.dSearchBrdAuthUser(requestData, onlineCtx).getRecordSet("ds"); //
			//responseData.putRecordSet("gridauthuser", gridauthuser);

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
