package com.psnm.dtok.com.userinfo.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecord;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.data.RecordHeader;
import nexcore.framework.core.data.RecordSet;
import nexcore.framework.core.exception.BizRuntimeException;
import nexcore.framework.core.util.DateUtils;
//import nexcore.framework.core.util.StringUtils;


import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;

import com.psnm.common.util.SHA256SaltHash;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: FUSERSCRBREQ001</li>
 * <li>설  명 : 회원정보관리 FU</li>
 * <li>작성일 : 2014-12-03 18:01:55</li>
 * <li>작성자 : 한상곤 (hansanggon)</li>
 * </ul>
 *
 * @author 한상곤 (hansanggon)
 */
public class FUSERSCRBREQ001 extends nexcore.framework.coreext.pojo.biz.FunctionUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public FUSERSCRBREQ001(){
		super();
	}

	/**
	 * 에이전트 조회[팝업] FM
	 *
	 * @author 한상곤 (hansanggon)
	 * @since 2014-12-03 18:04:21
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchAgnt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();

	    Log log = getLog(onlineCtx);
		if (log.isDebugEnabled()) {
			log.debug("<에이전트찾기> 입력데이터 : " + requestData.getFieldMap());
		}

	    try {
			DUSERSCRBREQ001 du = (DUSERSCRBREQ001)lookupDataUnit(DUSERSCRBREQ001.class);

	    	String findtype = requestData.getField("FINDTYPE"); //DEFAULT || ALL

	    	if ( StringUtils.isBlank(findtype) || !StringUtils.equalsIgnoreCase(findtype, "all") ) {
	    		requestData.putField("FINDTYPE", "DEFAULT"); //디폴트 //@since 2015-03-04
	    	}

			responseData = du.dSearchAgntCnt(requestData, onlineCtx);
			IRecordSet rs0 = responseData.getRecordSet("ds");
			int totalCount = rs0.getRecord(0).getInt("TOTAL_COUNT");

			log.debug("<에이전트찾기> 검색조건의 전체건수 = " + totalCount);

			responseData = du.dSearchAgnt(requestData, onlineCtx);
			responseData.putField("count", totalCount);

			responseData.getRecordSet("gridagnt").setTotalRecordCount(totalCount); //전체건수 설정
			responseData.getRecordSet("gridagnt").setPageNo(requestData.getIntField("page")); // page는 클라이언트에서 넘기는 것을 그대로 리턴하면 됩니다.
			responseData.getRecordSet("gridagnt").setRecordCountPerPage(requestData.getIntField("page_size"));

			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2014-12-03 18:01:55
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchUserScrbReq(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    Log log = getLog(onlineCtx);

	    try {
			DUSERSCRBREQ001 du = (DUSERSCRBREQ001)lookupDataUnit(DUSERSCRBREQ001.class);

			responseData = du.dSearchUserScrbReq(requestData, onlineCtx);
			
			IRecordSet rs = responseData.getRecordSet("grid");
			int totalCount = 0;
			if( rs.getRecordCount() != 0 ){
				totalCount = rs.getRecord(0).getInt("COUNT");
			}
			rs.setTotalRecordCount( totalCount );
			rs.setPageNo(requestData.getIntField("page"));
			rs.setRecordCountPerPage(requestData.getIntField("page_size"));
			
			responseData.putField("APPR_CNT", du.dSearchUserScrbApprCnt(requestData, onlineCtx).getField("CNT"));			
			responseData.putField("REQ_CNT", du.dSearchUserScrbReqCnt(requestData, onlineCtx).getField("CNT"));	
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2014-12-03 18:01:55
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchUserScrbReqDtl(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
		
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    Log log = getLog(onlineCtx);

	    try {
			DUSERSCRBREQ001 du = (DUSERSCRBREQ001)lookupDataUnit(DUSERSCRBREQ001.class);
            
			responseData.putFieldMap( du.dSearchUserScrbReqDtl(requestData, onlineCtx).getFieldMap() );
			responseData.putRecordSet( "userAuthGrp", du.dSearchUserAuthGrp(requestData, onlineCtx).getRecordSet("rs") );
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2014-12-03 18:01:55
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fUpdateUserScrbReq(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    Log log = getLog(onlineCtx);

		DUSERSCRBREQ001 du = (DUSERSCRBREQ001)lookupDataUnit(DUSERSCRBREQ001.class);

		responseData = du.dUpdateUserScrbReq(requestData, onlineCtx);
	    
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2014-12-03 18:01:55
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fApprUserScrbReq(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    /*
	    String SCRB_ST_CD = requestData.getField("SCRB_ST_CD");
	    
	    if( SCRB_ST_CD.equals("01") ){
	    	SCRB_ST_CD = "02"; //가입승인으로 변경
	    }
	    */
	    
	    //회원가입요청상태 승인으로 변경 
	    this.fUpdateUserScrbReq( requestData, onlineCtx);
	    
	    DUSERSCRBREQ001 du = (DUSERSCRBREQ001)lookupDataUnit(DUSERSCRBREQ001.class);
	    
	    //회원테이블에 저장 (TBAS_USER_MGMT)
	    du.dInsertUserInfo1(requestData, onlineCtx);
	    
	    //회원테이블에 저장 (DSM_USER)
	    du.dInsertUserInfo2(requestData, onlineCtx);
	    
	    //가입상태변경이력 저장 (DSM_USER_SCRB_ST_CHG_HST INSERT)
	    du.dInsertUserInfoHst(requestData, onlineCtx);
	    
	    //FAX번호 변경체크 및 업데이트	    
	    this.fSaveChangedFaxNo(requestData, onlineCtx);	     

	    //MA지원서 계약상태 변경
	    du.dUpdateMACntrtState(requestData, onlineCtx);
	    
	    //비밀번호 변경이력
	    du.dInsertPwdChgHst(requestData, onlineCtx);
	    
	    //SMS 발송
	    responseData.putField("TRAN_MENU_ID", "2200"); 
	    responseData.putField("TRAN_TYP_CD", "01");
	    responseData.putField("TRAN_SYS", "BO");
	    
	    IRecordSet rs = new RecordSet("ds");
	    rs.addHeader(new RecordHeader("RCV_PHN_ID"));
	    rs.addHeader(new RecordHeader("ABSN_CHECK_YN"));
	    rs.addHeader(new RecordHeader("{0}"));
	    rs.addHeader(new RecordHeader("{1}"));
	    
	    IRecord record = rs.newRecord(0);
	    
	    record.set("RCV_PHN_ID", requestData.getField("MBL_PHON_NUM1") + requestData.getField("MBL_PHON_NUM2") + requestData.getField("MBL_PHON_NUM3"));
	    record.set("ABSN_CHECK_YN", "N");
	    record.set("{0}", requestData.getField("USER_NM"));
	    record.set("{1}", requestData.getField("USER_ID"));
	    
	    
	    
	    responseData.putRecordSet(rs);

	    callSharedBizComponentByDirect("com.SHARE", "fSendSms", responseData, onlineCtx);
	    
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2014-12-24 09:38:45
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fRetrunUserScrbReq(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    
	    //회원가입요청상태 반려로 변경 
	    this.fUpdateUserScrbReq( requestData, onlineCtx);
	    
	    //SMS 발송
	    responseData.putField("TRAN_MENU_ID", "2200"); 
	    responseData.putField("TRAN_TYP_CD", "02");
	    responseData.putField("TRAN_SYS", "BO");
	    
	    IRecordSet rs = new RecordSet("ds");
	    rs.addHeader(new RecordHeader("RCV_PHN_ID"));
	    rs.addHeader(new RecordHeader("ABSN_CHECK_YN"));
	    rs.addHeader(new RecordHeader("{0}"));
	    rs.addHeader(new RecordHeader("{1}"));
	    rs.addHeader(new RecordHeader("{2}"));
	    
	    IRecord record = rs.newRecord(0);
	    record.set("RCV_PHN_ID", requestData.getField("MBL_PHON_NUM1") + requestData.getField("MBL_PHON_NUM2") + requestData.getField("MBL_PHON_NUM3"));
	    record.set("ABSN_CHECK_YN", "N");
	    record.set("{0}", requestData.getField("USER_NM"));
	    record.set("{1}", requestData.getField("USER_ID"));
	    record.set("{2}", requestData.getField("SCRB_ST_CHG_RSN"));
	    
	    responseData.putRecordSet(rs);

	    callSharedBizComponentByDirect("com.SHARE", "fSendSms", responseData, onlineCtx);
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-01-01 10:51:40
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchNickNmChk(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    DUSERSCRBREQ001 du = (DUSERSCRBREQ001)lookupDataUnit(DUSERSCRBREQ001.class);
	    responseData.putField("dupCnt", du.dSearchNickNmChk(requestData, onlineCtx).getField("CNT"));
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-01-01 14:11:59
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchFaxNumChk(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    DUSERSCRBREQ001 du = (DUSERSCRBREQ001)lookupDataUnit(DUSERSCRBREQ001.class);
	    responseData.putField("dupCnt", du.dSearchFaxNumChk(requestData, onlineCtx).getField("CNT"));
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2014-12-03 18:01:55
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchAddr(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    DUSERSCRBREQ001 du = (DUSERSCRBREQ001)lookupDataUnit(DUSERSCRBREQ001.class);
	    responseData = du.dSearchAddr(requestData, onlineCtx);
	    
		IRecordSet rs = responseData.getRecordSet("gridAddress");
		int totalCount = 0;
		if( rs.getRecordCount() != 0 ){
			totalCount = rs.getRecord(0).getInt("COUNT");
		}
		rs.setTotalRecordCount( totalCount );
		rs.setPageNo(requestData.getIntField("page"));
		rs.setRecordCountPerPage(requestData.getIntField("page_size"));
		
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2014-12-03 18:01:55
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fInsertUserScrbReq(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    
	    DUSERSCRBREQ001 du = (DUSERSCRBREQ001)lookupDataUnit(DUSERSCRBREQ001.class);
	    requestData.putField("AGNT_ID", requestData.getField("SALE_AGNT_ORG_ID"));
	    //회원가입여부 체크
	    int count = du.dSearchMemberChk(requestData, onlineCtx).getIntField("COUNT");
	    if( count>0 ){
	    	throw new BizRuntimeException("PSNM-E006");
	    }
	    //사용자 아이디 중복체크
	    count = du.dSearchUserIDChk(requestData, onlineCtx).getIntField("COUNT");	    
	    if( count>0 ){
	    	throw new BizRuntimeException("PSNM-E004");
	    }
	    //계약상태코드 체크 ( 상태코드가 5인 경우만 가입 가능 )
	    IRecordSet rs = du.dSearchCntrtStCd(requestData, onlineCtx).getRecordSet("state");
	    if( rs.getRecordCount() == 0 ){
	    	throw new BizRuntimeException("PSNM-E005");
	    }else if( !"5".equals( rs.get(0, "CNTRT_ST_CD") ) ){
	    	throw new BizRuntimeException("PSNM-E005");
	    }
	   
	    requestData.putField("POST_NUM", requestData.getField("POST_NUM1")+"-"+requestData.getField("POST_NUM2"));
	    
		requestData.putField("USER_CL_CD", "4");
		requestData.putField("SCRB_ST_CD", "01");

		requestData.putField("SCRT_NUM", SHA256SaltHash.encode( requestData.getField("SCRT_NUM")
																, requestData.getField("USER_ID").getBytes()));		

	    // 가입요청테이블에 저장
	    du.dInsertUserScrbReq(requestData, onlineCtx);
	    // 가입이력테이블에 저장
	    du.dInsertUserInfoHst(requestData, onlineCtx);
	    
		//사진첨부
		if( StringUtils.isNotEmpty(requestData.getField("FILE_NM")) ){ //파일이름이 있는것만 사진파일이 변경된것으로 본다.
			requestData.putField("ATCH_MGMT_ID", requestData.getField("USER_ID"));
			callSharedBizComponentByDirect("com.SHARE", "fSavePictuerFile", requestData, onlineCtx);
		}
		
	    // 영업국 담당자에게 sms 전송
	    responseData = du.dSearchSmsRecordSet(requestData, onlineCtx);
	    responseData.putField("TRAN_MENU_ID", "0000"); 
	    responseData.putField("TRAN_TYP_CD", "04");
	    responseData.putField("TRAN_SYS", "BO");
	    
	    callSharedBizComponentByDirect("com.SHARE", "fSendSms", responseData, onlineCtx);
	    
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-01-13 13:22:50
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchEmailChk(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    DUSERSCRBREQ001 du = (DUSERSCRBREQ001)lookupDataUnit(DUSERSCRBREQ001.class);
	    responseData.putField("dupCnt", du.dSearchEmailChk(requestData, onlineCtx).getField("CNT"));
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-02-24 10:25:25
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchSmember(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

	    Log log = getLog(onlineCtx);
		if (log.isDebugEnabled()) {
			log.debug("<임직원 찾기> 입력데이터 : " + requestData.getFieldMap());
		}

	    try {
			DUSERSCRBREQ001 du = (DUSERSCRBREQ001)lookupDataUnit(DUSERSCRBREQ001.class);
			
			responseData = du.dSearchSmemberCnt(requestData, onlineCtx);
			
			IRecordSet rs0 = responseData.getRecordSet("ds");
			int totalCount = rs0.getRecord(0).getInt("TOTAL_COUNT");
		
			log.debug("<임직원 찾기> 검색조건의 전체건수 = " + totalCount);
			
			responseData = du.dSearchSmember(requestData, onlineCtx);

			responseData.putField("count", totalCount);

			responseData.getRecordSet("gridsmember").setTotalRecordCount(totalCount); //전체건수 설정
			responseData.getRecordSet("gridsmember").setPageNo(requestData.getIntField("page")); // page는 클라이언트에서 넘기는 것을 그대로 리턴하면 됩니다.
			responseData.getRecordSet("gridsmember").setRecordCountPerPage(requestData.getIntField("page_size"));

			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-02-24 16:07:56
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSaveChangedFaxNo(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요
	    DUSERSCRBREQ001 du = (DUSERSCRBREQ001)lookupDataUnit(DUSERSCRBREQ001.class);
	    if( StringUtils.isNotEmpty( requestData.getField("AGNT_ID") ) ){
	     	du.dSaveChangedFaxNo(requestData, onlineCtx);
	    }	
	    return responseData;
	}
}
