package com.psnm.dtok.com.usermgmt.biz;

import com.psnm.common.util.SHA256SaltHash;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.data.RecordSet;
import nexcore.framework.core.exception.BizRuntimeException;
import nexcore.framework.core.util.StringUtils;



/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: FUSERMGMT001</li>
 * <li>설  명 : </li>
 * <li>작성일 : 2015-01-15 09:30:20</li>
 * <li>작성자 : 안진갑 (ahnjingap)</li>
 * </ul>
 *
 * @author 안진갑 (ahnjingap)
 */
public class FUSERMGMT001 extends nexcore.framework.coreext.pojo.biz.FunctionUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public FUSERMGMT001(){
		super();
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-01-15 09:32:00
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchUser(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
		DUSERMGMT001 du = (DUSERMGMT001)lookupDataUnit(DUSERMGMT001.class);

		responseData = du.dSearchUser(requestData, onlineCtx);
		
		IRecordSet rs = responseData.getRecordSet("gridUser");
		int totalCount = 0;
		if( rs.getRecordCount() != 0 ){
			totalCount = rs.getRecord(0).getInt("COUNT");
		}
		rs.setTotalRecordCount( totalCount );
		rs.setPageNo(requestData.getIntField("page"));
		rs.setRecordCountPerPage(requestData.getIntField("page_size"));
		
		responseData.putField("APPR_CNT", du.dSearchUserApprCnt(requestData, onlineCtx).getField("CNT"));			
		responseData.putField("BAN_CNT", du.dSearchUserBanCnt(requestData, onlineCtx).getField("CNT"));
			
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-01-16 11:35:49
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchUserDtl(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    DUSERMGMT001 du = (DUSERMGMT001)lookupDataUnit(DUSERMGMT001.class);

	    String USER_ID = StringUtils.nvlEmpty( requestData.getField("USER_ID"), onlineCtx.getUserInfo().getLoginId());
	    requestData.putField("USER_ID", USER_ID);
	    responseData = du.dSearchUserDtl(requestData, onlineCtx);
	    
	    // 권한그룹조회
	    responseData.putRecordSet( "userAuthGrp", du.dSearchUserAuthGrp(requestData, onlineCtx).getRecordSet("rs") );
	    
    	//첨부파일 조회
		requestData.putField("ATCH_MGMT_ID", USER_ID);
		requestData.putField("FILE_GRP_ID", "USR");
		IDataSet fileDataset = callSharedBizComponentByDirect("com.SHARE", "fSearchFileMapping", requestData, onlineCtx);
		responseData.putRecordSet("gridfile", fileDataset.getRecordSet("ds"));
	    
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-01-15 09:30:20
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fUpdateUser(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    //회원정보저장
	    DUSERMGMT001 du = (DUSERMGMT001)lookupDataUnit(DUSERMGMT001.class);
	    if( StringUtils.isNotEmpty( requestData.getField("POST_NUM1")) && StringUtils.isNotEmpty( requestData.getField("POST_NUM2")) )
	    {
	    	requestData.putField( "POST_NUM", requestData.getField("POST_NUM1") + "-" + requestData.getField("POST_NUM2") );
	    }
	    responseData = du.dUpdateUser(requestData, onlineCtx);	   	 
	    	    
		//사진첨부
		if( StringUtils.isNotEmpty(requestData.getField("FILE_NM")) ){ //파일이름이 있는것만 사진파일이 변경된것으로 본다.
			IDataSet paramData = new DataSet();
			if( StringUtils.isNotEmpty(requestData.getField("BEFORE_ATCH_FILE_ID")) ){
				paramData.putField("ATCH_FILE_ID", requestData.getField("BEFORE_ATCH_FILE_ID"));
				requestData.putField("FILE_GRP_ID", "PIC");
			    callSharedBizComponentByDirect("com.SHARE", "fDeleteFileByFileId", paramData, onlineCtx);
			}
			callSharedBizComponentByDirect("com.SHARE", "fSavePictuerFile", requestData, onlineCtx);
		}
		
		requestData.removeField("ATCH_FILE_ID");
		requestData.removeField("FILE_NM");
		requestData.removeField("FILE_PATH");
		requestData.removeField("FILE_SIZE");
	    //파일첨부
		if( requestData.getRecordSet("gridfile") != null ){
			requestData.putField("ATCH_MGMT_ID", requestData.getField("USER_ID"));
			requestData.putField("FILE_GRP_ID", "USR");
			callSharedBizComponentByDirect("com.SHARE", "fSaveFileList", requestData, onlineCtx);
		}
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-01-20 19:44:53
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchActvCareer(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
		DUSERMGMT001 du = (DUSERMGMT001)lookupDataUnit(DUSERMGMT001.class);
		responseData = du.dSearchActvCareer(requestData, onlineCtx);
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-01-21 10:41:32
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchMbrStHst(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
		DUSERMGMT001 du = (DUSERMGMT001)lookupDataUnit(DUSERMGMT001.class);
		responseData = du.dSearchMbrStHst(requestData, onlineCtx);
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-01-21 11:01:59
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchEduHst(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
		DUSERMGMT001 du = (DUSERMGMT001)lookupDataUnit(DUSERMGMT001.class);
		responseData = du.dSearchEduHst(requestData, onlineCtx);
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-01-21 11:40:23
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchFtftHst(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
		DUSERMGMT001 du = (DUSERMGMT001)lookupDataUnit(DUSERMGMT001.class);
		responseData = du.dSearchFtftHst(requestData, onlineCtx);
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-01-15 09:30:20
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchCareerMtrCntrt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
		DUSERMGMT001 du = (DUSERMGMT001)lookupDataUnit(DUSERMGMT001.class);
		responseData = du.dSearchCareerMtrCntrt(requestData, onlineCtx);
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-01-22 14:15:02
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fInitPassword(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    DUSERMGMT001 du = (DUSERMGMT001)lookupDataUnit(DUSERMGMT001.class);
	    
	    String userId = requestData.getField("USER_ID");
	    requestData.putField("PWD", SHA256SaltHash.encode( userId, userId.getBytes()));
	    responseData = du.dUpdatePassword(requestData, onlineCtx);
	    //비밀번호 이력변경 등록
	    responseData = du.dInsertPwdChgHst(requestData, onlineCtx);
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-01-22 16:20:10
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSaveTempAccessOrDeny(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    DUSERMGMT001 du = (DUSERMGMT001)lookupDataUnit(DUSERMGMT001.class);
	    du.dInsertUserInfoHst(requestData, onlineCtx); //회원가입이력 저장
	    du.dUpdateUser(requestData, onlineCtx);
	    du.dUpdateUserScrbReqSt(requestData, onlineCtx);
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-01-15 09:30:20
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchCertMember(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    DUSERMGMT001 du = (DUSERMGMT001)lookupDataUnit(DUSERMGMT001.class);
	    String portalUserId = onlineCtx.getUserInfo().get("PORTAL_USER_ID").toString();
	    if( StringUtils.isEmpty(portalUserId) ){
	    	portalUserId = onlineCtx.getUserInfo().getLoginId();
	    }
	    requestData.putField( "USER_ID", onlineCtx.getUserInfo().getLoginId());
	    requestData.putField( "PWD", SHA256SaltHash.encode(requestData.getField("PWD"), portalUserId) );
	    responseData = du.dSearchCertPwd(requestData, onlineCtx);
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-01-26 11:00:48
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fUpdatePassword(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    DUSERMGMT001 du = (DUSERMGMT001)lookupDataUnit(DUSERMGMT001.class);
	    //기존 패스워드 검증
	    String userId = onlineCtx.getUserInfo().getLoginId();
	    String pwd    = requestData.getField("PWD");
	    requestData.putField( "USER_ID", userId);	   
	    requestData.putField( "PWD", SHA256SaltHash.encode(requestData.getField("OLD_PWD"), userId) );
	    responseData = du.dSearchCertPwd(requestData, onlineCtx);
	    if( responseData.getIntField("CNT") == 0 ){
	    	throw new BizRuntimeException("PSNM-E007");
	    }
	   
	    // 신규 패스워드 수정
	    requestData.putField( "PWD", SHA256SaltHash.encode(pwd, userId) );
	    
	    //최근비밀번호 체크
	    responseData = du.dSearchIsRecentPassword(requestData, onlineCtx);
	    if( responseData.getIntField("CNT") > 0 ){
	    	throw new BizRuntimeException("PSNM-E024");
	    }
	   
	    responseData = du.dUpdatePassword(requestData, onlineCtx);
	    
	    //비밀번호 변경이력 등록
	    responseData = du.dInsertPwdChgHst(requestData, onlineCtx);
	    
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-01-26 14:32:50
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchNonRealBizUser(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
		DUSERMGMT001 du = (DUSERMGMT001)lookupDataUnit(DUSERMGMT001.class);
		responseData = du.dSearchNonRealBizUser(requestData, onlineCtx);
		
		IRecordSet rs = responseData.getRecordSet("gridUser");
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
	 * @since 2015-04-08 12:44:26
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fInsertEmpUser(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    DUSERMGMT001 du = (DUSERMGMT001)lookupDataUnit(DUSERMGMT001.class);
	    requestData.putField("POST_NUM", requestData.getField("POST_NUM1") + requestData.getField("POST_NUM2"));
	    du.dInsertEmpUser(requestData, onlineCtx);
	    
		//사진첨부
		if( StringUtils.isNotEmpty(requestData.getField("FILE_NM")) ){ //파일이름이 있는것만 사진파일이 변경된것으로 본다.
			requestData.putField("ATCH_MGMT_ID", requestData.getField("USER_ID"));
			callSharedBizComponentByDirect("com.SHARE", "fSavePictuerFile", requestData, onlineCtx);
		}
	    return responseData;
	}
  
}
